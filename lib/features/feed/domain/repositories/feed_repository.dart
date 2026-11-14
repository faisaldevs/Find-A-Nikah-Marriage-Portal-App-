import 'package:find_a_nikah/core/core.dart';
import 'package:find_a_nikah/features/feed/domain/entities/comment_sort.dart';
import 'package:find_a_nikah/features/feed/domain/entities/feed_author.dart';
import 'package:find_a_nikah/features/feed/domain/entities/feed_comment.dart';
import 'package:find_a_nikah/features/feed/domain/entities/feed_filter.dart';
import 'package:find_a_nikah/features/feed/domain/entities/feed_marriage_profile.dart';
import 'package:find_a_nikah/features/feed/domain/entities/feed_paged.dart';
import 'package:find_a_nikah/features/feed/domain/entities/feed_post.dart';
import 'package:find_a_nikah/features/feed/domain/entities/feed_profile.dart';
import 'package:find_a_nikah/features/feed/domain/entities/feed_topic.dart';

/// Community posts. Read policy: network only — page 1 is not cached yet.
/// Members are identified by `userId` everywhere; `handle` is a label.
abstract interface class FeedRepository {
  /// The signed-in member, as they appear on their own posts.
  Future<Either<Failure, FeedAuthor>> fetchMe();

  /// Topics offered as filter chips (and as the category to post into).
  Future<Either<Failure, List<FeedTopic>>> fetchTopics();

  // ── Posts ──────────────────────────────────────────────────────────────
  Future<Either<Failure, FeedPaged<FeedPost>>> fetchPosts(
    FeedFilter filter, {
    String? cursor,
  });

  /// One post by id (deep links, refresh after returning from comments).
  Future<Either<Failure, FeedPost>> fetchPost(String postId);

  Future<Either<Failure, FeedPost>> createPost({
    required FeedTopic topic,
    required String body,
  });

  Future<Either<Failure, FeedPost>> editPost(String postId, String body);

  Future<Either<Failure, Unit>> deletePost(String postId);

  /// Idempotent like / unlike; the result holds the server's count.
  Future<Either<Failure, ToggleResult>> setPostLiked(
    String postId, {
    required bool liked,
  });

  /// Batched impressions. Best effort — callers ignore failures.
  Future<Either<Failure, Unit>> recordViews(List<String> postIds);

  // ── Comments ───────────────────────────────────────────────────────────
  Future<Either<Failure, FeedPaged<FeedComment>>> fetchComments(
    String postId,
    CommentSort sort, {
    String? cursor,
  });

  /// The replies beyond the few inlined with a comment.
  Future<Either<Failure, FeedPaged<FeedComment>>> fetchReplies(
    String commentId, {
    String? cursor,
  });

  Future<Either<Failure, FeedComment>> createComment(
    String postId,
    String body, {
    String? parentId,
    String? mentionUserId,
  });

  Future<Either<Failure, FeedComment>> editComment(
    String commentId,
    String body,
  );

  Future<Either<Failure, Unit>> deleteComment(String commentId);

  Future<Either<Failure, ToggleResult>> setCommentLiked(
    String commentId, {
    required bool liked,
  });

  // ── Members ────────────────────────────────────────────────────────────
  Future<Either<Failure, FeedProfile>> fetchProfile(String userId);

  Future<Either<Failure, FeedPaged<FeedPost>>> fetchProfilePosts(
    String userId, {
    String? cursor,
  });

  Future<Either<Failure, FeedPaged<FeedUserComment>>> fetchProfileComments(
    String userId, {
    String? cursor,
  });

  /// Private: only the signed-in member's own likes are returned.
  Future<Either<Failure, FeedPaged<FeedPost>>> fetchProfileLikes(
    String userId, {
    String? cursor,
  });

  Future<Either<Failure, ToggleResult>> setFollowing(
    String userId, {
    required bool following,
  });

  Future<Either<Failure, Unit>> setMuted(
    String userId, {
    required bool muted,
  });

  Future<Either<Failure, Unit>> blockMember(String userId);

  /// "Message" on a profile: sends a compliment (a like + first message), as
  /// on Marriage. If they reply, the chat opens in Messages.
  Future<Either<Failure, Unit>> sendCompliment(String userId, String text);

  /// True once a compliment went to [userId] in this app session — so a
  /// reopened profile doesn't offer a second one. (Until the server says it:
  /// see BE-18 `complimentSent`.)
  bool hasSentCompliment(String userId);

  /// The member's Marriage profile **as seen by the signed-in viewer**; the
  /// server withholds what the viewer may not see (see
  /// [FeedMarriageAccess]). Counts as a profile view.
  Future<Either<Failure, FeedMarriageProfile>> fetchMarriageProfile(
    String userId,
  );

  // ── Search ─────────────────────────────────────────────────────────────
  Future<Either<Failure, FeedPaged<FeedPost>>> searchPosts(
    String query, {
    String? cursor,
  });

  Future<Either<Failure, FeedPaged<FeedPost>>> searchMemberPosts(
    String userId,
    String query, {
    String? cursor,
  });

  Future<Either<Failure, FeedPaged<FeedUserComment>>> searchMemberComments(
    String userId,
    String query, {
    String? cursor,
  });

  // ── Safety ─────────────────────────────────────────────────────────────
  Future<Either<Failure, Unit>> report(FeedReport report);
}

/// What can be reported from Feed.
enum FeedReportTarget { post, comment, feedUser }

/// Reasons the server accepts (its `reason` codes).
enum FeedReportReason {
  fakeProfile('fake_profile', 'Fake profile'),
  harassment('harassment', 'Harassment'),
  inappropriateContent('inappropriate_content', 'Inappropriate content'),
  inappropriatePhoto('inappropriate_photo', 'Inappropriate photo'),
  spam('spam', 'Spam'),
  underage('underage', 'Underage'),
  alreadyMarried('already_married', 'Already married'),
  other('other', 'Something else');

  const FeedReportReason(this.code, this.label);

  final String code;
  final String label;

  /// The reasons that make sense for [target]: a post or comment is about
  /// what was written; a member is about who they are. (The server accepts
  /// any of them for any target — this only keeps the menu sensible.)
  static List<FeedReportReason> forTarget(FeedReportTarget target) =>
      switch (target) {
        FeedReportTarget.post || FeedReportTarget.comment => const [
          inappropriateContent,
          harassment,
          spam,
          other,
        ],
        FeedReportTarget.feedUser => const [
          fakeProfile,
          harassment,
          inappropriatePhoto,
          spam,
          underage,
          alreadyMarried,
          other,
        ],
      };
}

class FeedReport {
  const FeedReport({
    required this.target,
    required this.reason,
    this.postId,
    this.commentId,
    this.targetUserId,
    this.description,
  });

  final FeedReportTarget target;
  final FeedReportReason reason;
  final String? postId;
  final String? commentId;
  final String? targetUserId;
  final String? description;
}
