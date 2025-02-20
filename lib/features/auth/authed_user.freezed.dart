// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'authed_user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AuthedUser _$AuthedUserFromJson(Map<String, dynamic> json) {
  return _AuthedUser.fromJson(json);
}

/// @nodoc
mixin _$AuthedUser {
  /// firestore上のドキュメントID
  String get id => throw _privateConstructorUsedError;

  /// 作成日時
  @timestampConverter
  UnionTimestamp get createdAt => throw _privateConstructorUsedError;

  /// 更新日時
  @serverTimestampConverter
  UnionTimestamp get updatedAt => throw _privateConstructorUsedError;

  /// 写真分類用APIの実行状態
  @ClassifyPhotosStatusConverter()
  ClassifyPhotosStatus get classifyPhotosStatus =>
      throw _privateConstructorUsedError;

  /// Serializes this AuthedUser to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AuthedUser
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AuthedUserCopyWith<AuthedUser> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthedUserCopyWith<$Res> {
  factory $AuthedUserCopyWith(
          AuthedUser value, $Res Function(AuthedUser) then) =
      _$AuthedUserCopyWithImpl<$Res, AuthedUser>;
  @useResult
  $Res call(
      {String id,
      @timestampConverter UnionTimestamp createdAt,
      @serverTimestampConverter UnionTimestamp updatedAt,
      @ClassifyPhotosStatusConverter()
      ClassifyPhotosStatus classifyPhotosStatus});

  $UnionTimestampCopyWith<$Res> get createdAt;
  $UnionTimestampCopyWith<$Res> get updatedAt;
}

/// @nodoc
class _$AuthedUserCopyWithImpl<$Res, $Val extends AuthedUser>
    implements $AuthedUserCopyWith<$Res> {
  _$AuthedUserCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AuthedUser
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? classifyPhotosStatus = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as UnionTimestamp,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as UnionTimestamp,
      classifyPhotosStatus: null == classifyPhotosStatus
          ? _value.classifyPhotosStatus
          : classifyPhotosStatus // ignore: cast_nullable_to_non_nullable
              as ClassifyPhotosStatus,
    ) as $Val);
  }

  /// Create a copy of AuthedUser
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UnionTimestampCopyWith<$Res> get createdAt {
    return $UnionTimestampCopyWith<$Res>(_value.createdAt, (value) {
      return _then(_value.copyWith(createdAt: value) as $Val);
    });
  }

  /// Create a copy of AuthedUser
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UnionTimestampCopyWith<$Res> get updatedAt {
    return $UnionTimestampCopyWith<$Res>(_value.updatedAt, (value) {
      return _then(_value.copyWith(updatedAt: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AuthedUserImplCopyWith<$Res>
    implements $AuthedUserCopyWith<$Res> {
  factory _$$AuthedUserImplCopyWith(
          _$AuthedUserImpl value, $Res Function(_$AuthedUserImpl) then) =
      __$$AuthedUserImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @timestampConverter UnionTimestamp createdAt,
      @serverTimestampConverter UnionTimestamp updatedAt,
      @ClassifyPhotosStatusConverter()
      ClassifyPhotosStatus classifyPhotosStatus});

  @override
  $UnionTimestampCopyWith<$Res> get createdAt;
  @override
  $UnionTimestampCopyWith<$Res> get updatedAt;
}

/// @nodoc
class __$$AuthedUserImplCopyWithImpl<$Res>
    extends _$AuthedUserCopyWithImpl<$Res, _$AuthedUserImpl>
    implements _$$AuthedUserImplCopyWith<$Res> {
  __$$AuthedUserImplCopyWithImpl(
      _$AuthedUserImpl _value, $Res Function(_$AuthedUserImpl) _then)
      : super(_value, _then);

  /// Create a copy of AuthedUser
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? classifyPhotosStatus = null,
  }) {
    return _then(_$AuthedUserImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as UnionTimestamp,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as UnionTimestamp,
      classifyPhotosStatus: null == classifyPhotosStatus
          ? _value.classifyPhotosStatus
          : classifyPhotosStatus // ignore: cast_nullable_to_non_nullable
              as ClassifyPhotosStatus,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AuthedUserImpl extends _AuthedUser {
  const _$AuthedUserImpl(
      {this.id = '',
      @timestampConverter
      this.createdAt = const UnionTimestamp.serverTimestamp(),
      @serverTimestampConverter
      this.updatedAt = const UnionTimestamp.serverTimestamp(),
      @ClassifyPhotosStatusConverter()
      this.classifyPhotosStatus = ClassifyPhotosStatus.readyForUse})
      : super._();

  factory _$AuthedUserImpl.fromJson(Map<String, dynamic> json) =>
      _$$AuthedUserImplFromJson(json);

  /// firestore上のドキュメントID
  @override
  @JsonKey()
  final String id;

  /// 作成日時
  @override
  @JsonKey()
  @timestampConverter
  final UnionTimestamp createdAt;

  /// 更新日時
  @override
  @JsonKey()
  @serverTimestampConverter
  final UnionTimestamp updatedAt;

  /// 写真分類用APIの実行状態
  @override
  @JsonKey()
  @ClassifyPhotosStatusConverter()
  final ClassifyPhotosStatus classifyPhotosStatus;

  @override
  String toString() {
    return 'AuthedUser(id: $id, createdAt: $createdAt, updatedAt: $updatedAt, classifyPhotosStatus: $classifyPhotosStatus)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthedUserImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.classifyPhotosStatus, classifyPhotosStatus) ||
                other.classifyPhotosStatus == classifyPhotosStatus));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, createdAt, updatedAt, classifyPhotosStatus);

  /// Create a copy of AuthedUser
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthedUserImplCopyWith<_$AuthedUserImpl> get copyWith =>
      __$$AuthedUserImplCopyWithImpl<_$AuthedUserImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AuthedUserImplToJson(
      this,
    );
  }
}

abstract class _AuthedUser extends AuthedUser {
  const factory _AuthedUser(
      {final String id,
      @timestampConverter final UnionTimestamp createdAt,
      @serverTimestampConverter final UnionTimestamp updatedAt,
      @ClassifyPhotosStatusConverter()
      final ClassifyPhotosStatus classifyPhotosStatus}) = _$AuthedUserImpl;
  const _AuthedUser._() : super._();

  factory _AuthedUser.fromJson(Map<String, dynamic> json) =
      _$AuthedUserImpl.fromJson;

  /// firestore上のドキュメントID
  @override
  String get id;

  /// 作成日時
  @override
  @timestampConverter
  UnionTimestamp get createdAt;

  /// 更新日時
  @override
  @serverTimestampConverter
  UnionTimestamp get updatedAt;

  /// 写真分類用APIの実行状態
  @override
  @ClassifyPhotosStatusConverter()
  ClassifyPhotosStatus get classifyPhotosStatus;

  /// Create a copy of AuthedUser
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AuthedUserImplCopyWith<_$AuthedUserImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
