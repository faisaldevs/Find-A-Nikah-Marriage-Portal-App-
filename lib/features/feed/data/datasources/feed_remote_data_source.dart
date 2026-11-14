import 'package:dio/dio.dart';
import 'package:find_a_nikah/features/feed/data/dtos/feed_dtos.dart';

/// The Feed API. Same base as the other data sources (`api.dio`, `/v1` in
/// the path). Every response is `{statusCode, success, message, data}`;
/// these methods return the unwrapped `data`. Errors stay [DioException]s —
/// `Guard` maps them.
class FeedRemoteDataSource {
  const FeedRemoteDataSource(this._dio);

  final Dio _dio;

  // ── Identity + topics ──────────────────────────────────────────────────
  Future<FeedAuthorDto> fetchMe() async =>
      FeedAuthorDto.fromJson(await _get('/v1/me/feed-author'));

  Future<List<FeedTopicDto>> fetchTopics() async {
    final data = await _data(_dio.get<Object?>('/v1/feed/topics'));
    return [
      for (final t in data! as List<Object?>)
        FeedTopicDto.fromJson(t! as Map<String, dynamic>),
    ];
  }

  // ── Posts ──────────────────────────────────────────────────────────────
  /// [mode] is `forYou` or `new`.
  Future<FeedPageDto<FeedPostDto>> fetchPosts({
    required String mode,
    String? topicId,
    String? cursor,
    int limit = 20,
  }) => _page(
    '/v1/feed/posts',
    FeedPostDto.fromJson,
    query: {
      'mode': mode,
      'topicId': ?topicId,
      'cursor': ?cursor,
      'limit': limit,
    },
  );

  Future<FeedPostDto> fetchPost(String postId) async =>
      FeedPostDto.fromJson(await _get('/v1/feed/posts/$postId'));

  Future<FeedPostDto> createPost({
    required String topicId,
    required String body,
  }) async => FeedPostDto.fromJson(
    await _send('POST', '/v1/feed/posts', {'topicId': topicId, 'body': body}),
  );

  Future<FeedPostDto> editPost(String postId, String body) async =>
      FeedPostDto.fromJson(
        await _send('PATCH', '/v1/feed/posts/$postId', {'body': body}),
      );

  Future<void> deletePost(String postId) =>
      _dio.delete<Object?>('/v1/feed/posts/$postId');

  /// `{liked, likeCount}`.
  Future<Map<String, dynamic>> setPostLiked(
    String postId, {
    required bool liked,
  }) => _send(liked ? 'PUT' : 'DELETE', '/v1/feed/posts/$postId/like');

  Future<void> recordViews(List<String> postIds) =>
      _dio.post<Object?>('/v1/feed/posts/views', data: {'postIds': postIds});

  // ── Comments ───────────────────────────────────────────────────────────
  /// [sort] is `popular` or `recent`.
  Future<FeedPageDto<FeedCommentDto>> fetchComments(
    String postId, {
    required String sort,
    String? cursor,
    int limit = 20,
  }) => _page(
    '/v1/feed/posts/$postId/comments',
    FeedCommentDto.fromJson,
    query: {'sort': sort, 'cursor': ?cursor, 'limit': limit},
  );

  Future<FeedPageDto<FeedCommentDto>> fetchReplies(
    String commentId, {
    String? cursor,
    int limit = 20,
  }) => _page(
    '/v1/feed/comments/$commentId/replies',
    FeedCommentDto.fromJson,
    query: {'cursor': ?cursor, 'limit': limit},
  );

  Future<FeedCommentDto> createComment(
    String postId,
    String body, {
    String? parentId,
    String? mentionUserId,
  }) async => FeedCommentDto.fromJson(
    await _send('POST', '/v1/feed/posts/$postId/comments', {
      'body': body,
      'parentId': ?parentId,
      'mentionUserId': ?mentionUserId,
    }),
  );

  Future<FeedCommentDto> editComment(String commentId, String body) async =>
      FeedCommentDto.fromJson(
        await _send('PATCH', '/v1/feed/comments/$commentId', {'body': body}),
      );

  Future<void> deleteComment(String commentId) =>
      _dio.delete<Object?>('/v1/feed/comments/$commentId');

  Future<Map<String, dynamic>> setCommentLiked(
    String commentId, {
    required bool liked,
  }) => _send(liked ? 'PUT' : 'DELETE', '/v1/feed/comments/$commentId/like');

  // ── Members ────────────────────────────────────────────────────────────
  Future<FeedProfileDto> fetchProfile(String userId) async =>
      FeedProfileDto.fromJson(await _get('/v1/feed/users/$userId'));

  Future<FeedPageDto<FeedPostDto>> fetchProfilePosts(
    String userId, {
    String? cursor,
    int limit = 20,
  }) => _page(
    '/v1/feed/users/$userId/posts',
    FeedPostDto.fromJson,
    query: {'cursor': ?cursor, 'limit': limit},
  );

  Future<FeedPageDto<FeedUserCommentDto>> fetchProfileComments(
    String userId, {
    String? cursor,
    int limit = 20,
  }) => _page(
    '/v1/feed/users/$userId/comments',
    FeedUserCommentDto.fromJson,
    query: {'cursor': ?cursor, 'limit': limit},
  );

  Future<FeedPageDto<FeedPostDto>> fetchProfileLikes(
    String userId, {
    String? cursor,
    int limit = 20,
  }) => _page(
    '/v1/feed/users/$userId/likes',
    FeedPostDto.fromJson,
    query: {'cursor': ?cursor, 'limit': limit},
  );

  /// `{following, followersCount}`.
  Future<Map<String, dynamic>> setFollowing(
    String userId, {
    required bool following,
  }) => _send(following ? 'PUT' : 'DELETE', '/v1/feed/users/$userId/follow');

  /// `{muted}`.
  Future<Map<String, dynamic>> setMuted(
    String userId, {
    required bool muted,
  }) => _send(muted ? 'PUT' : 'DELETE', '/v1/feed/users/$userId/mute');

  Future<void> blockMember(String userId) =>
      _dio.post<Object?>('/v1/blocks/$userId');

  /// `GET /v1/profiles/:userId` — the Marriage profile, with `access`.
  /// Returned raw: the shape is shared with Marriage and only a few fields
  /// are read (see `FeedMarriageMapper`).
  Future<Map<String, dynamic>> fetchMarriageProfile(String userId) =>
      _get('/v1/profiles/$userId');

  // ── Search ─────────────────────────────────────────────────────────────
  Future<FeedPageDto<FeedPostDto>> searchPosts(
    String query, {
    String? cursor,
    int limit = 20,
  }) => _page(
    '/v1/feed/search',
    FeedPostDto.fromJson,
    query: {'q': query, 'type': 'posts', 'cursor': ?cursor, 'limit': limit},
  );

  Future<FeedPageDto<FeedPostDto>> searchMemberPosts(
    String userId,
    String query, {
    String? cursor,
    int limit = 20,
  }) => _page(
    '/v1/feed/users/$userId/search',
    FeedPostDto.fromJson,
    query: {'q': query, 'type': 'posts', 'cursor': ?cursor, 'limit': limit},
  );

  Future<FeedPageDto<FeedUserCommentDto>> searchMemberComments(
    String userId,
    String query, {
    String? cursor,
    int limit = 20,
  }) => _page(
    '/v1/feed/users/$userId/search',
    FeedUserCommentDto.fromJson,
    query: {'q': query, 'type': 'comments', 'cursor': ?cursor, 'limit': limit},
  );

  // ── Safety ─────────────────────────────────────────────────────────────
  Future<void> report(Map<String, dynamic> body) =>
      _dio.post<Object?>('/v1/reports', data: body);

  // ── Plumbing ───────────────────────────────────────────────────────────
  Future<Map<String, dynamic>> _get(String path) async {
    final data = await _data(_dio.get<Object?>(path));
    return data! as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> _send(
    String method,
    String path, [
    Map<String, dynamic>? body,
  ]) async {
    final data = await _data(
      _dio.request<Object?>(
        path,
        data: body,
        options: Options(method: method),
      ),
    );
    return data! as Map<String, dynamic>;
  }

  Future<FeedPageDto<T>> _page<T>(
    String path,
    T Function(Map<String, dynamic>) parse, {
    required Map<String, dynamic> query,
  }) async {
    final raw = await _data(_dio.get<Object?>(path, queryParameters: query));
    final data = raw! as Map<String, dynamic>;
    return FeedPageDto<T>(
      items: [
        for (final i in (data['items'] as List<Object?>? ?? const []))
          parse(i! as Map<String, dynamic>),
      ],
      nextCursor: data['nextCursor'] as String?,
      hasMore: data['hasMore'] as bool? ?? false,
    );
  }

  /// `response.data['data']`.
  Future<Object?> _data(Future<Response<Object?>> call) async {
    final body = (await call).data;
    return body is Map<String, dynamic> ? body['data'] : null;
  }
}
