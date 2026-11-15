import 'package:find_a_nikah/core/core.dart';
import 'package:find_a_nikah/features/auth/domain/repositories/auth_repository.dart';
import 'package:find_a_nikah/features/auth/domain/repositories/session_lifecycle.dart';

/// Signs the user out in the order the architecture guide requires:
///
/// 1. tell the server (best effort): unregister the push token, end the
///    refresh token;
/// 2. close real-time connections and background sync;
/// 3. delete credentials (then local database and media caches, once they
///    exist);
/// 4. pop the user-scoped DI scope;
/// 5. emit `unauthenticated` → the router navigates to the signed-out route.
///
/// Spans two repositories, hence a use case. Never fails: every step is
/// local or best effort.
class SignOut implements UseCase<Unit, NoParams> {
  const SignOut(this._auth, this._session, this._push);

  final AuthRepository _auth;
  final SessionLifecycle _session;
  final PushRegistrar _push;

  @override
  Future<Either<Failure, Unit>> call(NoParams params) async {
    // Needs the access token, so before credentials are deleted.
    await _push.unregister();
    await _auth.revokeServerSession();
    await _session.closeConnections();
    await _auth.deleteCredentials();
    await _session.end();
    await _auth.markSignedOut();
    return right(unit);
  }
}
