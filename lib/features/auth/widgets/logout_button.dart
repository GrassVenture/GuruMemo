import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/services/analytics_service.dart';
import '../../../core/themes.dart';
import '../../../core/widgets/app_elevated_button.dart';
import '../auth_controller.dart';

class LogoutButton extends ConsumerWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: AppElevatedButton(
        text: 'ログアウト',
        onPressed: () async {
          // ログアウト処理を行い、ログイン画面へリダイレクトされる
          await ref.read(authControllerProvider).signOut();
          ref.read(analyticsServiceProvider).sendEvent(name: 'sign_out');
        },
        backgroundColor: Themes.mainOrange,
        borderColor: Themes.gray.shade900,
        textColor: Colors.white,
        height: 50,
      ),
    );
  }
}
