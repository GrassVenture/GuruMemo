import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../features/auth/my_page.dart';
import '../features/auth/sign_in_page.dart';
import '../features/photo/camera/camera_detail_page.dart';
import '../features/photo/camera/camera_page.dart';
import '../features/photo/gallery/gallery_page.dart';
import '../features/photo/photo_detail/photo_detail_page.dart';
import '../features/photo/swipe_photo/classify_start_page.dart';
import '../features/photo/swipe_photo/swipe_photo_page.dart';
import '../features/root_page.dart';
import 'services/analytics_service.dart';

final routerProvider = Provider(
  (ref) => GoRouter(
    initialLocation: GalleryPage.routePath,
    routes: [
      ShellRoute(
        builder: (context, state, child) => RootPage(child: child),
        routes: [
          GoRoute(
            name: SignInPage.routeName,
            path: SignInPage.routePath,
            builder: (context, state) => const SignInPage(),
          ),
          GoRoute(
            name: GalleryPage.routeName,
            path: GalleryPage.routePath,
            builder: (context, state) => const GalleryPage(),
          ),
          GoRoute(
            name: MyPage.routeName,
            path: MyPage.routePath,
            builder: (context, state) => const MyPage(),
          ),
          GoRoute(
            name: CameraPage.routeName,
            path: CameraPage.routePath,
            builder: (context, state) => const CameraPage(),
          ),
          GoRoute(
            name: ClassifyStartPage.routeName,
            path: ClassifyStartPage.routePath,
            builder: (context, state) => const ClassifyStartPage(),
          ),
          GoRoute(
            name: SwipePhotoPage.routeName,
            path: SwipePhotoPage.routePath,
            builder: (context, state) => const SwipePhotoPage(),
          ),
        ],
      ),
      GoRoute(
        name: CameraDetailPage.routeName,
        path: CameraDetailPage.routePath,
        builder: (context, state) {
          final args = state.extra! as Map<String, dynamic>;
          final imageFile = args['imageFile'] as File;
          final imageDate = args['imageDate'] as String;

          return CameraDetailPage(
            imageFile: imageFile,
            imageDate: imageDate,
          );
        },
      ),
      GoRoute(
        name: PhotoDetailPage.routeName,
        path: PhotoDetailPage.routePath,
        builder: (context, state) {
          final args = state.extra! as Map<String, dynamic>;
          return PhotoDetailPage(
            index: args['index'] as int,
            photoId: args['photoId'] as String,
          );
        },
      ),
    ],
    observers: [
      GoRouterObserver(analytics: ref.watch(analyticsRepository)),
    ],
  ),
);

class GoRouterObserver extends NavigatorObserver {
  GoRouterObserver({required this.analytics});

  final FirebaseAnalytics analytics;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (route.settings.name != null) {
      analytics.logScreenView(screenName: route.settings.name);
    }
  }
}
