import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../../core/exception/permission_exception.dart';
import '../../../core/logger.dart';
import '../../../core/services/analytics_service.dart';
import '../../../core/themes.dart';
import '../../../core/utils/category_constants.dart';
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
    final photoUrls = ref.watch(fetchPhotosProvider).when(
          error: (err, _) {
            logger.e(err);
            return null;
          },
          loading: () => null,
          data: (data) => data,
        );

    final tabController =
        useTabController(initialLength: CategoryConstants.categories.length);

    useEffect(
      () {
        Future<void> onTabChanged() async {
          final category = CategoryConstants.categories[tabController.index];

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
              tabs: CategoryConstants.tabLabels
                  .map((label) => Tab(text: label))
                  .toList(),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          DefaultTabController(
            length: CategoryConstants.categories.length,
            child: TabBarView(
              controller: tabController,
              children: CategoryConstants.categories
                  .map(
                    (category) => _buildPhotoGrid(context, category, photoUrls),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final galleryController = ref.read(galleryControllerProvider);
          try {
            await galleryController.checkPermission();

            await context.push('/gallery_photo_picker_page');
          } on PermissionException {
            AppSnackBar.show(
              message: '写真へのアクセスが許可されていません。設定を確認してください。',
              actionLabel: '設定を開く',
              onActionPressed: PhotoManager.openSetting,
            );
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
    if (category == CategoryConstants.all) {
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
