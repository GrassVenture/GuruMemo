import 'package:async/async.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../core/themes.dart';
import '../../../core/permission/permission_handler.dart';
import 'camera_controller.dart';
import 'camera_preview_page.dart';

class CameraPage extends HookConsumerWidget {
  CameraPage({super.key});

  static const routeName = 'camera_page';
  static const routePath = '/camera_page';

  final _permission = PermissionHandler();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cacheStrategy = useState(AsyncCache<dynamic>.ephemeral());
    final cameraState = ref.watch(cameraControllerProvider);

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: ref.watch(cameraControllerProvider).when(
                  data: CameraPreview.new,
                  error: (err, stack) => Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'カメラの初期化に失敗しました。\n'
                          '設定画面で権限を許可してください。',
                          textAlign: TextAlign.center,
                        ),
                        const Gap(16),
                        FractionallySizedBox(
                          widthFactor: 0.5, // 横幅を親要素の半分に設定
                          child: ElevatedButton(
                            onPressed: () async {
                              await openAppSettings();
                            },
                            child: const Text('設定を開く'),
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
          // 撮影ボタンの配置
          if (cameraState is AsyncData<CameraController>)
            Positioned(
              bottom: 56,
              left: MediaQuery.of(context).size.width / 2 - 34,
              child: GestureDetector(
                onTap: () => cacheStrategy.value.fetch(() async {
                  await _permission.requestPermissions([
                    Permission.camera,
                    Permission.microphone,
                    Permission.location,
                    Permission.photos
                  ]);

                  final controller =
                      await ref.read(cameraControllerProvider.future);
                  final image = await controller.takePicture();

                  if (!context.mounted) {
                    return;
                  }
                  await context.pushNamed(
                    CameraPreviewPage.routeName,
                    extra: image.path,
                  );
                }),
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
              icon: const Icon(Icons.close, color: Themes.gray),
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
