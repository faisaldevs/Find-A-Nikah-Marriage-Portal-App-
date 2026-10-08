import 'package:find_a_nikah/core/error/failure.dart';

/// User-facing text for a [Failure]. Exhaustive: adding a [Failure] case
/// breaks the build here until it has wording.
///
/// English only until the l10n approach is decided; this switch then reads
/// from the localisation layer instead.
extension FailureText on Failure {
  String get title => switch (this) {
    NetworkFailure() => 'No internet connection',
    TimeoutFailure() => 'The server is taking too long',
    SessionExpiredFailure() => 'Your session has expired',
    UnauthorizedFailure() => 'Sign-in required',
    InvalidCredentialsFailure() => 'Sign-in failed',
    ApiResponseFailure(:final fallback) => fallback.title,
    ForbiddenFailure() => "You don't have access to this",
    NotFoundFailure() => "We couldn't find that",
    ConflictFailure() => 'That changed in the meantime',
    ValidationFailure() => 'Please check the highlighted fields',
    RateLimitedFailure() => 'Too many attempts',
    ServerFailure() => 'Something went wrong on our side',
    StorageFailure() => "We couldn't save that on this device",
    DeviceFailure() => "That isn't available on this device",
    UnknownFailure() => 'Something went wrong',
  };

  String get message => switch (this) {
    NetworkFailure() => 'Check your connection and try again.',
    TimeoutFailure() => 'Please try again in a moment.',
    SessionExpiredFailure() => 'Please sign in again.',
    UnauthorizedFailure() => 'Please check your details and try again.',
    InvalidCredentialsFailure() => 'Check your email and password.',
    ApiResponseFailure(:final message) => message,
    RateLimitedFailure(:final retryAfter) =>
      retryAfter == null
          ? 'Please wait a little before trying again.'
          : 'Please try again in ${retryAfter.inSeconds} seconds.',
    ValidationFailure(:final fields) =>
      fields.isEmpty ? 'Some details are not valid.' : fields.values.first,
    _ => 'Please try again.',
  };
}
