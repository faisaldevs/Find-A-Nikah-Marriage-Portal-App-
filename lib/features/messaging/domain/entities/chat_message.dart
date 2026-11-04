import 'package:equatable/equatable.dart';
import 'package:find_a_nikah/core/core.dart';
import 'package:find_a_nikah/features/messaging/domain/entities/call_log.dart';

/// Delivery state of a message the signed-in user sent. Incoming messages
/// carry it too but nothing reads it there.
enum MessageStatus { sending, sent, delivered, seen, failed }

/// The message a reply quotes, as shown above the reply's text.
class MessageReply extends Equatable {
  const MessageReply({
    required this.messageId,
    required this.isMine,
    required this.text,
  });

  final String messageId;

  /// The quoted message was the signed-in user's own.
  final bool isMine;

  final String text;

  MessageReply copyWith({
    String? messageId,
    bool? isMine,
    String? text,
  }) {
    return MessageReply(
      messageId: messageId ?? this.messageId,
      isMine: isMine ?? this.isMine,
      text: text ?? this.text,
    );
  }

  @override
  List<Object?> get props => [
    messageId,
    isMine,
    text,
  ];
}

/// One message in a conversation: text, or a call record when [callLog]
/// is set (then [text] is empty).
class ChatMessage extends Equatable {
  const ChatMessage({
    required this.id,
    required this.conversationId,
    required this.text,
    required this.sentAt,
    required this.isMine,
    this.status = MessageStatus.sent,
    this.replyTo,
    this.callLog,
  });

  final String id;
  final String conversationId;
  final String text;
  final DateTime sentAt;

  /// Sent by the signed-in user.
  final bool isMine;

  final MessageStatus status;
  final MessageReply? replyTo;
  final CallLog? callLog;

  bool get isCall => callLog != null;

  ChatMessage copyWith({
    String? id,
    String? conversationId,
    String? text,
    DateTime? sentAt,
    bool? isMine,
    MessageStatus? status,
    Object? replyTo = unchanged,
    Object? callLog = unchanged,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      conversationId: conversationId ?? this.conversationId,
      text: text ?? this.text,
      sentAt: sentAt ?? this.sentAt,
      isMine: isMine ?? this.isMine,
      status: status ?? this.status,
      replyTo: identical(replyTo, unchanged)
          ? this.replyTo
          : replyTo as MessageReply?,
      callLog: identical(callLog, unchanged)
          ? this.callLog
          : callLog as CallLog?,
    );
  }

  @override
  List<Object?> get props => [
    id,
    conversationId,
    text,
    sentAt,
    isMine,
    status,
    replyTo,
    callLog,
  ];
}
