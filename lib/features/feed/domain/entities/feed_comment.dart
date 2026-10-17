import 'package:find_a_nikah/features/feed/domain/entities/feed_author.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'feed_comment.freezed.dart';

/// A comment on a post, with its replies one level deep.
@freezed
abstract class FeedComment with _$FeedComment {
  const factory FeedComment({
    required String id,
    required FeedAuthor author,

    /// Display-ready relative time ("4h ago").
    required String postedAgo,
    required String body,

    /// Handle (without "@") this comment replies to — shown in pink before
    /// [body].
    String? mention,
    @Default(false) bool edited,

    /// The post's own author — gets the pink "Author" tag.
    @Default(false) bool isPostAuthor,
    @Default(0) int likeCount,
    @Default(0) int replyCount,
    @Default(<FeedComment>[]) List<FeedComment> replies,
  }) = _FeedComment;
}
