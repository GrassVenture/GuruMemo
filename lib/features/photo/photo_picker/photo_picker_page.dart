import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../core/permission/permission_handler.dart';
import '../../../core/themes.dart';

import '../../../core/widgets/app_elevated_button.dart';
import '../../../core/widgets/navigation_frame.dart';
import '../camera/camera_page.dart';
import '../gallery/gallery_page.dart';
import 'photo_picker_controller.dart';

class PhotoPickerPage extends HookConsumerWidget {
  const PhotoPickerPage({super.key});

  static const routeName = 'photo_picker_page';
  static const routePath = '/photo_picker_page';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final permissionHandler = ref.read(permissionHandlerProvider);

    useEffect(() {
      Future(() async {
        await permissionHandler.requestPermissions([
          Permission.location,
          Permission.photos,
        ]);
      });

      return null;
    }, []);

    final localPhotoAssets = ref.watch(localPhotoAssetsProvider);
    final selectedLocalPhotosNotifier =
        ref.watch(selectedLocalPhotosProvider.notifier);
    final selectedLocalPhotos = ref.watch(selectedLocalPhotosProvider);

    // `PopScope` を使用して Android の戻るボタン押下時の挙動を制御
    return PopScope(
      canPop: false, // 戻るボタンを無効化
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        if (didPop) {
          return; // 重複実行防止
        }
        // 戻るボタン押下時の処理
        await ref.read(selectedIndexProvider.notifier).updateIndex(0);
        if (!context.mounted) {
          return;
        }
        context.go(GalleryPage.routePath);
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          titleSpacing: 0,
          leading: IconButton(
            icon: const Icon(Icons.close, color: Themes.gray),
            onPressed: () async {
              await ref.read(selectedIndexProvider.notifier).updateIndex(0);
              if (!context.mounted) {
                return;
              }
              context.go(GalleryPage.routePath);
            },
          ),
          actions: [
            AppElevatedButton(
              text: 'カメラを開く',
              onPressed: () async {
                final granted = await permissionHandler.requestPermissions([
                  Permission.location,
                  Permission.photos,
                  Permission.camera,
                ]);

                if (!granted || !context.mounted) {
                  return;
                }
                await context.push(CameraPage.routePath);
              },
              widget: const Icon(Icons.camera_alt, color: Colors.white),
              width: 130,
            ),
            const Gap(16),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(30),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '最近の項目',
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ),
            ),
          ),
        ),
        body: Stack(
          children: [
            localPhotoAssets.when(
              data: (photos) => GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 2,
                  crossAxisSpacing: 2,
                ),
                itemCount: photos.length,
                itemBuilder: (context, index) {
                  final photo = photos[index];
                  final isSelected = selectedLocalPhotos.contains(photo);

                  return Consumer(
                    builder: (context, ref, child) {
                      final thumbnailAsync =
                          ref.watch(photoThumbnailProvider(photo));

                      return GestureDetector(
                        onTap: () {
                          if (isSelected) {
                            selectedLocalPhotosNotifier.deselectPhoto(photo);
                          } else {
                            selectedLocalPhotosNotifier.selectPhoto(photo);
                          }
                        },
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            thumbnailAsync.when(
                              data: (thumbnail) => thumbnail != null
                                  ? SizedBox.expand(
                                      child: Image.memory(
                                        thumbnail,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : const ColoredBox(color: Themes.gray),
                              loading: () =>
                                  const ColoredBox(color: Themes.gray),
                              error: (_, __) =>
                                  const ColoredBox(color: Colors.red),
                            ),
                            Positioned(
                              right: 4,
                              top: 4,
                              child: Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.transparent,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                ),
                              ),
                            ),
                            if (isSelected)
                              Positioned(
                                right: 6,
                                top: 6,
                                child: Container(
                                  width: 20,
                                  height: 20,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Themes.mainOrange,
                                  ),
                                  alignment: Alignment.center,
                                  child: const Icon(
                                    Icons.check,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      '写真を読み込めませんでした。\n'
                      '権限を確認するか、再試行してください。',
                      textAlign: TextAlign.center,
                    ),
                    const Gap(16),
                    ElevatedButton(
                      onPressed: () async {
                        await openAppSettings();
                      },
                      child: const Text('設定を開く'),
                    ),
                    const Gap(8),
                    ElevatedButton(
                      onPressed: () {
                        ref.invalidate(localPhotoAssetsProvider); // もう一度読み込みを試す
                      },
                      child: const Text('再試行'),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 48,
              left: 16,
              right: 16,
              child: Consumer(
                builder: (context, ref, child) {
                  final selectedCount = selectedLocalPhotos.length;

                  return selectedCount > 0
                      ? AppElevatedButton(
                          text: '$selectedCount 件を追加',
                          onPressed: () async {
                            selectedLocalPhotosNotifier.clearSelection();

                            final granted = await permissionHandler
                                .requestPermissions(
                                    [Permission.location, Permission.photos]);

                            if (!granted) {
                              return;
                            }

                            // 非同期で分類処理を実行（バックグラウンド処理）
                            await Future.microtask(() async {
                              final selectedPhotos = 
                                  selectedLocalPhotos.toList();
                              final photoListNotifier = ref.read(
                                classifyLocalPhotoNotifierProvider.notifier,
                              );

                              final tasks = selectedPhotos.map((photo) async {
                                await photoListNotifier.classifyPhotoAsFood(
                                  photo: photo,
                                );
                              }).toList();

                              unawaited(Future.wait(tasks));
                              await ref
                                  .read(selectedIndexProvider.notifier)
                                  .updateIndex(0);
                              if (!context.mounted) {
                                return;
                              }

                              context.go(GalleryPage.routePath);
                            });
                          },
                        )
                      : const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
