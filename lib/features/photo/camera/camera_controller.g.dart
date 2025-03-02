// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'camera_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$cameraControllerHash() => r'75693cdcf02858bfd106288c2bb104e55c784277';

/// カメラコントローラ用のプロバイダー
///
/// Copied from [cameraController].
@ProviderFor(cameraController)
final cameraControllerProvider =
    AutoDisposeFutureProvider<Raw<CameraController>>.internal(
  cameraController,
  name: r'cameraControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$cameraControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CameraControllerRef
    = AutoDisposeFutureProviderRef<Raw<CameraController>>;
String _$classifyLatestPhotoNotifierHash() =>
    r'c1fcbe32666a0dccc6b68fa18721e5ac48ccddd5';

/// ローカルストレージ最新１枚の写真を食べ物に分類するProvider
///
/// Copied from [ClassifyLatestPhotoNotifier].
@ProviderFor(ClassifyLatestPhotoNotifier)
final classifyLatestPhotoNotifierProvider = AutoDisposeAsyncNotifierProvider<
    ClassifyLatestPhotoNotifier, AssetEntity?>.internal(
  ClassifyLatestPhotoNotifier.new,
  name: r'classifyLatestPhotoNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$classifyLatestPhotoNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ClassifyLatestPhotoNotifier = AutoDisposeAsyncNotifier<AssetEntity?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
