import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:photo_manager/photo_manager.dart';

class GalleryPage extends HookWidget {
  const GalleryPage({super.key});

  static const routeName = 'gallery_page';
  static const routePath = '/gallery_page';

  @override
  Widget build(BuildContext context) {
    final selectedImages = useState<List<AssetEntity>>([]);
    final isImagePickerVisible = useState(false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('ホームページ'),
      ),
      body: Column(
        children: [
          Expanded(
            child: _buildSelectedImagesList(selectedImages.value),
          ),
          if (isImagePickerVisible.value)
            Expanded(
              child: _buildImagePickerOverlay(
                context,
                isImagePickerVisible,
                selectedImages,
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final hasPermission = await _checkPhotoPermission();
          if (hasPermission) {
            isImagePickerVisible.value = true;
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<bool> _checkPhotoPermission() async {
    final permissionState = await PhotoManager.requestPermissionExtend();
    if (!permissionState.isAuth) {
      await PhotoManager.openSetting();
      return false;
    }
    return true;
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
