import 'package:find_a_nikah/core/error/failure.dart';
import 'package:fpdart/fpdart.dart';

/// A single business action that spans repositories or adds a rule.
///
/// Use cases exist only when there is logic to hold; plain reads call the
/// repository directly.
abstract interface class UseCase<T, Params> {
  Future<Either<Failure, T>> call(Params params);
}

/// [UseCase] params for actions that take none.
final class NoParams {
  const NoParams();
}
