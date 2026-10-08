import 'package:find_a_nikah/core/core.dart';
import 'package:find_a_nikah/features/auth/domain/repositories/auth_repository.dart';
import 'package:find_a_nikah/features/auth/domain/repositories/session_lifecycle.dart';

/// Signs the user out in the order the architecture guide requires:
///
/// 1. tell the server (best effort) — push-token unregistering joins here
///    once push exists;
/// 2. close real-time connections and background sync;
/// 3. delete credentials (then local database and media caches, once they
///    exist);
/// 4. pop the user-scoped DI scope;
/// 5. emit `unauthenticated` → the router navigates to the signed-out route.
///
/// Spans two repositories, hence a use case. Never fails: every step is
/// local or best effort.
class SignOut implements UseCase<Unit, NoParams> {
  const SignOut(this._auth, this._session);

  final AuthRepository _auth;
  final SessionLifecycle _session;

  @override
  Future<Either<Failure, Unit>> call(NoParams params) async {
    await _auth.revokeServerSession();
    await _session.closeConnections();
    await _auth.deleteCredentials();
    await _session.end();
    _auth.markSignedOut();
    return right(unit);
  }
}
