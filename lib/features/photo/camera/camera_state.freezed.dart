// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'camera_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CameraState _$CameraStateFromJson(Map<String, dynamic> json) {
  return _CameraState.fromJson(json);
}

/// @nodoc
mixin _$CameraState {
  /// 撮影された画像ファイル
  @FileConverter()
  File? get capturedImage => throw _privateConstructorUsedError;

  /// 画像の緯度
  double? get latitude => throw _privateConstructorUsedError;

  /// 画像の経度
  double? get longitude => throw _privateConstructorUsedError;

  /// 撮影日時
  String? get imageDate => throw _privateConstructorUsedError;

  /// 撮影中のフラグ
  bool get isTakingPicture => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CameraStateCopyWith<CameraState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CameraStateCopyWith<$Res> {
  factory $CameraStateCopyWith(
          CameraState value, $Res Function(CameraState) then) =
      _$CameraStateCopyWithImpl<$Res, CameraState>;
  @useResult
  $Res call(
      {@FileConverter() File? capturedImage,
      double? latitude,
      double? longitude,
      String? imageDate,
      bool isTakingPicture});
}

/// @nodoc
class _$CameraStateCopyWithImpl<$Res, $Val extends CameraState>
    implements $CameraStateCopyWith<$Res> {
  _$CameraStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? capturedImage = freezed,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? imageDate = freezed,
    Object? isTakingPicture = null,
  }) {
    return _then(_value.copyWith(
      capturedImage: freezed == capturedImage
          ? _value.capturedImage
          : capturedImage // ignore: cast_nullable_to_non_nullable
              as File?,
      latitude: freezed == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double?,
      longitude: freezed == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double?,
      imageDate: freezed == imageDate
          ? _value.imageDate
          : imageDate // ignore: cast_nullable_to_non_nullable
              as String?,
      isTakingPicture: null == isTakingPicture
          ? _value.isTakingPicture
          : isTakingPicture // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CameraStateImplCopyWith<$Res>
    implements $CameraStateCopyWith<$Res> {
  factory _$$CameraStateImplCopyWith(
          _$CameraStateImpl value, $Res Function(_$CameraStateImpl) then) =
      __$$CameraStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@FileConverter() File? capturedImage,
      double? latitude,
      double? longitude,
      String? imageDate,
      bool isTakingPicture});
}

/// @nodoc
class __$$CameraStateImplCopyWithImpl<$Res>
    extends _$CameraStateCopyWithImpl<$Res, _$CameraStateImpl>
    implements _$$CameraStateImplCopyWith<$Res> {
  __$$CameraStateImplCopyWithImpl(
      _$CameraStateImpl _value, $Res Function(_$CameraStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? capturedImage = freezed,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? imageDate = freezed,
    Object? isTakingPicture = null,
  }) {
    return _then(_$CameraStateImpl(
      capturedImage: freezed == capturedImage
          ? _value.capturedImage
          : capturedImage // ignore: cast_nullable_to_non_nullable
              as File?,
      latitude: freezed == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double?,
      longitude: freezed == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double?,
      imageDate: freezed == imageDate
          ? _value.imageDate
          : imageDate // ignore: cast_nullable_to_non_nullable
              as String?,
      isTakingPicture: null == isTakingPicture
          ? _value.isTakingPicture
          : isTakingPicture // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CameraStateImpl extends _CameraState {
  const _$CameraStateImpl(
      {@FileConverter() this.capturedImage,
      this.latitude,
      this.longitude,
      this.imageDate,
      this.isTakingPicture = false})
      : super._();

  factory _$CameraStateImpl.fromJson(Map<String, dynamic> json) =>
      _$$CameraStateImplFromJson(json);

  /// 撮影された画像ファイル
  @override
  @FileConverter()
  final File? capturedImage;

  /// 画像の緯度
  @override
  final double? latitude;

  /// 画像の経度
  @override
  final double? longitude;

  /// 撮影日時
  @override
  final String? imageDate;

  /// 撮影中のフラグ
  @override
  @JsonKey()
  final bool isTakingPicture;

  @override
  String toString() {
    return 'CameraState(capturedImage: $capturedImage, latitude: $latitude, longitude: $longitude, imageDate: $imageDate, isTakingPicture: $isTakingPicture)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CameraStateImpl &&
            (identical(other.capturedImage, capturedImage) ||
                other.capturedImage == capturedImage) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.imageDate, imageDate) ||
                other.imageDate == imageDate) &&
            (identical(other.isTakingPicture, isTakingPicture) ||
                other.isTakingPicture == isTakingPicture));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, capturedImage, latitude,
      longitude, imageDate, isTakingPicture);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CameraStateImplCopyWith<_$CameraStateImpl> get copyWith =>
      __$$CameraStateImplCopyWithImpl<_$CameraStateImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CameraStateImplToJson(
      this,
    );
  }
}

abstract class _CameraState extends CameraState {
  const factory _CameraState(
      {@FileConverter() final File? capturedImage,
      final double? latitude,
      final double? longitude,
      final String? imageDate,
      final bool isTakingPicture}) = _$CameraStateImpl;
  const _CameraState._() : super._();

  factory _CameraState.fromJson(Map<String, dynamic> json) =
      _$CameraStateImpl.fromJson;

  @override

  /// 撮影された画像ファイル
  @FileConverter()
  File? get capturedImage;
  @override

  /// 画像の緯度
  double? get latitude;
  @override

  /// 画像の経度
  double? get longitude;
  @override

  /// 撮影日時
  String? get imageDate;
  @override

  /// 撮影中のフラグ
  bool get isTakingPicture;
  @override
  @JsonKey(ignore: true)
  _$$CameraStateImplCopyWith<_$CameraStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
