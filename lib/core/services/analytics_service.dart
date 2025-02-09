import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/flavor.dart';
import '../../features/auth/auth_repository.dart';
import '../logger.dart';

part 'analytics_service.g.dart';

@Riverpod(keepAlive: true)
AnalyticsService analyticsService(AnalyticsServiceRef ref) {
  // authRepositoryProviderから認証情報を取得
  final authUser = ref.watch(authRepositoryProvider).auth;

  return AnalyticsService._(
    parameters: {
      'env': flavor.name,
      'u_id': authUser.currentUser?.uid ?? '',
      'display_name': authUser.currentUser?.displayName ?? '',
    },
  );
}

/// [FirebaseAnalytics]の操作を担当するクラス
class AnalyticsService {
  AnalyticsService._({required Map<String, String> parameters})
      : _analytics = FirebaseAnalytics.instance,
        _parameters = parameters;

  /// [FirebaseAnalytics]インスタンス
  final FirebaseAnalytics _analytics;

  /// ログ出力時に付与するパラメータ
  ///
  /// 初期化後に必要に応じて追加する。
  /// 文字列はスネークケースで記述する。
  final Map<String, String> _parameters;

  /// どの画面を開いているか、Analyticsにログを送信するメソッド
  ///
  /// [FirebaseAnalytics.logScreenView]加えて、
  /// [_parameters]を付与した[FirebaseAnalytics.logEvent]を送信する。
  void sendScreenView(String path) {
    unawaited(_analytics.logScreenView(screenName: path));
    unawaited(
      _analytics.logEvent(
        name: 'screen_view_event',
        parameters: {
          ..._parameters,
          'screen_name': path,
        },
      ),
    );
  }

  /// 特定のイベントをAnalyticsに送信するメソッド
  ///
  /// logEvent name : name
  void sendEvent({
    required String name,
    Map<String, String> additionalParams = const {},
  }) {
    unawaited(
      _analytics.logEvent(
        name: name,
        parameters: {
          ..._parameters,
          'event_name': name,
          ...additionalParams,
        },
      ),
    );
  }

  /// Analyticsに一律追加したいパラメータを設定するメソッド
  void addParameters({
    required Map<String, String> additionalParams,
  }) {
    _parameters.addAll(additionalParams);
    logger.i('追加後のAnalyticsのパラメータの状態 : $_parameters');
  }
}
