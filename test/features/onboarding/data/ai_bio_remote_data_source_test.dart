import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:find_a_nikah/core/network/interceptors/auth_interceptor.dart';
import 'package:find_a_nikah/core/network/network.dart';
import 'package:find_a_nikah/features/onboarding/data/datasources/ai_bio_remote_data_source.dart';
import 'package:flutter_test/flutter_test.dart';

class _MemoryTokenStore implements TokenStore {
  AuthTokens? tokens = const AuthTokens(
    accessToken: 'test-access-token',
    refreshToken: 'test-refresh-token',
  );

  @override
  Future<void> clear() async => tokens = null;

  @override
  Future<AuthTokens?> read() async => tokens;

  @override
  Future<void> save(AuthTokens tokens) async => this.tokens = tokens;
}

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
          'bio': 'Generated bio',
          'options': [
            {
              'tone': 'balanced',
              'title': 'Balanced & Engaging',
              'bio': 'Generated bio',
            },
          ],
          'source': 'heuristic',
        },
        'message': 'AI bio generated successfully',
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
    'calls the authenticated endpoint and parses the bio response',
    () async {
      final adapter = _RecordingAdapter();
      final bareDio = Dio();
      final tokenStore = _MemoryTokenStore();
      final dio = Dio(BaseOptions(baseUrl: 'https://api.example.test/api'))
        ..httpClientAdapter = adapter
        ..interceptors.add(
          AuthInterceptor(
            tokenStore: tokenStore,
            refreshTokens: (_, _) async =>
                throw StateError('Unexpected refresh'),
            bareDio: bareDio,
            onSessionExpired: () {},
          ),
        );

      final response = await AiBioRemoteDataSource(dio).generateBio();

      expect(response.data.bio, 'Generated bio');
      expect(response.data.options.single.title, 'Balanced & Engaging');
      expect(adapter.request?.method, 'GET');
      expect(adapter.request?.uri.path, '/api/v1/onboarding/ai-bio');
      expect(
        adapter.request?.headers['Authorization'],
        ['Bearer', 'test-access-token'].join(' '),
      );
    },
  );
}
