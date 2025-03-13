import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/themes.dart';
import '../../features/auth/my_page.dart';
import '../../features/photo/gallery/gallery_page.dart';
import '../../features/photo/photo_picker/photo_picker_page.dart';
import '../../features/photo/swipe_photo/swipe_photo_controller.dart';

part 'navigation_frame.g.dart';

/// [BottomNavigationBar]を用いてページ遷移を管理するクラス
class NavigationFrame extends HookConsumerWidget {
  const NavigationFrame({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(selectedIndexProvider);

    final isClassifyOnboardingCompleted =
        ref.watch(isClassifyOnboardingCompletedNotifierProvider);

    final itemWidth = MediaQuery.of(context).size.width / 3;
    final circleWidth = itemWidth * 0.8;

    return Scaffold(
      body: child,
      bottomNavigationBar: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Themes.gray.shade900,
            width: 2,
            strokeAlign: BorderSide.strokeAlignOutside,
          ),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 4, bottom: 16),
            child: Stack(
              children: [
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 400),
                  curve: StickyCurve(), // カスタムCurveを使用
                  left:
                      selectedIndex * itemWidth + (itemWidth - circleWidth) / 2,
                  child: Container(
                    width: circleWidth,
                    height: 72,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(36),
                      color: Themes.mainOrange,
                      border: Border.all(
                        color: Themes.gray.shade900,
                        width: 2,
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildNavItem(
                      icon: Icons.photo,
                      label: 'ギャラリー',
                      index: 0,
                      context: context,
                      isClassifyOnboardingCompleted:
                          isClassifyOnboardingCompleted,
                      ref: ref,
                    ),
                    _buildNavItem(
                      icon: Icons.add,
                      label: '写真を追加',
                      index: 1,
                      context: context,
                      isClassifyOnboardingCompleted:
                          isClassifyOnboardingCompleted,
                      ref: ref,
                    ),
                    _buildNavItem(
                      icon: Icons.person,
                      label: 'マイページ',
                      index: 2,
                      context: context,
                      isClassifyOnboardingCompleted:
                          isClassifyOnboardingCompleted,
                      ref: ref,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
    required BuildContext context,
    required bool isClassifyOnboardingCompleted,
    required WidgetRef ref,
  }) {
    final selectedIndex = ref.watch(selectedIndexProvider);
    final isSelected = index == selectedIndex;
    final itemWidth = MediaQuery.of(context).size.width / 3;
    final circleWidth = itemWidth * 0.8;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          ref.read(selectedIndexProvider.notifier).updateIndex(index);
          _onItemTapped(index, context, isClassifyOnboardingCompleted);
        },
        splashColor: Themes.mainOrange.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(36),
        child: SizedBox(
          width: itemWidth,
          height: 72,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: circleWidth,
                height: 72,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder:
                        (Widget child, Animation<double> animation) {
                      return FadeTransition(opacity: animation, child: child);
                    },
                    child: Icon(
                      icon,
                      key: ValueKey<bool>(isSelected),
                      color: isSelected ? Colors.white : Themes.gray[900],
                    ),
                  ),
                  const Gap(4),
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 300),
                    style: TextStyle(
                      color: isSelected ? Colors.white : Themes.gray[900],
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                    child: Text(label),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onItemTapped(
    int index,
    BuildContext context,
    bool isClassifyOnboardingCompleted,
  ) {
    switch (index) {
      case 0:
        context.go(GalleryPage.routePath);
      case 1:
        context.push(PhotoPickerPage.routePath);
      case 2:
        context.go(MyPage.routePath);
    }
  }
}

class StickyCurve extends Curve {
  @override
  double transform(double t) {
    if (t < 0.5) {
      return 4 * t * t * t;
    } else {
      return 1 - math.pow(-2 * t + 2, 3) / 2;
    }
  }
}

/// アプリのボトムナビゲーションの[SelectedIndex]を管理するプロバイダー。
///
/// NavigationFrameのシェルルート外からシェルルート内に画面遷移する際にも、
/// [SelectedIndex]を変更できるようにするため、実装している。
///
/// ### 初期値:
/// - `0`（ボトムナビゲーションバーの一番左の項目が初期選択状態）
///
/// ### 更新方法:
/// - `updateIndex(int newIndex)` を呼び出して新しいインデックスを設定する。
@riverpod
class SelectedIndex extends _$SelectedIndex {
  @override
  int build() => 0;

  /// [SelectedIndex]の値を更新する
  Future<void> updateIndex(int newIndex) async {
    state = newIndex;
  }
}
