import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'core/repositories/shared_preferences_repository.dart';
import 'core/router.dart';
import 'core/services/analytics_service.dart';
import 'core/themes.dart';

final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final container = ProviderContainer();
  await Future.wait([
    Firebase.initializeApp(),
    dotenv.load(),
    SystemChrome.setPreferredOrientations([
      // アプリ全体の画面を縦向きに固定
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]),
    container.read(sharedPreferencesRepositoryProvider).init(),
  ]);

  container.read(analyticsServiceProvider).logAppOpen();

  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };

  // Pass all uncaught asynchronous errors
  // that aren't handled by the Flutterframework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  runApp(UncontrolledProviderScope(
    container: container,
    child: const MyApp(),
  ));
}

/// エントリーポイントとなるクラス。
class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      scaffoldMessengerKey: scaffoldMessengerKey,
      theme: Themes.defaultTheme,
      routerConfig: ref.watch(routerProvider),
    );
  }
}
