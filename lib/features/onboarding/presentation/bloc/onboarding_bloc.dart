import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:find_a_nikah/core/core.dart';
import 'package:find_a_nikah/features/onboarding/domain/domain.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'onboarding_bloc.freezed.dart';

sealed class OnboardingEvent {
  const OnboardingEvent();
}

final class OnboardingDraftSubscribed extends OnboardingEvent {
  const OnboardingDraftSubscribed();
}

/// One wizard answer. Each page supplies its own `copyWith`, so the bloc
/// needs one event instead of ~20 setters.
final class OnboardingAnswerSaved extends OnboardingEvent {
  const OnboardingAnswerSaved(this.update);
  final OnboardingData Function(OnboardingData draft) update;
}

/// Fills the empty photo slots from the gallery.
final class ProfilePhotosPickRequested extends OnboardingEvent {
  const ProfilePhotosPickRequested();
}

final class ProfilePhotoRemoved extends OnboardingEvent {
  const ProfilePhotoRemoved(this.index);
  final int index;
}

final class BioGenerationRequested extends OnboardingEvent {
  const BioGenerationRequested();
}

/// Fired by the last page of each wizard section — submits that section to
/// the backend (steps 4-7). A `BlocListener` on the triggering page
/// navigates forward once [OnboardingState.submittingStep] clears with no
/// failure.
final class BasicsSubmitted extends OnboardingEvent {
  const BasicsSubmitted();
}

final class BackgroundFaithSubmitted extends OnboardingEvent {
  const BackgroundFaithSubmitted();
}

final class LifestylePersonalitySubmitted extends OnboardingEvent {
  const LifestylePersonalitySubmitted();
}

final class BioSubmitted extends OnboardingEvent {
  const BioSubmitted();
}

/// "Continue" on Add photos — uploads the photos (step 8) before face
/// verification starts. Skipped when the same photos already went up from
/// this bloc (back-and-forth through the Verification part).
final class PhotosSubmitted extends OnboardingEvent {
  const PhotosSubmitted();
}

@freezed
abstract class OnboardingState with _$OnboardingState {
  const factory OnboardingState({
    required OnboardingData draft,

    /// The gallery is open.
    @Default(false) bool pickingPhotos,

    /// How many picked photos were dropped by the last pick for going over
    /// [OnboardingData.maxPhotos] — the page shows a notice when it's > 0.
    @Default(0) int photosOverLimit,

    /// Photos were chosen and are being compressed before they're added —
    /// the page shows a blocking progress dialog.
    @Default(false) bool processingPhotos,

    /// The uploaded photo currently being deleted on the server (its URL)
    /// — that slot shows a spinner and removals are locked meanwhile.
    String? deletingPhoto,
    @Default(false) bool generatingBio,
    String? generatedBio,

    /// True while a `*Submitted` section PATCH (or the step-8 photo
    /// upload) is in flight.
    @Default(false) bool submittingStep,

    /// Shown once by the page's listener.
    Failure? failure,
  }) = _OnboardingState;
}

/// Provided by the wizard shells (Profile part and Verification part). All
/// instances share the session's draft repository.
class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  OnboardingBloc(
    this._drafts,
    this._photos,
    this._aiBio,
    this._submissions,
    this._profile,
  ) : super(OnboardingState(draft: _drafts.current)) {
    on<OnboardingDraftSubscribed>(
      (_, emit) async {
        // Best effort, once per bloc instance: prefill sections already
        // submitted server-side, so a resumed user sees their previous
        // choices instead of blank pages when they navigate back. A
        // failure here just means no prefill — never blocks the wizard.
        final existing = await _profile.fetchSubmittedDraft();
        await existing.fold(
          (_) async {},
          (draft) async {
            if (draft != null) await _drafts.save(draft);
          },
        );
        await emit.forEach<OnboardingData>(
          _drafts.watchDraft(),
          onData: (draft) => state.copyWith(draft: draft),
        );
      },
      transformer: restartable(),
    );
    // Read-modify-write on the draft: keep edits in order.
    on<OnboardingAnswerSaved>(
      (e, emit) => _save(emit, e.update(_drafts.current)),
      transformer: sequential(),
    );
    // on<ProfilePhotoRemoved>(
    //   (e, emit) => _save(emit, _drafts.current.withPhotoRemoved(e.index)),
    //   transformer: sequential(),
    // );
    on<ProfilePhotoRemoved>(_onPhotoRemoved, transformer: sequential());
    on<ProfilePhotosPickRequested>(_onPick, transformer: droppable());
    on<BioGenerationRequested>(_onBioGeneration, transformer: droppable());
    on<BasicsSubmitted>(
      (_, emit) => _submit(emit, _submissions.submitBasics),
      transformer: droppable(),
    );
    on<BackgroundFaithSubmitted>(
      (_, emit) => _submit(emit, _submissions.submitBackgroundFaith),
      transformer: droppable(),
    );
    on<LifestylePersonalitySubmitted>(
      (_, emit) => _submit(emit, _submissions.submitLifestylePersonality),
      transformer: droppable(),
    );
    on<BioSubmitted>(
      (_, emit) => _submit(emit, _submissions.submitBio),
      transformer: droppable(),
    );
    on<PhotosSubmitted>(_onPhotosSubmitted, transformer: droppable());
  }

  final OnboardingDraftRepository _drafts;
  final PhotoPickerRepository _photos;
  final AiBioRepository _aiBio;
  final OnboardingSubmissionRepository _submissions;
  final OnboardingProfileRepository _profile;

  /// The photo list last uploaded successfully by this bloc.
  List<String>? _uploadedPhotos;

  Future<void> _save(Emitter<OnboardingState> emit, OnboardingData next) async {
    final result = await _drafts.save(next);
    result.fold((f) => emit(state.copyWith(failure: f)), (_) {});
  }

  Future<void> _submit(
    Emitter<OnboardingState> emit,
    Future<Either<Failure, Unit>> Function(OnboardingData) submit,
  ) async {
    emit(state.copyWith(submittingStep: true, failure: null));
    final result = await submit(_drafts.current);
    emit(
      result.fold(
        (f) => state.copyWith(submittingStep: false, failure: f),
        (_) => state.copyWith(submittingStep: false),
      ),
    );
  }

  Future<void> _onPhotosSubmitted(
    PhotosSubmitted event,
    Emitter<OnboardingState> emit,
  ) async {
    final photos = _drafts.current.photoPaths;
    final uploaded = _uploadedPhotos;
    if (uploaded != null && _samePhotos(uploaded, photos)) {
      // Same true → false pulse a real upload produces, so the page's
      // listener moves on exactly the same way.
      emit(state.copyWith(submittingStep: true, failure: null));
      emit(state.copyWith(submittingStep: false));
      return;
    }
    await _submit(emit, _submissions.submitPhotos);
    if (state.failure == null) _uploadedPhotos = List.of(photos);
  }

  static bool _samePhotos(List<String> a, List<String> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  /// Local photo → just drop it. Uploaded photo → delete it on the server
  /// first, and only drop it once that succeeds (a failure keeps it and
  /// shows a toast).
  Future<void> _onPhotoRemoved(
    ProfilePhotoRemoved event,
    Emitter<OnboardingState> emit,
  ) async {
    final photos = _drafts.current.photoPaths;
    if (event.index < 0 || event.index >= photos.length) return;
    final path = photos[event.index];
    if (!OnboardingData.isUploadedPhoto(path)) {
      await _save(emit, _drafts.current.withPhotoRemoved(event.index));
      return;
    }

    emit(state.copyWith(deletingPhoto: path, failure: null));
    final result = await _submissions.deleteUploadedPhoto(path);
    emit(state.copyWith(deletingPhoto: null));
    await result.fold(
      (f) async => emit(state.copyWith(failure: f)),
      (_) async {
        // Re-find it: the list may have changed while the call ran.
        final index = _drafts.current.photoPaths.indexOf(path);
        if (index != -1) {
          await _save(emit, _drafts.current.withPhotoRemoved(index));
        }
        _uploadedPhotos?.remove(path);
      },
    );
  }

  Future<void> _onPick(
    ProfilePhotosPickRequested event,
    Emitter<OnboardingState> emit,
  ) async {
    final remaining = _drafts.current.remainingPhotoSlots;
    if (remaining <= 0) return;
    emit(
      state.copyWith(pickingPhotos: true, failure: null, photosOverLimit: 0),
    );
    final picked = await _photos.pickFromGallery(limit: remaining);
    emit(state.copyWith(pickingPhotos: false));
    final raw = picked.fold((f) {
      emit(state.copyWith(failure: f));
      return const <String>[];
    }, (paths) => paths);
    if (raw.isEmpty) return;
    // Safety net for galleries that ignore the limit: keep the first ones
    // and skip compressing the rest.
    final keep = raw.take(remaining).toList();
    if (raw.length > keep.length) {
      emit(state.copyWith(photosOverLimit: raw.length - keep.length));
    }

    emit(state.copyWith(processingPhotos: true));
    // final prepared = await _photos.preparePhotos(raw);
    final prepared = await _photos.preparePhotos(keep);
    emit(state.copyWith(processingPhotos: false));
    await prepared.fold(
      (f) async => emit(state.copyWith(failure: f)),
      (paths) => _save(emit, _drafts.current.withPhotosAdded(paths)),
    );
    // Before: pick + compress in one call (see PhotoPickerRepositoryImpl).
    // await picked.fold(
    //   (f) async => emit(state.copyWith(failure: f)),
    //   (paths) async {
    //     if (paths.isNotEmpty) {
    //       await _save(emit, _drafts.current.withPhotosAdded(paths));
    //     }
    //   },
    // );
  }

  Future<void> _onBioGeneration(
    BioGenerationRequested event,
    Emitter<OnboardingState> emit,
  ) async {
    emit(
      state.copyWith(
        generatingBio: true,
        generatedBio: null,
        failure: null,
      ),
    );
    final generated = await _aiBio.generateBio();
    await generated.fold(
      (failure) async => emit(
        state.copyWith(generatingBio: false, failure: failure),
      ),
      (bio) async {
        final saved = await _drafts.save(_drafts.current.copyWith(bio: bio));
        saved.fold(
          (failure) => emit(
            state.copyWith(
              generatingBio: false,
              generatedBio: bio,
              failure: failure,
            ),
          ),
          (_) => emit(
            state.copyWith(
              draft: _drafts.current,
              generatingBio: false,
              generatedBio: bio,
            ),
          ),
        );
      },
    );
  }
}
