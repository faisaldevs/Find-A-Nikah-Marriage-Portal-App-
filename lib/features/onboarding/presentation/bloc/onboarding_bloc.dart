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

@freezed
abstract class OnboardingState with _$OnboardingState {
  const factory OnboardingState({
    required OnboardingData draft,
    @Default(false) bool pickingPhotos,
    @Default(false) bool generatingBio,
    String? generatedBio,

    /// Shown once by the page's listener.
    Failure? failure,
  }) = _OnboardingState;
}

/// Provided by the wizard shells (Profile part and Verification part). All
/// instances share the session's draft repository.
class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  OnboardingBloc(this._drafts, this._photos, this._aiBio)
    : super(OnboardingState(draft: _drafts.current)) {
    on<OnboardingDraftSubscribed>(
      (_, emit) => emit.forEach<OnboardingData>(
        _drafts.watchDraft(),
        onData: (draft) => state.copyWith(draft: draft),
      ),
      transformer: restartable(),
    );
    // Read-modify-write on the draft: keep edits in order.
    on<OnboardingAnswerSaved>(
      (e, emit) => _save(emit, e.update(_drafts.current)),
      transformer: sequential(),
    );
    on<ProfilePhotoRemoved>(
      (e, emit) => _save(emit, _drafts.current.withPhotoRemoved(e.index)),
      transformer: sequential(),
    );
    on<ProfilePhotosPickRequested>(_onPick, transformer: droppable());
    on<BioGenerationRequested>(_onBioGeneration, transformer: droppable());
  }

  final OnboardingDraftRepository _drafts;
  final PhotoPickerRepository _photos;
  final AiBioRepository _aiBio;

  Future<void> _save(Emitter<OnboardingState> emit, OnboardingData next) async {
    final result = await _drafts.save(next);
    result.fold((f) => emit(state.copyWith(failure: f)), (_) {});
  }

  Future<void> _onPick(
    ProfilePhotosPickRequested event,
    Emitter<OnboardingState> emit,
  ) async {
    final remaining = _drafts.current.remainingPhotoSlots;
    if (remaining <= 0) return;
    emit(state.copyWith(pickingPhotos: true, failure: null));
    final picked = await _photos.pickFromGallery(limit: remaining);
    emit(state.copyWith(pickingPhotos: false));
    await picked.fold(
      (f) async => emit(state.copyWith(failure: f)),
      (paths) async {
        if (paths.isNotEmpty) {
          await _save(emit, _drafts.current.withPhotosAdded(paths));
        }
      },
    );
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
