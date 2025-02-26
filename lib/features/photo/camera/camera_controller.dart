import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/date_utils.dart';
import '../../../core/exception.dart';
import '../../../core/logger.dart';
import '../../auth/auth_controller.dart';
import '../local_photo_manager_service.dart';
import '../remote_photo_repository.dart';
import 'camera_state.dart';

class CameraStateNotifier extends StateNotifier<CameraState> {
  CameraStateNotifier(this.ref) : super(const CameraState());

  final Ref ref;

  Future<bool> takePicture(BuildContext context) async {
    state = state.copyWith(isTakingPicture: true); // 撮影中フラグをセット

    final position = await _getCurrentPosition();
    final latitude = position?.latitude;
    final longitude = position?.longitude;

    try {
      final controller = await ref.read(cameraControllerProvider.future);
      final image = await controller.takePicture();
      // 権限のリクエストをまとめて行う
      // if (!(await _ensurePermissions())) {
      //   return false;
      // }
      // 状態更新
      state = state.copyWith(
        capturedImage: File(image.path),
        latitude: latitude,
        longitude: longitude,
      );
    } on Exception catch (e) {
      logger.e('写真撮影エラー: $e');
      return false;
    } finally {
      state = state.copyWith(isTakingPicture: false); // 撮影中フラグを解除
    }
    return true;
  }

  Future<bool> takePictureAndSave(BuildContext context) async {
    state = state.copyWith(isTakingPicture: true); // 撮影中フラグをセット

    try {
      final controller = await ref.read(cameraControllerProvider.future);
      final image = await controller.takePicture();
      // 権限のリクエストをまとめて行う
      if (!(await _ensurePermissions())) {
        return false;
      }

      // 画像をギャラリーに保存
      final result = await ImageGallerySaverPlus.saveFile(image.path);
      logger.i('ギャラリーに画像を保存しました: $result');

      // 状態更新
      state = state.copyWith(
        capturedImage: File(image.path),
        imageDate: FormatDateTime.dateFmt.format(DateTime.now()),
      );
    } on Exception catch (e) {
      logger.e('写真撮影エラー: $e');
      return false;
    } finally {
      state = state.copyWith(isTakingPicture: false); // 撮影中フラグを解除
    }
    return true;
  }

  // 位置情報の取得
  Future<Position?> _getCurrentPosition() async {
    try {
      const locationSettings = LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 100,
      );

      final position = await Geolocator.getCurrentPosition(
        locationSettings: locationSettings,
      );

      return position;
    } on Exception catch (e) {
      logger.e('位置情報の取得に失敗しました: $e');
      return null;
    }
  }

  // 権限の確認とリクエスト
  Future<bool> _ensurePermissions() async {
    // 位置情報の権限をチェック
    var locationPermission = await Geolocator.checkPermission();
    if (locationPermission == LocationPermission.denied ||
        locationPermission == LocationPermission.deniedForever) {
      locationPermission = await Geolocator.requestPermission();
      if (locationPermission == LocationPermission.denied ||
          locationPermission == LocationPermission.deniedForever) {
        return false;
      }
    }

    final cameraStatus = await Permission.camera.status;
    final storageStatus = await Permission.storage.status;
    final photosStatus = await Permission.photos.status;
    final microphoneStatus = await Permission.microphone.status;

    if (photosStatus.isLimited || storageStatus.isLimited) {
      logger.i('_ensurePermissions: 写真またはストレージのアクセスが制限されています');
      return false;
    }

    if (!storageStatus.isGranted ||
        !cameraStatus.isGranted ||
        !photosStatus.isGranted ||
        !microphoneStatus.isGranted) {
      logger.i('_ensurePermissions: 権限が不足しているためリクエストします');
      final statuses = await [
        Permission.camera,
        Permission.storage,
        Permission.photos,
        Permission.microphone,
      ].request();

      if (statuses[Permission.camera]!.isPermanentlyDenied ||
          statuses[Permission.storage]!.isPermanentlyDenied ||
          statuses[Permission.photos]!.isPermanentlyDenied ||
          statuses[Permission.location]!.isPermanentlyDenied ||
          statuses[Permission.microphone]!.isPermanentlyDenied ||
          locationPermission == LocationPermission.deniedForever) {
        // TODO(sho): このままだと、権限が足りてなくても通ってしまうので、あとでここはfalseに戻す
        // return false;
        return true;
      }

      if (statuses[Permission.camera]!.isGranted &&
          statuses[Permission.storage]!.isGranted &&
          statuses[Permission.photos]!.isGranted &&
          statuses[Permission.location]!.isGranted &&
          statuses[Permission.microphone]!.isGranted) {
        logger.i('_ensurePermissions: すべての権限が許可されました');
        return true;
      } else {
        logger.i('_ensurePermissions: 権限が不足しています');
        return false;
      }
    } else {
      logger.i('_ensurePermissions: すべての権限がすでに許可されています');
      return true;
    }
  }
}

// カメラコントローラ用のプロバイダー
final AutoDisposeFutureProvider<CameraController> cameraControllerProvider =
    FutureProvider.autoDispose<CameraController>((ref) async {
  final cameras = await availableCameras();

  if (cameras.isEmpty) {
    throw CameraException('NoCameraAvailable', '''
利用可能なカメラが見つかりませんでした''');
  }

  final camera = cameras.first;
  final controller = CameraController(
    camera,
    ResolutionPreset.medium,
  );

  ref.onDispose(controller.dispose);

  await controller.initialize();
  return controller;
});

// カメラ状態を管理するためのStateNotifierプロバイダー
final cameraStateProvider =
    StateNotifierProvider<CameraStateNotifier, CameraState>((ref) {
  return CameraStateNotifier(ref);
});

// /// 写真リストを管理するプロバイダー
// final AutoDisposeAsyncNotifierProvider<LatestPhotoNotifier, AssetEntity?>
//     latestPhotoListProvider =
//     AsyncNotifierProvider.autoDispose<LatestPhotoNotifier, AssetEntity?>(
//   LatestPhotoNotifier.new,
// );

/// 写真を取得するProvider
// class LatestPhotoNotifier extends AutoDisposeAsyncNotifier<AssetEntity?> {
//   /// 初期処理
//   @override
//   Future<AssetEntity?> build() async {
//     // パーミッション確認
//     final permission = await PhotoManager.requestPermissionExtend();
//     if (!permission.isAuth && !permission.hasAccess) {
//       throw PermissionException();
//     }
//
//     return null;
//   }
//
//   Future<void> swipeRight({bool isFood = true}) async {
//     await PhotoManager.clearFileCache();
//     await PhotoManager.getAssetPathList();
//     final latestPhoto =
//         await ref.read(localPhotoManagerServiceProvider).getLatestPhoto();
//     state = AsyncValue.data(latestPhoto);
//
//     final value = state.valueOrNull;
//     if (value == null || state.asData == null) {
//       return;
//     }
//
//     if (state.hasError) {
//       return;
//     }
//
//     final photo = state.asData!.value;
//
//     final modifiedPhotoId = photo!.id.replaceAll('/', '-');
//
//     try {
//       final userId = ref.read(userIdProvider);
//
//       if (userId != null) {
//         final position = await _getCurrentPosition();
//         final latitude = position?.latitude;
//         final longitude = position?.longitude;
//
//         if (latitude != null && longitude != null) {
//           await ref.read(photoRepositoryProvider).registerStoreInfo(
//                 photoId: modifiedPhotoId,
//                 userId: userId,
//                 latitude: latitude,
//                 longitude: longitude,
//               );
//           logger.i('写真情報をサーバーに登録しました: $modifiedPhotoId, '
//               '緯度: $latitude, 経度: $longitude');
//         }
//
//         // 写真データの取得と圧縮
//         final photoFile = await photo.file;
//         if (photoFile != null) {
//           final compressedData = await _compressImage(photoFile);
//           if (compressedData != null) {
//             await ref.read(photoRepositoryProvider).categorizeFood(
//                   userId: userId,
//                   photoId: modifiedPhotoId,
//                   photoData: compressedData,
//                 );
//             logger.i('圧縮写真データをサーバーに送信しました: $modifiedPhotoId');
//           }
//         }
//       } else {
//         throw Exception('User not signed in');
//       }
//     } on Exception catch (e, stacktrace) {
//       state = AsyncValue.error(e, stacktrace);
//       logger.e('写真の登録中にエラーが発生しました: $e');
//       return;
//     }
//
//     // 最後の写真までスワイプした場合
//     state = const AsyncValue<AssetEntity?>.loading();
//   }
//
//
//
//   /// 強制リフレッシュ
//   void forceRefresh() {
//     state = const AsyncLoading<AssetEntity?>();
//     ref.invalidateSelf();
//   }
//
//   /// 画像を圧縮するメソッド
//   Future<Uint8List?> _compressImage(File file) async {
//     final result = await FlutterImageCompress.compressWithFile(
//       file.absolute.path,
//       minWidth: 256,
//       minHeight: 256,
//       quality: 85,
//       keepExif: true,
//     );
//     return result;
//   }
// }
