import 'package:find_a_nikah/core/core.dart';
import 'package:dio/dio.dart';
import 'package:find_a_nikah/features/discovery/domain/domain.dart';
import 'package:find_a_nikah/features/marriage/data/data.dart';
import 'package:find_a_nikah/features/marriage/data/dtos/marriage_profile_dto.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/fakes.dart';

class _FailingRemote implements MarriageRemoteDataSource {
  @override
  Future<MarriageFeedPageDto> fetchProfiles(Map<String, dynamic> query) =>
      throw DioException.connectionError(
        requestOptions: RequestOptions(path: '/discovery/profiles'),
        reason: 'offline',
      );
}

class _RecordingRemote implements MarriageRemoteDataSource {
  Map<String, dynamic>? lastQuery;

  @override
  Future<MarriageFeedPageDto> fetchProfiles(
    Map<String, dynamic> query,
  ) async {
    lastQuery = query;
    return const MarriageFeedPageDto(items: []);
  }
}

void main() {
  group('filtersToQuery', () {
    test('sends only the filters that are set', () {
      expect(
        MarriageRepositoryImpl.filtersToQuery(const DiscoveryFilters()),
        {'limit': MarriageRepositoryImpl.pageSize},
      );
    });

    test('maps age, distance, home country, ethnicity and cursor', () {
      final f = const DiscoveryFilters()
          .withAgeRange(25, 35)
          .withDistance(miles: 42.4, limitToHomeCountry: true)
          .withEthnicities(['BD', 'PK']);
      expect(MarriageRepositoryImpl.filtersToQuery(f, cursor: 'c1'), {
        'limit': MarriageRepositoryImpl.pageSize,
        'cursor': 'c1',
        'minAge': 25,
        'maxAge': 35,
        'maxDistanceMiles': 42,
        'country': kHomeCountryCode,
        'ethnicity': 'BD,PK',
      });
    });

    test('country mode sends the chosen country', () {
      final f = const DiscoveryFilters().withCountry('PK');
      expect(MarriageRepositoryImpl.filtersToQuery(f)['country'], 'PK');
    });
  });

  test('repository passes the query and maps DTOs to entities', () async {
    final remote = _RecordingRemote();
    final repo = MarriageRepositoryImpl(remote, testGuard());
    final result = await repo.fetchPage(
      filters: const DiscoveryFilters().withCountry('BD'),
      cursor: 'abc',
    );
    expect(result.isRight(), isTrue);
    expect(remote.lastQuery!['cursor'], 'abc');
  });

  test('a network error becomes NetworkFailure', () async {
    final repo = MarriageRepositoryImpl(_FailingRemote(), testGuard());
    final result = await repo.fetchPage(filters: const DiscoveryFilters());
    expect(result.getLeft().toNullable(), isA<NetworkFailure>());
  });

  test('dummy data source pages with an opaque cursor', () async {
    const source = DummyMarriageDataSource(latency: Duration.zero);
    final first = await source.fetchProfiles({});
    expect(first.items, hasLength(2));
    expect(first.nextCursor, '2');
    final last = await source.fetchProfiles({'cursor': '4'});
    expect(last.items, hasLength(1));
    expect(last.nextCursor, isNull);
  });

  test('DTO JSON round-trips and maps every field to the entity', () async {
    const source = DummyMarriageDataSource(latency: Duration.zero);
    final dto = (await source.fetchProfiles({})).items.first;
    final again = MarriageProfileDto.fromJson(
      Map<String, dynamic>.from(dto.toJson()),
    );
    final entity = again.toEntity();
    expect(entity.id, dto.id);
    expect(entity.name, dto.name);
    expect(entity.photoUrls, dto.photoUrls);
    expect(entity.faith, dto.faith);
    expect(entity.isIdVerified, dto.isIdVerified);
    expect(entity.bio, dto.bio);
    expect(() => entity.photoUrls.add('x'), throwsUnsupportedError);
  });
}
