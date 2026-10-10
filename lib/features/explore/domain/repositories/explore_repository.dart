import 'package:find_a_nikah/core/core.dart';
import 'package:find_a_nikah/features/explore/domain/entities/explore_feed.dart';

/// Every section on the Explore "For you" tab. Read policy mirrors
/// `MarriageRepository`: network only, no local cache — this is a live
/// "who's around right now" feed.
abstract interface class ExploreRepository {
  Future<Either<Failure, ExploreFeed>> fetchFeed();
}
