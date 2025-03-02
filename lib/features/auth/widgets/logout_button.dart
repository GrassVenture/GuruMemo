import 'package:flutter/material.dart';

import '../../../core/themes.dart';
import '../../../core/widgets/app_elevated_button.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: AppElevatedButton(
        text: 'ログアウト',
        onPressed: () {
          // ログアウト処理を追加
        },
        backgroundColor: Themes.mainOrange,
        borderColor: Themes.gray.shade900,
        textColor: Colors.white,
        height: 50,
      ),
    );
  }
}
