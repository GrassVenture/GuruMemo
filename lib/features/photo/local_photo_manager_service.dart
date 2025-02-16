import 'dart:io';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/exception/permission_exception.dart';
import '../../core/logger.dart';
import 'local_photo_repository.dart';
import 'swipe_photo/swipe_photo_controller.dart';

part 'local_photo_manager_service.g.dart';

/// [LocalPhotoManagerService]用Provider
@riverpod
LocalPhotoManagerService localPhotoManagerService(
  LocalPhotoManagerServiceRef ref,
) {
  return LocalPhotoManagerService._(ref);
}

/// デバイスの写真を取得する[PhotoManager]を操作するクラス
class LocalPhotoManagerService {
  LocalPhotoManagerService._(this._ref);

  final Ref _ref;

  LocalPhotoRepository get _localPhotoRepository =>
      _ref.read(localPhotoRepositoryProvider);

  /// **写真アクセスの権限をチェック**
  Future<void> checkPermission() async {
    final permission = await PhotoManager.requestPermissionExtend();
    if (!permission.isAuth && !permission.hasAccess) {
      throw const PermissionException(
        PermissionExceptionCode.localStragePermissonException,
      );
    }
  }

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
      _ref
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
      if (_ref.read(photoCountProvider) != null) {
        _ref.read(photoCountProvider.notifier).complete();
      }

      return [];
    }

    // 100件取得(とりあえずの値なのであとで変更するかも)
    final photos = await albums[0].getAssetListPaged(page: 0, size: 100);

    return photos;
  }

  /// 指定した件数・順番で写真を取得
  /// [limit] 取得件数
  /// [sortOrder] 並び順（昇順: true / 降順: false）
  Future<List<AssetEntity>> getFilteredPhotos({
    required int limit,
    required bool sortOrder,
  }) async {
    try {
      final albums = await PhotoManager.getAssetPathList(
        type: RequestType.image,
        filterOption: FilterOptionGroup(
          orders: [
            OrderOption(
              asc: sortOrder,
            ),
          ],
        ),
      );

      // 写真が取得できない場合
      if (albums.isEmpty) {
        return [];
      }

      // 指定した件数分の写真を取得
      return await albums[0].getAssetListPaged(page: 0, size: limit);
    } on Exception catch (e) {
      logger.e('Error getting filtered photos: $e');
      return [];
    }
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
