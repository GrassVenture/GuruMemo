import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionHandler extends ChangeNotifier {
  // Static instance

  factory PermissionHandler() {
    // Factory constructor to return the instance
    return _instance;
  }
  PermissionHandler._(); // Private constructor
  static final _instance = PermissionHandler._();

  final _permissionQueue = Queue<Permission>();

  Future<bool> _requestPermission(Permission permission) async {
    final status = await permission.status;

    if (status.isGranted) {
      return true;
    }

    if (status.isPermanentlyDenied) {
      await openAppSettings();
      return false;
    }

    final result = await permission.request();
    return result.isGranted;
  }

  Future<bool> _processQueue() async {
    var allGranted = true;
    while (_permissionQueue.isNotEmpty) {
      final permission = _permissionQueue.removeFirst();
      final granted = await _requestPermission(permission);
      if (!granted) {
        allGranted = false;
      }
      notifyListeners();
    }
    return allGranted;
  }

  Future<bool> requestPermissions(List<Permission> permissions) async {
    _permissionQueue.addAll(permissions);

    return _processQueue();
  }

  void refresh() {
    notifyListeners();
  }
}
