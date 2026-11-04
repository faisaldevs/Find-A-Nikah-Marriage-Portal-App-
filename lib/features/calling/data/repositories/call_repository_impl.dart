import 'package:find_a_nikah/core/core.dart';
import 'package:find_a_nikah/features/calling/data/datasources/dummy_call_data_source.dart';
import 'package:find_a_nikah/features/calling/data/mappers/call_mappers.dart';
import 'package:find_a_nikah/features/calling/domain/domain.dart';
import 'package:find_a_nikah/features/messaging/domain/domain.dart';

/// Session-scoped: live calls end with the session.
class CallRepositoryImpl implements CallRepository {
  CallRepositoryImpl(this._dummy, this._guard);

  // Dev-only for now — no calling SDK or signalling backend yet.
  final DummyCallDataSource _dummy;
  final Guard _guard;

  /// Call id → who's on the other end (the wire only sends the id).
  final _peers = <String, ChatPeer>{};

  @override
  Future<Either<Failure, CallSession>> dial(ChatPeer peer) => _guard(() async {
    final call = await _dummy.dial(peer.id);
    _peers[call.id] = peer;
    return call.toEntity(peer);
  });

  @override
  Future<Either<Failure, CallSession>> simulateIncoming(ChatPeer peer) =>
      _guard(() async {
        final call = await _dummy.ringIncoming(peer.id);
        _peers[call.id] = peer;
        return call.toEntity(peer);
      });

  @override
  Stream<CallSession> watchCall(String callId) =>
      _dummy.watch(callId).map((c) => c.toEntity(_peers[callId]!));

  @override
  Future<Either<Failure, Unit>> accept(String callId) =>
      _run(() => _dummy.accept(callId));

  @override
  Future<Either<Failure, Unit>> decline(String callId) =>
      _run(() => _dummy.decline(callId));

  @override
  Future<Either<Failure, Unit>> hangUp(String callId) =>
      _run(() => _dummy.hangUp(callId));

  @override
  Future<Either<Failure, Unit>> setMuted(
    String callId, {
    required bool muted,
  }) => _run(() => _dummy.setMuted(callId, muted: muted));

  @override
  Future<Either<Failure, Unit>> setSpeaker(String callId, {required bool on}) =>
      _run(() => _dummy.setSpeaker(callId, on: on));

  Future<Either<Failure, Unit>> _run(Future<void> Function() action) =>
      _guard(() async {
        await action();
        return unit;
      });

  Future<void> dispose() => _dummy.dispose();
}
