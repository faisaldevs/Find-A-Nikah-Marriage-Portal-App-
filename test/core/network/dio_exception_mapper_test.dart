import 'package:dio/dio.dart';
import 'package:find_a_nikah/core/error/failure.dart';
import 'package:find_a_nikah/core/network/api_exception.dart';
import 'package:find_a_nikah/core/network/dio_exception_mapper.dart';
import 'package:find_a_nikah/core/ui/text/failure_text.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  DioException responseError({
    required String path,
    required int statusCode,
    Object? data,
  }) {
    final options = RequestOptions(path: path);
    return DioException(
      requestOptions: options,
      response: Response<dynamic>(
        requestOptions: options,
        statusCode: statusCode,
        data: data,
      ),
      type: DioExceptionType.badResponse,
    );
  }

  test('login 401 surfaces the API message, not session-expiry text', () {
    final failure = mapDioException(
      responseError(
        path: '/api/v1/auth/login',
        statusCode: 401,
        data: {
          'success': false,
          'message': 'Invalid credentials',
          'errors': <Object?>[],
        },
      ),
    ).toFailure();

    expect(failure, isA<ApiResponseFailure>());
    expect(failure.title, 'Sign-in failed');
    expect(failure.message, 'Invalid credentials');
  });

  test('login 401 without a message has a credential-specific fallback', () {
    final failure = mapDioException(
      responseError(
        path: '/api/v1/auth/login',
        statusCode: 401,
      ),
    ).toFailure();

    expect(failure, isA<InvalidCredentialsFailure>());
    expect(failure.message, 'Check your email and password.');
  });

  test('server responses preserve their message and status category', () {
    final failure = mapDioException(
      responseError(
        path: '/api/v1/auth/login',
        statusCode: 500,
        data: {'message': 'Service is temporarily unavailable'},
      ),
    ).toFailure();

    expect(failure, isA<ApiResponseFailure>());
    expect(failure.title, 'Something went wrong on our side');
    expect(failure.message, 'Service is temporarily unavailable');
  });

  test('interceptor session expiry remains distinct from login rejection', () {
    expect(
      const UnauthorizedException('session expired').toFailure(),
      isA<SessionExpiredFailure>(),
    );
  });
}
