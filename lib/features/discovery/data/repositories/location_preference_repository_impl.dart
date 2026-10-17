import 'package:find_a_nikah/core/core.dart';
import 'package:find_a_nikah/features/discovery/data/datasources/discovery_remote_data_source.dart';
import 'package:find_a_nikah/features/discovery/data/dtos/location_step_request.dart';
import 'package:find_a_nikah/features/discovery/domain/domain.dart';

class LocationPreferenceRepositoryImpl implements LocationPreferenceRepository {
  const LocationPreferenceRepositoryImpl(this._remote, this._guard);

  final DiscoveryRemoteDataSource _remote;
  final Guard _guard;

  @override
  Future<Either<Failure, Unit>> saveCountry(String countryName) =>
      _guard(() async {
        await _remote.submitLocation(
          LocationStepRequestDto(country: countryName),
        );
        return unit;
      });

  @override
  Future<Either<Failure, Unit>> saveArea({
    required GeoPoint center,
    required double distanceMiles,
  }) => _guard(() async {
    await _remote.submitLocation(
      LocationStepRequestDto(
        coordinates: LocationCoordinatesDto(
          longitude: center.longitude,
          latitude: center.latitude,
          distance: distanceMiles,
        ),
      ),
    );
    return unit;
  });
}
