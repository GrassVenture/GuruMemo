import 'package:flutter/material.dart';
import '../../../core/themes.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ElevatedButton(
        onPressed: () {
          // ログアウト処理を追加
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Themes.mainOrange,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          side: const BorderSide(width: 2),
          textStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
        ),
        child: const Text('ログアウト'),
      ),
    );
  }
}
