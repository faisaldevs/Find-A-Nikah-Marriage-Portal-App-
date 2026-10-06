import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'discovery_filters.dart';

/// Holds the partner-preference filters while the user moves between
/// "Add filters" and the "Location" screen. In-memory only for now —
/// persistence + the discovery API call arrive with the discovery feature.
class DiscoveryFiltersController extends Notifier<DiscoveryFilters> {
  @override
  DiscoveryFilters build() => const DiscoveryFilters();

  void setAgeRange(int min, int max) {
    state = state.copyWith(minAge: min, maxAge: max);
  }

  /// Confirm on the Distance tab. Replaces any country filter.
  void setDistanceFilter({
    required double miles,
    required bool limitToHomeCountry,
  }) {
    state = state.copyWith(
      locationMode: LocationFilterMode.distance,
      distanceMiles: miles,
      limitToHomeCountry: limitToHomeCountry,
      countryCode: null,
    );
  }

  /// Confirm on the Country tab. Replaces any distance filter.
  void setCountryFilter(String countryCode) {
    state = state.copyWith(
      locationMode: LocationFilterMode.country,
      countryCode: countryCode,
    );
  }

  /// "Clear" in the Location app bar, and "Discard" on the remove-filter
  /// sheet. Distance draft values reset too so the slider reads Everywhere.
  void clearLocationFilter() {
    state = state.copyWith(
      locationMode: null,
      distanceMiles: kMaxDistanceMiles,
      limitToHomeCountry: false,
      countryCode: null,
    );
  }

  void setEthnicities(List<String> codes) {
    state = state.copyWith(ethnicities: codes);
  }
}

final discoveryFiltersControllerProvider =
    NotifierProvider<DiscoveryFiltersController, DiscoveryFilters>(
      DiscoveryFiltersController.new,
    );
