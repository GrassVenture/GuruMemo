import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/logger.dart';
import '../../../core/services/analytics_service.dart';
import '../../../core/themes.dart';
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

          // 非同期で analyticsServiceProvider を取得して sendEvent を呼び出す
          final analyticsService =
              await ref.read(analyticsServiceProvider.future);
          await analyticsService.sendEvent(
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
          if (isImagePickerVisible)
            _buildImagePickerOverlay(
              context,
              ref,
            ),
        ],
      ),
      floatingActionButton: !isImagePickerVisible
          ? FloatingActionButton(
              onPressed: () {
                ref.read(imagePickerVisibilityProvider.notifier).show();
              },
              child: const Icon(Icons.add),
            )
          : null,
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

Widget _buildImagePickerOverlay(BuildContext context, WidgetRef ref) {
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
                        children: [
                          thumbnailAsync.when(
                            data: (thumbnail) => thumbnail != null
                                ? Image.memory(thumbnail, fit: BoxFit.cover)
                                : Container(color: Colors.grey),
                            loading: () => Container(color: Colors.grey),
                            error: (_, __) => Container(color: Colors.red),
                          ),
                          if (isSelected)
                            Positioned(
                              right: 4,
                              top: 4,
                              child: Container(
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.blue,
                                ),
                                padding: const EdgeInsets.all(4),
                                child: const Icon(
                                  Icons.check,
                                  size: 16,
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
            error: (error, stack) => Center(child: Text('Error: $error')),
          ),
        ),
      ],
    ),
  );
}
