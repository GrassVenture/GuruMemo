import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';

import 'card_back.dart';
import 'card_front.dart';

class PhotoDetailCard extends StatelessWidget {
  const PhotoDetailCard({
    super.key,
    required this.isEditing,
    required this.onDelete,
    required this.onSelected,
    required this.userId,
    required this.photoId,
    required this.areaStoreIds,
    required this.storeName,
    required this.dateTime,
    required this.address,
    required this.photoUrl,
    required this.storeUrl,
    required this.storeImageUrls,
    this.showCardBack = true,
    required this.storeOpeningHours,
    required this.shotAt,
  });

  final bool isEditing;
  final VoidCallback onDelete;
  final String userId;
  final String photoId;
  final List<String> areaStoreIds;
  final String storeName;
  final DateTime dateTime;
  final String address;
  final String photoUrl;
  final String storeUrl;
  final List<String> storeImageUrls;
  final bool showCardBack;
  final Map<String, String> storeOpeningHours;
  final void Function() onSelected;
  final DateTime? shotAt;

  @override
  Widget build(BuildContext context) {
    return showCardBack
        ? FlipCard(
            fill: Fill.fillBack,
            front: CardFront(
              photoUrl: photoUrl,
              storeName: storeName,
              dateTime: dateTime,
              address: address,
              showCardBack: showCardBack,
              isEditing: isEditing,
              onDelete: onDelete,
              shotAt: shotAt,
            ),
            back: CardBack(
              onSelected: onSelected,
              userId: userId,
              photoId: photoId,
              areaStoreIds: areaStoreIds,
              isLinked: true,
              storeName: storeName,
              storeImageUrls: storeImageUrls,
              address: address,
              storeUrl: storeUrl,
              storeOpeningHours: storeOpeningHours,
            ),
          )
        : CardFront(
            photoUrl: photoUrl,
            storeName: storeName,
            dateTime: dateTime,
            address: address,
            showCardBack: showCardBack,
            isEditing: isEditing,
            onDelete: onDelete,
            shotAt: shotAt,
          );
  }
}
