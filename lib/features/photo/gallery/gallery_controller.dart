import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

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
