import 'package:find_a_nikah/core/logging/logger.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

/// Sends errors to Crashlytics and still writes them to the [Logger] (via
/// [_log]), so debug runs keep their console output.
class FirebaseErrorReporter implements ErrorReporter {
  FirebaseErrorReporter(this._log);

  final ErrorReporter _log;

  @override
  Future<void> record(
    Object error,
    StackTrace stackTrace, {
    bool fatal = false,
    String? reason,
  }) async {
    await _log.record(error, stackTrace, fatal: fatal, reason: reason);
    await FirebaseCrashlytics.instance.recordError(
      error,
      stackTrace,
      fatal: fatal,
      reason: reason,
    );
  }

  @override
  Future<void> setUserId(String? anonymousId) async {
    await _log.setUserId(anonymousId);
    await FirebaseCrashlytics.instance.setUserIdentifier(anonymousId ?? '');
  }
}
