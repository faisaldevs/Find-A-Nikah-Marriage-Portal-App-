import 'package:find_a_nikah/features/explore/domain/entities/explore_profile.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'explore_history_feed.freezed.dart';

/// The 4 lists behind the Explore "My history" tab's filter chips. No
/// per-list `count` badge, unlike `ExploreSection` — the mockup doesn't
/// show one here.
@freezed
abstract class ExploreHistoryFeed with _$ExploreHistoryFeed {
  const factory ExploreHistoryFeed({
    @Default(<ExploreProfile>[]) List<ExploreProfile> liked,
    @Default(<ExploreProfile>[]) List<ExploreProfile> favourited,
    @Default(<ExploreProfile>[]) List<ExploreProfile> passed,
    @Default(<ExploreProfile>[]) List<ExploreProfile> complimented,
  }) = _ExploreHistoryFeed;
}
