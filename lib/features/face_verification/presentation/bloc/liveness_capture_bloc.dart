import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:find_a_nikah/core/core.dart';
import 'package:find_a_nikah/features/face_verification/domain/domain.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'liveness_capture_bloc.freezed.dart';

sealed class LivenessCaptureEvent {
  const LivenessCaptureEvent();
}

/// Page opened (or "Try again" on the permission screen).
final class LivenessPermissionRequested extends LivenessCaptureEvent {
  const LivenessPermissionRequested();
}

/// "I'm ready" — starts a `/start` session and the first pose.
final class LivenessCaptureStarted extends LivenessCaptureEvent {
  const LivenessCaptureStarted();
}

/// One analysed live frame, forwarded by the page.
final class LivenessFrameReceived extends LivenessCaptureEvent {
  const LivenessFrameReceived(this.frame);
  final FaceSnapshot frame;
}

/// The page took the burst it was asked for
/// ([LivenessCaptureStatus.takingPhotos]).
final class LivenessBurstCaptured extends LivenessCaptureEvent {
  const LivenessBurstCaptured(this.paths);
  final List<String> paths;
}

/// The page couldn't take the burst (camera error) — redo the pose.
final class LivenessBurstFailed extends LivenessCaptureEvent {
  const LivenessBurstFailed();
}

/// The live camera couldn't be opened.
final class LivenessCameraUnavailable extends LivenessCaptureEvent {
  const LivenessCameraUnavailable();
}

/// "Try again" after a rejection/failure — back to the ready screen.
final class LivenessCaptureRetried extends LivenessCaptureEvent {
  const LivenessCaptureRetried();
}

/// Internal: the current pose wasn't reached within
/// `CaptureConfig.stepTimeout`.
final class _StepTimedOut extends LivenessCaptureEvent {
  const _StepTimedOut();
}

/// Internal: the `/start` session ran out before the upload.
final class _SessionExpired extends LivenessCaptureEvent {
  const _SessionExpired();
}

enum LivenessCaptureStatus {
  /// Asking for camera permission.
  requestingPermission,
  permissionDenied,
  permissionPermanentlyDenied,

  /// Camera open, tips shown, waiting for "I'm ready".
  ready,

  /// Calling `/start`.
  startingSession,

  /// Guiding the user into the current pose.
  capturing,

  /// The page should take [CaptureConfig.burstCount] photos now.
  takingPhotos,

  /// Scoring the burst to keep the best photo.
  choosingPhoto,

  /// All poses captured — uploading.
  submitting,

  /// Upload accepted — the page moves on.
  done,

  /// The server rejected the photos, or the session expired.
  rejected,

  /// Client/network error.
  failed,
}

@freezed
abstract class LivenessCaptureState with _$LivenessCaptureState {
  const factory LivenessCaptureState({
    @Default(LivenessCaptureStatus.requestingPermission)
    LivenessCaptureStatus status,
    FaceSession? session,
    @Default(0) int stepIndex,

    /// Best photo per challenge, keyed by the challenge name.
    @Default(<String, String>{}) Map<String, String> captured,

    /// Live guidance for the current pose.
    PoseHint? hint,
    String? rejectReason,
    @Default(true) bool canRetry,
    Failure? failure,
  }) = _LivenessCaptureState;

  const LivenessCaptureState._();

  LivenessStepPlan get plan => session?.plan ?? LivenessStepPlan.defaultPlan;

  LivenessStep? get currentStep =>
      stepIndex < plan.steps.length ? plan.steps[stepIndex] : null;

  /// The camera should be running (preview + frames).
  bool get cameraActive => switch (status) {
    LivenessCaptureStatus.ready ||
    LivenessCaptureStatus.startingSession ||
    LivenessCaptureStatus.capturing ||
    LivenessCaptureStatus.takingPhotos ||
    LivenessCaptureStatus.choosingPhoto => true,
    _ => false,
  };
}

/// Guided photo capture for face verification: for each `/start`
/// challenge, guide the user into the pose, take a short burst, keep the
/// clearest photo; then upload one photo per challenge. The backend does
/// the verification — this only makes sure the photos are good.
///
/// Provided by the liveness route itself (not the verification shell), so
/// each visit starts clean. Replaces the old hold-to-capture flow that
/// lived in `FaceVerificationBloc` (its `Liveness*` handlers are still
/// there, unused).
class LivenessCaptureBloc
    extends Bloc<LivenessCaptureEvent, LivenessCaptureState> {
  LivenessCaptureBloc(
    this._repository, [
    CaptureConfig config = CaptureConfig.standard,
  ]) : _config = config,
       _scorer = PoseScorer(config),
       super(const LivenessCaptureState()) {
    on<LivenessPermissionRequested>(_onPermission, transformer: droppable());
    on<LivenessCaptureStarted>(_onStart, transformer: droppable());
    on<LivenessFrameReceived>(_onFrame, transformer: sequential());
    on<LivenessBurstCaptured>(_onBurst, transformer: droppable());
    on<LivenessBurstFailed>(_onBurstFailed, transformer: sequential());
    on<LivenessCameraUnavailable>(
      (_, emit) => _fail(emit, const DeviceFailure()),
      transformer: sequential(),
    );
    on<LivenessCaptureRetried>(_onRetry, transformer: droppable());
    on<_StepTimedOut>(_onStepTimedOut, transformer: sequential());
    on<_SessionExpired>(_onSessionExpired, transformer: sequential());
  }

  final FaceVerificationRepository _repository;
  final CaptureConfig _config;
  final PoseScorer _scorer;

  Timer? _stepTimer;
  Timer? _sessionTimer;

  static const _expiredReason =
      'Your verification session timed out. Please try again.';

  Future<void> _onPermission(
    LivenessPermissionRequested event,
    Emitter<LivenessCaptureState> emit,
  ) async {
    emit(state.copyWith(status: LivenessCaptureStatus.requestingPermission));
    final result = await _repository.requestCameraPermission();
    result.fold(
      (f) => _fail(emit, f),
      (permission) => emit(
        state.copyWith(
          status: switch (permission) {
            CameraPermissionStatus.granted => LivenessCaptureStatus.ready,
            CameraPermissionStatus.denied =>
              LivenessCaptureStatus.permissionDenied,
            CameraPermissionStatus.permanentlyDenied =>
              LivenessCaptureStatus.permissionPermanentlyDenied,
          },
        ),
      ),
    );
  }

  Future<void> _onStart(
    LivenessCaptureStarted event,
    Emitter<LivenessCaptureState> emit,
  ) async {
    if (state.status != LivenessCaptureStatus.ready) return;
    emit(state.copyWith(status: LivenessCaptureStatus.startingSession));
    final result = await _repository.startLivenessSession();
    result.fold((f) => _fail(emit, f), (session) {
      _startSessionTimer(session);
      _armStepTimer();
      emit(
        const LivenessCaptureState().copyWith(
          status: LivenessCaptureStatus.capturing,
          session: session,
        ),
      );
    });
  }

  void _onFrame(
    LivenessFrameReceived event,
    Emitter<LivenessCaptureState> emit,
  ) {
    if (state.status != LivenessCaptureStatus.capturing) return;
    final step = state.currentStep;
    if (step == null) return;
    final hint = _scorer.check(event.frame, step.pose);
    if (hint == PoseHint.ok) {
      _stepTimer?.cancel();
      emit(
        state.copyWith(
          hint: hint,
          status: LivenessCaptureStatus.takingPhotos,
        ),
      );
    } else if (hint != state.hint) {
      emit(state.copyWith(hint: hint));
    }
  }

  /// Pose not reached in time: take the burst anyway — the best attempt
  /// still goes up, and the backend decides.
  void _onStepTimedOut(
    _StepTimedOut event,
    Emitter<LivenessCaptureState> emit,
  ) {
    if (state.status != LivenessCaptureStatus.capturing) return;
    emit(state.copyWith(status: LivenessCaptureStatus.takingPhotos));
  }

  Future<void> _onBurst(
    LivenessBurstCaptured event,
    Emitter<LivenessCaptureState> emit,
  ) async {
    final step = state.currentStep;
    if (state.status != LivenessCaptureStatus.takingPhotos || step == null) {
      return;
    }
    emit(state.copyWith(status: LivenessCaptureStatus.choosingPhoto));

    String? best;
    double? bestScore;
    for (final path in event.paths) {
      final analysed = await _repository.analyzeStill(path);
      final score = analysed.fold(
        (_) => null,
        (photo) => _scorer.stillScore(photo, step.pose),
      );
      if (score != null && (bestScore == null || score > bestScore)) {
        best = path;
        bestScore = score;
      }
    }
    if (state.status != LivenessCaptureStatus.choosingPhoto) return;

    if (best == null) {
      // No usable face in any shot — redo this pose.
      _armStepTimer();
      emit(
        state.copyWith(
          status: LivenessCaptureStatus.capturing,
          hint: PoseHint.noFace,
        ),
      );
      return;
    }

    final captured = {...state.captured, step.fieldName: best};
    final next = state.stepIndex + 1;
    if (next < state.plan.steps.length) {
      _armStepTimer();
      emit(
        state.copyWith(
          captured: captured,
          stepIndex: next,
          hint: null,
          status: LivenessCaptureStatus.capturing,
        ),
      );
      return;
    }
    emit(state.copyWith(captured: captured, stepIndex: next, hint: null));
    await _submit(emit);
  }

  void _onBurstFailed(
    LivenessBurstFailed event,
    Emitter<LivenessCaptureState> emit,
  ) {
    if (state.status != LivenessCaptureStatus.takingPhotos) return;
    _armStepTimer();
    emit(state.copyWith(status: LivenessCaptureStatus.capturing, hint: null));
  }

  Future<void> _submit(Emitter<LivenessCaptureState> emit) async {
    final session = state.session;
    if (session == null) return;
    _stepTimer?.cancel();
    _sessionTimer?.cancel();
    if (session.isExpiredAt(DateTime.now())) {
      emit(_expired());
      return;
    }
    emit(state.copyWith(status: LivenessCaptureStatus.submitting));
    final result = await _repository.submitLivenessSteps(
      session: session,
      stepFilePaths: state.captured,
    );
    result.fold(
      (f) => _fail(emit, f),
      (verdict) => emit(switch (verdict) {
        Verified() || UnderReview() => state.copyWith(
          status: LivenessCaptureStatus.done,
        ),
        Rejected(:final reason, :final canRetry) => state.copyWith(
          status: LivenessCaptureStatus.rejected,
          rejectReason: reason,
          canRetry: canRetry,
        ),
      }),
    );
  }

  void _onSessionExpired(
    _SessionExpired event,
    Emitter<LivenessCaptureState> emit,
  ) {
    // Only mid-capture — once uploading, the server decides.
    final capturing = switch (state.status) {
      LivenessCaptureStatus.capturing ||
      LivenessCaptureStatus.takingPhotos ||
      LivenessCaptureStatus.choosingPhoto => true,
      _ => false,
    };
    if (!capturing) return;
    _stepTimer?.cancel();
    emit(_expired());
  }

  LivenessCaptureState _expired() => state.copyWith(
    status: LivenessCaptureStatus.rejected,
    rejectReason: _expiredReason,
    canRetry: true,
  );

  /// Back to the ready screen with a clean slate; the camera stays open.
  void _onRetry(
    LivenessCaptureRetried event,
    Emitter<LivenessCaptureState> emit,
  ) {
    _stepTimer?.cancel();
    _sessionTimer?.cancel();
    emit(const LivenessCaptureState(status: LivenessCaptureStatus.ready));
  }

  void _fail(Emitter<LivenessCaptureState> emit, Failure failure) {
    _stepTimer?.cancel();
    _sessionTimer?.cancel();
    emit(
      state.copyWith(status: LivenessCaptureStatus.failed, failure: failure),
    );
  }

  void _armStepTimer() {
    _stepTimer?.cancel();
    _stepTimer = Timer(_config.stepTimeout, () {
      if (!isClosed) add(const _StepTimedOut());
    });
  }

  void _startSessionTimer(FaceSession session) {
    _sessionTimer?.cancel();
    final expiresAt = session.expiresAt;
    if (expiresAt == null) return;
    final remaining = expiresAt.difference(DateTime.now());
    _sessionTimer = Timer(remaining.isNegative ? Duration.zero : remaining, () {
      if (!isClosed) add(const _SessionExpired());
    });
  }

  @override
  Future<void> close() {
    _stepTimer?.cancel();
    _sessionTimer?.cancel();
    return super.close();
  }
}

/// User-facing instruction for each pose ("right"/"left" = the user's own).
extension LivenessPoseInstruction on LivenessPose {
  String get instruction => switch (this) {
    LivenessPose.front => 'Look straight at the camera',
    LivenessPose.right => 'Slowly turn your head to the right',
    LivenessPose.left => 'Slowly turn your head to the left',
  };
}

/// Live guidance under the circle.
extension PoseHintText on PoseHint {
  String get message => switch (this) {
    PoseHint.noFace => "We can't see your face — move into the circle",
    PoseHint.multipleFaces => 'Make sure only you are in the circle',
    PoseHint.lookStraight => 'Face the camera straight on',
    PoseHint.turnMore => 'Turn a little more',
    PoseHint.ok => 'Hold still…',
  };
}
