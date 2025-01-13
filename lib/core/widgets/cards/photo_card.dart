import 'dart:io';

import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../../features/photo/swipe_photo/swipe_photo_controller.dart';
import '../../themes.dart';

/// 写真のキャッシュを管理するProvider
class _PhotoFileCacheNotifier
    extends AutoDisposeFamilyAsyncNotifier<File, AssetEntity> {
  @override
  Future<File> build(AssetEntity assetEntity) async {
    final file = await assetEntity.file;
    return file!;
  }
}

final photoFileCacheProvider = AsyncNotifierProvider.family
    .autoDispose<_PhotoFileCacheNotifier, File, AssetEntity>(
  _PhotoFileCacheNotifier.new,
);

/// 写真カードリスト
class PhotoCard extends HookConsumerWidget {
  const PhotoCard({required this.photos, required this.controller, super.key});

  final List<AssetEntity> photos;
  final AppinioSwiperController controller;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Tinder風スワイプウィジェット
    return AppinioSwiper(
      backgroundCardCount: 2,
      backgroundCardOffset: const Offset(8, 14),
      backgroundCardScale: 0.98,
      controller: controller,
      cardCount: photos.length,
      onSwipeEnd: (
        previousIndex,
        targetIndex,
        activity,
      ) {
        // スワイプ完了イベント
        switch (activity) {
          case Swipe():
            // 左にスワイプしても右にスワイプしてもSwipeになる？のでoffsetから判定
            ref.read(photoListProvider.notifier).loadNext(
                  isFood: activity.currentOffset.dx > 0,
                  index: previousIndex,
                );
          case Unswipe():
          case CancelSwipe():
          case DrivenActivity():
        }
      },
      cardBuilder: (context, index) {
        return _PhotoCard(
          photo: photos[index],
        );
      },
    );
  }
}

/// 写真カード
class _PhotoCard extends ConsumerWidget {
  const _PhotoCard({
    required this.photo,
  });

  /// 写真データ
  final AssetEntity photo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(photoFileCacheProvider(photo)).when(
          data: (file) {
            return SizedBox.expand(
              child: Card(
                color: Colors.white,
                margin: const EdgeInsets.only(
                  left: 8,
                  top: 12,
                  right: 8,
                  bottom: 8,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(
                    width: 2,
                    color: Themes.gray.shade900,
                  ),
                ),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: FractionallySizedBox(
                  alignment: Alignment.topCenter,
                  heightFactor: 0.85,
                  child: Card(
                    color: Colors.white,
                    margin: const EdgeInsets.all(20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(
                        width: 2,
                        color: Themes.gray.shade900,
                      ),
                    ),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: Image.file(
                      key: ObjectKey(file.path),
                      file,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            );
          },
          error: (error, stackTrace) {
            final style = TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Themes.gray.shade500,
            );
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () =>
                      ref.read(photoListProvider.notifier).forceRefresh(),
                  icon: Icon(Icons.refresh, color: Themes.gray.shade500),
                ),
                Text('エラーが発生しました。', style: style),
              ],
            );
          },
          loading: () => const CircularProgressIndicator(),
        );
  }
}
