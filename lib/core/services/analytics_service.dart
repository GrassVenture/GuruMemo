import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../core/flavor.dart';
import '../../features/auth/auth_repository.dart';
import '../logger.dart';

/// [AnalyticsService]を提供する[Provider]
final analyticsServiceProvider = Provider((ref) {
  // パラメータに付与するユーザー情報の取得
  final authUser = ref.watch(authRepositoryProvider).auth;

  return AnalyticsService._(
    // 全てのユーザーから取得する初期値
    parameters: {
      'env': flavor.name,
      'u_id': authUser.currentUser?.uid ?? '',
      'display_name': authUser.currentUser?.displayName ?? '',
    },
  );
});

/// Analyticsに関する操作を担当するクラス
///
/// 参考)
/// https://www.kamo-it.org/blog/flutter-analytics/
class AnalyticsService {
  AnalyticsService._({required Map<String, String> parameters})
      : _parameters = parameters;

  /// [FirebaseAnalytics]のインスタンス
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  /// スネークケースのパラメータ
  ///
  /// 値がnullの場合は空文字を設定する。
  final Map<String, String> _parameters;

  /// どの画面を開いているか、Analyticsにログを送信するメソッド
  ///
  /// logEvent name : screen_view_event
  /// setCurrentScreenにはparameterを設定できないので、同時にlogEventも発火している。
  /// 参考)
  /// https://www.kamo-it.org/blog/flutter-analytics/
  void sendScreenView(String path) {
    _parameters
      // event_nameが残っていたら余計な情報なので省く
      ..remove('event_name')
      ..addAll({'screen_name': path});
    // パラメータの内容の確認
    logger.i('Analyticsのパラメータ : $_parameters');

    _analytics
      ..logEvent(name: 'screen_view_event', parameters: _parameters)
      ..logScreenView(screenName: path);
  }

  /// どのボタンを押したか、Analyticsに送信するメソッド
  ///
  /// logEvent name : event_name
  Future<void> sendEvent({
    required String name,
    Map<String, String> additionalParams = const {},
  }) async {
    // // _parametersに追加パラメータを結合
    _parameters
      ..addAll({'event_name': name})
      ..addAll(additionalParams);

    await _analytics.logEvent(name: name, parameters: _parameters);
  }

  /// Analyticsに一律追加したいパラメータを設定するメソッド
  void setAddParameters({
    required Map<String, String> additionalParams,
  }) {
    _parameters.addAll(additionalParams);
    // パラメータの内容の確認
    logger.i('追加後のAnalyticsのパラメータの状態 : $_parameters');
  }
}
