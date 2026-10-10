import 'package:find_a_nikah/features/explore/domain/entities/explore_profile.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'explore_feed.freezed.dart';

/// Every section on the "For you" tab. The header badge next to a section
/// title is its own count (e.g. "Visited you" can say 1 new while showing
/// more cards than that) — never `profiles.length` — so each section
/// carries its count alongside its list.
@freezed
abstract class ExploreSection with _$ExploreSection {
  const factory ExploreSection({
    @Default(0) int count,
    @Default(<ExploreProfile>[]) List<ExploreProfile> profiles,
  }) = _ExploreSection;
}

@freezed
abstract class ExploreFeed with _$ExploreFeed {
  const factory ExploreFeed({
    @Default(ExploreSection()) ExploreSection likesInFilters,
    @Default(ExploreSection()) ExploreSection secondLook,
    @Default(ExploreSection()) ExploreSection currentlyAvailable,
    @Default(ExploreSection()) ExploreSection visitedYou,
    @Default(ExploreSection()) ExploreSection justJoined,
    @Default(ExploreSection()) ExploreSection activeNearYou,
  }) = _ExploreFeed;
}
