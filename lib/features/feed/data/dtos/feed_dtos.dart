import 'package:json_annotation/json_annotation.dart';

part 'feed_dtos.g.dart';

/// Wire formats of the Feed API (`/v1/feed/...`), exactly as the server
/// sends them. Every response is `{statusCode, success, message, data}`;
/// the data source unwraps `data`.

@JsonSerializable()
class FeedAuthorDto {
  const FeedAuthorDto({
    required this.userId,
    required this.displayName,
    required this.handle,
    this.photoUrl,
    this.countryCode,
    this.isVerified = false,
    this.isMe = false,
  });

  factory FeedAuthorDto.fromJson(Map<String, dynamic> json) =>
      _$FeedAuthorDtoFromJson(json);

  final String userId;
  final String displayName;
  final String handle;

  /// Server-relative (`/public/upload/x.jpg`) or absolute; null if none.
  final String? photoUrl;
  final String? countryCode;
  final bool isVerified;
  final bool isMe;

  Map<String, dynamic> toJson() => _$FeedAuthorDtoToJson(this);
}

@JsonSerializable()
class FeedTopicDto {
  const FeedTopicDto({
    required this.id,
    required this.name,
    this.imageUrl,
    this.canPost = true,
    this.sortOrder = 0,
  });

  factory FeedTopicDto.fromJson(Map<String, dynamic> json) =>
      _$FeedTopicDtoFromJson(json);

  final String id;
  final String name;
  final String? imageUrl;
  final bool canPost;
  final int sortOrder;

  Map<String, dynamic> toJson() => _$FeedTopicDtoToJson(this);
}

@JsonSerializable()
class FeedPostTopicDto {
  const FeedPostTopicDto({required this.id, required this.name});

  factory FeedPostTopicDto.fromJson(Map<String, dynamic> json) =>
      _$FeedPostTopicDtoFromJson(json);

  final String id;
  final String name;

  Map<String, dynamic> toJson() => _$FeedPostTopicDtoToJson(this);
}

@JsonSerializable()
class FeedMentionDto {
  const FeedMentionDto({required this.userId, required this.handle});

  factory FeedMentionDto.fromJson(Map<String, dynamic> json) =>
      _$FeedMentionDtoFromJson(json);

  final String userId;
  final String handle;

  Map<String, dynamic> toJson() => _$FeedMentionDtoToJson(this);
}

/// A comment as returned by the comments, replies, create and edit
/// endpoints. The `topComment` preview inside a post is a trimmed version
/// (no `replyCount`, `replies`, …), hence the defaults.
@JsonSerializable()
class FeedCommentDto {
  const FeedCommentDto({
    required this.id,
    required this.author,
    required this.body,
    required this.createdAt,
    this.postId,
    this.parentId,
    this.mention,
    this.editedAt,
    this.isPostAuthor = false,
    this.likeCount = 0,
    this.replyCount = 0,
    this.likedByMe = false,
    this.isMine = false,
    this.replies = const <FeedCommentDto>[],
  });

  factory FeedCommentDto.fromJson(Map<String, dynamic> json) =>
      _$FeedCommentDtoFromJson(json);

  final String id;
  final String? postId;
  final String? parentId;
  final FeedAuthorDto author;
  final String body;
  final FeedMentionDto? mention;
  final DateTime createdAt;
  final DateTime? editedAt;
  final bool isPostAuthor;
  final int likeCount;
  final int replyCount;
  final bool likedByMe;
  final bool isMine;
  final List<FeedCommentDto> replies;

  Map<String, dynamic> toJson() => _$FeedCommentDtoToJson(this);
}

@JsonSerializable()
class FeedPostDto {
  const FeedPostDto({
    required this.id,
    required this.author,
    required this.topic,
    required this.body,
    required this.createdAt,
    this.editedAt,
    this.likeCount = 0,
    this.commentCount = 0,
    this.viewCount = 0,
    this.likedByMe = false,
    this.isMine = false,
    this.topComment,
  });

  factory FeedPostDto.fromJson(Map<String, dynamic> json) =>
      _$FeedPostDtoFromJson(json);

  final String id;
  final FeedAuthorDto author;
  final FeedPostTopicDto topic;
  final String body;
  final DateTime createdAt;
  final DateTime? editedAt;
  final int likeCount;
  final int commentCount;
  final int viewCount;
  final bool likedByMe;
  final bool isMine;
  final FeedCommentDto? topComment;

  Map<String, dynamic> toJson() => _$FeedPostDtoToJson(this);
}

/// `GET /feed/users/:userId` — the author fields plus counters.
@JsonSerializable()
class FeedProfileDto {
  const FeedProfileDto({
    required this.userId,
    required this.displayName,
    required this.handle,
    this.photoUrl,
    this.countryCode,
    this.isVerified = false,
    this.isMe = false,
    this.countryName,
    this.joinedAt,
    this.followersCount = 0,
    this.followingCount = 0,
    this.postsCount = 0,
    this.commentsCount = 0,
    this.likesCount = 0,
    this.isFollowing = false,
    this.followsMe = false,
  });

  factory FeedProfileDto.fromJson(Map<String, dynamic> json) =>
      _$FeedProfileDtoFromJson(json);

  final String userId;
  final String displayName;
  final String handle;
  final String? photoUrl;
  final String? countryCode;
  final bool isVerified;
  final bool isMe;
  final String? countryName;
  final DateTime? joinedAt;
  final int followersCount;
  final int followingCount;
  final int postsCount;
  final int commentsCount;
  final int likesCount;
  final bool isFollowing;
  final bool followsMe;

  Map<String, dynamic> toJson() => _$FeedProfileDtoToJson(this);
}

@JsonSerializable()
class FeedCommentPostDto {
  const FeedCommentPostDto({
    required this.id,
    this.authorDisplayName = '',
    this.bodyPreview = '',
  });

  factory FeedCommentPostDto.fromJson(Map<String, dynamic> json) =>
      _$FeedCommentPostDtoFromJson(json);

  final String id;
  final String authorDisplayName;
  final String bodyPreview;

  Map<String, dynamic> toJson() => _$FeedCommentPostDtoToJson(this);
}

/// One row of a member's Comments tab.
@JsonSerializable()
class FeedUserCommentDto {
  const FeedUserCommentDto({required this.comment, required this.post});

  factory FeedUserCommentDto.fromJson(Map<String, dynamic> json) =>
      _$FeedUserCommentDtoFromJson(json);

  final FeedCommentDto comment;
  final FeedCommentPostDto post;

  Map<String, dynamic> toJson() => _$FeedUserCommentDtoToJson(this);
}

/// `{items, nextCursor, hasMore}` of every paged endpoint.
class FeedPageDto<T> {
  const FeedPageDto({
    required this.items,
    this.nextCursor,
    this.hasMore = false,
  });

  final List<T> items;
  final String? nextCursor;
  final bool hasMore;
}
