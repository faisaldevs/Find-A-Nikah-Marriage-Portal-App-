import 'package:find_a_nikah/core/logging/logger.dart';

/// [ErrorReporter] used until a crash-reporting vendor is chosen. Writes
/// every error to the [Logger] so nothing is swallowed silently.
///
/// Swap for a Crashlytics/Sentry implementation in `lib/app/di.dart` —
/// callers only see [ErrorReporter].
class LogErrorReporter implements ErrorReporter {
  LogErrorReporter(this._logger);

  final Logger _logger;
  String? _userId;

  @override
  Future<void> record(
    Object error,
    StackTrace stackTrace, {
    bool fatal = false,
    String? reason,
  }) async {
    _logger.error(
      '${fatal ? 'FATAL' : 'non-fatal'}'
      '${reason == null ? '' : ' ($reason)'}'
      '${_userId == null ? '' : ' user=$_userId'}',
      error,
      stackTrace,
    );
  }

  @override
  Future<void> setUserId(String? anonymousId) async => _userId = anonymousId;
}
