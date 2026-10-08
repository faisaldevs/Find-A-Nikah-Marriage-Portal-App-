import 'package:find_a_nikah/core/core.dart';
import 'package:find_a_nikah/features/remote_config/domain/entities/remote_config.dart';

/// Read policy: network, last value as fallback (decisions register #8).
abstract interface class RemoteConfigRepository {
  /// Fetches the config; on failure returns the last fetched value if any,
  /// else the failure (callers then use flag defaults).
  Future<Either<Failure, RemoteConfig>> fetch();

  /// Last fetched config, or all-defaults before the first success.
  RemoteConfig get current;
}
