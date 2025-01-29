// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'store.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Store _$StoreFromJson(Map<String, dynamic> json) {
  return _Store.fromJson(json);
}

/// @nodoc
mixin _$Store {
  /// firestore上のドキュメントID
  String get id => throw _privateConstructorUsedError;

  /// 作成日時
  @timestampConverter
  UnionTimestamp get createdAt => throw _privateConstructorUsedError;

  /// 更新日時
  @serverTimestampConverter
  UnionTimestamp get updatedAt => throw _privateConstructorUsedError;

  /// FirebaseStorageに保存された（ストアの）画像のURL
  List<String> get imageUrls => throw _privateConstructorUsedError;

  /// FirebaseStorageの(ストアの)name
  String get name => throw _privateConstructorUsedError;

  /// FirebaseStorageの（ストアの）電話番号
  String get phoneNumber => throw _privateConstructorUsedError;

  /// FirebaseStorageの（ストアの）URL
  String get website => throw _privateConstructorUsedError;

  /// FirebaseStorageの（ストアの）住所
  String get address => throw _privateConstructorUsedError;

  /// FirebaseStorageの（ストアの）営業時間
  Map<String, String> get openingHours => throw _privateConstructorUsedError;

  /// 写真の撮影日時
  @timestampConverter
  UnionTimestamp get shotAt => throw _privateConstructorUsedError;
  String get storeId => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $StoreCopyWith<Store> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StoreCopyWith<$Res> {
  factory $StoreCopyWith(Store value, $Res Function(Store) then) =
      _$StoreCopyWithImpl<$Res, Store>;
  @useResult
  $Res call(
      {String id,
      @timestampConverter UnionTimestamp createdAt,
      @serverTimestampConverter UnionTimestamp updatedAt,
      List<String> imageUrls,
      String name,
      String phoneNumber,
      String website,
      String address,
      Map<String, String> openingHours,
      @timestampConverter UnionTimestamp shotAt,
      String storeId});

  $UnionTimestampCopyWith<$Res> get createdAt;
  $UnionTimestampCopyWith<$Res> get updatedAt;
  $UnionTimestampCopyWith<$Res> get shotAt;
}

/// @nodoc
class _$StoreCopyWithImpl<$Res, $Val extends Store>
    implements $StoreCopyWith<$Res> {
  _$StoreCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? imageUrls = null,
    Object? name = null,
    Object? phoneNumber = null,
    Object? website = null,
    Object? address = null,
    Object? openingHours = null,
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
      imageUrls: null == imageUrls
          ? _value.imageUrls
          : imageUrls // ignore: cast_nullable_to_non_nullable
              as List<String>,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      phoneNumber: null == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String,
      website: null == website
          ? _value.website
          : website // ignore: cast_nullable_to_non_nullable
              as String,
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      openingHours: null == openingHours
          ? _value.openingHours
          : openingHours // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
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

  @override
  @pragma('vm:prefer-inline')
  $UnionTimestampCopyWith<$Res> get createdAt {
    return $UnionTimestampCopyWith<$Res>(_value.createdAt, (value) {
      return _then(_value.copyWith(createdAt: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $UnionTimestampCopyWith<$Res> get updatedAt {
    return $UnionTimestampCopyWith<$Res>(_value.updatedAt, (value) {
      return _then(_value.copyWith(updatedAt: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $UnionTimestampCopyWith<$Res> get shotAt {
    return $UnionTimestampCopyWith<$Res>(_value.shotAt, (value) {
      return _then(_value.copyWith(shotAt: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$StoreImplCopyWith<$Res> implements $StoreCopyWith<$Res> {
  factory _$$StoreImplCopyWith(
          _$StoreImpl value, $Res Function(_$StoreImpl) then) =
      __$$StoreImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @timestampConverter UnionTimestamp createdAt,
      @serverTimestampConverter UnionTimestamp updatedAt,
      List<String> imageUrls,
      String name,
      String phoneNumber,
      String website,
      String address,
      Map<String, String> openingHours,
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
class __$$StoreImplCopyWithImpl<$Res>
    extends _$StoreCopyWithImpl<$Res, _$StoreImpl>
    implements _$$StoreImplCopyWith<$Res> {
  __$$StoreImplCopyWithImpl(
      _$StoreImpl _value, $Res Function(_$StoreImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? imageUrls = null,
    Object? name = null,
    Object? phoneNumber = null,
    Object? website = null,
    Object? address = null,
    Object? openingHours = null,
    Object? shotAt = null,
    Object? storeId = null,
  }) {
    return _then(_$StoreImpl(
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
      imageUrls: null == imageUrls
          ? _value._imageUrls
          : imageUrls // ignore: cast_nullable_to_non_nullable
              as List<String>,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      phoneNumber: null == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String,
      website: null == website
          ? _value.website
          : website // ignore: cast_nullable_to_non_nullable
              as String,
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      openingHours: null == openingHours
          ? _value._openingHours
          : openingHours // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
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
class _$StoreImpl extends _Store {
  const _$StoreImpl(
      {this.id = '',
      @timestampConverter
      this.createdAt = const UnionTimestamp.serverTimestamp(),
      @serverTimestampConverter
      this.updatedAt = const UnionTimestamp.serverTimestamp(),
      final List<String> imageUrls = const [],
      this.name = '',
      this.phoneNumber = '',
      this.website = '',
      this.address = '',
      final Map<String, String> openingHours = const <String, String>{},
      @timestampConverter this.shotAt = const UnionTimestamp.serverTimestamp(),
      this.storeId = ''})
      : _imageUrls = imageUrls,
        _openingHours = openingHours,
        super._();

  factory _$StoreImpl.fromJson(Map<String, dynamic> json) =>
      _$$StoreImplFromJson(json);

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

  /// FirebaseStorageに保存された（ストアの）画像のURL
  final List<String> _imageUrls;

  /// FirebaseStorageに保存された（ストアの）画像のURL
  @override
  @JsonKey()
  List<String> get imageUrls {
    if (_imageUrls is EqualUnmodifiableListView) return _imageUrls;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_imageUrls);
  }

  /// FirebaseStorageの(ストアの)name
  @override
  @JsonKey()
  final String name;

  /// FirebaseStorageの（ストアの）電話番号
  @override
  @JsonKey()
  final String phoneNumber;

  /// FirebaseStorageの（ストアの）URL
  @override
  @JsonKey()
  final String website;

  /// FirebaseStorageの（ストアの）住所
  @override
  @JsonKey()
  final String address;

  /// FirebaseStorageの（ストアの）営業時間
  final Map<String, String> _openingHours;

  /// FirebaseStorageの（ストアの）営業時間
  @override
  @JsonKey()
  Map<String, String> get openingHours {
    if (_openingHours is EqualUnmodifiableMapView) return _openingHours;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_openingHours);
  }

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
    return 'Store(id: $id, createdAt: $createdAt, updatedAt: $updatedAt, imageUrls: $imageUrls, name: $name, phoneNumber: $phoneNumber, website: $website, address: $address, openingHours: $openingHours, shotAt: $shotAt, storeId: $storeId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StoreImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            const DeepCollectionEquality()
                .equals(other._imageUrls, _imageUrls) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber) &&
            (identical(other.website, website) || other.website == website) &&
            (identical(other.address, address) || other.address == address) &&
            const DeepCollectionEquality()
                .equals(other._openingHours, _openingHours) &&
            (identical(other.shotAt, shotAt) || other.shotAt == shotAt) &&
            (identical(other.storeId, storeId) || other.storeId == storeId));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      createdAt,
      updatedAt,
      const DeepCollectionEquality().hash(_imageUrls),
      name,
      phoneNumber,
      website,
      address,
      const DeepCollectionEquality().hash(_openingHours),
      shotAt,
      storeId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$StoreImplCopyWith<_$StoreImpl> get copyWith =>
      __$$StoreImplCopyWithImpl<_$StoreImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StoreImplToJson(
      this,
    );
  }
}

abstract class _Store extends Store {
  const factory _Store(
      {final String id,
      @timestampConverter final UnionTimestamp createdAt,
      @serverTimestampConverter final UnionTimestamp updatedAt,
      final List<String> imageUrls,
      final String name,
      final String phoneNumber,
      final String website,
      final String address,
      final Map<String, String> openingHours,
      @timestampConverter final UnionTimestamp shotAt,
      final String storeId}) = _$StoreImpl;
  const _Store._() : super._();

  factory _Store.fromJson(Map<String, dynamic> json) = _$StoreImpl.fromJson;

  @override

  /// firestore上のドキュメントID
  String get id;
  @override

  /// 作成日時
  @timestampConverter
  UnionTimestamp get createdAt;
  @override

  /// 更新日時
  @serverTimestampConverter
  UnionTimestamp get updatedAt;
  @override

  /// FirebaseStorageに保存された（ストアの）画像のURL
  List<String> get imageUrls;
  @override

  /// FirebaseStorageの(ストアの)name
  String get name;
  @override

  /// FirebaseStorageの（ストアの）電話番号
  String get phoneNumber;
  @override

  /// FirebaseStorageの（ストアの）URL
  String get website;
  @override

  /// FirebaseStorageの（ストアの）住所
  String get address;
  @override

  /// FirebaseStorageの（ストアの）営業時間
  Map<String, String> get openingHours;
  @override

  /// 写真の撮影日時
  @timestampConverter
  UnionTimestamp get shotAt;
  @override
  String get storeId;
  @override
  @JsonKey(ignore: true)
  _$$StoreImplCopyWith<_$StoreImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
