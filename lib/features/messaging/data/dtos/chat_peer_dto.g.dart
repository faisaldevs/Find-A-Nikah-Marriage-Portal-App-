// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_peer_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatPeerDto _$ChatPeerDtoFromJson(Map<String, dynamic> json) => ChatPeerDto(
  id: json['id'] as String,
  name: json['name'] as String,
  photoUrl: json['photoUrl'] as String,
  isOnline: json['isOnline'] as bool? ?? false,
  lastSeenAt: json['lastSeenAt'] == null
      ? null
      : DateTime.parse(json['lastSeenAt'] as String),
  matchId: json['matchId'] as String?,
);

Map<String, dynamic> _$ChatPeerDtoToJson(ChatPeerDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'photoUrl': instance.photoUrl,
      'isOnline': instance.isOnline,
      'lastSeenAt': instance.lastSeenAt?.toIso8601String(),
      'matchId': instance.matchId,
    };
