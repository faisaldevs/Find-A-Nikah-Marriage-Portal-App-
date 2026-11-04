// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_message_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatMessageDto _$ChatMessageDtoFromJson(Map<String, dynamic> json) =>
    ChatMessageDto(
      id: json['id'] as String,
      conversationId: json['conversationId'] as String,
      senderId: json['senderId'] as String,
      text: json['text'] as String,
      sentAt: DateTime.parse(json['sentAt'] as String),
      status: json['status'] as String? ?? 'sent',
      replyTo: json['replyTo'] == null
          ? null
          : MessageReplyDto.fromJson(json['replyTo'] as Map<String, dynamic>),
      call: json['call'] == null
          ? null
          : CallLogDto.fromJson(json['call'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ChatMessageDtoToJson(ChatMessageDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'conversationId': instance.conversationId,
      'senderId': instance.senderId,
      'text': instance.text,
      'sentAt': instance.sentAt.toIso8601String(),
      'status': instance.status,
      'replyTo': instance.replyTo,
      'call': instance.call,
    };

MessageReplyDto _$MessageReplyDtoFromJson(Map<String, dynamic> json) =>
    MessageReplyDto(
      messageId: json['messageId'] as String,
      senderId: json['senderId'] as String,
      text: json['text'] as String,
    );

Map<String, dynamic> _$MessageReplyDtoToJson(MessageReplyDto instance) =>
    <String, dynamic>{
      'messageId': instance.messageId,
      'senderId': instance.senderId,
      'text': instance.text,
    };

CallLogDto _$CallLogDtoFromJson(Map<String, dynamic> json) => CallLogDto(
  outcome: json['outcome'] as String,
  callerId: json['callerId'] as String,
  durationSeconds: (json['durationSeconds'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$CallLogDtoToJson(CallLogDto instance) =>
    <String, dynamic>{
      'outcome': instance.outcome,
      'callerId': instance.callerId,
      'durationSeconds': instance.durationSeconds,
    };
