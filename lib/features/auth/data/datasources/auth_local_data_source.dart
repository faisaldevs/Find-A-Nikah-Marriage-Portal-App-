import 'package:find_a_nikah/core/core.dart';
import 'package:find_a_nikah/core/network/network.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Credentials + session metadata in the Keychain / Keystore.
///
/// Doubles as the [TokenStore] `api_client` reads on every request. Tokens
/// never go to SharedPreferences, a database or logs; iOS items are
/// `..._this_device` so they're excluded from backups.
///
/// Throws [StorageException] when the platform store fails.
class AuthLocalDataSource implements TokenStore {
  AuthLocalDataSource(this._storage);

  final FlutterSecureStorage _storage;

  static const _accessKey = 'auth.access_token';
  static const _refreshKey = 'auth.refresh_token';
  static const _userIdKey = 'auth.user_id';
  static const _onboardingKey = 'auth.onboarding_complete';

  static const iosOptions = IOSOptions(
    accessibility: KeychainAccessibility.first_unlock_this_device,
  );

  /// Cached so the auth interceptor doesn't hit the Keychain per request.
  AuthTokens? _cached;
  bool _loaded = false;

  @override
  Future<AuthTokens?> read() async {
    if (_loaded) return _cached;
    final access = await _guard(() => _storage.read(key: _accessKey));
    final refresh = await _guard(() => _storage.read(key: _refreshKey));
    _cached = access != null && refresh != null
        ? AuthTokens(accessToken: access, refreshToken: refresh)
        : null;
    _loaded = true;
    return _cached;
  }

  @override
  Future<void> save(AuthTokens tokens) async {
    await _guard(
      () => _storage.write(key: _accessKey, value: tokens.accessToken),
    );
    await _guard(
      () => _storage.write(key: _refreshKey, value: tokens.refreshToken),
    );
    _cached = tokens;
    _loaded = true;
  }

  /// Session metadata stored next to the tokens; null when signed out.
  Future<({String userId, bool onboardingComplete})?> readSession() async {
    final userId = await _guard(() => _storage.read(key: _userIdKey));
    if (userId == null) return null;
    final onboarding = await _guard(() => _storage.read(key: _onboardingKey));
    return (userId: userId, onboardingComplete: onboarding == 'true');
  }

  Future<void> saveSession({
    required String userId,
    required bool onboardingComplete,
  }) async {
    await _guard(() => _storage.write(key: _userIdKey, value: userId));
    await _guard(
      () => _storage.write(key: _onboardingKey, value: '$onboardingComplete'),
    );
  }

  /// Removes tokens and session metadata.
  @override
  Future<void> clear() async {
    _cached = null;
    _loaded = true;
    for (final key in [_accessKey, _refreshKey, _userIdKey, _onboardingKey]) {
      await _guard(() => _storage.delete(key: key));
    }
  }

  Future<T> _guard<T>(Future<T> Function() run) async {
    try {
      return await run();
    } on PlatformException catch (e) {
      throw StorageException('secure storage: ${e.code}');
    }
  }
}
