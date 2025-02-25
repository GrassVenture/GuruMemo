import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../core/themes.dart';
import 'camera_controller.dart';
import 'camera_preview_page.dart';
import 'camera_state.dart';

class CameraPage extends HookConsumerWidget {
  const CameraPage({super.key});

  static const routeName = 'camera_page';
  static const routePath = '/camera_page';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cameraState = ref.watch(cameraStateNotifierProvider);
    final cameraNotifier = ref.read(cameraStateNotifierProvider.notifier);

    useEffect(() {
      // カメラの初期化
      cameraNotifier.initializeCamera();

      ref.listen<AsyncValue<CameraState>>(cameraStateNotifierProvider,
          (previous, next) {
        next.when(
          data: (state) {
            if (state.capturedImagePath != null) {
              print('写真撮影に成功しました。画像パス: ${state.capturedImagePath}');
            }
          },
          loading: () => print('処理中...'),
          error: (error, stack) => print('エラーが発生しました: $error'),
        );
      });
      // ウィジェットの破棄時にカメラを解放
      return cameraNotifier.disposeCamera;
    }, []);

    return Scaffold(
      body: Stack(
        children: [
          // カメラプレビューの表示
          Positioned.fill(
            child: cameraState.when(
              data: (state) {
                if (state.isInitialized) {
                  return CameraPreview(cameraNotifier.cameraController!);
                } else {
                  return const Center(child: Text('カメラを初期化しています...'));
                }
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => const Center(
                child: Text('カメラの初期化に失敗しました。'),
              ),
            ),
          ),
          // 撮影ボタンの配置
          Positioned(
            bottom: 56,
            left: MediaQuery.of(context).size.width / 2 - 34,
            child: GestureDetector(
              onTap: cameraState.maybeWhen(
                data: (state) => state.isTakingPicture
                    ? null
                    : () async {
                        try {
                          await cameraNotifier.takePicture();
                          print("成功");
                          // 撮影後の処理（プレビュー画面への遷移など）
                        } catch (e) {
                          // エラーハンドリング
                        }
                      },
                orElse: () => null,
              ),
              child: Container(
                width: 68,
                height: 68,
                decoration: const BoxDecoration(
                  color: Colors.orange,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
          // 閉じるボタンの配置
          Positioned(
            top: 60,
            left: 16,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.grey),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      ),
    );
  }
}
