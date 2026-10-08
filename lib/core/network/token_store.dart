import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Access + refresh token pair issued by the backend.
@immutable
class AuthTokens {
  const AuthTokens({required this.accessToken, required this.refreshToken});

  final String accessToken;
  final String refreshToken;

  @override
  bool operator ==(Object other) =>
      other is AuthTokens &&
      other.accessToken == accessToken &&
      other.refreshToken == refreshToken;

  @override
  int get hashCode => Object.hash(accessToken, refreshToken);

  /// Never prints the tokens themselves.
  @override
  String toString() => 'AuthTokens(<redacted>)';
}

/// Where tokens live. Implemented on top of `flutter_secure_storage`
/// (Keychain / Keystore) — never SharedPreferences, a database, or logs.
abstract interface class TokenStore {
  Future<AuthTokens?> read();
  Future<void> save(AuthTokens tokens);
  Future<void> clear();
}

/// Exchanges a refresh token for a new pair using [bareDio] — a Dio with no
/// auth interceptor, so a failing refresh can never trigger another refresh.
///
/// Throws a [DioException] if the backend rejects the refresh token.
typedef TokenRefresher =
    Future<AuthTokens> Function(Dio bareDio, String refreshToken);
