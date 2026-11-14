import 'package:find_a_nikah/features/feed/data/dtos/feed_dtos.dart';
import 'package:find_a_nikah/features/feed/data/dtos/feed_mapper.dart';
import 'package:find_a_nikah/features/feed/domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';

// Shapes copied from real responses of the dev server (2026-11-14).
const _author = {
  'userId': '6af44cb2ac7e106dffb19077',
  'displayName': 'Chat T.',
  'handle': 'khalil_k2210',
  'photoUrl': '/public/upload/1794395516426-3101.jpg',
  'countryCode': 'bd',
  'isVerified': false,
  'isMe': false,
};

void main() {
  const mapper = FeedMapper('https://img.example.com');

  test('a post with a trimmed top comment maps fully', () {
    final dto = FeedPostDto.fromJson({
      'id': 'p1',
      'author': _author,
      'topic': {'id': 't1', 'name': 'Fun & Laughs'},
      'body': 'Tea always wins at 3 AM.',
      'createdAt': '2026-11-14T06:26:21.662Z',
      'editedAt': null,
      'likeCount': 12,
      'commentCount': 5,
      'viewCount': 382,
      'likedByMe': true,
      'isMine': false,
      // The list's trimmed preview: no postId, replyCount, replies…
      'topComment': {
        'id': 'c1',
        'author': {..._author, 'isMe': true},
        'body': 'With cardamom.',
        'likeCount': 4,
        'createdAt': '2026-11-14T06:26:21.812Z',
      },
    });

    final post = mapper.post(dto);

    expect(post.id, 'p1');
    expect(post.topic, 'Fun & Laughs');
    expect(post.topicId, 't1');
    expect(post.createdAt, DateTime.utc(2026, 11, 14, 6, 26, 21, 662));
    expect(post.likedByMe, isTrue);
    expect(post.isMine, isFalse);
    expect(post.edited, isFalse);
    expect(post.author.userId, '6af44cb2ac7e106dffb19077');
    expect(post.author.name, 'Chat T.');
    expect(post.author.countryCode, 'bd');
    expect(
      post.author.photoUrl,
      'https://img.example.com/public/upload/1794395516426-3101.jpg',
      reason: 'server-relative photo paths get the image base',
    );
    final top = post.topComment!;
    expect(top.postId, 'p1', reason: 'taken from the post when not sent');
    expect(top.replyCount, 0);
    expect(top.author.isMe, isTrue);
  });

  test('a comment keeps its replies, mention and flags', () {
    final dto = FeedCommentDto.fromJson({
      'id': 'c1',
      'postId': 'p1',
      'parentId': null,
      'author': _author,
      'body': 'Top level',
      'mention': null,
      'createdAt': '2026-11-14T06:26:21.812Z',
      'editedAt': '2026-11-14T06:30:00.000Z',
      'isPostAuthor': false,
      'likeCount': 4,
      'replyCount': 2,
      'likedByMe': true,
      'isMine': true,
      'replies': [
        {
          'id': 'c2',
          'postId': 'p1',
          'parentId': 'c1',
          'author': _author,
          'body': 'Reply',
          'mention': {'userId': 'u9', 'handle': 'ayat_n4821'},
          'createdAt': '2026-11-14T06:27:00.000Z',
          'editedAt': null,
          'isPostAuthor': true,
          'likeCount': 0,
          'replyCount': 0,
          'likedByMe': false,
          'isMine': false,
          'replies': <Object?>[],
        },
      ],
    });

    final c = mapper.comment(dto);

    expect(c.edited, isTrue);
    expect(c.likedByMe, isTrue);
    expect(c.isMine, isTrue);
    expect(c.replyCount, 2);
    expect(c.replies, hasLength(1));
    expect(c.replies.single.parentId, 'c1');
    expect(c.replies.single.mention, 'ayat_n4821');
    expect(c.replies.single.mentionUserId, 'u9');
    expect(c.replies.single.isPostAuthor, isTrue);
  });

  test('a member with no photo or a bad country code gets safe defaults', () {
    final author = mapper.author(
      FeedAuthorDto.fromJson({
        'userId': 'u',
        'displayName': 'Deleted member',
        'handle': 'gone',
        'photoUrl': null,
        'countryCode': 'bangladesh',
        'isVerified': false,
        'isMe': false,
      }),
    );

    expect(author.photoUrl, isEmpty);
    expect(author.countryCode, isNull, reason: 'not an alpha-2 code');
  });

  test('a profile maps counters and the join date', () {
    final p = mapper.profile(
      FeedProfileDto.fromJson({
        ..._author,
        'countryName': 'Bangladesh',
        'joinedAt': '2026-11-11T11:08:34.862Z',
        'followersCount': 0,
        'followingCount': 3,
        'postsCount': 2,
        'commentsCount': 3,
        'likesCount': 17,
        'isFollowing': true,
        'followsMe': false,
      }),
    );

    expect(p.countryName, 'Bangladesh');
    expect(p.joined, 'Nov 2026');
    expect(p.following, 3);
    expect(p.isFollowing, isTrue);
    expect(p.author.handle, 'khalil_k2210');
  });

  test('a Comments-tab row keeps the post it was left on', () {
    final row = mapper.userComment(
      FeedUserCommentDto.fromJson({
        'comment': {
          'id': 'c9',
          'postId': 'p1',
          'parentId': 'c1',
          'author': _author,
          'body': 'Test reply to comment.',
          'mention': null,
          'createdAt': '2026-11-14T06:28:20.696Z',
          'editedAt': null,
          'isPostAuthor': false,
          'likeCount': 0,
          'replyCount': 0,
          'likedByMe': false,
          'isMine': false,
          'replies': <Object?>[],
        },
        'post': {
          'id': 'p1',
          'authorDisplayName': 'Chat T.',
          'bodyPreview': 'Tea always wins at 3 AM.',
        },
      }),
    );

    expect(row.postId, 'p1');
    expect(row.postAuthorName, 'Chat T.');
    expect(row.comment.body, 'Test reply to comment.');
  });

  test('an author keeps the thumbnail and avatarUrl prefers it', () {
    final a = mapper.author(
      const FeedAuthorDto(
        userId: 'u1',
        displayName: 'Ayat N.',
        handle: 'ayat',
        photoUrl: '/public/upload/a.jpg',
        photoThumbUrl: '/public/upload/a.jpg?w=128',
        isFollowing: true,
      ),
    );

    expect(a.photoThumbUrl, endsWith('/public/upload/a.jpg?w=128'));
    expect(a.avatarUrl, a.photoThumbUrl);
    expect(a.isFollowing, isTrue);
  });

  test('an author with no thumbnail falls back to the photo', () {
    final a = mapper.author(
      const FeedAuthorDto(
        userId: 'u1',
        displayName: 'A',
        handle: 'a',
        photoUrl: '/public/upload/a.jpg',
      ),
    );

    expect(a.avatarUrl, a.photoUrl);
  });

  test('a profile maps mute, block and the Message rule', () {
    FeedProfile map(String? action) => mapper.profile(
      FeedProfileDto(
        userId: 'u2',
        displayName: 'K',
        handle: 'k',
        isMuted: true,
        complimentSent: true,
        messageAction: action,
        conversationId: 'c1',
      ),
    );

    expect(map('chat').messageAction, FeedMessageAction.chat);
    expect(map('chat').conversationId, 'c1');
    expect(map('chat').isMuted, isTrue);
    expect(map('chat').complimentSent, isTrue);
    expect(map('upgrade').messageAction, FeedMessageAction.upgrade);
    expect(map('none').messageAction, FeedMessageAction.none);
    expect(map(null).messageAction, FeedMessageAction.compliment);
    expect(map('something-new').messageAction, FeedMessageAction.compliment);
  });
}
