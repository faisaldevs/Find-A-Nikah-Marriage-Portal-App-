import 'package:bloc_test/bloc_test.dart';
import 'package:find_a_nikah/core/core.dart';
import 'package:find_a_nikah/features/feed/domain/domain.dart';
import 'package:find_a_nikah/features/feed/presentation/presentation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockFeedRepository extends Mock implements FeedRepository {}

const _topic = FeedTopic(id: 'random', name: 'Random');
const _post = FeedPost(
  id: 'p1',
  author: FeedAuthor(
    name: 'A',
    handle: 'a',
    photoUrl: 'https://example.com/a.png',
    countryCode: 'bd',
  ),
  topic: 'Random',
  postedAgo: '9h ago',
  body: 'Hello',
);

void main() {
  late _MockFeedRepository repo;

  setUpAll(() => registerFallbackValue(const FeedFilter.forYou()));

  setUp(() {
    repo = _MockFeedRepository();
    when(repo.fetchTopics).thenAnswer((_) async => right(const [_topic]));
    when(
      () => repo.fetchPosts(any()),
    ).thenAnswer((_) async => right(const [_post]));
  });

  blocTest<FeedBloc, FeedState>(
    'loads topics and the "For you" posts',
    build: () => FeedBloc(repo),
    act: (bloc) => bloc.add(const FeedSubscribed()),
    expect: () => [
      const FeedState(status: FeedStatus.loading),
      const FeedState(
        status: FeedStatus.ready,
        topics: [_topic],
        posts: [_post],
      ),
    ],
  );

  blocTest<FeedBloc, FeedState>(
    'selecting a topic reloads posts for it',
    build: () => FeedBloc(repo),
    seed: () => const FeedState(status: FeedStatus.ready, topics: [_topic]),
    act: (bloc) => bloc.add(const FeedFilterSelected(FeedFilter.topic(_topic))),
    expect: () => [
      const FeedState(
        status: FeedStatus.loading,
        filter: FeedFilter.topic(_topic),
        topics: [_topic],
      ),
      const FeedState(
        status: FeedStatus.ready,
        filter: FeedFilter.topic(_topic),
        topics: [_topic],
        posts: [_post],
      ),
    ],
    verify: (_) =>
        verify(() => repo.fetchPosts(const FeedFilter.topic(_topic))).called(1),
  );

  blocTest<FeedBloc, FeedState>(
    're-selecting the current filter does nothing',
    build: () => FeedBloc(repo),
    seed: () => const FeedState(status: FeedStatus.ready),
    act: (bloc) => bloc.add(const FeedFilterSelected(FeedFilter.forYou())),
    expect: () => <FeedState>[],
  );

  blocTest<FeedBloc, FeedState>(
    'a search query narrows the visible posts, empty shows all',
    build: () => FeedBloc(repo),
    seed: () => const FeedState(status: FeedStatus.ready, posts: [_post]),
    act: (bloc) => bloc
      ..add(const FeedQueryChanged('nothing like this'))
      ..add(const FeedQueryChanged('HELLO')),
    verify: (bloc) {
      expect(bloc.state.visiblePosts, [_post]);
      expect(
        const FeedState(posts: [_post], query: 'zzz').visiblePosts,
        isEmpty,
      );
    },
  );
}
