import 'package:dio/dio.dart';
import 'package:find_a_nikah/core/logging/logger.dart';
import 'package:find_a_nikah/core/network/interceptors/auth_interceptor.dart';
import 'package:find_a_nikah/core/network/interceptors/logging_interceptor.dart';
import 'package:find_a_nikah/core/network/interceptors/request_id_interceptor.dart';
import 'package:find_a_nikah/core/network/interceptors/retry_interceptor.dart';
import 'package:find_a_nikah/core/network/token_store.dart';
import 'package:flutter/foundation.dart';

/// Everything the HTTP stack needs from the flavor config.
@immutable
class ApiClientConfig {
  const ApiClientConfig({
    required this.baseUrl,
    required this.appVersion,
    required this.platform,
    this.connectTimeout = const Duration(seconds: 10),
    this.receiveTimeout = const Duration(seconds: 20),
    this.enableLogging = false,
  });

  final String baseUrl;

  /// Sent as `X-App-Version` so the backend can return "update required"
  /// once this version leaves its support window.
  final String appVersion;

  /// `ios` / `android`, sent as `X-Platform`.
  final String platform;
  final Duration connectTimeout;
  final Duration receiveTimeout;

  /// Debug builds only — release builds must never log bodies.
  final bool enableLogging;
}

/// The app's one HTTP stack.
///
/// - [dio]: every Retrofit data source uses this. Interceptor order:
///   request id → auth → retry → logging.
/// - [bareDio]: same base options, no auth interceptor. Only for the token
///   refresh call (and the auth interceptor's replay), so refresh can't
///   loop.
///
/// Large JSON bodies are decoded off the UI thread by Dio's default
/// `BackgroundTransformer` (an isolate for responses over 50 KB).
class ApiClient {
  ApiClient({
    required ApiClientConfig config,
    required TokenStore tokenStore,
    required TokenRefresher refreshTokens,
    required void Function() onSessionExpired,
    required Logger logger,
    @visibleForTesting HttpClientAdapter? adapter,
    @visibleForTesting Future<void> Function(Duration)? retrySleep,
  }) {
    final options = BaseOptions(
      baseUrl: config.baseUrl,
      connectTimeout: config.connectTimeout,
      receiveTimeout: config.receiveTimeout,
      headers: {
        'Accept': 'application/json',
        'X-App-Version': config.appVersion,
        'X-Platform': config.platform,
      },
    );

    bareDio = Dio(options);
    dio = Dio(options);
    if (adapter != null) {
      bareDio.httpClientAdapter = adapter;
      dio.httpClientAdapter = adapter;
    }

    final requestId = RequestIdInterceptor();
    bareDio.interceptors.addAll([
      requestId,
      if (config.enableLogging) LoggingInterceptor(logger),
    ]);
    dio.interceptors.addAll([
      requestId,
      AuthInterceptor(
        tokenStore: tokenStore,
        refreshTokens: refreshTokens,
        bareDio: bareDio,
        onSessionExpired: onSessionExpired,
      ),
      RetryInterceptor(dio: dio, sleep: retrySleep),
      if (config.enableLogging) LoggingInterceptor(logger),
    ]);
  }

  late final Dio dio;
  late final Dio bareDio;
}
