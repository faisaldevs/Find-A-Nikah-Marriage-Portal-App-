import 'package:find_a_nikah/core/core.dart';
import 'package:find_a_nikah/features/feed/domain/entities/comment_sort.dart';
import 'package:find_a_nikah/features/feed/domain/entities/feed_author.dart';
import 'package:find_a_nikah/features/feed/domain/entities/feed_comment.dart';
import 'package:find_a_nikah/features/feed/domain/entities/feed_filter.dart';
import 'package:find_a_nikah/features/feed/domain/entities/feed_post.dart';
import 'package:find_a_nikah/features/feed/domain/entities/feed_profile.dart';
import 'package:find_a_nikah/features/feed/domain/entities/feed_topic.dart';

/// Community posts. Read policy: network only for now — no feed API or
/// cache exists yet.
abstract interface class FeedRepository {
  /// The signed-in member, as they appear on their own posts.
  Future<Either<Failure, FeedAuthor>> fetchMe();

  /// Topics offered as filter chips (and as groups to post into).
  Future<Either<Failure, List<FeedTopic>>> fetchTopics();

  Future<Either<Failure, List<FeedPost>>> fetchPosts(FeedFilter filter);

  Future<Either<Failure, List<FeedComment>>> fetchComments(
    String postId,
    CommentSort sort,
  );

  Future<Either<Failure, FeedProfile>> fetchProfile(String handle);

  /// [handle]'s posts, each with a preview of its top comment.
  Future<Either<Failure, List<FeedPost>>> fetchProfilePosts(String handle);

  Future<Either<Failure, FeedPost>> createPost({
    required FeedTopic topic,
    required String body,
    required bool anonymous,
  });
}
