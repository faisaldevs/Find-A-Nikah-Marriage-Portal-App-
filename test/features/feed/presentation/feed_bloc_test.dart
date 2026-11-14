import 'package:bloc_test/bloc_test.dart';
import 'package:find_a_nikah/core/core.dart';
import 'package:find_a_nikah/features/feed/domain/domain.dart';
import 'package:find_a_nikah/features/feed/presentation/bloc/feed_list_state.dart';
import 'package:find_a_nikah/features/feed/presentation/presentation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'feed_test_data.dart';

class _MockFeedRepository extends Mock implements FeedRepository {}

void main() {
  late _MockFeedRepository repo;
  final post = feedPost();

  setUpAll(() => registerFallbackValue(const FeedFilter.forYou()));

  setUp(() {
    repo = _MockFeedRepository();
    when(repo.fetchTopics).thenAnswer((_) async => right(const [feedTopic]));
    when(
      () => repo.fetchPosts(any(), cursor: any(named: 'cursor')),
    ).thenAnswer((_) async => right(FeedPaged(items: [post])));
    when(
      () => repo.recordViews(any()),
    ).thenAnswer((_) async => right(unit));
  });

  FeedBloc build() => FeedBloc(repo);

  group('loading', () {
    blocTest<FeedBloc, FeedState>(
      'loads topics and the "For you" posts',
      build: build,
      act: (b) => b.add(const FeedSubscribed()),
      verify: (b) {
        expect(b.state.topics, [feedTopic]);
        expect(b.state.feed.isReady, isTrue);
        expect(b.state.feed.items, [post]);
      },
    );

    blocTest<FeedBloc, FeedState>(
      'a topics failure still shows the posts',
      build: () {
        when(
          repo.fetchTopics,
        ).thenAnswer((_) async => left(const ServerFailure()));
        return build();
      },
      act: (b) => b.add(const FeedSubscribed()),
      verify: (b) {
        expect(b.state.topics, isEmpty);
        expect(b.state.feed.items, [post]);
      },
    );

    blocTest<FeedBloc, FeedState>(
      'a posts failure shows an error with no items',
      build: () {
        when(
          () => repo.fetchPosts(any(), cursor: any(named: 'cursor')),
        ).thenAnswer((_) async => left(const NetworkFailure()));
        return build();
      },
      act: (b) => b.add(const FeedSubscribed()),
      verify: (b) {
        expect(b.state.feed.hasFailed, isTrue);
        expect(b.state.feed.failure, isA<NetworkFailure>());
      },
    );

    blocTest<FeedBloc, FeedState>(
      'selecting a topic reloads posts for it',
      build: build,
      seed: () => FeedState(
        feed: const FeedListState<FeedPost>().loaded(const FeedPaged()),
      ),
      act: (b) => b.add(const FeedFilterSelected(FeedFilter.topic(feedTopic))),
      verify: (b) {
        expect(b.state.filter, const FeedFilter.topic(feedTopic));
        verify(
          () => repo.fetchPosts(
            const FeedFilter.topic(feedTopic),
            cursor: any(named: 'cursor'),
          ),
        ).called(1);
      },
    );

    blocTest<FeedBloc, FeedState>(
      're-selecting the current filter does nothing',
      build: build,
      seed: () => FeedState(
        feed: const FeedListState<FeedPost>().loaded(const FeedPaged()),
      ),
      act: (b) => b.add(const FeedFilterSelected(FeedFilter.forYou())),
      expect: () => <FeedState>[],
    );
  });

  group('paging', () {
    blocTest<FeedBloc, FeedState>(
      'loads the next page and skips duplicates',
      build: () {
        when(
          () => repo.fetchPosts(any(), cursor: 'c1'),
        ).thenAnswer(
          (_) async => right(
            FeedPaged(
              items: [
                post,
                feedPost(id: 'p2'),
              ],
              nextCursor: 'c2',
            ),
          ),
        );
        return build();
      },
      seed: () => FeedState(
        feed: const FeedListState<FeedPost>().loaded(
          FeedPaged(items: [post], nextCursor: 'c1', hasMore: true),
        ),
      ),
      act: (b) => b.add(const FeedLoadMore()),
      verify: (b) {
        expect(b.state.feed.items.map((p) => p.id), ['p1', 'p2']);
        expect(b.state.feed.hasMore, isFalse);
        expect(b.state.feed.loadingMore, isFalse);
      },
    );

    blocTest<FeedBloc, FeedState>(
      'does not ask again once there is no more',
      build: build,
      seed: () => FeedState(
        feed: const FeedListState<FeedPost>().loaded(
          FeedPaged(items: [post], nextCursor: 'stale'),
        ),
      ),
      act: (b) => b.add(const FeedLoadMore()),
      verify: (_) => verifyNever(
        () => repo.fetchPosts(any(), cursor: any(named: 'cursor')),
      ),
    );

    blocTest<FeedBloc, FeedState>(
      'a failed next page keeps the list and shows a notice',
      build: () {
        when(
          () => repo.fetchPosts(any(), cursor: 'c1'),
        ).thenAnswer((_) async => left(const NetworkFailure()));
        return build();
      },
      seed: () => FeedState(
        feed: const FeedListState<FeedPost>().loaded(
          FeedPaged(items: [post], nextCursor: 'c1', hasMore: true),
        ),
      ),
      act: (b) => b.add(const FeedLoadMore()),
      verify: (b) {
        expect(b.state.feed.items, [post]);
        expect(b.state.feed.loadingMore, isFalse);
        expect(b.state.notice?.isError, isTrue);
      },
    );
  });

  group('likes', () {
    FeedState seeded() => FeedState(
      feed: const FeedListState<FeedPost>().loaded(FeedPaged(items: [post])),
    );

    blocTest<FeedBloc, FeedState>(
      'like flips the heart at once, then takes the server count',
      build: () {
        when(
          () => repo.setPostLiked('p1', liked: true),
        ).thenAnswer(
          (_) async => right(const ToggleResult(active: true, count: 9)),
        );
        return build();
      },
      seed: seeded,
      act: (b) => b.add(const FeedPostLikeToggled('p1')),
      expect: () => [
        isA<FeedState>().having(
          (s) => s.feed.items.single.likeCount,
          'optimistic count',
          4,
        ),
        isA<FeedState>().having(
          (s) => s.feed.items.single.likeCount,
          'server count',
          9,
        ),
      ],
      verify: (b) => expect(b.state.feed.items.single.likedByMe, isTrue),
    );

    blocTest<FeedBloc, FeedState>(
      'a failed like rolls back and tells the member',
      build: () {
        when(
          () => repo.setPostLiked('p1', liked: true),
        ).thenAnswer((_) async => left(const ServerFailure()));
        return build();
      },
      seed: seeded,
      act: (b) => b.add(const FeedPostLikeToggled('p1')),
      verify: (b) {
        final p = b.state.feed.items.single;
        expect(p.likedByMe, isFalse);
        expect(p.likeCount, 3);
        expect(b.state.notice?.isError, isTrue);
      },
    );

    blocTest<FeedBloc, FeedState>(
      'unliking a liked post goes down by one',
      build: () {
        when(
          () => repo.setPostLiked('p1', liked: false),
        ).thenAnswer(
          (_) async => right(const ToggleResult(active: false, count: 2)),
        );
        return build();
      },
      seed: () => FeedState(
        feed: const FeedListState<FeedPost>().loaded(
          FeedPaged(items: [feedPost(liked: true)]),
        ),
      ),
      act: (b) => b.add(const FeedPostLikeToggled('p1')),
      verify: (b) {
        expect(b.state.feed.items.single.likedByMe, isFalse);
        expect(b.state.feed.items.single.likeCount, 2);
      },
    );
  });

  group('local changes', () {
    blocTest<FeedBloc, FeedState>(
      'a new post goes on top of "For you"',
      build: build,
      seed: () => FeedState(
        feed: const FeedListState<FeedPost>().loaded(FeedPaged(items: [post])),
      ),
      act: (b) => b.add(FeedPostAdded(feedPost(id: 'new', mine: true))),
      verify: (b) => expect(b.state.feed.items.first.id, 'new'),
    );

    blocTest<FeedBloc, FeedState>(
      'a new post in another topic is not added to a topic feed',
      build: build,
      seed: () => FeedState(
        filter: const FeedFilter.topic(feedTopic),
        feed: const FeedListState<FeedPost>().loaded(FeedPaged(items: [post])),
      ),
      act: (b) => b.add(
        FeedPostAdded(feedPost(id: 'new', topicId: 'other')),
      ),
      verify: (b) {
        expect(b.state.feed.items, [post]);
        expect(b.state.notice, isNotNull, reason: 'still confirms it posted');
      },
    );

    blocTest<FeedBloc, FeedState>(
      'a changed post replaces the old one in place',
      build: build,
      seed: () => FeedState(
        feed: const FeedListState<FeedPost>().loaded(FeedPaged(items: [post])),
      ),
      act: (b) => b.add(FeedPostChanged(post.copyWith(commentCount: 7))),
      verify: (b) => expect(b.state.feed.items.single.commentCount, 7),
    );

    blocTest<FeedBloc, FeedState>(
      'muting an author removes all their posts',
      build: () {
        when(
          () => repo.setMuted('u2', muted: true),
        ).thenAnswer((_) async => right(unit));
        return build();
      },
      seed: () => FeedState(
        feed: const FeedListState<FeedPost>().loaded(
          FeedPaged(
            items: [
              post,
              feedPost(id: 'p2'),
              feedPost(id: 'p3', author: feedMe),
            ],
          ),
        ),
      ),
      act: (b) => b.add(const FeedAuthorMuteRequested('u2')),
      verify: (b) => expect(b.state.feed.items.map((p) => p.id), ['p3']),
    );

    blocTest<FeedBloc, FeedState>(
      'reporting a post removes it from the list',
      build: () {
        when(() => repo.report(any())).thenAnswer((_) async => right(unit));
        return build();
      },
      seed: () => FeedState(
        feed: const FeedListState<FeedPost>().loaded(FeedPaged(items: [post])),
      ),
      act: (b) => b.add(
        const FeedReportRequested(
          FeedReport(
            target: FeedReportTarget.post,
            reason: FeedReportReason.spam,
            postId: 'p1',
          ),
        ),
      ),
      verify: (b) => expect(b.state.feed.items, isEmpty),
      setUp: () => registerFallbackValue(
        const FeedReport(
          target: FeedReportTarget.post,
          reason: FeedReportReason.spam,
        ),
      ),
    );

    blocTest<FeedBloc, FeedState>(
      'a failed delete keeps the post',
      build: () {
        when(
          () => repo.deletePost('p1'),
        ).thenAnswer((_) async => left(const ForbiddenFailure()));
        return build();
      },
      seed: () => FeedState(
        feed: const FeedListState<FeedPost>().loaded(FeedPaged(items: [post])),
      ),
      act: (b) => b.add(const FeedPostDeleteRequested('p1')),
      verify: (b) {
        expect(b.state.feed.items, [post]);
        expect(b.state.notice?.isError, isTrue);
      },
    );
  });

  group('search', () {
    blocTest<FeedBloc, FeedState>(
      'a query searches the server after a pause',
      build: () {
        when(
          () => repo.searchPosts('tea', cursor: any(named: 'cursor')),
        ).thenAnswer(
          (_) async => right(FeedPaged(items: [feedPost(id: 's1')])),
        );
        return build();
      },
      act: (b) => b.add(const FeedQueryChanged('tea')),
      wait: FeedBloc.searchDelay + const Duration(milliseconds: 100),
      verify: (b) {
        expect(b.state.searching, isTrue);
        expect(b.state.shown.items.single.id, 's1');
      },
    );

    blocTest<FeedBloc, FeedState>(
      'typing on cancels the earlier search',
      build: () {
        when(
          () => repo.searchPosts(any(), cursor: any(named: 'cursor')),
        ).thenAnswer((_) async => right(const FeedPaged()));
        return build();
      },
      act: (b) async {
        b.add(const FeedQueryChanged('te'));
        await Future<void>.delayed(const Duration(milliseconds: 50));
        b.add(const FeedQueryChanged('tea'));
      },
      wait: FeedBloc.searchDelay + const Duration(milliseconds: 150),
      verify: (_) {
        verify(() => repo.searchPosts('tea', cursor: null)).called(1);
        verifyNever(() => repo.searchPosts('te', cursor: any(named: 'cursor')));
      },
    );

    blocTest<FeedBloc, FeedState>(
      'clearing the query goes back to the feed without a request',
      build: build,
      seed: () => FeedState(
        query: 'tea',
        feed: const FeedListState<FeedPost>().loaded(FeedPaged(items: [post])),
      ),
      act: (b) => b.add(const FeedQueryChanged('')),
      verify: (b) {
        expect(b.state.searching, isFalse);
        expect(b.state.shown.items, [post]);
        verifyNever(
          () => repo.searchPosts(any(), cursor: any(named: 'cursor')),
        );
      },
    );
  });

  group('views', () {
    blocTest<FeedBloc, FeedState>(
      'seen posts are sent once, in one batch',
      build: build,
      act: (b) => b
        ..add(const FeedPostSeen('p1'))
        ..add(const FeedPostSeen('p1'))
        ..add(const FeedPostSeen('p2')),
      wait: FeedBloc.viewsDelay + const Duration(milliseconds: 200),
      verify: (_) => verify(() => repo.recordViews(['p1', 'p2'])).called(1),
    );
  });
}
