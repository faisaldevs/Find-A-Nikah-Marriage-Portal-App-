import 'package:find_a_nikah/core/core.dart';
import 'package:find_a_nikah/features/discovery/domain/entities/discovery_filters.dart';

/// Device location, for centring the distance map. City-level accuracy is
/// enough for a "within N miles" radius, and the position never leaves the
/// device from here (privacy: never show other users' exact position).
abstract interface class LocationRepository {
  /// Checks access; with [request] shows the system prompt if it hasn't
  /// been answered yet.
  Future<LocationAccess> checkAccess({required bool request});

  /// Fails with `DeviceFailure` when access is missing or the fix times out.
  Future<Either<Failure, GeoPoint>> currentPosition();

  Future<void> openAppSettings();

  Future<void> openLocationSettings();
}
