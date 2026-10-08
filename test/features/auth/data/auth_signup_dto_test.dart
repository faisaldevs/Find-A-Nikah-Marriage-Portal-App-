import 'package:find_a_nikah/features/auth/data/dtos/auth_dtos.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('signup request includes the password confirmation', () {
    expect(
      const EmailPasswordRequestDto(
        email: 'user@example.com',
        password: 'Pass1234',
        confirmPassword: 'Pass1234',
      ).toJson(),
      {
        'email': 'user@example.com',
        'password': 'Pass1234',
        'confirmPassword': 'Pass1234',
      },
    );
  });

  test('signup account envelope maps to the stored session shape', () {
    final response = AuthApiSessionResponseDto.fromJson({
      'statusCode': 201,
      'data': {
        'user': {
          '_id': 'user-id',
          'email': 'user@example.com',
          'fullName': 'Test User',
          'onboardingStep': 6,
          'isOnboardingComplete': false,
        },
        'accessToken': 'access-token',
        'refreshToken': 'refresh-token',
      },
      'message': 'Account created',
      'success': true,
    });

    final session = response.toAuthSession();
    expect(session.accessToken, 'access-token');
    expect(session.refreshToken, 'refresh-token');
    expect(session.userId, 'user-id');
    expect(session.onboardingComplete, isFalse);
  });
}
