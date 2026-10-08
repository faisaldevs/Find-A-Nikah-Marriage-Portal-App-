import 'package:dio/dio.dart';
import 'package:find_a_nikah/core/network/api_exception.dart';
import 'package:find_a_nikah/core/network/dio_exception_mapper.dart';
import 'package:find_a_nikah/core/network/token_store.dart';

/// `RequestOptions.extra` key: set to `false` (Retrofit `@Extra`) on calls
/// that must not carry a token — login, register, refresh, public config.
const requiresAuthExtraKey = 'requiresAuth';

const _retriedExtraKey = 'authRetried';

/// Attaches the access token and recovers from expired tokens.
///
/// A `QueuedInterceptor`, so when several requests fail with 401 at once
/// only the first one refreshes; the others see the token already changed
/// and replay with it.
///
/// If the backend rejects the refresh token, credentials are cleared,
/// `onSessionExpired` fires (the app emits `unauthenticated`) and the caller
/// gets an [UnauthorizedException] → `SessionExpiredFailure`.
class AuthInterceptor extends QueuedInterceptor {
  AuthInterceptor({
    required this._tokenStore,
    required this._refreshTokens,
    required this._bareDio,
    required this._onSessionExpired,
  });

  final TokenStore _tokenStore;
  final TokenRefresher _refreshTokens;

  /// No auth interceptor: used for the refresh call and for replaying the
  /// failed request, so neither can recurse into this interceptor.
  final Dio _bareDio;
  final void Function() _onSessionExpired;

  static bool _requiresAuth(RequestOptions options) =>
      options.extra[requiresAuthExtraKey] != false;

  static String _bearer(String token) => ['Bearer', token].join(' ');

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (_requiresAuth(options)) {
      final tokens = await _tokenStore.read();
      if (tokens != null) {
        options.headers['Authorization'] = _bearer(tokens.accessToken);
      }
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final options = err.requestOptions;
    final isUnauthorized = err.response?.statusCode == 401;
    if (!isUnauthorized ||
        !_requiresAuth(options) ||
        options.extra[_retriedExtraKey] == true) {
      handler.next(err);
      return;
    }

    final current = await _tokenStore.read();
    if (current == null) {
      _expire(err, handler);
      return;
    }

    // Another queued 401 already refreshed: just replay with the new token.
    final sentHeader = options.headers['Authorization'];
    if (sentHeader != _bearer(current.accessToken)) {
      await _replay(options, current.accessToken, handler);
      return;
    }

    final AuthTokens refreshed;
    try {
      refreshed = await _refreshTokens(_bareDio, current.refreshToken);
    } on DioException catch (refreshError) {
      final status = refreshError.response?.statusCode;
      final rejected = status != null && status >= 400 && status < 500;
      if (rejected) {
        _expire(err, handler);
      } else {
        // Couldn't reach the server — keep the session and surface the
        // network/timeout error on the *original* request (passing the
        // refresh call's own error on would let RetryInterceptor replay the
        // refresh through the authed client).
        handler.next(err.copyWith(error: mapDioException(refreshError)));
      }
      return;
    }

    await _tokenStore.save(refreshed);
    await _replay(options, refreshed.accessToken, handler);
  }

  Future<void> _replay(
    RequestOptions options,
    String accessToken,
    ErrorInterceptorHandler handler,
  ) async {
    options
      ..headers['Authorization'] = _bearer(accessToken)
      ..extra[_retriedExtraKey] = true;
    try {
      handler.resolve(await _bareDio.fetch<dynamic>(options));
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        _expire(e, handler);
      } else {
        handler.next(e);
      }
    }
  }

  void _expire(DioException err, ErrorInterceptorHandler handler) {
    // Fire-and-forget: the caller must not wait on storage to learn the
    // session is over.
    _tokenStore.clear().ignore();
    _onSessionExpired();
    handler.next(
      err.copyWith(error: const UnauthorizedException('session expired')),
    );
  }
}
