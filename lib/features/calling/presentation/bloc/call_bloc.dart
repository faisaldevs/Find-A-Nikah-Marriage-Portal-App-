import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:find_a_nikah/core/core.dart';
import 'package:find_a_nikah/features/calling/domain/domain.dart';
import 'package:find_a_nikah/features/messaging/domain/domain.dart';

sealed class CallEvent {
  const CallEvent();
}

/// Dials the peer, or (dev) makes them ring this phone.
final class CallStarted extends CallEvent {
  const CallStarted();
}

final class CallAccepted extends CallEvent {
  const CallAccepted();
}

final class CallDeclined extends CallEvent {
  const CallDeclined();
}

/// Declines and texts the peer [text] instead.
final class CallQuickReplySent extends CallEvent {
  const CallQuickReplySent(this.text);

  final String text;
}

final class CallHungUp extends CallEvent {
  const CallHungUp();
}

final class CallMuteToggled extends CallEvent {
  const CallMuteToggled();
}

final class CallSpeakerToggled extends CallEvent {
  const CallSpeakerToggled();
}

enum CallStatus { starting, active, failure }

class CallState extends Equatable {
  const CallState({
    required this.peer,
    required this.incoming,
    this.status = CallStatus.starting,
    this.session,
    this.failure,
  });

  final ChatPeer peer;

  /// Opened as an incoming call (Accept / Decline) rather than a dial.
  final bool incoming;
  final CallStatus status;

  /// Null until the call is placed / ringing.
  final CallSession? session;

  /// Set when an action fails; shown once by the page's listener.
  final Failure? failure;

  CallState copyWith({
    CallStatus? status,
    Object? session = unchanged,
    Object? failure = unchanged,
  }) {
    return CallState(
      peer: peer,
      incoming: incoming,
      status: status ?? this.status,
      session: identical(session, unchanged)
          ? this.session
          : session as CallSession?,
      failure: identical(failure, unchanged)
          ? this.failure
          : failure as Failure?,
    );
  }

  @override
  List<Object?> get props => [peer, incoming, status, session, failure];
}

/// One voice call, scoped to the call page. When it ends, the call is
/// recorded in the chat (plus the quick reply, if one was picked).
class CallBloc extends Bloc<CallEvent, CallState> {
  CallBloc(
    this._calls,
    this._messaging,
    ChatPeer peer, {
    required bool incoming,
  }) : super(CallState(peer: peer, incoming: incoming)) {
    on<CallStarted>(_onStarted, transformer: restartable());
    on<CallAccepted>(
      (_, emit) => _act(emit, _calls.accept),
      transformer: droppable(),
    );
    on<CallDeclined>(
      (_, emit) => _act(emit, _calls.decline),
      transformer: droppable(),
    );
    on<CallQuickReplySent>(_onQuickReply, transformer: droppable());
    on<CallHungUp>(
      (_, emit) => _act(emit, _calls.hangUp),
      transformer: droppable(),
    );
    on<CallMuteToggled>(
      (_, emit) => _act(
        emit,
        (id) => _calls.setMuted(id, muted: !(state.session?.muted ?? false)),
      ),
      transformer: sequential(),
    );
    on<CallSpeakerToggled>(
      (_, emit) => _act(
        emit,
        (id) => _calls.setSpeaker(id, on: !(state.session?.speakerOn ?? false)),
      ),
      transformer: sequential(),
    );
  }

  final CallRepository _calls;
  final MessagingRepository _messaging;

  bool _logged = false;
  String? _quickReply;

  Future<void> _onStarted(CallStarted event, Emitter<CallState> emit) async {
    final started = state.incoming
        ? await _calls.simulateIncoming(state.peer)
        : await _calls.dial(state.peer);
    final session = started.toNullable();
    if (session == null) {
      emit(
        state.copyWith(
          status: CallStatus.failure,
          failure: started.getLeft().toNullable(),
        ),
      );
      return;
    }
    await emit.forEach<CallSession>(
      _calls.watchCall(session.id),
      onData: (s) {
        if (s.isEnded && !_logged) {
          _logged = true;
          unawaited(_record(s));
        }
        return state.copyWith(status: CallStatus.active, session: s);
      },
      onError: (e, st) {
        addError(e, st);
        return state.copyWith(status: CallStatus.failure);
      },
    );
  }

  Future<void> _onQuickReply(
    CallQuickReplySent event,
    Emitter<CallState> emit,
  ) async {
    _quickReply = event.text;
    await _act(emit, _calls.decline);
  }

  Future<void> _act(
    Emitter<CallState> emit,
    Future<Either<Failure, Unit>> Function(String callId) action,
  ) async {
    final id = state.session?.id;
    if (id == null) return;
    if (state.failure != null) emit(state.copyWith(failure: null));
    final result = await action(id);
    result.match((f) => emit(state.copyWith(failure: f)), (_) {});
  }

  /// The call line, then the quick reply, so the chat reads in order.
  /// Best effort: the call itself already ended either way.
  Future<void> _record(CallSession s) async {
    final opened = await _messaging.openConversation(s.peer.id);
    final conversation = opened.toNullable();
    if (conversation == null) return;
    await _messaging.logCall(
      conversationId: conversation.id,
      log: CallLog(
        outcome: s.outcome ?? CallOutcome.completed,
        outgoing: s.isOutgoing,
        duration: s.talkTime(),
      ),
    );
    final reply = _quickReply;
    if (reply != null) {
      await _messaging.sendMessage(
        conversationId: conversation.id,
        text: reply,
      );
    }
  }
}
