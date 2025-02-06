import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

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
          children: categories
              .map((category) => _buildPhotoGrid(context, category, photoUrls))
              .toList(),
        ),
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
