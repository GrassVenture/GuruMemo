import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/flavor.dart';
import '../../features/auth/auth_repository.dart';
import '../logger.dart';

part 'analytics_service.g.dart';

/// FirebaseAnalyticsのインスタンス
final analyticsRepository = Provider((ref) => FirebaseAnalytics.instance);

@Riverpod(keepAlive: true)
Future<AnalyticsService> analyticsService(Ref ref) async {
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

/// Analytics に関する操作を担当するクラス
class AnalyticsService {
  AnalyticsService._({required Map<String, String> parameters})
      : _parameters = parameters;

  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  /// パラメータ
  final Map<String, String> _parameters;

  void sendScreenView(String path) {
    _parameters
      ..remove('event_name')
      ..addAll({'screen_name': path});
    logger.i('Analyticsのパラメータ : $_parameters');

    _analytics
      ..logEvent(name: 'screen_view_event', parameters: _parameters)
      ..logScreenView(screenName: path);
  }

  Future<void> sendEvent({
    required String name,
    Map<String, String> additionalParams = const {},
  }) async {
    _parameters
      ..addAll({'event_name': name})
      ..addAll(additionalParams);

    await _analytics.logEvent(name: name, parameters: _parameters);
  }

  void setAddParameters({required Map<String, String> additionalParams}) {
    _parameters.addAll(additionalParams);
    logger.i('追加後のAnalyticsのパラメータの状態 : $_parameters');
  }
}
