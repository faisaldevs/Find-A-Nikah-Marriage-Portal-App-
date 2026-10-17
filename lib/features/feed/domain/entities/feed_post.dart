import 'package:find_a_nikah/features/feed/domain/entities/feed_author.dart';
import 'package:find_a_nikah/features/feed/domain/entities/feed_comment.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'feed_post.freezed.dart';

/// One community post on the Feed tab.
@freezed
abstract class FeedPost with _$FeedPost {
  const factory FeedPost({
    required String id,
    required FeedAuthor author,

    /// Name of the topic the post was filed under ("All things marriage").
    required String topic,

    /// Display-ready relative time ("9h ago", "2 days ago").
    required String postedAgo,
    required String body,
    @Default(0) int likeCount,
    @Default(0) int commentCount,
    @Default(0) int viewCount,

    /// A comment previewed inside the card (profile "Posts" tab).
    FeedComment? topComment,
  }) = _FeedPost;
}
