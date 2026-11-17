import 'dart:async';

import 'package:find_a_nikah/features/messaging/data/dtos/chat_api_dtos.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

/// A delivered / seen receipt, sent only to the message's sender:
/// `{ conversationId, messageIds, messageId, by, at }` where [by] is the
/// user who triggered it (the recipient who received / read).
class SocketReceipt {
  const SocketReceipt({
    required this.conversationId,
    required this.at,
    this.messageIds = const [],
    this.by,
  });

  final String conversationId;

  /// The messages affected. Empty for an old-style receipt that only has a
  /// timestamp (everything up to [at]).
  final List<String> messageIds;
  final DateTime at;

  /// Who triggered it; null when the server didn't say.
  final String? by;
}

/// `presence { userId, online, lastActiveAt }`.
class SocketPresence {
  const SocketPresence({
    required this.userId,
    required this.online,
    this.lastActiveAt,
  });

  final String userId;
  final bool online;
  final DateTime? lastActiveAt;
}

/// `message:deleted { conversationId, messageId }` — delete for everyone.
class SocketDeleted {
  const SocketDeleted({required this.conversationId, required this.messageId});

  final String conversationId;
  final String messageId;
}

/// `conversation:updated { conversationId, canMessage, blockedBy }` — an
/// unmatch, block or unblock.
class SocketConversationUpdated {
  const SocketConversationUpdated({
    required this.conversationId,
    required this.canMessage,
    this.blockedBy,
  });

  final String conversationId;
  final bool canMessage;

  /// `them` | `me` | null.
  final String? blockedBy;
}

class SocketTyping {
  const SocketTyping({
    required this.conversationId,
    required this.from,
    required this.typing,
  });

  final String conversationId;

  /// User id of whoever is typing.
  final String from;
  final bool typing;
}

/// The chat socket (`MESSAGE_AND_CHAT_API_SPEC.md` §4). Push-only: it feeds
/// streams that the messaging repository merges into its stores — it never
/// touches bloc state. Mutations that need a confirmed response stay REST.
abstract interface class ChatSocket {
  /// `message:new` (incoming) and `message:sent` (own, from another device).
  /// Each message carries its `senderId`; dedupe by id.
  Stream<MessageDto> get messages;

  Stream<SocketReceipt> get delivered;
  Stream<SocketReceipt> get seen;
  Stream<SocketTyping> get typing;
  Stream<SocketPresence> get presence;
  Stream<SocketDeleted> get deleted;
  Stream<SocketConversationUpdated> get conversationUpdated;

  /// True on every (re)connect, false on drop — a reconnect means events
  /// may have been missed, so the repository resyncs over REST.
  Stream<bool> get connection;

  bool get isConnected;

  void connect();
  void disconnect();

  /// App went to the background: drop the connection but remember the open
  /// rooms. Backend sends FCM only while no socket is connected, so a
  /// lingering background socket would swallow chat pushes.
  void suspend();

  /// Back in the foreground: reconnect (and rejoin rooms) if [suspend]ed.
  void resume();

  /// Rooms are rejoined by the data source after a reconnect.
  void join(String conversationId);
  void leave(String conversationId);

  void emitDelivered({String? messageId, String? conversationId});
  void emitSeen({String? messageId, String? conversationId});
  void emitTyping(String conversationId, {required bool typing});

  Future<void> dispose();
}

/// `socket_io_client` implementation. Websocket transport only; the JWT
/// goes in the handshake `auth`, read fresh on every (re)connect attempt.
class SocketIoChatSocket implements ChatSocket {
  /// [readToken]: the current access token. [refreshToken]: forces a token
  /// refresh (a cheap authenticated REST call does it) — used when the
  /// server rejects the handshake, which Socket.IO does not retry itself.
  SocketIoChatSocket({
    required this._url,
    required this._readToken,
    required this._refreshToken,
    this._retryAfter = const Duration(seconds: 3),
  });

  final String _url;
  final Future<String?> Function() _readToken;
  final Future<void> Function() _refreshToken;
  final Duration _retryAfter;

  io.Socket? _socket;
  final _rooms = <String>{};
  var _wanted = false;
  var _recovering = false;

  final _messages = StreamController<MessageDto>.broadcast();
  final _delivered = StreamController<SocketReceipt>.broadcast();
  final _seen = StreamController<SocketReceipt>.broadcast();
  final _typing = StreamController<SocketTyping>.broadcast();
  final _presence = StreamController<SocketPresence>.broadcast();
  final _deleted = StreamController<SocketDeleted>.broadcast();
  final _conversationUpdated =
      StreamController<SocketConversationUpdated>.broadcast();
  final _connection = StreamController<bool>.broadcast();

  @override
  Stream<MessageDto> get messages => _messages.stream;
  @override
  Stream<SocketReceipt> get delivered => _delivered.stream;
  @override
  Stream<SocketReceipt> get seen => _seen.stream;
  @override
  Stream<SocketTyping> get typing => _typing.stream;
  @override
  Stream<SocketPresence> get presence => _presence.stream;
  @override
  Stream<SocketDeleted> get deleted => _deleted.stream;
  @override
  Stream<SocketConversationUpdated> get conversationUpdated =>
      _conversationUpdated.stream;
  @override
  Stream<bool> get connection => _connection.stream;

  @override
  bool get isConnected => _socket?.connected ?? false;

  @override
  void connect() {
    _wanted = true;
    if (_socket != null) {
      if (!isConnected) _socket!.connect();
      return;
    }
    final socket = io.io(
      _url,
      io.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .enableReconnection()
          .setAuthFn((cb) async {
            cb({'token': await _readToken() ?? ''});
          })
          .build(),
    );
    _socket = socket;
    _listen(socket);
    socket.connect();
  }

  void _listen(io.Socket socket) {
    socket
      ..onConnect((_) {
        for (final id in _rooms) {
          socket.emit('conversation:join', {'conversationId': id});
        }
        _add(_connection, true);
      })
      ..onDisconnect((_) => _add(_connection, false))
      ..onConnectError((_) => unawaited(_recover()))
      ..on('message:new', _onMessage)
      ..on('message:sent', _onMessage)
      ..on('message:delivered', (d) => _onReceipt(d, _delivered))
      ..on('message:seen', (d) => _onReceipt(d, _seen))
      // Older server event for the same thing.
      ..on('message:read', (d) => _onReceipt(d, _seen))
      ..on('typing', (d) => _onTyping(d, typing: true))
      ..on('stop_typing', (d) => _onTyping(d, typing: false))
      ..on('presence', _onPresence)
      ..on('message:deleted', _onDeleted)
      ..on('conversation:updated', _onConversationUpdated);
  }

  /// The handshake was refused (usually an expired JWT): refresh it, wait a
  /// beat and try again, for as long as a connection is wanted.
  Future<void> _recover() async {
    if (_recovering || !_wanted) return;
    _recovering = true;
    try {
      await _refreshToken();
    } on Object {
      // Offline or signed out: the retry below decides.
    }
    await Future<void>.delayed(_retryAfter);
    _recovering = false;
    if (_wanted && !isConnected) _socket?.connect();
  }

  void _onMessage(dynamic data) {
    final map = _asMap(data);
    // Some events wrap the message: `{ message: {...} }`.
    final raw = map?['message'] is Map ? _asMap(map!['message']) : map;
    if (raw == null) return;
    try {
      _add(_messages, MessageDto.fromJson(raw));
    } on Object {
      // A malformed event must not kill the socket.
    }
  }

  void _onReceipt(dynamic data, StreamController<SocketReceipt> into) {
    final map = _asMap(data);
    if (map == null) return;
    final conversationId = map['conversationId'];
    if (conversationId is! String) return;
    final at =
        DateTime.tryParse(
          '${map['at'] ?? map['seenAt'] ?? map['deliveredAt'] ?? map['readAt'] ?? ''}',
        ) ??
        DateTime.now();
    final ids = <String>[
      if (map['messageIds'] is List)
        for (final id in map['messageIds'] as List)
          if (id is String) id,
      if (map['messageIds'] is! List && map['messageId'] is String)
        map['messageId'] as String,
    ];
    final by = map['by'] ?? map['seenBy'] ?? map['readBy'];
    _add(
      into,
      SocketReceipt(
        conversationId: conversationId,
        messageIds: ids,
        at: at,
        by: by is String ? by : null,
      ),
    );
  }

  void _onPresence(dynamic data) {
    final map = _asMap(data);
    final userId = map?['userId'];
    if (map == null || userId is! String) return;
    _add(
      _presence,
      SocketPresence(
        userId: userId,
        online: map['online'] == true,
        lastActiveAt: DateTime.tryParse('${map['lastActiveAt'] ?? ''}'),
      ),
    );
  }

  void _onConversationUpdated(dynamic data) {
    final map = _asMap(data);
    final conversationId = map?['conversationId'];
    final canMessage = map?['canMessage'];
    if (conversationId is! String || canMessage is! bool) return;
    final blockedBy = map?['blockedBy'];
    _add(
      _conversationUpdated,
      SocketConversationUpdated(
        conversationId: conversationId,
        canMessage: canMessage,
        blockedBy: blockedBy is String ? blockedBy : null,
      ),
    );
  }

  void _onDeleted(dynamic data) {
    final map = _asMap(data);
    final conversationId = map?['conversationId'];
    final messageId = map?['messageId'];
    if (conversationId is! String || messageId is! String) return;
    _add(
      _deleted,
      SocketDeleted(conversationId: conversationId, messageId: messageId),
    );
  }

  void _onTyping(dynamic data, {required bool typing}) {
    final map = _asMap(data);
    final conversationId = map?['conversationId'];
    final from = map?['from'];
    if (conversationId is! String || from is! String) return;
    _add(
      _typing,
      SocketTyping(
        conversationId: conversationId,
        from: from,
        typing: typing,
      ),
    );
  }

  static Map<String, dynamic>? _asMap(dynamic data) {
    // Socket.IO may hand over a one-element list of args.
    final value = data is List && data.isNotEmpty ? data.first : data;
    return value is Map ? Map<String, dynamic>.from(value) : null;
  }

  void _add<T>(StreamController<T> c, T value) {
    if (!c.isClosed) c.add(value);
  }

  @override
  void join(String conversationId) {
    _rooms.add(conversationId);
    if (isConnected) {
      _socket!.emit('conversation:join', {'conversationId': conversationId});
    }
  }

  @override
  void leave(String conversationId) {
    _rooms.remove(conversationId);
    if (isConnected) {
      _socket!.emit('conversation:leave', {'conversationId': conversationId});
    }
  }

  void _emitIds(String event, String? messageId, String? conversationId) {
    if (!isConnected) return;
    if (messageId != null) {
      _socket!.emit(event, {'messageId': messageId});
    } else if (conversationId != null) {
      _socket!.emit(event, {'conversationId': conversationId});
    }
  }

  @override
  void emitDelivered({String? messageId, String? conversationId}) =>
      _emitIds('message:delivered', messageId, conversationId);

  @override
  void emitSeen({String? messageId, String? conversationId}) =>
      _emitIds('message:seen', messageId, conversationId);

  @override
  void emitTyping(String conversationId, {required bool typing}) {
    if (!isConnected) return;
    _socket!.emit(typing ? 'typing' : 'stop_typing', {
      'conversationId': conversationId,
    });
  }

  bool _suspended = false;

  @override
  void suspend() {
    if (!_wanted || _socket == null) return;
    _suspended = true;
    _wanted = false;
    _socket!.disconnect();
  }

  @override
  void resume() {
    if (!_suspended) return;
    _suspended = false;
    connect();
  }

  @override
  void disconnect() {
    _suspended = false;
    _wanted = false;
    _rooms.clear();
    _socket?.disconnect();
  }

  @override
  Future<void> dispose() async {
    _wanted = false;
    _socket?.dispose();
    _socket = null;
    await Future.wait([
      _messages.close(),
      _delivered.close(),
      _seen.close(),
      _typing.close(),
      _presence.close(),
      _deleted.close(),
      _conversationUpdated.close(),
      _connection.close(),
    ]);
  }
}
