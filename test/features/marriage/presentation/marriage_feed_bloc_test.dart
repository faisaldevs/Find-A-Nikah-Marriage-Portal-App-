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
  String? _lastRewound;
  final blocked = <String>[];
  final reported = <String>[];

  @override
  Future<Either<Failure, Unit>> block(String userId) async {
    final f = failNext;
    failNext = null;
    if (f != null) return left(f);
    blocked.add(userId);
    deck.removeWhere((p) => p.id == userId);
    return right(unit);
  }

  @override
  Future<Either<Failure, Unit>> report(
    String userId, {
    required String reason,
    String? description,
  }) async {
    final f = failNext;
    failNext = null;
    if (f != null) return left(f);
    reported.add('$userId:$reason');
    return right(unit);
  }

  @override
  Future<Either<Failure, MarriageFeedPage>> fetchPage({
    required DiscoveryFilters filters,
    String? cursor,
  }) async => right((items: List.of(deck), nextCursor: null));

  @override
  Future<Either<Failure, SwipeOutcome>> swipe(
    SwipeAction action, {
    String? targetUserId,
    String? text,
  }) async {
    calls.add(
      '${action.name}:${targetUserId ?? '-'}${text == null ? '' : ':$text'}',
    );
    final f = failNext;
    failNext = null;
    if (f != null) return left(f);
    switch (action) {
      case SwipeAction.pass:
        final p = deck.firstWhere((p) => p.id == targetUserId);
        deck.remove(p);
        _passed.add(p);
      case SwipeAction.like || SwipeAction.complement:
        deck.removeWhere((p) => p.id == targetUserId);
      case SwipeAction.undo:
        final back = _passed.removeLast();
        _lastRewound = back.id;
        deck.insert(0, back);
    }
    return right(
      SwipeOutcome(
        isMatch: matchOn.contains(targetUserId),
        matchedName: matchOn.contains(targetUserId)
            ? 'Matched $targetUserId'
            : null,
        matchedPhotoUrl: matchOn.contains(targetUserId)
            ? 'https://x.test/p.jpg'
            : null,
        rewoundUserId: action == SwipeAction.undo ? _lastRewound : null,
      ),
    );
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

  test('compliment: sending then sent on the same profile', () async {
    final feed = _FakeFeed([testProfile('a'), testProfile('b')]);
    final bloc = await started(feed);
    final seen = <ComplimentStatus?>[];
    final sub = bloc.stream.listen(
      (s) => seen.add(s.compliments['a']?.status),
    );
    bloc.add(const MarriageComplimentSubmitted('  Mashallah  '));
    await _settle();
    await _settle();
    expect(feed.calls, ['complement:a:Mashallah']);
    expect(seen.whereType<ComplimentStatus>().toSet(), {
      ComplimentStatus.sending,
      ComplimentStatus.sent,
    });
    expect(bloc.state.compliments['a']!.text, 'Mashallah');
    expect(bloc.state.compliments['a']!.status, ComplimentStatus.sent);
    // Stays on the profile so the strip is visible.
    expect(bloc.state.current!.id, 'a');
    await sub.cancel();
    await bloc.close();
  });

  test('compliment: a failure removes the strip and reports it', () async {
    final feed = _FakeFeed([testProfile('a')])
      ..failNext = const NetworkFailure();
    final bloc = await started(feed);
    final notices = <MarriageFeedNotice?>[];
    final sub = bloc.stream.listen((s) => notices.add(s.notice));
    bloc.add(const MarriageComplimentSubmitted('hello'));
    await _settle();
    await _settle();
    expect(bloc.state.compliments, isEmpty);
    expect(notices, contains(MarriageFeedNotice.actionFailed));
    await sub.cancel();
    await bloc.close();
  });

  test('compliment: blank text is not sent', () async {
    final feed = _FakeFeed([testProfile('a')]);
    final bloc = await started(feed);
    bloc.add(const MarriageComplimentSubmitted('   '));
    await _settle();
    expect(feed.calls, isEmpty);
    await bloc.close();
  });

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

  test('a failed swipe brings the card back and forgets the swipe', () async {
    final feed = _FakeFeed([testProfile('a'), testProfile('b')])
      ..failNext = const NetworkFailure();
    final bloc = await started(feed);
    bloc.add(const MarriageProfilePassed());
    await _settle();
    await _settle();
    expect(bloc.state.current!.id, 'a');
    expect(bloc.state.swiped, isEmpty);
    // Undo has nothing to rewind: no stray server call.
    bloc.add(const MarriagePreviousRequested());
    await _settle();
    expect(feed.calls, ['pass:a']);
    await bloc.close();
  });

  test('a failed swipe on the last card stays on it', () async {
    final feed = _FakeFeed([testProfile('a')])
      ..failNext = const NetworkFailure();
    final bloc = await started(feed);
    bloc.add(const MarriageProfileLiked());
    for (var i = 0; i < 3; i++) {
      await _settle();
    }
    expect(bloc.state.current!.id, 'a');
    expect(bloc.state.swiped, isEmpty);
    await bloc.close();
  });

  test(
    'compliment: only one per profile; ✕/✓ afterwards only move on',
    () async {
      final feed = _FakeFeed([testProfile('a'), testProfile('b')]);
      final bloc = await started(feed);
      bloc.add(const MarriageComplimentSubmitted('hello'));
      await _settle();
      await _settle();
      bloc.add(const MarriageComplimentSubmitted('again'));
      await _settle();
      expect(feed.calls, ['complement:a:hello']);
      expect(bloc.state.isComplimented('a'), isTrue);
      bloc.add(const MarriageProfileLiked());
      await _settle();
      expect(feed.calls, ['complement:a:hello']);
      expect(bloc.state.current!.id, 'b');
      await bloc.close();
    },
  );

  test('compliment: a failed send keeps the text as a draft', () async {
    final feed = _FakeFeed([testProfile('a')])
      ..failNext = const NetworkFailure();
    final bloc = await started(feed);
    bloc.add(const MarriageComplimentSubmitted('hello'));
    await _settle();
    await _settle();
    expect(bloc.state.complimentDrafts['a'], 'hello');
    expect(bloc.state.isComplimented('a'), isFalse);
    // Retrying clears it.
    bloc.add(const MarriageComplimentSubmitted('hello'));
    await _settle();
    await _settle();
    expect(bloc.state.complimentDrafts, isEmpty);
    expect(bloc.state.isComplimented('a'), isTrue);
    await bloc.close();
  });

  test('block removes the profile and shows the next', () async {
    final feed = _FakeFeed([testProfile('a'), testProfile('b')]);
    final bloc = await started(feed);
    final notices = <MarriageFeedNotice?>[];
    final sub = bloc.stream.listen((s) => notices.add(s.notice));
    bloc.add(const MarriageProfileBlocked());
    await _settle();
    await _settle();
    expect(feed.blocked, ['a']);
    expect(bloc.state.current!.id, 'b');
    expect(notices, contains(MarriageFeedNotice.blocked));
    await sub.cancel();
    await bloc.close();
  });

  test('block failing keeps the profile', () async {
    final feed = _FakeFeed([testProfile('a'), testProfile('b')]);
    final bloc = await started(feed);
    feed.failNext = const NetworkFailure();
    bloc.add(const MarriageProfileBlocked());
    await _settle();
    await _settle();
    expect(bloc.state.current!.id, 'a');
    await bloc.close();
  });

  test('report sends the reason and stays on the profile', () async {
    final feed = _FakeFeed([testProfile('a')]);
    final bloc = await started(feed);
    final notices = <MarriageFeedNotice?>[];
    final sub = bloc.stream.listen((s) => notices.add(s.notice));
    bloc.add(const MarriageProfileReported('spam'));
    await _settle();
    await _settle();
    expect(feed.reported, ['a:spam']);
    expect(bloc.state.current!.id, 'a');
    expect(notices, contains(MarriageFeedNotice.reported));
    await sub.cancel();
    await bloc.close();
  });

  test('a match carries who it matched with', () async {
    final feed = _FakeFeed(
      [testProfile('a', name: 'Amina'), testProfile('b')],
      matchOn: {'a'},
    );
    final bloc = await started(feed);
    final seen = <MarriageFeedState>[];
    final sub = bloc.stream.listen(seen.add);
    bloc.add(const MarriageProfileLiked());
    await _settle();
    await _settle();
    final matched = seen.firstWhere(
      (s) => s.notice == MarriageFeedNotice.matched,
    );
    expect(matched.matchedName, 'Matched a');
    expect(matched.matchedPhotoUrl, 'https://x.test/p.jpg');
    await sub.cancel();
    await bloc.close();
  });

  test(
    'a duplicate report (409) is "already reported", not an error',
    () async {
      final feed = _FakeFeed([testProfile('a')]);
      final bloc = await started(feed);
      feed.failNext = const ConflictFailure();
      final seen = <MarriageFeedNotice?>[];
      final sub = bloc.stream.listen((s) => seen.add(s.notice));
      bloc.add(const MarriageProfileReported('spam'));
      await _settle();
      await _settle();
      expect(seen, contains(MarriageFeedNotice.alreadyReported));
      expect(seen, isNot(contains(MarriageFeedNotice.actionFailed)));
      await sub.cancel();
      await bloc.close();
    },
  );

  test('undo goes back to the profile the server says it restored', () async {
    final feed = _FakeFeed([testProfile('a'), testProfile('b')]);
    final bloc = await started(feed);
    bloc.add(const MarriageProfilePassed());
    await _settle();
    bloc.add(const MarriagePreviousRequested());
    await _settle();
    expect(bloc.state.current!.id, 'a');
    expect(bloc.state.swiped, isEmpty);
    await bloc.close();
  });
}
