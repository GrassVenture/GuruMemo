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
  ///初期化フラグ
  bool get isInitialized => throw _privateConstructorUsedError;

  ///撮影した画像のパス
  String? get capturedImagePath => throw _privateConstructorUsedError;

  /// 画像の緯度
  double? get latitude => throw _privateConstructorUsedError;

  /// 画像の経度
  double? get longitude => throw _privateConstructorUsedError;

  /// 撮影中のフラグ
  bool get isTakingPicture => throw _privateConstructorUsedError;

  /// Serializes this CameraState to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CameraState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
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
      {bool isInitialized,
      String? capturedImagePath,
      double? latitude,
      double? longitude,
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

  /// Create a copy of CameraState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isInitialized = null,
    Object? capturedImagePath = freezed,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? isTakingPicture = null,
  }) {
    return _then(_value.copyWith(
      isInitialized: null == isInitialized
          ? _value.isInitialized
          : isInitialized // ignore: cast_nullable_to_non_nullable
              as bool,
      capturedImagePath: freezed == capturedImagePath
          ? _value.capturedImagePath
          : capturedImagePath // ignore: cast_nullable_to_non_nullable
              as String?,
      latitude: freezed == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double?,
      longitude: freezed == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double?,
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
      {bool isInitialized,
      String? capturedImagePath,
      double? latitude,
      double? longitude,
      bool isTakingPicture});
}

/// @nodoc
class __$$CameraStateImplCopyWithImpl<$Res>
    extends _$CameraStateCopyWithImpl<$Res, _$CameraStateImpl>
    implements _$$CameraStateImplCopyWith<$Res> {
  __$$CameraStateImplCopyWithImpl(
      _$CameraStateImpl _value, $Res Function(_$CameraStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of CameraState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isInitialized = null,
    Object? capturedImagePath = freezed,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? isTakingPicture = null,
  }) {
    return _then(_$CameraStateImpl(
      isInitialized: null == isInitialized
          ? _value.isInitialized
          : isInitialized // ignore: cast_nullable_to_non_nullable
              as bool,
      capturedImagePath: freezed == capturedImagePath
          ? _value.capturedImagePath
          : capturedImagePath // ignore: cast_nullable_to_non_nullable
              as String?,
      latitude: freezed == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double?,
      longitude: freezed == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double?,
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
      {this.isInitialized = false,
      this.capturedImagePath,
      this.latitude,
      this.longitude,
      this.isTakingPicture = false})
      : super._();

  factory _$CameraStateImpl.fromJson(Map<String, dynamic> json) =>
      _$$CameraStateImplFromJson(json);

  ///初期化フラグ
  @override
  @JsonKey()
  final bool isInitialized;

  ///撮影した画像のパス
  @override
  final String? capturedImagePath;

  /// 画像の緯度
  @override
  final double? latitude;

  /// 画像の経度
  @override
  final double? longitude;

  /// 撮影中のフラグ
  @override
  @JsonKey()
  final bool isTakingPicture;

  @override
  String toString() {
    return 'CameraState(isInitialized: $isInitialized, capturedImagePath: $capturedImagePath, latitude: $latitude, longitude: $longitude, isTakingPicture: $isTakingPicture)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CameraStateImpl &&
            (identical(other.isInitialized, isInitialized) ||
                other.isInitialized == isInitialized) &&
            (identical(other.capturedImagePath, capturedImagePath) ||
                other.capturedImagePath == capturedImagePath) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.isTakingPicture, isTakingPicture) ||
                other.isTakingPicture == isTakingPicture));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, isInitialized, capturedImagePath,
      latitude, longitude, isTakingPicture);

  /// Create a copy of CameraState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
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
      {final bool isInitialized,
      final String? capturedImagePath,
      final double? latitude,
      final double? longitude,
      final bool isTakingPicture}) = _$CameraStateImpl;
  const _CameraState._() : super._();

  factory _CameraState.fromJson(Map<String, dynamic> json) =
      _$CameraStateImpl.fromJson;

  ///初期化フラグ
  @override
  bool get isInitialized;

  ///撮影した画像のパス
  @override
  String? get capturedImagePath;

  /// 画像の緯度
  @override
  double? get latitude;

  /// 画像の経度
  @override
  double? get longitude;

  /// 撮影中のフラグ
  @override
  bool get isTakingPicture;

  /// Create a copy of CameraState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CameraStateImplCopyWith<_$CameraStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
