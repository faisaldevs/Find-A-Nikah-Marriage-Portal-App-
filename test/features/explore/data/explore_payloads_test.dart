import 'dart:convert';
import 'dart:io';

import 'package:drift/native.dart';
import 'package:find_a_nikah/core/database/database.dart';
import 'package:find_a_nikah/features/explore/data/data.dart';
import 'package:find_a_nikah/features/explore/data/dtos/explore_feed_dto.dart';
import 'package:find_a_nikah/features/explore/domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/fakes.dart';

/// Real `GET /v1/profiles/feed/*` and `/v1/likes/like-list` responses
/// (pasted from the dev backend, 2026-10-27) run through the repository the
/// way the app does it — what the Explore cards are given.
Map<String, dynamic> _fixture(String name) =>
    jsonDecode(File('test/fixtures/explore/$name.json').readAsStringSync())
        as Map<String, dynamic>;

class _Remote implements ExploreRemoteDataSource {
  @override
  Future<ProfileFeedResponseDto> fetchFeed(
    String feed, {
    required int page,
    required int limit,
  }) async => ProfileFeedResponseDto.fromJson(
    _fixture(feed.replaceAll('-', '_')),
  );

  @override
  Future<LikeListResponseDto> fetchLikeList({
    required int page,
    required int limit,
  }) async => LikeListResponseDto.fromJson(_fixture('like_list'));

  @override
  Future<LikeListResponseDto> fetchWhoLikedMe({
    required int page,
    required int limit,
  }) async => LikeListResponseDto.fromJson(_fixture('who_liked_me'));

  @override
  Future<LikeListResponseDto> fetchFavourites({
    required int page,
    required int limit,
  }) async => LikeListResponseDto.fromJson(_fixture('like_list'));

  @override
  Future<LikeListResponseDto> fetchComplimentsSent({
    required int page,
    required int limit,
  }) async => LikeListResponseDto.fromJson(_fixture('like_list'));
}

const ExploreLiveSection _nearYou = ExploreLiveSection.activeNearYou;
const ExploreLiveSection _justJoined = ExploreLiveSection.justJoined;
const ExploreLiveSection _visited = ExploreLiveSection.visitedYou;
const ExploreLiveSection _second = ExploreLiveSection.secondLook;
const ExploreLiveSection _passed = ExploreLiveSection.passed;
const ExploreLiveSection _likes = ExploreLiveSection.likesInFilters;
const ExploreLiveSection _liked = ExploreLiveSection.liked;

void main() {
  late AppDatabase db;
  late ExploreRepositoryImpl repo;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    repo = ExploreRepositoryImpl(
      const DummyExploreDataSource(),
      _Remote(),
      JsonCache(db),
      testGuard(),
      'https://img.test',
    );
  });
  tearDown(() => db.close());

  Future<ExploreSection> load(ExploreLiveSection s) async =>
      (await repo.fetchSection(s, page: 1)).getOrElse((f) => fail('$f'));

  test(
    'just-joined: 8 profiles in API order, country stands in for city',
    () async {
      final s = await load(_justJoined);
      expect(s.count, 8);
      expect(s.hasMore, isFalse);
      expect(s.locked, isFalse);
      expect(s.profiles.map((p) => p.name), [
        'Ruqayyah Islam',
        'Hafsa Rahim',
        'Amina Yusuf',
        'Nusrat Jahan',
        'Sumaiya Akter',
        'Khadija Siddiqui',
        'Fatima Begum',
        'Ayesha Khan',
      ]);
      expect(s.profiles.map((p) => p.age), [29, 27, 31, 28, 28, 30, 27, 28]);
      expect(s.profiles.every((p) => p.area == 'Bangladesh'), isTrue);
      expect(s.profiles.every((p) => p.countryFlag.isNotEmpty), isTrue);
      expect(s.profiles.every((p) => p.isVerified), isTrue);
      // Last active a week before the snapshot: no "Active today" dot.
      expect(
        s.profiles.map((p) => p.isActiveToday),
        everyElement(isFalse),
      );
      expect(
        s.profiles.first.photoUrl,
        'https://img.test/public/upload/'
        '1792313652844-7631bf14-d9e4-42ac-9179-2cb320181165.jpg',
      );
    },
  );

  test('visited-you: 4 visitors with a viewed-at label, unlocked', () async {
    final s = await load(_visited);
    expect(s.count, 4);
    expect(s.locked, isFalse);
    expect(s.profiles.map((p) => p.name), [
      'Test Seed Sara',
      'Test Seed Laila',
      'Test Seed Amira',
      'Ayesha Khan',
    ]);
    expect(s.profiles.every((p) => p.postedAt != null), isTrue);
    expect(s.profiles.map((p) => p.isVerified), [false, false, false, true]);
  });

  test('passed: the 2 profiles returned, with passed-at labels', () async {
    final s = await load(_passed);
    // The API says totalCount 3 but returns 2 profiles; the header count
    // isn't shown here, the list is what matters.
    expect(s.profiles.map((p) => p.name), ['Zainab Noor', 'Maryam Hossain']);
    expect(s.profiles.every((p) => p.interactedAt != null), isTrue);
    expect(s.profiles.map((p) => p.profession), ['Student', 'Pharmacist']);
  });

  test('second-look: empty section (hidden by the page)', () async {
    final s = await load(_second);
    expect(s.profiles, isEmpty);
    expect(s.count, 0);
  });

  test('like-list (My history → Liked): times shown as interactedAt', () async {
    final s = await load(_liked);
    expect(s.profiles, isNotEmpty);
    expect(s.profiles.every((p) => p.interactedAt != null), isTrue);
  });

  test('who-liked-me: 2 people, wrapped likes give like times', () async {
    final s = await load(_likes);
    expect(s.count, 2);
    expect(s.locked, isFalse);
    expect(s.hasMore, isFalse);
    expect(s.profiles.map((p) => p.name), [
      'Test Seed Amira',
      'Test Seed Laila',
    ]);
    expect(s.profiles.every((p) => p.postedAt != null), isTrue);
  });

  test('like-list: flat profiles + pagination count + like times', () async {
    final s = await load(_likes);
    expect(s.count, 2);
    expect(s.locked, isFalse);
    expect(s.hasMore, isFalse);
    expect(s.profiles.map((p) => p.name), [
      'Test Seed Amira',
      'Test Seed Laila',
    ]);
    // likedAt comes from the wrapped `likes` entries.
    expect(s.profiles.every((p) => p.postedAt != null), isTrue);
  });

  test('near-you: distance and city now filled', () async {
    final s = await load(_nearYou);
    expect(s.count, 2);
    expect(s.profiles.map((p) => p.name), ['Ayesha Siddiqua', 'Fatima Zohra']);
    expect(s.profiles.map((p) => p.area), ['Dhaka', 'Dhaka']);
    expect(s.profiles.map((p) => p.distanceKm), [0, 3.6]);
    expect(s.profiles.map((p) => p.isVerified), [true, false]);
  });

  test('every payload survives the cache round trip unchanged', () async {
    for (final section in ExploreLiveSection.values) {
      final fresh = await load(section);
      final cached = await repo.cachedSection(section);
      expect(cached, isNotNull, reason: '$section');
      expect(
        cached!.profiles.map((p) => (p.id, p.name, p.age, p.area, p.postedAt)),
        fresh.profiles.map((p) => (p.id, p.name, p.age, p.area, p.postedAt)),
        reason: '$section',
      );
      expect(cached.count, fresh.count, reason: '$section');
    }
  });
}
