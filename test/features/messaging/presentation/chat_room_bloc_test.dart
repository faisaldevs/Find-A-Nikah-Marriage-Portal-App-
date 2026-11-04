import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:find_a_nikah/core/core.dart';
import 'package:find_a_nikah/features/messaging/domain/domain.dart';
import 'package:find_a_nikah/features/messaging/presentation/presentation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockMessagingRepository extends Mock implements MessagingRepository {}

const _peer = ChatPeer(id: 'u1', name: 'Yusuf', photoUrl: '');
const _conversation = Conversation(id: 'c1', peer: _peer, slot: 0);
final _incoming = ChatMessage(
  id: 'm1',
  conversationId: 'c1',
  text: 'Salaam',
  sentAt: DateTime(2026, 10, 24),
  isMine: false,
);

void main() {
  late _MockMessagingRepository repo;
  late StreamController<List<ChatMessage>> messages;

  setUp(() {
    repo = _MockMessagingRepository();
    messages = StreamController<List<ChatMessage>>.broadcast();
    when(
      () => repo.openConversation(any(), slot: any(named: 'slot')),
    ).thenAnswer((_) async => right(_conversation));
    when(() => repo.watchMessages(any())).thenAnswer((_) => messages.stream);
    when(
      () => repo.watchPeerTyping(any()),
    ).thenAnswer((_) => Stream.value(false));
    when(() => repo.markRead(any())).thenAnswer((_) async => right(unit));
    when(
      () => repo.sendMessage(
        conversationId: any(named: 'conversationId'),
        text: any(named: 'text'),
        replyToMessageId: any(named: 'replyToMessageId'),
      ),
    ).thenAnswer((_) async => right(unit));
  });

  tearDown(() => messages.close());

  blocTest<ChatRoomBloc, ChatRoomState>(
    'started: opens the conversation, shows messages, marks them read once',
    build: () => ChatRoomBloc(repo, _peer),
    act: (b) async {
      b.add(const ChatRoomStarted());
      await Future<void>.delayed(Duration.zero);
      messages
        ..add([_incoming])
        ..add([_incoming]);
    },
    expect: () => [
      const ChatRoomState(peer: _peer, conversationId: 'c1'),
      ChatRoomState(
        peer: _peer,
        conversationId: 'c1',
        status: ChatRoomStatus.ready,
        messages: [_incoming],
      ),
    ],
    verify: (_) => verify(() => repo.markRead('c1')).called(1),
  );

  blocTest<ChatRoomBloc, ChatRoomState>(
    'open failure → failure status',
    setUp: () => when(
      () => repo.openConversation(any(), slot: any(named: 'slot')),
    ).thenAnswer((_) async => left(const NetworkFailure())),
    build: () => ChatRoomBloc(repo, _peer),
    act: (b) => b.add(const ChatRoomStarted()),
    expect: () => [
      isA<ChatRoomState>()
          .having((s) => s.status, 'status', ChatRoomStatus.failure)
          .having((s) => s.failure, 'failure', isA<NetworkFailure>()),
    ],
  );

  blocTest<ChatRoomBloc, ChatRoomState>(
    'submitted: sends trimmed text quoting the selected reply, then clears it',
    build: () => ChatRoomBloc(repo, _peer),
    seed: () => ChatRoomState(
      peer: _peer,
      conversationId: 'c1',
      status: ChatRoomStatus.ready,
      replyingTo: _incoming,
    ),
    act: (b) => b.add(const ChatRoomMessageSubmitted('  Wa alaikum  ')),
    expect: () => [
      const ChatRoomState(
        peer: _peer,
        conversationId: 'c1',
        status: ChatRoomStatus.ready,
      ),
    ],
    verify: (_) => verify(
      () => repo.sendMessage(
        conversationId: 'c1',
        text: 'Wa alaikum',
        replyToMessageId: 'm1',
      ),
    ).called(1),
  );

  blocTest<ChatRoomBloc, ChatRoomState>(
    'submitted: blank text is ignored',
    build: () => ChatRoomBloc(repo, _peer),
    seed: () => const ChatRoomState(peer: _peer, conversationId: 'c1'),
    act: (b) => b.add(const ChatRoomMessageSubmitted('   ')),
    expect: () => <ChatRoomState>[],
    verify: (_) => verifyNever(
      () => repo.sendMessage(
        conversationId: any(named: 'conversationId'),
        text: any(named: 'text'),
        replyToMessageId: any(named: 'replyToMessageId'),
      ),
    ),
  );

  blocTest<ChatRoomBloc, ChatRoomState>(
    'send failure is surfaced once',
    setUp: () => when(
      () => repo.sendMessage(
        conversationId: any(named: 'conversationId'),
        text: any(named: 'text'),
        replyToMessageId: any(named: 'replyToMessageId'),
      ),
    ).thenAnswer((_) async => left(const NetworkFailure())),
    build: () => ChatRoomBloc(repo, _peer),
    seed: () => const ChatRoomState(peer: _peer, conversationId: 'c1'),
    act: (b) => b.add(const ChatRoomMessageSubmitted('Hi')),
    expect: () => [
      isA<ChatRoomState>().having(
        (s) => s.failure,
        'failure',
        isA<NetworkFailure>(),
      ),
    ],
  );

  blocTest<ChatRoomBloc, ChatRoomState>(
    'reply selected / cleared',
    build: () => ChatRoomBloc(repo, _peer),
    act: (b) => b
      ..add(ChatRoomReplySelected(_incoming))
      ..add(const ChatRoomReplyCleared()),
    expect: () => [
      ChatRoomState(peer: _peer, replyingTo: _incoming),
      const ChatRoomState(peer: _peer),
    ],
  );
}
