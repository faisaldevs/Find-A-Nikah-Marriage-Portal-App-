import 'package:dio/dio.dart';
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

  @PATCH('/v1/conversations/{id}/read')
  Future<void> markRead(@Path('id') String conversationId);
}
