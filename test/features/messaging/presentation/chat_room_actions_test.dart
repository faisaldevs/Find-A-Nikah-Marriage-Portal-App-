import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:find_a_nikah/core/core.dart';
import 'package:find_a_nikah/features/chat/presentation/bloc/conversations_bloc.dart';
import 'package:find_a_nikah/features/messaging/domain/domain.dart';
import 'package:find_a_nikah/features/messaging/presentation/presentation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockRepo extends Mock implements MessagingRepository {}

const _peer = ChatPeer(id: 'u1', name: 'Yusuf', photoUrl: '', matchId: 'mt1');
const _conversation = Conversation(id: 'c1', peer: _peer, slot: 0);
final _mine = ChatMessage(
  id: 'm1',
  conversationId: 'c1',
  text: 'hi',
  sentAt: DateTime(2026, 11, 12),
  isMine: true,
);

void main() {
  late _MockRepo repo;
  late StreamController<List<ChatMessage>> messages;

  setUp(() {
    repo = _MockRepo();
    messages = StreamController<List<ChatMessage>>.broadcast();
    when(
      () => repo.openConversation(any(), slot: any(named: 'slot')),
    ).thenAnswer((_) async => right(_conversation));
    when(() => repo.watchMessages(any())).thenAnswer((_) => messages.stream);
    when(
      () => repo.watchPeerTyping(any()),
    ).thenAnswer((_) => Stream.value(false));
    when(() => repo.markRead(any())).thenAnswer((_) async => right(unit));
  });

  tearDown(() => messages.close());

  /// A started bloc (conversation id known).
  Future<ChatRoomBloc> started() async {
    final bloc = ChatRoomBloc(repo, _peer)..add(const ChatRoomStarted());
    await bloc.stream.firstWhere((s) => s.conversationId != null);
    return bloc;
  }

  group('ChatRoomBloc actions', () {
    test('joins the room on start and leaves it on close', () async {
      final bloc = await started();
      verify(() => repo.enterConversation('c1')).called(1);
      await bloc.close();
      verify(() => repo.leaveConversation('c1')).called(1);
    });

    test('typing changes go to the repository', () async {
      final bloc = await started();
      bloc.add(const ChatRoomTypingChanged(typing: true));
      await Future<void>.delayed(Duration.zero);
      verify(() => repo.setTyping('c1', typing: true)).called(1);
      await bloc.close();
    });

    test('a picked image is sent, a failure is surfaced', () async {
      when(
        () => repo.sendImage(
          conversationId: any(named: 'conversationId'),
          path: any(named: 'path'),
        ),
      ).thenAnswer((_) async => left(const NetworkFailure()));
      final bloc = await started();
      bloc.add(const ChatRoomImageSelected('/tmp/a.jpg'));
      final s = await bloc.stream.firstWhere((s) => s.failure != null);
      expect(s.failure, isA<NetworkFailure>());
      verify(
        () => repo.sendImage(conversationId: 'c1', path: '/tmp/a.jpg'),
      ).called(1);
      await bloc.close();
    });

    test('delete for me asks for that message', () async {
      when(
        () => repo.deleteMessage(
          conversationId: any(named: 'conversationId'),
          messageId: any(named: 'messageId'),
        ),
      ).thenAnswer((_) async => right(unit));
      final bloc = await started();
      bloc.add(ChatRoomMessageDeleted(_mine));
      await Future<void>.delayed(Duration.zero);
      verify(
        () => repo.deleteMessage(conversationId: 'c1', messageId: 'm1'),
      ).called(1);
      await bloc.close();
    });

    test('block / unmatch / report / archive report their outcome', () async {
      when(() => repo.blockUser(any())).thenAnswer((_) async => right(unit));
      when(() => repo.unmatch(any())).thenAnswer((_) async => right(unit));
      when(
        () => repo.reportUser(
          peerId: any(named: 'peerId'),
          reason: any(named: 'reason'),
          description: any(named: 'description'),
        ),
      ).thenAnswer((_) async => right(unit));
      when(
        () => repo.setArchived(any(), archived: any(named: 'archived')),
      ).thenAnswer((_) async => right(unit));

      final bloc = await started();
      final outcomes = <ChatRoomOutcome>[];
      final sub = bloc.stream
          .map((s) => s.outcome)
          .where((o) => o != null)
          .listen((o) => outcomes.add(o!));

      bloc.add(const ChatRoomBlockRequested());
      await Future<void>.delayed(Duration.zero);
      bloc.add(const ChatRoomUnmatchRequested());
      await Future<void>.delayed(Duration.zero);
      bloc.add(const ChatRoomReportRequested('spam'));
      await Future<void>.delayed(Duration.zero);
      bloc.add(const ChatRoomArchiveRequested());
      await Future<void>.delayed(Duration.zero);

      verify(() => repo.blockUser('u1')).called(1);
      verify(() => repo.unmatch('mt1')).called(1);
      verify(
        () => repo.reportUser(peerId: 'u1', reason: 'spam', description: null),
      ).called(1);
      verify(() => repo.setArchived('c1', archived: true)).called(1);
      expect(outcomes, [
        ChatRoomOutcome.blocked,
        ChatRoomOutcome.unmatched,
        ChatRoomOutcome.reported,
        ChatRoomOutcome.archived,
      ]);
      await sub.cancel();
      await bloc.close();
    });

    test('unmatch without a match id fails without calling the API', () async {
      when(
        () => repo.openConversation(any(), slot: any(named: 'slot')),
      ).thenAnswer(
        (_) async => right(
          const Conversation(
            id: 'c1',
            peer: ChatPeer(id: 'u1', name: 'Yusuf', photoUrl: ''),
            slot: 0,
          ),
        ),
      );
      final bloc = ChatRoomBloc(
        repo,
        const ChatPeer(id: 'u1', name: 'Yusuf', photoUrl: ''),
      )..add(const ChatRoomStarted());
      await bloc.stream.firstWhere((s) => s.conversationId != null);
      bloc.add(const ChatRoomUnmatchRequested());
      final s = await bloc.stream.firstWhere((s) => s.failure != null);
      expect(s.failure, isA<NotFoundFailure>());
      verifyNever(() => repo.unmatch(any()));
      await bloc.close();
    });
  });

  group('BlockedUsersCubit', () {
    const amina = BlockedUser(id: 'u9', name: 'Amina');

    blocTest<BlockedUsersCubit, BlockedUsersState>(
      'load lists the blocked members',
      build: () {
        when(() => repo.fetchBlocked()).thenAnswer(
          (_) async => right(const [amina]),
        );
        return BlockedUsersCubit(repo);
      },
      act: (c) => c.load(),
      expect: () => [
        isA<BlockedUsersState>().having(
          (s) => s.status,
          'status',
          BlockedUsersStatus.loading,
        ),
        isA<BlockedUsersState>()
            .having((s) => s.status, 'status', BlockedUsersStatus.ready)
            .having((s) => s.users, 'users', const [amina]),
      ],
    );

    blocTest<BlockedUsersCubit, BlockedUsersState>(
      'unblock removes the member and says who',
      build: () {
        when(() => repo.unblockUser('u9')).thenAnswer(
          (_) async => right(unit),
        );
        return BlockedUsersCubit(repo);
      },
      seed: () => const BlockedUsersState(
        status: BlockedUsersStatus.ready,
        users: [amina],
      ),
      act: (c) => c.unblock(amina),
      expect: () => [
        isA<BlockedUsersState>()
            .having((s) => s.users, 'users', isEmpty)
            .having((s) => s.unblockedName, 'unblockedName', 'Amina'),
      ],
    );

    blocTest<BlockedUsersCubit, BlockedUsersState>(
      'a failed unblock keeps the member and reports the failure',
      build: () {
        when(() => repo.unblockUser('u9')).thenAnswer(
          (_) async => left(const NetworkFailure()),
        );
        return BlockedUsersCubit(repo);
      },
      seed: () => const BlockedUsersState(
        status: BlockedUsersStatus.ready,
        users: [amina],
      ),
      act: (c) => c.unblock(amina),
      expect: () => [
        isA<BlockedUsersState>()
            .having((s) => s.users, 'users', const [amina])
            .having((s) => s.failure, 'failure', isA<NetworkFailure>()),
      ],
    );
  });

  blocTest<ConversationsBloc, ConversationsState>(
    'opening the Matches panel refreshes the repository',
    build: () {
      when(() => repo.refresh()).thenAnswer((_) async {});
      return ConversationsBloc(repo);
    },
    act: (b) => b.add(const ConversationsRefreshRequested()),
    verify: (_) => verify(() => repo.refresh()).called(1),
  );
}
