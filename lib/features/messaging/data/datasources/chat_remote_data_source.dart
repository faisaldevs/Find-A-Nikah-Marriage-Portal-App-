import 'package:dio/dio.dart';
import 'package:find_a_nikah/features/messaging/data/dtos/blocks_dto.dart';
import 'package:find_a_nikah/features/messaging/data/dtos/chat_api_dtos.dart';
import 'package:retrofit/retrofit.dart';

part 'chat_remote_data_source.g.dart';

/// Conversations + messages REST API. Same base as the other feature data
/// sources: `api.dio`, `/v1` in the path.
@RestApi()
abstract class ChatRemoteDataSource {
  factory ChatRemoteDataSource(Dio dio) = _ChatRemoteDataSource;

  @GET('/v1/conversations')
  Future<ConversationsResponseDto> fetchConversations({
    @Query('page') required int page,
    @Query('limit') required int limit,
    @Query('archived') bool? archived,
  });

  /// 200 existing / 201 new. 403 with no match and no entitlement.
  @POST('/v1/conversations/{userId}')
  Future<OpenConversationResponseDto> openConversation(
    @Path('userId') String userId,
  );

  /// Newest first. [before]: a message id, for the page before it.
  @GET('/v1/conversations/{id}/messages')
  Future<MessagesResponseDto> fetchMessages(
    @Path('id') String conversationId, {
    @Query('limit') required int limit,
    @Query('before') String? before,
  });

  @POST('/v1/conversations/{id}/messages')
  Future<SendMessageResponseDto> sendMessage(
    @Path('id') String conversationId,
    @Body() SendMessageBodyDto body,
  );

  /// Image message: multipart, file field `image`.
  @POST('/v1/conversations/{id}/messages')
  @MultiPart()
  Future<SendMessageResponseDto> sendImage(
    @Path('id') String conversationId,
    @Part(name: 'image') MultipartFile image,
  );

  /// Seen = read; clears the caller's unread count.
  @PATCH('/v1/conversations/{id}/seen')
  Future<void> markRead(@Path('id') String conversationId);

  /// Tells the sender the messages reached this device.
  @PATCH('/v1/conversations/{id}/delivered')
  Future<void> markDelivered(@Path('id') String conversationId);

  /// Per-user: the other side still sees the chat.
  @PATCH('/v1/conversations/{id}/archive')
  Future<void> archive(
    @Path('id') String conversationId,
    @Body() ArchiveBodyDto body,
  );

  /// Per-user mute; unread counts still grow, alerts are suppressed.
  @PATCH('/v1/conversations/{id}/mute')
  Future<void> mute(
    @Path('id') String conversationId,
    @Body() MuteBodyDto body,
  );

  /// Clear chat: every message deleted for the caller only.
  @DELETE('/v1/conversations/{id}/messages')
  Future<void> clearChat(@Path('id') String conversationId);

  @GET('/v1/messages/unread-count')
  Future<UnreadCountResponseDto> unreadCount();

  /// Delete for me: the other side keeps their copy.
  @DELETE('/v1/messages/{id}')
  Future<void> deleteMessage(@Path('id') String messageId);

  @GET('/v1/blocks')
  Future<BlocksResponseDto> fetchBlocks({
    @Query('page') required int page,
    @Query('limit') required int limit,
  });

  @POST('/v1/blocks/{userId}')
  Future<void> block(@Path('userId') String userId);

  @DELETE('/v1/blocks/{userId}')
  Future<void> unblock(@Path('userId') String userId);

  @DELETE('/v1/matches/{matchId}')
  Future<void> unmatch(@Path('matchId') String matchId);

  @POST('/v1/reports')
  Future<void> report(@Body() ReportBodyDto body);
}
