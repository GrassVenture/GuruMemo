// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gallery_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$fetchPhotosHash() => r'820d679ad31dd0b0d21a62135147a295c0d45163';

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
String _$photoThumbnailHash() => r'08dbc9a666d10372f0229db88704c4b30dc4777c';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [photoThumbnail].
@ProviderFor(photoThumbnail)
const photoThumbnailProvider = PhotoThumbnailFamily();

/// See also [photoThumbnail].
class PhotoThumbnailFamily extends Family<AsyncValue<Uint8List?>> {
  /// See also [photoThumbnail].
  const PhotoThumbnailFamily();

  /// See also [photoThumbnail].
  PhotoThumbnailProvider call(
    AssetEntity photo,
  ) {
    return PhotoThumbnailProvider(
      photo,
    );
  }

  @override
  PhotoThumbnailProvider getProviderOverride(
    covariant PhotoThumbnailProvider provider,
  ) {
    return call(
      provider.photo,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'photoThumbnailProvider';
}

/// See also [photoThumbnail].
class PhotoThumbnailProvider extends AutoDisposeFutureProvider<Uint8List?> {
  /// See also [photoThumbnail].
  PhotoThumbnailProvider(
    AssetEntity photo,
  ) : this._internal(
          (ref) => photoThumbnail(
            ref as PhotoThumbnailRef,
            photo,
          ),
          from: photoThumbnailProvider,
          name: r'photoThumbnailProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$photoThumbnailHash,
          dependencies: PhotoThumbnailFamily._dependencies,
          allTransitiveDependencies:
              PhotoThumbnailFamily._allTransitiveDependencies,
          photo: photo,
        );

  PhotoThumbnailProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.photo,
  }) : super.internal();

  final AssetEntity photo;

  @override
  Override overrideWith(
    FutureOr<Uint8List?> Function(PhotoThumbnailRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: PhotoThumbnailProvider._internal(
        (ref) => create(ref as PhotoThumbnailRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        photo: photo,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Uint8List?> createElement() {
    return _PhotoThumbnailProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PhotoThumbnailProvider && other.photo == photo;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, photo.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin PhotoThumbnailRef on AutoDisposeFutureProviderRef<Uint8List?> {
  /// The parameter `photo` of this provider.
  AssetEntity get photo;
}

class _PhotoThumbnailProviderElement
    extends AutoDisposeFutureProviderElement<Uint8List?>
    with PhotoThumbnailRef {
  _PhotoThumbnailProviderElement(super.provider);

  @override
  AssetEntity get photo => (origin as PhotoThumbnailProvider).photo;
}

String _$imagePickerVisibilityHash() =>
    r'0a9f956ffc8e005f85be99ef2aec99be438969db';

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
String _$localPhotoAssetsHash() => r'e61cf64f47f392ead50764dcaeef346e17d44cff';

/// 画像選択画面に表示する画像を管理するProvider
///
/// Copied from [LocalPhotoAssets].
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
    r'5a5e2c568dc882f61b88a18f8389ddece755c9d4';

/// 画像選択画面で選択された画像を管理するProvider
///
/// Copied from [SelectedLocalPhotos].
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

/// 画像選択画面で選択された画像を用いて、画像分類APIを呼び出すProvider
///
/// Copied from [ClassifyLocalPhotoNotifier].
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
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
