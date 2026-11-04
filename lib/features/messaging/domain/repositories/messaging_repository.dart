import 'package:find_a_nikah/core/core.dart';
import 'package:find_a_nikah/features/messaging/domain/entities/call_log.dart';
import 'package:find_a_nikah/features/messaging/domain/entities/chat_message.dart';
import 'package:find_a_nikah/features/messaging/domain/entities/chat_peer.dart';
import 'package:find_a_nikah/features/messaging/domain/entities/conversation.dart';

/// One-to-one chats with matches. The streams are where live updates land
/// (polling today, the socket later) — never push into bloc state directly.
abstract interface class MessagingRepository {
  /// Active conversations in slot order. One started from a match shows
  /// up here, in its slot, before its first message.
  Stream<List<Conversation>> watchConversations();

  /// Matches with no conversation yet — the "start a conversation" picks.
  Stream<List<ChatPeer>> watchMatches();

  /// The conversation with [peerId], created empty if there is none yet —
  /// in [slot] when given and free, else the first free slot.
  Future<Either<Failure, Conversation>> openConversation(
    String peerId, {
    int? slot,
  });

  /// [conversationId]'s messages, oldest first.
  Stream<List<ChatMessage>> watchMessages(String conversationId);

  /// Whether the peer is typing in [conversationId].
  Stream<bool> watchPeerTyping(String conversationId);

  /// Loads the page of messages before the oldest one held in
  /// [conversationId]; they arrive through [watchMessages]. Returns whether
  /// still-older ones remain.
  Future<Either<Failure, bool>> loadOlderMessages(String conversationId);

  Future<Either<Failure, Unit>> sendMessage({
    required String conversationId,
    required String text,
    String? replyToMessageId,
  });

  /// Records a finished voice call in [conversationId].
  Future<Either<Failure, Unit>> logCall({
    required String conversationId,
    required CallLog log,
  });

  /// Clears [conversationId]'s unread count.
  Future<Either<Failure, Unit>> markRead(String conversationId);
}
