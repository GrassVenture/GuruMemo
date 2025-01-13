import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/build_context_extension.dart';
import '../../../core/exception.dart';
import '../../../core/themes.dart';
import '../../../core/widgets/cards/photo_card.dart';
import '../../../core/widgets/custom_elevated_button.dart';
import 'swipe_photo_controller.dart';

/// 写真スワイプページ
class SwipePhotoPage extends HookConsumerWidget {
  const SwipePhotoPage({super.key});

  static const routeName = 'swipe_photo_page';
  static const routePath = '/swipe_photo_page';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /// スワイプ用のコントローラー
    final swiperController = useMemoized(AppinioSwiperController.new);

    /// 完了アニメーション用のコントローラー
    final confettiController = useMemoized(
      () => ConfettiController(duration: const Duration(seconds: 5)),
    );

    /// アニメーションを行うかどうか
    /// 既にスワイプ完了していたらアニメーションを行わない
    final isAnimation = useState(false);

    /// スワイプ可能かどうか
    final isSwipe = useState(true);

    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            const Gap(8),
            _buildCount(ref),
            Expanded(
              child: _buildPhotoContainer(
                ref,
                context,
                swiperController,
                confettiController,
                isAnimation,
                isSwipe,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// カウント数
  Widget _buildCount(WidgetRef ref) {
    final photoCount = ref.watch(photoCountProvider);
    return photoCount != null
        ? Center(
            child: Text(
              '${photoCount.current}枚 / ${photoCount.total}枚',
              style: const TextStyle(fontSize: 18),
            ),
          )
        : const SizedBox.shrink();
  }

  /// 写真表示
  Widget _buildPhotoContainer(
    WidgetRef ref,
    BuildContext context,
    AppinioSwiperController swiperController,
    ConfettiController confettiController,
    ValueNotifier<bool> isAnimation,
    ValueNotifier<bool> isSwipe,
  ) {
    return Center(
      // 写真リスト監視
      child: ref.watch(photoListProvider).when(
            data: (photos) {
              if (photos.isEmpty) {
                return _buildComplete(
                  context,
                  ref,
                  confettiController,
                  isAnimation.value,
                );
              }

              isAnimation.value = true;

              return Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 8,
                      right: 8,
                      bottom: 32,
                    ),
                    child: PhotoCard(
                      controller: swiperController,
                      photos: photos,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    child: _buildButtons(context, swiperController, isSwipe),
                  ),
                ],
              );
            },
            error: (error, _) => _buildError(context, ref, error),
            loading: _buildLoading,
          ),
    );
  }

  /// スワイプボタン
  Widget _buildButtons(
    BuildContext context,
    AppinioSwiperController swiperController,
    ValueNotifier<bool> isSwipe,
  ) {
    return SizedBox(
      width: context.screenWidth,
      height: 210,
      child: Padding(
        padding: const EdgeInsets.only(left: 8, top: 16, right: 8, bottom: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              fit: FlexFit.tight,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(28),
                child: ColoredBox(
                  color: Colors.white,
                  child: CustomElevatedButton(
                    onPressed: () => _guardSwipe(
                      swiperController.swipeLeft,
                      isSwipe,
                    ),
                    text: 'ちがう',
                    backgroundColor: Themes.gray.shade200,
                    textColor: Themes.gray.shade900,
                    height: 56,
                    width: 180,
                    widget: Icon(
                      Icons.close,
                      color: Themes.gray.shade900,
                    ),
                  ),
                ),
              ),
            ),
            const Gap(32),
            Flexible(
              fit: FlexFit.tight,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(28),
                child: ColoredBox(
                  color: Colors.white,
                  child: CustomElevatedButton(
                    onPressed: () => _guardSwipe(
                      swiperController.swipeRight,
                      isSwipe,
                    ),
                    text: 'グルメ',
                    backgroundColor: Themes.mainOrange,
                    textColor: Colors.white,
                    height: 56,
                    width: 180,
                    widget: Image.asset(
                      'assets/images/gourmet.png',
                      width: 32,
                      height: 32,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 処理完了
  Widget _buildComplete(
    BuildContext context,
    WidgetRef ref,
    ConfettiController confettiController,
    bool isAnimation,
  ) {
    final text = Text(
      '全ての写真を分類しました！',
      style: context.textTheme.titleMedium,
    );

    if (isAnimation) {
      if (confettiController.state.name == 'stopped') {
        confettiController.play();
      }
      return Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              blastDirection: 0,
              emissionFrequency: 0.2,
              minimumSize: const Size(10, 10),
              maximumSize: const Size(50, 50),
              numberOfParticles: 1,
              colors: [
                Themes.mainOrange,
                Themes.mainOrange.shade50,
                Themes.mainOrange.shade100,
                Themes.gray,
                Themes.gray.shade200,
                Themes.gray.shade400,
              ], // manually specify the colors to be used
            ),
          ),
          text,
          Positioned(
            bottom: context.screenHeight * 0.25,
            child: Column(
              children: [
                Text(
                  '追加された写真',
                  style: context.textTheme.bodyMedium
                      ?.copyWith(color: Themes.gray.shade400),
                ),
                const Gap(8),
                ref.watch(foodPhotoTotalProvider).when(
                      data: (count) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.add,
                              color: Themes.mainOrange,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 16, bottom: 2),
                              child: Text(
                                '$count 枚',
                                style:
                                    context.textTheme.headlineSmall?.copyWith(
                                  color: Themes.mainOrange,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                      error: (error, _) => _buildError(context, ref, error),
                      loading: _buildLoading,
                    ),
              ],
            ),
          ),
        ],
      );
    }

    return Center(
      child: text,
    );
  }

  /// エラー
  Widget _buildError(BuildContext context, WidgetRef ref, Object error) {
    if (error is PermissionException) {
      return Text('権限がありません。', style: context.textTheme.titleMedium);
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: () => ref.read(photoListProvider.notifier).forceRefresh(),
          icon: Icon(Icons.refresh, color: Themes.gray.shade500),
        ),
        Text('エラーが発生しました。', style: context.textTheme.titleMedium),
      ],
    );
  }

  /// ローディング
  Widget _buildLoading() => const CircularProgressIndicator();

  /// スワイプボタン連打防止
  Future<void> _guardSwipe(
    Future<void> Function() execute,
    ValueNotifier<bool> isSwipe,
  ) async {
    if (isSwipe.value) {
      isSwipe.value = false;
      await execute();
      await Future<void>.delayed(
        const Duration(milliseconds: 300),
      );
      isSwipe.value = true;
    }
  }
}
