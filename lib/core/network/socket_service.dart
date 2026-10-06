import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

import 'api_endpoints.dart';

/// Single persistent Socket.IO connection, shared app-wide. `chat` and
/// `feed` subscribe to their own named events off this one connection —
/// do not create a second [io.Socket].
class SocketService {
  io.Socket? _socket;

  bool get isConnected => _socket?.connected ?? false;

  /// Connects once, authenticated with the current session token. Call after
  /// login; call [disconnect] on logout.
  void connect(String authToken) {
    _socket?.dispose();
    _socket = io.io(
      ApiEndpoints.baseUrl,
      io.OptionBuilder()
          .setTransports(['websocket'])
          .setAuth({'token': authToken})
          .disableAutoConnect()
          .build(),
    )..connect();
  }

  void disconnect() {
    _socket?.dispose();
    _socket = null;
  }

  /// Subscribes to a named server event. Callers (Repositories) filter to
  /// what they care about and are responsible for calling [off] on dispose.
  void on(String event, void Function(dynamic data) callback) {
    _socket?.on(event, callback);
  }

  void off(String event) => _socket?.off(event);

  void emit(String event, dynamic data) => _socket?.emit(event, data);
}

final socketServiceProvider = Provider<SocketService>((ref) {
  final service = SocketService();
  ref.onDispose(service.disconnect);
  return service;
});
