import 'dart:async';

import 'package:find_a_nikah/core/core.dart';
import 'package:find_a_nikah/core/utils/profile_mapping.dart';
import 'package:find_a_nikah/features/messaging/data/datasources/chat_remote_data_source.dart';
import 'package:find_a_nikah/features/messaging/data/datasources/matches_remote_data_source.dart';
import 'package:find_a_nikah/features/messaging/data/dtos/chat_api_dtos.dart';
import 'package:find_a_nikah/features/messaging/data/dtos/chat_peer_dto.dart';
import 'package:find_a_nikah/features/messaging/data/mappers/messaging_mappers.dart';
import 'package:find_a_nikah/features/messaging/domain/domain.dart';

/// Session-scoped: holds the signed-in user's chats, dropped on sign-out.
///
/// Live over REST (`/v1/conversations`, `/v1/matches/my-matches`), text
/// only. There is no socket yet, so the streams are kept fresh by polling:
/// the list every [_listEvery], an open thread every [_threadEvery]. When
/// the socket lands its events feed [_notify] / the stores below and the
/// timers go. Typing and presence have no REST source, so they stay quiet.
///
/// The dummy-backed version is `DummyMessagingRepositoryImpl`.
class MessagingRepositoryImpl implements MessagingRepository {
  /// [_imageBaseUrl]: server root that `/public/upload/...` photo paths
  /// hang off.
  MessagingRepositoryImpl(
    this._chat,
    this._matchesRemote,
    this._guard,
    this._imageBaseUrl,
  );

  final ChatRemoteDataSource _chat;
  final MatchesRemoteDataSource _matchesRemote;
  final Guard _guard;
  final String _imageBaseUrl;

  static const _listEvery = Duration(seconds: 10);
  static const _threadEvery = Duration(seconds: 3);
  static const _listPageSize = 50;
  static const _maxListPages = 10;
  static const _matchesPageSize = 50;
  static const _maxMatchPages = 10;
  static const _threadPageSize = 30;

  /// Free plan's conversation slots; the Chat tab draws this many.
  static const _slotCount = 5;

  final _changes = StreamController<void>.broadcast();
  int _seq = 0;

  // ── Conversations ─────────────────────────────────────────────────────

  /// Every conversation the server listed, by conversation id.
  final _byId = <String, Conversation>{};

  /// Conversation id → its slot. Assigned the first time a conversation
  /// shows in the slots and kept for the session, so a new message
  /// re-sorting the server's list doesn't shuffle the Chat tab.
  final _slotOf = <String, int>{};

  /// Peers picked from the Matches panel this session, with the slot they
  /// were picked into. Their (still empty) conversation shows in the slots
  /// even though it has no message yet.
  final _startedPeers = <String, int?>{};

  /// Server order (most recent activity first).
  var _order = <String>[];

  /// Matches without a started conversation, by peer id.
  final _matchesById = <String, ChatPeerDto>{};

  Future<void>? _firstLoad;

  @override
  Stream<List<Conversation>> watchConversations() => _live<List<Conversation>>(
    first: _ensureListLoaded,
    refresh: _refreshList,
    read: _slotted,
    every: _listEvery,
  );

  @override
  Stream<List<ChatPeer>> watchMatches() => _live<List<ChatPeer>>(
    first: _ensureListLoaded,
    refresh: _refreshList,
    read: _panelMatches,
    every: _listEvery,
  );

  Future<void> _ensureListLoaded() => _firstLoad ??= _loadList();

  Future<void> _loadList() async {
    try {
      await _refreshList();
    } on Object {
      _firstLoad = null; // retry on the next subscription
      rethrow;
    }
  }

  Future<void> _refreshList() async {
    await Future.wait([_fetchConversations(), _fetchMatches()]);
  }

  Future<void> _fetchConversations() async {
    final rows = <ConversationRowDto>[];
    for (var page = 1; page <= _maxListPages; page++) {
      final res = await _chat.fetchConversations(
        page: page,
        limit: _listPageSize,
      );
      rows.addAll(res.data.conversations);
      if (!res.data.pagination.hasNext) break;
    }
    _order = [for (final r in rows) r.id];
    final fresh = {for (final r in rows) r.id: _conversationOf(r)};
    // A just-opened empty conversation can be missing from a list that was
    // fetched before it existed; keep it until the server lists it.
    for (final old in _byId.values) {
      if (!fresh.containsKey(old.id) &&
          _startedPeers.containsKey(old.peer.id)) {
        fresh[old.id] = old;
        _order.add(old.id);
      }
    }
    _byId
      ..clear()
      ..addAll(fresh);
    _slotOf.removeWhere((id, _) => !_byId.containsKey(id));
    _notify();
  }

  Future<void> _fetchMatches() async {
    final peers = <ChatPeerDto>[];
    for (var page = 1; page <= _maxMatchPages; page++) {
      final res = await _matchesRemote.fetchMyMatches(
        page: page,
        limit: _matchesPageSize,
      );
      for (final m in res.data.matches) {
        if (m.toPeerDto(imageBaseUrl: _imageBaseUrl) case final peer?) {
          peers.add(peer);
        }
      }
      if (!res.data.pagination.hasNext) break;
    }
    _matchesById
      ..clear()
      ..addEntries(peers.map((p) => MapEntry(p.id, p)));
    _notify();
  }

  Conversation _conversationOf(ConversationRowDto row) {
    final partner = row.partner;
    final peerId = partner?.id ?? '';
    final photo = partner?.photoUrl;
    final preview = row.lastMessagePreview;
    return Conversation(
      id: row.id,
      peer: ChatPeer(
        id: peerId,
        name: partner?.fullName ?? '',
        photoUrl: photo == null || photo.isEmpty
            ? ''
            : resolveImageUrl(_imageBaseUrl, photo),
        lastSeenAt: partner?.lastActiveAt?.toLocal(),
      ),
      slot: 0, // set by _slotted
      lastMessage: preview == null
          ? null
          : ChatMessage(
              id: 'last-${row.id}',
              conversationId: row.id,
              text: preview,
              sentAt: (row.lastMessageAt ?? DateTime.now()).toLocal(),
              isMine:
                  row.lastMessageSender != null &&
                  row.lastMessageSender != peerId,
            ),
      unreadCount: row.unreadCount,
    );
  }

  /// Conversations that fill the slots: ones with messages, plus ones the
  /// user started from the panel. Slots go to the first free index, in
  /// server order, and stay put once given.
  List<Conversation> _slotted() {
    final eligible = [
      for (final id in _order)
        if (_byId[id] case final c?
            when c.lastMessage != null || _startedPeers.containsKey(c.peer.id))
          c,
    ];
    final taken = {
      for (final c in eligible)
        if (_slotOf[c.id] case final s?) s,
    };
    int firstFree() {
      var i = 0;
      while (taken.contains(i)) {
        i++;
      }
      return i;
    }

    for (final c in eligible) {
      if (_slotOf.containsKey(c.id)) continue;
      final hint = _startedPeers[c.peer.id];
      final slot = hint != null && !taken.contains(hint) ? hint : firstFree();
      _slotOf[c.id] = slot;
      taken.add(slot);
    }
    return [
      for (final c in eligible)
        if (_slotOf[c.id]! < _slotCount) c.copyWith(slot: _slotOf[c.id]),
    ]..sort((a, b) => a.slot.compareTo(b.slot));
  }

  /// Matches not already in a slot.
  List<ChatPeer> _panelMatches() {
    final inSlots = {for (final c in _slotted()) c.peer.id};
    return [
      for (final m in _matchesById.values)
        if (!inSlots.contains(m.id)) m.toEntity(),
    ];
  }

  @override
  Future<Either<Failure, Conversation>> openConversation(
    String peerId, {
    int? slot,
  }) => _guard(() async {
    await _ensureListLoaded();
    final known = _byId.values.where((c) => c.peer.id == peerId).firstOrNull;
    // POST is idempotent (200 existing / 201 new) and also enforces the
    // match / entitlement check, so a 403 surfaces here either way.
    final opened = await _chat.openConversation(peerId);
    final id = opened.data.id;
    final peer =
        known?.peer ??
        _matchesById[peerId]?.toEntity() ??
        ChatPeer(id: peerId, name: '', photoUrl: '');
    final base = known ?? Conversation(id: id, peer: peer, slot: 0);
    _byId[id] = base;
    if (!_order.contains(id)) _order.insert(0, id);
    _startedPeers.putIfAbsent(peerId, () => slot);
    _peerOf[id] = peerId;
    _notify();
    return _slotted().firstWhere(
      (c) => c.id == id,
      // Past the slot limit: still openable, just not on the tab.
      orElse: () => base,
    );
  });

  // ── Messages ──────────────────────────────────────────────────────────

  /// Conversation id → peer id, to tell whose message is whose without
  /// knowing the signed-in user's id (anything not from the peer is mine).
  final _peerOf = <String, String>{};

  /// Oldest first.
  final _messages = <String, List<ChatMessage>>{};
  final _hasMore = <String, bool>{};

  @override
  Stream<List<ChatMessage>> watchMessages(String conversationId) =>
      _live<List<ChatMessage>>(
        first: () => _refreshThread(conversationId),
        refresh: () => _refreshThread(conversationId),
        read: () => List.of(_messages[conversationId] ?? const []),
        every: _threadEvery,
      );

  /// Latest page, merged into what is held: newer messages appended, read
  /// flags updated, unsent / local entries kept.
  Future<void> _refreshThread(String conversationId) async {
    final res = await _chat.fetchMessages(
      conversationId,
      limit: _threadPageSize,
    );
    final held = _messages[conversationId];
    _hasMore[conversationId] = held == null
        ? res.data.hasMore
        : (_hasMore[conversationId] ?? res.data.hasMore);
    _merge(conversationId, res.data.messages);
    _notify();
  }

  void _merge(String conversationId, List<MessageDto> incoming) {
    final held = _messages[conversationId] ?? const <ChatMessage>[];
    final byId = {for (final m in held) m.id: m};
    for (final dto in incoming) {
      if (dto.messageType != 'text' && dto.text.isEmpty) continue;
      byId[dto.id] = _messageOf(conversationId, dto);
    }
    _messages[conversationId] = byId.values.toList()
      ..sort((a, b) => a.sentAt.compareTo(b.sentAt));
  }

  ChatMessage _messageOf(String conversationId, MessageDto dto) {
    final mine = dto.senderId != _peerOf[conversationId];
    return ChatMessage(
      id: dto.id,
      conversationId: conversationId,
      text: dto.text,
      sentAt: dto.createdAt.toLocal(),
      isMine: mine,
      status: dto.isRead ? MessageStatus.seen : MessageStatus.sent,
    );
  }

  @override
  Future<Either<Failure, bool>> loadOlderMessages(String conversationId) =>
      _guard(() async {
        if (_hasMore[conversationId] == false) return false;
        final held = _messages[conversationId] ?? const <ChatMessage>[];
        final oldest = held
            .where((m) => !m.id.startsWith('local-'))
            .firstOrNull;
        if (oldest == null) return false;
        final res = await _chat.fetchMessages(
          conversationId,
          limit: _threadPageSize,
          before: oldest.id,
        );
        _hasMore[conversationId] = res.data.hasMore;
        _merge(conversationId, res.data.messages);
        _notify();
        return res.data.hasMore;
      });

  @override
  Stream<bool> watchPeerTyping(String conversationId) =>
      // No REST source; arrives with the socket.
      Stream<bool>.value(false);

  @override
  Future<Either<Failure, Unit>> sendMessage({
    required String conversationId,
    required String text,
    // The API has no replies; the quote is dropped.
    String? replyToMessageId,
  }) async {
    final localId = 'local-${++_seq}';
    _put(
      conversationId,
      ChatMessage(
        id: localId,
        conversationId: conversationId,
        text: text,
        sentAt: DateTime.now(),
        isMine: true,
        status: MessageStatus.sending,
      ),
    );
    final sent = await _guard(
      () => _chat.sendMessage(conversationId, SendMessageBodyDto(text: text)),
    );
    return sent.match(
      (f) {
        _replace(
          conversationId,
          localId,
          (m) => m.copyWith(status: MessageStatus.failed),
        );
        return left(f);
      },
      (res) {
        // The poll may have fetched the server copy already: dedupe by id.
        final list = _messages[conversationId]!
          ..removeWhere((m) => m.id == localId || m.id == res.data.id);
        list
          ..add(_messageOf(conversationId, res.data))
          ..sort((a, b) => a.sentAt.compareTo(b.sentAt));
        _bumpPreview(conversationId, text);
        _notify();
        return right(unit);
      },
    );
  }

  /// A just-sent message moves the conversation to the top and becomes its
  /// preview without waiting for the next list poll.
  void _bumpPreview(String conversationId, String text) {
    final c = _byId[conversationId];
    if (c == null) return;
    _byId[conversationId] = c.copyWith(
      lastMessage: ChatMessage(
        id: 'last-$conversationId',
        conversationId: conversationId,
        text: text,
        sentAt: DateTime.now(),
        isMine: true,
      ),
    );
    _order
      ..remove(conversationId)
      ..insert(0, conversationId);
  }

  void _put(String conversationId, ChatMessage message) {
    (_messages[conversationId] ??= []).add(message);
    _notify();
  }

  void _replace(
    String conversationId,
    String messageId,
    ChatMessage Function(ChatMessage) update,
  ) {
    final list = _messages[conversationId];
    final i = list?.indexWhere((m) => m.id == messageId) ?? -1;
    if (list == null || i < 0) return;
    list[i] = update(list[i]);
    _notify();
  }

  @override
  Future<Either<Failure, Unit>> logCall({
    required String conversationId,
    required CallLog log,
  }) => _guard(() async {
    // No call records on the server: a local line until the thread reloads
    // from scratch. Kept by the poll merge (its id isn't a server id).
    _put(
      conversationId,
      ChatMessage(
        id: 'local-call-${++_seq}',
        conversationId: conversationId,
        text: '',
        sentAt: DateTime.now(),
        isMine: log.outgoing,
        status: MessageStatus.seen,
        callLog: log,
      ),
    );
    return unit;
  });

  @override
  Future<Either<Failure, Unit>> markRead(String conversationId) =>
      _guard(() async {
        await _chat.markRead(conversationId);
        final c = _byId[conversationId];
        if (c != null && c.hasUnread) {
          _byId[conversationId] = c.copyWith(unreadCount: 0);
          _notify();
        }
        return unit;
      });

  // ── Plumbing ──────────────────────────────────────────────────────────

  void _notify() {
    if (!_changes.isClosed) _changes.add(null);
  }

  /// [first] runs once per subscription — its error ends up in the stream.
  /// Then a value is emitted on every store change, and [refresh] runs
  /// every [every] while someone listens (poll errors are swallowed; the
  /// next tick retries).
  Stream<T> _live<T>({
    required Future<void> Function() first,
    required Future<void> Function() refresh,
    required T Function() read,
    required Duration every,
  }) {
    late final StreamController<T> controller;
    StreamSubscription<void>? changes;
    Timer? timer;
    var polling = false;

    void emit() {
      if (!controller.isClosed) controller.add(read());
    }

    controller = StreamController<T>(
      onListen: () async {
        try {
          await first();
        } on Object catch (e, st) {
          if (!controller.isClosed) controller.addError(e, st);
          return;
        }
        if (controller.isClosed) return;
        emit();
        changes = _changes.stream.listen((_) => emit());
        timer = Timer.periodic(every, (_) async {
          if (polling) return;
          polling = true;
          try {
            await refresh();
          } on Object {
            // keep the last data; try again next tick
          } finally {
            polling = false;
          }
        });
      },
      onCancel: () async {
        timer?.cancel();
        await changes?.cancel();
      },
    );
    return controller.stream;
  }

  Future<void> dispose() => _changes.close();
}
