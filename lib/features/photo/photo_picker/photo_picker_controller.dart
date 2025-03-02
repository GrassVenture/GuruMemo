import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:exif/exif.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/image_helper.dart';
import '../../../core/logger.dart';
import '../../auth/auth_controller.dart';
import '../local_photo_manager_service.dart';
import '../remote_photo_repository.dart';

part 'photo_picker_controller.g.dart';

/// 画像選択画面に表示する画像を管理するProvider
@riverpod
class LocalPhotoAssets extends _$LocalPhotoAssets {
  @override
  Future<List<AssetEntity>> build() {
    return _loadLocalPhotos();
  }

  Future<List<AssetEntity>> _loadLocalPhotos() {
    try {
      final localPhotoManagerService = ref.read(
        localPhotoManagerServiceProvider,
      );

      return localPhotoManagerService.getFilteredPhotos(
        limit: 20000,
        sortOrder: false,
      );
    } on Exception catch (e, stackTrace) {
      logger.e('画像選択画面の写真読み込みでエラーが発生しました: $e');
      state = AsyncValue.error(e, stackTrace);
      rethrow;
    }
  }
}

/// 画像選択画面で選択された画像を管理するProvider
@riverpod
class SelectedLocalPhotos extends _$SelectedLocalPhotos {
  final _maxSelection = 30;

  @override
  List<AssetEntity> build() => [];

  void selectPhoto(AssetEntity photo) {
    if (state.length >= _maxSelection) {
      return;
    }
    if (!state.contains(photo)) {
      state = [...state, photo];
    }
  }

  void deselectPhoto(AssetEntity photo) {
    state = state.where((p) => p != photo).toList();
  }

  void clearSelection() {
    state = [];
  }

  bool isSelected(AssetEntity photo) => state.contains(photo);
}

@riverpod
Future<Uint8List?> photoThumbnail(Ref ref, AssetEntity photo) {
  return photo.thumbnailData;
}

/// 画像選択画面で選択された画像を用いて、画像分類APIを呼び出すProvider
@riverpod
class ClassifyLocalPhotoNotifier extends _$ClassifyLocalPhotoNotifier {
  @override
  Future<void> build() async {
    final localPhotoManagerService = ref.read(localPhotoManagerServiceProvider);
    await localPhotoManagerService.checkPermission();
  }

  Future<void> classifyPhotoAsFood({
    required XFile image,
    bool isFood = true,
  }) async {
    final modifiedPhotoId = image.path.split('/').last.replaceAll('/', '-');
    final userId = ref.read(userIdProvider);

    if (userId == null) {
      logger.e('サインインされていません');
      return;
    }

    try {
      final location = await _getImageLocation(image.path);

      if (isFood) {
        if (location != null && location.isNotEmpty) {
          // サーバーに位置情報を送信
          await ref.read(photoRepositoryProvider).registerStoreInfo(
                photoId: modifiedPhotoId,
                userId: userId,
                latitude: location['latitude'],
                longitude: location['longitude'],
              );
        }

        // 画像ファイルの圧縮と送信
        final photoFile = File(image.path);
        final compressedData = await ImageHelper.compress(photoFile);

        if (compressedData != null) {
          await ref.read(photoRepositoryProvider).categorizeFood(
                userId: userId,
                photoId: modifiedPhotoId,
                photoData: compressedData,
              );
        }
      }
    } on Exception catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
      logger.e('Error in classifyPhotoAsFood: $e');
    }
  }

  Future<Map<String, double>?> _getImageLocation(String imagePath) async {
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
}
