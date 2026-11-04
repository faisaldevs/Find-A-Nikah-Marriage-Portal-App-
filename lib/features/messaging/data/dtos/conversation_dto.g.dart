// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversation_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConversationDto _$ConversationDtoFromJson(Map<String, dynamic> json) =>
    ConversationDto(
      id: json['id'] as String,
      peer: ChatPeerDto.fromJson(json['peer'] as Map<String, dynamic>),
      slot: (json['slot'] as num).toInt(),
      lastMessage: json['lastMessage'] == null
          ? null
          : ChatMessageDto.fromJson(
              json['lastMessage'] as Map<String, dynamic>,
            ),
      unreadCount: (json['unreadCount'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$ConversationDtoToJson(ConversationDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'peer': instance.peer,
      'slot': instance.slot,
      'lastMessage': instance.lastMessage,
      'unreadCount': instance.unreadCount,
    };
