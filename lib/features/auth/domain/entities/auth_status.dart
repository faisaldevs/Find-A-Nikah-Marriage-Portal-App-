import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_status.freezed.dart';

/// The signed-in user, as far as routing and session scoping care.
@freezed
abstract class UserSession with _$UserSession {
  const factory UserSession({
    required String userId,

    /// False right after registration: the profile wizard, verification and
    /// discovery filters still have to be completed before the main app.
    required bool onboardingComplete,
  }) = _UserSession;
}

/// Where the app stands on authentication. The router's redirect guards
/// routes on this; the session DI scope opens and closes with it.
@freezed
sealed class AuthStatus with _$AuthStatus {
  /// Stored credentials haven't been read yet (app start).
  const factory AuthStatus.unknown() = AuthUnknown;

  const factory AuthStatus.authenticated(UserSession session) = Authenticated;

  const factory AuthStatus.unauthenticated() = Unauthenticated;
}

/// Third-party identity providers offered on the welcome and login screens.
enum SocialProvider { google, apple }
