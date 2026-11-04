import 'dart:async';

import 'package:find_a_nikah/core/core.dart';
import 'package:find_a_nikah/features/explore/domain/domain.dart';
import 'package:find_a_nikah/features/explore/presentation/bloc/explore_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

ExploreProfile _p(String id) => ExploreProfile(
  id: id,
  name: id,
  age: 25,
  photoUrl: '',
  area: '',
  countryFlag: '',
);

ExploreSection _page(int page, List<String> ids, {bool hasMore = false}) =>
    ExploreSection(
      count: 99,
      profiles: [for (final id in ids) _p(id)],
      page: page,
      hasMore: hasMore,
    );

const ExploreLiveSection _nearYou = ExploreLiveSection.activeNearYou;
const ExploreLiveSection _justJoined = ExploreLiveSection.justJoined;

/// Near-you is driven by [cached] / [pages]; just-joined always has no
/// cache and fails, unless a test fills [justJoinedPages].
class _FakeRepo implements ExploreRepository {
  ExploreSection? cached;
  final pages = <int, Either<Failure, ExploreSection>>{};
  final justJoinedPages = <int, Either<Failure, ExploreSection>>{};

  /// When set, page fetches wait on it — lets a test look at the state
  /// between "cache shown" and "fresh data landed".
  Completer<void>? gate;

  @override
  Future<Either<Failure, ExploreFeed>> fetchFeed() async =>
      right(const ExploreFeed());

  @override
  Future<Either<Failure, ExploreHistoryFeed>> fetchHistory() async =>
      right(const ExploreHistoryFeed());

  @override
  Future<ExploreSection?> cachedSection(ExploreLiveSection section) async =>
      section == _nearYou ? cached : null;

  @override
  Future<Either<Failure, ExploreSection>> fetchSection(
    ExploreLiveSection section, {
    required int page,
  }) async {
    if (section == _justJoined) {
      return justJoinedPages[page] ?? left(const NetworkFailure());
    }
    await gate?.future;
    return pages[page] ?? left(const NetworkFailure());
  }
}

Future<void> _settle() => Future<void>.delayed(Duration.zero);

void main() {
  late _FakeRepo repo;
  late ExploreBloc bloc;

  setUp(() {
    repo = _FakeRepo();
    bloc = ExploreBloc(repo);
  });

  tearDown(() => bloc.close());

  test('first launch: loading (shimmer) then the API page', () async {
    repo
      ..gate = Completer<void>()
      ..pages[1] = right(_page(1, ['a', 'b'], hasMore: true));
    bloc.add(const ExploreSubscribed());
    await _settle();
    expect(bloc.state.liveOf(_nearYou).status, ExploreStatus.loading);
    repo.gate!.complete();
    await _settle();
    expect(bloc.state.liveOf(_nearYou).status, ExploreStatus.ready);
    expect(bloc.state.liveOf(_nearYou).section.profiles.map((p) => p.id), [
      'a',
      'b',
    ]);
  });

  test('cached: ready at once, never loading, then quietly updated', () async {
    repo
      ..cached = _page(1, ['old'])
      ..gate = Completer<void>()
      ..pages[1] = right(_page(1, ['new']));
    final statuses = <ExploreStatus>[];
    final sub = bloc.stream.listen(
      (s) => statuses.add(s.liveOf(_nearYou).status),
    );
    bloc.add(const ExploreSubscribed());
    await _settle();
    expect(bloc.state.liveOf(_nearYou).section.profiles.single.id, 'old');
    repo.gate!.complete();
    await _settle();
    expect(bloc.state.liveOf(_nearYou).section.profiles.single.id, 'new');
    expect(statuses, isNot(contains(ExploreStatus.loading)));
    await sub.cancel();
  });

  test('cached + offline: keeps the cache, no failure', () async {
    repo.cached = _page(1, ['old']);
    bloc.add(const ExploreSubscribed());
    await _settle();
    expect(bloc.state.liveOf(_nearYou).status, ExploreStatus.ready);
    expect(bloc.state.liveOf(_nearYou).section.profiles.single.id, 'old');
  });

  test('no cache + offline: failure (section hidden)', () async {
    bloc.add(const ExploreSubscribed());
    await _settle();
    expect(bloc.state.liveOf(_nearYou).status, ExploreStatus.failure);
  });

  test('load more appends the next page, skipping repeats', () async {
    repo
      ..pages[1] = right(_page(1, ['a', 'b'], hasMore: true))
      ..pages[2] = right(_page(2, ['b', 'c']));
    bloc.add(const ExploreSubscribed());
    await _settle();
    bloc.add(const ExploreLiveMoreRequested(_nearYou));
    await _settle();
    expect(bloc.state.liveOf(_nearYou).section.profiles.map((p) => p.id), [
      'a',
      'b',
      'c',
    ]);
    expect(bloc.state.liveOf(_nearYou).section.page, 2);
    expect(bloc.state.liveOf(_nearYou).section.hasMore, isFalse);
    expect(bloc.state.liveOf(_nearYou).loadingMore, isFalse);
  });

  test('load more is ignored on the last page', () async {
    repo.pages[1] = right(_page(1, ['a']));
    bloc.add(const ExploreSubscribed());
    await _settle();
    bloc.add(const ExploreLiveMoreRequested(_nearYou));
    await _settle();
    expect(bloc.state.liveOf(_nearYou).section.page, 1);
  });

  test('failed load more keeps the list and allows a retry', () async {
    repo.pages[1] = right(_page(1, ['a'], hasMore: true));
    bloc.add(const ExploreSubscribed());
    await _settle();
    bloc.add(const ExploreLiveMoreRequested(_nearYou));
    await _settle();
    expect(bloc.state.liveOf(_nearYou).section.profiles.map((p) => p.id), [
      'a',
    ]);
    expect(bloc.state.liveOf(_nearYou).loadingMore, isFalse);
    repo.pages[2] = right(_page(2, ['b']));
    bloc.add(const ExploreLiveMoreRequested(_nearYou));
    await _settle();
    expect(bloc.state.liveOf(_nearYou).section.profiles.map((p) => p.id), [
      'a',
      'b',
    ]);
  });

  test(
    'sections are independent: near-you waiting, just-joined ready',
    () async {
      repo
        ..gate = Completer<void>()
        ..pages[1] = right(_page(1, ['a']))
        ..justJoinedPages[1] = right(_page(1, ['j1', 'j2'], hasMore: true))
        ..justJoinedPages[2] = right(_page(2, ['j3']));
      bloc.add(const ExploreSubscribed());
      await _settle();
      expect(bloc.state.liveOf(_nearYou).status, ExploreStatus.loading);
      expect(bloc.state.liveOf(_justJoined).status, ExploreStatus.ready);
      bloc.add(const ExploreLiveMoreRequested(_justJoined));
      await _settle();
      expect(
        bloc.state.liveOf(_justJoined).section.profiles.map((p) => p.id),
        ['j1', 'j2', 'j3'],
      );
      expect(bloc.state.liveOf(_nearYou).status, ExploreStatus.loading);
      repo.gate!.complete();
      await _settle();
      expect(bloc.state.liveOf(_nearYou).section.profiles.single.id, 'a');
    },
  );
}
