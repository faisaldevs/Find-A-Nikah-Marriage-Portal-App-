/// Shared non-UI building blocks: failures, exceptions, the repository
/// guard, use cases, logging and static data. Network lives in
/// `network/network.dart`, UI in `ui/ui.dart`.
library;

export 'package:fpdart/fpdart.dart' show Either, Unit, left, right, unit;

export 'constants/countries.dart';
export 'error/app_exception.dart';
export 'error/failure.dart';
export 'error/guard.dart';
export 'logging/logger.dart';
export 'media/image_compressor.dart';
export 'usecase/use_case.dart';
