import 'package:flutter/material.dart';

import '../themes.dart';

/// 確認用のダイアログ
class AppDialog extends StatelessWidget {
  const AppDialog._({
    required this.contentString,
    required this.titleString,
    required this.negativeButtonString,
    required this.positiveButtonString,
    required this.onConfirmed,
    required this.hasCancelButton,
    required this.shouldPopOnConfirmed,
    this.isDestructiveAction = false,
  });

  /// ダイアログのタイトル
  final String titleString;

  /// ダイアログの中身
  final String contentString;

  /// 否定ボタンのテキスト
  final String negativeButtonString;

  /// 肯定ボタンテキスト
  final String positiveButtonString;

  /// 「はい」ボタン押下後の挙動
  final VoidCallback onConfirmed;

  /// 「いいえ」ボタンを表示するかどうか
  final bool hasCancelButton;

  /// [onConfirmed]完了後にダイアログを閉じるかどうか
  final bool shouldPopOnConfirmed;

  /// 破滅的な(もとに戻せない)アクションかどうか
  final bool isDestructiveAction;

  static Future<void> show(
    BuildContext context, {
    String? titleString,
    required String contentString,
    String negativeButtonString = 'キャンセル',
    String positiveButtonString = 'OK',
    required VoidCallback onConfirmed,
    bool hasCancelButton = false,
    bool shouldPopOnConfirmed = true,
    bool isDestructiveAction = false,
  }) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return AppDialog._(
          titleString: titleString ?? '',
          contentString: contentString,
          negativeButtonString: negativeButtonString,
          positiveButtonString: positiveButtonString,
          onConfirmed: onConfirmed,
          hasCancelButton: hasCancelButton,
          shouldPopOnConfirmed: shouldPopOnConfirmed,
          isDestructiveAction: isDestructiveAction,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titleTextStyle: Theme.of(context).textTheme.titleMedium,
      contentTextStyle: Theme.of(context).textTheme.bodyLarge,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      title: Center(
        child: Text(titleString),
      ),
      content: Text(contentString),
      actions: [
        if (hasCancelButton)
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              negativeButtonString,
              style: Theme.of(context)
                  .textTheme
                  .labelLarge
                  ?.copyWith(color: Themes.gray),
            ),
          ),
        TextButton(
          onPressed: () {
            onConfirmed();
            if (shouldPopOnConfirmed) {
              Navigator.of(context).pop();
            }
          },
          child: Text(
            positiveButtonString,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: isDestructiveAction
                      ? Themes.errorAlertColor
                      : Themes.mainOrange,
                ),
          ),
        ),
      ],
    );
  }
}
