import 'package:json_annotation/json_annotation.dart';

part 'chat_api_dtos.g.dart';

/// Wire formats of the chat REST API (`resources/docs/MESSAGING_API.md`).
/// Every response is `{statusCode, data, message}`. These are the raw
/// server shapes; `ConversationDto` / `ChatMessageDto` stay the dummy
/// source's format.

@JsonSerializable(createToJson: false)
class ApiPaginationDto {
  const ApiPaginationDto({this.hasNext = false});

  factory ApiPaginationDto.fromJson(Map<String, dynamic> json) =>
      _$ApiPaginationDtoFromJson(json);

  final bool hasNext;
}

/// `GET /v1/conversations`.
@JsonSerializable(createToJson: false)
class ConversationsResponseDto {
  const ConversationsResponseDto({required this.data});

  factory ConversationsResponseDto.fromJson(Map<String, dynamic> json) =>
      _$ConversationsResponseDtoFromJson(json);

  final ConversationsDataDto data;
}

@JsonSerializable(createToJson: false)
class ConversationsDataDto {
  const ConversationsDataDto({
    this.conversations = const [],
    this.pagination = const ApiPaginationDto(),
  });

  factory ConversationsDataDto.fromJson(Map<String, dynamic> json) =>
      _$ConversationsDataDtoFromJson(json);

  final List<ConversationRowDto> conversations;
  final ApiPaginationDto pagination;
}

/// A list row: the raw conversation plus `partner` and `unreadCount`.
@JsonSerializable(createToJson: false)
class ConversationRowDto {
  const ConversationRowDto({
    required this.id,
    this.partner,
    this.matchId,
    this.lastMessageAt,
    this.lastMessagePreview,
    this.lastMessageSender,
    this.unreadCount = 0,
    this.isMuted = false,
  });

  factory ConversationRowDto.fromJson(Map<String, dynamic> json) =>
      _$ConversationRowDtoFromJson(json);

  @JsonKey(name: '_id')
  final String id;
  final ConversationPartnerDto? partner;

  /// The match behind the chat; Unmatch needs it.
  final String? matchId;
  final DateTime? lastMessageAt;

  /// Null until the first message.
  final String? lastMessagePreview;

  /// User id of whoever sent the last message.
  final String? lastMessageSender;
  final int unreadCount;

  /// The caller muted this thread.
  final bool isMuted;
}

@JsonSerializable(createToJson: false)
class ConversationPartnerDto {
  const ConversationPartnerDto({
    required this.id,
    this.fullName,
    this.photoUrl,
    this.lastActiveAt,
    this.isOnline = false,
  });

  factory ConversationPartnerDto.fromJson(Map<String, dynamic> json) =>
      _$ConversationPartnerDtoFromJson(json);

  @JsonKey(name: '_id')
  final String id;
  final String? fullName;

  /// Server-relative (`/public/upload/...`).
  final String? photoUrl;
  final DateTime? lastActiveAt;
  final bool isOnline;
}

/// `POST /v1/conversations/:userId` — participants are ids only.
@JsonSerializable(createToJson: false)
class OpenConversationResponseDto {
  const OpenConversationResponseDto({required this.data});

  factory OpenConversationResponseDto.fromJson(Map<String, dynamic> json) =>
      _$OpenConversationResponseDtoFromJson(json);

  final OpenConversationDto data;
}

@JsonSerializable(createToJson: false)
class OpenConversationDto {
  const OpenConversationDto({required this.id});

  factory OpenConversationDto.fromJson(Map<String, dynamic> json) =>
      _$OpenConversationDtoFromJson(json);

  @JsonKey(name: '_id')
  final String id;
}

/// `GET /v1/conversations/:id/messages` — newest first.
@JsonSerializable(createToJson: false)
class MessagesResponseDto {
  const MessagesResponseDto({required this.data});

  factory MessagesResponseDto.fromJson(Map<String, dynamic> json) =>
      _$MessagesResponseDtoFromJson(json);

  final MessagesDataDto data;
}

@JsonSerializable(createToJson: false)
class MessagesDataDto {
  const MessagesDataDto({
    this.messages = const [],
    this.hasMore = false,
    this.nextCursor,
  });

  factory MessagesDataDto.fromJson(Map<String, dynamic> json) =>
      _$MessagesDataDtoFromJson(json);

  final List<MessageDto> messages;
  final bool hasMore;
  final String? nextCursor;
}

/// `POST /v1/conversations/:id/messages` → 201 with the raw message.
@JsonSerializable(createToJson: false)
class SendMessageResponseDto {
  const SendMessageResponseDto({required this.data});

  factory SendMessageResponseDto.fromJson(Map<String, dynamic> json) =>
      _$SendMessageResponseDtoFromJson(json);

  final MessageDto data;
}

/// A raw server message (`MESSAGE_AND_CHAT_API_SPEC.md` §2).
///
/// Ticks: sent → [isDelivered] → [isSeen] (`isRead` is the same flag).
@JsonSerializable(createToJson: false)
class MessageDto {
  const MessageDto({
    required this.id,
    required this.senderId,
    required this.createdAt,
    this.conversationId = '',
    this.receiverId,
    this.text = '',
    this.messageType = 'text',
    this.attachmentUrl,
    this.isDelivered = false,
    this.isRead = false,
    this.isSeen = false,
    this.deliveredAt,
    this.seenAt,
    this.deletedForMe = false,
    this.replyToId,
    this.replyTo,
  });

  factory MessageDto.fromJson(Map<String, dynamic> json) =>
      _$MessageDtoFromJson(json);

  @JsonKey(name: '_id')
  final String id;
  final String conversationId;
  final String senderId;
  final String? receiverId;
  final String text;

  /// `text` or `image`.
  final String messageType;

  /// Server-relative (`/public/upload/...`) for an image message.
  final String? attachmentUrl;
  final bool isDelivered;
  final bool isRead;
  final bool isSeen;
  final DateTime? deliveredAt;
  final DateTime? seenAt;

  /// The caller deleted it (for themselves); hide it.
  final bool deletedForMe;
  final DateTime createdAt;

  /// The quoted message, populated by the server on every read.
  final String? replyToId;
  final ReplyToDto? replyTo;

  bool get seen => isSeen || isRead;
}

/// The quoted message inside a reply.
@JsonSerializable(createToJson: false)
class ReplyToDto {
  const ReplyToDto({
    required this.id,
    this.senderId = '',
    this.messageType = 'text',
    this.text = '',
    this.deletedForMe = false,
  });

  factory ReplyToDto.fromJson(Map<String, dynamic> json) =>
      _$ReplyToDtoFromJson(json);

  @JsonKey(name: '_id')
  final String id;
  final String senderId;
  final String messageType;
  final String text;
  final bool deletedForMe;
}

/// `PATCH .../delivered|seen` and `GET /messages/unread-count`.
@JsonSerializable(createToJson: false)
class UnreadCountResponseDto {
  const UnreadCountResponseDto({required this.data});

  factory UnreadCountResponseDto.fromJson(Map<String, dynamic> json) =>
      _$UnreadCountResponseDtoFromJson(json);

  final UnreadCountDto data;
}

@JsonSerializable(createToJson: false)
class UnreadCountDto {
  const UnreadCountDto({this.count = 0});

  factory UnreadCountDto.fromJson(Map<String, dynamic> json) =>
      _$UnreadCountDtoFromJson(json);

  final int count;
}

/// Body of `PATCH /v1/conversations/:id/archive`.
@JsonSerializable(createFactory: false)
class ArchiveBodyDto {
  const ArchiveBodyDto({required this.archived});

  final bool archived;

  Map<String, dynamic> toJson() => _$ArchiveBodyDtoToJson(this);
}

/// Body of `POST /v1/reports`.
@JsonSerializable(createFactory: false)
class ReportBodyDto {
  const ReportBodyDto({
    required this.targetUserId,
    required this.reason,
    this.description,
  });

  /// Sent as `reportedUserId` — the live server rejects the spec's
  /// `targetUserId` with 404 "Member not found" (verified 2026-11-12).
  final String targetUserId;
  final String reason;
  final String? description;

  Map<String, dynamic> toJson() => {
    'reportedUserId': targetUserId,
    'reason': reason,
    if (description != null) 'description': description,
  };
}

/// Body of `POST /v1/conversations/:id/messages`.
@JsonSerializable(createFactory: false)
class SendMessageBodyDto {
  const SendMessageBodyDto({required this.text, this.replyToId});

  final String text;

  /// The message being quoted (same conversation).
  @JsonKey(includeIfNull: false)
  final String? replyToId;

  Map<String, dynamic> toJson() => _$SendMessageBodyDtoToJson(this);
}

/// Body of `PATCH /v1/conversations/:id/mute`.
@JsonSerializable(createFactory: false)
class MuteBodyDto {
  const MuteBodyDto({required this.muted});

  final bool muted;

  Map<String, dynamic> toJson() => _$MuteBodyDtoToJson(this);
}
