import 'package:find_a_nikah/core/core.dart';
import 'package:find_a_nikah/features/auth/domain/entities/auth_status.dart';

/// Authentication, sign-up and account verification (email code, phone OTP).
///
/// Decisions register #7: own backend, access + refresh tokens; social
/// sign-in goes through the same repository.
abstract interface class AuthRepository {
  /// Current status first, then every change. Never errors.
  Stream<AuthStatus> watchStatus();

  AuthStatus get currentStatus;

  /// Reads stored credentials, refreshes onboarding completion from the
  /// authenticated status endpoint, then emits `authenticated` or
  /// `unauthenticated`. Called once at app start.
  Future<void> restoreSession();

  /// Fails with `ValidationFailure` / `NotFoundFailure` on bad credentials.
  Future<Either<Failure, Unit>> signInWithEmail({
    required String email,
    required String password,
  });

  Future<Either<Failure, Unit>> signInWithSocial(SocialProvider provider);

  /// Sign-up step 1: emails a one-time code to [email].
  Future<Either<Failure, Unit>> requestSignUpCode(String email);

  /// Sign-up step 2: checks the emailed code.
  Future<Either<Failure, Unit>> verifySignUpCode({
    required String email,
    required String code,
  });

  /// Sign-up step 3: creates the account and starts a session whose
  /// onboarding is still incomplete.
  Future<Either<Failure, Unit>> register({
    required String email,
    required String password,
  });

  /// Sends a one-time code to [phoneNumber] (E.164) over WhatsApp/SMS.
  Future<Either<Failure, Unit>> requestPhoneCode(String phoneNumber);

  Future<Either<Failure, Unit>> verifyPhoneCode({
    required String phoneNumber,
    required String code,
  });

  /// Marks onboarding done ("Discover profiles") and confirms completion
  /// with the onboarding status endpoint before the router enters the app.
  Future<Either<Failure, Unit>> completeOnboarding();

  /// Sign-out step 1: revokes the refresh token server-side. Best effort —
  /// never fails, because sign-out must work offline.
  Future<void> revokeServerSession();

  /// Sign-out step 3: deletes credentials from secure storage.
  Future<void> deleteCredentials();

  /// Sign-out step 5: emits `unauthenticated` so the router navigates to
  /// the signed-out route, then consumes the one-shot "has signed in"
  /// flag — awaited so a logout immediately followed by the app closing
  /// can't leave it unconsumed.
  Future<void> markSignedOut();
}
