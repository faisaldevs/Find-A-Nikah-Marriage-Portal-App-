import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:find_a_nikah/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:flutter_test/flutter_test.dart';

class _RecordingAdapter implements HttpClientAdapter {
  RequestOptions? request;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    request = options;
    return ResponseBody.fromString(
      jsonEncode({
        'statusCode': 200,
        'data': {
          'user': {'isOnboardingComplete': false},
          'profile': {'isOnboardingCompleted': false},
          'currentStep': 23,
          'isCompleted': false,
        },
        'message': 'Onboarding status',
        'success': true,
      }),
      200,
      headers: {
        Headers.contentTypeHeader: ['application/json'],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  test(
    'gets onboarding status without a request body',
    () async {
      final adapter = _RecordingAdapter();
      final dio = Dio(
        BaseOptions(baseUrl: 'https://api.example.test/api/v1'),
      )..httpClientAdapter = adapter;

      final response = await AuthRemoteDataSource(
        dio,
      ).fetchOnboardingStatus();

      expect(adapter.request?.method, 'GET');
      expect(adapter.request?.uri.path, '/api/v1/onboarding/status');
      expect(adapter.request?.data, isNull);
      expect(response.data.isCompleted, isFalse);
    },
  );
}
