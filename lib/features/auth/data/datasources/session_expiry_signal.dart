import 'dart:async';

/// Fired by `api_client` when the refresh token is rejected. The auth
/// repository listens and emits `unauthenticated`.
///
/// Exists to break the cycle Dio → auth repository → Dio: the HTTP stack
/// only knows this signal, not the repository.
class SessionExpirySignal {
  final _controller = StreamController<void>.broadcast(sync: true);

  Stream<void> get stream => _controller.stream;

  void notify() => _controller.add(null);

  Future<void> dispose() => _controller.close();
}
