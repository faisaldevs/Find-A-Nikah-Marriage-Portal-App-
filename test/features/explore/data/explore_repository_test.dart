import 'package:dio/dio.dart';
import 'package:drift/native.dart';
import 'package:find_a_nikah/core/core.dart';
import 'package:find_a_nikah/core/database/database.dart';
import 'package:find_a_nikah/features/explore/data/data.dart';
import 'package:find_a_nikah/features/explore/data/dtos/explore_feed_dto.dart';
import 'package:find_a_nikah/features/explore/domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/fakes.dart';

// Trimmed from a real `GET /v1/profiles/feed/near-you` item (2026-10-25).
Map<String, dynamic> _item(String id, {String? city, double? km}) => {
  'userId': id,
  'profileId': 'p$id',
  'fullName': 'Ayesha Khan',
  'isVerified': true,
  'lastActiveAt': '2026-10-18T11:38:07.661Z',
  'gender': 'female',
  'photoUrl': '/public/upload/$id.jpg',
  'images': ['/public/upload/$id.jpg'],
  'age': 28,
  'professionTitle': 'Doctor',
  'faith': ['dhikr'],
  'sect': ['dhikr'],
  'city': city,
  'country': 'Bangladesh',
  'completeness': 80,
  'distanceKm': km,
  'passedAt': '2026-10-25T09:32:48.642Z',
  'viewedAt': '2026-10-25T09:47:47.803Z',
  'viewCount': 1,
};

class _Remote implements ExploreRemoteDataSource {
  final calls = <String>[];
  bool offline = false;

  @override
  Future<ProfileFeedResponseDto> fetchFeed(
    String feed, {
    required int page,
    required int limit,
  }) async {
    calls.add('$feed:$page');
    if (offline) {
      throw DioException.connectionError(
        requestOptions: RequestOptions(path: '/v1/profiles/feed/$feed'),
        reason: 'offline',
      );
    }
    return ProfileFeedResponseDto.fromJson({
      'data': {
        'profiles': [
          _item('$feed-u$page', km: page == 1 ? 3.4 : null),
        ],
        'pagination': {
          'currentPage': page,
          'limit': limit,
          'totalPages': 2,
          'totalCount': 2,
          'hasNext': page < 2,
          'hasPrev': page > 1,
        },
        'radiusKm': 50,
      },
    });
  }

  Map<String, dynamic> likeListData = {
    'likes': <Object>[],
    'totalCount': 2,
    'locked': true,
  };

  @override
  Future<LikeListResponseDto> fetchLikeList({
    required int page,
    required int limit,
  }) async {
    calls.add('like-list:$page');
    return LikeListResponseDto.fromJson({'data': likeListData});
  }

  @override
  Future<LikeListResponseDto> fetchWhoLikedMe({
    required int page,
    required int limit,
  }) async {
    calls.add('who-liked-me:$page');
    return LikeListResponseDto.fromJson({'data': likeListData});
  }
}

const ExploreLiveSection _nearYou = ExploreLiveSection.activeNearYou;
const ExploreLiveSection _justJoined = ExploreLiveSection.justJoined;

const ExploreLiveSection _likes = ExploreLiveSection.likesInFilters;
const ExploreLiveSection _passed = ExploreLiveSection.passed;

void main() {
  late AppDatabase db;
  late _Remote remote;
  late ExploreRepositoryImpl repo;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    remote = _Remote();
    repo = ExploreRepositoryImpl(
      const DummyExploreDataSource(),
      remote,
      JsonCache(db),
      testGuard(),
      'https://img.example.com/',
    );
  });

  tearDown(() => db.close());

  test('no cache on first launch', () async {
    expect(await repo.cachedSection(_nearYou), isNull);
  });

  test(
    'maps a page: absolute photo, paging, country stands in for city',
    () async {
      final section = (await repo.fetchSection(_nearYou, page: 1)).getOrElse(
        (f) => fail('$f'),
      );
      expect(section.page, 1);
      expect(section.hasMore, isTrue);
      expect(section.count, 2);
      final p = section.profiles.single;
      expect(p.id, 'near-you-u1');
      expect(
        p.photoUrl,
        'https://img.example.com/public/upload/near-you-u1.jpg',
      );
      expect(p.area, 'Bangladesh');
      expect(p.countryFlag, isNotEmpty);
      expect(p.distanceKm, 3.4);
      expect(p.profession, 'Doctor');
    },
  );

  test('page 1 is cached after success; later pages are not', () async {
    await repo.fetchSection(_nearYou, page: 1);
    await repo.fetchSection(_nearYou, page: 2);
    final cached = await repo.cachedSection(_nearYou);
    expect(cached?.profiles.map((p) => p.id), ['near-you-u1']);
    expect(cached?.hasMore, isTrue);
  });

  test('a failed fetch keeps the previous cache', () async {
    await repo.fetchSection(_nearYou, page: 1);
    remote.offline = true;
    final result = await repo.fetchSection(_nearYou, page: 1);
    expect(result.isLeft(), isTrue);
    expect(result.getLeft().toNullable(), isA<NetworkFailure>());
    expect((await repo.cachedSection(_nearYou))?.profiles, hasLength(1));
  });

  test('sign-out wipe empties the cache', () async {
    await repo.fetchSection(_nearYou, page: 1);
    await JsonCache(db).clear();
    expect(await repo.cachedSection(_nearYou), isNull);
  });

  test('each section hits its own feed path', () async {
    await repo.fetchSection(_nearYou, page: 1);
    await repo.fetchSection(_justJoined, page: 2);
    expect(remote.calls, ['near-you:1', 'just-joined:2']);
  });

  test('sections cache separately', () async {
    await repo.fetchSection(_justJoined, page: 1);
    expect(await repo.cachedSection(_nearYou), isNull);
    expect(
      (await repo.cachedSection(_justJoined))?.profiles.single.id,
      'just-joined-u1',
    );
  });

  test('like-list: locked count with no profiles', () async {
    final section = (await repo.fetchSection(
      _likes,
      page: 1,
    )).getOrElse((f) => fail('$f'));
    expect(remote.calls, ['who-liked-me:1']);
    expect(section.locked, isTrue);
    expect(section.count, 2);
    expect(section.profiles, isEmpty);
    expect(section.hasMore, isFalse);
  });

  test('like-list: flat or wrapped items both map; junk skipped', () async {
    remote.likeListData = {
      'likes': [
        _item('flat'),
        {'user': _item('wrapped'), 'likedAt': '2026-10-25T09:00:00Z'},
        {'nothing': 1},
      ],
      'totalCount': 2,
      'locked': false,
    };
    final section = (await repo.fetchSection(
      _likes,
      page: 1,
    )).getOrElse((f) => fail('$f'));
    expect(section.profiles.map((p) => p.id), ['flat', 'wrapped']);
    expect(section.locked, isFalse);
    // Normalised before caching, so it reads back like any feed.
    expect((await repo.cachedSection(_likes))?.profiles, hasLength(2));
  });

  test("passed: passedAt becomes the card's relative time", () async {
    final section = (await repo.fetchSection(
      _passed,
      page: 1,
    )).getOrElse((f) => fail('$f'));
    expect(remote.calls, ['passed:1']);
    expect(section.profiles.single.interactedAt, isNotNull);
  });

  test('visited-you: viewedAt becomes the small card time, unlocked', () async {
    final section = (await repo.fetchSection(
      ExploreLiveSection.visitedYou,
      page: 1,
    )).getOrElse((f) => fail('$f'));
    expect(remote.calls, ['visited-you:1']);
    expect(section.locked, isFalse);
    expect(section.profiles.single.postedAt, isNotNull);
  });
}
