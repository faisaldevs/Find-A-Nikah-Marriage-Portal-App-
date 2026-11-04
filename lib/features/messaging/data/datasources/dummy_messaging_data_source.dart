import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;

import 'package:find_a_nikah/features/messaging/data/dtos/chat_message_dto.dart';
import 'package:find_a_nikah/features/messaging/data/dtos/chat_peer_dto.dart';
import 'package:find_a_nikah/features/messaging/data/dtos/conversation_dto.dart';
import 'package:find_a_nikah/gen/assets.gen.dart';
import 'package:flutter/services.dart';

/// Dev-only stand-in for the chat API + socket, seeded from
/// `assets/dummy/messaging.json`. In-memory, so sent messages last until
/// sign-out or restart.
///
/// Fakes what the server will do: a sent message goes sending → sent →
/// delivered → seen, then the peer "types" and answers with one of the
/// fixture's `autoReplies`.
class DummyMessagingDataSource {
  DummyMessagingDataSource({
    AssetBundle? bundle,
    this.latency = const Duration(milliseconds: 300),
  }) : _bundle = bundle ?? rootBundle;

  final AssetBundle _bundle;
  final Duration latency;

  final _changes = StreamController<void>.broadcast();
  final _random = math.Random();
  Future<void>? _loading;

  /// The signed-in user's id in the fixture. Valid once anything has
  /// loaded (every stream emits only after that).
  String meId = '';

  /// Conversation id → peer, messages (oldest first) and unread count.
  final _peers = <String, ChatPeerDto>{};
  final _messages = <String, List<ChatMessageDto>>{};
  final _unread = <String, int>{};

  // /// When a conversation was started from a match — orders it in the list
  // /// until its first message.
  // final _startedAt = <String, DateTime>{};

  /// Conversation id → its slot on the Chat tab.
  final _slots = <String, int>{};

  /// Matched peers nobody has messaged yet.
  final _matches = <ChatPeerDto>[];
  final _typing = <String>{};
  List<String> _autoReplies = const [];

  final _timers = <Timer>{};
  final _replyTimers = <String, Timer>{};
  int _seq = 0;

  // Before: only conversations with messages were listed, and a match
  // stayed a match until messaged.
  // Stream<List<ConversationDto>> watchConversations() => _watch(
  //   () =>
  //       [
  //         for (final id in _peers.keys)
  //           if (_messages[id]!.isNotEmpty) _conversation(id),
  //       ]..sort(
  //         (a, b) => b.lastMessage!.sentAt.compareTo(a.lastMessage!.sentAt),
  //       ),
  // );
  //
  // Stream<List<ChatPeerDto>> watchMatches() => _watch(
  //   () => [
  //     for (final peer in _matches)
  //       if (!_hasMessages(peer.id)) peer,
  //   ],
  // );

  // /// Every started conversation, empty ones included, newest activity
  // /// first.
  // Stream<List<ConversationDto>> watchConversations() => _watch(
  //   () =>
  //       [for (final id in _peers.keys) _conversation(id)]
  //         ..sort((a, b) => _activityOf(b).compareTo(_activityOf(a))),
  // );

  /// Every started conversation, empty ones included, in slot order.
  Stream<List<ConversationDto>> watchConversations() => _watch(
    () =>
        [for (final id in _peers.keys) _conversation(id)]
          ..sort((a, b) => a.slot.compareTo(b.slot)),
  );

  /// Matches with no conversation yet.
  Stream<List<ChatPeerDto>> watchMatches() => _watch(
    () => [
      for (final peer in _matches)
        if (_conversationIdOf(peer.id) == null) peer,
    ],
  );

  Stream<List<ChatMessageDto>> watchMessages(String conversationId) =>
      _watch(() => List.of(_messages[conversationId] ?? const []));

  Stream<bool> watchPeerTyping(String conversationId) =>
      _watch(() => _typing.contains(conversationId)).distinct();

  // Before: only the fixture's own matches could start a conversation.
  // Future<ConversationDto> openConversation(
  //   String peerId, {
  //   int? slot,
  // }) async {
  //   await _ensureLoaded();
  //   final existing = _conversationIdOf(peerId);
  //   if (existing != null) return _conversation(existing);
  //   final peer = _matches.firstWhere(
  //     (p) => p.id == peerId,
  //     orElse: () => throw StateError('no match with $peerId'),
  //   );

  /// [peer]: a real match (from `my-matches`) that isn't in the fixture —
  /// the Matches panel is live while the chats themselves are still fake.
  Future<ConversationDto> openConversation(
    String peerId, {
    int? slot,
    ChatPeerDto? peer,
  }) async {
    await _ensureLoaded();
    final existing = _conversationIdOf(peerId);
    if (existing != null) return _conversation(existing);
    final match =
        _matches.where((p) => p.id == peerId).firstOrNull ??
        peer ??
        (throw StateError('no match with $peerId'));
    final id = 'c-$peerId';
    // _peers[id] = peer;
    _peers[id] = match;
    _messages[id] = [];
    _unread[id] = 0;
    // _startedAt[id] = DateTime.now().toUtc();
    final taken = _slots.values.toSet();
    _slots[id] = slot != null && !taken.contains(slot)
        ? slot
        : _firstFree(taken);
    _notify();
    return _conversation(id);
  }

  Future<void> sendMessage({
    required String conversationId,
    required String text,
    String? replyToMessageId,
  }) async {
    await _ensureLoaded();
    final messages = _messages[conversationId];
    if (messages == null) throw StateError('no conversation $conversationId');
    final quoted = replyToMessageId == null
        ? null
        : messages.where((m) => m.id == replyToMessageId).firstOrNull;
    final id = 'local-${++_seq}';
    messages.add(
      ChatMessageDto(
        id: id,
        conversationId: conversationId,
        senderId: meId,
        text: text,
        sentAt: DateTime.now().toUtc(),
        status: 'sending',
        replyTo: quoted == null
            ? null
            : MessageReplyDto(
                messageId: quoted.id,
                senderId: quoted.senderId,
                text: quoted.text,
              ),
      ),
    );
    _notify();

    await Future<void>.delayed(latency);
    _setStatus(conversationId, id, 'sent');
    _after(const Duration(seconds: 1), () {
      _setStatus(conversationId, id, 'delivered');
    });
    _after(const Duration(milliseconds: 2500), () {
      _setStatus(conversationId, id, 'seen');
    });
    _scheduleReply(conversationId);
  }

  /// Appends a call record. A call the peer placed counts as unread.
  Future<void> logCall({
    required String conversationId,
    required String outcome,
    required bool outgoing,
    required int durationSeconds,
  }) async {
    await _ensureLoaded();
    final messages = _messages[conversationId];
    if (messages == null) throw StateError('no conversation $conversationId');
    final peerId = _peers[conversationId]!.id;
    messages.add(
      ChatMessageDto(
        id: 'local-${++_seq}',
        conversationId: conversationId,
        senderId: outgoing ? meId : peerId,
        text: '',
        sentAt: DateTime.now().toUtc(),
        status: 'seen',
        call: CallLogDto(
          outcome: outcome,
          callerId: outgoing ? meId : peerId,
          durationSeconds: durationSeconds,
        ),
      ),
    );
    if (!outgoing) {
      _unread[conversationId] = (_unread[conversationId] ?? 0) + 1;
    }
    _notify();
  }

  Future<void> markRead(String conversationId) async {
    await _ensureLoaded();
    if ((_unread[conversationId] ?? 0) == 0) return;
    _unread[conversationId] = 0;
    _notify();
  }

  Future<void> dispose() async {
    for (final t in [..._timers, ..._replyTimers.values]) {
      t.cancel();
    }
    await _changes.close();
  }

  // ── Fake peer ─────────────────────────────────────────────────────────

  /// One answer per burst: every send pushes the reply back.
  void _scheduleReply(String conversationId) {
    if (_autoReplies.isEmpty) return;
    _replyTimers[conversationId]?.cancel();
    _replyTimers[conversationId] = Timer(const Duration(seconds: 3), () {
      _typing.add(conversationId);
      _notify();
      _replyTimers[conversationId] = Timer(const Duration(seconds: 2), () {
        _replyTimers.remove(conversationId);
        _typing.remove(conversationId);
        _messages[conversationId]?.add(
          ChatMessageDto(
            id: 'local-${++_seq}',
            conversationId: conversationId,
            senderId: _peers[conversationId]!.id,
            text: _autoReplies[_random.nextInt(_autoReplies.length)],
            sentAt: DateTime.now().toUtc(),
          ),
        );
        _unread[conversationId] = (_unread[conversationId] ?? 0) + 1;
        _notify();
      });
    });
  }

  // ── Store ─────────────────────────────────────────────────────────────

  /// Emits the current value once loaded, then again after every change.
  Stream<T> _watch<T>(T Function() read) async* {
    await _ensureLoaded();
    yield read();
    yield* _changes.stream.map((_) => read());
  }

  void _notify() {
    if (!_changes.isClosed) _changes.add(null);
  }

  void _after(Duration delay, void Function() run) {
    late final Timer timer;
    timer = Timer(delay, () {
      _timers.remove(timer);
      run();
    });
    _timers.add(timer);
  }

  void _setStatus(String conversationId, String messageId, String status) {
    final messages = _messages[conversationId];
    if (messages == null) return;
    final i = messages.indexWhere((m) => m.id == messageId);
    if (i < 0) return;
    messages[i] = messages[i].withStatus(status);
    _notify();
  }

  ConversationDto _conversation(String id) {
    final messages = _messages[id]!;
    return ConversationDto(
      id: id,
      peer: _peers[id]!,
      slot: _slots[id]!,
      lastMessage: messages.isEmpty ? null : messages.last,
      unreadCount: _unread[id] ?? 0,
    );
  }

  String? _conversationIdOf(String peerId) => _peers.entries
      .where((e) => e.value.id == peerId)
      .map((e) => e.key)
      .firstOrNull;

  // bool _hasMessages(String peerId) {
  //   final id = _conversationIdOf(peerId);
  //   return id != null && _messages[id]!.isNotEmpty;
  // }

  // DateTime _activityOf(ConversationDto c) =>
  //     c.lastMessage?.sentAt ?? _startedAt[c.id] ?? DateTime(0);

  static int _firstFree(Set<int> taken) {
    var i = 0;
    while (taken.contains(i)) {
      i++;
    }
    return i;
  }

  Future<void> _ensureLoaded() => _loading ??= _load();

  Future<void> _load() async {
    final json =
        jsonDecode(await _bundle.loadString(Assets.dummy.messaging))
            as Map<String, dynamic>;
    // Fixture times are written against `anchor`; shift them so the
    // newest chats always read as just now.
    final shift = DateTime.now().difference(
      DateTime.parse(json['anchor'] as String),
    );
    meId = json['meId'] as String;
    for (final raw in json['conversations'] as List<dynamic>) {
      final c = raw as Map<String, dynamic>;
      final id = c['id'] as String;
      _peers[id] = ChatPeerDto.fromJson(
        _shifted(c['peer'] as Map<String, dynamic>, 'lastSeenAt', shift),
      );
      _unread[id] = c['unreadCount'] as int? ?? 0;
      _slots[id] = c['slot'] as int? ?? _firstFree(_slots.values.toSet());
      _messages[id] = [
        for (final m in c['messages'] as List<dynamic>)
          ChatMessageDto.fromJson({
            ..._shifted(m as Map<String, dynamic>, 'sentAt', shift),
            'conversationId': id,
          }),
      ];
    }
    _matches.addAll([
      for (final m in json['matches'] as List<dynamic>)
        ChatPeerDto.fromJson(
          _shifted(m as Map<String, dynamic>, 'lastSeenAt', shift),
        ),
    ]);
    _autoReplies = List<String>.from(json['autoReplies'] as List<dynamic>);
  }

  static Map<String, dynamic> _shifted(
    Map<String, dynamic> json,
    String key,
    Duration shift,
  ) {
    final value = json[key] as String?;
    if (value == null) return json;
    return {...json, key: DateTime.parse(value).add(shift).toIso8601String()};
  }
}
