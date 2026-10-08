import 'package:find_a_nikah/core/error/app_exception.dart';
import 'package:find_a_nikah/core/error/failure.dart';

/// Every way an HTTP call can fail, as seen by a data source.
///
/// Produced only by `mapDioException` (via `translateDioException`);
/// no other code inspects status codes. Each subtype knows its [Failure].
sealed class ApiException extends AppException {
  const ApiException([super.message]);
}

/// No connection, DNS failure, socket closed, TLS failure.
final class NetworkException extends ApiException {
  const NetworkException([super.message]);

  @override
  Failure toFailure() =>
      failureWithResponseMessage(const NetworkFailure(), message);
}

/// Connect, send or receive timed out.
final class ApiTimeoutException extends ApiException {
  const ApiTimeoutException([super.message]);

  @override
  Failure toFailure() =>
      failureWithResponseMessage(const TimeoutFailure(), message);
}

/// 401 after the token refresh already failed — the session is over.
final class UnauthorizedException extends ApiException {
  const UnauthorizedException([super.message]);

  @override
  Failure toFailure() => const SessionExpiredFailure();
}

/// A 401 returned directly by an endpoint, rather than by session refresh.
final class AuthenticationException extends ApiException {
  const AuthenticationException(this.fallback, [super.message]);

  final Failure fallback;

  @override
  Failure toFailure() => failureWithResponseMessage(fallback, message);
}

/// 403.
final class ForbiddenException extends ApiException {
  const ForbiddenException([super.message]);

  @override
  Failure toFailure() =>
      failureWithResponseMessage(const ForbiddenFailure(), message);
}

/// 404.
final class NotFoundException extends ApiException {
  const NotFoundException([super.message]);

  @override
  Failure toFailure() =>
      failureWithResponseMessage(const NotFoundFailure(), message);
}

/// 409.
final class ConflictException extends ApiException {
  const ConflictException([super.message]);

  @override
  Failure toFailure() =>
      failureWithResponseMessage(const ConflictFailure(), message);
}

/// 422 (and 400 with field errors). [fieldErrors] maps field → message.
final class ValidationException extends ApiException {
  const ValidationException(this.fieldErrors, [super.message]);

  final Map<String, String> fieldErrors;

  @override
  Failure toFailure() => failureWithResponseMessage(
    ValidationFailure(fieldErrors),
    message,
  );
}

/// 429. [retryAfter] comes from the `Retry-After` header when present.
final class RateLimitedException extends ApiException {
  const RateLimitedException(this.retryAfter, [super.message]);

  final Duration? retryAfter;

  @override
  Failure toFailure() => failureWithResponseMessage(
    RateLimitedFailure(retryAfter),
    message,
  );
}

/// 5xx, any other unexpected status, or a body the client can't parse.
final class ServerException extends ApiException {
  const ServerException(this.statusCode, [super.message]);

  final int? statusCode;

  @override
  Failure toFailure() =>
      failureWithResponseMessage(const ServerFailure(), message);
}

/// The caller cancelled the request (e.g. the screen closed).
final class RequestCancelledException extends ApiException {
  const RequestCancelledException([super.message]);

  @override
  Failure toFailure() => const UnknownFailure();
}

Failure failureWithResponseMessage(Failure fallback, String? message) {
  final responseMessage = message?.trim();
  if (responseMessage == null || responseMessage.isEmpty) return fallback;
  return ApiResponseFailure(fallback: fallback, message: responseMessage);
}
