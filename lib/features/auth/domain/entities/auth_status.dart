import 'package:equatable/equatable.dart';

/// The signed-in user, as far as routing and session scoping care.
class UserSession extends Equatable {
  const UserSession({
    required this.userId,
    required this.onboardingComplete,
    this.resumeStep = 4,
    this.isPhoneVerified = false,
  });

  final String userId;

  /// False right after registration: the profile wizard, verification and
  /// discovery filters still have to be completed before the main app.
  final bool onboardingComplete;

  /// Mirrors the onboarding-status API's `currentStep` — which wizard
  /// section to resume into. See `resumeRouteFor` in `app_router.dart`.
  final int resumeStep;

  /// Mirrors `user.isPhoneVerified` — once true, `resumeRouteFor` never
  /// routes back to the phone step (it's locked; change it from
  /// Settings instead).
  final bool isPhoneVerified;

  UserSession copyWith({
    String? userId,
    bool? onboardingComplete,
    int? resumeStep,
    bool? isPhoneVerified,
  }) {
    return UserSession(
      userId: userId ?? this.userId,
      onboardingComplete: onboardingComplete ?? this.onboardingComplete,
      resumeStep: resumeStep ?? this.resumeStep,
      isPhoneVerified: isPhoneVerified ?? this.isPhoneVerified,
    );
  }

  @override
  List<Object?> get props => [
    userId,
    onboardingComplete,
    resumeStep,
    isPhoneVerified,
  ];
}

/// Where the app stands on authentication. The router's redirect guards
/// routes on this; the session DI scope opens and closes with it.
sealed class AuthStatus extends Equatable {
  const AuthStatus();

  /// Stored credentials haven't been read yet (app start).
  const factory AuthStatus.unknown() = AuthUnknown;

  const factory AuthStatus.authenticated(UserSession session) = Authenticated;

  const factory AuthStatus.unauthenticated({SignedOutReason reason}) =
      Unauthenticated;
}

final class AuthUnknown extends AuthStatus {
  const AuthUnknown();

  @override
  List<Object?> get props => [];
}

final class Authenticated extends AuthStatus {
  const Authenticated(this.session);

  final UserSession session;

  @override
  List<Object?> get props => [session];
}

final class Unauthenticated extends AuthStatus {
  const Unauthenticated({this.reason = SignedOutReason.freshInstall});

  final SignedOutReason reason;

  @override
  List<Object?> get props => [reason];
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
