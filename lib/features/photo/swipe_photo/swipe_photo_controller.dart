import 'dart:async';

import 'package:photo_manager/photo_manager.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/exception.dart';
import '../../../core/image_helper.dart';
import '../../../core/logger.dart';
import '../../../core/repositories/shared_preferences_repository.dart';
import '../../../core/timestamp_converter.dart';
import '../../auth/auth_controller.dart';
import '../local_photo_manager_service.dart';
import '../local_photo_repository.dart';
import '../remote_photo_repository.dart';
import 'photo_count.dart';

part 'swipe_photo_controller.g.dart';

/// 写真のカウントを管理するProvider
/// スワイプ画面の上部のカウントに使用
class _PhotoCountNotifier extends AutoDisposeNotifier<PhotoCount?> {
  @override
  PhotoCount? build() => null;

  /// カウント更新
  void updateCount(int current, int total) => state = PhotoCount(
        current: current,
        total: total,
      );

  /// 現在のカウント更新
  void updateCurrentCount() {
    state = state?.copyWith(
      current: (state?.current ?? 0) + 1,
    );
  }

  /// 完了
  void complete() {
    state = null;
  }
}

final AutoDisposeNotifierProvider<_PhotoCountNotifier, PhotoCount?>
    photoCountProvider =
    NotifierProvider.autoDispose<_PhotoCountNotifier, PhotoCount?>(
  _PhotoCountNotifier.new,
);

/// グルメの登録数を取得するProvider
/// 分類完了後の 「追加された写真 ＋XXX枚」に使用
class _FoodPhotoTotalNotifier extends AutoDisposeAsyncNotifier<int> {
  @override
  Future<int> build() {
    // 取得できない場合はデフォルト値設定
    return ref.read(localPhotoRepositoryProvider).getFoodPhotoTotal();
  }
}

final AutoDisposeAsyncNotifierProvider<_FoodPhotoTotalNotifier, int>
    foodPhotoTotalProvider =
    AsyncNotifierProvider.autoDispose<_FoodPhotoTotalNotifier, int>(
  _FoodPhotoTotalNotifier.new,
);

/// 写真を取得するProvider
class _PhotoListNotifier extends AutoDisposeAsyncNotifier<List<AssetEntity>> {
  /// 初期処理
  @override
  Future<List<AssetEntity>> build() async {
    // パーミッション確認
    final permission = await PhotoManager.requestPermissionExtend();
    if (!permission.isAuth && !permission.hasAccess) {
      throw PermissionException();
    }

    // 写真取得
    return ref.read(localPhotoManagerServiceProvider).getAllPhotos();
  }

  Future<void> loadNext({bool isFood = false, required int index}) async {
    // データがない時は何もしない
    final value = state.valueOrNull;
    if (value == null || state.asData == null) {
      return;
    }

    // エラーがある時は何もしない
    if (state.hasError) {
      return;
    }

    final photos = state.asData!.value;
    final photo = photos[index];
    final length = photos.length;
    // IDのスラッシュをハイフンに置換
    final modifiedPhotoId = photo.id.replaceAll('/', '-');

    try {
      final userId = ref.read(userIdProvider);

      if (userId != null) {
        // TODO(kim): ローカルに写真を保存している処理が不要なものの、
        //　保存枚数などの処理は必要なので、処理の中身を後ほど修正する。
        // 写真登録
        await ref.read(localPhotoRepositoryProvider).savePhoto(
              photo: photo,
              isFood: isFood,
            );

        // 写真情報をサーバーに登録
        if (isFood) {
          if (photo.longitude != null && photo.latitude != null) {
            await ref.read(photoRepositoryProvider).registerStoreInfo(
                  photoId: modifiedPhotoId,
                  userId: userId,
                  latitude: photo.latitude,
                  longitude: photo.longitude,
                );
          }

          final photoFile = await photo.file;
          if (photoFile != null) {
            final compressedData = await ImageHelper.compress(photoFile);
            if (compressedData != null) {
              await ref.read(photoRepositoryProvider).registerPhotoData(
                    userId: userId,
                    shotAt: UnionTimestamp.dateTime(photo.createDateTime),
                    photoId: modifiedPhotoId,
                  );
              await ref.read(photoRepositoryProvider).categorizeFood(
                    userId: userId,
                    photoId: modifiedPhotoId,
                    photoData: compressedData,
                  );
            }
          }
        }
      } else {
        throw Exception('User not signed in');
      }
      // カウント更新
      ref.read(photoCountProvider.notifier).updateCurrentCount();
    } on Exception catch (e, stacktrace) {
      state = AsyncValue.error(e, stacktrace);
      logger.e('Error loading next: $e');
      return;
    }

    // 最後の写真までスワイプしていない場合
    if (index != length - 1) {
      return;
    }

    // 最後の写真までスワイプした場合
    // ローディング
    state = const AsyncValue<List<AssetEntity>>.loading();

    try {
      // 次の写真リストをDBから取得
      final results =
          await ref.read(localPhotoManagerServiceProvider).getAllPhotos(
                lastEntity: photos[index],
              );

      // 状態更新
      state = AsyncValue<List<AssetEntity>>.data([
        ...results,
      ]);
    } on Exception catch (e, stacktrace) {
      state = AsyncValue.error(e, stacktrace);
      return;
    }
  }

  /// 強制リフレッシュ
  void forceRefresh() {
    state = const AsyncLoading<List<AssetEntity>>();
    ref.invalidateSelf();
  }
}

final AutoDisposeAsyncNotifierProvider<_PhotoListNotifier, List<AssetEntity>>
    photoListProvider =
    AsyncNotifierProvider.autoDispose<_PhotoListNotifier, List<AssetEntity>>(
  _PhotoListNotifier.new,
);

/// [SharedPreferencesRepository]と連携して、写真分類スタート画面表示フラグを管理するNotifier
@Riverpod(keepAlive: true)
class IsClassifyOnboardingCompletedNotifier
    extends _$IsClassifyOnboardingCompletedNotifier {
  SharedPreferencesRepository get _sharedPreferencesRepository =>
      ref.read(sharedPreferencesRepositoryProvider);

  @override
  bool build() {
    return _sharedPreferencesRepository.getBool(
      key: SharedPreferencesKey.isClassifyOnboardingCompleted,
    );
  }

  /// [SharedPreferencesRepository]の値とともに更新する
  Future<void> update({required bool isClassifyOnboardingCompleted}) async {
    final value = await _sharedPreferencesRepository.setBool(
      key: SharedPreferencesKey.isClassifyOnboardingCompleted,
      value: isClassifyOnboardingCompleted,
    );
    state = value;
  }
}
