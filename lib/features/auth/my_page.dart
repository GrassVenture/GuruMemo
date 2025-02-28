import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'widgets/delete_account_button.dart';
import 'widgets/logout_button.dart';
import 'widgets/user_info.dart';

/// マイページ
class MyPage extends ConsumerWidget {
  const MyPage({super.key});

  static const routeName = 'my_page';
  static const routePath = '/my_page';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            UserInfo(), // ユーザー情報を表示
            SizedBox(height: 40),
            LogoutButton(), // ログアウトボタン
            SizedBox(height: 20),
            DeleteAccountButton(), // アカウント削除ボタン
          ],
        ),
      ),
    );
  }
}
