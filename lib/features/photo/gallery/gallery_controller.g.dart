// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gallery_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$fetchPhotosHash() => r'4a13784e4d024408596da0ef52f8123df27ac770';

/// See also [fetchPhotos].
@ProviderFor(fetchPhotos)
final fetchPhotosProvider =
    AutoDisposeFutureProvider<List<RemotePhoto>>.internal(
  fetchPhotos,
  name: r'fetchPhotosProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$fetchPhotosHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef FetchPhotosRef = AutoDisposeFutureProviderRef<List<RemotePhoto>>;
String _$imagePickerVisibilityHash() =>
    r'2af400b9ecdc2622b456ad790c1fad00bbd17647';

/// See also [ImagePickerVisibility].
@ProviderFor(ImagePickerVisibility)
final imagePickerVisibilityProvider =
    AutoDisposeNotifierProvider<ImagePickerVisibility, bool>.internal(
  ImagePickerVisibility.new,
  name: r'imagePickerVisibilityProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$imagePickerVisibilityHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ImagePickerVisibility = AutoDisposeNotifier<bool>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
