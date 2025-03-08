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
import '../../../core/widgets/navigation_frame_controller.dart';
import '../gallery/gallery_page.dart';
import '../local_photo_repository.dart';
import '../photo_picker/photo_picker_page.dart';
import 'camera_controller.dart';
import 'camera_page.dart';

class CameraPreviewPage extends HookConsumerWidget {
  const CameraPreviewPage({super.key, required this.imagePath});

  final String imagePath;

  static const routeName = 'camera_preview_page';
  static const routePath = '/camera_preview_page';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final permissionHandler = ref.read(permissionHandlerProvider);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        if (didPop) {
          return;
        }
        await ref.read(selectedIndexProvider.notifier).updateIndex(1);
        if (!context.mounted) {
          return;
        }
        context.go(PhotoPickerPage.routePath);
      },
      child: Scaffold(
        appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.all(16),
            child: IconButton(
              iconSize: 24,
              icon: const Icon(
                Icons.close,
                color: Themes.gray,
              ),
              onPressed: () async {
                await ref.read(selectedIndexProvider.notifier).updateIndex(0);
                if (!context.mounted) {
                  return;
                }
                context.go(PhotoPickerPage.routePath);
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
                    await ref
                        .read(selectedIndexProvider.notifier)
                        .updateIndex(0);
                    if (!context.mounted) {
                      return;
                    }
                    context.go(GalleryPage.routePath);
                  },
                  widget: const Icon(Icons.camera_alt, color: Colors.white),
                ),
                const Gap(12),
                TextButton(
                  onPressed: () async {
                    final granted = await permissionHandler.requestPermissions([
                      Permission.camera,
                      Permission.microphone,
                    ]);
                    if (!granted || !context.mounted) {
                      return;
                    }
                    await context.push(CameraPage.routePath);
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
      ),
    );
  }
}
