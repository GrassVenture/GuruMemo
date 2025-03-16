import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../core/logger.dart';
import 'store.dart';

/// [Store]用コレクションのためのレファレンス
///
/// [Store]ドキュメントの操作にはこのレファレンスを経由すること。
/// fromFirestoreではドキュメントidを追加し、toFirestoreではドキュメントidを削除する。
/// 常にtoFirestoreを経由するために、ドキュメント更新時には
/// [DocumentReference.update]ではなく[DocumentReference.set]を用いる。
CollectionReference<Store> storesRef({required String userId}) {
  return FirebaseFirestore.instance.collection('stores').withConverter<Store>(
    fromFirestore: (snapshot, _) {
      final data = snapshot.data()!;
      return Store.fromJson(<String, dynamic>{
        ...data,
        'id': snapshot.id,
      });
    },
    toFirestore: (store, _) {
      final json = store.toJson()..remove('id');
      return json;
    },
  );
}

final Provider<StoreRepository> storeRepositoryProvider =
    Provider((ref) => StoreRepository._());

class StoreRepository {
  StoreRepository._();

  Future<Store?> getStoreById({
    required String userId,
    required String storeId,
  }) async {
    try {
      final docSnapshot = await storesRef(userId: userId).doc(storeId).get();
      if (docSnapshot.exists) {
        return docSnapshot.data();
      } else {
        return null;
      }
    } on Exception catch (e) {
      logger.e('Error fetching store: $e');
      return null;
    }
  }

  // areaStoreIdsのリストを引数に、Storesのリストを受け取る処理を追加
  Future<List<Store>> getStoresInfo({
    required List<String> areaStoreIds,
  }) async {
    try {
      // `in` クエリを使用して、複数の storeId に一致するドキュメントを一度に取得する
      final querySnapshot = await FirebaseFirestore.instance
          .collection('stores')
          .where(FieldPath.documentId, whereIn: areaStoreIds)
          .get();

      // ドキュメントを Store オブジェクトに変換してリストにする
      final stores = querySnapshot.docs.map((doc) {
        final data = doc.data();
        return Store.fromJson({
          ...data,
          'id': doc.id, // ドキュメントIDをセット
        });
      }).toList();

      return stores;
    } on Exception catch (e) {
      logger.e('An error occurred while fetching stores: $e');
      return [];
    }
  }
}
