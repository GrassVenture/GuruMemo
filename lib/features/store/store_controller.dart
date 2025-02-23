import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'store.dart';
import 'store_repository.dart';

final storeControllerProvider = Provider<StoreController>(StoreController._);

/// ストアに関連した外部通信の操作を担当するコントローラー
///
/// ストア関連の外部通信を行う際にはこのコントローラーを[storeControllerProvider]経由で操作する。
/// 別クラスを参照する場合は、refによりgetter経由でインスタンス化して用いる。
/// refを渡さずコンストラクタから依存性を注入するようにすると
/// クラス内で_ref.invalidateメソッド等を用いたriverpodらしい状態管理が出来なくなるため、依存関係はgetterで表現しておく。
class StoreController {
  StoreController._(this._ref);

  final Ref _ref;

  StoreRepository get _storeRepository => _ref.read(storeRepositoryProvider);

  /// 写真ダウンロード用メソッド
  Future<List<Store>> getStoresInfo({
    required List<String> areaStoreIds,
  }) {
    return _storeRepository.getStoresInfo(areaStoreIds: areaStoreIds);
  }

  Future<Store?> getStoreById({
    required String userId,
    required String storeId,
  }) {
    return _storeRepository.getStoreById(
      userId: userId,
      storeId: storeId,
    );
  }
}
