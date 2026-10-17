import 'package:find_a_nikah/core/core.dart';
import 'package:find_a_nikah/features/explore/data/datasources/dummy_explore_data_source.dart';
import 'package:find_a_nikah/features/explore/domain/domain.dart';

class ExploreRepositoryImpl implements ExploreRepository {
  const ExploreRepositoryImpl(this._dummy, this._guard);

  // Dev-only for now — no Explore API exists yet to swap in alongside it
  // (see `MarriageRepositoryImpl` for the shape a real/dummy split takes).
  final DummyExploreDataSource _dummy;
  final Guard _guard;

  @override
  Future<Either<Failure, ExploreFeed>> fetchFeed() => _guard(_dummy.fetchFeed);

  @override
  Future<Either<Failure, ExploreHistoryFeed>> fetchHistory() =>
      _guard(_dummy.fetchHistory);
}
