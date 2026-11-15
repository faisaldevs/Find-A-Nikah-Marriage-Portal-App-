import 'package:bloc_test/bloc_test.dart';
import 'package:find_a_nikah/core/core.dart';
import 'package:find_a_nikah/features/auth/presentation/bloc/forgot_password_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/fakes.dart';

void main() {
  late MockAuthRepository repo;

  setUp(() => repo = MockAuthRepository());

  group('request code', () {
    blocTest<ForgotPasswordCubit, ForgotPasswordState>(
      'trims the email and moves to codeSent',
      build: () {
        when(
          () => repo.requestPasswordReset('a@b.co'),
        ).thenAnswer((_) async => right(unit));
        return ForgotPasswordCubit(repo);
      },
      act: (c) => c.requestCode('  a@b.co '),
      expect: () => const [
        ForgotPasswordState(
          email: 'a@b.co',
          status: ForgotPasswordStatus.submitting,
        ),
        ForgotPasswordState(
          email: 'a@b.co',
          status: ForgotPasswordStatus.codeSent,
        ),
      ],
    );

    blocTest<ForgotPasswordCubit, ForgotPasswordState>(
      'a failure is kept for the toast',
      build: () {
        when(
          () => repo.requestPasswordReset(any()),
        ).thenAnswer((_) async => left(const NetworkFailure()));
        return ForgotPasswordCubit(repo);
      },
      act: (c) => c.requestCode('a@b.co'),
      verify: (c) {
        expect(c.state.status, ForgotPasswordStatus.failure);
        expect(c.state.failure, isA<NetworkFailure>());
        expect(c.state.email, 'a@b.co');
      },
    );
  });

  group('reset password', () {
    blocTest<ForgotPasswordCubit, ForgotPasswordState>(
      'sends the remembered email, the code and the new password',
      build: () {
        when(
          () => repo.requestPasswordReset(any()),
        ).thenAnswer((_) async => right(unit));
        when(
          () => repo.resetPassword(
            email: any(named: 'email'),
            code: any(named: 'code'),
            newPassword: any(named: 'newPassword'),
          ),
        ).thenAnswer((_) async => right(unit));
        return ForgotPasswordCubit(repo);
      },
      act: (c) async {
        await c.requestCode('a@b.co');
        await c.resetPassword(code: '123456', newPassword: 'Newpass123');
      },
      verify: (c) {
        expect(c.state.status, ForgotPasswordStatus.done);
        verify(
          () => repo.resetPassword(
            email: 'a@b.co',
            code: '123456',
            newPassword: 'Newpass123',
          ),
        ).called(1);
      },
    );

    blocTest<ForgotPasswordCubit, ForgotPasswordState>(
      'a wrong code stays on the page with the failure',
      build: () {
        when(
          () => repo.resetPassword(
            email: any(named: 'email'),
            code: any(named: 'code'),
            newPassword: any(named: 'newPassword'),
          ),
        ).thenAnswer(
          (_) async => left(
            const ApiResponseFailure(
              fallback: ValidationFailure({}),
              message: 'Invalid or expired code',
            ),
          ),
        );
        return ForgotPasswordCubit(repo);
      },
      act: (c) => c.resetPassword(code: '000000', newPassword: 'Newpass123'),
      verify: (c) {
        expect(c.state.status, ForgotPasswordStatus.failure);
        expect((c.state.failure! as ApiResponseFailure).message, isNotEmpty);
      },
    );
  });
}
