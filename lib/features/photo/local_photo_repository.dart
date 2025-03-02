import 'package:drift/drift.dart';
import 'package:gallery_saver_plus/gallery_saver.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../../core/local_database/local_database.dart';
import '../../core/logger.dart';

/// [LocalPhotoRepository]用プロバイダー
final Provider<LocalPhotoRepository> localPhotoRepositoryProvider =
    Provider(LocalPhotoRepository._);

/// ローカルDBに接続して[LocalPhoto]を操作するクラス
class LocalPhotoRepository {
  LocalPhotoRepository._(this._ref);

  final Ref _ref;

  /// DBインスタンス
  AppDatabase get _db => _ref.read(appDatabaseProvider);

  /// 写真リストを取得する
  Future<List<LocalPhoto>> getAllPhotos() {
    return _db.select(_db.photos).get();
  }

  /// 写真を削除する
  /// [id] 写真id
  Future<void> deletePhoto(String id) async {
    await (_db.delete(_db.photos)..where((tbl) => tbl.id.equals(id))).go();
  }

  /// 写真情報を取得する
  Future<LocalPhotoDetail?> getPhotoDetail() {
    return (_db.select(_db.photoDetails)..limit(1)).getSingleOrNull();
  }

  ///imagePathで写真を保存する
  Future<void> savePhotoByImagePath(String imagePath) async {
    try {
      await GallerySaver.saveImage(imagePath);
    } on Exception catch (e) {
      logger.e('ローカルへの写真保存でエラーが発生しました: $e');
    }
  }

  /// グルメ分類合計枚数を取得する
  Future<int> getFoodPhotoTotal() async {
    // 過去のグルメ分類合計枚数取得
    final photoDetail = await getPhotoDetail();

    final countExpression = countAll();
    final query = _db.selectOnly(_db.photos)..addColumns([countExpression]);
    final row = await query.getSingle();

    final count = row.rawData.data.values.first as int;

    // 過去のグルメ分類合計枚数を更新する
    final lastPhotoModel = PhotoDetailsCompanion(
      pastFoodTotal: Value(count),
    );
    await _db.update(_db.photoDetails).write(lastPhotoModel);

    return count - photoDetail!.pastFoodTotal;
  }

  /// 写真データを保存する
  /// [photo] 写真データ
  /// [isFood] 食べ物かどうか
  Future<void> savePhoto({
    required AssetEntity photo,
    required bool isFood,
  }) async {
    final file = await photo.originFile;

    final latLng = await photo.latlngAsync();

    // 飯の場合写真データ保存
    if (isFood && file != null) {
      final photoModel = PhotosCompanion(
        id: Value(photo.id),
        path: Value(file.path),
        width: Value(photo.width),
        height: Value(photo.height),
        latitude: Value(latLng.latitude),
        longitude: Value(latLng.longitude),
      );
      await _db.into(_db.photos).insert(
            photoModel,
            mode: InsertMode.insertOrIgnore,
          );
    }

    // 写真情報保存
    final photoDetail = await getPhotoDetail();
    final lastPhotoModel = PhotoDetailsCompanion(
      lastId: Value(photo.id),
      lastCreateDateSecond: Value(photo.createDateSecond!),
      currentCount:
          Value(photoDetail != null ? photoDetail.currentCount + 1 : 1),
      pastFoodTotal: Value(photoDetail?.pastFoodTotal ?? 0),
    );
    if (photoDetail != null) {
      // 更新
      await _db.update(_db.photoDetails).write(lastPhotoModel);
    } else {
      // 登録
      await _db.into(_db.photoDetails).insert(lastPhotoModel);
    }
  }
}
