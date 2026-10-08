import 'package:find_a_nikah/core/error/app_exception.dart';
import 'package:find_a_nikah/core/error/failure.dart';
import 'package:find_a_nikah/core/logging/logger.dart';
import 'package:fpdart/fpdart.dart';

/// Turns a foreign error (e.g. Dio's `DioException`) into an [AppException],
/// or returns null when it doesn't recognise it.
typedef ExceptionTranslator = AppException? Function(Object error);

/// The one try/catch every repository uses.
///
/// Repositories never hand-write try/catch per method; they wrap the call:
///
/// ```dart
/// Future<Either<Failure, Item>> getItem(String id) =>
///     _guard(() async => (await _remote.getItem(id)).toEntity());
/// ```
///
/// - [AppException] (thrown directly, or produced by an
///   [ExceptionTranslator]) → its own [Failure]. Storage and device
///   exceptions are reported first because they usually point at a bug.
/// - Anything else → reported as non-fatal, returned as [UnknownFailure].
///   The app never crashes on an unexpected repository error.
class Guard {
  const Guard(this._reporter, {this.translators = const []});

  final ErrorReporter _reporter;

  /// Tried in order on any error that isn't already an [AppException].
  final List<ExceptionTranslator> translators;

  Future<Either<Failure, T>> call<T>(Future<T> Function() run) async {
    try {
      return right(await run());
    } on Object catch (error, stackTrace) {
      final appException = error is AppException ? error : _translate(error);
      if (appException == null) {
        await _reporter.record(
          error,
          stackTrace,
          reason: 'unexpected repository error',
        );
        return left(const UnknownFailure());
      }
      if (appException is StorageException || appException is DeviceException) {
        await _reporter.record(appException, stackTrace, reason: 'local');
      }
      return left(appException.toFailure());
    }
  }

  AppException? _translate(Object error) {
    for (final translate in translators) {
      final translated = translate(error);
      if (translated != null) return translated;
    }
    return null;
  }
}
