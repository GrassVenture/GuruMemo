import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/shared_preferences_service.dart';

part 'onboarding_controller.g.dart';

/// [SharedPreferencesService]と連携して、オンボーディング完了フラグを管理するNotifier
@Riverpod(keepAlive: true)
class IsOnboardingCompletedNotifier extends _$IsOnboardingCompletedNotifier {
  SharedPreferencesService get _sharedPreferencesService =>
      ref.read(sharedPreferencesServiceProvider);

  @override
  bool build() {
    return _sharedPreferencesService.getBool(
      key: SharedPreferencesKey.isOnboardingCompleted,
    );
  }

  /// [SharedPreferencesService]の値とともに更新する
  Future<void> update({required bool isOnboardingCompleted}) async {
    final value = await _sharedPreferencesService.setBool(
      key: SharedPreferencesKey.isOnboardingCompleted,
      value: isOnboardingCompleted,
    );
    state = value;
  }
}
