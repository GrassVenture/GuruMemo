import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/widgets/app_elevated_button.dart';
import 'camera_controller.dart';
import 'camera_state.dart';

class CameraPreviewPage extends HookConsumerWidget {
  const CameraPreviewPage({super.key, required this.cameraState});

  final CameraState cameraState;

  static const routeName = 'camera_preview_page';
  static const routePath = '/camera_preview_page';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final cameraState = ref.watch(cameraStateProvider);
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(16),
          child: IconButton(
            iconSize: 24,
            icon: const Icon(
              Icons.close,
              color: Colors.grey,
            ),
            onPressed: () {
              context.pop();
            },
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(28),
                  child: ClipRRect(
                    child: Image.file(
                      File(cameraState.capturedImagePath!),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const Gap(92),
              AppElevatedButton(
                text: 'この写真を追加',
                onPressed: () {},
                widget: const Icon(Icons.camera_alt, color: Colors.white),
              ),
              const Gap(12),
              AppElevatedButton(
                text: '撮り直す',
                onPressed: () {},
                widget: const Icon(Icons.camera_alt, color: Colors.white),
              ),
              const Gap(64),
            ],
          ),
        ),
      ),
    );
  }
}
