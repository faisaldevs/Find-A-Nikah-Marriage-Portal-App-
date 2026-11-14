import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart' show MultipartFile;
import 'package:find_a_nikah/core/core.dart';
import 'package:find_a_nikah/core/network/api_exception.dart';
import 'package:find_a_nikah/features/messaging/data/data.dart';
import 'package:find_a_nikah/features/messaging/data/dtos/blocks_dto.dart';
import 'package:find_a_nikah/features/messaging/data/dtos/chat_api_dtos.dart';
import 'package:find_a_nikah/features/messaging/data/dtos/my_matches_dto.dart';
import 'package:find_a_nikah/features/messaging/domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/fakes.dart';

class _MockChat extends Mock implements ChatRemoteDataSource {}

class _FakeMatches implements MatchesRemoteDataSource {
  /// What `GET /profiles/:id` returns; tests set it.
  Object? profileResponse = <String, dynamic>{};

  @override
  Future<dynamic> fetchProfile(String userId) async => profileResponse;

  _FakeMatches([this.matches = const []]);

  final List<Map<String, dynamic>> matches;
  final List<Map<String, dynamic>> unmatched = [];

  @override
  Future<MyMatchesResponseDto> fetchUnmatched({
    String status = 'unmatched',
    required int page,
    required int limit,
  }) async => MyMatchesResponseDto.fromJson({
    'data': {'matches': unmatched, 'pagination': <String, Object>{}},
  });

  @override
  Future<MyMatchesResponseDto> fetchMyMatches({
    required int page,
    required int limit,
  }) async => MyMatchesResponseDto.fromJson({
    'data': {'matches': matches, 'pagination': <String, Object>{}},
  });
}

class _ThrowingMatches implements MatchesRemoteDataSource {
  @override
  Future<dynamic> fetchProfile(String userId) async => <String, dynamic>{};

  @override
  Future<MyMatchesResponseDto> fetchUnmatched({
    String status = 'unmatched',
    required int page,
    required int limit,
  }) async => throw const FormatException('bad');

  @override
  Future<MyMatchesResponseDto> fetchMyMatches({
    required int page,
    required int limit,
  }) async => throw const FormatException('bad matches payload');
}

Map<String, dynamic> _match(
  String peerId, {
  bool canMessage = true,
  String? conversationId,
}) => {
  'matchId': 'm-$peerId',
  'canMessage': canMessage,
  'conversationId': conversationId,
  'partner': {'_id': peerId, 'fullName': 'Name $peerId'},
  'profile': {
    'userId': peerId,
    'fullName': 'Name $peerId',
    'photoUrl': '/public/upload/$peerId.jpg',
    'images': ['/public/upload/$peerId.jpg', '/public/upload/$peerId-2.jpg'],
    'age': 27,
    // The API sends these as lists (a string must work too).
    'faith': <String>[],
    'sect': ['sunni'],
    'maritalStatus': 'never_married',
    'city': 'Dhaka',
    'country': 'Bangladesh',
    'professionTitle': 'Consultant',
    'isVerified': true,
  },
};

class _FakeSocket implements ChatSocket {
  final messagesC = StreamController<MessageDto>.broadcast();
  final deliveredC = StreamController<SocketReceipt>.broadcast();
  final seenC = StreamController<SocketReceipt>.broadcast();
  final typingC = StreamController<SocketTyping>.broadcast();
  final presenceC = StreamController<SocketPresence>.broadcast();
  final deletedC = StreamController<SocketDeleted>.broadcast();
  final conversationUpdatedC =
      StreamController<SocketConversationUpdated>.broadcast();
  final connectionC = StreamController<bool>.broadcast();

  final emitted = <String>[];
  final joined = <String>[];
  var connectCalls = 0;

  @override
  Stream<MessageDto> get messages => messagesC.stream;
  @override
  Stream<SocketReceipt> get delivered => deliveredC.stream;
  @override
  Stream<SocketReceipt> get seen => seenC.stream;
  @override
  Stream<SocketTyping> get typing => typingC.stream;
  @override
  Stream<SocketPresence> get presence => presenceC.stream;
  @override
  Stream<SocketDeleted> get deleted => deletedC.stream;
  @override
  Stream<SocketConversationUpdated> get conversationUpdated =>
      conversationUpdatedC.stream;
  @override
  Stream<bool> get connection => connectionC.stream;
  @override
  bool get isConnected => true;
  @override
  void connect() => connectCalls++;
  @override
  void disconnect() {}
  @override
  void join(String id) => joined.add(id);
  @override
  void leave(String id) => joined.remove(id);
  @override
  void emitDelivered({String? messageId, String? conversationId}) =>
      emitted.add('delivered:${messageId ?? conversationId}');
  @override
  void emitSeen({String? messageId, String? conversationId}) =>
      emitted.add('seen:${messageId ?? conversationId}');
  @override
  void emitTyping(String conversationId, {required bool typing}) =>
      emitted.add('typing:$typing');
  @override
  Future<void> dispose() async {}
}

Map<String, dynamic> _msg(
  String id, {
  required String from,
  String text = 'hi',
  bool delivered = false,
  bool seen = false,
  bool deleted = false,
  String type = 'text',
  String? attachment,
}) => {
  '_id': id,
  'conversationId': 'c1',
  'senderId': from,
  'receiverId': from == 'peer' ? 'me' : 'peer',
  'messageType': type,
  'text': text,
  'attachmentUrl': attachment,
  'isDelivered': delivered || seen,
  'isRead': seen,
  'isSeen': seen,
  'deletedForMe': deleted,
  'createdAt': '2026-11-11T09:00:0${id.length}.000Z',
};

void main() {
  late _MockChat chat;
  late _FakeSocket socket;
  late MessagingRepositoryImpl repo;
  var matchesFake = _FakeMatches();

  MessagingRepositoryImpl _repoWith(List<Map<String, dynamic>> matches) =>
      MessagingRepositoryImpl(
        chat,
        matchesFake = _FakeMatches(matches),
        socket,
        testGuard(),
        'https://api.test',
      );

  setUpAll(() {
    registerFallbackValue(const ArchiveBodyDto(archived: true));
    registerFallbackValue(const MuteBodyDto(muted: true));
    registerFallbackValue(const SendMessageBodyDto(text: ''));
    registerFallbackValue(MultipartFile.fromBytes(const [0]));
  });

  setUp(() {
    chat = _MockChat();
    socket = _FakeSocket();
    when(
      () => chat.fetchConversations(
        page: any(named: 'page'),
        limit: any(named: 'limit'),
        archived: any(named: 'archived'),
      ),
    ).thenAnswer(
      (_) async => ConversationsResponseDto.fromJson({
        'data': {
          'conversations': [
            {
              '_id': 'c1',
              'matchId': 'match1',
              'partner': {'_id': 'peer', 'fullName': 'Amina'},
              'lastMessagePreview': 'old',
              'lastMessageSender': 'peer',
              'lastMessageAt': '2026-11-11T08:00:00.000Z',
              'unreadCount': 0,
            },
          ],
          'pagination': {'hasNext': false},
        },
      }),
    );
    when(() => chat.openConversation('peer')).thenAnswer(
      (_) async => OpenConversationResponseDto.fromJson({
        'data': {'_id': 'c1'},
      }),
    );
    when(
      () => chat.fetchMessages(
        any(),
        limit: any(named: 'limit'),
        before: any(named: 'before'),
      ),
    ).thenAnswer(
      (_) async => MessagesResponseDto.fromJson({
        'data': {
          'messages': [
            _msg('m22', from: 'peer', text: 'salam'),
            _msg('m1', from: 'me', text: 'wa alaikum'),
          ],
          'hasMore': false,
        },
      }),
    );
    when(() => chat.markRead(any())).thenAnswer((_) async {});
    when(() => chat.markDelivered(any())).thenAnswer((_) async {});
    repo = _repoWith(const []);
  });

  tearDown(() => repo.dispose());

  /// Opens c1 and keeps the latest thread / list snapshots.
  late List<ChatMessage> thread;
  late List<Conversation> list;

  Future<void> settle() =>
      Future<void>.delayed(const Duration(milliseconds: 20));

  Future<void> openThread() async {
    thread = const [];
    list = const [];
    final sub = repo.watchConversations().listen((c) => list = c);
    addTearDown(sub.cancel);
    final opened = await repo.openConversation('peer');
    expect(opened.isRight(), isTrue);
    final threadSub = repo.watchMessages('c1').listen((m) => thread = m);
    addTearDown(threadSub.cancel);
    await settle();
  }

  ChatMessage byId(String id) => thread.firstWhere((m) => m.id == id);

  test('conversations still load when the matches request fails', () async {
    await repo.dispose();
    repo = MessagingRepositoryImpl(
      chat,
      _ThrowingMatches(),
      socket,
      testGuard(),
      'https://api.test',
    );
    final rows = await repo.watchConversations().first;
    // c1 has a last message, so it shows even though matches blew up.
    expect(rows.map((c) => c.id), ['c1']);
  });

  test('connects the socket when created', () {
    expect(socket.connectCalls, 1);
  });

  test('server messages map to sent / delivered / seen', () async {
    when(
      () => chat.fetchMessages(
        any(),
        limit: any(named: 'limit'),
        before: any(named: 'before'),
      ),
    ).thenAnswer(
      (_) async => MessagesResponseDto.fromJson({
        'data': {
          'messages': [
            _msg('a', from: 'me'),
            _msg('bb', from: 'me', delivered: true),
            _msg('ccc', from: 'me', seen: true),
          ],
          'hasMore': false,
        },
      }),
    );
    await openThread();
    expect(byId('a').status, MessageStatus.sent);
    expect(byId('bb').status, MessageStatus.delivered);
    expect(byId('ccc').status, MessageStatus.seen);
    expect(thread.every((m) => m.isMine), isTrue);
  });

  test('deleted-for-me messages are hidden; images get a full URL', () async {
    when(
      () => chat.fetchMessages(
        any(),
        limit: any(named: 'limit'),
        before: any(named: 'before'),
      ),
    ).thenAnswer(
      (_) async => MessagesResponseDto.fromJson({
        'data': {
          'messages': [
            _msg('a', from: 'peer', deleted: true),
            _msg(
              'bb',
              from: 'peer',
              text: '',
              type: 'image',
              attachment: '/public/upload/x.jpg',
            ),
          ],
          'hasMore': false,
        },
      }),
    );
    await openThread();
    expect(thread.map((m) => m.id), ['bb']);
    expect(byId('bb').imageUrl, 'https://api.test/public/upload/x.jpg');
  });

  test(
    'socket message in a closed room: appended, delivered, unread +1',
    () async {
      await openThread();
      socket.messagesC.add(
        MessageDto.fromJson(_msg('new', from: 'peer', text: 'are you there')),
      );
      await settle();
      expect(byId('new').text, 'are you there');
      expect(byId('new').isMine, isFalse);
      expect(socket.emitted, contains('delivered:c1'));
      expect(socket.emitted, isNot(contains('seen:c1')));
      expect(list.single.unreadCount, 1);
      expect(list.single.lastMessage!.text, 'are you there');
    },
  );

  test(
    'socket message while the room is open: marked seen, no unread',
    () async {
      await openThread();
      repo.enterConversation('c1');
      expect(socket.joined, ['c1']);
      socket.messagesC.add(MessageDto.fromJson(_msg('new', from: 'peer')));
      await settle();
      expect(socket.emitted, contains('seen:c1'));
      verify(() => chat.markRead('c1')).called(greaterThan(0));
      expect(list.single.unreadCount, 0);
      repo.leaveConversation('c1');
      expect(socket.joined, isEmpty);
    },
  );

  test('the same message from the socket and the poll shows once', () async {
    await openThread();
    final dto = MessageDto.fromJson(_msg('new', from: 'peer'));
    socket.messagesC
      ..add(dto)
      ..add(dto);
    await settle();
    expect(thread.where((m) => m.id == 'new'), hasLength(1));
  });

  test('delivered then seen receipts move ticks forward, never back', () async {
    await openThread();
    expect(byId('m1').status, MessageStatus.sent);

    socket.deliveredC.add(
      SocketReceipt(
        conversationId: 'c1',
        messageIds: const ['m1'],
        by: 'peer',
        at: DateTime.utc(2026, 11, 11, 9),
      ),
    );
    await settle();
    expect(byId('m1').status, MessageStatus.delivered);

    socket.seenC.add(
      SocketReceipt(
        conversationId: 'c1',
        messageIds: const ['m1'],
        by: 'peer',
        at: DateTime.utc(2026, 11, 11, 10),
      ),
    );
    await settle();
    expect(byId('m1').status, MessageStatus.seen);
    // The peer's own message is untouched.
    expect(byId('m22').isMine, isFalse);

    socket.deliveredC.add(
      SocketReceipt(
        conversationId: 'c1',
        messageIds: const ['m1'],
        by: 'peer',
        at: DateTime.utc(2026, 11, 11, 11),
      ),
    );
    await settle();
    expect(byId('m1').status, MessageStatus.seen);
  });

  test('a receipt only touches the messages it names', () async {
    when(
      () => chat.fetchMessages(
        any(),
        limit: any(named: 'limit'),
        before: any(named: 'before'),
      ),
    ).thenAnswer(
      (_) async => MessagesResponseDto.fromJson({
        'data': {
          'messages': [
            _msg('a', from: 'me'),
            _msg('bb', from: 'me'),
          ],
          'hasMore': false,
        },
      }),
    );
    await openThread();
    socket.seenC.add(
      SocketReceipt(
        conversationId: 'c1',
        messageIds: const ['a'],
        by: 'peer',
        at: DateTime.utc(2026, 11, 11, 10),
      ),
    );
    await settle();
    expect(byId('a').status, MessageStatus.seen);
    expect(byId('bb').status, MessageStatus.sent);
  });

  test(
    'a receipt triggered by someone other than the peer is ignored',
    () async {
      await openThread();
      socket.seenC.add(
        SocketReceipt(
          conversationId: 'c1',
          messageIds: const ['m1'],
          by: 'me',
          at: DateTime.utc(2026, 11, 11, 10),
        ),
      );
      await settle();
      expect(byId('m1').status, MessageStatus.sent);
    },
  );

  test('presence flips the peer online and back to last seen', () async {
    await openThread();
    expect(list.single.peer.isOnline, isFalse);
    socket.presenceC.add(const SocketPresence(userId: 'peer', online: true));
    await settle();
    expect(list.single.peer.isOnline, isTrue);
    expect(list.single.peer.lastSeenAt, isNull);

    socket.presenceC.add(
      SocketPresence(
        userId: 'peer',
        online: false,
        lastActiveAt: DateTime.utc(2026, 11, 12, 9),
      ),
    );
    await settle();
    expect(list.single.peer.isOnline, isFalse);
    expect(list.single.peer.lastSeenAt, isNotNull);
  });

  test('watchPeer follows presence', () async {
    await openThread();
    final peers = <ChatPeer>[];
    final sub = repo.watchPeer('c1').listen(peers.add);
    addTearDown(sub.cancel);
    await settle();
    socket.presenceC.add(const SocketPresence(userId: 'peer', online: true));
    await settle();
    expect(peers.first.isOnline, isFalse);
    expect(peers.last.isOnline, isTrue);
  });

  test('a reply is sent with replyToId and read back as a quote', () async {
    when(
      () => chat.sendMessage(any(), any()),
    ).thenAnswer(
      (_) async => SendMessageResponseDto.fromJson({
        'data': {
          ..._msg('m9', from: 'me', text: 'answer'),
          'replyToId': 'm22',
          'replyTo': {
            '_id': 'm22',
            'senderId': 'peer',
            'messageType': 'text',
            'text': 'salam',
            'deletedForMe': false,
          },
        },
      }),
    );
    await openThread();
    await repo.sendMessage(
      conversationId: 'c1',
      text: 'answer',
      replyToMessageId: 'm22',
    );
    final body =
        verify(() => chat.sendMessage('c1', captureAny())).captured.single
            as SendMessageBodyDto;
    expect(body.replyToId, 'm22');
    expect(body.toJson(), {'text': 'answer', 'replyToId': 'm22'});
    await settle();
    final quote = byId('m9').replyTo!;
    expect(quote.messageId, 'm22');
    expect(quote.text, 'salam');
    expect(quote.isMine, isFalse); // it quotes the peer
  });

  test('a message without a reply sends no replyToId', () {
    expect(const SendMessageBodyDto(text: 'hi').toJson(), {'text': 'hi'});
  });

  test('mute and unmute call the API and update the chat', () async {
    when(() => chat.mute(any(), any())).thenAnswer((_) async {});
    await openThread();
    expect(list.single.isMuted, isFalse);
    await repo.setMuted('c1', muted: true);
    await settle();
    expect(list.single.isMuted, isTrue);
    final body =
        verify(() => chat.mute('c1', captureAny())).captured.single
            as MuteBodyDto;
    expect(body.toJson(), {'muted': true});
  });

  test(
    'clear chat empties the thread but keeps the chat in its slot',
    () async {
      when(() => chat.clearChat('c1')).thenAnswer((_) async {});
      await openThread();
      expect(thread, isNotEmpty);
      final res = await repo.clearChat('c1');
      expect(res.isRight(), isTrue);
      await settle();
      expect(thread, isEmpty);
      expect(list.single.lastMessage, isNull);
      expect(list, hasLength(1));
    },
  );

  test('unmatched people are listed', () async {
    final matches = _FakeMatches()..unmatched.add(_match('ended'));
    await repo.dispose();
    repo = MessagingRepositoryImpl(
      chat,
      matches,
      socket,
      testGuard(),
      'https://api.test',
    );
    final res = await repo.fetchUnmatched();
    expect(res.getOrElse((_) => const []).map((p) => p.id), ['ended']);
  });

  test('peer typing shows, and only for the peer', () async {
    await openThread();
    final seen = <bool>[];
    final sub = repo.watchPeerTyping('c1').listen(seen.add);
    addTearDown(sub.cancel);
    await settle();

    socket.typingC.add(
      const SocketTyping(conversationId: 'c1', from: 'stranger', typing: true),
    );
    await settle();
    expect(seen, [false]);

    socket.typingC.add(
      const SocketTyping(conversationId: 'c1', from: 'peer', typing: true),
    );
    await settle();
    socket.typingC.add(
      const SocketTyping(conversationId: 'c1', from: 'peer', typing: false),
    );
    await settle();
    expect(seen, [false, true, false]);
  });

  test('own typing is throttled and ends with stop_typing', () async {
    repo
      ..setTyping('c1', typing: true)
      ..setTyping('c1', typing: true)
      ..setTyping('c1', typing: true);
    expect(socket.emitted.where((e) => e == 'typing:true'), hasLength(1));
    repo.setTyping('c1', typing: false);
    expect(socket.emitted.last, 'typing:false');
  });

  test('a reconnect refetches the open thread', () async {
    await openThread();
    repo.enterConversation('c1');
    socket.connectionC.add(true); // first connect: nothing to resync
    await settle();
    clearInteractions(chat);
    socket.connectionC.add(false);
    socket.connectionC.add(true);
    await settle();
    verify(
      () => chat.fetchMessages(
        'c1',
        limit: any(named: 'limit'),
        before: any(named: 'before'),
      ),
    ).called(1);
  });

  test('delete for me calls the API and drops the message', () async {
    when(() => chat.deleteMessage('m22')).thenAnswer((_) async {});
    await openThread();
    final res = await repo.deleteMessage(
      conversationId: 'c1',
      messageId: 'm22',
    );
    expect(res.isRight(), isTrue);
    await settle();
    expect(thread.map((m) => m.id), ['m1']);
    verify(() => chat.deleteMessage('m22')).called(1);
  });

  test('a message:deleted event removes it from the thread', () async {
    await openThread();
    expect(thread.map((m) => m.id), contains('m22'));
    socket.deletedC.add(
      const SocketDeleted(conversationId: 'c1', messageId: 'm22'),
    );
    await settle();
    expect(thread.map((m) => m.id), ['m1']);
  });

  test('delete for everyone calls the scoped API and drops the message', () async {
    when(() => chat.deleteMessageForEveryone('m1')).thenAnswer((_) async {});
    await openThread();
    final res = await repo.deleteMessageForEveryone(
      conversationId: 'c1',
      messageId: 'm1',
    );
    expect(res.isRight(), isTrue);
    await settle();
    expect(thread.map((m) => m.id), ['m22']);
    verify(() => chat.deleteMessageForEveryone('m1')).called(1);
  });

  test('a delete-for-everyone that is too late fails with the message', () async {
    when(() => chat.deleteMessageForEveryone('m1')).thenThrow(
      const ForbiddenException('Too late to delete for everyone'),
    );
    await openThread();
    final res = await repo.deleteMessageForEveryone(
      conversationId: 'c1',
      messageId: 'm1',
    );
    expect(res.isLeft(), isTrue);
    expect(thread.map((m) => m.id), contains('m1'));
  });

  test('chatSlots.limit sets the slot limit (Gold = 10)', () async {
    expect(repo.slotLimit, 5);
    when(
      () => chat.fetchConversations(
        page: any(named: 'page'),
        limit: any(named: 'limit'),
        archived: any(named: 'archived'),
      ),
    ).thenAnswer(
      (_) async => ConversationsResponseDto.fromJson({
        'data': {
          'conversations': <Map<String, dynamic>>[],
          'pagination': {'hasNext': false},
          'chatSlots': {'limit': 10, 'used': 3},
        },
      }),
    );
    await repo.refresh();
    expect(repo.slotLimit, 10);
  });

  test('media rows get a readable preview from lastMessageType', () async {
    when(
      () => chat.fetchConversations(
        page: any(named: 'page'),
        limit: any(named: 'limit'),
        archived: any(named: 'archived'),
      ),
    ).thenAnswer(
      (_) async => ConversationsResponseDto.fromJson({
        'data': {
          'conversations': [
            {
              '_id': 'c1',
              'partner': {'_id': 'peer', 'fullName': 'Amina'},
              'lastMessagePreview': 'http://x/voice.m4a',
              'lastMessageType': 'audio',
              'lastMessageSender': 'peer',
              'lastMessageAt': '2026-11-11T08:00:00.000Z',
            },
          ],
          'pagination': {'hasNext': false},
        },
      }),
    );
    await openThread();
    expect(list.single.lastMessage!.text, 'Voice message');
  });

  test('audio messages map to a playable url and duration', () async {
    when(
      () => chat.fetchMessages(
        any(),
        limit: any(named: 'limit'),
        before: any(named: 'before'),
      ),
    ).thenAnswer(
      (_) async => MessagesResponseDto.fromJson({
        'data': {
          'messages': [
            {
              ..._msg('m5', from: 'peer', text: ''),
              'messageType': 'audio',
              'attachmentUrl': '/public/upload/v.m4a',
              'durationSeconds': 45,
            },
          ],
          'hasMore': false,
        },
      }),
    );
    await openThread();
    final m = byId('m5');
    expect(m.isAudio, isTrue);
    expect(m.audioUrl, 'https://api.test/public/upload/v.m4a');
    expect(m.audioDuration, const Duration(seconds: 45));
  });

  test('sending a voice note uploads it and shows it once', () async {
    final file = File('${Directory.systemTemp.path}/voice_test.m4a')
      ..writeAsBytesSync([1, 2, 3]);
    addTearDown(file.deleteSync);
    when(() => chat.sendAudio(any(), any(), any())).thenAnswer(
      (_) async => SendMessageResponseDto.fromJson({
        'data': {
          ..._msg('m9', from: 'me', text: ''),
          'messageType': 'audio',
          'attachmentUrl': '/public/upload/v.m4a',
          'durationSeconds': 7,
        },
      }),
    );
    await openThread();
    final res = await repo.sendAudio(
      conversationId: 'c1',
      path: file.path,
      duration: const Duration(seconds: 7),
    );
    expect(res.isRight(), isTrue);
    await settle();
    verify(() => chat.sendAudio('c1', any(), '7')).called(1);
    expect(thread.where((m) => m.isAudio), hasLength(1));
    expect(byId('m9').audioDuration, const Duration(seconds: 7));
  });

  group('conversation:updated', () {
    test('closes an open chat at once and reopens it', () async {
      await openThread();
      expect(list.single.peer.closure, isNull);

      Map<String, dynamic> row(Map<String, dynamic> extra) => {
        '_id': 'c1',
        'partner': {'_id': 'peer', 'fullName': 'Amina'},
        'lastMessagePreview': 'old',
        'lastMessageSender': 'peer',
        'lastMessageAt': '2026-11-11T08:00:00.000Z',
        ...extra,
      };
      void serve(Map<String, dynamic> extra) => when(
        () => chat.fetchConversations(
          page: any(named: 'page'),
          limit: any(named: 'limit'),
          archived: any(named: 'archived'),
        ),
      ).thenAnswer(
        (_) async => ConversationsResponseDto.fromJson({
          'data': {
            'conversations': [row(extra)],
            'pagination': {'hasNext': false},
          },
        }),
      );

      serve({'canMessage': false, 'blockedBy': 'them'});
      socket.conversationUpdatedC.add(
        const SocketConversationUpdated(
          conversationId: 'c1',
          canMessage: false,
          blockedBy: 'them',
        ),
      );
      await settle();
      expect(list.single.peer.closure, ChatClosure.blocked);

      serve({'canMessage': true});
      socket.conversationUpdatedC.add(
        const SocketConversationUpdated(
          conversationId: 'c1',
          canMessage: true,
        ),
      );
      await settle();
      expect(list.single.peer.closure, isNull);
    });

    test('blocked by me maps to its own closure', () async {
      when(
        () => chat.fetchConversations(
          page: any(named: 'page'),
          limit: any(named: 'limit'),
          archived: any(named: 'archived'),
        ),
      ).thenAnswer(
        (_) async => ConversationsResponseDto.fromJson({
          'data': {
            'conversations': [
              {
                '_id': 'c1',
                'partner': {'_id': 'peer', 'fullName': 'Amina'},
                'lastMessagePreview': 'old',
                'lastMessageSender': 'peer',
                'lastMessageAt': '2026-11-11T08:00:00.000Z',
                'canMessage': false,
                'blockedBy': 'me',
              },
            ],
            'pagination': {'hasNext': false},
          },
        }),
      );
      await openThread();
      expect(list.single.peer.closure, ChatClosure.blockedByMe);
    });
  });

  group('closed chats', () {
    void rowsAre(Map<String, dynamic> extra) => when(
      () => chat.fetchConversations(
        page: any(named: 'page'),
        limit: any(named: 'limit'),
        archived: any(named: 'archived'),
      ),
    ).thenAnswer(
      (_) async => ConversationsResponseDto.fromJson({
        'data': {
          'conversations': [
            {
              '_id': 'c1',
              'matchId': 'match1',
              'partner': {'_id': 'peer', 'fullName': 'Amina'},
              'lastMessagePreview': 'old',
              'lastMessageSender': 'peer',
              'lastMessageAt': '2026-11-11T08:00:00.000Z',
              ...extra,
            },
          ],
          'pagination': {'hasNext': false},
        },
      }),
    );

    test('an open chat has no closure', () async {
      await openThread();
      expect(list.single.peer.closure, isNull);
    });

    test('canMessage:false + blockedBy them → blocked', () async {
      rowsAre({'canMessage': false, 'blockedBy': 'them'});
      await openThread();
      expect(list.single.peer.closure, ChatClosure.blocked);
    });

    test('canMessage:false alone → unmatched', () async {
      rowsAre({'canMessage': false});
      await openThread();
      expect(list.single.peer.closure, ChatClosure.unmatched);
    });

    test('an ended match in my-matches closes the chat', () async {
      await repo.dispose();
      repo = _repoWith([_match('peer', canMessage: false)]);
      await openThread();
      expect(list.single.peer.closure, ChatClosure.unmatched);
    });

    test('a 403 on send closes the chat; re-entering retries', () async {
      when(() => chat.sendMessage(any(), any())).thenThrow(
        const ForbiddenException('You cannot message this member'),
      );
      await openThread();
      final res = await repo.sendMessage(conversationId: 'c1', text: 'hi');
      expect(res.isLeft(), isTrue);
      await settle();
      expect(list.single.peer.closure, ChatClosure.unavailable);
      // The row says nothing either way: the mark survives a refresh.
      await repo.refresh();
      await settle();
      expect(list.single.peer.closure, ChatClosure.unavailable);

      repo.enterConversation('c1');
      await settle();
      expect(list.single.peer.closure, isNull);
    });

    test('an explicit canMessage:true clears an earlier 403', () async {
      when(() => chat.sendMessage(any(), any())).thenThrow(
        const ForbiddenException(),
      );
      await openThread();
      await repo.sendMessage(conversationId: 'c1', text: 'hi');
      await settle();
      expect(list.single.peer.closure, ChatClosure.unavailable);
      rowsAre({'canMessage': true});
      await repo.refresh();
      await settle();
      expect(list.single.peer.closure, isNull);
    });
  });

  test('archiving frees the slot; fetchArchived asks for archived', () async {
    when(
      () => chat.archive(any(), any()),
    ).thenAnswer((_) async {});
    await openThread();
    expect(list, hasLength(1));
    final res = await repo.setArchived('c1', archived: true);
    expect(res.isRight(), isTrue);
    await settle();
    expect(list, isEmpty);

    await repo.fetchArchived();
    verify(
      () => chat.fetchConversations(
        page: 1,
        limit: any(named: 'limit'),
        archived: true,
      ),
    ).called(greaterThanOrEqualTo(1));
  });

  test('conversation rows carry the match id for unmatching', () async {
    await openThread();
    expect(list.single.peer.matchId, 'match1');
  });

  test('a report is sent with the key the live server accepts', () {
    expect(
      const ReportBodyDto(targetUserId: 'u1', reason: 'spam').toJson(),
      {'reportedUserId': 'u1', 'reason': 'spam'},
    );
  });

  group('matches panel', () {
    test('a match shows its profile with absolute photo URLs', () async {
      await repo.dispose();
      repo = _repoWith([_match('amina')]);
      final peers = await repo.watchMatches().first;
      final profile = peers.single.profile!;
      expect(profile.age, 27);
      expect(profile.city, 'Dhaka');
      expect(profile.isVerified, isTrue);
      expect(profile.sect, 'sunni');
      expect(profile.faith, isNull);
      expect(profile.maritalStatus, 'never_married');
      expect(profile.images, [
        'https://api.test/public/upload/amina.jpg',
        'https://api.test/public/upload/amina-2.jpg',
      ]);
    });

    test('a match that can no longer be messaged is not offered', () async {
      await repo.dispose();
      repo = _repoWith([_match('amina'), _match('ended', canMessage: false)]);
      final peers = await repo.watchMatches().first;
      expect(peers.map((p) => p.id), ['amina']);
    });

    test('a partner with an archived chat is hidden until restored', () async {
      when(
        () => chat.fetchConversations(
          page: any(named: 'page'),
          limit: any(named: 'limit'),
          archived: true,
        ),
      ).thenAnswer(
        (_) async => ConversationsResponseDto.fromJson({
          'data': {
            'conversations': [
              {
                '_id': 'c9',
                'partner': {'_id': 'amina', 'fullName': 'Amina'},
              },
            ],
            'pagination': {'hasNext': false},
          },
        }),
      );
      await repo.dispose();
      repo = _repoWith([_match('amina'), _match('hamza')]);
      final peers = await repo.watchMatches().first;
      expect(peers.map((p) => p.id), ['hamza']);
    });

    test('refresh() refetches the list now', () async {
      await repo.watchConversations().first;
      clearInteractions(chat);
      await repo.refresh();
      verify(
        () => chat.fetchConversations(
          page: 1,
          limit: any(named: 'limit'),
          archived: any(named: 'archived'),
        ),
      ).called(greaterThanOrEqualTo(1));
    });
  });

  test('the list row tick follows receipts for our last message', () async {
    when(
      () => chat.fetchConversations(
        page: any(named: 'page'),
        limit: any(named: 'limit'),
        archived: any(named: 'archived'),
      ),
    ).thenAnswer(
      (_) async => ConversationsResponseDto.fromJson({
        'data': {
          'conversations': [
            {
              '_id': 'c1',
              'partner': {'_id': 'peer', 'fullName': 'Amina'},
              'lastMessagePreview': 'wa alaikum',
              'lastMessageSender': 'me', // ours
              'lastMessageAt': '2026-11-11T09:00:05.000Z',
            },
          ],
          'pagination': {'hasNext': false},
        },
      }),
    );
    // Our message is the newest in the thread.
    when(
      () => chat.fetchMessages(
        any(),
        limit: any(named: 'limit'),
        before: any(named: 'before'),
      ),
    ).thenAnswer(
      (_) async => MessagesResponseDto.fromJson({
        'data': {
          'messages': [_msg('m1', from: 'me', text: 'wa alaikum')],
          'hasMore': false,
        },
      }),
    );
    await repo.dispose();
    repo = _repoWith(const []);
    await openThread();
    expect(list.single.lastMessage!.status, MessageStatus.sent);

    socket.seenC.add(
      SocketReceipt(
        conversationId: 'c1',
        by: 'peer',
        at: DateTime.utc(2026, 11, 11, 10),
      ),
    );
    await settle();
    expect(list.single.lastMessage!.status, MessageStatus.seen);
  });

  test('blocked users are read tolerantly and photos made absolute', () async {
    when(
      () => chat.fetchBlocks(
        page: any(named: 'page'),
        limit: any(named: 'limit'),
      ),
    ).thenAnswer(
      (_) async => BlocksResponseDto.fromJson({
        'data': {
          'blocks': [
            {
              '_id': 'b1',
              'blocked': {
                '_id': 'u1',
                'fullName': 'Hamza',
                'photoUrl': '/public/upload/h.jpg',
              },
            },
            {'_id': 'b2', 'targetUserId': 'u2'},
            {'_id': 'b3'}, // no user at all: skipped
          ],
          'pagination': {'hasNext': false},
        },
      }),
    );
    final res = await repo.fetchBlocked();
    final users = res.getOrElse((_) => const []);
    expect(users.map((u) => u.id), ['u1', 'u2']);
    expect(users.first.name, 'Hamza');
    expect(users.first.photoUrl, 'https://api.test/public/upload/h.jpg');
  });

  test('unblocking calls the API and refreshes', () async {
    when(() => chat.unblock('u1')).thenAnswer((_) async {});
    await repo.watchConversations().first;
    final res = await repo.unblockUser('u1');
    expect(res.isRight(), isTrue);
    verify(() => chat.unblock('u1')).called(1);
  });

  test(
    'fetchPeerProfile reads about, languages, practices and lifestyle',
    () async {
      matchesFake.profileResponse = {
        'data': {
          'profile': {
            'aboutMe': ' Hello there ',
            'languages': ['English', 'Bengali'],
            'religiousPractices': ['actively_practising'],
            'lifestyle': {
              'halalFood': true,
              'smoking': false,
              'alcohol': false,
            },
          },
        },
      };
      final res = await repo.fetchPeerProfile('u1');
      final p = res.getOrElse((f) => throw StateError('$f'));
      expect(p.about, 'Hello there');
      expect(p.languages, ['English', 'Bengali']);
      expect(p.practices, ['actively_practising']);
      expect(p.lifestyle, [
        'Eats halal food',
        "Doesn't smoke",
        "Doesn't drink alcohol",
      ]);
    },
  );

  test('fetchPeerProfile with an empty body gives an empty profile', () async {
    final p = (await repo.fetchPeerProfile('u1')).getOrElse(
      (f) => throw StateError('$f'),
    );
    expect(p.about, isNull);
    expect(p.lifestyle, isEmpty);
  });
}
