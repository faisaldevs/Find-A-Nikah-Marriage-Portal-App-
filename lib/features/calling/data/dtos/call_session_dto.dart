import 'package:find_a_nikah/features/calling/domain/entities/call_session.dart';
import 'package:json_annotation/json_annotation.dart';

part 'call_session_dto.g.dart';

/// Wire format of a call's state, as signalling will report it. Kept
/// separate from [CallSession] (decisions register #4): the wire speaks in
/// peer ids and raw codes.
@JsonSerializable()
class CallSessionDto {
  const CallSessionDto({
    required this.id,
    required this.peerId,
    required this.direction,
    required this.phase,
    this.connectedAt,
    this.endedAt,
    this.outcome,
    this.muted = false,
    this.speakerOn = false,
  });

  factory CallSessionDto.fromJson(Map<String, dynamic> json) =>
      _$CallSessionDtoFromJson(json);

  final String id;
  final String peerId;

  /// `outgoing` · `incoming`.
  final String direction;

  /// `dialing` · `ringing` · `connected` · `ended`.
  final String phase;
  final DateTime? connectedAt;
  final DateTime? endedAt;

  /// `completed` · `missed` · `declined` · `cancelled`, once ended.
  final String? outcome;
  final bool muted;
  final bool speakerOn;

  CallSessionDto copyWith({
    String? phase,
    DateTime? connectedAt,
    DateTime? endedAt,
    String? outcome,
    bool? muted,
    bool? speakerOn,
  }) => CallSessionDto(
    id: id,
    peerId: peerId,
    direction: direction,
    phase: phase ?? this.phase,
    connectedAt: connectedAt ?? this.connectedAt,
    endedAt: endedAt ?? this.endedAt,
    outcome: outcome ?? this.outcome,
    muted: muted ?? this.muted,
    speakerOn: speakerOn ?? this.speakerOn,
  );

  Map<String, dynamic> toJson() => _$CallSessionDtoToJson(this);
}
