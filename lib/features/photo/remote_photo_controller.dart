import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'remote_photo.dart';
import 'remote_photo_repository.dart';

final remotePhotoControllerProvider =
    Provider<RemotePhotoController>(RemotePhotoController._);

/// 写真に関連した外部通信の操作を担当するコントローラー
///
/// 写真関連の外部通信を行う際にはこのコントローラーを[remotePhotoControllerProvider]経由で操作する。
/// 別クラスを参照する場合は、refによりgetter経由でインスタンス化して用いる。
/// refを渡さずコンストラクタから依存性を注入するようにすると
/// クラス内で_ref.invalidateメソッド等を用いたriverpodらしい状態管理が出来なくなるため、依存関係はgetterで表現しておく。
class RemotePhotoController {
  RemotePhotoController._(this._ref);

  final Ref _ref;

  PhotoRepository get _photoRepository => _ref.read(photoRepositoryProvider);

  // TODO(kim): RemotePhoto?の部分はあとで書き換える。
  Future<RemotePhoto?> downloadPhoto({
    required String userId,
    required String photoId,
  }) {
    return _photoRepository.downloadPhoto(userId: userId, photoId: photoId);
  }

  Future<String> getStoreNameByStoreId({
    required String userId,
    required String storeId,
  }) {
    return _photoRepository.getStoreNameByStoreId(
      userId: userId,
      storeId: storeId,
    );
  }

  Future<RemotePhoto?> getPhotoById({
    required String userId,
    required String photoId,
  }) {
    return _photoRepository.getPhotoById(
      userId: userId,
      photoId: photoId,
    );
  }

  /// 画像分類ステータスの更新用メソッド
  Future<void> updateStoreIdForPhoto({
    required String userId,
    required String photoId,
    required String storeId,
  }) async {
    await _photoRepository.updateStoreIdForPhoto(
      userId,
      photoId,
      storeId,
    );
  }

  /// 写真削除用メソッド
  Future<void> deletePhoto(
    String userId,
    String photoId,
    String photoUrl,
  ) async {
    await _photoRepository.deletePhoto(userId, photoId, photoUrl);
  }
}
