import 'package:find_a_nikah/core/core.dart';
import 'package:find_a_nikah/features/explore/domain/entities/explore_feed.dart';
import 'package:find_a_nikah/features/explore/domain/entities/explore_history_feed.dart';

/// Every section on the Explore "For you" tab. [fetchFeed] mirrors
/// `MarriageRepository`: network only, no local cache. The
/// [ExploreLiveSection]s are cache, then network: [cachedSection] shows
/// at once, then [fetchSection] quietly replaces it.
abstract interface class ExploreRepository {
  Future<Either<Failure, ExploreFeed>> fetchFeed();

  /// The 4 lists behind the "My history" tab's filter chips.
  Future<Either<Failure, ExploreHistoryFeed>> fetchHistory();

  /// Page 1 of [section] as last saved — null on first launch, after
  /// sign-out, or when the cache can't be read.
  Future<ExploreSection?> cachedSection(ExploreLiveSection section);

  /// One 1-based [page] of [section] from the API. A successful page 1
  /// also replaces the cached copy.
  Future<Either<Failure, ExploreSection>> fetchSection(
    ExploreLiveSection section, {
    required int page,
  });
}
