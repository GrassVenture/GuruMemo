import 'dart:io';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'camera_state.freezed.dart';
part 'camera_state.g.dart';

@freezed
class CameraState with _$CameraState {
  const factory CameraState({
    ///初期化フラグ
    @Default(false) bool isInitialized,

    ///撮影した画像のパス
    String? capturedImagePath,

    /// 画像の緯度
    double? latitude,

    /// 画像の経度
    double? longitude,

    /// 撮影中のフラグ
    @Default(false) bool isTakingPicture,
  }) = _CameraState;

  const CameraState._();

  /// JSONから`CameraState`インスタンスを生成
  factory CameraState.fromJson(Map<String, dynamic> json) =>
      _$CameraStateFromJson(json);
}
