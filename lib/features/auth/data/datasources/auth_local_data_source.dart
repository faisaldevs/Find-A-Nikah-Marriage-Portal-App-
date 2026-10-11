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
  static const _resumeStepKey = 'auth.resume_step';
  static const _phoneVerifiedKey = 'auth.phone_verified';

  /// Survives [clear] (logout/expiry only wipe tokens, not this) — tells a
  /// fresh install apart from a returning signed-out user. [forgetPriorSession]
  /// consumes it the moment the one-shot login screen is shown.
  static const _hasSignedInKey = 'auth.has_signed_in';

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
  Future<
    ({
      String userId,
      bool onboardingComplete,
      int resumeStep,
      bool isPhoneVerified,
    })?
  >
  readSession() async {
    final userId = await _guard(() => _storage.read(key: _userIdKey));
    if (userId == null) return null;
    final onboarding = await _guard(() => _storage.read(key: _onboardingKey));
    final resumeStep = await _guard(() => _storage.read(key: _resumeStepKey));
    final phoneVerified = await _guard(
      () => _storage.read(key: _phoneVerifiedKey),
    );
    return (
      userId: userId,
      onboardingComplete: onboarding == 'true',
      resumeStep: int.tryParse(resumeStep ?? '') ?? 4,
      isPhoneVerified: phoneVerified == 'true',
    );
  }

  Future<void> saveSession({
    required String userId,
    required bool onboardingComplete,
    required int resumeStep,
    required bool isPhoneVerified,
  }) async {
    await _guard(() => _storage.write(key: _userIdKey, value: userId));
    await _guard(
      () => _storage.write(key: _onboardingKey, value: '$onboardingComplete'),
    );
    await _guard(
      () => _storage.write(key: _resumeStepKey, value: '$resumeStep'),
    );
    await _guard(
      () => _storage.write(key: _phoneVerifiedKey, value: '$isPhoneVerified'),
    );
    await _guard(() => _storage.write(key: _hasSignedInKey, value: 'true'));
  }

  /// Whether this device has ever completed a sign-in, even if the current
  /// tokens were since cleared by [clear].
  Future<bool> hasSignedInBefore() async =>
      await _guard(() => _storage.read(key: _hasSignedInKey)) == 'true';

  /// Consumes the "has signed in before" flag — called once the one-shot
  /// "log in again" screen (logout or expiry) has been shown, so the next
  /// cold start with no new sign-in is treated as a fresh install again.
  Future<void> forgetPriorSession() async =>
      _guard(() => _storage.delete(key: _hasSignedInKey));

  /// Removes tokens and session metadata. [_hasSignedInKey] is deliberately
  /// not cleared here — it must outlive logout.
  @override
  Future<void> clear() async {
    _cached = null;
    _loaded = true;
    for (final key in [
      _accessKey,
      _refreshKey,
      _userIdKey,
      _onboardingKey,
      _resumeStepKey,
      _phoneVerifiedKey,
    ]) {
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
