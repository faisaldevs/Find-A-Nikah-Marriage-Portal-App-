import 'package:equatable/equatable.dart';
import 'package:find_a_nikah/core/core.dart';
import 'package:find_a_nikah/features/feed/domain/entities/feed_author.dart';
import 'package:find_a_nikah/features/feed/domain/entities/feed_time.dart';

/// A comment on a post, with its replies one level deep.
class FeedComment extends Equatable {
  const FeedComment({
    required this.id,
    required this.author,
    required this.createdAt,
    required this.body,
    this.postId = '',
    this.parentId,
    this.mention,
    this.mentionUserId,
    this.editedAt,
    this.isPostAuthor = false,
    this.likeCount = 0,
    this.replyCount = 0,
    this.likedByMe = false,
    this.isMine = false,
    this.replies = const <FeedComment>[],
  });

  final String id;
  final String postId;

  /// The top-level comment this replies to; null for a top-level comment.
  final String? parentId;
  final FeedAuthor author;
  final DateTime createdAt;
  final DateTime? editedAt;

  final String body;

  /// Handle (without "@") this comment replies to — shown in pink before
  /// [body].
  final String? mention;
  final String? mentionUserId;

  /// The post's own author — gets the pink "Author" tag.
  final bool isPostAuthor;

  final int likeCount;
  final int replyCount;
  final bool likedByMe;
  final bool isMine;
  final List<FeedComment> replies;

  /// Display-ready relative time ("4h ago").
  String get postedAgo => feedTimeAgo(createdAt);

  bool get edited => editedAt != null;

  FeedComment copyWith({
    String? id,
    String? postId,
    Object? parentId = unchanged,
    FeedAuthor? author,
    DateTime? createdAt,
    Object? editedAt = unchanged,
    String? body,
    Object? mention = unchanged,
    Object? mentionUserId = unchanged,
    bool? isPostAuthor,
    int? likeCount,
    int? replyCount,
    bool? likedByMe,
    bool? isMine,
    List<FeedComment>? replies,
  }) {
    return FeedComment(
      id: id ?? this.id,
      postId: postId ?? this.postId,
      parentId: identical(parentId, unchanged)
          ? this.parentId
          : parentId as String?,
      author: author ?? this.author,
      createdAt: createdAt ?? this.createdAt,
      editedAt: identical(editedAt, unchanged)
          ? this.editedAt
          : editedAt as DateTime?,
      body: body ?? this.body,
      mention: identical(mention, unchanged)
          ? this.mention
          : mention as String?,
      mentionUserId: identical(mentionUserId, unchanged)
          ? this.mentionUserId
          : mentionUserId as String?,
      isPostAuthor: isPostAuthor ?? this.isPostAuthor,
      likeCount: likeCount ?? this.likeCount,
      replyCount: replyCount ?? this.replyCount,
      likedByMe: likedByMe ?? this.likedByMe,
      isMine: isMine ?? this.isMine,
      replies: replies ?? this.replies,
    );
  }

  @override
  List<Object?> get props => [
    id,
    postId,
    parentId,
    author,
    createdAt,
    editedAt,
    body,
    mention,
    mentionUserId,
    isPostAuthor,
    likeCount,
    replyCount,
    likedByMe,
    isMine,
    replies,
  ];
}

/// One row of a member's "Comments" tab: the comment and the post it was
/// left on.
class FeedUserComment extends Equatable {
  const FeedUserComment({
    required this.comment,
    required this.postId,
    required this.postAuthorName,
    required this.postPreview,
  });

  final FeedComment comment;
  final String postId;
  final String postAuthorName;
  final String postPreview;

  @override
  List<Object?> get props => [comment, postId, postAuthorName, postPreview];
}
