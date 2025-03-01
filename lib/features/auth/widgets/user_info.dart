import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../core/themes.dart';
import '../auth_controller.dart';

class UserInfo extends ConsumerWidget {
  const UserInfo({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(firebaseUserProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ログイン中のアカウント',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Themes.gray.shade600,
              ),
        ),
        const Gap(15),
        Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Themes.gray.shade400,
            ),
            const Gap(16),
            Text(
              user?.email ?? '',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
      ],
    );
  }
}
