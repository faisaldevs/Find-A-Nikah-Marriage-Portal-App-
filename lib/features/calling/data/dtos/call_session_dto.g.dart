// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_session_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CallSessionDto _$CallSessionDtoFromJson(Map<String, dynamic> json) =>
    CallSessionDto(
      id: json['id'] as String,
      peerId: json['peerId'] as String,
      direction: json['direction'] as String,
      phase: json['phase'] as String,
      connectedAt: json['connectedAt'] == null
          ? null
          : DateTime.parse(json['connectedAt'] as String),
      endedAt: json['endedAt'] == null
          ? null
          : DateTime.parse(json['endedAt'] as String),
      outcome: json['outcome'] as String?,
      muted: json['muted'] as bool? ?? false,
      speakerOn: json['speakerOn'] as bool? ?? false,
    );

Map<String, dynamic> _$CallSessionDtoToJson(CallSessionDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'peerId': instance.peerId,
      'direction': instance.direction,
      'phase': instance.phase,
      'connectedAt': instance.connectedAt?.toIso8601String(),
      'endedAt': instance.endedAt?.toIso8601String(),
      'outcome': instance.outcome,
      'muted': instance.muted,
      'speakerOn': instance.speakerOn,
    };
