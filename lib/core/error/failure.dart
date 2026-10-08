/// Every way an operation above the repository layer can fail.
///
/// Sealed, so a `switch` over a [Failure] is exhaustive: adding a case makes
/// the compiler point at every place that has to handle it. Presentation maps
/// each case to user-facing text; nothing below presentation produces text.
sealed class Failure {
  const Failure();
}

/// No connection, DNS failure, socket closed.
final class NetworkFailure extends Failure {
  const NetworkFailure();
}

/// The server didn't answer in time.
final class TimeoutFailure extends Failure {
  const TimeoutFailure();
}

/// The session is gone (refresh failed). Presentation logs the user out.
final class SessionExpiredFailure extends Failure {
  const SessionExpiredFailure();
}

/// An unauthenticated API response that did not come from session refresh.
final class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure();
}

/// Login rejected the submitted credentials.
final class InvalidCredentialsFailure extends Failure {
  const InvalidCredentialsFailure();
}

/// An API-provided message takes precedence over the fallback category text.
final class ApiResponseFailure extends Failure {
  const ApiResponseFailure({required this.fallback, required this.message});

  final Failure fallback;
  final String message;
}

/// Authenticated, but not allowed (403).
final class ForbiddenFailure extends Failure {
  const ForbiddenFailure();
}

final class NotFoundFailure extends Failure {
  const NotFoundFailure();
}

/// The request conflicts with the current server state (409).
final class ConflictFailure extends Failure {
  const ConflictFailure();
}

/// Server-side validation failed (422). [fields] maps field name → message.
final class ValidationFailure extends Failure {
  const ValidationFailure(this.fields);
  final Map<String, String> fields;
}

/// Too many requests (429). Disable the action until [retryAfter] elapses.
final class RateLimitedFailure extends Failure {
  const RateLimitedFailure(this.retryAfter);
  final Duration? retryAfter;
}

/// 5xx, or a response the client can't understand.
final class ServerFailure extends Failure {
  const ServerFailure();
}

/// Local storage (secure storage, database, files) failed.
final class StorageFailure extends Failure {
  const StorageFailure();
}

/// A device capability failed or was refused (camera, location, ML Kit).
final class DeviceFailure extends Failure {
  const DeviceFailure();
}

/// Anything unexpected. Always reported to crash reporting before returning.
final class UnknownFailure extends Failure {
  const UnknownFailure();
}
