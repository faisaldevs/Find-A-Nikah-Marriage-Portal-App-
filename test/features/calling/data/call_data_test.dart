import 'package:find_a_nikah/features/calling/data/data.dart';
import 'package:find_a_nikah/features/calling/data/dtos/call_session_dto.dart';
import 'package:find_a_nikah/features/calling/data/mappers/call_mappers.dart';
import 'package:find_a_nikah/features/calling/domain/domain.dart';
import 'package:find_a_nikah/features/messaging/domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';

const _peer = ChatPeer(id: 'u1', name: 'Yusuf', photoUrl: '');

void main() {
  group('call mapper', () {
    test('codes map to phases, directions and outcomes', () {
      final s = CallSessionDto(
        id: 'c',
        peerId: 'u1',
        direction: 'incoming',
        phase: 'ended',
        connectedAt: DateTime.utc(2026, 10, 24, 12),
        endedAt: DateTime.utc(2026, 10, 24, 12, 2, 14),
        outcome: 'completed',
      ).toEntity(_peer);
      expect(s.direction, CallDirection.incoming);
      expect(s.phase, CallPhase.ended);
      expect(s.outcome, CallOutcome.completed);
      expect(s.talkTime(), const Duration(minutes: 2, seconds: 14));
      expect(s.peer, _peer);
    });
  });

  group('DummyCallDataSource', () {
    late DummyCallDataSource source;

    setUp(
      () => source = DummyCallDataSource(
        ringingAfter: const Duration(milliseconds: 10),
        answerAfter: const Duration(milliseconds: 30),
        ringTimeout: const Duration(milliseconds: 30),
      ),
    );
    tearDown(() => source.dispose());

    test('outgoing: dialing → ringing → connected → completed', () async {
      final call = await source.dial('u1');
      final phases = <String>[];
      final sub = source.watch(call.id).listen((c) => phases.add(c.phase));
      await Future<void>.delayed(const Duration(milliseconds: 60));
      await source.hangUp(call.id);
      await Future<void>.delayed(Duration.zero);
      await sub.cancel();
      expect(phases, ['dialing', 'ringing', 'connected', 'ended']);
    });

    test('hanging up before an answer cancels', () async {
      final call = await source.dial('u1');
      final ended = source.watch(call.id).last;
      await source.hangUp(call.id);
      expect((await ended).outcome, 'cancelled');
    });

    test('incoming: unanswered → missed', () async {
      final call = await source.ringIncoming('u1');
      final ended = await source.watch(call.id).last;
      expect(ended.outcome, 'missed');
    });

    test('incoming: declined / accepted', () async {
      final a = await source.ringIncoming('u1');
      await source.decline(a.id);
      expect((await source.watch(a.id).last).outcome, 'declined');

      final b = await source.ringIncoming('u1');
      await source.accept(b.id);
      await source.setMuted(b.id, muted: true);
      final live = await source.watch(b.id).first;
      expect(live.phase, 'connected');
      expect(live.muted, isTrue);
      await source.hangUp(b.id);
      expect((await source.watch(b.id).last).outcome, 'completed');
    });
  });
}
