import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../../core/build_context_extension.dart';
import '../../../core/exception/permission_exception.dart';
import '../../../core/logger.dart';
import '../../../core/services/analytics_service.dart';
import '../../../core/themes.dart';
import '../../../core/widgets/app_snack_bar.dart';
import '../photo_detail/photo_detail_page.dart';
import '../remote_photo.dart';
import 'gallery_controller.dart';

class GalleryPage extends HookConsumerWidget {
  const GalleryPage({super.key});

  static const routeName = 'gallery_page';
  static const routePath = '/gallery_page';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isImagePickerVisible = ref.watch(imagePickerVisibilityProvider);

    final photoUrls = ref.watch(fetchPhotosProvider).when(
          error: (err, _) {
            logger.e(err);
            return null;
          },
          loading: () => null,
          data: (data) => data,
        );

    final tabController = useTabController(initialLength: 6);

    final categories = [
      'すべて',
      'ramen',
      'cafe',
      'japanese_food',
      'western_food',
      'ethnic',
    ];

    useEffect(
      () {
        Future<void> onTabChanged() async {
          final category = categories[tabController.index];

          ref.read(analyticsServiceProvider).sendEvent(
            name: 'filter_photo',
            additionalParams: {'category': category},
          );
        }

        tabController.addListener(onTabChanged);
        return () => tabController.removeListener(onTabChanged);
      },
      [tabController],
    );

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppBar(
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(0),
            child: TabBar(
              padding: const EdgeInsets.only(left: 16, bottom: 8),
              controller: tabController,
              isScrollable: true,
              tabs: const [
                Tab(text: 'すべて'),
                Tab(text: 'ラーメン'),
                Tab(text: 'カフェ'),
                Tab(text: '和食'),
                Tab(text: '洋食'),
                Tab(text: 'エスニック'),
              ],
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          DefaultTabController(
            length: 6,
            child: TabBarView(
              controller: tabController,
              children: [
                _buildPhotoGrid(context, 'すべて', photoUrls),
                _buildPhotoGrid(context, 'ramen', photoUrls),
                _buildPhotoGrid(context, 'cafe', photoUrls),
                _buildPhotoGrid(context, 'japanese_food', photoUrls),
                _buildPhotoGrid(context, 'western_food', photoUrls),
                _buildPhotoGrid(context, 'ethnic', photoUrls),
              ],
            ),
          ),
          if (isImagePickerVisible) const _ImagePickerOverlay(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final galleryController = ref.read(galleryControllerProvider);
          try {
            await galleryController.checkPermission();

            context.go('/gallery_photo_picker_page');
          } on PermissionException catch (e) {
            AppSnackBar.show(
              message: '写真へのアクセスが許可されていません。設定を確認してください。',
              actionLabel: '設定を開く',
              onActionPressed: PhotoManager.openSetting,
            );
            logger.e('写真のアクセスが許可されていません: $e');
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildPhotoGrid(
    BuildContext context,
    String category,
    List<RemotePhoto>? photoUrls,
  ) {
    if (photoUrls == null) {
      return const Center(child: CircularProgressIndicator());
    }

    List<RemotePhoto> filteredPhotos;
    if (category == 'すべて') {
      filteredPhotos = photoUrls;
    } else {
      filteredPhotos =
          photoUrls.where((photo) => photo.category == category).toList();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      child: MasonryGridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 6,
        crossAxisSpacing: 6,
        itemBuilder: (context, index) {
          final photo = filteredPhotos[index];

          return Hero(
            tag: photo,
            child: GestureDetector(
              onTap: () {
                context.push(
                  PhotoDetailPage.routePath,
                  extra: {
                    'photoId': photo.id,
                    'index': index,
                  },
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(photo.url),
                    fit: BoxFit.cover,
                    onError: (error, stackTrace) {
                      throw Exception('Error loading image: $error');
                    },
                  ),
                  border: Border.all(
                    color: Themes.gray[900]!,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                height: 280,
              ),
            ),
          );
        },
        itemCount: filteredPhotos.length,
      ),
    );
  }
}

class _ImagePickerOverlay extends HookConsumerWidget {
  const _ImagePickerOverlay();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localPhotoAssets = ref.watch(localPhotoAssetsProvider);
    final selectedLocalPhotosNotifier =
        ref.watch(selectedLocalPhotosProvider.notifier);
    final selectedLocalPhotos = ref.watch(selectedLocalPhotosProvider);

    return Material(
      color: Colors.grey,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                const Text(
                  '画像を選択',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                const Spacer(),
                Text(
                  '選択中: ${selectedLocalPhotos.length} / 30 枚',
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
                const Gap(16),
                SizedBox(
                  width: 100,
                  child: ElevatedButton(
                    onPressed: () async {
                      final selectedPhotos = selectedLocalPhotos.toList();
                      final photoListNotifier =
                          ref.read(classifyLocalPhotoNotifierProvider.notifier);

                      ref.read(imagePickerVisibilityProvider.notifier).hide();

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
                    },
                    child: const Text('確定'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () {
                    ref.read(imagePickerVisibilityProvider.notifier).hide();
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: localPhotoAssets.when(
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
                      final thumbnailAsync =
                          // ignore: deprecated_member_use_from_same_package
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
                              loading: () =>
                                  const ColoredBox(color: Colors.grey),
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
                                    // TextStyle(
                                    //   fontSize: 16,
                                    //   fontWeight: FontWeight.bold,
                                    //   color: Colors.white,
                                    // ),
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
                    const Gap(16), // スペースを追加
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
            ),
          ),
        ],
      ),
    );
  }
}
