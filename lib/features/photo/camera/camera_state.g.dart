// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'camera_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CameraStateImpl _$$CameraStateImplFromJson(Map<String, dynamic> json) =>
    _$CameraStateImpl(
      capturedImage:
          const FileConverter().fromJson(json['capturedImage'] as String?),
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      imageDate: json['imageDate'] as String?,
      isTakingPicture: json['isTakingPicture'] as bool? ?? false,
    );

Map<String, dynamic> _$$CameraStateImplToJson(_$CameraStateImpl instance) =>
    <String, dynamic>{
      'capturedImage': const FileConverter().toJson(instance.capturedImage),
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'imageDate': instance.imageDate,
      'isTakingPicture': instance.isTakingPicture,
    };
