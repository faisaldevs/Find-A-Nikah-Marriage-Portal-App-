import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Stand-in for real auth: whether the user may enter the main app (the
/// bottom-nav tabs). The router's redirect reads this.
///
/// In-memory only — forgotten on app restart. Set by:
/// - the intro carousel's "Skip" (temporary shortcut into the app while
///   the backend doesn't exist), and
/// - "Discover profiles" at the end of sign-up.
///
/// TODO(auth): replace with the real auth state provider once login/token
/// storage exists; the router needs no other change.
class SessionController extends Notifier<bool> {
  @override
  bool build() => false;

  void signIn() => state = true;
  void signOut() => state = false;
}

final sessionProvider = NotifierProvider<SessionController, bool>(
  SessionController.new,
);
