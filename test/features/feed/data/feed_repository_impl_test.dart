import 'package:dio/dio.dart';
import 'package:find_a_nikah/core/core.dart';
import 'package:find_a_nikah/core/network/dio_exception_mapper.dart';
import 'package:find_a_nikah/features/feed/data/data.dart';
import 'package:find_a_nikah/features/feed/data/dtos/feed_dtos.dart';
import 'package:find_a_nikah/features/feed/domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/fakes.dart';

class _MockRemote extends Mock implements FeedRemoteDataSource {}

const _authorJson = FeedAuthorDto(
  userId: 'u1',
  displayName: 'Chat T.',
  handle: 'ayat_n4821',
);

FeedPostDto _postDto(String id) => FeedPostDto(
  id: id,
  author: _authorJson,
  topic: const FeedPostTopicDto(id: 't1', name: 'Random'),
  body: 'Hello',
  createdAt: DateTime.utc(2026, 11, 14),
);

void main() {
  late _MockRemote remote;
  late FeedRepositoryImpl repo;

  setUp(() {
    remote = _MockRemote();
    repo = FeedRepositoryImpl(
      remote,
      Guard(RecordingErrorReporter(), translators: [translateDioException]),
      'https://img.example.com',
    );
  });

  group('fetchPosts', () {
    test('"For you" asks for mode forYou and maps the page', () async {
      when(
        () => remote.fetchPosts(
          mode: any(named: 'mode'),
          topicId: any(named: 'topicId'),
          cursor: any(named: 'cursor'),
        ),
      ).thenAnswer(
        (_) async => FeedPageDto(
          items: [_postDto('p1')],
          nextCursor: 'c1',
          hasMore: true,
        ),
      );

      final r = await repo.fetchPosts(const FeedFilter.forYou());

      final page = r.toNullable()!;
      expect(page.items.single.id, 'p1');
      expect(page.next, 'c1');
      verify(
        () => remote.fetchPosts(mode: 'forYou', topicId: null, cursor: null),
      ).called(1);
    });

    test('"New" asks for mode new', () async {
      when(
        () => remote.fetchPosts(
          mode: any(named: 'mode'),
          topicId: any(named: 'topicId'),
          cursor: any(named: 'cursor'),
        ),
      ).thenAnswer((_) async => const FeedPageDto(items: []));

      await repo.fetchPosts(const FeedFilter.newest());

      verify(
        () => remote.fetchPosts(mode: 'new', topicId: null, cursor: null),
      ).called(1);
    });

    test('a topic sends its id and passes the cursor on', () async {
      when(
        () => remote.fetchPosts(
          mode: any(named: 'mode'),
          topicId: any(named: 'topicId'),
          cursor: any(named: 'cursor'),
        ),
      ).thenAnswer((_) async => const FeedPageDto(items: []));

      await repo.fetchPosts(
        const FeedFilter.topic(FeedTopic(id: 't9', name: 'Random')),
        cursor: 'abc',
      );

      verify(
        () => remote.fetchPosts(mode: 'forYou', topicId: 't9', cursor: 'abc'),
      ).called(1);
    });
  });

  group('errors', () {
    DioException status(int code, {Object? data}) => DioException(
      requestOptions: RequestOptions(path: '/x'),
      response: Response<Object?>(
        requestOptions: RequestOptions(path: '/x'),
        statusCode: code,
        data: data,
      ),
      type: DioExceptionType.badResponse,
    );

    test('410 POST_DELETED becomes NotFoundFailure', () async {
      when(() => remote.fetchPost(any())).thenThrow(
        status(
          410,
          data: {'message': 'Post deleted', 'code': 'POST_DELETED'},
        ),
      );

      final r = await repo.fetchPost('p1');

      expect(r.swap().toNullable()!.base, isA<NotFoundFailure>());
    });

    test('403 EDIT_WINDOW_EXPIRED keeps the server message', () async {
      when(() => remote.editPost(any(), any())).thenThrow(
        status(
          403,
          data: {
            'message': 'Posts cannot be edited after 15 minutes',
            'code': 'EDIT_WINDOW_EXPIRED',
          },
        ),
      );

      final r = await repo.editPost('p1', 'new');

      final f = r.swap().toNullable()!;
      expect(f.base, isA<ForbiddenFailure>());
      expect(f, isA<ApiResponseFailure>());
      expect((f as ApiResponseFailure).message, contains('15 minutes'));
    });

    test('429 RATE_LIMITED becomes RateLimitedFailure', () async {
      when(
        () => remote.createPost(
          topicId: any(named: 'topicId'),
          body: any(named: 'body'),
        ),
      ).thenThrow(status(429, data: {'code': 'RATE_LIMITED'}));

      final r = await repo.createPost(
        topic: const FeedTopic(id: 't', name: 'T'),
        body: 'hi',
      );

      expect(r.swap().toNullable()!.base, isA<RateLimitedFailure>());
    });

    test('409 DUPLICATE_REPORT becomes ConflictFailure', () async {
      when(() => remote.report(any())).thenThrow(
        status(409, data: {'code': 'DUPLICATE_REPORT'}),
      );

      final r = await repo.report(
        const FeedReport(
          target: FeedReportTarget.post,
          reason: FeedReportReason.spam,
          postId: 'p1',
        ),
      );

      expect(r.swap().toNullable()!.base, isA<ConflictFailure>());
    });
  });

  group('toggles use the server\'s answer', () {
    test('like returns the server count, not our guess', () async {
      when(
        () => remote.setPostLiked('p1', liked: true),
      ).thenAnswer((_) async => {'liked': true, 'likeCount': 13});

      final r = await repo.setPostLiked('p1', liked: true);

      expect(r.toNullable(), const ToggleResult(active: true, count: 13));
    });

    test('follow returns followersCount', () async {
      when(
        () => remote.setFollowing('u1', following: true),
      ).thenAnswer((_) async => {'following': true, 'followersCount': 2});

      final r = await repo.setFollowing('u1', following: true);

      expect(r.toNullable(), const ToggleResult(active: true, count: 2));
    });
  });

  group('report body', () {
    test('a post report sends the target type, id and reason code', () async {
      when(() => remote.report(any())).thenAnswer((_) async {});

      await repo.report(
        const FeedReport(
          target: FeedReportTarget.post,
          reason: FeedReportReason.inappropriateContent,
          postId: 'p1',
          description: '  not suitable  ',
        ),
      );

      final body =
          verify(() => remote.report(captureAny())).captured.single
              as Map<String, dynamic>;
      expect(body['targetType'], 'post');
      expect(body['postId'], 'p1');
      expect(body['reason'], 'inappropriate_content');
      expect(body['description'], 'not suitable');
      expect(body.containsKey('commentId'), isFalse);
    });

    test('a member report carries both id names the servers use', () async {
      when(() => remote.report(any())).thenAnswer((_) async {});

      await repo.report(
        const FeedReport(
          target: FeedReportTarget.feedUser,
          reason: FeedReportReason.harassment,
          targetUserId: 'u7',
        ),
      );

      final body =
          verify(() => remote.report(captureAny())).captured.single
              as Map<String, dynamic>;
      expect(body['targetType'], 'feedUser');
      expect(body['targetUserId'], 'u7');
      expect(body['reportedUserId'], 'u7');
    });
  });

  test('recordViews skips the call for an empty batch', () async {
    final r = await repo.recordViews(const []);

    expect(r.isRight(), isTrue);
    verifyNever(() => remote.recordViews(any()));
  });

  group('compliment memory', () {
    test('remembers a member after a successful send only', () async {
      when(() => remote.sendCompliment('u2', 'Hi')).thenAnswer((_) async {});
      when(
        () => remote.sendCompliment('u3', 'Hi'),
      ).thenThrow(DioException(requestOptions: RequestOptions()));

      expect(repo.hasSentCompliment('u2'), isFalse);
      await repo.sendCompliment('u2', 'Hi');
      await repo.sendCompliment('u3', 'Hi');

      expect(repo.hasSentCompliment('u2'), isTrue);
      expect(repo.hasSentCompliment('u3'), isFalse);
    });
  });

  group('report reasons per target', () {
    test('a post or comment gets content reasons only', () {
      for (final t in [FeedReportTarget.post, FeedReportTarget.comment]) {
        final r = FeedReportReason.forTarget(t);
        expect(r, contains(FeedReportReason.inappropriateContent));
        expect(r, isNot(contains(FeedReportReason.underage)));
        expect(r, isNot(contains(FeedReportReason.alreadyMarried)));
        expect(r, isNot(contains(FeedReportReason.fakeProfile)));
      }
    });

    test('a member gets person reasons', () {
      final r = FeedReportReason.forTarget(FeedReportTarget.feedUser);
      expect(r, contains(FeedReportReason.fakeProfile));
      expect(r, contains(FeedReportReason.underage));
    });
  });
}
