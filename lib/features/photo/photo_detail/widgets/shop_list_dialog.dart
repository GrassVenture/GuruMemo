import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/build_context_extension.dart';
import '../../../../core/services/analytics_service.dart';
import '../../../../core/themes.dart';
import '../../../../core/widgets/custom_elevated_button.dart';
import '../../../../core/widgets/scalable_photo.dart';
import '../../../store/store.dart';
import '../../remote_photo_controller.dart';

List<File> shopList = [];
int shopNoSelected = 0; // 初期値を0に設定

Future<void> showShopListDialog(
  BuildContext context, {
  required WidgetRef ref,
  required String userId,
  required String photoId,
  required List<Store> stores,
  required void Function() onSelected,
}) async {
  await showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            insetPadding: const EdgeInsets.symmetric(horizontal: 24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            content: Container(
              width: context.screenWidth * 0.9,
              height: context.screenHeight * 0.85,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Themes.gray[50],
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: Icon(
                          Icons.close,
                          size: 20,
                          color: Themes.gray[800],
                        ),
                      ),
                    ),
                  ),
                  const Gap(10),
                  Text(
                    '写真を撮った店舗を選んでください',
                    style: context.textTheme.titleSmall,
                  ),
                  const Gap(10),
                  Expanded(
                    child: ListView.builder(
                      itemCount: stores.length,
                      itemBuilder: (context, shopNo) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              shopNoSelected = shopNo;
                            });
                          },
                          child: Stack(
                            children: [
                              Container(
                                margin: const EdgeInsets.symmetric(
                                  vertical: 7,
                                  horizontal: 10,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 5,
                                  horizontal: 10,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 2,
                                    color: shopNoSelected == shopNo
                                        ? Themes.mainOrange
                                        : Themes.gray.shade300,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      blurRadius: 3,
                                      offset: const Offset(0, 5),
                                    ),
                                  ],
                                  color: Colors.white,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      stores[shopNo].name,
                                      style: context.textTheme.bodySmall,
                                    ),
                                    const Gap(5),
                                    SizedBox(
                                      height: 110,
                                      child: Scrollbar(
                                        child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount:
                                              stores[shopNo].imageUrls.length,
                                          itemBuilder: (context, index) {
                                            final imageUrl =
                                                stores[shopNo].imageUrls[index];
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                left: 10,
                                              ),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                child: ScalablePhoto(
                                                  height: 100,
                                                  width: 125,
                                                  photoUrl: imageUrl,
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (shopNo == shopNoSelected)
                                Positioned(
                                  right: 0,
                                  top: 0,
                                  child: Container(
                                    width: 28,
                                    height: 28,
                                    decoration: const BoxDecoration(
                                      color: Themes.mainOrange,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  const Gap(16),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: context.screenWidth * 0.05,
                    ),
                    child: SizedBox(
                      height: 44,
                      child: CustomElevatedButton(
                        onPressed: () async {
                          // 決定ボタン押下時にstoreIdを更新
                          await ref
                              .read(remotePhotoControllerProvider)
                              .updateStoreIdForPhoto(
                                userId: userId,
                                photoId: photoId,
                                storeId: stores[shopNoSelected].id,
                              );
                          await ref.read(analyticsServiceProvider).sendEvent(
                                name: 'update_store_info_for_photo',
                              );
                          onSelected();
                          shopNoSelected = 0;
                        },
                        text: '決定',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}
