import 'package:find_a_nikah/core/core.dart';
import 'package:find_a_nikah/features/discovery/domain/domain.dart';
import 'package:find_a_nikah/features/marriage/domain/entities/marriage_profile.dart';

/// One page of the feed. `nextCursor` is null on the last page.
typedef MarriageFeedPage = ({List<MarriageProfile> items, String? nextCursor});

/// Profiles for the Marriage tab, filtered server-side by the user's
/// `DiscoveryFilters`. Read policy: network only — a stale feed shows
/// people who may have left (decisions register #8).
abstract interface class MarriageRepository {
  /// First page when [cursor] is null.
  Future<Either<Failure, MarriageFeedPage>> fetchPage({
    required DiscoveryFilters filters,
    String? cursor,
  });
}
