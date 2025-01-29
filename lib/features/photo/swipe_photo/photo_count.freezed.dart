// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'photo_count.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$PhotoCount {
  /// 現在の写真処理数
  int get current => throw _privateConstructorUsedError;

  /// 写真の合計数
  int get total => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $PhotoCountCopyWith<PhotoCount> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PhotoCountCopyWith<$Res> {
  factory $PhotoCountCopyWith(
          PhotoCount value, $Res Function(PhotoCount) then) =
      _$PhotoCountCopyWithImpl<$Res, PhotoCount>;
  @useResult
  $Res call({int current, int total});
}

/// @nodoc
class _$PhotoCountCopyWithImpl<$Res, $Val extends PhotoCount>
    implements $PhotoCountCopyWith<$Res> {
  _$PhotoCountCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? current = null,
    Object? total = null,
  }) {
    return _then(_value.copyWith(
      current: null == current
          ? _value.current
          : current // ignore: cast_nullable_to_non_nullable
              as int,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PhotoCountImplCopyWith<$Res>
    implements $PhotoCountCopyWith<$Res> {
  factory _$$PhotoCountImplCopyWith(
          _$PhotoCountImpl value, $Res Function(_$PhotoCountImpl) then) =
      __$$PhotoCountImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int current, int total});
}

/// @nodoc
class __$$PhotoCountImplCopyWithImpl<$Res>
    extends _$PhotoCountCopyWithImpl<$Res, _$PhotoCountImpl>
    implements _$$PhotoCountImplCopyWith<$Res> {
  __$$PhotoCountImplCopyWithImpl(
      _$PhotoCountImpl _value, $Res Function(_$PhotoCountImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? current = null,
    Object? total = null,
  }) {
    return _then(_$PhotoCountImpl(
      current: null == current
          ? _value.current
          : current // ignore: cast_nullable_to_non_nullable
              as int,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$PhotoCountImpl extends _PhotoCount {
  const _$PhotoCountImpl({required this.current, required this.total})
      : super._();

  /// 現在の写真処理数
  @override
  final int current;

  /// 写真の合計数
  @override
  final int total;

  @override
  String toString() {
    return 'PhotoCount(current: $current, total: $total)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PhotoCountImpl &&
            (identical(other.current, current) || other.current == current) &&
            (identical(other.total, total) || other.total == total));
  }

  @override
  int get hashCode => Object.hash(runtimeType, current, total);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PhotoCountImplCopyWith<_$PhotoCountImpl> get copyWith =>
      __$$PhotoCountImplCopyWithImpl<_$PhotoCountImpl>(this, _$identity);
}

abstract class _PhotoCount extends PhotoCount {
  const factory _PhotoCount(
      {required final int current,
      required final int total}) = _$PhotoCountImpl;
  const _PhotoCount._() : super._();

  @override

  /// 現在の写真処理数
  int get current;
  @override

  /// 写真の合計数
  int get total;
  @override
  @JsonKey(ignore: true)
  _$$PhotoCountImplCopyWith<_$PhotoCountImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
