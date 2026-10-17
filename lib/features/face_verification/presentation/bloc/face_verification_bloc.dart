import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:find_a_nikah/core/core.dart';
import 'package:find_a_nikah/features/face_verification/domain/domain.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'face_verification_bloc.freezed.dart';

sealed class FaceVerificationEvent {
  const FaceVerificationEvent();
}

/// "Scan your face" opened with the main onboarding photo (route `extra`).
/// Ignored once a photo is set, so returning to the page keeps a changed
/// photo.
final class FaceVerificationProfilePhotoProvided extends FaceVerificationEvent {
  const FaceVerificationProfilePhotoProvided(this.path);
  final String? path;
}

/// "Change photo" / "Add photo".
final class FaceVerificationProfilePhotoChangeRequested
    extends FaceVerificationEvent {
  const FaceVerificationProfilePhotoChangeRequested();
}

final class SelfieCaptureRequested extends FaceVerificationEvent {
  const SelfieCaptureRequested();
}

final class SelfieRetakeRequested extends FaceVerificationEvent {
  const SelfieRetakeRequested();
}

final class FaceVerificationSubmitted extends FaceVerificationEvent {
  const FaceVerificationSubmitted();
}

// ── Guided liveness (`livenessEnabled`) ─────────────────────────────────

/// "Start verification", liveness path: requests camera access, then
/// starts a session.
final class LivenessSessionStartRequested extends FaceVerificationEvent {
  const LivenessSessionStartRequested();
}

/// One analysed frame from `LivenessCameraController`, forwarded by
/// `LivenessCapturePage`. Internal — the page is the only sender.
final class LivenessSnapshotReceived extends FaceVerificationEvent {
  const LivenessSnapshotReceived(this.snapshot);
  final FaceSnapshot snapshot;
}

/// The page captured a still after
/// [FaceVerificationStatus.capturingLivenessStill] told it to.
final class LivenessStillCaptured extends FaceVerificationEvent {
  const LivenessStillCaptured(this.path);
  final String path;
}

/// The current step ran longer than `LivenessConfig.stepTimeout` without
/// completing — dispatched by the bloc's own step timer.
final class LivenessStepTimedOut extends FaceVerificationEvent {
  const LivenessStepTimedOut();
}

/// The page couldn't take the still it was asked for (camera error, app
/// backgrounded mid-capture) — re-arms the current step.
final class LivenessStillCaptureFailed extends FaceVerificationEvent {
  const LivenessStillCaptureFailed();
}

/// The live camera couldn't be opened.
final class LivenessCameraFailed extends FaceVerificationEvent {
  const LivenessCameraFailed();
}

/// The server-side session (`FaceSession.expiresAt`) ran out before the
/// steps were uploaded — dispatched by the bloc's own session timer.
final class LivenessSessionExpired extends FaceVerificationEvent {
  const LivenessSessionExpired();
}

/// "Try again" after a step timeout — redoes the current step only.
final class LivenessStepRetryRequested extends FaceVerificationEvent {
  const LivenessStepRetryRequested();
}

/// All steps captured — uploads them. Self-dispatched once the third step
/// is confirmed; also how a test can drive the submit step directly.
final class LivenessSubmitRequested extends FaceVerificationEvent {
  const LivenessSubmitRequested();
}

/// "Try again" after [FaceVerificationStatus.rejected] or a failure during
/// the liveness flow — starts a brand-new session (steps already
/// captured are discarded).
final class LivenessRetryRequested extends FaceVerificationEvent {
  const LivenessRetryRequested();
}

enum FaceVerificationStatus {
  /// Nothing captured yet.
  idle,

  /// Selfie taken, ML Kit is checking it has exactly one usable face.
  checkingSelfie,

  /// Selfie passed the on-device check — ready to submit.
  selfieReady,

  /// Selfie + profile photo are uploading for server-side matching.
  submitting,

  /// Backend accepted the submission; profile is pending review (or, for
  /// the liveness path, already verified — see
  /// [FaceVerificationState.rejectReason] for the one case that differs).
  underReview,

  /// The on-device check rejected the selfie ([FaceVerificationState.check])
  /// or a call failed ([FaceVerificationState.failure]).
  failed,

  /// Requesting/starting a liveness session.
  startingLivenessSession,

  /// Camera permission was denied (not permanently) — the page offers to
  /// ask again.
  cameraPermissionDenied,

  /// Camera permission is permanently denied — only Settings can fix it.
  cameraPermissionPermanentlyDenied,

  /// Live preview running, showing pose feedback for the current step.
  capturingLiveness,

  /// The current step's hold completed — the page should capture a still
  /// now and dispatch [LivenessStillCaptured]. Transient.
  capturingLivenessStill,

  /// All 3 steps captured; compressing and uploading them.
  submittingLiveness,

  /// The server rejected the submission (distinct from [failed], which is
  /// a client/network error).
  rejected,
}

@freezed
abstract class FaceVerificationState with _$FaceVerificationState {
  const factory FaceVerificationState({
    /// The photo the user confirms is theirs.
    String? profilePhotoPath,

    /// Private selfie; never shown on the public profile.
    String? selfiePath,
    @Default(FaceVerificationStatus.idle) FaceVerificationStatus status,

    /// Why the on-device gate rejected the last selfie or liveness still.
    SelfieCheckResult? check,
    Failure? failure,

    // ── Guided liveness ──────────────────────────────────────────────
    FaceSession? session,
    @Default(0) int currentStepIndex,
    PoseFeedback? poseFeedback,
    @Default(0.0) double holdProgress,
    @Default(<String, String>{}) Map<String, String> capturedStepPaths,
    @Default(false) bool stepTimedOut,
    String? rejectReason,
    @Default(true) bool canRetry,

    /// The backend approved instantly ([Verified]) rather than queueing for
    /// review — the result page words it differently (audit #40).
    @Default(false) bool verified,
  }) = _FaceVerificationState;

  const FaceVerificationState._();

  bool get busy =>
      status == FaceVerificationStatus.checkingSelfie ||
      status == FaceVerificationStatus.submitting ||
      status == FaceVerificationStatus.startingLivenessSession ||
      status == FaceVerificationStatus.submittingLiveness;

  bool get hasSelfie =>
      selfiePath != null && status == FaceVerificationStatus.selfieReady;

  LivenessStepPlan get plan => session?.plan ?? LivenessStepPlan.defaultPlan;

  LivenessStep? get currentLivenessStep => currentStepIndex < plan.steps.length
      ? plan.steps[currentStepIndex]
      : null;
}

/// Drives "Scan your face" → "Start verification" → "Photo verification"
/// (old single-selfie path), and, behind `livenessEnabled`, the guided
/// 3-step liveness capture from the same "Start verification" CTA.
/// Provided by the Verification wizard shell.
class FaceVerificationBloc
    extends Bloc<FaceVerificationEvent, FaceVerificationState> {
  FaceVerificationBloc(
    this._repository, [
    LivenessConfig config = LivenessConfig.standard,
  ]) : _config = config,
       _evaluator = LivenessPoseEvaluator(config),
       super(const FaceVerificationState()) {
    on<FaceVerificationProfilePhotoProvided>(
      (e, emit) {
        if (state.profilePhotoPath == null && e.path != null) {
          emit(state.copyWith(profilePhotoPath: e.path));
        }
      },
      transformer: sequential(),
    );
    on<FaceVerificationProfilePhotoChangeRequested>(
      _onChangePhoto,
      transformer: droppable(),
    );
    on<SelfieCaptureRequested>(_onCapture, transformer: droppable());
    on<SelfieRetakeRequested>(
      (_, emit) => emit(
        FaceVerificationState(profilePhotoPath: state.profilePhotoPath),
      ),
      transformer: sequential(),
    );
    on<FaceVerificationSubmitted>(_onSubmit, transformer: droppable());

    on<LivenessSessionStartRequested>(
      _onLivenessStart,
      transformer: droppable(),
    );
    on<LivenessSnapshotReceived>(_onSnapshot, transformer: sequential());
    on<LivenessStillCaptured>(_onStillCaptured, transformer: droppable());
    on<LivenessStillCaptureFailed>(
      _onStillCaptureFailed,
      transformer: sequential(),
    );
    on<LivenessCameraFailed>(
      (_, emit) => emit(
        state.copyWith(
          status: FaceVerificationStatus.failed,
          failure: const DeviceFailure(),
        ),
      ),
      transformer: sequential(),
    );
    on<LivenessSessionExpired>(_onSessionExpired, transformer: sequential());
    on<LivenessStepTimedOut>(_onStepTimedOut, transformer: sequential());
    on<LivenessStepRetryRequested>(_onStepRetry, transformer: sequential());
    on<LivenessSubmitRequested>(_onLivenessSubmit, transformer: droppable());
    on<LivenessRetryRequested>(_onLivenessRetry, transformer: droppable());
  }

  final FaceVerificationRepository _repository;
  final LivenessConfig _config;
  final LivenessPoseEvaluator _evaluator;

  /// When the current step's feedback last became [PoseFeedback.ok] —
  /// derived bookkeeping, not UI state, so it's a plain field rather than
  /// part of the freezed state.
  DateTime? _holdStartedAt;
  Timer? _stepTimer;
  Timer? _sessionTimer;

  static const _sessionExpiredReason =
      'Your verification session timed out. Please try again.';

  Future<void> _onChangePhoto(
    FaceVerificationProfilePhotoChangeRequested event,
    Emitter<FaceVerificationState> emit,
  ) async {
    final result = await _repository.pickProfilePhoto();
    result.fold(
      (f) => emit(state.copyWith(failure: f)),
      (path) {
        // A new profile photo invalidates any selfie checked against the
        // old one.
        if (path != null) emit(FaceVerificationState(profilePhotoPath: path));
      },
    );
  }

  Future<void> _onCapture(
    SelfieCaptureRequested event,
    Emitter<FaceVerificationState> emit,
  ) async {
    final captured = await _repository.captureSelfie();
    final path = captured.fold((f) {
      emit(
        state.copyWith(status: FaceVerificationStatus.failed, failure: f),
      );
      return null;
    }, (p) => p);
    if (path == null) return;

    emit(
      state.copyWith(
        selfiePath: path,
        status: FaceVerificationStatus.checkingSelfie,
        check: null,
        failure: null,
      ),
    );
    final checked = await _repository.checkSelfie(path);
    emit(
      checked.fold(
        (f) => state.copyWith(
          selfiePath: null,
          status: FaceVerificationStatus.failed,
          failure: f,
        ),
        (result) => result == SelfieCheckResult.ok
            ? state.copyWith(status: FaceVerificationStatus.selfieReady)
            : state.copyWith(
                selfiePath: null,
                status: FaceVerificationStatus.failed,
                check: result,
              ),
      ),
    );
  }

  Future<void> _onSubmit(
    FaceVerificationSubmitted event,
    Emitter<FaceVerificationState> emit,
  ) async {
    final photo = state.profilePhotoPath;
    final selfie = state.selfiePath;
    if (!state.hasSelfie || photo == null || selfie == null) return;
    emit(state.copyWith(status: FaceVerificationStatus.submitting));
    final result = await _repository.submit(
      profilePhotoPath: photo,
      selfiePath: selfie,
    );
    emit(
      result.fold(
        // Keep the selfie so the user can retry without retaking it.
        (f) => state.copyWith(
          status: FaceVerificationStatus.selfieReady,
          failure: f,
        ),
        (_) => state.copyWith(
          status: FaceVerificationStatus.underReview,
          failure: null,
        ),
      ),
    );
  }

  // ── Guided liveness ───────────────────────────────────────────────

  Future<void> _onLivenessStart(
    LivenessSessionStartRequested event,
    Emitter<FaceVerificationState> emit,
  ) async {
    final permission = await _repository.requestCameraPermission();
    final granted = permission.fold((f) {
      emit(state.copyWith(status: FaceVerificationStatus.failed, failure: f));
      return null;
    }, (status) => status);
    if (granted == null) return;
    if (granted == CameraPermissionStatus.denied) {
      emit(
        state.copyWith(status: FaceVerificationStatus.cameraPermissionDenied),
      );
      return;
    }
    if (granted == CameraPermissionStatus.permanentlyDenied) {
      emit(
        state.copyWith(
          status: FaceVerificationStatus.cameraPermissionPermanentlyDenied,
        ),
      );
      return;
    }

    emit(
      state.copyWith(status: FaceVerificationStatus.startingLivenessSession),
    );
    final result = await _repository.startLivenessSession();
    emit(
      result.fold(
        (f) =>
            state.copyWith(status: FaceVerificationStatus.failed, failure: f),
        (session) {
          _resetStepTimer();
          _startSessionTimer(session);
          return FaceVerificationState(
            profilePhotoPath: state.profilePhotoPath,
            session: session,
            status: FaceVerificationStatus.capturingLiveness,
          );
        },
      ),
    );
  }

  void _onSnapshot(
    LivenessSnapshotReceived event,
    Emitter<FaceVerificationState> emit,
  ) {
    if (state.status != FaceVerificationStatus.capturingLiveness) return;
    final step = state.currentLivenessStep;
    if (step == null) return;

    final feedback = _evaluator.evaluate(event.snapshot, step.pose);
    if (feedback != PoseFeedback.ok) {
      _holdStartedAt = null;
      if (_shouldEmitSnapshot(feedback, 0)) {
        emit(state.copyWith(poseFeedback: feedback, holdProgress: 0));
      }
      return;
    }

    final startedAt = _holdStartedAt ??= DateTime.now();
    final elapsedMs = DateTime.now().difference(startedAt).inMilliseconds;
    final totalMs = _config.holdDuration.inMilliseconds;
    final progress = totalMs <= 0 ? 1.0 : (elapsedMs / totalMs).clamp(0.0, 1.0);

    if (progress >= 1.0) {
      _holdStartedAt = null;
      _stepTimer?.cancel();
      emit(
        state.copyWith(
          poseFeedback: feedback,
          holdProgress: 1,
          status: FaceVerificationStatus.capturingLivenessStill,
        ),
      );
      return;
    }

    if (_shouldEmitSnapshot(feedback, progress)) {
      emit(state.copyWith(poseFeedback: feedback, holdProgress: progress));
    }
  }

  /// Emits only when [feedback] changed or [progress] crossed a 0.1 step —
  /// otherwise every camera frame would trigger a rebuild.
  bool _shouldEmitSnapshot(PoseFeedback feedback, double progress) =>
      feedback != state.poseFeedback ||
      (progress * 10).floor() != (state.holdProgress * 10).floor();

  Future<void> _onStillCaptured(
    LivenessStillCaptured event,
    Emitter<FaceVerificationState> emit,
  ) async {
    if (state.status != FaceVerificationStatus.capturingLivenessStill) return;
    final step = state.currentLivenessStep;
    if (step == null) return;

    final checked = await _repository.checkSelfie(
      event.path,
      expectedPose: step.pose,
    );
    await checked.fold(
      (f) async => emit(
        state.copyWith(status: FaceVerificationStatus.failed, failure: f),
      ),
      (result) async {
        if (result != SelfieCheckResult.ok) {
          // Rare: the live gate already confirmed this pose — re-show the
          // same step rather than losing progress on the others.
          _resetStepTimer();
          emit(
            state.copyWith(
              status: FaceVerificationStatus.capturingLiveness,
              poseFeedback: null,
              holdProgress: 0,
              check: result,
            ),
          );
          return;
        }

        final captured = {
          ...state.capturedStepPaths,
          step.fieldName: event.path,
        };
        final nextIndex = state.currentStepIndex + 1;
        _resetStepTimer();
        emit(
          state.copyWith(
            capturedStepPaths: captured,
            currentStepIndex: nextIndex,
            status: FaceVerificationStatus.capturingLiveness,
            poseFeedback: null,
            holdProgress: 0,
            check: null,
            stepTimedOut: false,
          ),
        );
        if (nextIndex >= state.plan.steps.length) {
          add(const LivenessSubmitRequested());
        }
      },
    );
  }

  void _onStillCaptureFailed(
    LivenessStillCaptureFailed event,
    Emitter<FaceVerificationState> emit,
  ) {
    if (state.status != FaceVerificationStatus.capturingLivenessStill) return;
    _holdStartedAt = null;
    _resetStepTimer();
    emit(
      state.copyWith(
        status: FaceVerificationStatus.capturingLiveness,
        poseFeedback: null,
        holdProgress: 0,
      ),
    );
  }

  void _onSessionExpired(
    LivenessSessionExpired event,
    Emitter<FaceVerificationState> emit,
  ) {
    // Only while still capturing — once the upload is in flight, the
    // server decides.
    if (state.status != FaceVerificationStatus.capturingLiveness &&
        state.status != FaceVerificationStatus.capturingLivenessStill) {
      return;
    }
    _holdStartedAt = null;
    _stepTimer?.cancel();
    emit(
      state.copyWith(
        status: FaceVerificationStatus.rejected,
        rejectReason: _sessionExpiredReason,
        canRetry: true,
      ),
    );
  }

  void _onStepTimedOut(
    LivenessStepTimedOut event,
    Emitter<FaceVerificationState> emit,
  ) {
    if (state.status != FaceVerificationStatus.capturingLiveness) return;
    _holdStartedAt = null;
    emit(state.copyWith(stepTimedOut: true, holdProgress: 0));
  }

  void _onStepRetry(
    LivenessStepRetryRequested event,
    Emitter<FaceVerificationState> emit,
  ) {
    _holdStartedAt = null;
    _resetStepTimer();
    emit(
      state.copyWith(
        stepTimedOut: false,
        holdProgress: 0,
        poseFeedback: null,
      ),
    );
  }

  Future<void> _onLivenessSubmit(
    LivenessSubmitRequested event,
    Emitter<FaceVerificationState> emit,
  ) async {
    final session = state.session;
    if (session == null ||
        state.capturedStepPaths.length < state.plan.steps.length) {
      return;
    }
    _stepTimer?.cancel();
    _sessionTimer?.cancel();
    if (session.isExpiredAt(DateTime.now())) {
      emit(
        state.copyWith(
          status: FaceVerificationStatus.rejected,
          rejectReason: _sessionExpiredReason,
          canRetry: true,
        ),
      );
      return;
    }
    emit(state.copyWith(status: FaceVerificationStatus.submittingLiveness));
    final result = await _repository.submitLivenessSteps(
      session: session,
      stepFilePaths: state.capturedStepPaths,
    );
    emit(
      result.fold(
        (f) =>
            state.copyWith(status: FaceVerificationStatus.failed, failure: f),
        (verdict) => switch (verdict) {
          // Verified() || UnderReview() => state.copyWith(
          //   status: FaceVerificationStatus.underReview,
          //   failure: null,
          // ),
          Verified() || UnderReview() => state.copyWith(
            status: FaceVerificationStatus.underReview,
            verified: verdict is Verified,
            failure: null,
          ),
          Rejected(:final reason, :final canRetry) => state.copyWith(
            status: FaceVerificationStatus.rejected,
            rejectReason: reason,
            canRetry: canRetry,
            failure: null,
          ),
        },
      ),
    );
  }

  Future<void> _onLivenessRetry(
    LivenessRetryRequested event,
    Emitter<FaceVerificationState> emit,
  ) async {
    _holdStartedAt = null;
    _stepTimer?.cancel();
    _sessionTimer?.cancel();
    emit(FaceVerificationState(profilePhotoPath: state.profilePhotoPath));
    add(const LivenessSessionStartRequested());
  }

  void _resetStepTimer() {
    _stepTimer?.cancel();
    _stepTimer = Timer(_config.stepTimeout, () {
      if (!isClosed) add(const LivenessStepTimedOut());
    });
  }

  void _startSessionTimer(FaceSession session) {
    _sessionTimer?.cancel();
    final expiresAt = session.expiresAt;
    if (expiresAt == null) return;
    final remaining = expiresAt.difference(DateTime.now());
    _sessionTimer = Timer(remaining.isNegative ? Duration.zero : remaining, () {
      if (!isClosed) add(const LivenessSessionExpired());
    });
  }

  @override
  Future<void> close() {
    _stepTimer?.cancel();
    _sessionTimer?.cancel();
    return super.close();
  }
}

/// User-facing text for a rejected selfie.
extension SelfieCheckResultText on SelfieCheckResult {
  String get message => switch (this) {
    SelfieCheckResult.ok => '',
    SelfieCheckResult.noFace =>
      "We couldn't find a face. Make sure you're in good lighting and "
          'your face fills the frame.',
    SelfieCheckResult.multipleFaces =>
      'Only you should be in the photo. Please retake it alone.',
    SelfieCheckResult.notFrontal =>
      'Please look straight at the camera and try again.',
    SelfieCheckResult.eyesClosed =>
      'Keep your eyes open and look at the camera.',
  };
}

/// User-facing instruction for the guided-liveness capture.
extension PoseFeedbackText on PoseFeedback {
  String get message => switch (this) {
    PoseFeedback.noFace => "We can't see your face",
    PoseFeedback.multipleFaces => 'Only one face, please',
    PoseFeedback.moveCloser => 'Move a little closer',
    PoseFeedback.moveBack => 'Move back a little',
    PoseFeedback.centerFace => 'Center your face in the frame',
    PoseFeedback.lookStraight => 'Look straight at the camera',
    PoseFeedback.turnLeft => 'Slowly turn your head left',
    PoseFeedback.turnRight => 'Slowly turn your head right',
    PoseFeedback.openEyes => 'Keep your eyes open',
    PoseFeedback.holdStill => 'Hold still…',
    PoseFeedback.ok => 'Hold still…',
  };
}
