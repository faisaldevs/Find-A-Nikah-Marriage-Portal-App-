import 'package:dio/dio.dart';
import 'package:find_a_nikah/core/core.dart';
import 'package:find_a_nikah/features/discovery/domain/domain.dart';
import 'package:find_a_nikah/features/marriage/data/data.dart';
import 'package:find_a_nikah/features/marriage/data/dtos/profile_card_dto.dart';
import 'package:find_a_nikah/features/marriage/data/dtos/profile_card_mapper.dart';
import 'package:find_a_nikah/features/marriage/domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/fakes.dart';

// Trimmed from a real `GET /v1/profiles/cards` response (2026-10-18).
final _cardJson = <String, dynamic>{
  'userId': '6ad482a9061cf43752ad7f3f',
  'profileId': '6ad482a8a16f2d56cc2261d8',
  'fullName': 'Maryam Hossain',
  'isVerified': true,
  'lastActiveAt': '2026-10-18T08:26:17.148Z',
  'age': 29,
  'faith': ['fasting', 'friday_prayer'],
  'ethnicity': <String>[],
  'country': 'Bangladesh',
  'location': null,
  'distanceKm': null,
  'aboutMe': 'Assalamu Alaikum!',
  'educationLevel': 'undergraduate',
  'professionTitle': 'Pharmacist',
  'maritalStatus': 'never_married',
  'heightCm': null,
  'images': ['/public/upload/a.jpg', '/public/upload/b.jpg'],
  'primaryPhoto': '/public/upload/b.jpg',
  'allInterests': ['Reading', 'Cooking'],
  'sharedInterests': ['Cooking'],
  'matchScore': 86,
};

// Trimmed from `GET /v1/profiles/{userId}`.
final _detailJson = <String, dynamic>{
  'data': {
    'userId': '6ad482a9061cf43752ad7f3f',
    'profile': {
      'marriageIntentions': {
        'getToknowDuration': '3-4_months',
        'marriageTimeline': '4-12_months',
      },
      'aboutYou': {'haveChildren': false, 'relocateAbroad': true},
      'faceVerification': {'isFaceVerified': true},
      'languages': ['English', 'Bengali'],
      'personalityTraits': ['Cheerful'],
      'religiousPractices': ['actively_practising'],
      'grewUpIn': <String>[],
    },
  },
};

class _Remote implements MarriageCardsRemoteDataSource {
  _Remote({
    this.card,
    this.nextCursor,
    this.hasMore = false,
  });

  final Map<String, dynamic>? card;
  final String? nextCursor;
  final bool hasMore;
  final detailCalls = <String>[];
  final blocked = <String>[];
  Map<String, dynamic>? lastReport;
  Map<String, dynamic>? lastQuery;

  final favourited = <String>[];

  @override
  Future<void> addFavourite(String userId) async => favourited.add(userId);

  @override
  Future<void> block(String userId) async => blocked.add(userId);

  @override
  Future<void> report(Map<String, dynamic> body) async => lastReport = body;

  @override
  Future<ProfileCardsResponseDto> fetchCards(
    Map<String, dynamic> query,
  ) async {
    lastQuery = query;
    return ProfileCardsResponseDto.fromJson({
      'data': {
        'cards': [card ?? _cardJson],
        'hasMore': hasMore,
        'nextCursor': nextCursor,
      },
    });
  }

  @override
  Future<ProfileDetailResponseDto> fetchProfile(String userId) async {
    detailCalls.add(userId);
    return ProfileDetailResponseDto.fromJson(_detailJson);
  }

  Map<String, dynamic>? lastSwipe;

  @override
  Future<SwipeResponseDto> swipe(Map<String, dynamic> body) async {
    lastSwipe = body;
    return SwipeResponseDto.fromJson({
      'data': {
        'action': body['action'],
        'isMatch': body['action'] == 'like',
        if (body['action'] == 'like') ...{
          'matchId': 'm1',
          'conversationId': 'c1',
          'matchedUser': {
            'fullName': 'Amina',
            'photoUrl': '/public/upload/a.jpg',
          },
        },
        if (body['action'] == 'undo') 'rewoundUserId': 'u9',
      },
    });
  }
}

void main() {
  group('card mapper', () {
    final card = ProfileCardDto.fromJson(_cardJson);
    final detail = ProfileDetailResponseDto.fromJson(
      _detailJson,
    ).data.profile;

    test('labels codes, prefixes photos, primary photo first', () {
      final p = card.toEntity(
        imageBaseUrl: 'https://x.test/',
        detail: detail,
        now: DateTime.utc(2026, 10, 18, 12),
      );
      expect(p.id, '6ad482a9061cf43752ad7f3f');
      expect(p.name, 'Maryam Hossain');
      expect(p.photoUrls, [
        'https://x.test/public/upload/b.jpg',
        'https://x.test/public/upload/a.jpg',
      ]);
      expect(p.maritalStatus, 'Never married');
      expect(p.education, 'Undergraduate');
      expect(p.faith, ['Fasting', 'Friday prayer']);
      expect(p.countryFlag, '🇧🇩');
      expect(p.similarities, ['Cooking']);
      expect(p.isActiveToday, isTrue);
      // From the full profile.
      expect(p.practice, 'Actively practising');
      expect(p.chatFor, '3-4 months');
      expect(p.marryWithin, '4-12 months');
      expect(p.children, "Doesn't have children");
      expect(p.futurePlans, ['Open to relocate globally']);
      expect(p.languages, ['English', 'Bengali']);
      expect(p.isPhotoVerified, isTrue);
    });

    test('missing values come out empty, not invented', () {
      final p = card.toEntity(imageBaseUrl: 'https://x.test');
      expect(p.distanceKm, isNull);
      expect(p.heightCm, isNull);
      expect(p.ethnicity, '');
      expect(p.ethnicityFlag, '');
      expect(p.practice, '');
      expect(p.chatFor, '');
      expect(p.involveFamily, '');
      expect(p.futurePlans, isEmpty);
    });
  });

  group('filtersToQuery', () {
    test('defaults to just the deck size', () {
      expect(
        MarriageCardsRepositoryImpl.filtersToQuery(const DiscoveryFilters()),
        {'limit': MarriageCardsRepositoryImpl.deckSize},
      );
    });

    test('sends age range and the country by name', () {
      final f = const DiscoveryFilters().withAgeRange(25, 35).withCountry('PK');
      expect(MarriageCardsRepositoryImpl.filtersToQuery(f), {
        'limit': MarriageCardsRepositoryImpl.deckSize,
        'minAge': 25,
        'maxAge': 35,
        'country': 'Pakistan',
      });
    });
  });

  group('filtersToQuery: location, ethnicity, faith, city', () {
    test('limit to my country: that country by name, no radius', () {
      final f = const DiscoveryFilters().withDistance(
        miles: 5,
        limitToHomeCountry: true,
        homeCountryCode: 'PK',
      );
      final q = MarriageCardsRepositoryImpl.filtersToQuery(f);
      expect(q['country'], 'Pakistan');
      expect(q.containsKey('maxDistanceMiles'), isFalse);
    });

    test('ethnicity by country name, faith tokens and city', () {
      final f = const DiscoveryFilters()
          .withEthnicities(['BD', 'PK'])
          .withFaiths(['dhikr', 'fasting'])
          .withCity('Dhaka');
      final q = MarriageCardsRepositoryImpl.filtersToQuery(f);
      expect(q['ethnicity'], 'Bangladesh,Pakistan');
      expect(q['faith'], 'dhikr,fasting');
      expect(q['city'], 'Dhaka');
    });
  });

  // A card as the updated backend sends it: every section on the card.
  final richCard = <String, dynamic>{
    ..._cardJson,
    'city': 'Dhaka',
    'heightCm': 165,
    'distanceKm': 12.5,
    'marriageIntentions': {
      'getToknowDuration': '3-4_months',
      'marriageTimeline': '4-12_months',
      'involveFamily': 'after_getting_to_know',
    },
    'aboutYou': {'haveChildren': false, 'relocateAbroad': true},
    'religiousPractices': ['actively_practising'],
    'languages': ['English', 'Bengali'],
    'personalityTraits': ['Cheerful'],
    'grewUpIn': ['Bangladesh'],
    'isFaceVerified': true,
    'isAgeVerified': true,
    'isIdVerified': false,
    'isPremium': true,
  };

  test('a rich card maps with no detail call at all', () async {
    final remote = _Remote(card: richCard);
    final repo = MarriageCardsRepositoryImpl(
      remote,
      testGuard(),
      'https://x.test',
    );
    final page = (await repo.fetchPage(
      filters: const DiscoveryFilters(),
    )).getOrElse((f) => throw StateError('$f'));
    final p = page.items.single;
    expect(remote.detailCalls, isEmpty);
    expect(p.area, 'Dhaka');
    expect(p.heightCm, 165);
    expect(p.distanceKm, 12.5);
    expect(p.chatFor, '3-4 months');
    expect(p.involveFamily, 'After getting to know');
    expect(p.children, "Doesn't have children");
    expect(p.futurePlans, ['Open to relocate globally']);
    expect(p.languages, ['English', 'Bengali']);
    expect(p.personality, ['Cheerful']);
    expect(p.practice, 'Actively practising');
    expect(p.isPhotoVerified, isTrue);
    expect(p.isAgeVerified, isTrue);
    expect(p.isIdVerified, isFalse);
    expect(p.isPremium, isTrue);
  });

  test('an old-style card with no answers stays empty, not invented', () async {
    final repo = MarriageCardsRepositoryImpl(_Remote(), testGuard(), 'x');
    final page = (await repo.fetchPage(
      filters: const DiscoveryFilters(),
    )).getOrElse((f) => throw StateError('$f'));
    final p = page.items.single;
    expect(p.children, '');
    expect(p.involveFamily, '');
    expect(p.futurePlans, isEmpty);
    expect(p.isPremium, isFalse);
    expect(p.isPhotoVerified, isFalse);
  });

  test('cursor: sent back, and only returned while hasMore', () async {
    final remote = _Remote(nextCursor: 'abc', hasMore: true);
    final repo = MarriageCardsRepositoryImpl(remote, testGuard(), 'x');
    final first = (await repo.fetchPage(
      filters: const DiscoveryFilters(),
    )).getOrElse((f) => throw StateError('$f'));
    expect(first.nextCursor, 'abc');
    expect(remote.lastQuery!.containsKey('cursor'), isFalse);
    await repo.fetchPage(filters: const DiscoveryFilters(), cursor: 'abc');
    expect(remote.lastQuery!['cursor'], 'abc');

    final last = MarriageCardsRepositoryImpl(
      _Remote(nextCursor: 'stale'),
      testGuard(),
      'x',
    );
    final page = (await last.fetchPage(
      filters: const DiscoveryFilters(),
    )).getOrElse((f) => throw StateError('$f'));
    expect(page.nextCursor, isNull);
  });

  test('distance filter sends maxDistanceMiles (not when "everywhere")', () {
    final f = const DiscoveryFilters().withDistance(
      miles: 40,
      limitToHomeCountry: false,
    );
    expect(
      MarriageCardsRepositoryImpl.filtersToQuery(f)['maxDistanceMiles'],
      40,
    );
    final all = const DiscoveryFilters().withDistance(
      miles: kMaxDistanceMiles,
      limitToHomeCountry: false,
    );
    expect(
      MarriageCardsRepositoryImpl.filtersToQuery(all).containsKey(
        'maxDistanceMiles',
      ),
      isFalse,
    );
  });

  test(
    'swipe: a match carries name, photo (resolved) and conversation',
    () async {
      final repo = MarriageCardsRepositoryImpl(
        _Remote(),
        testGuard(),
        'https://x.test',
      );
      final like = (await repo.swipe(
        SwipeAction.like,
        targetUserId: 'u1',
      )).getOrElse((f) => throw StateError('$f'));
      expect(like.isMatch, isTrue);
      expect(like.matchedName, 'Amina');
      expect(like.matchedPhotoUrl, 'https://x.test/public/upload/a.jpg');
      expect(like.conversationId, 'c1');
      final undo = (await repo.swipe(
        SwipeAction.undo,
      )).getOrElse((f) => throw StateError('$f'));
      expect(undo.rewoundUserId, 'u9');
    },
  );

  test('swipe sends action + target; undo sends no target', () async {
    final remote = _Remote();
    final repo = MarriageCardsRepositoryImpl(remote, testGuard(), 'x');
    final like = await repo.swipe(SwipeAction.like, targetUserId: 'u1');
    expect(remote.lastSwipe, {'action': 'like', 'targetUserId': 'u1'});
    expect(like.getOrElse((_) => const SwipeOutcome()).isMatch, isTrue);
    await repo.swipe(SwipeAction.undo);
    expect(remote.lastSwipe, {'action': 'undo'});
  });

  test('block and report hit the right endpoints', () async {
    final remote = _Remote();
    final repo = MarriageCardsRepositoryImpl(remote, testGuard(), 'x');
    await repo.block('u1');
    expect(remote.blocked, ['u1']);
    await repo.report('u1', reason: 'spam');
    expect(remote.lastReport, {'reportedUserId': 'u1', 'reason': 'spam'});
  });

  test('cards request failing becomes a Failure', () async {
    final repo = MarriageCardsRepositoryImpl(
      _ThrowingRemote(),
      testGuard(),
      'https://x.test',
    );
    final result = await repo.fetchPage(filters: const DiscoveryFilters());
    expect(result.getLeft().toNullable(), isA<Failure>());
  });

  test('favourite posts the member to favorites', () async {
    final remote = _Remote();
    final repo = MarriageCardsRepositoryImpl(remote, testGuard(), 'x');

    final result = await repo.favourite('u9');

    expect(result.isRight(), isTrue);
    expect(remote.favourited, ['u9']);
  });
}

class _ThrowingRemote extends _Remote {
  @override
  Future<ProfileCardsResponseDto> fetchCards(Map<String, dynamic> query) =>
      throw DioException.connectionError(
        requestOptions: RequestOptions(path: '/v1/profiles/cards'),
        reason: 'offline',
      );
}
