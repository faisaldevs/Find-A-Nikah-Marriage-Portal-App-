import 'package:find_a_nikah/features/messaging/domain/entities/chat_message.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chat_message_dto.g.dart';

/// Wire format of one message. Kept separate from [ChatMessage]
/// (decisions register #4): the API speaks in sender ids and raw status
/// codes; the entity in `isMine` and [MessageStatus].
@JsonSerializable()
class ChatMessageDto {
  const ChatMessageDto({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.text,
    required this.sentAt,
    this.status = 'sent',
    this.replyTo,
    this.call,
  });

  factory ChatMessageDto.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageDtoFromJson(json);

  final String id;
  final String conversationId;
  final String senderId;
  final String text;
  final DateTime sentAt;

  /// `sending` · `sent` · `delivered` · `seen` · `failed`.
  final String status;
  final MessageReplyDto? replyTo;

  /// Set on call records (then [text] is empty).
  final CallLogDto? call;

  ChatMessageDto withStatus(String status) => ChatMessageDto(
    id: id,
    conversationId: conversationId,
    senderId: senderId,
    text: text,
    sentAt: sentAt,
    status: status,
    replyTo: replyTo,
    call: call,
  );

  Map<String, dynamic> toJson() => _$ChatMessageDtoToJson(this);
}

/// The quoted message embedded in a reply.
@JsonSerializable()
class MessageReplyDto {
  const MessageReplyDto({
    required this.messageId,
    required this.senderId,
    required this.text,
  });

  factory MessageReplyDto.fromJson(Map<String, dynamic> json) =>
      _$MessageReplyDtoFromJson(json);

  final String messageId;
  final String senderId;
  final String text;

  Map<String, dynamic> toJson() => _$MessageReplyDtoToJson(this);
}

/// A call record inside a message.
@JsonSerializable()
class CallLogDto {
  const CallLogDto({
    required this.outcome,
    required this.callerId,
    this.durationSeconds = 0,
  });

  factory CallLogDto.fromJson(Map<String, dynamic> json) =>
      _$CallLogDtoFromJson(json);

  /// `completed` · `missed` · `declined` · `cancelled`.
  final String outcome;

  /// Who placed the call.
  final String callerId;
  final int durationSeconds;

  Map<String, dynamic> toJson() => _$CallLogDtoToJson(this);
}
