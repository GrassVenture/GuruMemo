import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// TODO(kim): アナリティクスマージ後にコメントアウトを解除
// import '../../core/analytics/analytics_service.dart';
import '../../core/themes.dart';
import '../photo/swipe_photo/swipe_photo_page.dart';
import 'auth_controller.dart';

/// サインインページ
class SignInPage extends HookConsumerWidget {
  const SignInPage({super.key});

  static const routeName = 'sign_in_page';
  static const routePath = '/sign_in_page';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // State Hookを使用して、UIがリビルドされても状態を保持する
    final isLoading = useState(false);

    return Scaffold(
      body: ColoredBox(
        color: Themes.mainOrange,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Gap(160),
            const Spacer(),
            Image.asset(
              'assets/images/sign_in/sign_in_icon.png',
              width: 300,
              height: 300,
            ),
            const Gap(60),
            const Spacer(),
            // Googleで続けるボタン
            _buildSignInButton(
              isLoading: isLoading,
              context: context,
              ref: ref,
              label: 'Googleで続ける',
              iconPath: 'assets/images/sign_in/google_icon.png',
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              signInMethod: ref.read(authControllerProvider).signInWithGoogle,
            ),
            const Gap(20),
            // Appleで続けるボタン
            _buildSignInButton(
              isLoading: isLoading,
              context: context,
              ref: ref,
              label: 'Appleで続ける',
              iconPath: 'assets/images/sign_in/apple_icon.png',
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              signInMethod: ref.read(authControllerProvider).signInWithApple,
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  /// サインインボタンの共通化メソッド
  Widget _buildSignInButton({
    required ValueNotifier<bool> isLoading,
    required BuildContext context,
    required WidgetRef ref,
    required String label,
    required String iconPath,
    required Color backgroundColor,
    required Color foregroundColor,
    required Future<void> Function() signInMethod,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ElevatedButton.icon(
        onPressed: isLoading.value
            ? () {}
            : () => _handleSignIn(isLoading, signInMethod, context, ref),
        icon: Image.asset(
          iconPath,
          width: 24,
        ),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          minimumSize: const Size(double.infinity, 50),
        ),
      ),
    );
  }

  /// サインイン処理の共通化
  Future<void> _handleSignIn(
    ValueNotifier<bool> isLoading,
    Future<void> Function() signIn,
    BuildContext context,
    WidgetRef ref,
  ) async {
    try {
      isLoading.value = true;
      await signIn();
      if (!context.mounted) {
        return;
      }
      GoRouter.of(context).go(SwipePhotoPage.routePath);
    } on Exception catch (e) {
      _showSnackBar(context, 'サインインに失敗しました: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// スナックバーの表示
  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.black,
      ),
    );
  }
}
