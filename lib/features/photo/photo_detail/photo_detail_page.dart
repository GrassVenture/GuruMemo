import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart' hide Store;
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/themes.dart';
import '../../../core/widgets/app_dialog.dart';
import '../../auth/auth_controller.dart';
import '../../store/store.dart';
import '../../store/store_controller.dart';
import '../gallery/gallery_page.dart';
import '../remote_photo.dart';
import '../remote_photo_controller.dart';
import 'widgets/photo_detail_card.dart';

class PhotoDetailPage extends HookConsumerWidget {
  const PhotoDetailPage({
    super.key,
    required this.index,
    required this.photoId,
  });

  static const String routeName = '/photo_detail';
  static const String routePath = '/photo_detail';

  final int index;
  final String photoId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageController = usePageController(
      initialPage: index,
      viewportFraction: 0.9,
    );

    final photo = useState<Future<RemotePhoto?>?>(null);

    final userId = ref.watch(userIdProvider);

    final isEditing = useState(false);

    final photoController = ref.read(remotePhotoControllerProvider);

    void downloadPhoto(WidgetRef ref) {
      if (userId == null) {
        return;
      }

      photo.value = ref.read(remotePhotoControllerProvider).downloadPhoto(
            userId: userId,
            photoId: photoId,
          );
    }

    useEffect(
      () {
        downloadPhoto(ref);
        return null;
      },
      [],
    );

    Future<Store?> fetchStore(RemotePhoto photo) async {
      final storeController = ref.read(storeControllerProvider);
      final userId = FirebaseAuth.instance.currentUser!.uid;

      final storeId = photo.storeId;

      if (storeId.isEmpty) {
        return null;
      }

      return storeController.getStoreById(
        userId: userId,
        storeId: storeId,
      );
    }

    String formatAddress(String fullAddress) {
      // 変更なし
      final postalCodeIndex = fullAddress.indexOf('〒');

      // もし '〒' が見つからない場合、そのまま fullAddress を返す
      if (postalCodeIndex == -1) {
        return fullAddress;
      }

      // '〒' の次のスペースが見つからない場合、そのまま fullAddress を返す
      final spaceIndex = fullAddress.indexOf(' ', postalCodeIndex);
      if (spaceIndex == -1) {
        return fullAddress;
      }

      final postalCode = fullAddress.substring(postalCodeIndex, spaceIndex);
      final address = fullAddress.substring(spaceIndex + 1);

      return '$postalCode\n$address';
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        toolbarHeight: 50,
        actions: [
          if (isEditing.value)
            TextButton(
              onPressed: () => isEditing.value = false,
              style: TextButton.styleFrom(foregroundColor: Themes.mainOrange),
              child: const Text('完了'),
            )
          else
            IconButton(
              onPressed: () => isEditing.value = true,
              icon: const Icon(Icons.edit),
            ),
        ],
      ),
      body: Center(
        child: Stack(
          children: [
            Positioned(
              bottom: 0,
              child: Container(
                width: MediaQuery.of(context).size.width,
                color: Themes.mainOrange[50],
              ),
            ),
            FutureBuilder(
              future: photo.value,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData && snapshot.data != null) {
                  final photo = snapshot.data!;
                  final photoUrl = photo.url;
                  final storeFuture = fetchStore(photo);

                  return FutureBuilder<Store?>(
                    future: storeFuture,
                    builder: (context, storeSnapshot) {
                      if (storeSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (storeSnapshot.hasError) {
                        return Center(
                          child: Text('Error: ${storeSnapshot.error}'),
                        );
                      } else {
                        final store = storeSnapshot.data;
                        return PageView.builder(
                          controller: pageController,
                          itemCount: 1,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.only(
                                top: MediaQuery.of(context).size.height * 0.01,
                                bottom:
                                    MediaQuery.of(context).size.height * 0.01,
                                left: 4,
                                right: 4,
                              ),
                              child: PhotoDetailCard(
                                isEditing: isEditing.value,
                                onDelete: () async {
                                  await AppDialog.show(
                                    context,
                                    titleString: '削除',
                                    contentString: '選択した写真を削除します。\nよろしいですか？',
                                    onConfirmed: () async {
                                      await photoController.deletePhoto(
                                        userId!,
                                        photoId,
                                        photoUrl,
                                      );
                                      if (context.mounted) {
                                        context.pushReplacementNamed(
                                          GalleryPage.routeName,
                                        );
                                      }
                                    },
                                    hasCancelButton: true,
                                  );
                                },
                                userId: photo.userId,
                                photoId: photo.id,
                                areaStoreIds: photo.areaStoreIds,
                                photoUrl: photo.url,
                                storeName: store?.name ?? '',
                                dateTime: DateTime.now(),
                                address: formatAddress(store?.address ?? ''),
                                storeUrl: store?.website ?? '',
                                storeImageUrls: store?.imageUrls ?? [],
                                storeOpeningHours: store?.openingHours ?? {},
                                showCardBack: photo.storeId.isNotEmpty,
                                onSelected: () {
                                  downloadPhoto(ref);
                                },
                                shotAt: photo.shotAt.dateTime,
                              ),
                            );
                          },
                        );
                      }
                    },
                  );
                } else {
                  return const Center(
                    child: Text('Nothing photo'),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
