import 'package:find_a_nikah/core/core.dart';
import 'package:find_a_nikah/features/discovery/domain/entities/discovery_filters.dart';

/// Saves the member's location preference to the backend (onboarding
/// step 11): either a country, or a point + radius.
abstract interface class LocationPreferenceRepository {
  /// [countryName] as shown in the list, e.g. "Bangladesh".
  Future<Either<Failure, Unit>> saveCountry(String countryName);

  /// [center] = the member's position; [distanceMiles] = slider value
  /// (the max, [kMaxDistanceMiles], when "Everywhere").
  Future<Either<Failure, Unit>> saveArea({
    required GeoPoint center,
    required double distanceMiles,
  });
}
