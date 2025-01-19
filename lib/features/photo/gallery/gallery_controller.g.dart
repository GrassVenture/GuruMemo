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
String _$localPhotoAssetsHash() => r'7b26565c63b42e50d36fe9af5f7b9a9a28c44b1c';

/// See also [LocalPhotoAssets].
@ProviderFor(LocalPhotoAssets)
final localPhotoAssetsProvider = AutoDisposeAsyncNotifierProvider<
    LocalPhotoAssets, List<AssetEntity>>.internal(
  LocalPhotoAssets.new,
  name: r'localPhotoAssetsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$localPhotoAssetsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$LocalPhotoAssets = AutoDisposeAsyncNotifier<List<AssetEntity>>;
String _$selectedLocalPhotosHash() =>
    r'6868dfc3217aeb5eb2bf669f6875bc3322fdf9c6';

/// See also [SelectedLocalPhotos].
@ProviderFor(SelectedLocalPhotos)
final selectedLocalPhotosProvider = AutoDisposeNotifierProvider<
    SelectedLocalPhotos, List<AssetEntity>>.internal(
  SelectedLocalPhotos.new,
  name: r'selectedLocalPhotosProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$selectedLocalPhotosHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SelectedLocalPhotos = AutoDisposeNotifier<List<AssetEntity>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
