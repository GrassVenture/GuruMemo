// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$authedUserStreamHash() => r'cfe52885f81545fd073a8d823ecbb446044c1b9d';

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
