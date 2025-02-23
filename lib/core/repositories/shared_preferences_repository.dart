import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'shared_preferences_repository.g.dart';

/// [SharedPreferences]のキーを管理するenum
enum SharedPreferencesKey {
  /// オンボーディングが完了したかどうか
  isOnboardingCompleted,

  /// 写真分類のオンボーディングが完了したかどうか
  isClassifyOnboardingCompleted,
}

/// [SharedPreferencesRepository]用プロバイダー
///
/// アプリ起動時 or テスト時に、初期化処理としてインスタンスを生成しておく。

@Riverpod(keepAlive: true)
SharedPreferencesRepository sharedPreferencesRepository(
  Ref ref,
) {
  return SharedPreferencesRepository._();
}

/// [SharedPreferences]を操作するクラス
class SharedPreferencesRepository {
  SharedPreferencesRepository._();

  late final SharedPreferences _sharedPreferences;

  /// 初期化処理
  Future<void> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  /// bool用書き込み処理
  Future<bool> setBool({
    required SharedPreferencesKey key,
    required bool value,
  }) {
    return _sharedPreferences.setBool(key.name, value);
  }

  /// bool用読み込み処理
  bool getBool({
    required SharedPreferencesKey key,
  }) {
    return _sharedPreferences.getBool(key.name) ?? false;
  }
}
