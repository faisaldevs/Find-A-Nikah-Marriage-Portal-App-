import 'package:equatable/equatable.dart';
import 'package:find_a_nikah/core/core.dart';
import 'package:find_a_nikah/features/feed/domain/entities/feed_author.dart';
import 'package:find_a_nikah/features/feed/domain/entities/feed_comment.dart';

/// One community post on the Feed tab.
class FeedPost extends Equatable {
  const FeedPost({
    required this.id,
    required this.author,
    required this.topic,
    required this.postedAgo,
    required this.body,
    this.likeCount = 0,
    this.commentCount = 0,
    this.viewCount = 0,
    this.topComment,
  });

  final String id;
  final FeedAuthor author;

  /// Name of the topic the post was filed under ("All things marriage").
  final String topic;

  /// Display-ready relative time ("9h ago", "2 days ago").
  final String postedAgo;

  final String body;
  final int likeCount;
  final int commentCount;
  final int viewCount;

  /// A comment previewed inside the card (profile "Posts" tab).
  final FeedComment? topComment;

  FeedPost copyWith({
    String? id,
    FeedAuthor? author,
    String? topic,
    String? postedAgo,
    String? body,
    int? likeCount,
    int? commentCount,
    int? viewCount,
    Object? topComment = unchanged,
  }) {
    return FeedPost(
      id: id ?? this.id,
      author: author ?? this.author,
      topic: topic ?? this.topic,
      postedAgo: postedAgo ?? this.postedAgo,
      body: body ?? this.body,
      likeCount: likeCount ?? this.likeCount,
      commentCount: commentCount ?? this.commentCount,
      viewCount: viewCount ?? this.viewCount,
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
    postedAgo,
    body,
    likeCount,
    commentCount,
    viewCount,
    topComment,
  ];
}
