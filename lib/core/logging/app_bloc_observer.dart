import 'package:bloc/bloc.dart';
import 'package:find_a_nikah/core/logging/logger.dart';

/// Forwards every error a bloc reports (`addError`, or an exception thrown in
/// a handler) to crash reporting, and logs transitions in debug builds.
class AppBlocObserver extends BlocObserver {
  const AppBlocObserver({required this.reporter, required this.logger});

  final ErrorReporter reporter;
  final Logger logger;

  @override
  void onTransition(
    Bloc<dynamic, dynamic> bloc,
    Transition<dynamic, dynamic> transition,
  ) {
    super.onTransition(bloc, transition);
    logger.debug('${bloc.runtimeType} ${transition.event.runtimeType}');
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    reporter.record(error, stackTrace, reason: '${bloc.runtimeType}').ignore();
    super.onError(bloc, error, stackTrace);
  }
}
