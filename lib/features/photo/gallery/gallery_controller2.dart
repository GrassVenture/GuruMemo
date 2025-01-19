import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../../core/database/database.dart';
import '../../../core/local_photo_repository.dart';
import '../../../core/logger.dart';

final galleryControllerProvider = Provider<GalleryController>((ref) {
  return GalleryController(ref);
});

class GalleryController {
  GalleryController(this.ref);

  final Ref ref;

  LocalPhotoRepository get _localPhotoRepository =>
      ref.read(localPhotoRepositoryProvider);

  Future<List<Photo>> getPhotos() async {
    try {
      final photos = await _localPhotoRepository.getAllPhotos();
      return _removeInvalidPhotos(photos);
    } on Exception catch (e) {
      logger.e('Error fetching photos: $e');
      return [];
    }
  }

  Future<List<Photo>> _removeInvalidPhotos(List<Photo> photos) async {
    final validPhotos = <Photo>[];
    for (final photo in photos) {
      final file = await getFileByPhoto(photo);
      if (file.existsSync()) {
        validPhotos.add(photo);
      }
    }
    return validPhotos;
  }

  Future<List<Size>> calculateSizes(List<Photo> photos) async {
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

  Future<File> getFileByPhoto(Photo photo) async {
    if (Platform.isAndroid) {
      return File(photo.path);
    }

    final asset = await AssetEntity.fromId(photo.id);
    final file = await asset!.file;

    return file!;
  }
}
