import 'dart:io';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'camera_state.freezed.dart';
part 'camera_state.g.dart';

/// File型をサポートするためのカスタムコンバータ
class FileConverter implements JsonConverter<File?, String?> {
  const FileConverter();

  @override
  File? fromJson(String? path) => path != null ? File(path) : null;

  @override
  String? toJson(File? file) => file?.path;
}

@freezed
class CameraState with _$CameraState {
  const factory CameraState({
    /// 撮影された画像ファイル
    @FileConverter() File? capturedImage,

    /// 画像の緯度
    double? latitude,

    /// 画像の経度
    double? longitude,

    /// 撮影日時
    String? imageDate,

    /// 撮影中のフラグ
    @Default(false) bool isTakingPicture,
  }) = _CameraState;

  const CameraState._();

  /// JSONから`CameraState`インスタンスを生成
  factory CameraState.fromJson(Map<String, dynamic> json) =>
      _$CameraStateFromJson(json);
}
