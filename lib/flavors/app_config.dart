import 'package:freezed_annotation/freezed_annotation.dart';

enum Flavors { dev, uat, prod }

@immutable
class AppConfig {
  const AppConfig({
    required this.flavors,
    required this.apiBaseUrl,
    required this.imageBaseUrl,
    this.authApiBaseUrl,
    this.socketUrl,
  });

  factory AppConfig.fromEnvironment(Flavors expected) {
    const flavorName = String.fromEnvironment('FLAVOR');
    const apiBaseUrl = String.fromEnvironment('API_BASE_URL');
    const imageBaseUrl = String.fromEnvironment('IMAGE_BASE_URL');
    const authApiBaseUrl = String.fromEnvironment('AUTH_API_BASE_URL');
    const socketUrl = String.fromEnvironment('SOCKET_URL');

    if (flavorName.isEmpty || apiBaseUrl.isEmpty) {
      throw StateError(
        'Missing config. Run with '
        '--dart-define-from-file=lib/flavors/env/${expected.name}.json',
      );
    }
    if (flavorName != expected.name) {
      throw StateError(
        'Entry point is ${expected.name} but config/$flavorName.json was '
        'passed.',
      );
    }

    final config = AppConfig(
      flavors: expected,
      apiBaseUrl: apiBaseUrl,
      // Server root that `/public/upload/...` image paths hang off — the API
      // base without its `/api` suffix when not set explicitly.
      imageBaseUrl: imageBaseUrl.isNotEmpty
          ? imageBaseUrl
          : apiBaseUrl.replaceFirst(RegExp(r'/api/?$'), ''),
      authApiBaseUrl: authApiBaseUrl.isEmpty ? null : authApiBaseUrl,
      socketUrl: socketUrl,
    );
    if (expected != Flavors.dev) config._assertHttps();
    return config;
  }

  final Flavors flavors;
  final String apiBaseUrl;

  /// Prefix for server-relative image paths (`/public/upload/x.jpg`).
  final String imageBaseUrl;
  final String? authApiBaseUrl;
  final String? socketUrl;

  /// HTTPS/TLS only outside dev (security baseline).
  void _assertHttps() {
    final authUrl = authApiBaseUrl;
    for (final url in [apiBaseUrl, imageBaseUrl, ?authUrl]) {
      if (!url.startsWith('https://')) {
        throw StateError('Non-dev flavors must use https: $url');
      }
    }
  }
}
