import 'package:equatable/equatable.dart';
import 'package:find_a_nikah/core/core.dart';
import 'package:find_a_nikah/features/messaging/domain/entities/chat_message.dart';
import 'package:find_a_nikah/features/messaging/domain/entities/chat_peer.dart';

/// A one-to-one chat with a match, as listed on the Chat tab.
class Conversation extends Equatable {
  const Conversation({
    required this.id,
    required this.peer,
    required this.slot,
    this.lastMessage,
    this.unreadCount = 0,
  });

  final String id;
  final ChatPeer peer;

  /// 0-based position among the Chat tab's conversation slots — a
  /// conversation stays where it was started.
  final int slot;

  /// Null until either side sends the first message.
  final ChatMessage? lastMessage;

  final int unreadCount;

  bool get hasUnread => unreadCount > 0;

  Conversation copyWith({
    String? id,
    ChatPeer? peer,
    int? slot,
    Object? lastMessage = unchanged,
    int? unreadCount,
  }) {
    return Conversation(
      id: id ?? this.id,
      peer: peer ?? this.peer,
      slot: slot ?? this.slot,
      lastMessage: identical(lastMessage, unchanged)
          ? this.lastMessage
          : lastMessage as ChatMessage?,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }

  @override
  List<Object?> get props => [
    id,
    peer,
    slot,
    lastMessage,
    unreadCount,
  ];
}
