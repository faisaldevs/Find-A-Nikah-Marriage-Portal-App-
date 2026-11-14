import 'package:find_a_nikah/core/utils/profile_mapping.dart';
import 'package:find_a_nikah/features/feed/data/dtos/feed_dtos.dart';
import 'package:find_a_nikah/features/feed/domain/domain.dart';

/// DTO → entity. [imageBaseUrl] turns server-relative upload paths
/// (`/public/upload/x.jpg`) into absolute URLs.
class FeedMapper {
  const FeedMapper(this.imageBaseUrl);

  final String imageBaseUrl;

  String _url(String? path) =>
      path == null || path.isEmpty ? '' : resolveImageUrl(imageBaseUrl, path);

  FeedAuthor author(FeedAuthorDto d) => FeedAuthor(
    userId: d.userId,
    name: d.displayName,
    handle: d.handle,
    photoUrl: _url(d.photoUrl),
    countryCode: _code(d.countryCode),
    isVerified: d.isVerified,
    isMe: d.isMe,
  );

  FeedTopic topic(FeedTopicDto d) => FeedTopic(
    id: d.id,
    name: d.name,
    imageUrl: d.imageUrl == null || d.imageUrl!.isEmpty
        ? null
        : _url(d.imageUrl),
    canPost: d.canPost,
  );

  FeedComment comment(FeedCommentDto d, {String? fallbackPostId}) =>
      FeedComment(
        id: d.id,
        postId: d.postId ?? fallbackPostId ?? '',
        parentId: d.parentId,
        author: author(d.author),
        createdAt: d.createdAt,
        editedAt: d.editedAt,
        body: d.body,
        mention: d.mention?.handle,
        mentionUserId: d.mention?.userId,
        isPostAuthor: d.isPostAuthor,
        likeCount: d.likeCount,
        replyCount: d.replyCount,
        likedByMe: d.likedByMe,
        isMine: d.isMine,
        replies: [
          for (final r in d.replies) comment(r, fallbackPostId: d.postId),
        ],
      );

  FeedPost post(FeedPostDto d) => FeedPost(
    id: d.id,
    author: author(d.author),
    topic: d.topic.name,
    topicId: d.topic.id,
    createdAt: d.createdAt,
    editedAt: d.editedAt,
    body: d.body,
    likeCount: d.likeCount,
    commentCount: d.commentCount,
    viewCount: d.viewCount,
    likedByMe: d.likedByMe,
    isMine: d.isMine,
    topComment: d.topComment == null
        ? null
        : comment(d.topComment!, fallbackPostId: d.id),
  );

  FeedUserComment userComment(FeedUserCommentDto d) => FeedUserComment(
    comment: comment(d.comment, fallbackPostId: d.post.id),
    postId: d.post.id,
    postAuthorName: d.post.authorDisplayName,
    postPreview: d.post.bodyPreview,
  );

  FeedProfile profile(FeedProfileDto d) => FeedProfile(
    author: author(
      FeedAuthorDto(
        userId: d.userId,
        displayName: d.displayName,
        handle: d.handle,
        photoUrl: d.photoUrl,
        countryCode: d.countryCode,
        isVerified: d.isVerified,
        isMe: d.isMe,
      ),
    ),
    countryName: d.countryName ?? '',
    joinedAt: d.joinedAt,
    followers: d.followersCount,
    following: d.followingCount,
    postsCount: d.postsCount,
    commentsCount: d.commentsCount,
    likesCount: d.likesCount,
    isFollowing: d.isFollowing,
    followsMe: d.followsMe,
  );

  FeedPaged<R> page<T, R>(FeedPageDto<T> p, R Function(T) map) => FeedPaged<R>(
    items: [for (final i in p.items) map(i)],
    nextCursor: p.nextCursor,
    hasMore: p.hasMore,
  );

  /// Lower-case alpha-2, or null for anything else (no flag badge).
  String? _code(String? c) =>
      c == null || c.length != 2 ? null : c.toLowerCase();
}
