import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'local_database.g.dart';

/// 写真テーブル
@DataClassName('LocalPhoto')
class Photos extends Table {
  /// 写真のid
  TextColumn get id => text()();

  /// 写真のパス
  TextColumn get path => text()();

  /// 横サイズ
  IntColumn get width => integer().withDefault(const Constant(0))();

  /// 縦サイズ
  IntColumn get height => integer().withDefault(const Constant(0))();

  /// 緯度
  RealColumn get latitude => real().nullable()();

  /// 経度
  RealColumn get longitude => real().nullable()();

  /// 主キー設定
  @override
  Set<Column> get primaryKey => {id};
}

/// 写真情報を保存するテーブル
@DataClassName('LocalPhotoDetail')
class PhotoDetails extends Table {
  /// 最後の写真id
  TextColumn get lastId => text()();

  /// 最後の写真日付
  IntColumn get lastCreateDateSecond => integer()();

  /// 現在の写真処理数
  IntColumn get currentCount => integer()();

  /// 過去のグルメ分類合計枚数(追加された写真をカウントするのに使用)
  IntColumn get pastFoodTotal => integer()();
}

/// DB設定
@DriftDatabase(tables: [Photos, PhotoDetails])
class AppDatabase extends _$AppDatabase {
  // 引数なしのコンストラクタで_openConnectionを直接使用
  AppDatabase() : super(_openConnection());

  /// スキーマバージョン
  @override
  int get schemaVersion => 2;

  /// マイグレーション処理
  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 2) {
          await m.addColumn(photos, photos.width);
          await m.addColumn(photos, photos.height);
          await m.addColumn(photos, photos.latitude);
          await m.addColumn(photos, photos.longitude);
        }
      },
    );
  }
}

/// コネクション生成
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file);
  });
}

/// [AppDatabase]インスタンス用Provider
@riverpod
AppDatabase appDatabase(Ref ref) {
  return AppDatabase();
}
