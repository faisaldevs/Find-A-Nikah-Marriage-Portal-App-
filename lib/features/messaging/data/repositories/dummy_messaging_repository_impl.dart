import 'package:find_a_nikah/core/core.dart';
import 'package:find_a_nikah/features/messaging/data/datasources/dummy_messaging_data_source.dart';
import 'package:find_a_nikah/features/messaging/data/datasources/matches_remote_data_source.dart';
import 'package:find_a_nikah/features/messaging/data/dtos/chat_peer_dto.dart';
import 'package:find_a_nikah/features/messaging/data/mappers/messaging_mappers.dart';
import 'package:find_a_nikah/features/messaging/domain/domain.dart';

/// Dev fallback kept after the live repository replaced it: dummy chats +
/// live matches. Not registered in DI; swap it back in `di.dart` to demo
/// without a backend.
///
/// Session-scoped: holds the signed-in user's chats, dropped on sign-out.
///
/// Matches are live (`GET /v1/matches/my-matches`); conversations and
/// messages are still [DummyMessagingDataSource] until the chat API is
/// wired, so a picked real match opens a fake conversation.
class DummyMessagingRepositoryImpl implements MessagingRepository {
  // const DummyMessagingRepositoryImpl(this._dummy, this._guard);
  /// [_imageBaseUrl]: server root that `/public/upload/...` photo paths
  /// hang off.
  DummyMessagingRepositoryImpl(
    this._dummy,
    this._matchesRemote,
    this._guard,
    this._imageBaseUrl,
  );

  // Dev-only for now — no chat API or socket exists yet.
  final DummyMessagingDataSource _dummy;
  final MatchesRemoteDataSource _matchesRemote;
  final Guard _guard;
  final String _imageBaseUrl;

  /// Last fetched matches by peer id — hands a picked match's name and
  /// photo to the fake conversation store.
  final _matchesById = <String, ChatPeerDto>{};

  /// Page size for `my-matches`, and how many pages to read at most.
  static const _matchesPageSize = 50;
  static const _maxMatchPages = 10;

  @override
  Stream<List<Conversation>> watchConversations() =>
      _dummy.watchConversations().map(
        (list) => [for (final c in list) c.toEntity(myId: _dummy.meId)],
      );

  // Before: the fixture's matches.
  // @override
  // Stream<List<ChatPeer>> watchMatches() => _dummy.watchMatches().map(
  //   (list) => [for (final p in list) p.toEntity()],
  // );

  /// Fetched once per subscription, then re-filtered whenever the
  /// conversation list changes: a match already in a slot leaves the
  /// panel. A failed fetch errors the stream (the bloc keeps the last
  /// list).
  @override
  Stream<List<ChatPeer>> watchMatches() async* {
    final matches = await _fetchMatches();
    yield* _dummy.watchConversations().map((conversations) {
      final started = {for (final c in conversations) c.peer.id};
      return [
        for (final m in matches)
          if (!started.contains(m.id)) m.toEntity(),
      ];
    });
  }

  /// Every page of `my-matches` (up to [_maxMatchPages]), as peers.
  Future<List<ChatPeerDto>> _fetchMatches() async {
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
    return peers;
  }

  // @override
  // Future<Either<Failure, Conversation>> openConversation(
  //   String peerId, {
  //   int? slot,
  // }) => _guard(
  //   () async => (await _dummy.openConversation(
  //     peerId,
  //     slot: slot,
  //   )).toEntity(myId: _dummy.meId),
  // );

  @override
  Future<Either<Failure, Conversation>> openConversation(
    String peerId, {
    int? slot,
  }) => _guard(
    () async => (await _dummy.openConversation(
      peerId,
      slot: slot,
      peer: _matchesById[peerId],
    )).toEntity(myId: _dummy.meId),
  );

  @override
  Stream<List<ChatMessage>> watchMessages(String conversationId) => _dummy
      .watchMessages(conversationId)
      .map(
        (list) => [for (final m in list) m.toEntity(myId: _dummy.meId)],
      );

  @override
  Stream<bool> watchPeerTyping(String conversationId) =>
      _dummy.watchPeerTyping(conversationId);

  // The fixture holds the whole thread already.
  @override
  Future<Either<Failure, bool>> loadOlderMessages(String conversationId) =>
      _guard(() async => false);

  @override
  Future<Either<Failure, Unit>> sendMessage({
    required String conversationId,
    required String text,
    String? replyToMessageId,
  }) => _guard(() async {
    await _dummy.sendMessage(
      conversationId: conversationId,
      text: text,
      replyToMessageId: replyToMessageId,
    );
    return unit;
  });

  @override
  Future<Either<Failure, Unit>> logCall({
    required String conversationId,
    required CallLog log,
  }) => _guard(() async {
    await _dummy.logCall(
      conversationId: conversationId,
      outcome: log.outcome.name,
      outgoing: log.outgoing,
      durationSeconds: log.duration.inSeconds,
    );
    return unit;
  });

  @override
  Future<Either<Failure, Unit>> markRead(String conversationId) =>
      _guard(() async {
        await _dummy.markRead(conversationId);
        return unit;
      });

  // The dummy source has no socket, images, archive or safety actions: these
  // are inert so the dummy repository still satisfies the interface.
  @override
  void enterConversation(String conversationId) {}

  @override
  void leaveConversation(String conversationId) {}

  @override
  void setTyping(String conversationId, {required bool typing}) {}

  @override
  Future<Either<Failure, Unit>> sendImage({
    required String conversationId,
    required String path,
  }) async => right(unit);

  @override
  Future<Either<Failure, Unit>> deleteMessage({
    required String conversationId,
    required String messageId,
  }) async => right(unit);

  @override
  Stream<int> watchUnreadCount() => Stream<int>.value(0);

  @override
  Future<Either<Failure, List<Conversation>>> fetchArchived() async =>
      right(const <Conversation>[]);

  @override
  Future<Either<Failure, Unit>> setArchived(
    String conversationId, {
    required bool archived,
  }) async => right(unit);

  @override
  Future<Either<Failure, Unit>> blockUser(String peerId) async => right(unit);

  @override
  Future<Either<Failure, Unit>> unmatch(String matchId) async => right(unit);

  @override
  Future<Either<Failure, Unit>> reportUser({
    required String peerId,
    required String reason,
    String? description,
  }) async => right(unit);

  @override
  Stream<ChatPeer> watchPeer(String conversationId) => const Stream.empty();

  @override
  Future<Either<Failure, Unit>> setMuted(
    String conversationId, {
    required bool muted,
  }) async => right(unit);

  @override
  Future<Either<Failure, Unit>> clearChat(String conversationId) async =>
      right(unit);

  @override
  Future<Either<Failure, List<ChatPeer>>> fetchUnmatched() async =>
      right(const <ChatPeer>[]);

  @override
  Future<void> refresh() async {}

  @override
  Future<Either<Failure, List<BlockedUser>>> fetchBlocked() async =>
      right(const <BlockedUser>[]);

  @override
  Future<Either<Failure, Unit>> unblockUser(String userId) async => right(unit);

  Future<void> dispose() => _dummy.dispose();
}
