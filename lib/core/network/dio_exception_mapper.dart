import 'dart:io' show HttpDate, HttpException;

import 'package:dio/dio.dart';
import 'package:find_a_nikah/core/error/app_exception.dart';
import 'package:find_a_nikah/core/error/failure.dart';
import 'package:find_a_nikah/core/network/api_exception.dart';

/// `ExceptionTranslator` for `Guard`: turns a [DioException] (what Retrofit
/// data sources throw) into the matching [ApiException]. Returns null for
/// anything that isn't Dio's.
AppException? translateDioException(Object error) =>
    error is DioException ? mapDioException(error) : null;

/// The single place status codes and Dio error types are interpreted.
ApiException mapDioException(DioException e) {
  // An interceptor (e.g. AuthInterceptor) may already have decided.
  final inner = e.error;
  if (inner is ApiException) return inner;

  switch (e.type) {
    case DioExceptionType.connectionError:
    case DioExceptionType.badCertificate:
      return NetworkException(e.message);
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
    case DioExceptionType.transformTimeout:
      return ApiTimeoutException(e.message);
    case DioExceptionType.cancel:
      return RequestCancelledException(e.message);
    case DioExceptionType.badResponse:
      return _fromResponse(e.response);
    case DioExceptionType.unknown:
      // SocketException and friends surface here with no response.
      return e.response == null
          ? NetworkException(e.message ?? inner?.toString())
          : _fromResponse(e.response);
  }
}

ApiException _fromResponse(Response<dynamic>? response) {
  final status = response?.statusCode;
  final message = _message(response?.data);
  final fields = _fieldErrors(response?.data);
  return switch (status) {
    401 => AuthenticationException(
      response?.requestOptions.path.endsWith('/auth/login') == true
          ? const InvalidCredentialsFailure()
          : const UnauthorizedFailure(),
      message,
    ),
    403 => ForbiddenException(message),
    404 => NotFoundException(message),
    409 => ConflictException(message),
    400 || 422 when fields.isNotEmpty => ValidationException(fields, message),
    422 => ValidationException(const {}, message),
    429 => RateLimitedException(
      parseRetryAfter(response?.headers.value('retry-after')),
      message,
    ),
    _ => ServerException(status, message),
  };
}

String? _message(Object? data) {
  if (data is Map && data['message'] is String) {
    final message = (data['message'] as String).trim();
    if (message.isNotEmpty) return message;
  }
  return null;
}

/// Accepts `{"errors": {"field": "msg"}}` or `{"errors": {"field": ["msg"]}}`.
Map<String, String> _fieldErrors(Object? data) {
  if (data is! Map) return const {};
  final errors = data['errors'];
  if (errors is! Map) return const {};
  return {
    for (final entry in errors.entries)
      '${entry.key}': switch (entry.value) {
        final List<dynamic> list when list.isNotEmpty => '${list.first}',
        final Object value => '$value',
        _ => '',
      },
  };
}

/// `Retry-After` is either delta-seconds or an HTTP date. Null if absent or
/// unparseable.
Duration? parseRetryAfter(String? value, {DateTime? now}) {
  if (value == null) return null;
  final seconds = int.tryParse(value.trim());
  if (seconds != null) return Duration(seconds: seconds);
  try {
    final date = HttpDate.parse(value);
    final diff = date.difference(now ?? DateTime.now().toUtc());
    return diff.isNegative ? Duration.zero : diff;
  } on HttpException {
    return null;
  }
}
