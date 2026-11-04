import 'package:equatable/equatable.dart';
import 'package:find_a_nikah/core/core.dart';
import 'package:find_a_nikah/features/messaging/domain/domain.dart';

enum CallDirection { outgoing, incoming }

enum CallPhase {
  /// Outgoing, reaching the peer ("Calling…").
  dialing,

  /// Ringing on the other end (outgoing, "Ringing…") or on this phone
  /// (incoming: Accept / Decline).
  ringing,
  connected,
  ended,
}

/// One voice call with a match, from dial / ring to hang-up.
class CallSession extends Equatable {
  const CallSession({
    required this.id,
    required this.peer,
    required this.direction,
    required this.phase,
    this.connectedAt,
    this.endedAt,
    this.outcome,
    this.muted = false,
    this.speakerOn = false,
  });

  final String id;
  final ChatPeer peer;
  final CallDirection direction;
  final CallPhase phase;
  final DateTime? connectedAt;
  final DateTime? endedAt;

  /// Set once [phase] is [CallPhase.ended].
  final CallOutcome? outcome;
  final bool muted;
  final bool speakerOn;

  bool get isOutgoing => direction == CallDirection.outgoing;
  bool get isEnded => phase == CallPhase.ended;

  /// Talk time: connected → ended (or [now] while still connected).
  Duration talkTime({DateTime? now}) {
    final start = connectedAt;
    if (start == null) return Duration.zero;
    return (endedAt ?? now ?? DateTime.now()).difference(start);
  }

  CallSession copyWith({
    String? id,
    ChatPeer? peer,
    CallDirection? direction,
    CallPhase? phase,
    Object? connectedAt = unchanged,
    Object? endedAt = unchanged,
    Object? outcome = unchanged,
    bool? muted,
    bool? speakerOn,
  }) {
    return CallSession(
      id: id ?? this.id,
      peer: peer ?? this.peer,
      direction: direction ?? this.direction,
      phase: phase ?? this.phase,
      connectedAt: identical(connectedAt, unchanged)
          ? this.connectedAt
          : connectedAt as DateTime?,
      endedAt: identical(endedAt, unchanged)
          ? this.endedAt
          : endedAt as DateTime?,
      outcome: identical(outcome, unchanged)
          ? this.outcome
          : outcome as CallOutcome?,
      muted: muted ?? this.muted,
      speakerOn: speakerOn ?? this.speakerOn,
    );
  }

  @override
  List<Object?> get props => [
    id,
    peer,
    direction,
    phase,
    connectedAt,
    endedAt,
    outcome,
    muted,
    speakerOn,
  ];
}
