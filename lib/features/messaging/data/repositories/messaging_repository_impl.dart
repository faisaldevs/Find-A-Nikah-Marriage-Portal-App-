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
  void _onDelivered(SocketReceipt r) {
    final peer = _peerIdOf(r.conversationId);
    if (r.deliveredTo != null && r.deliveredTo == peer) return;
    _applyReceipt(r, MessageStatus.delivered);
  }

  void _onSeen(SocketReceipt r) {
    final peer = _peerIdOf(r.conversationId);
    if (r.seenBy != null && r.seenBy != peer) return;
    _applyReceipt(r, MessageStatus.seen);
  }

  void _applyReceipt(SocketReceipt r, MessageStatus to) {
    final list = _messages[r.conversationId];
    if (list == null) return;
    var changed = false;
    for (var i = 0; i < list.length; i++) {
      final m = list[i];
      final hit = r.messageId != null
          ? m.id == r.messageId
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
