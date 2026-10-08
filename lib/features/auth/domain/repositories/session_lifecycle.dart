/// The user-scoped part of the app (live connection, user repositories,
/// in-memory user data) as seen by sign-out. Implemented by the composition
/// root, which owns the `session` DI scope.
abstract interface class SessionLifecycle {
  /// Sign-out step 2: closes the live connection and cancels background
  /// sync.
  Future<void> closeConnections();

  /// Sign-out step 4: drops the session DI scope, so no singleton keeps the
  /// previous user's data. Idempotent.
  Future<void> end();
}
