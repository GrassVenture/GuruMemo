import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:exif/exif.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/exception.dart';
import '../../../core/local_database/local_database.dart';
import '../../../core/logger.dart';
import '../../auth/auth_controller.dart';
import '../../auth/authed_user.dart';
import '../local_photo_repository.dart';
import '../remote_photo.dart';
import '../remote_photo_repository.dart';

part 'gallery_controller.g.dart';

// TODO(masaki): g.ファイルにAutoDisposeFutureProviderRefが生成されないように調整
// Flutterバージョンを上げた後、build_runnerを最新にして再生成する等を行う
@riverpod
Future<List<RemotePhoto>> fetchPhotos(Ref ref) async {
  final userId = ref.watch(userIdProvider);
// TODO(masaki): nullの場合ハンドリング検討
  if (userId == null) {
    logger.e('userId is null');
    return [];
  }

  await ref.watch(authedUserStreamProvider.future);
  final authedUserAsync = ref.watch(authedUserStreamProvider).valueOrNull;
  final isReadyForUse =
      authedUserAsync?.classifyPhotosStatus == ClassifyPhotosStatus.readyForUse;
  if (!isReadyForUse) {
    return <RemotePhoto>[];
  }

  final result =
      await ref.read(photoRepositoryProvider).downloadPhotos(userId: userId);

  return result.where((e) => e.url.isNotEmpty).toList();
}

final galleryControllerProvider = Provider<GalleryController>((ref) {
  return GalleryController(ref);
});

class GalleryController {
  GalleryController(this.ref);

  final Ref ref;

  LocalPhotoRepository get _localPhotoRepository =>
      ref.read(localPhotoRepositoryProvider);

  Future<List<LocalPhoto>> getPhotos() async {
    try {
      final photos = await _localPhotoRepository.getAllPhotos();
      return _removeInvalidPhotos(photos);
    } on Exception catch (e) {
      logger.e('Error fetching photos: $e');
      return [];
    }
  }

  Future<List<LocalPhoto>> _removeInvalidPhotos(
    List<LocalPhoto> photos,
  ) async {
    final validPhotos = <LocalPhoto>[];
    for (final photo in photos) {
      final file = await getFileByPhoto(photo);
      if (file.existsSync()) {
        validPhotos.add(photo);
      }
    }
    return validPhotos;
  }

  Future<List<Size>> calculateSizes(List<LocalPhoto> photos) async {
    final sizes = <Size>[];
    for (final photo in photos) {
      if ((photo.width == 0 || photo.height == 0) ||
          (photo.width > photo.height)) {
        sizes.add(const Size(172, 172));
      } else {
        sizes.add(const Size(172, 228));
      }
    }
    return sizes;
  }

  Future<void> printPhotoPaths() async {
    try {
      await _localPhotoRepository.getAllPhotos();
    } on Exception catch (e) {
      logger.e('Error fetching photos: $e');
    }
  }

  Future<File> getFileByPhoto(LocalPhoto photo) async {
    if (Platform.isAndroid) {
      return File(photo.path);
    }

    final asset = await AssetEntity.fromId(photo.id);
    final file = await asset!.file;

    return file!;
  }
}

@riverpod
class ImagePickerVisibility extends _$ImagePickerVisibility {
  @override
  bool build() => false;

  void show() => state = true;

  void hide() => state = false;

  void toggle() => state = !state;
}

@riverpod
class LocalPhotoAssets extends _$LocalPhotoAssets {
  @override
  Future<List<AssetEntity>> build() async {
    return _loadLocalPhotos();
  }

  Future<List<AssetEntity>> _loadLocalPhotos() async {
    final albums = await PhotoManager.getAssetPathList(type: RequestType.image);
    if (albums.isNotEmpty) {
      return albums[0].getAssetListPaged(page: 0, size: 500);
    }
    return [];
  }

  Future<void> reloadLocalPhotos() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(_loadLocalPhotos);
  }
}

@riverpod
class SelectedLocalPhotos extends _$SelectedLocalPhotos {
  @override
  List<AssetEntity> build() => [];

  void selectPhoto(AssetEntity photo) {
    if (!state.contains(photo)) {
      state = [...state, photo];
    }
  }

  void deselectPhoto(AssetEntity photo) {
    state = state.where((p) => p != photo).toList();
  }

  bool isSelected(AssetEntity photo) => state.contains(photo);

  void clearSelection() {
    state = [];
  }
}

class _PhotoListNotifier extends AutoDisposeAsyncNotifier<void> {
  /// 初期処理
  @override
  Future<void> build() async {
    final permission = await PhotoManager.requestPermissionExtend();
    if (!permission.isAuth && !permission.hasAccess) {
      throw PermissionException();
    }
  }

  Future<void> classifyPhotoAsFood({
    required Map<String, double> location,
    required XFile image,
    bool isFood = true,
  }) async {
    final modifiedPhotoId = image.path.split('/').last.replaceAll('/', '-');
    final userId = ref.read(userIdProvider);

    if (userId == null) {
      throw Exception('User not signed in');
    }

    try {
      if (isFood) {
        if (location.isNotEmpty) {
          await ref.read(photoRepositoryProvider).registerStoreInfo(
                photoId: modifiedPhotoId,
                userId: userId,
                latitude: location['latitude'],
                longitude: location['longitude'],
              );
        }

        // 画像ファイルの圧縮と送信
        final photoFile = File(image.path);
        final compressedData = await _compressImage(photoFile);

        if (compressedData != null) {
          await ref.read(photoRepositoryProvider).categorizeFood(
                userId: userId,
                photoId: modifiedPhotoId,
                photoData: compressedData,
              );
        }
      }
    } on Exception catch (e, stacktrace) {
      state = AsyncValue.error(e, stacktrace);
      logger.e('Error in swipeRight: $e');
    }
  }

  /// 画像から位置情報を取得
  Future<Map<String, double>?> getImageLocation(String imagePath) async {
    try {
      final file = File(imagePath);
      final bytes = await file.readAsBytes();

      // EXIFデータを解析
      final data = await readExifFromBytes(bytes);

      if (data.isEmpty) {
        return null;
      }

      final gpsLatitude = data['GPS GPSLatitude']?.values.toList();
      final gpsLongitude = data['GPS GPSLongitude']?.values.toList();
      final gpsLatitudeRef = data['GPS GPSLatitudeRef']?.printable;
      final gpsLongitudeRef = data['GPS GPSLongitudeRef']?.printable;

      if (gpsLatitude != null && gpsLongitude != null) {
        final latitude = _convertToDecimal(
          gpsLatitude,
          gpsLatitudeRef == 'S' ? -1 : 1,
        );
        final longitude = _convertToDecimal(
          gpsLongitude,
          gpsLongitudeRef == 'W' ? -1 : 1,
        );

        return {
          'latitude': latitude,
          'longitude': longitude,
        };
      }
    } on Exception catch (e) {
      logger.e('位置情報の取得に失敗しました: $e');
    }
    return null;
  }

  /// 度分秒を10進数に変換
  double _convertToDecimal(List<dynamic> values, int sign) {
    final degrees = _toDouble(values[0]);
    final minutes = _toDouble(values[1]) / 60;
    final seconds = _toDouble(values[2]) / 3600;
    return sign * (degrees + minutes + seconds);
  }

  /// EXIF値を`double`に変換
  double _toDouble(dynamic value) {
    if (value is! Ratio) {
      throw ArgumentError('値がRatio型ではありません: $value');
    }
    return value.numerator / value.denominator;
  }

  Future<Uint8List?> _compressImage(File file) async {
    final result = await FlutterImageCompress.compressWithFile(
      file.absolute.path,
      minWidth: 256,
      minHeight: 256,
      quality: 85,
      keepExif: true,
    );
    return result;
  }
}
