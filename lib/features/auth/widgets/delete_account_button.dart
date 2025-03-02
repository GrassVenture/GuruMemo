import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/services/analytics_service.dart';
import '../../../core/themes.dart';
import '../../../core/widgets/app_dialog.dart';
import '../../../core/widgets/app_snack_bar.dart';
import '../auth_controller.dart';

class DeleteAccountButton extends ConsumerWidget {
  const DeleteAccountButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: TextButton(
          onPressed: () async {
            await AppDialog.show(
              context,
              hasCancelButton: true,
              titleString: '本当にアカウントを削除しますか？',
              contentString: 'この操作はもとに戻せません。',
              positiveButtonString: '削除',
              isDestructiveAction: true,
              onConfirmed: () async {
                ref
                    .read(analyticsServiceProvider)
                    .sendEvent(name: 'delete_account');
                // アカウントが削除された後、ログイン画面へリダイレクトされる
                await ref.read(authControllerProvider).deleteUserAccount();
                AppSnackBar.show(message: 'アカウントを削除しました');
              },
            );
          },
          child: Text(
            'アカウントを削除',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontSize: 18,
                  color: Themes.errorAlertColor,
                ),
          ),
        ),
      ),
    );
  }
}
