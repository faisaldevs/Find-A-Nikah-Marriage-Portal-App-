import 'dart:async';

import 'package:dio/dio.dart' show MultipartFile;
import 'package:find_a_nikah/core/core.dart';
import 'package:find_a_nikah/core/utils/profile_mapping.dart';
import 'package:find_a_nikah/features/messaging/data/datasources/chat_remote_data_source.dart';
import 'package:find_a_nikah/features/messaging/data/datasources/chat_socket_data_source.dart';
import 'package:find_a_nikah/features/messaging/data/datasources/matches_remote_data_source.dart';
import 'package:find_a_nikah/features/messaging/data/dtos/chat_api_dtos.dart';
import 'package:find_a_nikah/features/messaging/data/dtos/chat_peer_dto.dart';
import 'package:find_a_nikah/features/messaging/data/mappers/messaging_mappers.dart';
import 'package:find_a_nikah/features/messaging/domain/domain.dart';

/// Session-scoped: holds the signed-in user's chats, dropped on sign-out.
///
/// REST (`/v1/conversations`, `/v1/matches/my-matches`) is the source of
/// truth; the [ChatSocket] pushes changes on top of it: new messages,
/// delivered / seen ticks, typing. Socket events only ever land in the
/// stores below and go out through the streams — never into bloc state.
/// Polling stays as a slow safety net, and every socket (re)connect
/// resyncs over REST in case events were missed while it was down.
///
/// The dummy-backed version is `DummyMessagingRepositoryImpl`.
class MessagingRepositoryImpl implements MessagingRepository {
  /// [_imageBaseUrl]: server root that `/public/upload/...` photo paths
  /// hang off.
  MessagingRepositoryImpl(
    this._chat,
    this._matchesRemote,
    this._socket,
    this._guard,
    this._imageBaseUrl,
  ) {
    _subs.addAll([
      _socket.messages.listen(_onSocketMessage),
      _socket.delivered.listen(_onDelivered),
      _socket.seen.listen(_onSeen),
      _socket.typing.listen(_onTyping),
      _socket.presence.listen(_onPresence),
      _socket.connection.listen(_onConnection),
    ]);
    _socket.connect();
  }

  final ChatRemoteDataSource _chat;
  final MatchesRemoteDataSource _matchesRemote;
  final ChatSocket _socket;
  final Guard _guard;
  final String _imageBaseUrl;

  // Slow: the socket does the live work, this only catches what it missed.
  static const _listEvery = Duration(seconds: 30);
  static const _threadEvery = Duration(seconds: 15);
  static const _listPageSize = 50;
  static const _maxListPages = 10;
  static const _matchesPageSize = 50;
  static const _maxMatchPages = 10;
  static const _threadPageSize = 30;

  /// Free plan's conversation slots; the Chat tab draws this many.
  static const _slotCount = 5;

  final _changes = StreamController<void>.broadcast();
  final _subs = <StreamSubscription<Object?>>[];
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

  /// "View profile" data from `my-matches`, by peer id (every match, with or
  /// without a conversation).
  final _profileById = <String, PeerProfile>{};

  /// Partners of chats the user archived: kept out of the Matches panel until
  /// the chat is restored.
  final _archivedPeerIds = <String>{};

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
    await Future.wait([
      _fetchConversations(),
      // The Matches panel is secondary: if it can't load (or can't be
      // parsed) the conversations must still show.
      _fetchMatches().catchError((Object _) {}),
      _fetchArchivedPeers(),
    ]);
  }

  Future<void> _fetchArchivedPeers() async {
    try {
      final ids = <String>{};
      for (var page = 1; page <= _maxListPages; page++) {
        final res = await _chat.fetchConversations(
          page: page,
          limit: _listPageSize,
          archived: true,
        );
        for (final r in res.data.conversations) {
          if (r.partner?.id case final id? when id.isNotEmpty) ids.add(id);
        }
        if (!res.data.pagination.hasNext) break;
      }
      _archivedPeerIds
        ..clear()
        ..addAll(ids);
      _notify();
    } on Object {
      // Keep the last known set; the next poll retries.
    }
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
        final peer = m.toPeerDto(imageBaseUrl: _imageBaseUrl);
        if (peer == null) continue;
        if (m.toPeerProfile(imageBaseUrl: _imageBaseUrl) case final profile?) {
          _profileById[peer.id] = profile;
        }
        // A match that can no longer be messaged (ended) isn't offered as
        // a new conversation.
        if (m.canMessage) peers.add(peer);
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
        isOnline: partner?.isOnline ?? false,
        lastSeenAt: (partner?.isOnline ?? false)
            ? null
            : partner?.lastActiveAt?.toLocal(),
        matchId: row.matchId,
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
      isMuted: row.isMuted,
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
        if (_slotOf[c.id]! < _slotCount)
          _enrich(c.copyWith(slot: _slotOf[c.id])),
    ]..sort((a, b) => a.slot.compareTo(b.slot));
  }

  /// Matches not already in a slot.
  List<ChatPeer> _panelMatches() {
    final inSlots = {for (final c in _slotted()) c.peer.id};
    return [
      for (final m in _matchesById.values)
        if (!inSlots.contains(m.id) && !_archivedPeerIds.contains(m.id))
          m.toEntity().copyWith(profile: _profileById[m.id]),
    ];
  }

  /// The conversation with its peer's profile attached, when known.
  Conversation _enrich(Conversation c) {
    final profile = _profileById[c.peer.id];
    return profile == null || c.peer.profile == profile
        ? c
        : c.copyWith(peer: c.peer.copyWith(profile: profile));
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
    // (the room gets the profile through `_enrich` below)
    final base = known ?? Conversation(id: id, peer: peer, slot: 0);
    _byId[id] = base;
    if (!_order.contains(id)) _order.insert(0, id);
    _startedPeers.putIfAbsent(peerId, () => slot);
    _peerOf[id] = peerId;
    _notify();
    return _slotted().firstWhere(
      (c) => c.id == id,
      // Past the slot limit: still openable, just not on the tab.
      orElse: () => _enrich(base),
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
    // Fetching them is what "delivered" means for messages that arrived
    // while the socket was down.
    final peerId = _peerIdOf(conversationId);
    if (res.data.messages.any(
      (m) => m.senderId == peerId && !m.isDelivered && !m.seen,
    )) {
      unawaited(_guard(() => _chat.markDelivered(conversationId)));
    }
  }

  void _merge(String conversationId, List<MessageDto> incoming) {
    final held = _messages[conversationId] ?? const <ChatMessage>[];
    final byId = {for (final m in held) m.id: m};
    for (final dto in incoming) {
      if (dto.deletedForMe) {
        byId.remove(dto.id);
        continue;
      }
      if (dto.text.isEmpty && dto.attachmentUrl == null) continue;
      byId[dto.id] = _messageOf(conversationId, dto);
    }
    _messages[conversationId] = byId.values.toList()
      ..sort((a, b) => a.sentAt.compareTo(b.sentAt));
  }

  ChatMessage _messageOf(String conversationId, MessageDto dto) {
    final mine = dto.senderId != _peerIdOf(conversationId);
    final attachment = dto.attachmentUrl;
    return ChatMessage(
      id: dto.id,
      conversationId: conversationId,
      text: dto.text,
      sentAt: dto.createdAt.toLocal(),
      isMine: mine,
      status: dto.seen
          ? MessageStatus.seen
          : dto.isDelivered
          ? MessageStatus.delivered
          : MessageStatus.sent,
      imageUrl: dto.messageType == 'image' && attachment != null
          ? resolveImageUrl(_imageBaseUrl, attachment)
          : null,
      replyTo: switch (dto.replyTo) {
        null => null,
        final r => MessageReply(
          messageId: r.id,
          isMine: r.senderId != _peerIdOf(conversationId),
          text: r.deletedForMe
              ? 'Message deleted'
              : r.messageType == 'image'
              ? 'Photo'
              : r.text,
        ),
      },
    );
  }

  /// The other side of [conversationId], from whichever store knows it.
  String? _peerIdOf(String conversationId) =>
      _peerOf[conversationId] ?? _byId[conversationId]?.peer.id;

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
  Stream<bool> watchPeerTyping(String conversationId) async* {
    yield _peerTyping[conversationId] ?? false;
    yield* _typingChanges.stream
        .where((id) => id == conversationId)
        .map((_) => _peerTyping[conversationId] ?? false)
        .distinct();
  }

  @override
  Future<Either<Failure, Unit>> sendMessage({
    required String conversationId,
    required String text,
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
        replyTo: _quoteOf(conversationId, replyToMessageId),
      ),
    );
    final sent = await _guard(
      () => _chat.sendMessage(
        conversationId,
        SendMessageBodyDto(text: text, replyToId: replyToMessageId),
      ),
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

  /// The held message [id], shaped as a quote, for the optimistic bubble.
  MessageReply? _quoteOf(String conversationId, String? id) {
    if (id == null) return null;
    final m = _messages[conversationId]?.where((m) => m.id == id).firstOrNull;
    if (m == null) return null;
    return MessageReply(
      messageId: m.id,
      isMine: m.isMine,
      text: m.isImage ? 'Photo' : m.text,
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
        _clearUnread(conversationId);
        return unit;
      });

  void _clearUnread(String conversationId) {
    final c = _byId[conversationId];
    if (c != null && c.hasUnread) {
      _unread = (_unread - c.unreadCount).clamp(0, 1 << 30);
      _byId[conversationId] = c.copyWith(unreadCount: 0);
      _notify();
    }
  }

  // ── Realtime (socket) ─────────────────────────────────────────────────

  /// The room on screen: incoming messages there are seen, not just
  /// delivered.
  String? _openRoom;

  @override
  void enterConversation(String conversationId) {
    _openRoom = conversationId;
    _socket.join(conversationId);
  }

  @override
  void leaveConversation(String conversationId) {
    if (_openRoom == conversationId) _openRoom = null;
    _socket.leave(conversationId);
    _stopTypingNow(conversationId);
  }

  var _firstConnection = true;

  /// A reconnect means events may have been missed: refetch the list and
  /// the open thread. (The first connect is covered by the initial load.)
  void _onConnection(bool connected) {
    if (!connected) return;
    final isFirst = _firstConnection;
    _firstConnection = false;
    if (isFirst) return;
    unawaited(_resync());
  }

  Future<void> _resync() async {
    try {
      if (_firstLoad != null) await _refreshList();
      final room = _openRoom;
      if (room != null) {
        _socket.join(room);
        await _refreshThread(room);
      }
      await _refreshUnread();
    } on Object {
      // The slow poll retries.
    }
  }

  void _onSocketMessage(MessageDto dto) {
    final id = dto.conversationId;
    if (id.isEmpty) return;
    if (!_byId.containsKey(id)) {
      // A conversation we have not listed yet (a new match messaging first).
      if (_firstLoad != null) unawaited(_refreshList().catchError((_) {}));
      return;
    }
    final mine = dto.senderId != _peerIdOf(id);
    final held = _messages[id];
    if (held != null) {
      final local = mine
          ? held.where(
              (m) =>
                  m.id.startsWith('local-') &&
                  m.status == MessageStatus.sending &&
                  m.text == dto.text &&
                  m.imageUrl == null,
            )
          : const <ChatMessage>[];
      // Our own send echoed from another device or ahead of the REST
      // response: drop the optimistic copy it replaces.
      if (local.isNotEmpty) held.remove(local.first);
      _merge(id, [dto]);
    }
    final c = _byId[id]!;
    final preview = dto.messageType == 'image' ? 'Photo' : dto.text;
    final isOpen = _openRoom == id;
    if (!mine) {
      // Conversation-level receipts: the server broadcasts those to the
      // sender, but not the per-message socket ones (verified live).
      if (isOpen) {
        _socket.emitSeen(conversationId: id);
        unawaited(_guard(() => _chat.markRead(id)));
      } else {
        _socket.emitDelivered(conversationId: id);
        _unread++;
      }
      _setPeerTyping(id, typing: false);
    }
    _byId[id] = c.copyWith(
      lastMessage: ChatMessage(
        id: 'last-$id',
        conversationId: id,
        text: preview,
        sentAt: dto.createdAt.toLocal(),
        isMine: mine,
      ),
      unreadCount: mine || isOpen ? c.unreadCount : c.unreadCount + 1,
    );
    _order
      ..remove(id)
      ..insert(0, id);
    _notify();
  }

  /// A delivered / seen receipt is about messages this user sent.
  ///
  /// The server sends each receipt to both users, so first check it came
  /// from the peer: a `seenBy` that isn't the peer is our own read; a
  /// `deliveredTo` that is the peer means it was addressed to them.
  void _onDelivered(SocketReceipt r) => _onReceipt(r, MessageStatus.delivered);

  void _onSeen(SocketReceipt r) => _onReceipt(r, MessageStatus.seen);

  /// Receipts reach only the sender, and `by` is whoever received / read —
  /// so it must be the peer. Anything else (our own echo) is ignored.
  void _onReceipt(SocketReceipt r, MessageStatus to) {
    final peer = _peerIdOf(r.conversationId);
    if (r.by != null && peer != null && r.by != peer) return;
    _applyReceipt(r, to);
  }

  void _applyReceipt(SocketReceipt r, MessageStatus to) {
    final list = _messages[r.conversationId];
    if (list == null) return;
    final ids = r.messageIds.toSet();
    var changed = false;
    for (var i = 0; i < list.length; i++) {
      final m = list[i];
      // By id when the server named them, else everything up to the time.
      final hit = ids.isNotEmpty
          ? ids.contains(m.id)
          : m.isMine && !m.isCall && !m.sentAt.isAfter(r.at.toLocal());
      // Ticks only move forward.
      if (hit &&
          m.isMine &&
          !m.id.startsWith('local-') &&
          m.status.index < to.index) {
        list[i] = m.copyWith(status: to);
        changed = true;
      }
    }
    if (changed) _notify();
  }

  // ── Presence ──

  void _onPresence(SocketPresence p) {
    var changed = false;
    for (final entry in _byId.entries.toList()) {
      final c = entry.value;
      if (c.peer.id != p.userId) continue;
      _byId[entry.key] = c.copyWith(
        peer: c.peer.copyWith(
          isOnline: p.online,
          lastSeenAt: p.online ? null : (p.lastActiveAt?.toLocal()),
        ),
      );
      changed = true;
    }
    if (_matchesById[p.userId] case final m?) {
      _matchesById[p.userId] = ChatPeerDto(
        id: m.id,
        name: m.name,
        photoUrl: m.photoUrl,
        isOnline: p.online,
        lastSeenAt: p.online ? null : p.lastActiveAt ?? m.lastSeenAt,
        matchId: m.matchId,
      );
      changed = true;
    }
    if (changed) _notify();
  }

  @override
  Stream<ChatPeer> watchPeer(String conversationId) async* {
    ChatPeer? last;
    ChatPeer? read() => _byId[conversationId]?.peer;
    last = read();
    if (last != null) yield last;
    await for (final _ in _changes.stream) {
      final now = read();
      if (now != null && now != last) {
        last = now;
        yield now;
      }
    }
  }

  // ── Typing ──

  final _peerTyping = <String, bool>{};
  final _typingChanges = StreamController<String>.broadcast();
  final _typingExpiry = <String, Timer>{};

  void _onTyping(SocketTyping t) {
    if (t.from != _peerIdOf(t.conversationId)) return;
    _setPeerTyping(t.conversationId, typing: t.typing);
  }

  void _setPeerTyping(String conversationId, {required bool typing}) {
    _typingExpiry.remove(conversationId)?.cancel();
    if ((_peerTyping[conversationId] ?? false) == typing) {
      if (!typing) return;
    }
    _peerTyping[conversationId] = typing;
    // A lost `stop_typing` must not leave the bubble up for good.
    if (typing) {
      _typingExpiry[conversationId] = Timer(
        const Duration(seconds: 6),
        () => _setPeerTyping(conversationId, typing: false),
      );
    }
    if (!_typingChanges.isClosed) _typingChanges.add(conversationId);
  }

  DateTime? _typingSentAt;
  Timer? _typingIdle;

  @override
  void setTyping(String conversationId, {required bool typing}) {
    if (!typing) {
      _stopTypingNow(conversationId);
      return;
    }
    final now = DateTime.now();
    // One `typing` per 3s is enough to keep the peer's bubble up.
    if (_typingSentAt == null ||
        now.difference(_typingSentAt!) > const Duration(seconds: 3)) {
      _typingSentAt = now;
      _socket.emitTyping(conversationId, typing: true);
    }
    _typingIdle?.cancel();
    _typingIdle = Timer(
      const Duration(seconds: 4),
      () => _stopTypingNow(conversationId),
    );
  }

  void _stopTypingNow(String conversationId) {
    _typingIdle?.cancel();
    _typingIdle = null;
    if (_typingSentAt == null) return;
    _typingSentAt = null;
    _socket.emitTyping(conversationId, typing: false);
  }

  // ── Images, delete, unread, archive, safety ───────────────────────────

  @override
  Future<Either<Failure, Unit>> sendImage({
    required String conversationId,
    required String path,
  }) async {
    final localId = 'local-${++_seq}';
    _put(
      conversationId,
      ChatMessage(
        id: localId,
        conversationId: conversationId,
        text: '',
        sentAt: DateTime.now(),
        isMine: true,
        status: MessageStatus.sending,
        imageUrl: path,
      ),
    );
    final sent = await _guard(
      () async => _chat.sendImage(
        conversationId,
        await MultipartFile.fromFile(path, filename: 'photo.jpg'),
      ),
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
        final list = _messages[conversationId]!
          ..removeWhere((m) => m.id == localId || m.id == res.data.id);
        list
          ..add(_messageOf(conversationId, res.data))
          ..sort((a, b) => a.sentAt.compareTo(b.sentAt));
        _bumpPreview(conversationId, 'Photo');
        _notify();
        return right(unit);
      },
    );
  }

  @override
  Future<Either<Failure, Unit>> deleteMessage({
    required String conversationId,
    required String messageId,
  }) => _guard(() async {
    if (!messageId.startsWith('local-')) await _chat.deleteMessage(messageId);
    _messages[conversationId]?.removeWhere((m) => m.id == messageId);
    _notify();
    return unit;
  });

  var _unread = 0;

  Future<void> _refreshUnread() async {
    final res = await _chat.unreadCount();
    _unread = res.data.count;
    _notify();
  }

  @override
  Stream<int> watchUnreadCount() => _live<int>(
    first: _refreshUnread,
    refresh: _refreshUnread,
    read: () => _unread,
    every: _listEvery,
  ).distinct();

  @override
  Future<Either<Failure, List<Conversation>>> fetchArchived() =>
      _guard(() async {
        final rows = <ConversationRowDto>[];
        for (var page = 1; page <= _maxListPages; page++) {
          final res = await _chat.fetchConversations(
            page: page,
            limit: _listPageSize,
            archived: true,
          );
          rows.addAll(res.data.conversations);
          if (!res.data.pagination.hasNext) break;
        }
        return [for (final r in rows) _conversationOf(r)];
      });

  @override
  Future<Either<Failure, Unit>> setArchived(
    String conversationId, {
    required bool archived,
  }) => _guard(() async {
    await _chat.archive(conversationId, ArchiveBodyDto(archived: archived));
    if (archived) {
      if (_byId[conversationId]?.peer.id case final peerId?) {
        _archivedPeerIds.add(peerId);
      }
      _dropConversation(conversationId);
    } else {
      await _refreshList();
    }
    return unit;
  });

  /// Gone from the slots (archived / unmatched / blocked); its slot frees.
  void _dropConversation(String conversationId) {
    final peerId = _byId[conversationId]?.peer.id;
    _byId.remove(conversationId);
    _order.remove(conversationId);
    _slotOf.remove(conversationId);
    _messages.remove(conversationId);
    if (peerId != null) _startedPeers.remove(peerId);
    _notify();
  }

  @override
  Future<Either<Failure, Unit>> blockUser(String peerId) => _guard(() async {
    await _chat.block(peerId);
    final id = _byId.values.where((c) => c.peer.id == peerId).firstOrNull?.id;
    if (id != null) _dropConversation(id);
    _matchesById.remove(peerId);
    _notify();
    return unit;
  });

  @override
  Future<Either<Failure, Unit>> unmatch(String matchId) => _guard(() async {
    await _chat.unmatch(matchId);
    // The conversation closes server-side; refetch so list and matches agree.
    await _refreshList();
    return unit;
  });

  @override
  Future<Either<Failure, Unit>> reportUser({
    required String peerId,
    required String reason,
    String? description,
  }) => _guard(() async {
    await _chat.report(
      ReportBodyDto(
        targetUserId: peerId,
        reason: reason,
        description: description,
      ),
    );
    return unit;
  });

  @override
  Future<Either<Failure, Unit>> setMuted(
    String conversationId, {
    required bool muted,
  }) => _guard(() async {
    await _chat.mute(conversationId, MuteBodyDto(muted: muted));
    final c = _byId[conversationId];
    if (c != null) {
      _byId[conversationId] = c.copyWith(isMuted: muted);
      _notify();
    }
    return unit;
  });

  @override
  Future<Either<Failure, Unit>> clearChat(String conversationId) =>
      _guard(() async {
        await _chat.clearChat(conversationId);
        _messages[conversationId]?.clear();
        _hasMore[conversationId] = false;
        final c = _byId[conversationId];
        if (c != null) {
          // Stays in its slot (as a fresh chat) instead of dropping to the
          // Matches panel.
          _startedPeers.putIfAbsent(c.peer.id, () => null);
          _byId[conversationId] = c.copyWith(
            lastMessage: null,
            unreadCount: 0,
          );
        }
        _notify();
        return unit;
      });

  @override
  Future<Either<Failure, List<ChatPeer>>> fetchUnmatched() => _guard(() async {
    final out = <ChatPeer>[];
    for (var page = 1; page <= _maxMatchPages; page++) {
      final res = await _matchesRemote.fetchUnmatched(
        page: page,
        limit: _matchesPageSize,
      );
      for (final m in res.data.matches) {
        if (m.toPeerDto(imageBaseUrl: _imageBaseUrl) case final p?) {
          out.add(p.toEntity());
        }
      }
      if (!res.data.pagination.hasNext) break;
    }
    return out;
  });

  @override
  Future<void> refresh() async {
    try {
      if (_firstLoad == null) {
        await _ensureListLoaded();
      } else {
        await _refreshList();
      }
    } on Object {
      // The slow poll retries; a failed refresh must not break the caller.
    }
  }

  static const _blocksPageSize = 50;

  @override
  Future<Either<Failure, List<BlockedUser>>> fetchBlocked() => _guard(() async {
    final out = <BlockedUser>[];
    for (var page = 1; page <= _maxListPages; page++) {
      final res = await _chat.fetchBlocks(page: page, limit: _blocksPageSize);
      for (final b in res.blocks) {
        if (b.userId.isEmpty) continue;
        final photo = b.photoUrl;
        out.add(
          BlockedUser(
            id: b.userId,
            name: b.name ?? '',
            photoUrl: photo == null || photo.isEmpty
                ? ''
                : resolveImageUrl(_imageBaseUrl, photo),
          ),
        );
      }
      if (!res.hasNext) break;
    }
    return out;
  });

  @override
  Future<Either<Failure, PeerProfile>> fetchPeerProfile(String peerId) =>
      _guard(() async {
        final res = await _matchesRemote.fetchProfile(peerId);
        final data = res is Map ? res['data'] : null;
        final p = data is Map ? data['profile'] : null;
        final full = p is Map
            ? _profileDetails(Map<String, dynamic>.from(p))
            : const PeerProfile();
        final held = _profileById[peerId];
        final merged = held == null ? full : held.withDetails(full);
        _profileById[peerId] = merged;
        return merged;
      });

  /// The about-me / languages / practices / lifestyle of a full profile.
  PeerProfile _profileDetails(Map<String, dynamic> p) {
    List<String> list(Object? v) => [
      if (v is List)
        for (final x in v)
          if (x is String && x.trim().isNotEmpty) x.trim(),
    ];
    final life = p['lifestyle'];
    String? flag(String key, String yes, String no) {
      final v = life is Map ? life[key] : null;
      return v is bool ? (v ? yes : no) : null;
    }

    final about = p['aboutMe'];
    return PeerProfile(
      about: about is String && about.trim().isNotEmpty ? about.trim() : null,
      languages: list(p['languages']),
      practices: list(p['religiousPractices']),
      lifestyle: [
        ?flag('halalFood', 'Eats halal food', 'Does not require halal food'),
        ?flag('smoking', 'Smokes', "Doesn't smoke"),
        ?flag('alcohol', 'Drinks alcohol', "Doesn't drink alcohol"),
      ],
      images: [
        for (final i in list(p['images'])) resolveImageUrl(_imageBaseUrl, i),
      ],
      country: p['country'] is String ? p['country'] as String : null,
    );
  }

  @override
  Future<Either<Failure, Unit>> unblockUser(String userId) => _guard(() async {
    await _chat.unblock(userId);
    // They may be matchable / chattable again: refetch.
    await refresh();
    return unit;
  });

  // ── Plumbing ──────────────────────────────────────────────────────────

  void _notify() {
    _syncLastStatuses();
    if (!_changes.isClosed) _changes.add(null);
  }

  /// The list row's last message is a stub built from the list preview, so it
  /// never learns about receipts. When the thread is held and its newest
  /// message is ours, the row takes that message's tick.
  void _syncLastStatuses() {
    for (final entry in _messages.entries) {
      final c = _byId[entry.key];
      final last = c?.lastMessage;
      if (c == null || last == null || !last.isMine || entry.value.isEmpty) {
        continue;
      }
      final newest = entry.value.last;
      if (newest.isMine && !newest.isCall && newest.status != last.status) {
        _byId[entry.key] = c.copyWith(
          lastMessage: last.copyWith(status: newest.status),
        );
      }
    }
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

  Future<void> dispose() async {
    for (final sub in _subs) {
      await sub.cancel();
    }
    for (final t in _typingExpiry.values) {
      t.cancel();
    }
    _typingIdle?.cancel();
    await _socket.dispose();
    await _typingChanges.close();
    await _changes.close();
  }
}
