import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'api_endpoints.dart';

/// Fired on a 401 for a request that carried a session (i.e. not a bare
/// login/register attempt) — wire this to `authProvider`'s logout once that
/// provider exists in `core/providers/`. Never fired for [ApiEndpoints.authPaths].
typedef UnauthorizedCallback = void Function();

/// Thin wrapper around a configured [Dio] instance. Repositories depend on
/// this (via [dioClientProvider]), never construct `Dio` themselves.
class DioClient {
  DioClient({UnauthorizedCallback? onUnauthorized}) {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: const {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );

    dio.interceptors.addAll([
      _UnauthorizedInterceptor(onUnauthorized: onUnauthorized),
      if (kDebugMode)
        LogInterceptor(requestBody: true, responseBody: true, error: true),
    ]);
  }

  late final Dio dio;

  /// Set after login. Attached to every subsequent request as
  /// `Authorization: Bearer <token>` — no per-request lookup needed.
  void setAuthToken(String token) =>
      dio.options.headers['Authorization'] = 'Bearer $token';

  /// Called on logout — drops the header so no stale token leaks into
  /// requests still in flight after the session ends.
  void clearAuthToken() => dio.options.headers.remove('Authorization');
}

class _UnauthorizedInterceptor extends Interceptor {
  _UnauthorizedInterceptor({this.onUnauthorized});
  final UnauthorizedCallback? onUnauthorized;

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final is401 = err.response?.statusCode == 401;
    final isAuthPath = ApiEndpoints.authPaths.any(
      err.requestOptions.path.contains,
    );
    if (is401 && !isAuthPath) onUnauthorized?.call();
    handler.next(err);
  }
}

/// Override this in `ProviderScope` (or wire `onUnauthorized` here directly)
/// once `authProvider` exists, so a 401 actually triggers logout + redirect.
final dioClientProvider = Provider<DioClient>((ref) {
  return DioClient();
});
