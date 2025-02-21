import 'package:collection/collection.dart';
import 'custom_exception.dart';

import 'exception_code.dart';

class PermissionException extends CustomException {
  const PermissionException(
    PermissionExceptionCode super.exceptionCode, {
    super.info,
  });

  // factoryでExceptionから生成する
  factory PermissionException.fromCode(String exceptionCode) {
    final exceptionInfo = PermissionExceptionCode.fromCode(exceptionCode);
    // 取得に失敗した場合、一律permissionExceptionとする
    if (exceptionInfo == null) {
      throw const PermissionException(
        PermissionExceptionCode.permissionException,
      );
    }
    return PermissionException(exceptionInfo);
  }
}

/// PermissionException共通エラーコード
enum PermissionExceptionCode implements ExceptionCode {
  permissionException(
    'EX001',
    '',
    '権限エクセプションが発生しました。アプリの権限設定を確認してください。',
  ),
  localStoragePermissionException(
    'EX002',
    '',
    'ローカルストレージ権限エクセプションが発生しました。アプリの権限設定を確認してください。',
  ),
  ;

  const PermissionExceptionCode(
    this._exceptionCode,
    this._exceptionTitle,
    this._exceptionMessage,
  );

  final String _exceptionCode;

  final String _exceptionTitle;

  final String _exceptionMessage;

  @override
  String get exceptionCode => _exceptionCode;

  @override
  String get exceptionTitle => _exceptionTitle;

  @override
  String get exceptionMessage => _exceptionMessage;

  static PermissionExceptionCode? fromCode(String exceptionCode) => values
      .firstWhereOrNull((element) => element.exceptionCode == exceptionCode);
}
