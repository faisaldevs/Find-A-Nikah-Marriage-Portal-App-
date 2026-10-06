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
/// TODO(profile): read from the signed-in user's grew-up country once a
/// profile/auth provider exists in `core/` — onboarding's controller can't be
/// imported from here (features never import each other).
const kHomeCountryCode = 'BD';

/// Partner-preference filters collected on "Add filters" and the "Location"
/// screen (`features/auth/location`) and consumed by the Marriage feed
/// (`features/marriage`). Lives in `core/` because two features share it.
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

    /// Country-mode field: ISO code from `core/constants/countries.dart`.
    String? countryCode,

    /// Ethnicity codes; empty = "No preference".
    @Default(<String>[]) List<String> ethnicities,
  }) = _DiscoveryFilters;

  const DiscoveryFilters._();

  bool get isAnyAge => minAge == kMinAge && maxAge == kMaxAge;
  bool get isEverywhere => distanceMiles >= kMaxDistanceMiles;
  bool get hasLocationFilter => locationMode != null;
}
