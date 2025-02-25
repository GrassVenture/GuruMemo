// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'camera_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CameraStateImpl _$$CameraStateImplFromJson(Map<String, dynamic> json) =>
    _$CameraStateImpl(
      isInitialized: json['isInitialized'] as bool? ?? false,
      capturedImagePath: json['capturedImagePath'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      isTakingPicture: json['isTakingPicture'] as bool? ?? false,
    );

Map<String, dynamic> _$$CameraStateImplToJson(_$CameraStateImpl instance) =>
    <String, dynamic>{
      'isInitialized': instance.isInitialized,
      'capturedImagePath': instance.capturedImagePath,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'isTakingPicture': instance.isTakingPicture,
    };
