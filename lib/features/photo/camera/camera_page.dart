import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../core/build_context_extension.dart';
import 'camera_controller.dart';
import 'camera_detail_page.dart';

class CameraPage extends HookConsumerWidget {
  const CameraPage({super.key});

  static const routeName = 'camera_page';
  static const routePath = '/camera_page';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cameraState = ref.watch(cameraStateProvider);
    ref.watch(latestPhotoListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body: Stack(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          Expanded(
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: ref.watch(cameraControllerProvider).when(
                                      data: CameraPreview.new,
                                      error: (err, stack) => const Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
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
                            ),
                          ),
                          const Gap(20),
                          GestureDetector(
                            onTap: cameraState.isTakingPicture
                                ? null // 撮影中はボタンを無効にする
                                : () async {
                                    final isCaptureSuccessful = await ref
                                        .read(cameraStateProvider.notifier)
                                        .takePictureAndSave(context);
                                    if (!isCaptureSuccessful &&
                                        context.mounted) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content:
                                              Text('設定画面で権限を全て許可に設定してください。'),
                                          action: SnackBarAction(
                                            label: '設定を開く',
                                            onPressed: openAppSettings,
                                          ),
                                        ),
                                      );
                                      ref.invalidate(cameraStateProvider);
                                    }
                                    await ref
                                        .read(
                                          latestPhotoListProvider.notifier,
                                        )
                                        .swipeRight();
                                  },
                            child: Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  width: 2,
                                ),
                              ),
                              child: Center(
                                child: Container(
                                  width: 50,
                                  height: 50,
                                  decoration: const BoxDecoration(
                                    color: Colors.black,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (cameraState.capturedImage != null &&
              cameraState.imageDate != null)
            Positioned(
              bottom: 32,
              left: 24,
              child: GestureDetector(
                onTap: () {
                  context.push(
                    CameraDetailPage.routePath,
                    extra: {
                      'imageFile': cameraState.capturedImage,
                      'imageDate': cameraState.imageDate,
                    },
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      width: 2,
                    ),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        width: MediaQuery.sizeOf(context).width / 5,
                        height: MediaQuery.sizeOf(context).height / 5,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: Image.file(
                            cameraState.capturedImage!,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const Gap(4),
                      SizedBox(
                        width: MediaQuery.sizeOf(context).width / 5,
                        child: Text(
                          cameraState.imageDate!,
                          style: context.textTheme.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
