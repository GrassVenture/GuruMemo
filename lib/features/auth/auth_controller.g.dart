// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$authedUserStreamHash() => r'1339d5b33422b48a40b1635cc3bce651ef020f5b';

/// [AuthedUser]を購読するProvider
///
/// Copied from [authedUserStream].
@ProviderFor(authedUserStream)
final authedUserStreamProvider = AutoDisposeStreamProvider<AuthedUser>.internal(
  authedUserStream,
  name: r'authedUserStreamProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$authedUserStreamHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

// ignore: deprecated_member_use
typedef AuthedUserStreamRef = AutoDisposeStreamProviderRef<AuthedUser>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
