import 'package:equatable/equatable.dart';
import 'package:find_a_nikah/core/core.dart';
import 'package:find_a_nikah/features/feed/domain/entities/feed_author.dart';

/// A comment on a post, with its replies one level deep.
class FeedComment extends Equatable {
  const FeedComment({
    required this.id,
    required this.author,
    required this.postedAgo,
    required this.body,
    this.mention,
    this.edited = false,
    this.isPostAuthor = false,
    this.likeCount = 0,
    this.replyCount = 0,
    this.replies = const <FeedComment>[],
  });

  final String id;
  final FeedAuthor author;

  /// Display-ready relative time ("4h ago").
  final String postedAgo;

  final String body;

  /// Handle (without "@") this comment replies to — shown in pink before
  /// [body].
  final String? mention;

  final bool edited;

  /// The post's own author — gets the pink "Author" tag.
  final bool isPostAuthor;

  final int likeCount;
  final int replyCount;
  final List<FeedComment> replies;

  FeedComment copyWith({
    String? id,
    FeedAuthor? author,
    String? postedAgo,
    String? body,
    Object? mention = unchanged,
    bool? edited,
    bool? isPostAuthor,
    int? likeCount,
    int? replyCount,
    List<FeedComment>? replies,
  }) {
    return FeedComment(
      id: id ?? this.id,
      author: author ?? this.author,
      postedAgo: postedAgo ?? this.postedAgo,
      body: body ?? this.body,
      mention: identical(mention, unchanged)
          ? this.mention
          : mention as String?,
      edited: edited ?? this.edited,
      isPostAuthor: isPostAuthor ?? this.isPostAuthor,
      likeCount: likeCount ?? this.likeCount,
      replyCount: replyCount ?? this.replyCount,
      replies: replies ?? this.replies,
    );
  }

  @override
  List<Object?> get props => [
    id,
    author,
    postedAgo,
    body,
    mention,
    edited,
    isPostAuthor,
    likeCount,
    replyCount,
    replies,
  ];
}
