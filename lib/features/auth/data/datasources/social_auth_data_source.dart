import 'package:find_a_nikah/core/core.dart';
import 'package:find_a_nikah/features/auth/domain/entities/auth_status.dart';

/// Obtains an identity token from Google / Apple on the device, for the
/// backend to verify. Throws [DeviceException] when the user cancels or the
/// provider isn't available.
abstract interface class SocialAuthDataSource {
  Future<String> obtainIdToken(SocialProvider provider);
}

/// Staging/prod until `google_sign_in` / `sign_in_with_apple` are added
/// (they need OAuth client ids from the backend team).
class UnconfiguredSocialAuthDataSource implements SocialAuthDataSource {
  const UnconfiguredSocialAuthDataSource();

  @override
  Future<String> obtainIdToken(SocialProvider provider) async =>
      throw DeviceException('${provider.name} sign-in is not configured');
}
