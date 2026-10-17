import 'package:find_a_nikah/core/core.dart';
import 'package:find_a_nikah/features/explore/domain/entities/explore_feed.dart';
import 'package:find_a_nikah/features/explore/domain/entities/explore_history_feed.dart';

/// Every section on the Explore "For you" tab. Read policy mirrors
/// `MarriageRepository`: network only, no local cache — this is a live
/// "who's around right now" feed.
abstract interface class ExploreRepository {
  Future<Either<Failure, ExploreFeed>> fetchFeed();

  /// The 4 lists behind the "My history" tab's filter chips.
  Future<Either<Failure, ExploreHistoryFeed>> fetchHistory();
}
