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

    /// Mirrors the onboarding-status API's `currentStep` — which wizard
    /// section to resume into. See `resumeRouteFor` in `app_router.dart`.
    @Default(4) int resumeStep,

    /// Mirrors `user.isPhoneVerified` — once true, `resumeRouteFor` never
    /// routes back to the phone step (it's locked; change it from
    /// Settings instead).
    @Default(false) bool isPhoneVerified,
  }) = _UserSession;
}

/// Where the app stands on authentication. The router's redirect guards
/// routes on this; the session DI scope opens and closes with it.
@freezed
sealed class AuthStatus with _$AuthStatus {
  /// Stored credentials haven't been read yet (app start).
  const factory AuthStatus.unknown() = AuthUnknown;

  const factory AuthStatus.authenticated(UserSession session) = Authenticated;

  const factory AuthStatus.unauthenticated({
    @Default(SignedOutReason.freshInstall) SignedOutReason reason,
  }) = Unauthenticated;
}

/// Why the app is signed out — the splash screen's one-shot redirect reads
/// this. [freshInstall] (never signed in on this device, or the one-shot
/// below has already been shown and not followed by a new sign-in) goes to
/// the intro carousel; [loggedOut] / [sessionExpired] skip it, straight to
/// login with a toast — but only once: the repository consumes this
/// device's "has signed in" flag the moment either fires, so a reopen
/// without signing back in sees [freshInstall] again.
enum SignedOutReason { freshInstall, loggedOut, sessionExpired }

/// Third-party identity providers offered on the welcome and login screens.
enum SocialProvider { google, apple }
