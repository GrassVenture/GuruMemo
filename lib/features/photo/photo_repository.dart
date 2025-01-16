import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;

import '../../core/flavor.dart';
import '../../core/logger.dart';
import 'photo.dart';

/// [Photo]用コレクションのためのレファレンス
///
/// [Photo]ドキュメントの操作にはこのレファレンスを経由すること。
/// fromFirestoreではドキュメントidを追加し、toFirestoreではドキュメントidを削除する。
/// 常にtoFirestoreを経由するために、ドキュメント更新時には
/// [DocumentReference.update]ではなく[DocumentReference.set]を用いる。
CollectionReference<Photo> photosRef({required String userId}) {
  return FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('photos')
      .withConverter<Photo>(
    fromFirestore: (snapshot, _) {
      final data = snapshot.data()!;
      return Photo.fromJson(<String, dynamic>{
        ...data,
        'id': snapshot.id,
      });
    },
    toFirestore: (photo, _) {
      final json = photo.toJson()..remove('id');
      return json;
    },
  );
}

final photoRepositoryProvider = Provider((ref) => PhotoRepository._());

class PhotoRepository {
  PhotoRepository._();

  // OAuth 2.0 REST APIエンドポイント
  final String _apiUrl =
      flavor.isProd ? dotenv.env['PROD_API_URL']! : dotenv.env['DEV_API_URL']!;

  Future<void> registerStoreInfo({
    required String photoId,
    String? accessToken,
    String? userId,
    double? latitude,
    double? longitude,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_apiUrl/findNearbyRestaurants'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({
          'userId': userId,
          'lat': latitude,
          'lon': longitude,
          'photo_id': photoId,
        }),
      );

      if (response.statusCode == 200) {
        // 成功した場合の処理
        debugPrint('API call successful: ${response.body}');
      } else {
        // エラーが返された場合の処理
        debugPrint('API call failed: ${response.body}');
      }
    } on Exception catch (error) {
      logger.e(error.toString());
    }
  }

  Future<void> categorizeFood({
    required String userId,
    required String photoId,
    required Uint8List photoData,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_apiUrl/categorizeFood'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'userId': userId,
          'photoId': photoId,
          'photo': base64Encode(photoData),
        }),
      );

      if (response.statusCode == 200) {
        // 成功した場合の処理
        debugPrint('API call successful: ${response.body}');
      } else {
        // エラーが返された場合の処理
        debugPrint('API call failed: ${response.body}');
      }
    } on Exception catch (error) {
      logger.e(error.toString());
    }
  }

  // TODO(firestore): データ作成後に動作確認 & 全件取得ではない取得方法検討
  Future<List<Photo>> downloadPhotos({
    required String userId,
  }) async {
    try {
      // Firestoreのクエリを実行して、ドキュメントIDで降順にソート
      final QuerySnapshot photosSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('photos')

          // ドキュメントIDで降順にソート
          .orderBy(FieldPath.documentId, descending: true)
          .get();

      // ドキュメントのデータをPhotoオブジェクトに変換
      return photosSnap.docs
          .map((doc) {
            final data = doc.data();
            if (data != null) {
              (data as Map<String, dynamic>).addAll({'id': doc.id});
              // nullチェックを追加
              return Photo.fromJson(data);
            } else {
              return null;
            }
          })
          .where((photo) => photo != null)
          .cast<Photo>()
          .toList();
    } on Exception catch (e) {
      logger.e('An error occurred: $e');
      return [];
    }
  }

  // TODO(kim): Photo?の部分はあとで書き換える。
  Future<Photo?> downloadPhoto({
    required String userId,
    required String photoId,
  }) async {
    try {
      // Firestoreのクエリを実行して、ドキュメントIDで降順にソート
      final photosSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('photos')
          .doc(photoId)
          .get();

      final data = photosSnap.data();
      if (data != null) {
        data.addAll({'id': photosSnap.id});

        return Photo.fromJson(data);
      } else {
        return null;
      }
    } on Exception catch (e) {
      logger.e('An error occurred: $e');
      return null;
    }
  }

  Future<Photo?> getPhotoById({
    required String userId,
    required String photoId,
  }) async {
    try {
      final docSnapshot = await photosRef(userId: userId).doc(photoId).get();
      if (docSnapshot.exists) {
        return docSnapshot.data();
      } else {
        return null;
      }
    } on Exception catch (e) {
      logger.e('Error fetching photo: $e');
      return null;
    }
  }

  Future<String> getStoreNameByStoreId({
    required String userId,
    required String storeId,
  }) async {
    try {
      // Fetching the document snapshot from Firestore
      final DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('stores')
          .doc(storeId)
          .get();

      // Checking if the document exists
      if (doc.exists) {
        // Extracting data from the document snapshot
        final data = doc.data() as Map<String, dynamic>?;
        if (data != null && data.containsKey('name')) {
          return data['name'] as String;
        } else {
          throw Exception('Name field not found in the document');
        }
      } else {
        throw Exception('Store not found');
      }
    } on Exception catch (e) {
      // Logging the error and returning an empty string
      logger.e('Error fetching store name: $e');
      return '';
    }
  }

  /// [photoId] に対応する Firestore ドキュメントの [storeId] を更新するメソッド
  ///
  Future<void> updateStoreIdForPhoto(
    String userId,
    String photoId,
    String storeId,
  ) async {
    final photoDoc = photosRef(userId: userId).doc(photoId);
    final photoDocSnapshot = await photoDoc.get();

    if (photoDocSnapshot.exists) {
      // ドキュメントが存在する場合、storeIdを更新
      await photoDoc.update({'storeId': storeId});
      debugPrint('StoreId updated successfully for photoId: $photoId');
    } else {
      logger.e('Error Photo with id: $photoId does not exist.');
    }
  }

  /// FirestoreとGCSから写真を削除する
  Future<void> deletePhoto(
    String userId,
    String photoId,
    String photoUrl,
  ) async {
    try {
      // Firestoreから該当の写真ドキュメントを削除
      final photoDoc = photosRef(userId: userId).doc(photoId);
      await photoDoc.delete();
      debugPrint('Firestore document deleted for photoId: $photoId');

      // GCSから該当の写真ファイルを削除
      final storageRef = FirebaseStorage.instance.refFromURL(photoUrl);
      await storageRef.delete();
      debugPrint('Photo deleted from storage for photoUrl: $photoUrl');
    } on Exception catch (e) {
      // エラーハンドリング
      logger.e('Failed to delete photo: $e');
      throw Exception('Failed to delete photo: $e');
    }
  }
}
