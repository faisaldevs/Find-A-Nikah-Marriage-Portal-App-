// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_api_dtos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiPaginationDto _$ApiPaginationDtoFromJson(Map<String, dynamic> json) =>
    ApiPaginationDto(hasNext: json['hasNext'] as bool? ?? false);

ConversationsResponseDto _$ConversationsResponseDtoFromJson(
  Map<String, dynamic> json,
) => ConversationsResponseDto(
  data: ConversationsDataDto.fromJson(json['data'] as Map<String, dynamic>),
);

ConversationsDataDto _$ConversationsDataDtoFromJson(
  Map<String, dynamic> json,
) => ConversationsDataDto(
  conversations:
      (json['conversations'] as List<dynamic>?)
          ?.map((e) => ConversationRowDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  pagination: json['pagination'] == null
      ? const ApiPaginationDto()
      : ApiPaginationDto.fromJson(json['pagination'] as Map<String, dynamic>),
);

ConversationRowDto _$ConversationRowDtoFromJson(Map<String, dynamic> json) =>
    ConversationRowDto(
      id: json['_id'] as String,
      partner: json['partner'] == null
          ? null
          : ConversationPartnerDto.fromJson(
              json['partner'] as Map<String, dynamic>,
            ),
      matchId: json['matchId'] as String?,
      lastMessageAt: json['lastMessageAt'] == null
          ? null
          : DateTime.parse(json['lastMessageAt'] as String),
      lastMessagePreview: json['lastMessagePreview'] as String?,
      lastMessageSender: json['lastMessageSender'] as String?,
      unreadCount: (json['unreadCount'] as num?)?.toInt() ?? 0,
      isMuted: json['isMuted'] as bool? ?? false,
    );

ConversationPartnerDto _$ConversationPartnerDtoFromJson(
  Map<String, dynamic> json,
) => ConversationPartnerDto(
  id: json['_id'] as String,
  fullName: json['fullName'] as String?,
  photoUrl: json['photoUrl'] as String?,
  lastActiveAt: json['lastActiveAt'] == null
      ? null
      : DateTime.parse(json['lastActiveAt'] as String),
  isOnline: json['isOnline'] as bool? ?? false,
);

OpenConversationResponseDto _$OpenConversationResponseDtoFromJson(
  Map<String, dynamic> json,
) => OpenConversationResponseDto(
  data: OpenConversationDto.fromJson(json['data'] as Map<String, dynamic>),
);

OpenConversationDto _$OpenConversationDtoFromJson(Map<String, dynamic> json) =>
    OpenConversationDto(id: json['_id'] as String);

MessagesResponseDto _$MessagesResponseDtoFromJson(Map<String, dynamic> json) =>
    MessagesResponseDto(
      data: MessagesDataDto.fromJson(json['data'] as Map<String, dynamic>),
    );

MessagesDataDto _$MessagesDataDtoFromJson(Map<String, dynamic> json) =>
    MessagesDataDto(
      messages:
          (json['messages'] as List<dynamic>?)
              ?.map((e) => MessageDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      hasMore: json['hasMore'] as bool? ?? false,
      nextCursor: json['nextCursor'] as String?,
    );

SendMessageResponseDto _$SendMessageResponseDtoFromJson(
  Map<String, dynamic> json,
) => SendMessageResponseDto(
  data: MessageDto.fromJson(json['data'] as Map<String, dynamic>),
);

MessageDto _$MessageDtoFromJson(Map<String, dynamic> json) => MessageDto(
  id: json['_id'] as String,
  senderId: json['senderId'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  conversationId: json['conversationId'] as String? ?? '',
  receiverId: json['receiverId'] as String?,
  text: json['text'] as String? ?? '',
  messageType: json['messageType'] as String? ?? 'text',
  attachmentUrl: json['attachmentUrl'] as String?,
  isDelivered: json['isDelivered'] as bool? ?? false,
  isRead: json['isRead'] as bool? ?? false,
  isSeen: json['isSeen'] as bool? ?? false,
  deliveredAt: json['deliveredAt'] == null
      ? null
      : DateTime.parse(json['deliveredAt'] as String),
  seenAt: json['seenAt'] == null
      ? null
      : DateTime.parse(json['seenAt'] as String),
  deletedForMe: json['deletedForMe'] as bool? ?? false,
  replyToId: json['replyToId'] as String?,
  replyTo: json['replyTo'] == null
      ? null
      : ReplyToDto.fromJson(json['replyTo'] as Map<String, dynamic>),
);

ReplyToDto _$ReplyToDtoFromJson(Map<String, dynamic> json) => ReplyToDto(
  id: json['_id'] as String,
  senderId: json['senderId'] as String? ?? '',
  messageType: json['messageType'] as String? ?? 'text',
  text: json['text'] as String? ?? '',
  deletedForMe: json['deletedForMe'] as bool? ?? false,
);

UnreadCountResponseDto _$UnreadCountResponseDtoFromJson(
  Map<String, dynamic> json,
) => UnreadCountResponseDto(
  data: UnreadCountDto.fromJson(json['data'] as Map<String, dynamic>),
);

UnreadCountDto _$UnreadCountDtoFromJson(Map<String, dynamic> json) =>
    UnreadCountDto(count: (json['count'] as num?)?.toInt() ?? 0);

Map<String, dynamic> _$ArchiveBodyDtoToJson(ArchiveBodyDto instance) =>
    <String, dynamic>{'archived': instance.archived};

Map<String, dynamic> _$ReportBodyDtoToJson(ReportBodyDto instance) =>
    <String, dynamic>{
      'targetUserId': instance.targetUserId,
      'reason': instance.reason,
      'description': instance.description,
    };

Map<String, dynamic> _$SendMessageBodyDtoToJson(SendMessageBodyDto instance) =>
    <String, dynamic>{'text': instance.text, 'replyToId': ?instance.replyToId};

Map<String, dynamic> _$MuteBodyDtoToJson(MuteBodyDto instance) =>
    <String, dynamic>{'muted': instance.muted};
