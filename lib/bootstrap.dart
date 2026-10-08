import 'dart:async';
import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:find_a_nikah/app/app.dart';
import 'package:find_a_nikah/app/di.dart';
import 'package:find_a_nikah/app/session_scope_manager.dart';
import 'package:find_a_nikah/core/core.dart';
import 'package:find_a_nikah/core/logging/app_bloc_observer.dart';
import 'package:find_a_nikah/flavors/app_config.dart';
import 'package:flutter/widgets.dart';

/// Shared start-up for every flavor: config → DI → error handlers →
/// session scope → `runApp`.
Future<void> bootstrap(Flavors flavor) async {
  WidgetsFlutterBinding.ensureInitialized();

  final config = AppConfig.fromEnvironment(flavor);
  await configureDependencies(config);

  final reporter = getIt<ErrorReporter>();
  final logger = getIt<Logger>();

  // Every uncaught error reaches crash reporting.
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    reporter
        .record(
          details.exception,
          details.stack ?? StackTrace.current,
          fatal: true,
          reason: details.context?.toDescription(),
        )
        .ignore();
  };
  PlatformDispatcher.instance.onError = (error, stackTrace) {
    reporter.record(error, stackTrace, fatal: true).ignore();
    return true;
  };
  Bloc.observer = AppBlocObserver(reporter: reporter, logger: logger);

  // Before any bloc subscribes to auth status, so the session scope exists
  // by the time the router lets the user into session routes.
  getIt<SessionScopeManager>().attach();

  logger.info('starting ${config.flavors.name}');
  runApp(const App());
}
