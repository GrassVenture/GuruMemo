import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/repositories/shared_preferences_repository.dart';

part 'onboarding_controller.g.dart';

/// [SharedPreferencesRepository]と連携して、オンボーディング完了フラグを管理するNotifier
@Riverpod(keepAlive: true)
class IsOnboardingCompletedNotifier extends _$IsOnboardingCompletedNotifier {
  SharedPreferencesRepository get _sharedPreferencesRepository =>
      ref.read(sharedPreferencesRepositoryProvider);

  @override
  bool build() {
    return _sharedPreferencesRepository.getBool(
      key: SharedPreferencesKey.isOnboardingCompleted,
    );
  }

  /// [SharedPreferencesRepository]の値とともに更新する
  Future<void> update({
    required bool isOnboardingCompleted,
  }) async {
    final value = await _sharedPreferencesRepository.setBool(
      key: SharedPreferencesKey.isOnboardingCompleted,
      value: isOnboardingCompleted,
    );
    state = value;
  }
}
