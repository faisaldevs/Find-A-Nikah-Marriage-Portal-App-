import 'package:find_a_nikah/features/messaging/data/dtos/chat_message_dto.dart';
import 'package:find_a_nikah/features/messaging/data/dtos/chat_peer_dto.dart';
import 'package:find_a_nikah/features/messaging/domain/entities/conversation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'conversation_dto.g.dart';

/// Wire format of a conversation-list row. Kept separate from
/// [Conversation] (decisions register #4).
@JsonSerializable()
class ConversationDto {
  const ConversationDto({
    required this.id,
    required this.peer,
    required this.slot,
    this.lastMessage,
    this.unreadCount = 0,
  });

  factory ConversationDto.fromJson(Map<String, dynamic> json) =>
      _$ConversationDtoFromJson(json);

  final String id;
  final ChatPeerDto peer;

  /// 0-based position among the user's conversation slots.
  final int slot;
  final ChatMessageDto? lastMessage;
  final int unreadCount;

  Map<String, dynamic> toJson() => _$ConversationDtoToJson(this);
}
