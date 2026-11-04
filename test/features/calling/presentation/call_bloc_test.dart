import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:find_a_nikah/core/core.dart';
import 'package:find_a_nikah/features/calling/domain/domain.dart';
import 'package:find_a_nikah/features/calling/presentation/presentation.dart';
import 'package:find_a_nikah/features/messaging/domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockCallRepository extends Mock implements CallRepository {}

class _MockMessagingRepository extends Mock implements MessagingRepository {}

const _peer = ChatPeer(id: 'u1', name: 'Yusuf', photoUrl: '');
const _conversation = Conversation(id: 'c1', peer: _peer, slot: 0);
const _ringing = CallSession(
  id: 'call-1',
  peer: _peer,
  direction: CallDirection.incoming,
  phase: CallPhase.ringing,
);
final CallSession _ended = _ringing.copyWith(
  phase: CallPhase.ended,
  outcome: CallOutcome.declined,
);

void main() {
  late _MockCallRepository calls;
  late _MockMessagingRepository messaging;
  late StreamController<CallSession> session;

  setUpAll(() {
    registerFallbackValue(_peer);
    registerFallbackValue(
      const CallLog(outcome: CallOutcome.completed, outgoing: true),
    );
  });

  setUp(() {
    calls = _MockCallRepository();
    messaging = _MockMessagingRepository();
    session = StreamController<CallSession>.broadcast();
    when(
      () => calls.simulateIncoming(any()),
    ).thenAnswer((_) async => right(_ringing));
    when(() => calls.dial(any())).thenAnswer(
      (_) async => right(
        _ringing.copyWith(
          direction: CallDirection.outgoing,
          phase: CallPhase.dialing,
        ),
      ),
    );
    when(() => calls.watchCall(any())).thenAnswer((_) => session.stream);
    when(() => calls.decline(any())).thenAnswer((_) async => right(unit));
    when(() => calls.hangUp(any())).thenAnswer((_) async => right(unit));
    when(
      () => calls.setMuted(any(), muted: any(named: 'muted')),
    ).thenAnswer((_) async => right(unit));
    when(
      () => messaging.openConversation(any(), slot: any(named: 'slot')),
    ).thenAnswer((_) async => right(_conversation));
    when(
      () => messaging.logCall(
        conversationId: any(named: 'conversationId'),
        log: any(named: 'log'),
      ),
    ).thenAnswer((_) async => right(unit));
    when(
      () => messaging.sendMessage(
        conversationId: any(named: 'conversationId'),
        text: any(named: 'text'),
        replyToMessageId: any(named: 'replyToMessageId'),
      ),
    ).thenAnswer((_) async => right(unit));
  });

  tearDown(() => session.close());

  CallBloc build({bool incoming = true}) =>
      CallBloc(calls, messaging, _peer, incoming: incoming);

  blocTest<CallBloc, CallState>(
    'incoming: rings via simulateIncoming and follows the session',
    build: build,
    act: (b) async {
      b.add(const CallStarted());
      await Future<void>.delayed(Duration.zero);
      session.add(_ringing);
    },
    expect: () => [
      const CallState(
        peer: _peer,
        incoming: true,
        status: CallStatus.active,
        session: _ringing,
      ),
    ],
    verify: (_) {
      verify(() => calls.simulateIncoming(_peer)).called(1);
      verifyNever(() => calls.dial(any()));
    },
  );

  blocTest<CallBloc, CallState>(
    'outgoing: dials',
    build: () => build(incoming: false),
    act: (b) => b.add(const CallStarted()),
    verify: (_) => verify(() => calls.dial(_peer)).called(1),
  );

  blocTest<CallBloc, CallState>(
    'quick reply: declines, logs the call, then sends the text',
    build: build,
    act: (b) async {
      b.add(const CallStarted());
      await Future<void>.delayed(Duration.zero);
      session.add(_ringing);
      await Future<void>.delayed(Duration.zero);
      b.add(const CallQuickReplySent('In a meeting, text me?'));
      await Future<void>.delayed(Duration.zero);
      session.add(_ended);
      await Future<void>.delayed(Duration.zero);
    },
    verify: (_) {
      verify(() => calls.decline('call-1')).called(1);
      verifyInOrder([
        () => messaging.logCall(
          conversationId: 'c1',
          log: const CallLog(outcome: CallOutcome.declined, outgoing: false),
        ),
        () => messaging.sendMessage(
          conversationId: 'c1',
          text: 'In a meeting, text me?',
        ),
      ]);
    },
  );

  blocTest<CallBloc, CallState>(
    'the call is logged once even if ended repeats',
    build: build,
    act: (b) async {
      b.add(const CallStarted());
      await Future<void>.delayed(Duration.zero);
      session
        ..add(_ended)
        ..add(_ended);
      await Future<void>.delayed(Duration.zero);
    },
    verify: (_) => verify(
      () => messaging.logCall(
        conversationId: any(named: 'conversationId'),
        log: any(named: 'log'),
      ),
    ).called(1),
  );

  blocTest<CallBloc, CallState>(
    'mute toggles against the current session',
    build: build,
    seed: () => const CallState(
      peer: _peer,
      incoming: true,
      status: CallStatus.active,
      session: _ringing,
    ),
    act: (b) => b.add(const CallMuteToggled()),
    verify: (_) =>
        verify(() => calls.setMuted('call-1', muted: true)).called(1),
  );

  blocTest<CallBloc, CallState>(
    'start failure → failure status',
    setUp: () => when(
      () => calls.simulateIncoming(any()),
    ).thenAnswer((_) async => left(const NetworkFailure())),
    build: build,
    act: (b) => b.add(const CallStarted()),
    expect: () => [
      const CallState(
        peer: _peer,
        incoming: true,
        status: CallStatus.failure,
        failure: NetworkFailure(),
      ),
    ],
  );
}
