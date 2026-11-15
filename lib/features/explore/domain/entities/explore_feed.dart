import 'package:equatable/equatable.dart';
import 'package:find_a_nikah/features/explore/domain/entities/explore_profile.dart';

/// Every section on the "For you" tab. The header badge next to a section
/// title is its own count (e.g. "Visited you" can say 1 new while showing
/// more cards than that) — never `profiles.length` — so each section
/// carries its count alongside its list.
///
/// Paged sections ("Active near you") also carry the last loaded [page]
/// (1-based; 0 = nothing loaded) and whether the server has more.
/// [locked] = premium-gated for this member: cards show with the lock and
/// don't open.
class ExploreSection extends Equatable {
  const ExploreSection({
    this.count = 0,
    this.profiles = const <ExploreProfile>[],
    this.page = 0,
    this.hasMore = false,
    this.locked = false,
  });

  final int count;
  final List<ExploreProfile> profiles;
  final int page;
  final bool hasMore;
  final bool locked;

  ExploreSection copyWith({
    int? count,
    List<ExploreProfile>? profiles,
    int? page,
    bool? hasMore,
    bool? locked,
  }) {
    return ExploreSection(
      count: count ?? this.count,
      profiles: profiles ?? this.profiles,
      page: page ?? this.page,
      hasMore: hasMore ?? this.hasMore,
      locked: locked ?? this.locked,
    );
  }

  @override
  List<Object?> get props => [
    count,
    profiles,
    page,
    hasMore,
    locked,
  ];
}

class ExploreFeed extends Equatable {
  const ExploreFeed({
    this.likesInFilters = const ExploreSection(),
    this.secondLook = const ExploreSection(),
    this.currentlyAvailable = const ExploreSection(),
    this.visitedYou = const ExploreSection(),
    this.justJoined = const ExploreSection(),
    this.activeNearYou = const ExploreSection(),
  });

  final ExploreSection likesInFilters;
  final ExploreSection secondLook;
  final ExploreSection currentlyAvailable;
  final ExploreSection visitedYou;
  final ExploreSection justJoined;
  final ExploreSection activeNearYou;

  ExploreFeed copyWith({
    ExploreSection? likesInFilters,
    ExploreSection? secondLook,
    ExploreSection? currentlyAvailable,
    ExploreSection? visitedYou,
    ExploreSection? justJoined,
    ExploreSection? activeNearYou,
  }) {
    return ExploreFeed(
      likesInFilters: likesInFilters ?? this.likesInFilters,
      secondLook: secondLook ?? this.secondLook,
      currentlyAvailable: currentlyAvailable ?? this.currentlyAvailable,
      visitedYou: visitedYou ?? this.visitedYou,
      justJoined: justJoined ?? this.justJoined,
      activeNearYou: activeNearYou ?? this.activeNearYou,
    );
  }

  @override
  List<Object?> get props => [
    likesInFilters,
    secondLook,
    currentlyAvailable,
    visitedYou,
    justJoined,
    activeNearYou,
  ];
}

/// Explore sections backed by a real, paged `GET /v1/profiles/feed/<x>`
/// endpoint (cached, offline-first). The rest of [ExploreFeed] is still
/// dummy data.
/// [passed] backs My history's "Passed" filter, not a "For you" section.
enum ExploreLiveSection {
  likesInFilters,
  secondLook,
  visitedYou,
  justJoined,
  activeNearYou,
  passed,

  /// My history → Liked (members I liked); `likesInFilters` is the
  /// reverse — members who liked me.
  liked,

  /// My history → Favourited (`GET /v1/favorites`).
  favourited,

  /// My history → Complimented (`GET /v1/likes/compliments-sent`).
  complimented,
}
