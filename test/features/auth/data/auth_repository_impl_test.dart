import 'package:dio/dio.dart';
import 'package:find_a_nikah/core/core.dart';
import 'package:find_a_nikah/core/network/network.dart';
import 'package:find_a_nikah/features/auth/data/data.dart';
import 'package:find_a_nikah/features/auth/data/dtos/auth_dtos.dart';
import 'package:find_a_nikah/features/auth/domain/domain.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/fakes.dart';

/// Test-only auth response source with zero latency.
class _Remote implements AuthRemoteDataSource {
  Exception? failWith;
  int logouts = 0;
  bool onboardingComplete = false;
  bool? onboardingStatusOverride;
  int onboardingStatusRequests = 0;

  AuthApiSessionResponseDto _response({required bool onboardingComplete}) =>
      AuthApiSessionResponseDto(
        data: AuthApiSessionDataDto(
          accessToken: 'access-token',
          refreshToken: 'refresh-token',
          user: AuthApiSessionUserDto(
            userId: 'test-user',
            onboardingComplete: onboardingComplete,
          ),
        ),
      );

  Never _reject(String path, int status, Map<String, String> fields) {
    final options = RequestOptions(path: path);
    throw DioException.badResponse(
      statusCode: status,
      requestOptions: options,
      response: Response<dynamic>(
        requestOptions: options,
        statusCode: status,
        data: {'message': 'rejected by test backend', 'errors': fields},
      ),
    );
  }

  Future<T> _maybeFail<T>(Future<T> Function() run) async {
    final error = failWith;
    failWith = null;
    if (error != null) throw error;
    return run();
  }

  @override
  Future<AuthApiSessionResponseDto> login(EmailPasswordRequestDto body) =>
      _maybeFail(() async {
        if (body.password == 'wrongpass') {
          _reject('/auth/login', 422, {
            'password': 'Incorrect email or password.',
          });
        }
        onboardingComplete = true;
        return _response(onboardingComplete: true);
      });

  @override
  Future<AuthApiSessionResponseDto> register(EmailPasswordRequestDto body) =>
      _maybeFail(() async {
        onboardingComplete = false;
        return _response(onboardingComplete: false);
      });

  @override
  Future<void> logout(RefreshRequestDto body) =>
      _maybeFail(() async => logouts++);

  @override
  Future<AuthSessionDto> socialSignIn(SocialSignInRequestDto body) async =>
      throw UnimplementedError();

  @override
  Future<void> requestSignUpCode(EmailRequestDto body) async {}

  @override
  Future<void> verifySignUpCode(EmailCodeRequestDto body) async {}

  @override
  Future<AuthSessionDto> refresh(RefreshRequestDto body) async =>
      throw UnimplementedError();

  @override
  Future<void> requestPhoneCode(PhoneRequestDto body) async {}

  @override
  Future<void> verifyPhoneCode(PhoneCodeRequestDto body) async {}

  @override
  Future<void> completeOnboarding() async {
    onboardingComplete = true;
  }

  @override
  Future<OnboardingStatusResponseDto> fetchOnboardingStatus() async {
    onboardingStatusRequests++;
    return OnboardingStatusResponseDto(
      data: OnboardingStatusDataDto(
        isCompleted: onboardingStatusOverride ?? onboardingComplete,
      ),
    );
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late _Remote remote;
  late AuthLocalDataSource local;
  late SessionExpirySignal expiry;
  late AuthRepositoryImpl repo;

  setUp(() {
    FlutterSecureStorage.setMockInitialValues({});
    remote = _Remote();
    local = AuthLocalDataSource(const FlutterSecureStorage());
    expiry = SessionExpirySignal();
    repo = AuthRepositoryImpl(
      remote: remote,
      local: local,
      social: const UnconfiguredSocialAuthDataSource(),
      guard: testGuard(),
      logger: SilentLogger(),
      sessionExpiry: expiry,
    );
  });

  tearDown(() => repo.dispose());

  test(
    'starts unknown; restore with nothing stored → unauthenticated',
    () async {
      expect(repo.currentStatus, const AuthStatus.unknown());
      await repo.restoreSession();
      expect(repo.currentStatus, const AuthStatus.unauthenticated());
    },
  );

  test('sign in stores tokens + session and emits authenticated', () async {
    final statuses = <AuthStatus>[];
    final sub = repo.watchStatus().listen(statuses.add);

    final result = await repo.signInWithEmail(email: 'a@b.co', password: 'x');

    expect(result.isRight(), isTrue);
    expect(await local.read(), isNotNull);
    expect((await local.readSession())!.onboardingComplete, isTrue);
    await Future<void>.delayed(Duration.zero);
    expect(statuses.last, isA<Authenticated>());
    await sub.cancel();
  });

  test('a stored session is restored on the next start', () async {
    await repo.register(email: 'a@b.co', password: 'abcdefg1');
    final next = AuthRepositoryImpl(
      remote: remote,
      local: AuthLocalDataSource(const FlutterSecureStorage()),
      social: const UnconfiguredSocialAuthDataSource(),
      guard: testGuard(),
      logger: SilentLogger(),
      sessionExpiry: SessionExpirySignal(),
    );
    await next.restoreSession();
    final status = next.currentStatus;
    expect(status, isA<Authenticated>());
    expect((status as Authenticated).session.onboardingComplete, isFalse);
    expect(remote.onboardingStatusRequests, 2);
  });

  test('restore uses the server onboarding completion status', () async {
    await repo.register(email: 'a@b.co', password: 'abcdefg1');
    remote.onboardingStatusOverride = true;

    await repo.restoreSession();

    final status = repo.currentStatus as Authenticated;
    expect(status.session.onboardingComplete, isTrue);
    expect((await local.readSession())!.onboardingComplete, isTrue);
  });

  test('a successful login uses the server onboarding status', () async {
    remote.onboardingStatusOverride = false;

    await repo.signInWithEmail(email: 'a@b.co', password: 'x');

    final status = repo.currentStatus as Authenticated;
    expect(status.session.onboardingComplete, isFalse);
    expect(remote.onboardingStatusRequests, 1);
  });

  test('rejected credentials become a ValidationFailure', () async {
    final result = await repo.signInWithEmail(
      email: 'a@b.co',
      password: 'wrongpass',
    );
    final failure = result.getLeft().toNullable();
    expect(failure, isA<ApiResponseFailure>());
    final responseFailure = failure! as ApiResponseFailure;
    expect(responseFailure.fallback, isA<ValidationFailure>());
    expect(responseFailure.message, 'rejected by test backend');
    expect(repo.currentStatus, isNot(isA<Authenticated>()));
    expect(await local.read(), isNull);
  });

  test('completeOnboarding flips the session flag and persists it', () async {
    await repo.register(email: 'a@b.co', password: 'abcdefg1');
    final result = await repo.completeOnboarding();
    expect(result.isRight(), isTrue);
    expect(remote.onboardingStatusRequests, 2);
    final status = repo.currentStatus as Authenticated;
    expect(status.session.onboardingComplete, isTrue);
    expect((await local.readSession())!.onboardingComplete, isTrue);
  });

  test(
    'completeOnboarding does not finish if server status is incomplete',
    () async {
      await repo.register(email: 'a@b.co', password: 'abcdefg1');
      remote.onboardingStatusOverride = false;

      final result = await repo.completeOnboarding();

      expect(result.isLeft(), isTrue);
      expect(
        (repo.currentStatus as Authenticated).session.onboardingComplete,
        isFalse,
      );
      expect((await local.readSession())!.onboardingComplete, isFalse);
    },
  );

  test('onboarding status DTO reads completion from the data payload', () {
    final status = OnboardingStatusResponseDto.fromJson({
      'statusCode': 200,
      'data': {
        'user': {'isOnboardingComplete': false},
        'currentStep': 23,
        'isCompleted': false,
      },
      'message': 'Onboarding status',
      'success': true,
    });

    expect(status.data.isCompleted, isFalse);
  });

  test('a session expiry from the HTTP stack signs out', () async {
    await repo.signInWithEmail(email: 'a@b.co', password: 'x');
    expiry.notify();
    expect(repo.currentStatus, const AuthStatus.unauthenticated());
  });

  test(
    'sign-out steps: revoke is best effort, delete clears storage',
    () async {
      await repo.signInWithEmail(email: 'a@b.co', password: 'x');
      remote.failWith = const NetworkException();
      await repo.revokeServerSession(); // offline: must not throw
      await repo.deleteCredentials();
      repo.markSignedOut();
      expect(await local.read(), isNull);
      expect(await local.readSession(), isNull);
      expect(repo.currentStatus, const AuthStatus.unauthenticated());
    },
  );

  test('tokens never appear in toString', () async {
    await repo.signInWithEmail(email: 'a@b.co', password: 'x');
    final tokens = (await local.read())!;
    expect('$tokens', isNot(contains(tokens.accessToken)));
    expect(tokens, isA<AuthTokens>());
  });
}
