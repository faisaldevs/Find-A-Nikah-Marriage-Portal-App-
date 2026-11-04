import 'package:equatable/equatable.dart';

/// How a voice call ended, from the signed-in user's side.
enum CallOutcome {
  /// Connected, then hung up by either side.
  completed,

  /// Incoming and never answered.
  missed,

  /// Incoming and turned down by the user.
  declined,

  /// Outgoing and hung up before the peer answered.
  cancelled,
}

/// A voice call, recorded in the conversation as a centred line.
class CallLog extends Equatable {
  const CallLog({
    required this.outcome,
    required this.outgoing,
    this.duration = Duration.zero,
  });

  final CallOutcome outcome;

  /// The signed-in user placed the call.
  final bool outgoing;

  /// Talk time; zero unless [outcome] is [CallOutcome.completed].
  final Duration duration;

  CallLog copyWith({
    CallOutcome? outcome,
    bool? outgoing,
    Duration? duration,
  }) {
    return CallLog(
      outcome: outcome ?? this.outcome,
      outgoing: outgoing ?? this.outgoing,
      duration: duration ?? this.duration,
    );
  }

  @override
  List<Object?> get props => [outcome, outgoing, duration];
}
