// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'remote_photo.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

RemotePhoto _$RemotePhotoFromJson(Map<String, dynamic> json) {
  return _RemotePhoto.fromJson(json);
}

/// @nodoc
mixin _$RemotePhoto {
  /// firestore上のドキュメントID
  String get id => throw _privateConstructorUsedError;

  /// 作成日時
  @timestampConverter
  UnionTimestamp get createdAt => throw _privateConstructorUsedError;

  /// 更新日時
  @serverTimestampConverter
  UnionTimestamp get updatedAt => throw _privateConstructorUsedError;

  /// FirebaseStorageに保存された写真の周辺店舗のIdリスト
  List<String> get areaStoreIds => throw _privateConstructorUsedError;

  /// FirebaseStorageに保存された写真のURL
  String get url => throw _privateConstructorUsedError;

  /// geminiで推論した写真のカテゴリ
  /// ここをstringではなくてenumに変換して格納しておくと、
  /// Flutter上では型安全に扱えて想定外の実行時エラーが防げるため修正したい
  String get category => throw _privateConstructorUsedError;

  /// FirebaseStorageのドキュメントID
  String get userId => throw _privateConstructorUsedError;

  /// 写真の撮影日時
  @timestampConverter
  UnionTimestamp get shotAt => throw _privateConstructorUsedError;
  String get storeId => throw _privateConstructorUsedError;

  /// Serializes this RemotePhoto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RemotePhoto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RemotePhotoCopyWith<RemotePhoto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RemotePhotoCopyWith<$Res> {
  factory $RemotePhotoCopyWith(
          RemotePhoto value, $Res Function(RemotePhoto) then) =
      _$RemotePhotoCopyWithImpl<$Res, RemotePhoto>;
  @useResult
  $Res call(
      {String id,
      @timestampConverter UnionTimestamp createdAt,
      @serverTimestampConverter UnionTimestamp updatedAt,
      List<String> areaStoreIds,
      String url,
      String category,
      String userId,
      @timestampConverter UnionTimestamp shotAt,
      String storeId});

  $UnionTimestampCopyWith<$Res> get createdAt;
  $UnionTimestampCopyWith<$Res> get updatedAt;
  $UnionTimestampCopyWith<$Res> get shotAt;
}

/// @nodoc
class _$RemotePhotoCopyWithImpl<$Res, $Val extends RemotePhoto>
    implements $RemotePhotoCopyWith<$Res> {
  _$RemotePhotoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RemotePhoto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? areaStoreIds = null,
    Object? url = null,
    Object? category = null,
    Object? userId = null,
    Object? shotAt = null,
    Object? storeId = null,
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
      areaStoreIds: null == areaStoreIds
          ? _value.areaStoreIds
          : areaStoreIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      shotAt: null == shotAt
          ? _value.shotAt
          : shotAt // ignore: cast_nullable_to_non_nullable
              as UnionTimestamp,
      storeId: null == storeId
          ? _value.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }

  /// Create a copy of RemotePhoto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UnionTimestampCopyWith<$Res> get createdAt {
    return $UnionTimestampCopyWith<$Res>(_value.createdAt, (value) {
      return _then(_value.copyWith(createdAt: value) as $Val);
    });
  }

  /// Create a copy of RemotePhoto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UnionTimestampCopyWith<$Res> get updatedAt {
    return $UnionTimestampCopyWith<$Res>(_value.updatedAt, (value) {
      return _then(_value.copyWith(updatedAt: value) as $Val);
    });
  }

  /// Create a copy of RemotePhoto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UnionTimestampCopyWith<$Res> get shotAt {
    return $UnionTimestampCopyWith<$Res>(_value.shotAt, (value) {
      return _then(_value.copyWith(shotAt: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$RemotePhotoImplCopyWith<$Res>
    implements $RemotePhotoCopyWith<$Res> {
  factory _$$RemotePhotoImplCopyWith(
          _$RemotePhotoImpl value, $Res Function(_$RemotePhotoImpl) then) =
      __$$RemotePhotoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @timestampConverter UnionTimestamp createdAt,
      @serverTimestampConverter UnionTimestamp updatedAt,
      List<String> areaStoreIds,
      String url,
      String category,
      String userId,
      @timestampConverter UnionTimestamp shotAt,
      String storeId});

  @override
  $UnionTimestampCopyWith<$Res> get createdAt;
  @override
  $UnionTimestampCopyWith<$Res> get updatedAt;
  @override
  $UnionTimestampCopyWith<$Res> get shotAt;
}

/// @nodoc
class __$$RemotePhotoImplCopyWithImpl<$Res>
    extends _$RemotePhotoCopyWithImpl<$Res, _$RemotePhotoImpl>
    implements _$$RemotePhotoImplCopyWith<$Res> {
  __$$RemotePhotoImplCopyWithImpl(
      _$RemotePhotoImpl _value, $Res Function(_$RemotePhotoImpl) _then)
      : super(_value, _then);

  /// Create a copy of RemotePhoto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? areaStoreIds = null,
    Object? url = null,
    Object? category = null,
    Object? userId = null,
    Object? shotAt = null,
    Object? storeId = null,
  }) {
    return _then(_$RemotePhotoImpl(
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
      areaStoreIds: null == areaStoreIds
          ? _value._areaStoreIds
          : areaStoreIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      shotAt: null == shotAt
          ? _value.shotAt
          : shotAt // ignore: cast_nullable_to_non_nullable
              as UnionTimestamp,
      storeId: null == storeId
          ? _value.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RemotePhotoImpl extends _RemotePhoto {
  const _$RemotePhotoImpl(
      {this.id = '',
      @timestampConverter
      this.createdAt = const UnionTimestamp.serverTimestamp(),
      @serverTimestampConverter
      this.updatedAt = const UnionTimestamp.serverTimestamp(),
      final List<String> areaStoreIds = const <String>[],
      this.url = '',
      this.category = '',
      this.userId = '',
      @timestampConverter this.shotAt = const UnionTimestamp.serverTimestamp(),
      this.storeId = ''})
      : _areaStoreIds = areaStoreIds,
        super._();

  factory _$RemotePhotoImpl.fromJson(Map<String, dynamic> json) =>
      _$$RemotePhotoImplFromJson(json);

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

  /// FirebaseStorageに保存された写真の周辺店舗のIdリスト
  final List<String> _areaStoreIds;

  /// FirebaseStorageに保存された写真の周辺店舗のIdリスト
  @override
  @JsonKey()
  List<String> get areaStoreIds {
    if (_areaStoreIds is EqualUnmodifiableListView) return _areaStoreIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_areaStoreIds);
  }

  /// FirebaseStorageに保存された写真のURL
  @override
  @JsonKey()
  final String url;

  /// geminiで推論した写真のカテゴリ
  /// ここをstringではなくてenumに変換して格納しておくと、
  /// Flutter上では型安全に扱えて想定外の実行時エラーが防げるため修正したい
  @override
  @JsonKey()
  final String category;

  /// FirebaseStorageのドキュメントID
  @override
  @JsonKey()
  final String userId;

  /// 写真の撮影日時
  @override
  @JsonKey()
  @timestampConverter
  final UnionTimestamp shotAt;
  @override
  @JsonKey()
  final String storeId;

  @override
  String toString() {
    return 'RemotePhoto(id: $id, createdAt: $createdAt, updatedAt: $updatedAt, areaStoreIds: $areaStoreIds, url: $url, category: $category, userId: $userId, shotAt: $shotAt, storeId: $storeId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RemotePhotoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            const DeepCollectionEquality()
                .equals(other._areaStoreIds, _areaStoreIds) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.shotAt, shotAt) || other.shotAt == shotAt) &&
            (identical(other.storeId, storeId) || other.storeId == storeId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      createdAt,
      updatedAt,
      const DeepCollectionEquality().hash(_areaStoreIds),
      url,
      category,
      userId,
      shotAt,
      storeId);

  /// Create a copy of RemotePhoto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RemotePhotoImplCopyWith<_$RemotePhotoImpl> get copyWith =>
      __$$RemotePhotoImplCopyWithImpl<_$RemotePhotoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RemotePhotoImplToJson(
      this,
    );
  }
}

abstract class _RemotePhoto extends RemotePhoto {
  const factory _RemotePhoto(
      {final String id,
      @timestampConverter final UnionTimestamp createdAt,
      @serverTimestampConverter final UnionTimestamp updatedAt,
      final List<String> areaStoreIds,
      final String url,
      final String category,
      final String userId,
      @timestampConverter final UnionTimestamp shotAt,
      final String storeId}) = _$RemotePhotoImpl;
  const _RemotePhoto._() : super._();

  factory _RemotePhoto.fromJson(Map<String, dynamic> json) =
      _$RemotePhotoImpl.fromJson;

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

  /// FirebaseStorageに保存された写真の周辺店舗のIdリスト
  @override
  List<String> get areaStoreIds;

  /// FirebaseStorageに保存された写真のURL
  @override
  String get url;

  /// geminiで推論した写真のカテゴリ
  /// ここをstringではなくてenumに変換して格納しておくと、
  /// Flutter上では型安全に扱えて想定外の実行時エラーが防げるため修正したい
  @override
  String get category;

  /// FirebaseStorageのドキュメントID
  @override
  String get userId;

  /// 写真の撮影日時
  @override
  @timestampConverter
  UnionTimestamp get shotAt;
  @override
  String get storeId;

  /// Create a copy of RemotePhoto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RemotePhotoImplCopyWith<_$RemotePhotoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
