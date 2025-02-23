import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../core/themes.dart';
import 'camera_controller.dart';
import 'camera_preview_page.dart';

class CameraPage extends HookConsumerWidget {
  const CameraPage({super.key});

  static const routeName = 'camera_page';
  static const routePath = '/camera_page';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cameraState = ref.watch(cameraStateProvider);
    ref.watch(latestPhotoListProvider);

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: ref.watch(cameraControllerProvider).when(
                  data: CameraPreview.new,
                  error: (err, stack) => const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'カメラの初期化に失敗しました。\n'
                          '設定画面で権限を許可してください。',
                          textAlign: TextAlign.center,
                        ),
                        Gap(16), // スペースを追加
                        FractionallySizedBox(
                          widthFactor: 0.5, // 横幅を親要素の半分に設定
                          child: ElevatedButton(
                            onPressed: openAppSettings,
                            child: Text('設定を開く'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  loading: () => const Center(
                    child: Text('カメラを準備中です...'),
                  ),
                ),
          ),
          Positioned(
            bottom: 56,
            left: MediaQuery.of(context).size.width / 2 - 34,
            child: GestureDetector(
              onTap: cameraState.isTakingPicture
                  ? null // 撮影中はボタンを無効にする
                  : () async {
                      // final image = await ref
                      //     .read(cameraStateProvider.notifier)
                      //     .takePicture(context);
                      final controller =
                          await ref.read(cameraControllerProvider.future);
                      final image = await controller.takePicture();
                      // if (!isCaptureSuccessful) {
                      //   AppSnackBar.show(
                      //     message: '設定画面で権限を全て許可に設定してください。',
                      //     actionLabel: '設定を開く',
                      //     onActionPressed: openAppSettings,
                      //   );
                      //   ref.invalidate(cameraStateProvider);
                      // }

                      await context.pushNamed(
                        CameraPreviewPage.routeName,
                        extra: image.path,
                      );
                    },
              child: Container(
                width: 68,
                height: 68,
                decoration: const BoxDecoration(
                  color: Themes.mainOrange,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
          Positioned(
            top: 60,
            left: 16,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () {
                context.pop();
              },
            ),
          ),
        ],
      ),
    );
  }
}
