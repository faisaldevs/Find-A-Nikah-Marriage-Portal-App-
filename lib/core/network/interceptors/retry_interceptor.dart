import 'dart:math';

import 'package:dio/dio.dart';
import 'package:find_a_nikah/core/network/dio_exception_mapper.dart';

/// `RequestOptions.extra` key: set to `true` (Retrofit `@Extra`) on a
/// non-GET call the backend guarantees is idempotent, to make it retryable.
const idempotentExtraKey = 'idempotent';

const _attemptExtraKey = 'retryAttempt';

/// Retries transient failures of idempotent requests with exponential
/// backoff + jitter, honouring `Retry-After` on 429/503.
///
/// Never retries a POST/PATCH unless marked [idempotentExtraKey] — a
/// duplicated "send message" or "like" is worse than a visible error.
class RetryInterceptor extends Interceptor {
  RetryInterceptor({
    required this._dio,
    this.maxRetries = 3,
    this.baseDelay = const Duration(milliseconds: 500),
    this.maxDelay = const Duration(seconds: 10),
    Future<void> Function(Duration)? sleep,
    Random? random,
  }) : _sleep = sleep ?? Future<void>.delayed,
       _random = random ?? Random();

  final Dio _dio;
  final int maxRetries;
  final Duration baseDelay;
  final Duration maxDelay;
  final Future<void> Function(Duration) _sleep;
  final Random _random;

  static const _idempotentMethods = {'GET', 'HEAD', 'OPTIONS', 'PUT', 'DELETE'};
  static const _retryableStatuses = {429, 502, 503, 504};

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final options = err.requestOptions;
    final attempt = options.extra[_attemptExtraKey] as int? ?? 0;
    if (attempt >= maxRetries ||
        !_isIdempotent(options) ||
        !_isTransient(err)) {
      handler.next(err);
      return;
    }

    await _sleep(_delayFor(err, attempt));
    options.extra[_attemptExtraKey] = attempt + 1;
    try {
      handler.resolve(await _dio.fetch<dynamic>(options));
    } on DioException catch (e) {
      handler.next(e);
    }
  }

  bool _isIdempotent(RequestOptions options) =>
      _idempotentMethods.contains(options.method.toUpperCase()) ||
      options.extra[idempotentExtraKey] == true;

  bool _isTransient(DioException err) => switch (err.type) {
    DioExceptionType.connectionError ||
    DioExceptionType.connectionTimeout ||
    DioExceptionType.receiveTimeout => true,
    DioExceptionType.badResponse => _retryableStatuses.contains(
      err.response?.statusCode,
    ),
    _ => false,
  };

  Duration _delayFor(DioException err, int attempt) {
    final retryAfter = parseRetryAfter(
      err.response?.headers.value('retry-after'),
    );
    if (retryAfter != null) {
      return retryAfter > maxDelay ? maxDelay : retryAfter;
    }
    final exponential = baseDelay * pow(2, attempt).toInt();
    final jitter = Duration(
      milliseconds: _random.nextInt(baseDelay.inMilliseconds + 1),
    );
    final total = exponential + jitter;
    return total > maxDelay ? maxDelay : total;
  }
}
