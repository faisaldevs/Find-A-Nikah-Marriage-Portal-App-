import 'dart:async';

import 'package:find_a_nikah/features/calling/data/dtos/call_session_dto.dart';

/// Dev-only stand-in for a calling SDK + signalling. No audio: it only
/// moves each call through its states on timers.
///
/// Outgoing: dialing → ringing after [ringingAfter] → connected after
/// [answerAfter] (the peer always answers). Incoming: ringing → missed
/// after [ringTimeout] unless accepted or declined.
class DummyCallDataSource {
  DummyCallDataSource({
    this.ringingAfter = const Duration(seconds: 1),
    this.answerAfter = const Duration(seconds: 5),
    this.ringTimeout = const Duration(seconds: 30),
  });

  final Duration ringingAfter;
  final Duration answerAfter;
  final Duration ringTimeout;

  final _calls = <String, CallSessionDto>{};
  final _changes = StreamController<String>.broadcast();
  final _timers = <String, List<Timer>>{};
  int _seq = 0;

  Future<CallSessionDto> dial(String peerId) async {
    final id = 'call-${++_seq}';
    _put(
      CallSessionDto(
        id: id,
        peerId: peerId,
        direction: 'outgoing',
        phase: 'dialing',
      ),
    );
    _after(id, ringingAfter, () {
      if (_calls[id]?.phase == 'dialing') _update(id, phase: 'ringing');
    });
    _after(id, answerAfter, () {
      if (_calls[id]?.phase == 'ringing') _connect(id);
    });
    return _calls[id]!;
  }

  Future<CallSessionDto> ringIncoming(String peerId) async {
    final id = 'call-${++_seq}';
    _put(
      CallSessionDto(
        id: id,
        peerId: peerId,
        direction: 'incoming',
        phase: 'ringing',
      ),
    );
    _after(id, ringTimeout, () {
      if (_calls[id]?.phase == 'ringing') _end(id, 'missed');
    });
    return _calls[id]!;
  }

  /// Current state first, then every change, until it ends.
  Stream<CallSessionDto> watch(String callId) async* {
    final current = _calls[callId];
    if (current == null) throw StateError('no call $callId');
    yield current;
    if (current.phase == 'ended') return;
    await for (final id in _changes.stream) {
      if (id != callId) continue;
      final call = _calls[id]!;
      yield call;
      if (call.phase == 'ended') return;
    }
  }

  Future<void> accept(String callId) async {
    final call = _require(callId);
    if (call.direction == 'incoming' && call.phase == 'ringing') {
      _connect(callId);
    }
  }

  Future<void> decline(String callId) async {
    final call = _require(callId);
    if (call.phase == 'ringing') _end(callId, 'declined');
  }

  Future<void> hangUp(String callId) async {
    final call = _require(callId);
    switch (call.phase) {
      case 'connected':
        _end(callId, 'completed');
      case 'dialing' || 'ringing':
        _end(callId, call.direction == 'incoming' ? 'declined' : 'cancelled');
    }
  }

  Future<void> setMuted(String callId, {required bool muted}) async {
    _require(callId);
    _update(callId, muted: muted);
  }

  Future<void> setSpeaker(String callId, {required bool on}) async {
    _require(callId);
    _update(callId, speakerOn: on);
  }

  Future<void> dispose() async {
    for (final timers in _timers.values) {
      for (final t in timers) {
        t.cancel();
      }
    }
    await _changes.close();
  }

  void _connect(String id) =>
      _update(id, phase: 'connected', connectedAt: DateTime.now().toUtc());

  void _end(String id, String outcome) {
    for (final t in _timers.remove(id) ?? const <Timer>[]) {
      t.cancel();
    }
    _update(
      id,
      phase: 'ended',
      endedAt: DateTime.now().toUtc(),
      outcome: outcome,
    );
  }

  CallSessionDto _require(String id) =>
      _calls[id] ?? (throw StateError('no call $id'));

  void _put(CallSessionDto call) {
    _calls[call.id] = call;
    if (!_changes.isClosed) _changes.add(call.id);
  }

  void _update(
    String id, {
    String? phase,
    DateTime? connectedAt,
    DateTime? endedAt,
    String? outcome,
    bool? muted,
    bool? speakerOn,
  }) {
    final call = _calls[id];
    if (call == null || call.phase == 'ended') return;
    _put(
      call.copyWith(
        phase: phase,
        connectedAt: connectedAt,
        endedAt: endedAt,
        outcome: outcome,
        muted: muted,
        speakerOn: speakerOn,
      ),
    );
  }

  void _after(String id, Duration delay, void Function() run) {
    (_timers[id] ??= []).add(Timer(delay, run));
  }
}
