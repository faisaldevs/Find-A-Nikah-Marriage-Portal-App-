import 'dart:async';

import 'package:find_a_nikah/app/di.dart';
import 'package:find_a_nikah/core/core.dart';
import 'package:find_a_nikah/features/auth/domain/domain.dart';

/// Opens the session DI scope when a user signs in and drops it when they
/// sign out or the session expires.
///
/// Attached at bootstrap, before any bloc subscribes to auth status, so the
/// scope exists before the router lets the user into session routes.
class SessionScopeManager implements SessionLifecycle {
  SessionScopeManager(this._auth, this._reporter);

  final AuthRepository _auth;
  final ErrorReporter _reporter;

  StreamSubscription<AuthStatus>? _subscription;
  String? _userId;

  bool get isActive => _userId != null;

  void attach() {
    _subscription ??= _auth.watchStatus().listen(_onStatus);
  }

  Future<void> _onStatus(AuthStatus status) async {
    switch (status) {
      case Authenticated(:final session):
        if (_userId == session.userId) return;
        if (isActive) await end();
        pushSessionScope();
        _userId = session.userId;
        // Backend user ids are opaque — never an email or name.
        unawaited(_reporter.setUserId(session.userId));
      case Unauthenticated():
        await end();
      case AuthUnknown():
        break;
    }
  }

  /// Nothing long-lived to close yet. Live connections (chat) and
  /// background sync get closed here once they exist.
  @override
  Future<void> closeConnections() async {}

  @override
  Future<void> end() async {
    if (!isActive) return;
    _userId = null;
    await dropSessionScope();
    await _reporter.setUserId(null);
  }

  Future<void> dispose() async => _subscription?.cancel();
}
