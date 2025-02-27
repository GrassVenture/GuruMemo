import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'widgets/delete_account_button.dart';
import 'widgets/logout_button.dart';

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
        child: const Column(
          children: [
            SizedBox(height: 160),
            LogoutButton(),
            SizedBox(height: 20),
            DeleteAccountButton(),
          ],
        ),
      ),
    );
  }
}
