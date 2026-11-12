import 'dart:async';

import 'package:find_a_nikah/core/core.dart';
import 'package:find_a_nikah/features/messaging/data/data.dart';
import 'package:find_a_nikah/features/messaging/data/dtos/chat_api_dtos.dart';
import 'package:find_a_nikah/features/messaging/data/dtos/my_matches_dto.dart';
import 'package:find_a_nikah/features/messaging/domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/fakes.dart';

class _MockChat extends Mock implements ChatRemoteDataSource {}

class _FakeMatches implements MatchesRemoteDataSource {
  @override
  Future<MyMatchesResponseDto> fetchMyMatches({
    required int page,
    required int limit,
  }) async => MyMatchesResponseDto.fromJson({
    'data': {'matches': <Object>[], 'pagination': <String, Object>{}},
  });
}

class _FakeSocket implements ChatSocket {
  final messagesC = StreamController<MessageDto>.broadcast();
  final deliveredC = StreamController<SocketReceipt>.broadcast();
  final seenC = StreamController<SocketReceipt>.broadcast();
  final typingC = StreamController<SocketTyping>.broadcast();
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

  setUpAll(() => registerFallbackValue(const ArchiveBodyDto(archived: true)));

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
    repo = MessagingRepositoryImpl(
      chat,
      _FakeMatches(),
      socket,
      testGuard(),
      'https://api.test',
    );
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
        messageId: 'm1',
        at: DateTime.utc(2026, 11, 11, 9),
      ),
    );
    await settle();
    expect(byId('m1').status, MessageStatus.delivered);

    socket.seenC.add(
      SocketReceipt(conversationId: 'c1', at: DateTime.utc(2026, 11, 11, 10)),
    );
    await settle();
    expect(byId('m1').status, MessageStatus.seen);
    // The peer's own message is untouched.
    expect(byId('m22').isMine, isFalse);

    socket.deliveredC.add(
      SocketReceipt(
        conversationId: 'c1',
        messageId: 'm1',
        at: DateTime.utc(2026, 11, 11, 11),
      ),
    );
    await settle();
    expect(byId('m1').status, MessageStatus.seen);
  });

  test('receipts triggered by me (sent to both users) are ignored', () async {
    await openThread();
    // I read the peer's messages: the server echoes `seenBy: me` to me.
    socket.seenC.add(
      SocketReceipt(
        conversationId: 'c1',
        seenBy: 'me',
        at: DateTime.utc(2026, 11, 11, 10),
      ),
    );
    // I delivered: `deliveredTo` is the sender, i.e. the peer.
    socket.deliveredC.add(
      SocketReceipt(
        conversationId: 'c1',
        deliveredTo: 'peer',
        at: DateTime.utc(2026, 11, 11, 10),
      ),
    );
    await settle();
    expect(byId('m1').status, MessageStatus.sent);

    // The peer reading my messages is the real one.
    socket.seenC.add(
      SocketReceipt(
        conversationId: 'c1',
        seenBy: 'peer',
        at: DateTime.utc(2026, 11, 11, 10),
      ),
    );
    await settle();
    expect(byId('m1').status, MessageStatus.seen);
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
    ).called(1);
  });

  test('conversation rows carry the match id for unmatching', () async {
    await openThread();
    expect(list.single.peer.matchId, 'match1');
  });
}
