import 'package:freezed_annotation/freezed_annotation.dart';

import '../../core/timestamp_converter.dart';

part 'photo.freezed.dart';
part 'photo.g.dart';

@freezed
class Photo with _$Photo {
  const factory Photo({
    /// firestore上のドキュメントID
    @Default('') String id,

    /// 作成日時
    @timestampConverter
    @Default(UnionTimestamp.serverTimestamp())
    UnionTimestamp createdAt,

    /// 更新日時
    @serverTimestampConverter
    @Default(UnionTimestamp.serverTimestamp())
    UnionTimestamp updatedAt,

    /// FirebaseStorageに保存された写真の周辺店舗のIdリスト
    @Default(<String>[]) List<String> areaStoreIds,

    /// FirebaseStorageに保存された写真のURL
    @Default('') String url,

    /// geminiで推論した写真のカテゴリ
    /// ここをstringではなくてenumに変換して格納しておくと、
    /// Flutter上では型安全に扱えて想定外の実行時エラーが防げるため修正したい
    @Default('') String category,

    /// FirebaseStorageのドキュメントID
    @Default('') String userId,

    /// 写真の撮影日時
    @timestampConverter
    @Default(UnionTimestamp.serverTimestamp())
    UnionTimestamp shotAt,
    @Default('') String storeId,

    /// 写真分類用APIの実行状態
    // @SingleClassifyPhotoStatus()
    // @Default(SingleClassifyPhotoStatus.readyForUse)
    // SingleClassifyPhotoStatus classifyPhotosStatus,
  }) = _Photo;

  const Photo._();

  factory Photo.fromJson(Map<String, dynamic> json) => _$PhotoFromJson(json);
}

/// 写真分類用APIの実行状態を表すenum
// @JsonEnum(alwaysCreate: true)
// enum SingleClassifyPhotoStatus {
//   /// 処理中
//   processing,
//
//   /// 利用の準備が整っている
//   readyForUse,
//
//   /// 失敗
//   // TODO(masaki): エラーハンドリングを別途検討
//   failed;
// }

/// [SingleClassifyPhotoStatus]用JsonConverter
// class SingleClassifyPhotoStatusConverter
//     implements JsonConverter<SingleClassifyPhotoStatus, String> {
//   const SingleClassifyPhotoStatusConverter();
//
//   @override
//   SingleClassifyPhotoStatus fromJson(String value) {
//     switch (value) {
//       case 'processing':
//         return SingleClassifyPhotoStatus.processing;
//       case 'readyForUse':
//         return SingleClassifyPhotoStatus.readyForUse;
//       case 'failed':
//         return SingleClassifyPhotoStatus.failed;
//       default:
//         return SingleClassifyPhotoStatus.readyForUse;
//     }
//   }

// @override
// String toJson(SingleClassifyPhotoStatus object) {
//   return object.name;
// }
// }
