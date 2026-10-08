import 'dart:math';

import 'package:dio/dio.dart';

/// Header carrying a per-request id the backend logs too, so a crash report
/// can be matched to the server's log line.
const requestIdHeader = 'X-Request-Id';

/// `RequestOptions.extra` key holding the same id for client-side reporting.
const requestIdExtraKey = 'requestId';

/// First in the chain: tags every request with a random id. A retried
/// request keeps its original id.
class RequestIdInterceptor extends Interceptor {
  RequestIdInterceptor({Random? random}) : _random = random ?? Random.secure();

  final Random _random;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final id = options.extra[requestIdExtraKey] as String? ?? _newId();
    options.extra[requestIdExtraKey] = id;
    options.headers[requestIdHeader] = id;
    handler.next(options);
  }

  String _newId() => List.generate(
    16,
    (_) => _random.nextInt(256).toRadixString(16).padLeft(2, '0'),
  ).join();
}
