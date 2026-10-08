import 'package:dio/dio.dart';
import 'package:find_a_nikah/core/logging/logger.dart';

/// Last in the chain, debug builds only: one line per request/response with
/// auth headers and personal fields redacted.
class LoggingInterceptor extends Interceptor {
  LoggingInterceptor(this._logger);

  final Logger _logger;

  static const _redactedHeaders = {'authorization', 'cookie', 'set-cookie'};

  /// Body keys whose values never reach a log (matched case-insensitively,
  /// at any depth).
  static const redactedKeys = {
    'password',
    'token',
    'accesstoken',
    'access_token',
    'refreshtoken',
    'refresh_token',
    'idtoken',
    'otp',
    'code',
    'phone',
    'phonenumber',
    'phone_number',
    'email',
    'latitude',
    'longitude',
    'lat',
    'lng',
  };

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _logger.debug(
      '→ ${options.method} ${options.uri} '
      'headers=${_redactHeaders(options.headers)} '
      'body=${redact(options.data)}',
    );
    handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    _logger.debug(
      '← ${response.statusCode} ${response.requestOptions.method} '
      '${response.requestOptions.uri} body=${redact(response.data)}',
    );
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _logger.debug(
      '✗ ${err.response?.statusCode ?? err.type.name} '
      '${err.requestOptions.method} ${err.requestOptions.uri} '
      'body=${redact(err.response?.data)}',
    );
    handler.next(err);
  }

  Map<String, Object?> _redactHeaders(Map<String, dynamic> headers) => {
    for (final e in headers.entries)
      e.key: _redactedHeaders.contains(e.key.toLowerCase())
          ? '<redacted>'
          : e.value,
  };

  /// Copy of [data] with every [redactedKeys] value replaced.
  static Object? redact(Object? data) => switch (data) {
    final Map<dynamic, dynamic> map => {
      for (final e in map.entries)
        e.key: redactedKeys.contains('${e.key}'.toLowerCase())
            ? '<redacted>'
            : redact(e.value),
    },
    final List<dynamic> list => [for (final item in list) redact(item)],
    FormData() => '<form-data>',
    _ => data,
  };
}
