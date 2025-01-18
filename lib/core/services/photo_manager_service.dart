import 'dart:io';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../features/photo/swipe_photo/swipe_photo_controller.dart';
import '../repositories/local_photo_repository.dart';

/// [PhotoService]用プロバイダー
final photoManagerServiceProvider = Provider<PhotoService>(
  PhotoService._,
);

/// [PhotoManager]を操作するクラス
class PhotoService {
  PhotoService._(this.ref);

  final Ref ref;

  LocalPhotoRepository get _localPhotoRepository =>
      ref.read(localPhotoRepositoryProvider);

  /// 写真取得
  /// [lastEntity] 最後の写真情報
  Future<List<AssetEntity>> getAllPhotos({AssetEntity? lastEntity}) async {
    AdvancedCustomFilter filter;

    // 初回ロード
    if (lastEntity == null) {
      // DBから写真情報を取得
      final photoDetail = await _localPhotoRepository.getPhotoDetail();

      // PhotoManagerから写真数取得
      final totalCount = await PhotoManager.getAssetCount(
        type: RequestType.image,
      );
      // カウント更新
      ref
          .read(photoCountProvider.notifier)
          .updateCount(photoDetail?.currentCount ?? 0, totalCount);

      // 取得できた場合続きから写真を取得する
      if (photoDetail != null) {
        filter = _getPhotoFilter(
          photoDetail.lastId,
          DateTime.fromMillisecondsSinceEpoch(
            photoDetail.lastCreateDateSecond * 1000,
          ),
        );
      } else {
        filter = AdvancedCustomFilter();
      }
    } else {
      filter = _getPhotoFilter(lastEntity.id, lastEntity.createDateTime);
    }

    // 写真を古い順に取得
    final albums = await PhotoManager.getAssetPathList(
      type: RequestType.image,
      filterOption: filter.addOrderBy(
        column: Platform.isAndroid
            ? CustomColumns.base.id
            : CustomColumns.base.createDate,
      ),
    );

    // 写真が取得できない場合
    if (albums.isEmpty) {
      // スワイプ完了
      if (ref.read(photoCountProvider) != null) {
        ref.read(photoCountProvider.notifier).complete();
      }

      return [];
    }

    // 100件取得(とりあえずの値なのであとで変更するかも)
    final photos = await albums[0].getAssetListPaged(page: 0, size: 100);

    return photos;
  }

  /// 最新の写真を取得
  /// 最新の写真を取得するメソッド
  Future<AssetEntity?> getLatestPhoto() async {
    // 写真アルバムを取得し、最新の写真から取得するための設定
    final albums = await PhotoManager.getAssetPathList(
      type: RequestType.image,
    );

    // 写真がない場合は null を返す
    if (albums.isEmpty) {
      return null;
    }

    // アルバムから最新の写真1枚を取得
    final photo = await albums[0].getAssetListPaged(
      page: 0,
      size: 1, // 1枚だけ取得
    );

    return photo.isNotEmpty ? photo.first : null;
  }

  /// フィルタリング
  /// [lastId] 最後の写真id
  /// [lastDate] 最後の写真日付
  AdvancedCustomFilter _getPhotoFilter(
    String lastId,
    DateTime lastDate,
  ) {
    if (Platform.isAndroid) {
      return _getPhotoFilterForAndroid(lastId);
    } else {
      return _getPhotoFilterForIos(lastDate);
    }
  }

  /// Android用のフィルタリング
  /// 写真idでフィルタリングする
  /// [lastId] 最後の写真id
  AdvancedCustomFilter _getPhotoFilterForAndroid(
    String lastId,
  ) {
    return AdvancedCustomFilter(
      where: [
        ColumnWhereCondition(
          column: CustomColumns.base.id,
          operator: '>',
          value: lastId,
        ),
      ],
    );
  }

  /// iOS用のフィルタリング
  /// 写真日付でフィルタリングする
  /// [lastDate] 最後の写真日付
  AdvancedCustomFilter _getPhotoFilterForIos(
    DateTime lastDate,
  ) {
    return AdvancedCustomFilter(
      where: [
        DateColumnWhereCondition(
          column: CustomColumns.base.createDate,
          operator: '>',
          value: lastDate.add(
            const Duration(seconds: 1),
          ),
        ),
      ],
    );
  }
}
