import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../core/build_context_extension.dart';
import '../../core/themes.dart';

class AppElevatedButton extends StatelessWidget {
  const AppElevatedButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.widget,
    this.backgroundColor,
    this.borderColor,
    this.textColor,
    this.width,
    this.height,
  });

  /// ボタンのテキスト
  final String text;

  /// onPressed
  final VoidCallback onPressed;

  /// テキストの隣に置くWidget
  final Widget? widget;

  /// 背景色
  final Color? backgroundColor;

  /// 枠線の色
  final Color? borderColor;

  /// textの色
  final Color? textColor;

  /// ボタンのサイズ(正方形にしたいときなどに指定)
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    double backgroundHeight() {
      if (height != null) {
        return height! - 8;
      } else {
        return 48;
      }
    }

    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? 48,
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Row(
            children: [
              const Gap(8),
              Expanded(
                child: Container(
                  height: backgroundHeight(),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    color: backgroundColor ?? Themes.mainOrange,
                  ),
                ),
              ),
            ],
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              border: Border.all(
                color: borderColor ?? Themes.gray.shade900,
                width: 2,
              ),
            ),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (widget != null) ...[widget!, const Gap(8)],
                  Text(
                    text,
                    style: context.textTheme.labelLarge!.copyWith(
                      color: textColor ?? Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (widget != null) const Gap(8),
                ],
              ),
            ),
          ),
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onPressed,
                borderRadius: BorderRadius.circular(40),
                splashColor: Themes.mainOrange.withValues(alpha: 0.3),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
