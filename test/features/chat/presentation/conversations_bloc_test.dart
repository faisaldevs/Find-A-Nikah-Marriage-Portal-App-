import 'package:bloc_test/bloc_test.dart';
import 'package:find_a_nikah/core/core.dart';
import 'package:find_a_nikah/features/chat/presentation/presentation.dart';
import 'package:find_a_nikah/features/messaging/domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockMessagingRepository extends Mock implements MessagingRepository {}

const _peer = ChatPeer(id: 'u1', name: 'Yusuf', photoUrl: '');
const _match = ChatPeer(id: 'u2', name: 'Hamza', photoUrl: '');
const _conversation = Conversation(
  id: 'c1',
  peer: _peer,
  slot: 0,
  unreadCount: 1,
);

void main() {
  late _MockMessagingRepository repo;

  setUp(() {
    repo = _MockMessagingRepository();
    when(
      repo.watchConversations,
    ).thenAnswer((_) => Stream.value(const [_conversation]));
    when(repo.watchMatches).thenAnswer((_) => Stream.value(const [_match]));
  });

  blocTest<ConversationsBloc, ConversationsState>(
    'subscribed: lists conversations and matches',
    build: () => ConversationsBloc(repo),
    act: (b) => b.add(const ConversationsSubscribed()),
    expect: () => [
      const ConversationsState(
        status: ConversationsStatus.ready,
        conversations: [_conversation],
      ),
      const ConversationsState(
        status: ConversationsStatus.ready,
        conversations: [_conversation],
        matches: [_match],
      ),
    ],
  );

  blocTest<ConversationsBloc, ConversationsState>(
    'stream error → failure',
    setUp: () => when(
      repo.watchConversations,
    ).thenAnswer((_) => Stream.error(Exception('boom'))),
    build: () => ConversationsBloc(repo),
    act: (b) => b.add(const ConversationsSubscribed()),
    expect: () => [
      const ConversationsState(status: ConversationsStatus.failure),
      const ConversationsState(
        status: ConversationsStatus.failure,
        matches: [_match],
      ),
    ],
    errors: () => [isA<Exception>()],
  );

  blocTest<ConversationsBloc, ConversationsState>(
    'start requested: opens the conversation for the match',
    setUp: () =>
        when(
          () => repo.openConversation(any(), slot: any(named: 'slot')),
        ).thenAnswer(
          (_) async =>
              right(const Conversation(id: 'c2', peer: _match, slot: 4)),
        ),
    build: () => ConversationsBloc(repo),
    act: (b) => b.add(const ConversationStartRequested(_match, slot: 4)),
    expect: () => <ConversationsState>[],
    verify: (_) => verify(() => repo.openConversation('u2', slot: 4)).called(1),
  );

  blocTest<ConversationsBloc, ConversationsState>(
    'start failure is surfaced once',
    setUp: () => when(
      () => repo.openConversation(any(), slot: any(named: 'slot')),
    ).thenAnswer((_) async => left(const NetworkFailure())),
    build: () => ConversationsBloc(repo),
    act: (b) => b.add(const ConversationStartRequested(_match)),
    expect: () => [const ConversationsState(failure: NetworkFailure())],
  );
}
