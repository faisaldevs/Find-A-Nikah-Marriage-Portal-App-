import 'package:equatable/equatable.dart';
import 'package:find_a_nikah/core/core.dart';
import 'package:find_a_nikah/features/feed/domain/entities/feed_author.dart';
import 'package:find_a_nikah/features/feed/domain/entities/feed_comment.dart';
import 'package:find_a_nikah/features/feed/domain/entities/feed_time.dart';

/// Server limit for a post body.
const feedPostMaxLength = 5000;

/// Server limit for a comment body.
const feedCommentMaxLength = 2000;

/// Edits are accepted for this long after posting (server rule).
const feedEditWindow = Duration(minutes: 15);

/// One community post on the Feed tab.
class FeedPost extends Equatable {
  const FeedPost({
    required this.id,
    required this.author,
    required this.topic,
    required this.createdAt,
    required this.body,
    this.topicId = '',
    this.editedAt,
    this.likeCount = 0,
    this.commentCount = 0,
    this.viewCount = 0,
    this.likedByMe = false,
    this.isMine = false,
    this.topComment,
  });

  final String id;
  final FeedAuthor author;

  /// Name of the topic the post was filed under ("All things marriage").
  final String topic;
  final String topicId;

  final DateTime createdAt;
  final DateTime? editedAt;

  final String body;
  final int likeCount;
  final int commentCount;
  final int viewCount;
  final bool likedByMe;
  final bool isMine;

  /// A comment previewed inside the card (profile "Posts" tab).
  final FeedComment? topComment;

  /// Display-ready relative time ("9h ago", "2 days ago").
  String get postedAgo => feedTimeAgo(createdAt);

  bool get edited => editedAt != null;

  /// Still inside the server's edit window (the server has the last word).
  bool canEditAt(DateTime now) =>
      isMine && now.toUtc().difference(createdAt.toUtc()) < feedEditWindow;

  FeedPost copyWith({
    String? id,
    FeedAuthor? author,
    String? topic,
    String? topicId,
    DateTime? createdAt,
    Object? editedAt = unchanged,
    String? body,
    int? likeCount,
    int? commentCount,
    int? viewCount,
    bool? likedByMe,
    bool? isMine,
    Object? topComment = unchanged,
  }) {
    return FeedPost(
      id: id ?? this.id,
      author: author ?? this.author,
      topic: topic ?? this.topic,
      topicId: topicId ?? this.topicId,
      createdAt: createdAt ?? this.createdAt,
      editedAt: identical(editedAt, unchanged)
          ? this.editedAt
          : editedAt as DateTime?,
      body: body ?? this.body,
      likeCount: likeCount ?? this.likeCount,
      commentCount: commentCount ?? this.commentCount,
      viewCount: viewCount ?? this.viewCount,
      likedByMe: likedByMe ?? this.likedByMe,
      isMine: isMine ?? this.isMine,
      topComment: identical(topComment, unchanged)
          ? this.topComment
          : topComment as FeedComment?,
    );
  }

  @override
  List<Object?> get props => [
    id,
    author,
    topic,
    topicId,
    createdAt,
    editedAt,
    body,
    likeCount,
    commentCount,
    viewCount,
    likedByMe,
    isMine,
    topComment,
  ];
}
