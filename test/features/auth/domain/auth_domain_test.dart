import 'package:find_a_nikah/core/core.dart';
import 'package:find_a_nikah/features/auth/domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/fakes.dart';

void main() {
  group('CredentialsPolicy', () {
    test('email', () {
      expect(CredentialsPolicy.isValidEmail(' a@b.co '), isTrue);
      expect(CredentialsPolicy.isValidEmail('a@b'), isFalse);
      expect(CredentialsPolicy.isValidEmail('a b@c.d'), isFalse);
    });

    test('password needs 8+ chars, a digit and a letter', () {
      expect(CredentialsPolicy.isValidPassword('abcdefg1'), isTrue);
      expect(CredentialsPolicy.isValidPassword('abcdefgh'), isFalse);
      expect(CredentialsPolicy.isValidPassword('12345678'), isFalse);
      expect(CredentialsPolicy.isValidPassword('abc1'), isFalse);
    });

    test('code is exactly 6 digits', () {
      expect(CredentialsPolicy.isValidCode('123456'), isTrue);
      expect(CredentialsPolicy.isValidCode('12345'), isFalse);
      expect(CredentialsPolicy.isValidCode('12345a'), isFalse);
    });
  });

  group('SignOut', () {
    late MockAuthRepository auth;
    late MockSessionLifecycle session;
    final calls = <String>[];

    setUp(() {
      calls.clear();
      auth = MockAuthRepository();
      session = MockSessionLifecycle();
      when(
        auth.revokeServerSession,
      ).thenAnswer((_) async => calls.add('revoke'));
      when(
        session.closeConnections,
      ).thenAnswer((_) async => calls.add('close'));
      when(auth.deleteCredentials).thenAnswer((_) async => calls.add('delete'));
      when(session.end).thenAnswer((_) async => calls.add('end'));
      when(auth.markSignedOut).thenAnswer((_) => calls.add('signedOut'));
    });

    test('runs the guide\'s five steps in order and never fails', () async {
      final result = await SignOut(auth, session)(const NoParams());
      expect(result, right<Failure, Unit>(unit));
      expect(calls, ['revoke', 'close', 'delete', 'end', 'signedOut']);
    });
  });
}
