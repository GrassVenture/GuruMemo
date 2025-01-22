// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gallery_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$fetchPhotosHash() => r'3b648e9da201a81eb012ba4d4cbe21b1c090052f';

/// See also [fetchPhotos].
@ProviderFor(fetchPhotos)
final fetchPhotosProvider = FutureProvider<List<RemotePhoto>>.internal(
  fetchPhotos,
  name: r'fetchPhotosProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$fetchPhotosHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FetchPhotosRef = FutureProviderRef<List<RemotePhoto>>;
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
String _$localPhotoAssetsHash() => r'497b7962fa49ee49d0203f43f012f24833384deb';

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
    r'8b4321e54bb31c7c3ddaae5e6d0b3dfb4dc3dcd1';

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
String _$classifyLocalPhotoNotifierHash() =>
    r'4ba754adcf5ed91045fb1cf4084f329941a0b3eb';

/// See also [ClassifyLocalPhotoNotifier].
@ProviderFor(ClassifyLocalPhotoNotifier)
final classifyLocalPhotoNotifierProvider =
    AutoDisposeAsyncNotifierProvider<ClassifyLocalPhotoNotifier, void>.internal(
  ClassifyLocalPhotoNotifier.new,
  name: r'classifyLocalPhotoNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$classifyLocalPhotoNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ClassifyLocalPhotoNotifier = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
