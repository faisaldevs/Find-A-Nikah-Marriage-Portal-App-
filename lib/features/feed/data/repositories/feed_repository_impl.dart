import 'package:find_a_nikah/core/core.dart';
import 'package:find_a_nikah/features/feed/data/datasources/dummy_feed_data_source.dart';
import 'package:find_a_nikah/features/feed/domain/domain.dart';

class FeedRepositoryImpl implements FeedRepository {
  const FeedRepositoryImpl(this._dummy, this._guard);

  // Dev-only for now — no Feed API exists yet.
  final DummyFeedDataSource _dummy;
  final Guard _guard;

  @override
  Future<Either<Failure, FeedAuthor>> fetchMe() => _guard(_dummy.fetchMe);

  @override
  Future<Either<Failure, List<FeedTopic>>> fetchTopics() =>
      _guard(_dummy.fetchTopics);

  @override
  Future<Either<Failure, List<FeedPost>>> fetchPosts(FeedFilter filter) =>
      _guard(() => _dummy.fetchPosts(filter));

  @override
  Future<Either<Failure, List<FeedComment>>> fetchComments(
    String postId,
    CommentSort sort,
  ) => _guard(() => _dummy.fetchComments(postId, sort));

  @override
  Future<Either<Failure, FeedProfile>> fetchProfile(String handle) =>
      _guard(() => _dummy.fetchProfile(handle));

  @override
  Future<Either<Failure, List<FeedPost>>> fetchProfilePosts(String handle) =>
      _guard(() => _dummy.fetchProfilePosts(handle));

  @override
  Future<Either<Failure, FeedPost>> createPost({
    required FeedTopic topic,
    required String body,
    required bool anonymous,
  }) => _guard(
    () => _dummy.createPost(topic: topic, body: body, anonymous: anonymous),
  );
}
