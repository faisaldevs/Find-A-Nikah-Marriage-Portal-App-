import 'dart:async';

import 'package:find_a_nikah/core/core.dart';
import 'package:find_a_nikah/core/network/network.dart';
import 'package:find_a_nikah/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:find_a_nikah/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:find_a_nikah/features/auth/data/datasources/session_expiry_signal.dart';
import 'package:find_a_nikah/features/auth/data/datasources/social_auth_data_source.dart';
import 'package:find_a_nikah/features/auth/data/dtos/auth_dtos.dart';
import 'package:find_a_nikah/features/auth/domain/entities/auth_status.dart';
import 'package:find_a_nikah/features/auth/domain/repositories/auth_repository.dart';

/// Write policy: online only — every auth call needs the server's answer
/// before anything is stored locally (decisions register #8).
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required this._remote,
    required this._local,
    required this._social,
    required this._guard,
    required this._logger,
    required SessionExpirySignal sessionExpiry,
  }) {
    _expirySubscription = sessionExpiry.stream.listen(
      (_) => _signOutLocally(SignedOutReason.sessionExpired),
    );
  }

  final AuthRemoteDataSource _remote;
  final AuthLocalDataSource _local;
  final SocialAuthDataSource _social;
  final Guard _guard;
  final Logger _logger;
  late final StreamSubscription<void> _expirySubscription;

  final _controller = StreamController<AuthStatus>.broadcast();
  AuthStatus _status = const AuthStatus.unknown();

  @override
  AuthStatus get currentStatus => _status;

  @override
  Stream<AuthStatus> watchStatus() async* {
    yield _status;
    yield* _controller.stream;
  }

  void _emit(AuthStatus status) {
    if (status == _status) return;
    _status = status;
    _controller.add(status);
  }

  /// Emits the one-shot signed-out status immediately — this must win any
  /// race with a concurrent [restoreSession] that's mid-flight — then
  /// clears the now-dead tokens and consumes the "has signed in" flag, so
  /// a reopen without a new sign-in lands on [SignedOutReason.freshInstall]
  /// (the intro carousel) instead of showing the one-shot login screen
  /// again.
  Future<void> _signOutLocally(SignedOutReason reason) async {
    _emit(AuthStatus.unauthenticated(reason: reason));
    await _guard(_local.clear);
    await _guard(_local.forgetPriorSession);
  }

  @override
  void devSkipToApp() {
    _emit(
      const AuthStatus.authenticated(
        UserSession(userId: 'dev-skip', onboardingComplete: true),
      ),
    );
  }

  @override
  Future<void> restoreSession() async {
    final restored = await _guard(() async {
      final tokens = await _local.read();
      final session = await _local.readSession();
      if (tokens == null || session == null) return null;
      return UserSession(
        userId: session.userId,
        onboardingComplete: session.onboardingComplete,
        resumeStep: session.resumeStep,
        isPhoneVerified: session.isPhoneVerified,
      );
    });
    await restored.fold(
      // Unreadable store: treat as signed out (Guard already reported it).
      (_) async => _emit(const AuthStatus.unauthenticated()),
      (session) async {
        if (session == null) {
          final hadSignedIn = await _guard(_local.hasSignedInBefore);
          _emit(
            AuthStatus.unauthenticated(
              reason: hadSignedIn.fold(
                (_) => SignedOutReason.freshInstall,
                (value) => value
                    ? SignedOutReason.sessionExpired
                    : SignedOutReason.freshInstall,
              ),
            ),
          );
          return;
        }

        final status = await _guard(
          () async => (await _remote.fetchOnboardingStatus()).data,
        );
        final restoredSession = status.fold(
          (failure) {
            // Keep the last known state when offline; the failure is still
            // recorded here instead of silently discarding the status check.
            _logger.warning(
              'Could not refresh onboarding completion status: $failure',
            );
            return session;
          },
          (data) => session.copyWith(
            // onboardingComplete: data.isCompleted,
            onboardingComplete: data.isEffectivelyCompleted,
            // resumeStep: data.currentStep,
            resumeStep: data.resumeStep,
            isPhoneVerified: data.user?.isPhoneVerified ?? false,
          ),
        );
        if (restoredSession != session) {
          final saved = await _guard(
            () => _local.saveSession(
              userId: restoredSession.userId,
              onboardingComplete: restoredSession.onboardingComplete,
              resumeStep: restoredSession.resumeStep,
              isPhoneVerified: restoredSession.isPhoneVerified,
            ),
          );
          saved.fold(
            (failure) => _logger.warning(
              'Could not cache onboarding completion status: $failure',
            ),
            (_) {},
          );
        }
        // Fetching the onboarding status above can 401 → a refresh failure
        // → the expiry signal, which already emitted `unauthenticated`
        // synchronously. Don't clobber that with a stale `authenticated`.
        if (_status is Unauthenticated) return;
        _emit(AuthStatus.authenticated(restoredSession));
      },
    );
  }

  /// Persists tokens + session, then emits `authenticated`.
  Future<Unit> _startSession(AuthSessionDto dto) async {
    await _local.save(
      AuthTokens(accessToken: dto.accessToken, refreshToken: dto.refreshToken),
    );
    var onboardingComplete = dto.onboardingComplete;
    var resumeStep = 4;
    var isPhoneVerified = false;
    final status = await _guard(
      () async => (await _remote.fetchOnboardingStatus()).data,
    );
    status.fold(
      (failure) => _logger.warning(
        'Could not fetch onboarding completion status: $failure',
      ),
      (data) {
        // onboardingComplete = data.isCompleted;
        onboardingComplete = data.isEffectivelyCompleted;
        // resumeStep = data.currentStep;
        resumeStep = data.resumeStep;
        isPhoneVerified = data.user?.isPhoneVerified ?? false;
      },
    );
    await _local.saveSession(
      userId: dto.userId,
      onboardingComplete: onboardingComplete,
      resumeStep: resumeStep,
      isPhoneVerified: isPhoneVerified,
    );
    _emit(
      AuthStatus.authenticated(
        UserSession(
          userId: dto.userId,
          onboardingComplete: onboardingComplete,
          resumeStep: resumeStep,
          isPhoneVerified: isPhoneVerified,
        ),
      ),
    );
    return unit;
  }

  @override
  Future<Either<Failure, Unit>> signInWithEmail({
    required String email,
    required String password,
  }) => _guard(
    () async => _startSession(
      (await _remote.login(
        EmailPasswordRequestDto(email: email, password: password),
      )).toAuthSession(),
    ),
  );

  @override
  Future<Either<Failure, Unit>> signInWithSocial(SocialProvider provider) =>
      _guard(() async {
        final idToken = await _social.obtainIdToken(provider);
        return _startSession(
          await _remote.socialSignIn(
            SocialSignInRequestDto(provider: provider.name, idToken: idToken),
          ),
        );
      });

  @override
  Future<Either<Failure, Unit>> requestSignUpCode(String email) => _guard(
    () async {
      await _remote.requestSignUpCode(EmailRequestDto(email: email));
      return unit;
    },
  );

  @override
  Future<Either<Failure, Unit>> verifySignUpCode({
    required String email,
    required String code,
  }) => _guard(() async {
    await _remote.verifySignUpCode(
      EmailCodeRequestDto(email: email, code: code),
    );
    return unit;
  });

  @override
  Future<Either<Failure, Unit>> register({
    required String email,
    required String password,
  }) => _guard(
    () async => _startSession(
      (await _remote.register(
        EmailPasswordRequestDto(
          email: email,
          password: password,
          confirmPassword: password,
        ),
      )).toAuthSession(),
    ),
  );

  @override
  Future<Either<Failure, String?>> requestPhoneCode(String phoneNumber) =>
      _guard(() async {
        final sent = await _remote.requestPhoneCode(
          PhoneRequestDto(phoneNumber: phoneNumber),
        );
        return sent.data?.devCode ?? sent.data?.code;
      });

  @override
  Future<Either<Failure, Unit>> verifyPhoneCode({
    required String phoneNumber,
    required String code,
  }) async {
    final result = await _guard(() async {
      final res = await _remote.verifyPhoneCode(
        PhoneCodeRequestDto(phoneNumber: phoneNumber, code: code),
      );
      final data = res.data;
      // A 2xx without a positive verdict still means "not verified".
      if (data == null || !(data.isPhoneVerified || data.verified)) {
        throw const ValidationException(
          {'code': 'invalid'},
          'That code didn’t work. Please try again.',
        );
      }
      return unit;
    });
    if (result.isLeft()) return result;
    await _markPhoneVerified();
    return result;
  }

  /// Persists + emits the session with `isPhoneVerified: true`. Best
  /// effort: the server already has it, so a storage hiccup isn't surfaced.
  Future<void> _markPhoneVerified() async {
    final current = _status;
    if (current is! Authenticated || current.session.isPhoneVerified) return;
    final session = current.session.copyWith(isPhoneVerified: true);
    final saved = await _guard(
      () => _local.saveSession(
        userId: session.userId,
        onboardingComplete: session.onboardingComplete,
        resumeStep: session.resumeStep,
        isPhoneVerified: true,
      ),
    );
    if (saved.isRight()) _emit(AuthStatus.authenticated(session));
  }

  @override
  Future<Either<Failure, Unit>> completeOnboarding() async {
    final result = await _guard(() async {
      if (_status is! Authenticated) throw StateError('not signed in');
      await _remote.completeOnboarding();
      return (await _remote.fetchOnboardingStatus()).data.isCompleted;
    });
    return result.fold(
      (failure) async => left(failure),
      (isCompleted) async {
        if (!isCompleted) {
          return left(
            const ApiResponseFailure(
              fallback: ConflictFailure(),
              message: 'The server has not marked onboarding as complete.',
            ),
          );
        }
        final current = _status;
        if (current is! Authenticated) {
          return left(const UnauthorizedFailure());
        }
        final session = current.session.copyWith(onboardingComplete: true);
        final saved = await _guard(
          () => _local.saveSession(
            userId: session.userId,
            onboardingComplete: true,
            resumeStep: session.resumeStep,
            isPhoneVerified: session.isPhoneVerified,
          ),
        );
        return saved.fold(
          left,
          (_) {
            _emit(AuthStatus.authenticated(session));
            return right(unit);
          },
        );
      },
    );
  }

  @override
  Future<Either<Failure, Unit>> markOnboardingCompleteLocally() async {
    final current = _status;
    if (current is! Authenticated) return left(const UnauthorizedFailure());
    final session = current.session.copyWith(
      onboardingComplete: true,
      resumeStep: 12,
    );
    final saved = await _guard(
      () => _local.saveSession(
        userId: session.userId,
        onboardingComplete: true,
        resumeStep: session.resumeStep,
        isPhoneVerified: session.isPhoneVerified,
      ),
    );
    return saved.fold(left, (_) {
      _emit(AuthStatus.authenticated(session));
      return right(unit);
    });
  }

  @override
  Future<void> revokeServerSession() async {
    final tokens = await _local.read().catchError((Object _) => null);
    if (tokens == null) return;
    // Best effort: an offline sign-out still signs out locally.
    await _guard(
      () =>
          _remote.logout(RefreshRequestDto(refreshToken: tokens.refreshToken)),
    );
  }

  @override
  Future<void> deleteCredentials() async {
    await _guard(_local.clear);
  }

  @override
  Future<void> markSignedOut() => _signOutLocally(SignedOutReason.loggedOut);

  /// Test/teardown hook.
  Future<void> dispose() async {
    await _expirySubscription.cancel();
    await _controller.close();
  }
}

/// [TokenRefresher] for `ApiClient`: exchanges the refresh token on the bare
/// Dio and persists the new session metadata.
TokenRefresher authTokenRefresher(AuthLocalDataSource local) =>
    (bareDio, refreshToken) async {
      final dto = await AuthRemoteDataSource(
        bareDio,
      ).refresh(RefreshRequestDto(refreshToken: refreshToken));
      // The refresh response carries no `currentStep`/`isPhoneVerified` —
      // keep whatever was cached rather than resetting the resume point on
      // every silent token refresh.
      final previous = await local.readSession();
      await local.saveSession(
        userId: dto.userId,
        // onboardingComplete: dto.onboardingComplete,
        // The refresh response only has the server flag, which stays false
        // while step 12 is treated as complete client-side — don't let a
        // silent refresh undo that.
        onboardingComplete:
            dto.onboardingComplete || (previous?.onboardingComplete ?? false),
        resumeStep: previous?.resumeStep ?? 4,
        isPhoneVerified: previous?.isPhoneVerified ?? false,
      );
      return AuthTokens(
        accessToken: dto.accessToken,
        refreshToken: dto.refreshToken,
      );
    };
