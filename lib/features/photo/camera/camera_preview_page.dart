import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../core/themes.dart';
import '../../../core/permission/permission_handler.dart';
import '../../../core/widgets/app_elevated_button.dart';
import '../gallery/gallery_page.dart';
import '../local_photo_repository.dart';
import 'camera_controller.dart';

class CameraPreviewPage extends HookConsumerWidget {
  const CameraPreviewPage({super.key, required this.imagePath});

  final String imagePath;

  static const routeName = 'camera_preview_page';
  static const routePath = '/camera_preview_page';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final permissionHandler = ref.read(permissionHandlerProvider);

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
                      File(imagePath),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const Gap(92),
              AppElevatedButton(
                text: 'この写真を追加',
                onPressed: () async {
                  final granted = await permissionHandler.requestPermissions([
                    Permission.camera,
                    Permission.microphone,
                    Permission.location,
                    Permission.photos
                  ]);

                  if (!granted) {
                    return;
                  }

                  await ref
                      .read(localPhotoRepositoryProvider)
                      .savePhotoByImagePath(imagePath);
                  unawaited(ref
                      .read(classifyLatestPhotoNotifierProvider.notifier)
                      .classifyPhotoAsFood());
                  if (!context.mounted) {
                    return;
                  }
                  context.go(GalleryPage.routePath);
                },
                widget: const Icon(Icons.camera_alt, color: Colors.white),
              ),
              const Gap(12),
              TextButton(
                onPressed: () {
                  context.pop();
                },
                style: TextButton.styleFrom(
                  backgroundColor: Colors.white,
                  minimumSize: const Size(76, 32),
                  shape: const RoundedRectangleBorder(),
                ),
                child: const Text(
                  '撮り直す',
                  style: TextStyle(color: Themes.mainOrange),
                ),
              ),
              const Gap(64),
            ],
          ),
        ),
      ),
    );
  }
}
