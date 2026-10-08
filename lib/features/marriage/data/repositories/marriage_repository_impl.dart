import 'package:find_a_nikah/core/core.dart';
import 'package:find_a_nikah/features/discovery/domain/domain.dart';
import 'package:find_a_nikah/features/marriage/data/datasources/marriage_remote_data_source.dart';
import 'package:find_a_nikah/features/marriage/data/dtos/marriage_profile_dto.dart';
import 'package:find_a_nikah/features/marriage/domain/repositories/marriage_repository.dart';

class MarriageRepositoryImpl implements MarriageRepository {
  const MarriageRepositoryImpl(this._remote, this._guard);

  final MarriageRemoteDataSource _remote;
  final Guard _guard;

  static const pageSize = 20;

  @override
  Future<Either<Failure, MarriageFeedPage>> fetchPage({
    required DiscoveryFilters filters,
    String? cursor,
  }) => _guard(() async {
    final page = await _remote.fetchProfiles(
      filtersToQuery(filters, cursor: cursor),
    );
    return (
      items: [for (final dto in page.items) dto.toEntity()],
      nextCursor: page.nextCursor,
    );
  });

  /// The query the discovery API expects. Only set filters are sent.
  static Map<String, dynamic> filtersToQuery(
    DiscoveryFilters f, {
    String? cursor,
  }) => {
    'limit': pageSize,
    'cursor': ?cursor,
    if (!f.isAnyAge) ...{'minAge': f.minAge, 'maxAge': f.maxAge},
    if (f.locationMode == LocationFilterMode.distance && !f.isEverywhere)
      'maxDistanceMiles': f.distanceMiles.round(),
    if (f.locationMode == LocationFilterMode.distance && f.limitToHomeCountry)
      'country': kHomeCountryCode,
    if (f.locationMode == LocationFilterMode.country) 'country': f.countryCode,
    if (f.ethnicities.isNotEmpty) 'ethnicity': f.ethnicities.join(','),
  };
}
