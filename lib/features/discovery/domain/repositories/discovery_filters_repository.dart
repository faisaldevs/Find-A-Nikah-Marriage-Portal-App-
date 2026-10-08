import 'package:find_a_nikah/core/core.dart';
import 'package:find_a_nikah/features/discovery/domain/entities/discovery_filters.dart';

/// The signed-in user's partner-preference filters. Session-scoped: dropped
/// on sign-out.
///
/// Edited by the Location / Add filters pages and watched by the Marriage
/// feed, which restarts whenever they change.
abstract interface class DiscoveryFiltersRepository {
  /// Current filters first, then every change.
  Stream<DiscoveryFilters> watchFilters();

  DiscoveryFilters get current;

  /// Write policy: online only once the discovery API exists; in-memory
  /// until then.
  Future<Either<Failure, Unit>> save(DiscoveryFilters filters);
}
