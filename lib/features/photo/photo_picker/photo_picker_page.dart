import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../core/build_context_extension.dart';
import '../../../core/logger.dart';
import '../../../core/permission/permission_handler.dart';
import '../../../core/themes.dart';

import '../../../core/widgets/app_elevated_button.dart';
import '../camera/camera_page.dart';
import 'photo_picker_controller.dart';

class PhotoPickerPage extends HookConsumerWidget {
  PhotoPickerPage({super.key});

  static const routeName = 'photo_picker_page';
  static const routePath = '/photo_picker_page';

  final _permission = PermissionHandler();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localPhotoAssets = ref.watch(localPhotoAssetsProvider);
    final selectedLocalPhotosNotifier =
        ref.watch(selectedLocalPhotosProvider.notifier);
    final selectedLocalPhotos = ref.watch(selectedLocalPhotosProvider);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        actions: [
          AppElevatedButton(
            text: 'カメラを開く',
            onPressed: () async {
              final granted = await _permission.requestPermissions([
                Permission.camera,
                Permission.microphone,
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
                                : const ColoredBox(color: Colors.grey),
                            loading: () => const ColoredBox(color: Colors.grey),
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
                                child: Text(
                                  '1',
                                  style:
                                      context.textTheme.labelMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
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
                    '写真へのアクセスが許可されていません。\n'
                    '設定画面を確認してください。',
                    textAlign: TextAlign.center,
                  ),
                  const Gap(16),
                  FractionallySizedBox(
                    widthFactor: 0.5,
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
                        onPressed: () {
                          selectedLocalPhotosNotifier.clearSelection();

                          // 非同期で分類処理を実行（バックグラウンド処理）
                          Future.microtask(() async {
                            final selectedPhotos = selectedLocalPhotos.toList();
                            final photoListNotifier = ref.read(
                              classifyLocalPhotoNotifierProvider.notifier,
                            );

                            final tasks = selectedPhotos.map((photo) async {
                              try {
                                final file = await photo.file;

                                if (file != null) {
                                  final xFile = XFile(file.path);
                                  await photoListNotifier.classifyPhotoAsFood(
                                    image: xFile,
                                  );
                                }
                              } on Exception catch (e) {
                                logger.e('Error classify processing photo: $e');
                              }
                            }).toList();

                            await Future.wait(tasks);
                          });
                        },
                      )
                    : const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}
