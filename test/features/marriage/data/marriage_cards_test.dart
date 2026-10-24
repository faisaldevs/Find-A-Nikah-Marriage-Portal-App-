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
  _Remote({this.failDetails = false});

  final bool failDetails;
  Map<String, dynamic>? lastQuery;

  @override
  Future<ProfileCardsResponseDto> fetchCards(
    Map<String, dynamic> query,
  ) async {
    lastQuery = query;
    return ProfileCardsResponseDto.fromJson({
      'data': {
        'cards': [_cardJson],
        'hasMore': false,
      },
    });
  }

  @override
  Future<ProfileDetailResponseDto> fetchProfile(String userId) async {
    if (failDetails) {
      throw DioException.connectionError(
        requestOptions: RequestOptions(path: '/v1/profiles/$userId'),
        reason: 'offline',
      );
    }
    return ProfileDetailResponseDto.fromJson(_detailJson);
  }

  Map<String, dynamic>? lastSwipe;

  @override
  Future<SwipeResponseDto> swipe(Map<String, dynamic> body) async {
    lastSwipe = body;
    return SwipeResponseDto.fromJson({
      'data': {'action': body['action'], 'isMatch': body['action'] == 'like'},
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
      final f = const DiscoveryFilters()
          .withAgeRange(25, 35)
          .withCountry('PK');
      expect(MarriageCardsRepositoryImpl.filtersToQuery(f), {
        'limit': MarriageCardsRepositoryImpl.deckSize,
        'minAge': 25,
        'maxAge': 35,
        'country': 'Pakistan',
      });
    });
  });

  test('a failed detail call keeps the card', () async {
    final repo = MarriageCardsRepositoryImpl(
      _Remote(failDetails: true),
      testGuard(),
      'https://x.test',
    );
    final page = (await repo.fetchPage(
      filters: const DiscoveryFilters(),
    )).getOrElse((f) => throw StateError('$f'));
    expect(page.items.single.name, 'Maryam Hossain');
    expect(page.items.single.chatFor, '');
    expect(page.nextCursor, isNull);
  });

  test('swipe sends action + target; undo sends no target', () async {
    final remote = _Remote();
    final repo = MarriageCardsRepositoryImpl(remote, testGuard(), 'x');
    final like = await repo.swipe(SwipeAction.like, targetUserId: 'u1');
    expect(remote.lastSwipe, {'action': 'like', 'targetUserId': 'u1'});
    expect(like.getOrElse((_) => (isMatch: false)).isMatch, isTrue);
    await repo.swipe(SwipeAction.undo);
    expect(remote.lastSwipe, {'action': 'undo'});
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
}

class _ThrowingRemote extends _Remote {
  @override
  Future<ProfileCardsResponseDto> fetchCards(Map<String, dynamic> query) =>
      throw DioException.connectionError(
        requestOptions: RequestOptions(path: '/v1/profiles/cards'),
        reason: 'offline',
      );
}
