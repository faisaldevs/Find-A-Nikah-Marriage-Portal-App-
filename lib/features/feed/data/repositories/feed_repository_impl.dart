import 'package:find_a_nikah/core/core.dart';
import 'package:find_a_nikah/features/feed/data/datasources/feed_remote_data_source.dart';
import 'package:find_a_nikah/features/feed/data/dtos/feed_marriage_mapper.dart';
import 'package:find_a_nikah/features/feed/data/dtos/feed_mapper.dart';
import 'package:find_a_nikah/features/feed/domain/domain.dart';

/// Feed on the real API. Writes return the server's own state (counts,
/// `editedAt`, …) so the UI never has to guess.
class FeedRepositoryImpl implements FeedRepository {
  FeedRepositoryImpl(this._remote, this._guard, String imageBaseUrl)
    : _map = FeedMapper(imageBaseUrl),
      _marriage = FeedMarriageMapper(imageBaseUrl);

  final FeedRemoteDataSource _remote;
  final Guard _guard;
  final FeedMapper _map;
  final FeedMarriageMapper _marriage;
  final _complimented = <String>{};

  @override
  Future<Either<Failure, FeedAuthor>> fetchMe() =>
      _guard(() async => _map.author(await _remote.fetchMe()));

  @override
  Future<Either<Failure, List<FeedTopic>>> fetchTopics() => _guard(
    () async => [for (final t in await _remote.fetchTopics()) _map.topic(t)],
  );

  @override
  Future<Either<Failure, FeedPaged<FeedPost>>> fetchPosts(
    FeedFilter filter, {
    String? cursor,
  }) => _guard(() async {
    final page = await _remote.fetchPosts(
      mode: switch (filter) {
        FeedNewest() => 'new',
        FeedForYou() || FeedTopicFilter() => 'forYou',
      },
      topicId: switch (filter) {
        FeedTopicFilter(:final topic) => topic.id,
        _ => null,
      },
      cursor: cursor,
    );
    return _map.page(page, _map.post);
  });

  @override
  Future<Either<Failure, FeedPost>> fetchPost(String postId) =>
      _guard(() async => _map.post(await _remote.fetchPost(postId)));

  @override
  Future<Either<Failure, FeedPost>> createPost({
    required FeedTopic topic,
    required String body,
  }) => _guard(
    () async => _map.post(
      await _remote.createPost(topicId: topic.id, body: body),
    ),
  );

  @override
  Future<Either<Failure, FeedPost>> editPost(String postId, String body) =>
      _guard(() async => _map.post(await _remote.editPost(postId, body)));

  @override
  Future<Either<Failure, Unit>> deletePost(String postId) => _guard(() async {
    await _remote.deletePost(postId);
    return unit;
  });

  @override
  Future<Either<Failure, ToggleResult>> setPostLiked(
    String postId, {
    required bool liked,
  }) => _guard(() async {
    final r = await _remote.setPostLiked(postId, liked: liked);
    return ToggleResult(
      active: r['liked'] as bool? ?? liked,
      count: r['likeCount'] as int?,
    );
  });

  @override
  Future<Either<Failure, Unit>> recordViews(List<String> postIds) =>
      _guard(() async {
        if (postIds.isNotEmpty) await _remote.recordViews(postIds);
        return unit;
      });

  @override
  Future<Either<Failure, FeedPaged<FeedComment>>> fetchComments(
    String postId,
    CommentSort sort, {
    String? cursor,
  }) => _guard(() async {
    final page = await _remote.fetchComments(
      postId,
      sort: switch (sort) {
        CommentSort.mostPopular => 'popular',
        CommentSort.mostRecent => 'recent',
      },
      cursor: cursor,
    );
    return _map.page(page, (c) => _map.comment(c, fallbackPostId: postId));
  });

  @override
  Future<Either<Failure, FeedPaged<FeedComment>>> fetchReplies(
    String commentId, {
    String? cursor,
  }) => _guard(() async {
    final page = await _remote.fetchReplies(commentId, cursor: cursor);
    return _map.page(page, _map.comment);
  });

  @override
  Future<Either<Failure, FeedComment>> createComment(
    String postId,
    String body, {
    String? parentId,
    String? mentionUserId,
  }) => _guard(
    () async => _map.comment(
      await _remote.createComment(
        postId,
        body,
        parentId: parentId,
        mentionUserId: mentionUserId,
      ),
      fallbackPostId: postId,
    ),
  );

  @override
  Future<Either<Failure, FeedComment>> editComment(
    String commentId,
    String body,
  ) => _guard(
    () async => _map.comment(await _remote.editComment(commentId, body)),
  );

  @override
  Future<Either<Failure, Unit>> deleteComment(String commentId) =>
      _guard(() async {
        await _remote.deleteComment(commentId);
        return unit;
      });

  @override
  Future<Either<Failure, ToggleResult>> setCommentLiked(
    String commentId, {
    required bool liked,
  }) => _guard(() async {
    final r = await _remote.setCommentLiked(commentId, liked: liked);
    return ToggleResult(
      active: r['liked'] as bool? ?? liked,
      count: r['likeCount'] as int?,
    );
  });

  @override
  Future<Either<Failure, FeedProfile>> fetchProfile(String userId) =>
      _guard(() async => _map.profile(await _remote.fetchProfile(userId)));

  @override
  Future<Either<Failure, FeedPaged<FeedPost>>> fetchProfilePosts(
    String userId, {
    String? cursor,
  }) => _guard(
    () async => _map.page(
      await _remote.fetchProfilePosts(userId, cursor: cursor),
      _map.post,
    ),
  );

  @override
  Future<Either<Failure, FeedPaged<FeedUserComment>>> fetchProfileComments(
    String userId, {
    String? cursor,
  }) => _guard(
    () async => _map.page(
      await _remote.fetchProfileComments(userId, cursor: cursor),
      _map.userComment,
    ),
  );

  @override
  Future<Either<Failure, FeedPaged<FeedPost>>> fetchProfileLikes(
    String userId, {
    String? cursor,
  }) => _guard(
    () async => _map.page(
      await _remote.fetchProfileLikes(userId, cursor: cursor),
      _map.post,
    ),
  );

  @override
  Future<Either<Failure, ToggleResult>> setFollowing(
    String userId, {
    required bool following,
  }) => _guard(() async {
    final r = await _remote.setFollowing(userId, following: following);
    return ToggleResult(
      active: r['following'] as bool? ?? following,
      count: r['followersCount'] as int?,
    );
  });

  @override
  Future<Either<Failure, Unit>> setMuted(
    String userId, {
    required bool muted,
  }) => _guard(() async {
    await _remote.setMuted(userId, muted: muted);
    return unit;
  });

  @override
  Future<Either<Failure, Unit>> sendCompliment(String userId, String text) =>
      _guard(() async {
        await _remote.sendCompliment(userId, text);
        _complimented.add(userId);
        return unit;
      });

  @override
  bool hasSentCompliment(String userId) => _complimented.contains(userId);

  @override
  Future<Either<Failure, Unit>> blockMember(String userId) => _guard(() async {
    await _remote.blockMember(userId);
    return unit;
  });

  @override
  Future<Either<Failure, FeedMarriageProfile>> fetchMarriageProfile(
    String userId,
  ) => _guard(
    () async => _marriage.map(await _remote.fetchMarriageProfile(userId)),
  );

  @override
  Future<Either<Failure, FeedPaged<FeedPost>>> searchPosts(
    String query, {
    String? cursor,
  }) => _guard(
    () async => _map.page(
      await _remote.searchPosts(query, cursor: cursor),
      _map.post,
    ),
  );

  @override
  Future<Either<Failure, FeedPaged<FeedPost>>> searchMemberPosts(
    String userId,
    String query, {
    String? cursor,
  }) => _guard(
    () async => _map.page(
      await _remote.searchMemberPosts(userId, query, cursor: cursor),
      _map.post,
    ),
  );

  @override
  Future<Either<Failure, FeedPaged<FeedUserComment>>> searchMemberComments(
    String userId,
    String query, {
    String? cursor,
  }) => _guard(
    () async => _map.page(
      await _remote.searchMemberComments(userId, query, cursor: cursor),
      _map.userComment,
    ),
  );

  @override
  Future<Either<Failure, Unit>> report(FeedReport report) => _guard(() async {
    await _remote.report({
      'targetType': switch (report.target) {
        FeedReportTarget.post => 'post',
        FeedReportTarget.comment => 'comment',
        FeedReportTarget.feedUser => 'feedUser',
      },
      'postId': ?report.postId,
      'commentId': ?report.commentId,
      'targetUserId': ?report.targetUserId,
      // The live Marriage report endpoint wants this name for members.
      'reportedUserId': ?report.targetUserId,
      'reason': report.reason.code,
      if (report.description?.trim().isNotEmpty ?? false)
        'description': report.description!.trim(),
    });
    return unit;
  });
}
