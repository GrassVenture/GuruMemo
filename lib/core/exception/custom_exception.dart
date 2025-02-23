import 'exception_code.dart';

abstract class CustomException implements Exception {
  const CustomException(
    this.exceptionCode, {
    this.info,
  });

  final ExceptionCode exceptionCode;
  final dynamic info;

  @override
  String toString() {
    return 'CustomException{exceptionCode: ${exceptionCode.exceptionCode}, '
        'title: ${exceptionCode.exceptionTitle}, '
        'message: ${exceptionCode.exceptionMessage}, info: $info}';
  }
}
