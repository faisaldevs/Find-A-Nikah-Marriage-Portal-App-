import 'package:find_a_nikah/features/calling/data/dtos/call_session_dto.dart';
import 'package:find_a_nikah/features/calling/domain/domain.dart';
import 'package:find_a_nikah/features/messaging/domain/domain.dart';

/// The wire only names the peer; the caller already holds who that is.
extension CallSessionDtoMapper on CallSessionDto {
  CallSession toEntity(ChatPeer peer) => CallSession(
    id: id,
    peer: peer,
    direction: direction == 'incoming'
        ? CallDirection.incoming
        : CallDirection.outgoing,
    phase: switch (phase) {
      'dialing' => CallPhase.dialing,
      'ringing' => CallPhase.ringing,
      'connected' => CallPhase.connected,
      _ => CallPhase.ended,
    },
    connectedAt: connectedAt?.toLocal(),
    endedAt: endedAt?.toLocal(),
    outcome: switch (outcome) {
      null => null,
      'missed' => CallOutcome.missed,
      'declined' => CallOutcome.declined,
      'cancelled' => CallOutcome.cancelled,
      _ => CallOutcome.completed,
    },
    muted: muted,
    speakerOn: speakerOn,
  );
}
