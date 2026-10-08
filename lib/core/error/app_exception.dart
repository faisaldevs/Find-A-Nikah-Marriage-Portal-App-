import 'package:find_a_nikah/core/error/failure.dart';
import 'package:find_a_nikah/core/error/guard.dart' show Guard;

/// Base for every typed exception thrown by a data source.
///
/// Data sources throw subclasses of this; repositories never let them
/// escape — [Guard] converts them with [toFailure].
abstract class AppException implements Exception {
  const AppException([this.message]);

  /// Developer-facing detail for logs. Never shown to users.
  final String? message;

  /// The [Failure] this exception becomes above the repository layer.
  Failure toFailure();

  @override
  String toString() => '$runtimeType${message == null ? '' : ': $message'}';
}

/// Thrown by local-store wrappers (secure storage, database, file cache).
/// Reported to crash reporting by [Guard] because it usually means a bug or
/// a corrupted store, not a user error.
class StorageException extends AppException {
  const StorageException([super.message]);

  @override
  Failure toFailure() => const StorageFailure();
}

/// Thrown by device-capability wrappers (camera, location, on-device ML).
class DeviceException extends AppException {
  const DeviceException([super.message]);

  @override
  Failure toFailure() => const DeviceFailure();
}
