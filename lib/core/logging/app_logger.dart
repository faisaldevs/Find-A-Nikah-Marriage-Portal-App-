import 'dart:developer' as developer;

import 'package:find_a_nikah/core/logging/logger.dart';
import 'package:flutter/foundation.dart';

/// [Logger] over `dart:developer`. Release builds drop debug and info
/// entries; warnings and errors are kept (they become crash-report
/// breadcrumbs once a vendor is chosen).
class AppLogger implements Logger {
  const AppLogger({this.verbose = kDebugMode});

  /// Whether debug/info entries are written.
  final bool verbose;

  @override
  void debug(String message) {
    if (verbose) developer.log(message, name: 'app', level: 500);
  }

  @override
  void info(String message) {
    if (verbose) developer.log(message, name: 'app', level: 800);
  }

  @override
  void warning(String message, [Object? error, StackTrace? stackTrace]) =>
      developer.log(
        message,
        name: 'app',
        level: 900,
        error: error,
        stackTrace: stackTrace,
      );

  @override
  void error(String message, Object error, StackTrace stackTrace) =>
      developer.log(
        message,
        name: 'app',
        level: 1000,
        error: error,
        stackTrace: stackTrace,
      );
}
