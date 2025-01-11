import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/themes.dart';
import '../../auth/auth_controller.dart';
import '../../auth/authed_user.dart';
import '../photo.dart';
import '../photo_controller.dart';
import '../photo_detail/photo_detail_page.dart';

class GalleryPage extends HookConsumerWidget {
  const GalleryPage({super.key});

  static const routeName = 'gallery_page';
  static const routePath = '/gallery_page';

  Future<void> _downloadPhotos(
    WidgetRef ref,
    ValueNotifier<List<Photo>?> photoUrls,
  ) async {
    final userId = ref.watch(userIdProvider);

    if (userId == null) {
      return;
    }

    final result = await ref.read(photoControllerProvider).downloadPhotos(
          userId: userId,
        );

    photoUrls.value = result.where((e) => e.url.isNotEmpty).toList();
  }

  Future<void> _initDownloadPhotos(
    WidgetRef ref,
    BuildContext context,
    ValueNotifier<bool> isReady,
    ValueNotifier<List<Photo>?> photoUrls,
  ) async {
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      final isSignedIn = ref.watch(userIdProvider) != null;
      if (!isSignedIn) {
        isReady.value = true;
        return;
      }
      await ref.watch(authedUserStreamProvider.future);
      final authedUserAsync = ref.watch(authedUserStreamProvider).valueOrNull;
      final isReadyForUse = authedUserAsync?.classifyPhotosStatus ==
          ClassifyPhotosStatus.readyForUse;
      if (!isReadyForUse) {
        isReady.value = true;
        return;
      }

      await _downloadPhotos(ref, photoUrls);
      isReady.value = true;
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isReady = useState(false);
    final photoUrls = useState<List<Photo>?>(null);

    final tabController = useTabController(initialLength: 6);

    useEffect(
      () {
        _initDownloadPhotos(ref, context, isReady, photoUrls);
        return null;
      },
      [],
    );

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
            _buildPhotoGrid(context, 'すべて', photoUrls.value),
            _buildPhotoGrid(context, 'ramen', photoUrls.value),
            _buildPhotoGrid(context, 'cafe', photoUrls.value),
            _buildPhotoGrid(context, 'japanese_food', photoUrls.value),
            _buildPhotoGrid(context, 'western_food', photoUrls.value),
            _buildPhotoGrid(context, 'ethnic', photoUrls.value),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoGrid(
    BuildContext context,
    String category,
    List<Photo>? photoUrls,
  ) {
    if (photoUrls == null) {
      return const Center(child: CircularProgressIndicator());
    }

    List<Photo> filteredPhotos;
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
}
