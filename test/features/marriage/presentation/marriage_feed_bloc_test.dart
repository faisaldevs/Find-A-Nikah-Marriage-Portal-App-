import 'package:find_a_nikah/core/core.dart';
import 'package:find_a_nikah/features/discovery/data/repositories/in_memory_discovery_filters_repository.dart';
import 'package:find_a_nikah/features/discovery/domain/domain.dart';
import 'package:find_a_nikah/features/marriage/domain/domain.dart';
import 'package:find_a_nikah/features/marriage/presentation/bloc/marriage_feed_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/fakes.dart';

/// Server-like deck: swiped profiles leave it, undo brings back the last
/// pass, likes can't be undone.
class _FakeFeed implements MarriageRepository {
  _FakeFeed(this.deck, {this.matchOn = const {}});

  final List<MarriageProfile> deck;
  final Set<String> matchOn;
  final calls = <String>[];
  final _passed = <MarriageProfile>[];
  Failure? failNext;

  @override
  Future<Either<Failure, MarriageFeedPage>> fetchPage({
    required DiscoveryFilters filters,
    String? cursor,
  }) async => right((items: List.of(deck), nextCursor: null));

  @override
  Future<Either<Failure, SwipeOutcome>> swipe(
    SwipeAction action, {
    String? targetUserId,
  }) async {
    calls.add('${action.name}:${targetUserId ?? '-'}');
    final f = failNext;
    failNext = null;
    if (f != null) return left(f);
    switch (action) {
      case SwipeAction.pass:
        final p = deck.firstWhere((p) => p.id == targetUserId);
        deck.remove(p);
        _passed.add(p);
      case SwipeAction.like:
        deck.removeWhere((p) => p.id == targetUserId);
      case SwipeAction.undo:
        deck.insert(0, _passed.removeLast());
    }
    return right((isMatch: matchOn.contains(targetUserId)));
  }
}

Future<void> _settle() => Future<void>.delayed(Duration.zero);

void main() {
  late InMemoryDiscoveryFiltersRepository filters;

  setUp(() => filters = InMemoryDiscoveryFiltersRepository());
  tearDown(() => filters.dispose());

  Future<MarriageFeedBloc> started(_FakeFeed feed) async {
    final bloc = MarriageFeedBloc(feed, filters)
      ..add(const MarriageFeedSubscribed());
    await _settle();
    await _settle();
    return bloc;
  }

  test('✕ passes the current profile and shows the next', () async {
    final feed = _FakeFeed([testProfile('a'), testProfile('b')]);
    final bloc = await started(feed);
    bloc.add(const MarriageProfilePassed());
    await _settle();
    expect(bloc.state.current!.id, 'b');
    expect(feed.calls, ['pass:a']);
    await bloc.close();
  });

  test('✓ likes; a match raises the matched notice once', () async {
    final feed = _FakeFeed(
      [testProfile('a', name: 'Amina'), testProfile('b')],
      matchOn: {'a'},
    );
    final bloc = await started(feed);
    final notices = <MarriageFeedNotice?>[];
    final sub = bloc.stream.listen((s) => notices.add(s.notice));
    bloc.add(const MarriageProfileLiked());
    await _settle();
    await _settle();
    expect(feed.calls, ['like:a']);
    expect(notices.where((n) => n == MarriageFeedNotice.matched), hasLength(1));
    expect(bloc.state.notice, isNull);
    await sub.cancel();
    await bloc.close();
  });

  test('undo rewinds a pass and goes back', () async {
    final feed = _FakeFeed([testProfile('a'), testProfile('b')]);
    final bloc = await started(feed);
    bloc.add(const MarriageProfilePassed());
    await _settle();
    bloc.add(const MarriagePreviousRequested());
    await _settle();
    expect(feed.calls, ['pass:a', 'undo:-']);
    expect(bloc.state.current!.id, 'a');
    await bloc.close();
  });

  test("undo after a like doesn't call the API", () async {
    final feed = _FakeFeed([testProfile('a'), testProfile('b')]);
    final bloc = await started(feed);
    final notices = <MarriageFeedNotice?>[];
    final sub = bloc.stream.listen((s) => notices.add(s.notice));
    bloc.add(const MarriageProfileLiked());
    await _settle();
    bloc.add(const MarriagePreviousRequested());
    await _settle();
    expect(feed.calls, ['like:a']);
    expect(bloc.state.current!.id, 'b');
    expect(notices, contains(MarriageFeedNotice.undoUnavailable));
    await sub.cancel();
    await bloc.close();
  });

  test('a failed swipe reports actionFailed', () async {
    final feed = _FakeFeed([testProfile('a'), testProfile('b')])
      ..failNext = const NetworkFailure();
    final bloc = await started(feed);
    final failures = <Failure?>[];
    final sub = bloc.stream.listen((s) => failures.add(s.actionFailure));
    bloc.add(const MarriageProfilePassed());
    await _settle();
    await _settle();
    expect(failures.whereType<NetworkFailure>(), hasLength(1));
    await sub.cancel();
    await bloc.close();
  });

  test('swiping the last card reloads what is still unseen', () async {
    final feed = _FakeFeed([testProfile('a')]);
    final bloc = await started(feed);
    bloc.add(const MarriageProfilePassed());
    for (var i = 0; i < 4; i++) {
      await _settle();
    }
    expect(feed.calls, ['pass:a']);
    // The deck is now empty server-side → empty state, not a loop.
    expect(bloc.state.status, MarriageFeedStatus.ready);
    expect(bloc.state.profiles, isEmpty);
    await bloc.close();
  });
}
