import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:find_a_nikah/core/core.dart';
import 'package:find_a_nikah/features/auth/domain/domain.dart';
import 'package:find_a_nikah/features/auth/presentation/presentation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/fakes.dart';

const _member = AuthStatus.authenticated(
  UserSession(userId: 'u1', onboardingComplete: true),
);

Future<Either<Failure, Unit>> _ok() async => right(unit);
Future<Either<Failure, Unit>> _fail(Failure f) async => left(f);

void main() {
  late MockAuthRepository repo;

  setUpAll(() => registerFallbackValue(SocialProvider.google));
  setUp(() => repo = MockAuthRepository());

  group('AuthBloc', () {
    late StreamController<AuthStatus> statuses;
    late MockSessionLifecycle session;

    setUp(() {
      statuses = StreamController<AuthStatus>();
      session = MockSessionLifecycle();
      when(() => repo.watchStatus()).thenAnswer((_) => statuses.stream);
      when(() => repo.restoreSession()).thenAnswer((_) async {
        statuses.add(_member);
      });
    });

    blocTest<AuthBloc, AuthStatus>(
      'restores the stored session and follows status changes',
      build: () => AuthBloc(repo, SignOut(repo, session)),
      act: (bloc) async {
        bloc.add(const AuthStatusSubscriptionRequested());
        await Future<void>.delayed(Duration.zero);
        statuses.add(const AuthStatus.unauthenticated());
      },
      expect: () => [_member, const AuthStatus.unauthenticated()],
      verify: (_) => verify(() => repo.restoreSession()).called(1),
    );

    blocTest<AuthBloc, AuthStatus>(
      'sign-out runs the SignOut use case once, even when tapped twice',
      setUp: () {
        when(repo.revokeServerSession).thenAnswer((_) async {});
        when(repo.deleteCredentials).thenAnswer((_) async {});
        when(repo.markSignedOut).thenAnswer((_) async {});
        when(session.closeConnections).thenAnswer((_) async {});
        when(session.end).thenAnswer((_) async {});
      },
      build: () => AuthBloc(repo, SignOut(repo, session)),
      act: (bloc) => bloc
        ..add(const AuthSignOutRequested())
        ..add(const AuthSignOutRequested()),
      verify: (_) {
        verify(repo.deleteCredentials).called(1);
        verify(session.end).called(1);
      },
    );
  });

  group('SignInBloc', () {
    setUp(() {
      when(
        () => repo.currentStatus,
      ).thenReturn(const AuthStatus.unauthenticated());
    });

    blocTest<SignInBloc, SignInState>(
      'email sign-in: submitting → idle on success, trimmed email',
      setUp: () => when(
        () => repo.signInWithEmail(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) => _ok()),
      build: () => SignInBloc(repo),
      act: (bloc) => bloc.add(
        const SignInEmailSubmitted(email: ' a@b.co ', password: 'pw'),
      ),
      expect: () => [
        const SignInState(status: SignInStatus.submitting),
        const SignInState(status: SignInStatus.success),
      ],
      verify: (_) => verify(
        () => repo.signInWithEmail(email: 'a@b.co', password: 'pw'),
      ).called(1),
    );

    blocTest<SignInBloc, SignInState>(
      'failure carries the Failure for the listener',
      setUp: () => when(
        () => repo.signInWithSocial(any()),
      ).thenAnswer((_) => _fail(const NetworkFailure())),
      build: () => SignInBloc(repo),
      act: (bloc) =>
          bloc.add(const SignInSocialRequested(SocialProvider.apple)),
      expect: () => [
        const SignInState(status: SignInStatus.submitting),
        const SignInState(
          status: SignInStatus.failure,
          failure: NetworkFailure(),
        ),
      ],
    );

    blocTest<SignInBloc, SignInState>(
      "a brand-new account (hasn't started the wizard) is flagged new",
      setUp: () {
        when(() => repo.currentStatus).thenReturn(
          const AuthStatus.authenticated(
            UserSession(userId: 'u1', onboardingComplete: false),
          ),
        );
        when(
          () => repo.signInWithEmail(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) => _ok());
      },
      build: () => SignInBloc(repo),
      act: (bloc) =>
          bloc.add(const SignInEmailSubmitted(email: 'a@b.co', password: 'pw')),
      expect: () => [
        const SignInState(status: SignInStatus.submitting),
        const SignInState(status: SignInStatus.success, isNewAccount: true),
      ],
    );

    blocTest<SignInBloc, SignInState>(
      'a returning, mid-wizard account is NOT flagged new (router moves it on)',
      setUp: () {
        when(() => repo.currentStatus).thenReturn(
          const AuthStatus.authenticated(
            UserSession(
              userId: 'u1',
              onboardingComplete: false,
              resumeStep: 8,
            ),
          ),
        );
        when(
          () => repo.signInWithEmail(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) => _ok());
      },
      build: () => SignInBloc(repo),
      act: (bloc) =>
          bloc.add(const SignInEmailSubmitted(email: 'a@b.co', password: 'pw')),
      expect: () => [
        const SignInState(status: SignInStatus.submitting),
        const SignInState(status: SignInStatus.success),
      ],
    );

    blocTest<SignInBloc, SignInState>(
      'double-tapping a submit button signs in once (droppable)',
      setUp: () =>
          when(
            () => repo.signInWithEmail(
              email: any(named: 'email'),
              password: any(named: 'password'),
            ),
          ).thenAnswer(
            (_) => Future.delayed(const Duration(milliseconds: 20), _ok),
          ),
      wait: const Duration(milliseconds: 50),
      build: () => SignInBloc(repo),
      act: (bloc) => bloc
        ..add(const SignInEmailSubmitted(email: 'a@b.co', password: 'pw'))
        ..add(const SignInEmailSubmitted(email: 'a@b.co', password: 'pw')),
      verify: (_) => verify(
        () => repo.signInWithEmail(email: 'a@b.co', password: 'pw'),
      ).called(1),
    );
  });

  group('SignUpBloc', () {
    blocTest<SignUpBloc, SignUpState>(
      'email → code → password, carrying the email between steps',
      setUp: () {
        when(() => repo.requestSignUpCode(any())).thenAnswer((_) => _ok());
        when(
          () => repo.verifySignUpCode(
            email: any(named: 'email'),
            code: any(named: 'code'),
          ),
        ).thenAnswer((_) => _ok());
        when(
          () => repo.register(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) => _ok());
      },
      build: () => SignUpBloc(repo),
      act: (bloc) async {
        bloc.add(const SignUpEmailSubmitted(' a@b.co'));
        await Future<void>.delayed(Duration.zero);
        bloc.add(const SignUpCodeSubmitted('123456'));
        await Future<void>.delayed(Duration.zero);
        bloc.add(const SignUpPasswordSubmitted('abcdefg1'));
      },
      expect: () => [
        const SignUpState(email: 'a@b.co'),
        const SignUpState(
          email: 'a@b.co',
          status: SignUpStatus.submitting,
          operation: SignUpOperation.requestCode,
        ),
        const SignUpState(
          email: 'a@b.co',
          status: SignUpStatus.codeSent,
          operation: SignUpOperation.requestCode,
        ),
        const SignUpState(
          email: 'a@b.co',
          status: SignUpStatus.submitting,
          operation: SignUpOperation.verifyCode,
        ),
        const SignUpState(
          email: 'a@b.co',
          status: SignUpStatus.emailVerified,
          operation: SignUpOperation.verifyCode,
        ),
        const SignUpState(
          email: 'a@b.co',
          status: SignUpStatus.submitting,
          operation: SignUpOperation.createAccount,
        ),
        const SignUpState(
          email: 'a@b.co',
          status: SignUpStatus.registered,
          operation: SignUpOperation.createAccount,
        ),
      ],
      verify: (_) {
        verify(
          () => repo.verifySignUpCode(email: 'a@b.co', code: '123456'),
        ).called(1);
        verify(
          () => repo.register(email: 'a@b.co', password: 'abcdefg1'),
        ).called(1);
      },
    );

    blocTest<SignUpBloc, SignUpState>(
      'a rejected code reports a failure and stays on the step',
      seed: () => const SignUpState(email: 'a@b.co'),
      setUp: () => when(
        () => repo.verifySignUpCode(
          email: any(named: 'email'),
          code: any(named: 'code'),
        ),
      ).thenAnswer((_) => _fail(const ValidationFailure({'code': 'invalid'}))),
      build: () => SignUpBloc(repo),
      act: (bloc) => bloc.add(const SignUpCodeSubmitted('000000')),
      expect: () => [
        const SignUpState(
          email: 'a@b.co',
          status: SignUpStatus.submitting,
          operation: SignUpOperation.verifyCode,
        ),
        const SignUpState(
          email: 'a@b.co',
          status: SignUpStatus.failure,
          operation: SignUpOperation.verifyCode,
          failure: ValidationFailure({'code': 'invalid'}),
        ),
      ],
    );

    blocTest<SignUpBloc, SignUpState>(
      'duplicate verification submissions are dropped while a request is running',
      setUp: () =>
          when(
            () => repo.verifySignUpCode(
              email: any(named: 'email'),
              code: any(named: 'code'),
            ),
          ).thenAnswer(
            (_) => Future.delayed(const Duration(milliseconds: 20), _ok),
          ),
      seed: () => const SignUpState(email: 'a@b.co'),
      wait: const Duration(milliseconds: 50),
      build: () => SignUpBloc(repo),
      act: (bloc) => bloc
        ..add(const SignUpCodeSubmitted('123456'))
        ..add(const SignUpCodeSubmitted('123456')),
      verify: (_) => verify(
        () => repo.verifySignUpCode(email: 'a@b.co', code: '123456'),
      ).called(1),
    );
  });

  group('PhoneVerificationBloc', () {
    blocTest<PhoneVerificationBloc, PhoneVerificationState>(
      'number → code sent → verified',
      setUp: () {
        when(
          () => repo.requestPhoneCode(any()),
        ).thenAnswer((_) async => right('715208'));
        when(
          () => repo.verifyPhoneCode(
            phoneNumber: any(named: 'phoneNumber'),
            code: any(named: 'code'),
          ),
        ).thenAnswer((_) => _ok());
      },
      build: () => PhoneVerificationBloc(repo),
      act: (bloc) async {
        bloc.add(const PhoneNumberSubmitted('+8801700000000'));
        await Future<void>.delayed(Duration.zero);
        bloc.add(const PhoneCodeSubmitted('123456'));
      },
      skip: 2,
      expect: () => [
        const PhoneVerificationState(
          phoneNumber: '+8801700000000',
          status: PhoneVerificationStatus.codeSent,
          demoCode: '715208',
        ),
        const PhoneVerificationState(
          phoneNumber: '+8801700000000',
          status: PhoneVerificationStatus.submitting,
          demoCode: '715208',
        ),
        const PhoneVerificationState(
          phoneNumber: '+8801700000000',
          status: PhoneVerificationStatus.verified,
          demoCode: '715208',
        ),
      ],
      verify: (_) => verify(
        () => repo.verifyPhoneCode(
          phoneNumber: '+8801700000000',
          code: '123456',
        ),
      ).called(1),
    );

    blocTest<PhoneVerificationBloc, PhoneVerificationState>(
      'resend asks for a new code for the same number',
      seed: () => const PhoneVerificationState(
        phoneNumber: '+8801700000000',
        status: PhoneVerificationStatus.codeSent,
      ),
      setUp: () => when(
        () => repo.requestPhoneCode(any()),
      ).thenAnswer((_) async => right(null)),
      build: () => PhoneVerificationBloc(repo),
      act: (bloc) => bloc.add(const PhoneCodeResendRequested()),
      verify: (_) =>
          verify(() => repo.requestPhoneCode('+8801700000000')).called(1),
    );
  });
}
