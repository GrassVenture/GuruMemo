// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'remote_photo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RemotePhotoImpl _$$RemotePhotoImplFromJson(Map<String, dynamic> json) =>
    _$RemotePhotoImpl(
      id: json['id'] as String? ?? '',
      createdAt: json['createdAt'] == null
          ? const UnionTimestamp.serverTimestamp()
          : timestampConverter.fromJson(json['createdAt'] as Object),
      updatedAt: json['updatedAt'] == null
          ? const UnionTimestamp.serverTimestamp()
          : serverTimestampConverter.fromJson(json['updatedAt'] as Object),
      areaStoreIds: (json['areaStoreIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      url: json['url'] as String? ?? '',
      category: json['category'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      shotAt: json['shotAt'] == null
          ? const UnionTimestamp.serverTimestamp()
          : timestampConverter.fromJson(json['shotAt'] as Object),
      storeId: json['storeId'] as String? ?? '',
    );

Map<String, dynamic> _$$RemotePhotoImplToJson(_$RemotePhotoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'createdAt': timestampConverter.toJson(instance.createdAt),
      'updatedAt': serverTimestampConverter.toJson(instance.updatedAt),
      'areaStoreIds': instance.areaStoreIds,
      'url': instance.url,
      'category': instance.category,
      'userId': instance.userId,
      'shotAt': timestampConverter.toJson(instance.shotAt),
      'storeId': instance.storeId,
    };
