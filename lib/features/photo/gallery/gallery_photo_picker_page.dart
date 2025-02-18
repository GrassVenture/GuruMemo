import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../../core/build_context_extension.dart';
import '../../../core/logger.dart';
import '../../../core/themes.dart';
import '../../../core/widgets/app_snack_bar.dart';
import 'gallery_controller.dart';

class GalleryPhotoPickerPage extends HookConsumerWidget {
  const GalleryPhotoPickerPage({super.key});

  static const routeName = 'gallery_photo_picker_page';
  static const routePath = '/gallery_photo_picker_page';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localPhotoAssets = ref.watch(localPhotoAssetsProvider);
    final selectedLocalPhotosNotifier =
        ref.watch(selectedLocalPhotosProvider.notifier);
    final selectedLocalPhotos = ref.watch(selectedLocalPhotosProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('画像を選択'),
        actions: [
          TextButton(
            onPressed: selectedLocalPhotos.isNotEmpty
                ? () async {
                    final selectedPhotos = selectedLocalPhotos.toList();
                    final photoListNotifier =
                        ref.read(classifyLocalPhotoNotifierProvider.notifier);

                    Navigator.pop(context); // 画像選択画面を閉じる

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
                  }
                : null,
            child: const Text('確定', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: localPhotoAssets.when(
        data: (photos) => GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
          ),
          itemCount: photos.length,
          itemBuilder: (context, index) {
            final photo = photos[index];
            final isSelected = selectedLocalPhotos.contains(photo);

            return Consumer(
              builder: (context, ref, child) {
                final thumbnailAsync = ref.watch(photoThumbnailProvider(photo));

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
                        error: (_, __) => const ColoredBox(color: Colors.red),
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
                              style: context.textTheme.labelMedium?.copyWith(
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
    );
  }
}
