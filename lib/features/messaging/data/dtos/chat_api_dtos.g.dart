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
      lastMessageAt: json['lastMessageAt'] == null
          ? null
          : DateTime.parse(json['lastMessageAt'] as String),
      lastMessagePreview: json['lastMessagePreview'] as String?,
      lastMessageSender: json['lastMessageSender'] as String?,
      unreadCount: (json['unreadCount'] as num?)?.toInt() ?? 0,
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
  text: json['text'] as String? ?? '',
  messageType: json['messageType'] as String? ?? 'text',
  isRead: json['isRead'] as bool? ?? false,
);

Map<String, dynamic> _$SendMessageBodyDtoToJson(SendMessageBodyDto instance) =>
    <String, dynamic>{'text': instance.text};
