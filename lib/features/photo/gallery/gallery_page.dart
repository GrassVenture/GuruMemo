import 'dart:nativewrappers/_internal/vm/lib/typed_data_patch.dart';
import 'dart:nativewrappers/_internal/vm/lib/typed_data_patch.dart';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../../core/logger.dart';
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
    final photoUrls = ref.watch(fetchPhotosProvider).when(
          error: (err, _) {
            logger.e(err);
            return null;
          },
          loading: () => null,
          data: (data) => data,
        );

    final tabController = useTabController(initialLength: 6);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppBar(
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(0), // TabBarの高さを指定
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
      body: DefaultTabController(
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
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
                      // 画像が読み込めなかったときの代替表示
                      throw Exception('Error loading image: $error');
                    },
                  ),
                  border: Border.all(
                    color: Themes.gray[900]!,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                height: 280, // 最低限の高さを設定
              ),
            ),
          );
        },
        itemCount: filteredPhotos.length,
      ),
    );
  }

  Widget _buildImagePickerOverlay(
    BuildContext context,
    ValueNotifier<bool> isImagePickerVisible,
    ValueNotifier<List<AssetEntity>> selectedImages,
  ) {
    final photoAssets = useState<List<AssetEntity>>([]);
    final selectedPhotos = useState<Set<AssetEntity>>({});

    useEffect(() {
      () async {
        final albums =
            await PhotoManager.getAssetPathList(type: RequestType.image);
        if (albums.isNotEmpty) {
          final photos = await albums[0].getAssetListPaged(page: 0, size: 500);
          photoAssets.value = photos;
        }
      }();
      return null;
    }, []);

    return Material(
      color: Colors.black54,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                const Text(
                  '画像を選択',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                const Spacer(),
                // 選択中の枚数を表示
                Text(
                  '選択中: ${selectedPhotos.value.length} 枚',
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
                const SizedBox(width: 16), // 少し間隔を空ける
                SizedBox(
                  width: 100,
                  child: ElevatedButton(
                    onPressed: () {
                      selectedImages.value = selectedPhotos.value.toList();
                      isImagePickerVisible.value = false;
                    },
                    child: const Text('確定'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () {
                    isImagePickerVisible.value = false;
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
              ),
              itemCount: photoAssets.value.length,
              itemBuilder: (context, index) {
                final photo = photoAssets.value[index];
                final isSelected = selectedPhotos.value.contains(photo);

                return FutureBuilder<Uint8List?>(
                  future: photo.thumbnailData,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Container(color: Colors.grey);
                    }

                    return GestureDetector(
                      onTap: () {
                        if (isSelected) {
                          selectedPhotos.value = {
                            ...selectedPhotos.value..remove(photo),
                          };
                        } else {
                          selectedPhotos.value = {
                            ...selectedPhotos.value..add(photo),
                          };
                        }
                      },
                      child: Stack(
                        children: [
                          Image.memory(
                            snapshot.data!,
                            fit: BoxFit.cover,
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
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedImagesList(List<AssetEntity> selectedImages) {
    return selectedImages.isEmpty
        ? const Center(child: Text("画像が選択されていません"))
        : GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
            ),
            itemCount: selectedImages.length,
            itemBuilder: (context, index) {
              return FutureBuilder<Uint8List?>(
                future: selectedImages[index].thumbnailData,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Container(color: Colors.grey);
                  }
                  return Image.memory(
                    snapshot.data!,
                    fit: BoxFit.cover,
                  );
                },
              );
            },
          );
  }
}
