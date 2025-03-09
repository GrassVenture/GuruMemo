import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../widgets/app_snack_bar.dart';

part 'permission_handler.g.dart';

class PermissionHandler {
  PermissionHandler._();

  Future<bool> _requestPermission(Permission permission) async {
    final status = await permission.status;

    if (status.isGranted) {
      return true;
    }

    if (status.isPermanentlyDenied) {
      AppSnackBar.show(
        message: '設定から権限を許可してください。',
        actionLabel: '設定を開く',
        onActionPressed: () async {
          await openAppSettings();
        },
      );
      return false;
    }

    final result = await permission.request();
    if (result.isPermanentlyDenied) {
      AppSnackBar.show(
        message: '設定から権限を許可してください。',
        actionLabel: '設定を開く',
        onActionPressed: () async {
          await openAppSettings();
        },
      );
      return false;
    }
    return result.isGranted;
  }

  Future<bool> requestPermissions(List<Permission> permissions) async {
    for (final permission in permissions) {
      final granted = await _requestPermission(permission);
      if (!granted) {
        return false;
      }
    }
    return true;
  }
}

@riverpod
PermissionHandler permissionHandler(Ref ref) {
  return PermissionHandler._();
}
