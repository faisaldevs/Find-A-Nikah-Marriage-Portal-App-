import 'package:find_a_nikah/features/feed/domain/domain.dart';

const feedMe = FeedAuthor(
  userId: 'me',
  name: 'Me T.',
  handle: 'me_1',
  photoUrl: '',
  isMe: true,
);
const feedOther = FeedAuthor(
  userId: 'u2',
  name: 'Khalil K.',
  handle: 'khalil_k2210',
  photoUrl: '',
  countryCode: 'bd',
);
const feedTopic = FeedTopic(id: 't1', name: 'Random');
const feedReadOnlyTopic = FeedTopic(
  id: 't2',
  name: 'Announcements',
  canPost: false,
);

FeedPost feedPost({
  String id = 'p1',
  FeedAuthor author = feedOther,
  bool liked = false,
  int likes = 3,
  int comments = 0,
  bool mine = false,
  String body = 'Hello',
  String topicId = 't1',
}) => FeedPost(
  id: id,
  author: author,
  topic: 'Random',
  topicId: topicId,
  createdAt: DateTime.utc(2026, 11, 14),
  body: body,
  likeCount: likes,
  commentCount: comments,
  likedByMe: liked,
  isMine: mine,
);

FeedComment feedComment({
  String id = 'c1',
  String? parentId,
  FeedAuthor author = feedOther,
  int likes = 0,
  bool liked = false,
  List<FeedComment> replies = const [],
}) => FeedComment(
  id: id,
  postId: 'p1',
  parentId: parentId,
  author: author,
  createdAt: DateTime.utc(2026, 11, 14),
  body: 'Comment $id',
  likeCount: likes,
  likedByMe: liked,
  replyCount: replies.length,
  replies: replies,
);
