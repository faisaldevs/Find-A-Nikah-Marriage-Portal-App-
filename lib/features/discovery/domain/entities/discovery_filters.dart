import 'package:freezed_annotation/freezed_annotation.dart';

part 'discovery_filters.freezed.dart';

/// Members can only apply ONE location filter at a time (per the "Remove
/// location filter?" sheet in the mockups) — hence a mode enum instead of
/// two independent fields that could both be set.
enum LocationFilterMode { distance, country }

const kMinAge = 18;
const kMaxAge = 80;

/// Slider ceiling — at this value the UI reads "Everywhere".
const kMaxDistanceMiles = 500.0;
const kMinDistanceMiles = 5.0;

/// Country the "Limit to only …" toggle refers to.
// TODO(profile): read from the signed-in user's grew-up country once a
/// profile repository exists (its domain can then be imported here).
const kHomeCountryCode = 'BD';

/// Partner-preference filters collected on "Add filters" and the "Location"
/// screen and consumed by the Marriage feed (`features/marriage`, through
/// this feature's domain).
@freezed
abstract class DiscoveryFilters with _$DiscoveryFilters {
  const factory DiscoveryFilters({
    @Default(kMinAge) int minAge,
    @Default(kMaxAge) int maxAge,

    /// Null = no location filter applied.
    LocationFilterMode? locationMode,

    /// Distance-mode fields. Kept even when [locationMode] is `country` so
    /// switching back restores the last slider position.
    @Default(kMaxDistanceMiles) double distanceMiles,
    @Default(false) bool limitToHomeCountry,

    /// Country-mode field: ISO code from `package:core` `allCountries`.
    String? countryCode,

    /// Ethnicity codes; empty = "No preference".
    @Default(<String>[]) List<String> ethnicities,
  }) = _DiscoveryFilters;

  const DiscoveryFilters._();

  bool get isAnyAge => minAge == kMinAge && maxAge == kMaxAge;
  bool get isEverywhere => distanceMiles >= kMaxDistanceMiles;
  bool get hasLocationFilter => locationMode != null;

  /// Members can apply age bounds anywhere in [kMinAge]–[kMaxAge].
  DiscoveryFilters withAgeRange(int min, int max) {
    if (min < kMinAge || max > kMaxAge || min > max) {
      throw ArgumentError('age range $min–$max outside $kMinAge–$kMaxAge');
    }
    return copyWith(minAge: min, maxAge: max);
  }

  /// Applies a distance filter; replaces any country filter.
  DiscoveryFilters withDistance({
    required double miles,
    required bool limitToHomeCountry,
  }) => copyWith(
    locationMode: LocationFilterMode.distance,
    distanceMiles: miles.clamp(kMinDistanceMiles, kMaxDistanceMiles),
    limitToHomeCountry: limitToHomeCountry,
    countryCode: null,
  );

  /// Applies a country filter; replaces any distance filter. The distance
  /// slider position is kept so switching back restores it.
  DiscoveryFilters withCountry(String countryCode) => copyWith(
    locationMode: LocationFilterMode.country,
    countryCode: countryCode,
  );

  /// No location filter; the distance draft resets to "Everywhere".
  DiscoveryFilters withoutLocation() => copyWith(
    locationMode: null,
    distanceMiles: kMaxDistanceMiles,
    limitToHomeCountry: false,
    countryCode: null,
  );

  DiscoveryFilters withEthnicities(List<String> codes) =>
      copyWith(ethnicities: List.unmodifiable(codes));
}

/// A position on the map, without any map package's type.
@freezed
abstract class GeoPoint with _$GeoPoint {
  const factory GeoPoint(double latitude, double longitude) = _GeoPoint;

  /// Dhaka — where the map lands when location is unavailable, since the
  /// launch market is Bangladesh.
  static const fallback = GeoPoint(23.8103, 90.4125);
}

/// Whether the app may read the device location.
enum LocationAccess { checking, granted, denied, serviceOff }
