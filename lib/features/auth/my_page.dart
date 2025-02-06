import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../core/services/analytics_service.dart';
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
        padding: const EdgeInsets.only(top: 50),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    onTap: () async {
                      await ConfirmDialog.show(
                        context,
                        hasCancelButton: true,
                        titleString: '注意',
                        contentString: '本当にアカウントを削除しますか？',
                        onConfirmed: () async {
                          await ref
                              .read(authControllerProvider)
                              .deleteUserAccount();
                          await ref
                              .read(analyticsServiceProvider.future)
                              .then((analyticsService) {
                            analyticsService.sendEvent(
                              name: 'delete_account',
                            );
                          });
                          if (context.mounted) {
                            SuccessSnackBar.show(
                              context,
                              message: 'アカウントを削除しました',
                            );
                          }
                        },
                      );
                    },
                    title: const Text('   アカウントを削除'),
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
