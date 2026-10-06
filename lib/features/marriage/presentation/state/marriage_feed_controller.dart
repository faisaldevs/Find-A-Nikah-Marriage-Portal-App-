import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/filters/discovery_filters_controller.dart';
import '../data/dummy_profiles.dart';
import 'marriage_profile.dart';

/// Profiles in the Marriage feed. Dummy for now.
///
/// TODO(discovery): fetch from the API using the current
/// `discoveryFiltersControllerProvider` value.
final marriageProfilesProvider = Provider<List<MarriageProfile>>(
  (ref) => dummyMarriageProfiles,
);

/// Index of the profile currently on screen.
///
/// Cancel / Save → [next] (loops back to the first profile at the end).
/// Previous → [previous] (disabled on the first profile).
/// Changing the filters restarts the feed from the first profile.
class MarriageFeedController extends Notifier<int> {
  @override
  int build() {
    // Rebuild — and so reset to 0 — whenever the filters change.
    ref.watch(discoveryFiltersControllerProvider);
    ref.watch(marriageProfilesProvider);
    return 0;
  }

  int get _count => ref.read(marriageProfilesProvider).length;

  bool get canGoBack => state > 0;

  void next() {
    if (_count == 0) return;
    state = (state + 1) % _count;
  }

  void previous() {
    if (canGoBack) state = state - 1;
  }
}

final marriageFeedControllerProvider =
    NotifierProvider<MarriageFeedController, int>(MarriageFeedController.new);

/// The profile on screen, or null when the feed is empty.
final currentMarriageProfileProvider = Provider<MarriageProfile?>((ref) {
  final profiles = ref.watch(marriageProfilesProvider);
  if (profiles.isEmpty) return null;
  final index = ref.watch(marriageFeedControllerProvider);
  return profiles[index.clamp(0, profiles.length - 1)];
});
