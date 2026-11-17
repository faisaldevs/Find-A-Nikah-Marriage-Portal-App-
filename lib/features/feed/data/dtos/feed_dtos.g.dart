// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feed_dtos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FeedAuthorDto _$FeedAuthorDtoFromJson(Map<String, dynamic> json) =>
    FeedAuthorDto(
      userId: json['userId'] as String,
      displayName: json['displayName'] as String,
      handle: json['handle'] as String,
      photoUrl: json['photoUrl'] as String?,
      photoThumbUrl: json['photoThumbUrl'] as String?,
      countryCode: json['countryCode'] as String?,
      isVerified: json['isVerified'] as bool? ?? false,
      isMe: json['isMe'] as bool? ?? false,
      isFollowing: json['isFollowing'] as bool? ?? false,
    );

Map<String, dynamic> _$FeedAuthorDtoToJson(FeedAuthorDto instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'displayName': instance.displayName,
      'handle': instance.handle,
      'photoUrl': instance.photoUrl,
      'photoThumbUrl': instance.photoThumbUrl,
      'countryCode': instance.countryCode,
      'isVerified': instance.isVerified,
      'isMe': instance.isMe,
      'isFollowing': instance.isFollowing,
    };

FeedTopicDto _$FeedTopicDtoFromJson(Map<String, dynamic> json) => FeedTopicDto(
  id: json['id'] as String,
  name: json['name'] as String,
  imageUrl: json['imageUrl'] as String?,
  canPost: json['canPost'] as bool? ?? true,
  sortOrder: (json['sortOrder'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$FeedTopicDtoToJson(FeedTopicDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'imageUrl': instance.imageUrl,
      'canPost': instance.canPost,
      'sortOrder': instance.sortOrder,
    };

FeedPostTopicDto _$FeedPostTopicDtoFromJson(Map<String, dynamic> json) =>
    FeedPostTopicDto(name: json['name'] as String, id: json['id'] as String?);

Map<String, dynamic> _$FeedPostTopicDtoToJson(FeedPostTopicDto instance) =>
    <String, dynamic>{'id': instance.id, 'name': instance.name};

FeedMentionDto _$FeedMentionDtoFromJson(Map<String, dynamic> json) =>
    FeedMentionDto(
      userId: json['userId'] as String,
      handle: json['handle'] as String,
    );

Map<String, dynamic> _$FeedMentionDtoToJson(FeedMentionDto instance) =>
    <String, dynamic>{'userId': instance.userId, 'handle': instance.handle};

FeedCommentDto _$FeedCommentDtoFromJson(Map<String, dynamic> json) =>
    FeedCommentDto(
      id: json['id'] as String,
      author: FeedAuthorDto.fromJson(json['author'] as Map<String, dynamic>),
      body: json['body'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      postId: json['postId'] as String?,
      parentId: json['parentId'] as String?,
      mention: json['mention'] == null
          ? null
          : FeedMentionDto.fromJson(json['mention'] as Map<String, dynamic>),
      editedAt: json['editedAt'] == null
          ? null
          : DateTime.parse(json['editedAt'] as String),
      isPostAuthor: json['isPostAuthor'] as bool? ?? false,
      likeCount: (json['likeCount'] as num?)?.toInt() ?? 0,
      replyCount: (json['replyCount'] as num?)?.toInt() ?? 0,
      likedByMe: json['likedByMe'] as bool? ?? false,
      isMine: json['isMine'] as bool? ?? false,
      replies:
          (json['replies'] as List<dynamic>?)
              ?.map((e) => FeedCommentDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <FeedCommentDto>[],
    );

Map<String, dynamic> _$FeedCommentDtoToJson(FeedCommentDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'postId': instance.postId,
      'parentId': instance.parentId,
      'author': instance.author,
      'body': instance.body,
      'mention': instance.mention,
      'createdAt': instance.createdAt.toIso8601String(),
      'editedAt': instance.editedAt?.toIso8601String(),
      'isPostAuthor': instance.isPostAuthor,
      'likeCount': instance.likeCount,
      'replyCount': instance.replyCount,
      'likedByMe': instance.likedByMe,
      'isMine': instance.isMine,
      'replies': instance.replies,
    };

FeedPostDto _$FeedPostDtoFromJson(Map<String, dynamic> json) => FeedPostDto(
  id: json['id'] as String,
  author: FeedAuthorDto.fromJson(json['author'] as Map<String, dynamic>),
  topic: FeedPostTopicDto.fromJson(json['topic'] as Map<String, dynamic>),
  body: json['body'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  editedAt: json['editedAt'] == null
      ? null
      : DateTime.parse(json['editedAt'] as String),
  likeCount: (json['likeCount'] as num?)?.toInt() ?? 0,
  commentCount: (json['commentCount'] as num?)?.toInt() ?? 0,
  viewCount: (json['viewCount'] as num?)?.toInt() ?? 0,
  likedByMe: json['likedByMe'] as bool? ?? false,
  isMine: json['isMine'] as bool? ?? false,
  topComment: json['topComment'] == null
      ? null
      : FeedCommentDto.fromJson(json['topComment'] as Map<String, dynamic>),
);

Map<String, dynamic> _$FeedPostDtoToJson(FeedPostDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'author': instance.author,
      'topic': instance.topic,
      'body': instance.body,
      'createdAt': instance.createdAt.toIso8601String(),
      'editedAt': instance.editedAt?.toIso8601String(),
      'likeCount': instance.likeCount,
      'commentCount': instance.commentCount,
      'viewCount': instance.viewCount,
      'likedByMe': instance.likedByMe,
      'isMine': instance.isMine,
      'topComment': instance.topComment,
    };

FeedProfileDto _$FeedProfileDtoFromJson(Map<String, dynamic> json) =>
    FeedProfileDto(
      userId: json['userId'] as String,
      displayName: json['displayName'] as String,
      handle: json['handle'] as String,
      photoUrl: json['photoUrl'] as String?,
      photoThumbUrl: json['photoThumbUrl'] as String?,
      countryCode: json['countryCode'] as String?,
      isVerified: json['isVerified'] as bool? ?? false,
      isMe: json['isMe'] as bool? ?? false,
      countryName: json['countryName'] as String?,
      joinedAt: json['joinedAt'] == null
          ? null
          : DateTime.parse(json['joinedAt'] as String),
      followersCount: (json['followersCount'] as num?)?.toInt() ?? 0,
      followingCount: (json['followingCount'] as num?)?.toInt() ?? 0,
      postsCount: (json['postsCount'] as num?)?.toInt() ?? 0,
      commentsCount: (json['commentsCount'] as num?)?.toInt() ?? 0,
      likesCount: (json['likesCount'] as num?)?.toInt() ?? 0,
      isFollowing: json['isFollowing'] as bool? ?? false,
      followsMe: json['followsMe'] as bool? ?? false,
      isMuted: json['isMuted'] as bool? ?? false,
      isBlocked: json['isBlocked'] as bool? ?? false,
      complimentSent: json['complimentSent'] as bool? ?? false,
      messageAction: json['messageAction'] as String?,
      conversationId: json['conversationId'] as String?,
      matchId: json['matchId'] as String?,
    );

Map<String, dynamic> _$FeedProfileDtoToJson(FeedProfileDto instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'displayName': instance.displayName,
      'handle': instance.handle,
      'photoUrl': instance.photoUrl,
      'photoThumbUrl': instance.photoThumbUrl,
      'countryCode': instance.countryCode,
      'isVerified': instance.isVerified,
      'isMe': instance.isMe,
      'countryName': instance.countryName,
      'joinedAt': instance.joinedAt?.toIso8601String(),
      'followersCount': instance.followersCount,
      'followingCount': instance.followingCount,
      'postsCount': instance.postsCount,
      'commentsCount': instance.commentsCount,
      'likesCount': instance.likesCount,
      'isFollowing': instance.isFollowing,
      'followsMe': instance.followsMe,
      'isMuted': instance.isMuted,
      'isBlocked': instance.isBlocked,
      'complimentSent': instance.complimentSent,
      'messageAction': instance.messageAction,
      'conversationId': instance.conversationId,
      'matchId': instance.matchId,
    };

FeedCommentPostDto _$FeedCommentPostDtoFromJson(Map<String, dynamic> json) =>
    FeedCommentPostDto(
      id: json['id'] as String,
      authorDisplayName: json['authorDisplayName'] as String? ?? '',
      bodyPreview: json['bodyPreview'] as String? ?? '',
    );

Map<String, dynamic> _$FeedCommentPostDtoToJson(FeedCommentPostDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'authorDisplayName': instance.authorDisplayName,
      'bodyPreview': instance.bodyPreview,
    };

FeedUserCommentDto _$FeedUserCommentDtoFromJson(Map<String, dynamic> json) =>
    FeedUserCommentDto(
      comment: FeedCommentDto.fromJson(json['comment'] as Map<String, dynamic>),
      post: FeedCommentPostDto.fromJson(json['post'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$FeedUserCommentDtoToJson(FeedUserCommentDto instance) =>
    <String, dynamic>{'comment': instance.comment, 'post': instance.post};
