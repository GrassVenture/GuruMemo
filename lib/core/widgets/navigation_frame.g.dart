// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'navigation_frame.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$selectedIndexHash() => r'c033422a404bb733194757ca0a02053ef6ef1432';

/// アプリのボトムナビゲーションの[SelectedIndex]を管理するプロバイダー。
///
/// NavigationFrameのシェルルート外からシェルルート内に画面遷移する際にも、
/// [SelectedIndex]を変更できるようにするため、実装している。
///
/// ### 初期値:
/// - `0`（ボトムナビゲーションバーの一番左の項目が初期選択状態）
///
/// ### 更新方法:
/// - `updateIndex(int newIndex)` を呼び出して新しいインデックスを設定する。
///
/// Copied from [SelectedIndex].
@ProviderFor(SelectedIndex)
final selectedIndexProvider =
    AutoDisposeNotifierProvider<SelectedIndex, int>.internal(
  SelectedIndex.new,
  name: r'selectedIndexProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$selectedIndexHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SelectedIndex = AutoDisposeNotifier<int>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
