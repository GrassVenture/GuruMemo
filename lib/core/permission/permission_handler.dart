import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../widgets/app_snack_bar.dart';

part 'permission_handler.g.dart';

/// 権限管理クラス
///
/// アプリで必要な権限をリクエストし、ユーザーの許可状況を確認するためのユーティリティクラス。
/// ユーザーが権限を拒否した場合、スナックバーで設定画面へ誘導する。
class PermissionHandler {
  PermissionHandler._();

  /// 指定された権限をリクエストする。
  ///
  /// - すでに許可されている場合は `true` を返す。
  /// - 永久に拒否されている場合は、設定画面を開くようユーザーに促し `false` を返す。
  /// - リクエスト後に許可された場合は `true`、拒否された場合は `false` を返す。
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
    if (result.isPermanentlyDenied ||
        result.isDenied ||
        result.isRestricted ||
        result.isLimited) {
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

  /// 複数の権限をリクエストする。
  ///
  /// - すべての権限が許可された場合は `true` を返す。
  /// - いずれかの権限が拒否された場合は `false` を返す。
  ///
  /// ### 引数
  /// - `permissions` : リクエストする権限のリスト。
  ///   各権限は `permission_handler` パッケージの `Permission` クラスを使用する。
  ///   例: `[Permission.camera, Permission.microphone]`
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

/// [PermissionHandler]用プロバイダー
@riverpod
PermissionHandler permissionHandler(Ref ref) {
  return PermissionHandler._();
}
