import 'package:find_a_nikah/core/core.dart';
import 'package:find_a_nikah/features/auth/domain/entities/auth_status.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// Obtains an identity token from Google / Apple on the device, for the
/// backend to verify. Returns null when the user backs out of the sign-in
/// sheet; throws [DeviceException] when the provider isn't available or
/// misconfigured.
abstract interface class SocialAuthDataSource {
  Future<String?> obtainIdToken(SocialProvider provider);
}

/// Staging/prod until a provider is configured, and Apple until it is built.
class UnconfiguredSocialAuthDataSource implements SocialAuthDataSource {
  const UnconfiguredSocialAuthDataSource();

  @override
  Future<String?> obtainIdToken(SocialProvider provider) async =>
      throw DeviceException('${provider.name} sign-in is not configured');
}

/// Google through the Firebase project's OAuth client: `google_sign_in`
/// (Credential Manager on Android) returns a Google ID token whose audience
/// is the project's web client — the backend must verify against that.
/// Apple is not built yet (it is hidden in the UI).
class GoogleSocialAuthDataSource implements SocialAuthDataSource {
  GoogleSocialAuthDataSource([GoogleSignIn? google])
    : _google = google ?? GoogleSignIn.instance;

  final GoogleSignIn _google;
  bool _ready = false;

  @override
  Future<String?> obtainIdToken(SocialProvider provider) async {
    if (provider != SocialProvider.google) {
      throw DeviceException('${provider.name} sign-in is not available yet');
    }
    try {
      if (!_ready) {
        // Android reads the web client id from google-services.json
        // (`default_web_client_id`); nothing to pass here.
        await _google.initialize();
        _ready = true;
      }
      final account = await _google.authenticate();
      final idToken = account.authentication.idToken;
      if (idToken == null) {
        throw DeviceException('google returned no id token');
      }
      return idToken;
    } on GoogleSignInException catch (e) {
      return switch (e.code) {
        GoogleSignInExceptionCode.canceled ||
        GoogleSignInExceptionCode.interrupted => null,
        _ => throw DeviceException('google sign-in failed: ${e.code.name}'),
      };
    }
  }
}
