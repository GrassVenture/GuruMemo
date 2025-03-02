import 'package:camera/camera.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/exception.dart';
import '../../../core/image_helper.dart';
import '../../../core/logger.dart';
import '../../auth/auth_controller.dart';
import '../local_photo_manager_service.dart';
import '../remote_photo_repository.dart';

part 'camera_controller.g.dart';

/// カメラコントローラ用のプロバイダー
@riverpod
Future<Raw<CameraController>> cameraController(Ref ref) async {
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
}

/// ローカルストレージ最新１枚の写真を食べ物に分類するProvider
@riverpod
class ClassifyLatestPhotoNotifier extends _$ClassifyLatestPhotoNotifier {
  @override
  Future<AssetEntity?> build() async {
    final permission = await PhotoManager.requestPermissionExtend();
    if (!permission.isAuth && !permission.hasAccess) {
      throw PermissionException();
    }

    return null;
  }

  /// 最新の写真を食べ物として分類する
  Future<void> classifyPhotoAsFood() async {
    try {
      await PhotoManager.clearFileCache();
      await PhotoManager.getAssetPathList();

      final latestPhoto =
          await ref.read(localPhotoManagerServiceProvider).getLatestPhoto();
      if (latestPhoto == null) {
        logger.w('No latest photo found.');
        return;
      }

      final modifiedPhotoId = latestPhoto.id.replaceAll('/', '-');

      final userId = ref.read(userIdProvider);
      if (userId == null) {
        throw Exception('User not signed in');
      }

      final position = await _getCurrentPosition();
      final latitude = position?.latitude;
      final longitude = position?.longitude;

      if (latitude != null && longitude != null) {
        await ref.read(photoRepositoryProvider).registerStoreInfo(
              photoId: modifiedPhotoId,
              userId: userId,
              latitude: latitude,
              longitude: longitude,
            );
      }

      final photoFile = await latestPhoto.file;
      if (photoFile != null) {
        final compressedData = await ImageHelper.compress(photoFile);
        if (compressedData != null) {
          await ref.read(photoRepositoryProvider).categorizeFood(
                userId: userId,
                photoId: modifiedPhotoId,
                photoData: compressedData,
              );
          logger.i('圧縮写真データをサーバーに送信しました: $modifiedPhotoId');
        }
      }
    } on Exception catch (e, stacktrace) {
      logger.e('写真の登録中にエラーが発生しました: $e\n$stacktrace');
    }
  }

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
}
