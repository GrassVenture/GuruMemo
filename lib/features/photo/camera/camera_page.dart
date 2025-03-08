import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../core/permission/permission_handler.dart';
import 'camera_preview_page.dart';

class CameraPage extends HookConsumerWidget {
  const CameraPage({super.key});

  static const routeName = 'camera_page';
  static const routePath = '/camera_page';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final permissionHandler = ref.read(permissionHandlerProvider);
    final imagePicker = useMemoized(ImagePicker.new);

    useEffect(() {
      Future(() async {
        if (!await permissionHandler.requestPermissions([
          Permission.camera,
          Permission.photos,
        ])) {
          if (context.mounted) {
            context.pop(); // 権限なしなら戻る
          }
          return;
        }

        final image = await imagePicker.pickImage(source: ImageSource.camera);

        if (context.mounted) {
          if (image != null) {
            await context.pushNamed(
              CameraPreviewPage.routeName,
              extra: image.path,
            );
          } else {
            context.pop(); // ユーザーがキャンセルした場合、戻る
          }
        }
      });

      return null;
    }, []);

    return const Scaffold(
      backgroundColor: Colors.black,
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
