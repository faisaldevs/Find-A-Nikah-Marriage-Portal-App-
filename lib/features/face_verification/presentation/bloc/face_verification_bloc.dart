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

enum FaceVerificationStatus {
  /// Nothing captured yet.
  idle,

  /// Selfie taken, ML Kit is checking it has exactly one usable face.
  checkingSelfie,

  /// Selfie passed the on-device check — ready to submit.
  selfieReady,

  /// Selfie + profile photo are uploading for server-side matching.
  submitting,

  /// Backend accepted the submission; profile is pending review.
  underReview,

  /// The on-device check rejected the selfie ([FaceVerificationState.check])
  /// or a call failed ([FaceVerificationState.failure]).
  failed,
}

@freezed
abstract class FaceVerificationState with _$FaceVerificationState {
  const factory FaceVerificationState({
    /// The photo the user confirms is theirs.
    String? profilePhotoPath,

    /// Private selfie; never shown on the public profile.
    String? selfiePath,
    @Default(FaceVerificationStatus.idle) FaceVerificationStatus status,

    /// Why the on-device gate rejected the last selfie.
    SelfieCheckResult? check,
    Failure? failure,
  }) = _FaceVerificationState;

  const FaceVerificationState._();

  bool get busy =>
      status == FaceVerificationStatus.checkingSelfie ||
      status == FaceVerificationStatus.submitting;

  bool get hasSelfie =>
      selfiePath != null && status == FaceVerificationStatus.selfieReady;
}

/// Drives "Scan your face" → "Start verification" → "Photo verification".
/// Provided by the Verification wizard shell.
class FaceVerificationBloc
    extends Bloc<FaceVerificationEvent, FaceVerificationState> {
  FaceVerificationBloc(this._repository)
    : super(const FaceVerificationState()) {
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
  }

  final FaceVerificationRepository _repository;

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
