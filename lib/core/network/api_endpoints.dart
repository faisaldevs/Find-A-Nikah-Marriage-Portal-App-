/// Base URL and REST endpoint paths for the backend API.
class ApiEndpoints {
  ApiEndpoints._();

  /// Injected via `--dart-define=API_BASE_URL=...` so dev/staging/prod point
  /// at different servers without code changes.
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:3000/api',
  );

  // ── Auth ──────────────────────────────────────────────────────────
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String refreshToken = '/auth/refresh';
  static const String logout = '/auth/logout';

  /// Paths that must never trigger the 401 → forced-logout flow — a 401 here
  /// means "bad credentials," not "session expired."
  static const List<String> authPaths = [login, register, refreshToken];
}
