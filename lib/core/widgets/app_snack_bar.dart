import 'package:flutter/material.dart';

/// 共通SnackBar
class AppSnackBar extends SnackBar {
  AppSnackBar._({
    required String message,
    super.action,
  }) : super(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        );

  static void show(
    BuildContext context, {
    required String message,
    String? actionLabel,
    VoidCallback? onActionPressed,
  }) {
    final action = actionLabel != null && onActionPressed != null
        ? SnackBarAction(
            label: actionLabel,
            onPressed: onActionPressed,
          )
        : null;

    ScaffoldMessenger.of(context).showSnackBar(
      AppSnackBar._(message: message, action: action),
    );
  }
}
