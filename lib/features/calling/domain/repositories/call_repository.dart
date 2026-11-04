import 'package:find_a_nikah/core/core.dart';
import 'package:find_a_nikah/features/calling/domain/entities/call_session.dart';
import 'package:find_a_nikah/features/messaging/domain/domain.dart';

/// One-to-one voice calls. Faked for now — no calling SDK or signalling
/// backend exists yet (decisions register #13); the session stream is
/// where SDK events will land.
abstract interface class CallRepository {
  /// Places a call to [peer].
  Future<Either<Failure, CallSession>> dial(ChatPeer peer);

  /// Dev only: makes [peer] ring this phone, as a push would.
  Future<Either<Failure, CallSession>> simulateIncoming(ChatPeer peer);

  /// [callId]'s session, through to its ended state.
  Stream<CallSession> watchCall(String callId);

  Future<Either<Failure, Unit>> accept(String callId);

  /// Turns down an incoming call.
  Future<Either<Failure, Unit>> decline(String callId);

  /// Ends the call — or cancels it, if not answered yet.
  Future<Either<Failure, Unit>> hangUp(String callId);

  Future<Either<Failure, Unit>> setMuted(String callId, {required bool muted});

  Future<Either<Failure, Unit>> setSpeaker(String callId, {required bool on});
}
