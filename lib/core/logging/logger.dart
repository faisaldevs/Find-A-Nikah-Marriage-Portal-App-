import 'package:find_a_nikah/core/error/failure.dart' show Failure;

/// App-wide logging interface. The implementation decides where entries go
/// (console in debug, crash-reporting breadcrumbs in release).
///
/// Never log names, contact details, user content, tokens or precise
/// location — log ids and counts instead.
abstract interface class Logger {
  void debug(String message);
  void info(String message);
  void warning(String message, [Object? error, StackTrace? stackTrace]);
  void error(String message, Object error, StackTrace stackTrace);
}

/// Sends errors to crash reporting. The vendor (Crashlytics, Sentry, …) sits
/// behind this interface so it can be swapped without touching callers.
abstract interface class ErrorReporter {
  /// Records [error]. [fatal] errors crashed the app; non-fatal ones were
  /// caught and turned into a [Failure] or an error state.
  Future<void> record(
    Object error,
    StackTrace stackTrace, {
    bool fatal = false,
    String? reason,
  });

  /// Anonymous id attached to subsequent reports (never an email or name).
  /// Null clears it, e.g. on sign-out.
  Future<void> setUserId(String? anonymousId);
}
