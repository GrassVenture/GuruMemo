// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_database.dart';

// ignore_for_file: type=lint
class $PhotosTable extends Photos with TableInfo<$PhotosTable, LocalPhoto> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PhotosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _pathMeta = const VerificationMeta('path');
  @override
  late final GeneratedColumn<String> path = GeneratedColumn<String>(
      'path', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _widthMeta = const VerificationMeta('width');
  @override
  late final GeneratedColumn<int> width = GeneratedColumn<int>(
      'width', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _heightMeta = const VerificationMeta('height');
  @override
  late final GeneratedColumn<int> height = GeneratedColumn<int>(
      'height', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _latitudeMeta =
      const VerificationMeta('latitude');
  @override
  late final GeneratedColumn<double> latitude = GeneratedColumn<double>(
      'latitude', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _longitudeMeta =
      const VerificationMeta('longitude');
  @override
  late final GeneratedColumn<double> longitude = GeneratedColumn<double>(
      'longitude', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, path, width, height, latitude, longitude];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'photos';
  @override
  VerificationContext validateIntegrity(Insertable<LocalPhoto> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('path')) {
      context.handle(
          _pathMeta, path.isAcceptableOrUnknown(data['path']!, _pathMeta));
    } else if (isInserting) {
      context.missing(_pathMeta);
    }
    if (data.containsKey('width')) {
      context.handle(
          _widthMeta, width.isAcceptableOrUnknown(data['width']!, _widthMeta));
    }
    if (data.containsKey('height')) {
      context.handle(_heightMeta,
          height.isAcceptableOrUnknown(data['height']!, _heightMeta));
    }
    if (data.containsKey('latitude')) {
      context.handle(_latitudeMeta,
          latitude.isAcceptableOrUnknown(data['latitude']!, _latitudeMeta));
    }
    if (data.containsKey('longitude')) {
      context.handle(_longitudeMeta,
          longitude.isAcceptableOrUnknown(data['longitude']!, _longitudeMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalPhoto map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalPhoto(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      path: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}path'])!,
      width: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}width'])!,
      height: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}height'])!,
      latitude: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}latitude']),
      longitude: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}longitude']),
    );
  }

  @override
  $PhotosTable createAlias(String alias) {
    return $PhotosTable(attachedDatabase, alias);
  }
}

class LocalPhoto extends DataClass implements Insertable<LocalPhoto> {
  /// 写真のid
  final String id;

  /// 写真のパス
  final String path;

  /// 横サイズ
  final int width;

  /// 縦サイズ
  final int height;

  /// 緯度
  final double? latitude;

  /// 経度
  final double? longitude;
  const LocalPhoto(
      {required this.id,
      required this.path,
      required this.width,
      required this.height,
      this.latitude,
      this.longitude});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['path'] = Variable<String>(path);
    map['width'] = Variable<int>(width);
    map['height'] = Variable<int>(height);
    if (!nullToAbsent || latitude != null) {
      map['latitude'] = Variable<double>(latitude);
    }
    if (!nullToAbsent || longitude != null) {
      map['longitude'] = Variable<double>(longitude);
    }
    return map;
  }

  PhotosCompanion toCompanion(bool nullToAbsent) {
    return PhotosCompanion(
      id: Value(id),
      path: Value(path),
      width: Value(width),
      height: Value(height),
      latitude: latitude == null && nullToAbsent
          ? const Value.absent()
          : Value(latitude),
      longitude: longitude == null && nullToAbsent
          ? const Value.absent()
          : Value(longitude),
    );
  }

  factory LocalPhoto.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalPhoto(
      id: serializer.fromJson<String>(json['id']),
      path: serializer.fromJson<String>(json['path']),
      width: serializer.fromJson<int>(json['width']),
      height: serializer.fromJson<int>(json['height']),
      latitude: serializer.fromJson<double?>(json['latitude']),
      longitude: serializer.fromJson<double?>(json['longitude']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'path': serializer.toJson<String>(path),
      'width': serializer.toJson<int>(width),
      'height': serializer.toJson<int>(height),
      'latitude': serializer.toJson<double?>(latitude),
      'longitude': serializer.toJson<double?>(longitude),
    };
  }

  LocalPhoto copyWith(
          {String? id,
          String? path,
          int? width,
          int? height,
          Value<double?> latitude = const Value.absent(),
          Value<double?> longitude = const Value.absent()}) =>
      LocalPhoto(
        id: id ?? this.id,
        path: path ?? this.path,
        width: width ?? this.width,
        height: height ?? this.height,
        latitude: latitude.present ? latitude.value : this.latitude,
        longitude: longitude.present ? longitude.value : this.longitude,
      );
  LocalPhoto copyWithCompanion(PhotosCompanion data) {
    return LocalPhoto(
      id: data.id.present ? data.id.value : this.id,
      path: data.path.present ? data.path.value : this.path,
      width: data.width.present ? data.width.value : this.width,
      height: data.height.present ? data.height.value : this.height,
      latitude: data.latitude.present ? data.latitude.value : this.latitude,
      longitude: data.longitude.present ? data.longitude.value : this.longitude,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalPhoto(')
          ..write('id: $id, ')
          ..write('path: $path, ')
          ..write('width: $width, ')
          ..write('height: $height, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, path, width, height, latitude, longitude);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalPhoto &&
          other.id == this.id &&
          other.path == this.path &&
          other.width == this.width &&
          other.height == this.height &&
          other.latitude == this.latitude &&
          other.longitude == this.longitude);
}

class PhotosCompanion extends UpdateCompanion<LocalPhoto> {
  final Value<String> id;
  final Value<String> path;
  final Value<int> width;
  final Value<int> height;
  final Value<double?> latitude;
  final Value<double?> longitude;
  final Value<int> rowid;
  const PhotosCompanion({
    this.id = const Value.absent(),
    this.path = const Value.absent(),
    this.width = const Value.absent(),
    this.height = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PhotosCompanion.insert({
    required String id,
    required String path,
    this.width = const Value.absent(),
    this.height = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        path = Value(path);
  static Insertable<LocalPhoto> custom({
    Expression<String>? id,
    Expression<String>? path,
    Expression<int>? width,
    Expression<int>? height,
    Expression<double>? latitude,
    Expression<double>? longitude,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (path != null) 'path': path,
      if (width != null) 'width': width,
      if (height != null) 'height': height,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PhotosCompanion copyWith(
      {Value<String>? id,
      Value<String>? path,
      Value<int>? width,
      Value<int>? height,
      Value<double?>? latitude,
      Value<double?>? longitude,
      Value<int>? rowid}) {
    return PhotosCompanion(
      id: id ?? this.id,
      path: path ?? this.path,
      width: width ?? this.width,
      height: height ?? this.height,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (path.present) {
      map['path'] = Variable<String>(path.value);
    }
    if (width.present) {
      map['width'] = Variable<int>(width.value);
    }
    if (height.present) {
      map['height'] = Variable<int>(height.value);
    }
    if (latitude.present) {
      map['latitude'] = Variable<double>(latitude.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<double>(longitude.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PhotosCompanion(')
          ..write('id: $id, ')
          ..write('path: $path, ')
          ..write('width: $width, ')
          ..write('height: $height, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PhotoDetailsTable extends PhotoDetails
    with TableInfo<$PhotoDetailsTable, LocalPhotoDetail> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PhotoDetailsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _lastIdMeta = const VerificationMeta('lastId');
  @override
  late final GeneratedColumn<String> lastId = GeneratedColumn<String>(
      'last_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _lastCreateDateSecondMeta =
      const VerificationMeta('lastCreateDateSecond');
  @override
  late final GeneratedColumn<int> lastCreateDateSecond = GeneratedColumn<int>(
      'last_create_date_second', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _currentCountMeta =
      const VerificationMeta('currentCount');
  @override
  late final GeneratedColumn<int> currentCount = GeneratedColumn<int>(
      'current_count', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _pastFoodTotalMeta =
      const VerificationMeta('pastFoodTotal');
  @override
  late final GeneratedColumn<int> pastFoodTotal = GeneratedColumn<int>(
      'past_food_total', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [lastId, lastCreateDateSecond, currentCount, pastFoodTotal];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'photo_details';
  @override
  VerificationContext validateIntegrity(Insertable<LocalPhotoDetail> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('last_id')) {
      context.handle(_lastIdMeta,
          lastId.isAcceptableOrUnknown(data['last_id']!, _lastIdMeta));
    } else if (isInserting) {
      context.missing(_lastIdMeta);
    }
    if (data.containsKey('last_create_date_second')) {
      context.handle(
          _lastCreateDateSecondMeta,
          lastCreateDateSecond.isAcceptableOrUnknown(
              data['last_create_date_second']!, _lastCreateDateSecondMeta));
    } else if (isInserting) {
      context.missing(_lastCreateDateSecondMeta);
    }
    if (data.containsKey('current_count')) {
      context.handle(
          _currentCountMeta,
          currentCount.isAcceptableOrUnknown(
              data['current_count']!, _currentCountMeta));
    } else if (isInserting) {
      context.missing(_currentCountMeta);
    }
    if (data.containsKey('past_food_total')) {
      context.handle(
          _pastFoodTotalMeta,
          pastFoodTotal.isAcceptableOrUnknown(
              data['past_food_total']!, _pastFoodTotalMeta));
    } else if (isInserting) {
      context.missing(_pastFoodTotalMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  LocalPhotoDetail map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalPhotoDetail(
      lastId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}last_id'])!,
      lastCreateDateSecond: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}last_create_date_second'])!,
      currentCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}current_count'])!,
      pastFoodTotal: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}past_food_total'])!,
    );
  }

  @override
  $PhotoDetailsTable createAlias(String alias) {
    return $PhotoDetailsTable(attachedDatabase, alias);
  }
}

class LocalPhotoDetail extends DataClass
    implements Insertable<LocalPhotoDetail> {
  /// 最後の写真id
  final String lastId;

  /// 最後の写真日付
  final int lastCreateDateSecond;

  /// 現在の写真処理数
  final int currentCount;

  /// 過去のグルメ分類合計枚数(追加された写真をカウントするのに使用)
  final int pastFoodTotal;
  const LocalPhotoDetail(
      {required this.lastId,
      required this.lastCreateDateSecond,
      required this.currentCount,
      required this.pastFoodTotal});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['last_id'] = Variable<String>(lastId);
    map['last_create_date_second'] = Variable<int>(lastCreateDateSecond);
    map['current_count'] = Variable<int>(currentCount);
    map['past_food_total'] = Variable<int>(pastFoodTotal);
    return map;
  }

  PhotoDetailsCompanion toCompanion(bool nullToAbsent) {
    return PhotoDetailsCompanion(
      lastId: Value(lastId),
      lastCreateDateSecond: Value(lastCreateDateSecond),
      currentCount: Value(currentCount),
      pastFoodTotal: Value(pastFoodTotal),
    );
  }

  factory LocalPhotoDetail.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalPhotoDetail(
      lastId: serializer.fromJson<String>(json['lastId']),
      lastCreateDateSecond:
          serializer.fromJson<int>(json['lastCreateDateSecond']),
      currentCount: serializer.fromJson<int>(json['currentCount']),
      pastFoodTotal: serializer.fromJson<int>(json['pastFoodTotal']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'lastId': serializer.toJson<String>(lastId),
      'lastCreateDateSecond': serializer.toJson<int>(lastCreateDateSecond),
      'currentCount': serializer.toJson<int>(currentCount),
      'pastFoodTotal': serializer.toJson<int>(pastFoodTotal),
    };
  }

  LocalPhotoDetail copyWith(
          {String? lastId,
          int? lastCreateDateSecond,
          int? currentCount,
          int? pastFoodTotal}) =>
      LocalPhotoDetail(
        lastId: lastId ?? this.lastId,
        lastCreateDateSecond: lastCreateDateSecond ?? this.lastCreateDateSecond,
        currentCount: currentCount ?? this.currentCount,
        pastFoodTotal: pastFoodTotal ?? this.pastFoodTotal,
      );
  LocalPhotoDetail copyWithCompanion(PhotoDetailsCompanion data) {
    return LocalPhotoDetail(
      lastId: data.lastId.present ? data.lastId.value : this.lastId,
      lastCreateDateSecond: data.lastCreateDateSecond.present
          ? data.lastCreateDateSecond.value
          : this.lastCreateDateSecond,
      currentCount: data.currentCount.present
          ? data.currentCount.value
          : this.currentCount,
      pastFoodTotal: data.pastFoodTotal.present
          ? data.pastFoodTotal.value
          : this.pastFoodTotal,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalPhotoDetail(')
          ..write('lastId: $lastId, ')
          ..write('lastCreateDateSecond: $lastCreateDateSecond, ')
          ..write('currentCount: $currentCount, ')
          ..write('pastFoodTotal: $pastFoodTotal')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(lastId, lastCreateDateSecond, currentCount, pastFoodTotal);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalPhotoDetail &&
          other.lastId == this.lastId &&
          other.lastCreateDateSecond == this.lastCreateDateSecond &&
          other.currentCount == this.currentCount &&
          other.pastFoodTotal == this.pastFoodTotal);
}

class PhotoDetailsCompanion extends UpdateCompanion<LocalPhotoDetail> {
  final Value<String> lastId;
  final Value<int> lastCreateDateSecond;
  final Value<int> currentCount;
  final Value<int> pastFoodTotal;
  final Value<int> rowid;
  const PhotoDetailsCompanion({
    this.lastId = const Value.absent(),
    this.lastCreateDateSecond = const Value.absent(),
    this.currentCount = const Value.absent(),
    this.pastFoodTotal = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PhotoDetailsCompanion.insert({
    required String lastId,
    required int lastCreateDateSecond,
    required int currentCount,
    required int pastFoodTotal,
    this.rowid = const Value.absent(),
  })  : lastId = Value(lastId),
        lastCreateDateSecond = Value(lastCreateDateSecond),
        currentCount = Value(currentCount),
        pastFoodTotal = Value(pastFoodTotal);
  static Insertable<LocalPhotoDetail> custom({
    Expression<String>? lastId,
    Expression<int>? lastCreateDateSecond,
    Expression<int>? currentCount,
    Expression<int>? pastFoodTotal,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (lastId != null) 'last_id': lastId,
      if (lastCreateDateSecond != null)
        'last_create_date_second': lastCreateDateSecond,
      if (currentCount != null) 'current_count': currentCount,
      if (pastFoodTotal != null) 'past_food_total': pastFoodTotal,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PhotoDetailsCompanion copyWith(
      {Value<String>? lastId,
      Value<int>? lastCreateDateSecond,
      Value<int>? currentCount,
      Value<int>? pastFoodTotal,
      Value<int>? rowid}) {
    return PhotoDetailsCompanion(
      lastId: lastId ?? this.lastId,
      lastCreateDateSecond: lastCreateDateSecond ?? this.lastCreateDateSecond,
      currentCount: currentCount ?? this.currentCount,
      pastFoodTotal: pastFoodTotal ?? this.pastFoodTotal,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (lastId.present) {
      map['last_id'] = Variable<String>(lastId.value);
    }
    if (lastCreateDateSecond.present) {
      map['last_create_date_second'] =
          Variable<int>(lastCreateDateSecond.value);
    }
    if (currentCount.present) {
      map['current_count'] = Variable<int>(currentCount.value);
    }
    if (pastFoodTotal.present) {
      map['past_food_total'] = Variable<int>(pastFoodTotal.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PhotoDetailsCompanion(')
          ..write('lastId: $lastId, ')
          ..write('lastCreateDateSecond: $lastCreateDateSecond, ')
          ..write('currentCount: $currentCount, ')
          ..write('pastFoodTotal: $pastFoodTotal, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $PhotosTable photos = $PhotosTable(this);
  late final $PhotoDetailsTable photoDetails = $PhotoDetailsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [photos, photoDetails];
}

typedef $$PhotosTableCreateCompanionBuilder = PhotosCompanion Function({
  required String id,
  required String path,
  Value<int> width,
  Value<int> height,
  Value<double?> latitude,
  Value<double?> longitude,
  Value<int> rowid,
});
typedef $$PhotosTableUpdateCompanionBuilder = PhotosCompanion Function({
  Value<String> id,
  Value<String> path,
  Value<int> width,
  Value<int> height,
  Value<double?> latitude,
  Value<double?> longitude,
  Value<int> rowid,
});

class $$PhotosTableFilterComposer
    extends FilterComposer<_$AppDatabase, $PhotosTable> {
  $$PhotosTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get path => $state.composableBuilder(
      column: $state.table.path,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get width => $state.composableBuilder(
      column: $state.table.width,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get height => $state.composableBuilder(
      column: $state.table.height,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get latitude => $state.composableBuilder(
      column: $state.table.latitude,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get longitude => $state.composableBuilder(
      column: $state.table.longitude,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$PhotosTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $PhotosTable> {
  $$PhotosTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get path => $state.composableBuilder(
      column: $state.table.path,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get width => $state.composableBuilder(
      column: $state.table.width,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get height => $state.composableBuilder(
      column: $state.table.height,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get latitude => $state.composableBuilder(
      column: $state.table.latitude,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get longitude => $state.composableBuilder(
      column: $state.table.longitude,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

class $$PhotosTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PhotosTable,
    LocalPhoto,
    $$PhotosTableFilterComposer,
    $$PhotosTableOrderingComposer,
    $$PhotosTableCreateCompanionBuilder,
    $$PhotosTableUpdateCompanionBuilder,
    (LocalPhoto, BaseReferences<_$AppDatabase, $PhotosTable, LocalPhoto>),
    LocalPhoto,
    PrefetchHooks Function()> {
  $$PhotosTableTableManager(_$AppDatabase db, $PhotosTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$PhotosTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$PhotosTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> path = const Value.absent(),
            Value<int> width = const Value.absent(),
            Value<int> height = const Value.absent(),
            Value<double?> latitude = const Value.absent(),
            Value<double?> longitude = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PhotosCompanion(
            id: id,
            path: path,
            width: width,
            height: height,
            latitude: latitude,
            longitude: longitude,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String path,
            Value<int> width = const Value.absent(),
            Value<int> height = const Value.absent(),
            Value<double?> latitude = const Value.absent(),
            Value<double?> longitude = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PhotosCompanion.insert(
            id: id,
            path: path,
            width: width,
            height: height,
            latitude: latitude,
            longitude: longitude,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$PhotosTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PhotosTable,
    LocalPhoto,
    $$PhotosTableFilterComposer,
    $$PhotosTableOrderingComposer,
    $$PhotosTableCreateCompanionBuilder,
    $$PhotosTableUpdateCompanionBuilder,
    (LocalPhoto, BaseReferences<_$AppDatabase, $PhotosTable, LocalPhoto>),
    LocalPhoto,
    PrefetchHooks Function()>;
typedef $$PhotoDetailsTableCreateCompanionBuilder = PhotoDetailsCompanion
    Function({
  required String lastId,
  required int lastCreateDateSecond,
  required int currentCount,
  required int pastFoodTotal,
  Value<int> rowid,
});
typedef $$PhotoDetailsTableUpdateCompanionBuilder = PhotoDetailsCompanion
    Function({
  Value<String> lastId,
  Value<int> lastCreateDateSecond,
  Value<int> currentCount,
  Value<int> pastFoodTotal,
  Value<int> rowid,
});

class $$PhotoDetailsTableFilterComposer
    extends FilterComposer<_$AppDatabase, $PhotoDetailsTable> {
  $$PhotoDetailsTableFilterComposer(super.$state);
  ColumnFilters<String> get lastId => $state.composableBuilder(
      column: $state.table.lastId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get lastCreateDateSecond => $state.composableBuilder(
      column: $state.table.lastCreateDateSecond,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get currentCount => $state.composableBuilder(
      column: $state.table.currentCount,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get pastFoodTotal => $state.composableBuilder(
      column: $state.table.pastFoodTotal,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$PhotoDetailsTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $PhotoDetailsTable> {
  $$PhotoDetailsTableOrderingComposer(super.$state);
  ColumnOrderings<String> get lastId => $state.composableBuilder(
      column: $state.table.lastId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get lastCreateDateSecond => $state.composableBuilder(
      column: $state.table.lastCreateDateSecond,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get currentCount => $state.composableBuilder(
      column: $state.table.currentCount,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get pastFoodTotal => $state.composableBuilder(
      column: $state.table.pastFoodTotal,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

class $$PhotoDetailsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PhotoDetailsTable,
    LocalPhotoDetail,
    $$PhotoDetailsTableFilterComposer,
    $$PhotoDetailsTableOrderingComposer,
    $$PhotoDetailsTableCreateCompanionBuilder,
    $$PhotoDetailsTableUpdateCompanionBuilder,
    (
      LocalPhotoDetail,
      BaseReferences<_$AppDatabase, $PhotoDetailsTable, LocalPhotoDetail>
    ),
    LocalPhotoDetail,
    PrefetchHooks Function()> {
  $$PhotoDetailsTableTableManager(_$AppDatabase db, $PhotoDetailsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$PhotoDetailsTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$PhotoDetailsTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> lastId = const Value.absent(),
            Value<int> lastCreateDateSecond = const Value.absent(),
            Value<int> currentCount = const Value.absent(),
            Value<int> pastFoodTotal = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PhotoDetailsCompanion(
            lastId: lastId,
            lastCreateDateSecond: lastCreateDateSecond,
            currentCount: currentCount,
            pastFoodTotal: pastFoodTotal,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String lastId,
            required int lastCreateDateSecond,
            required int currentCount,
            required int pastFoodTotal,
            Value<int> rowid = const Value.absent(),
          }) =>
              PhotoDetailsCompanion.insert(
            lastId: lastId,
            lastCreateDateSecond: lastCreateDateSecond,
            currentCount: currentCount,
            pastFoodTotal: pastFoodTotal,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$PhotoDetailsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PhotoDetailsTable,
    LocalPhotoDetail,
    $$PhotoDetailsTableFilterComposer,
    $$PhotoDetailsTableOrderingComposer,
    $$PhotoDetailsTableCreateCompanionBuilder,
    $$PhotoDetailsTableUpdateCompanionBuilder,
    (
      LocalPhotoDetail,
      BaseReferences<_$AppDatabase, $PhotoDetailsTable, LocalPhotoDetail>
    ),
    LocalPhotoDetail,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$PhotosTableTableManager get photos =>
      $$PhotosTableTableManager(_db, _db.photos);
  $$PhotoDetailsTableTableManager get photoDetails =>
      $$PhotoDetailsTableTableManager(_db, _db.photoDetails);
}

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$appDatabaseHash() => r'18ce5c8c4d8ddbfe5a7d819d8fb7d5aca76bf416';

/// [AppDatabase]インスタンス用Provider
///
/// Copied from [appDatabase].
@ProviderFor(appDatabase)
final appDatabaseProvider = AutoDisposeProvider<AppDatabase>.internal(
  appDatabase,
  name: r'appDatabaseProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$appDatabaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AppDatabaseRef = AutoDisposeProviderRef<AppDatabase>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
