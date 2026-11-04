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
    this.lastMessageAt,
    this.lastMessagePreview,
    this.lastMessageSender,
    this.unreadCount = 0,
  });

  factory ConversationRowDto.fromJson(Map<String, dynamic> json) =>
      _$ConversationRowDtoFromJson(json);

  @JsonKey(name: '_id')
  final String id;
  final ConversationPartnerDto? partner;
  final DateTime? lastMessageAt;

  /// Null until the first message.
  final String? lastMessagePreview;

  /// User id of whoever sent the last message.
  final String? lastMessageSender;
  final int unreadCount;
}

@JsonSerializable(createToJson: false)
class ConversationPartnerDto {
  const ConversationPartnerDto({
    required this.id,
    this.fullName,
    this.photoUrl,
    this.lastActiveAt,
  });

  factory ConversationPartnerDto.fromJson(Map<String, dynamic> json) =>
      _$ConversationPartnerDtoFromJson(json);

  @JsonKey(name: '_id')
  final String id;
  final String? fullName;

  /// Server-relative (`/public/upload/...`).
  final String? photoUrl;
  final DateTime? lastActiveAt;
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

/// A raw server message. No delivered state — `isRead` is all there is.
@JsonSerializable(createToJson: false)
class MessageDto {
  const MessageDto({
    required this.id,
    required this.senderId,
    required this.createdAt,
    this.conversationId = '',
    this.text = '',
    this.messageType = 'text',
    this.isRead = false,
  });

  factory MessageDto.fromJson(Map<String, dynamic> json) =>
      _$MessageDtoFromJson(json);

  @JsonKey(name: '_id')
  final String id;
  final String conversationId;
  final String senderId;
  final String text;

  /// `text` or `image` (images are out of scope for now).
  final String messageType;
  final bool isRead;
  final DateTime createdAt;
}

/// Body of `POST /v1/conversations/:id/messages`.
@JsonSerializable(createFactory: false)
class SendMessageBodyDto {
  const SendMessageBodyDto({required this.text});

  final String text;

  Map<String, dynamic> toJson() => _$SendMessageBodyDtoToJson(this);
}
