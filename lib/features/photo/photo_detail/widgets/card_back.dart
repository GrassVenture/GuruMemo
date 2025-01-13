import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/themes.dart';
import '../../../../core/widgets/guru_memo_card.dart';
import '../../../../core/widgets/scalable_photo.dart';
import '../../../store/store_controller.dart';
import 'shop_list_dialog.dart';

class CardBack extends ConsumerWidget {
  const CardBack({
    required this.onSelected,
    required this.userId,
    required this.photoId,
    required this.areaStoreIds,
    required this.isLinked,
    required this.storeName,
    required this.storeImageUrls,
    this.openTime,
    this.address,
    this.storeUrl,
    this.storeOpeningHours,
    super.key,
  });

  final String userId;
  final String photoId;
  final List<String> areaStoreIds;
  final bool isLinked;
  final String storeName;
  final List<String> storeImageUrls;
  final String? openTime;
  final String? address;
  final String? storeUrl;
  final Map<String, String>? storeOpeningHours;

  final void Function() onSelected;

  Future<void> _fetchAndShowStoresInfo(
    BuildContext context,
    WidgetRef ref,
  ) async {
    // Firestoreから店舗情報を取得する
    final stores = await ref
        .read(storeControllerProvider)
        .getStoresInfo(areaStoreIds: areaStoreIds);

    // コンテキストがまだ有効かどうかを確認する
    if (context.mounted) {
      await showShopListDialog(
        context,
        ref: ref,
        stores: stores,
        userId: userId,
        photoId: photoId,
        onSelected: () {
          onSelected();
          Navigator.of(context).pop();
        },
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!isLinked) {
      return GuruMemoCard(
        child: Container(
          padding: const EdgeInsets.only(
            top: 48,
            bottom: 40,
            left: 16,
            right: 16,
          ),
          decoration: BoxDecoration(
            border: Border.all(
              color: Themes.gray[900]!,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      );
    }

    final orderedKeys = [
      'sunday_hours',
      'monday_hours',
      'tuesday_hours',
      'wednesday_hours',
      'thursday_hours',
      'friday_hours',
      'saturday_hours',
    ];

    final Map<String, String> sortedOpeningHours;
    if (storeOpeningHours != null) {
      sortedOpeningHours = Map.fromEntries(
        storeOpeningHours!.entries.toList()
          ..sort(
            (a, b) => orderedKeys
                .indexOf(a.key)
                .compareTo(orderedKeys.indexOf(b.key)),
          ),
      );
    } else {
      sortedOpeningHours = {};
    }

    return GuruMemoCard(
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.only(
              top: 48,
              bottom: 40,
              left: 16,
              right: 16,
            ),
            decoration: BoxDecoration(
              border: Border.all(
                color: Themes.gray[900]!,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  storeName,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Divider(
                    color: Themes.gray[900],
                  ),
                ),
                if (storeImageUrls.isNotEmpty)
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 6,
                    child: Scrollbar(
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: storeImageUrls.length,
                        itemBuilder: (context, index) {
                          final photoUrl = storeImageUrls[index];
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: ScalablePhoto(
                                height: MediaQuery.of(context).size.height / 6,
                                width: MediaQuery.of(context).size.height / 6,
                                photoUrl: photoUrl,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  )
                else
                  Container(
                    height: 200,
                    width: 300,
                    color: Themes.gray[200],
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.image_outlined),
                        const Gap(4),
                        Text(
                          '画像がありません',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Divider(
                    color: Themes.gray[900],
                  ),
                ),
                if (address != null)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8),
                        child: Icon(Icons.pin_drop_outlined, size: 18),
                      ),
                      Expanded(
                        child: Text(
                          address!,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                if (storeUrl != null)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8),
                        child: Icon(Icons.link_outlined, size: 18),
                      ),
                      Expanded(
                        child: Text(
                          storeUrl!,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Divider(
                    color: Themes.gray[900],
                  ),
                ),
                if (storeOpeningHours != null)
                  Flexible(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ...sortedOpeningHours.entries.map((entry) {
                            // アイコンを最初の要素にのみ表示
                            final isFirst =
                                sortedOpeningHours.entries.first.key ==
                                    entry.key;
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2),
                              child: Row(
                                children: [
                                  if (isFirst) ...[
                                    const Padding(
                                      padding:
                                          EdgeInsets.only(left: 8, right: 8),
                                      child: Icon(Icons.access_time, size: 16),
                                    ),
                                  ] else ...[
                                    const Padding(
                                      padding: EdgeInsets.only(left: 32),
                                    ),
                                  ],
                                  Text(
                                    _getWeekday(entry.key),
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    entry.value.toLowerCase() == 'closed'
                                        ? '定休日'
                                        : entry.value,
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 32),
              ],
            ),
          ),
          Positioned.fill(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Themes.gray[200],
                          border: Border.all(
                            color: Themes.gray[900]!,
                            width: 2,
                          ),
                          borderRadius: const BorderRadius.only(
                            bottomRight: Radius.circular(16),
                            bottomLeft: Radius.circular(16),
                          ),
                        ),
                        child: TextButton(
                          onPressed: () {
                            //　発火するリクエストのメソッドの処理を追加する
                            _fetchAndShowStoresInfo(context, ref);
                          },
                          child: Text(
                            '店舗を選び直す',
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            height: 36,
            width: 36,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
              ),
              border: Border.all(
                color: Themes.gray[900]!,
                width: 2,
              ),
              color: Themes.gray[100],
            ),
            child: const Icon(Icons.refresh),
          ),
        ],
      ),
    );
  }

  String _getWeekday(String key) {
    switch (key) {
      case 'monday_hours':
        return '月:';
      case 'tuesday_hours':
        return '火:';
      case 'wednesday_hours':
        return '水:';
      case 'thursday_hours':
        return '木:';
      case 'friday_hours':
        return '金:';
      case 'saturday_hours':
        return '土:';
      case 'sunday_hours':
        return '日:';
      default:
        return key;
    }
  }
}
