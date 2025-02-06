import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../core/widgets/confirm_dialog.dart';
import '../../core/widgets/success_snack_bar.dart';
import 'auth_controller.dart';

/// マイページ
class MyPage extends ConsumerWidget {
  const MyPage({super.key});

  static const routeName = 'my_page';
  static const routePath = '/my_page';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      // サインインのリスト部分の設定
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(top: 160),
                children: [
                  ListTile(
                    onTap: () async {
                      await ConfirmDialog.show(
                        context,
                        hasCancelButton: true,
                        titleString: '本当にアカウントを削除しますか？',
                        contentString: 'この操作はもとに戻せません。',
                        positiveButtonString: '削除',
                        isDestructiveAction: true,
                        onConfirmed: () async {
                          await ref
                              .read(authControllerProvider)
                              .deleteUserAccount();
                          if (context.mounted) {
                            CommonSnackBar.show(
                              context,
                              message: 'アカウントを削除しました',
                            );
                          }
                        },
                      );
                    },
                    title: const Text(
                      'アカウントを削除',
                      style: TextStyle(color: Themes.errorAlertColor),
                    ),
                  ),
                  const Divider(
                    thickness: 1,
                    indent: 20,
                    endIndent: 20,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
