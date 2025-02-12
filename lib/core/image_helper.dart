import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import '../../core/logger.dart';

class ImageHelper {
  /// 画像を圧縮する共通メソッド
  static Future<Uint8List?> compress(File file) async {
    try {
      final result = await FlutterImageCompress.compressWithFile(
        file.absolute.path,
        minWidth: 256,
        minHeight: 256,
        quality: 85,
        keepExif: true,
      );
      return result;
    } on Exception catch (e) {
      logger.e('画像圧縮に失敗しました: $e');
      return null;
    }
  }
}
