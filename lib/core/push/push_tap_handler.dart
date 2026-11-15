import 'package:find_a_nikah/core/push/push_payload.dart';

/// Holds a tapped notification until the app can open it (signed in, router
/// up), then hands it to [open]. The screen mapping lives in the router
/// (`lib/router/push_navigation.dart`), because core can't see features.
class PushTapHandler {
  PushPayload? _pending;
  void Function(PushPayload)? _open;
  bool Function() _ready = () => false;

  /// Called by `App` once the router exists.
  void attach({
    required void Function(PushPayload) open,
    required bool Function() isReady,
  }) {
    _open = open;
    _ready = isReady;
    drain();
  }

  void handle(PushPayload payload) {
    _pending = payload;
    drain();
  }

  /// Opens the pending tap if the app is ready; call again after sign-in.
  void drain() {
    final p = _pending;
    final open = _open;
    if (p == null || open == null || !_ready()) return;
    _pending = null;
    open(p);
  }
}
