// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'remote_config_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RemoteConfigDto _$RemoteConfigDtoFromJson(Map<String, dynamic> json) =>
    RemoteConfigDto(
      minimumSupportedVersion: json['minimumSupportedVersion'] as String?,
      flags:
          (json['flags'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as bool),
          ) ??
          const {},
    );

Map<String, dynamic> _$RemoteConfigDtoToJson(RemoteConfigDto instance) =>
    <String, dynamic>{
      'minimumSupportedVersion': instance.minimumSupportedVersion,
      'flags': instance.flags,
    };
