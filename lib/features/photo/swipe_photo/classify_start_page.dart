import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/services/analytics_service.dart';
import '../../../core/build_context_extension.dart';
import '../../../core/widgets/app_elevated_button.dart';
import 'swipe_photo_controller.dart';
import 'swipe_photo_page.dart';

/// 写真分類開始画面
class ClassifyStartPage extends ConsumerWidget {
  const ClassifyStartPage({super.key});

  static const routeName = 'classify_start_page';
  static const routePath = '/classify_start_page';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    width: 300,
                    height: 350,
                    'assets/images/classify_photo.png',
                  ),
                  const Gap(16),
                  Text(
                    'スマホに入っている写真を読み込みます！',
                    style: context.textTheme.titleMedium,
                  ),
                  Text(
                    'グルメの画像とそれ以外を分類してください。',
                    style: context.textTheme.titleMedium,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: AppElevatedButton(
                onPressed: () async {
                  final goRouter = GoRouter.of(context);
                  await ref
                      .read(
                        isClassifyOnboardingCompletedNotifierProvider.notifier,
                      )
                      .update(isClassifyOnboardingCompleted: true);
                  ref.read(analyticsServiceProvider).sendEvent(
                        name: 'google_sign_in',
                      );
                  goRouter.go(SwipePhotoPage.routePath);
                },
                text: '分類スタート',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
