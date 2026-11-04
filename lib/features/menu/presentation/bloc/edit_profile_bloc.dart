import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:find_a_nikah/core/core.dart';
import 'package:find_a_nikah/features/menu/domain/domain.dart';

sealed class EditProfileEvent {
  const EditProfileEvent();
}

final class EditProfileStarted extends EditProfileEvent {
  const EditProfileStarted();
}

final class EditProfileTabSelected extends EditProfileEvent {
  const EditProfileTabSelected(this.tab);
  final EditProfileTab tab;
}

/// "Gold member badge" toggle.
final class GoldBadgeToggled extends EditProfileEvent {
  const GoldBadgeToggled({required this.visible});
  final bool visible;
}

/// A field page saved: show the profile the server returned.
/// (Unused since edits became optimistic: see [EditProfileSaveRequested].)
final class EditProfileUpdated extends EditProfileEvent {
  const EditProfileUpdated(this.profile);
  final MyProfile profile;
}

/// A field page's "Update": shown at once, saved in the background.
final class EditProfileSaveRequested extends EditProfileEvent {
  const EditProfileSaveRequested(this.patch);
  final ProfilePatch patch;
}

/// Photo sheet → "Use as main photo".
final class EditProfilePhotoMadeMain extends EditProfileEvent {
  const EditProfilePhotoMadeMain(this.photoUrl);
  final String photoUrl;
}

/// Photo sheet → "Delete".
final class EditProfilePhotoDeleted extends EditProfileEvent {
  const EditProfilePhotoDeleted(this.photoUrl);
  final String photoUrl;
}

enum EditProfileTab { preview, edit }

enum EditProfileStatus { loading, ready, failure }

class EditProfileState extends Equatable {
  const EditProfileState({
    this.status = EditProfileStatus.loading,
    this.tab = EditProfileTab.edit,
    this.profile,
    this.settings = const AppSettings(),
    this.failure,
    this.photoBusy = false,
  });

  final EditProfileStatus status;
  final EditProfileTab tab;
  final MyProfile? profile;
  final AppSettings settings;
  final Failure? failure;

  /// A photo change is being saved.
  final bool photoBusy;

  EditProfileState copyWith({
    EditProfileStatus? status,
    EditProfileTab? tab,
    Object? profile = unchanged,
    AppSettings? settings,
    Object? failure = unchanged,
    bool? photoBusy,
  }) {
    return EditProfileState(
      status: status ?? this.status,
      tab: tab ?? this.tab,
      profile: identical(profile, unchanged)
          ? this.profile
          : profile as MyProfile?,
      settings: settings ?? this.settings,
      failure: identical(failure, unchanged)
          ? this.failure
          : failure as Failure?,
      photoBusy: photoBusy ?? this.photoBusy,
    );
  }

  @override
  List<Object?> get props => [
    status,
    tab,
    profile,
    settings,
    failure,
    photoBusy,
  ];
}

/// Edit profile: the member's profile grouped into sections. Opens on the
/// cached profile and refreshes quietly. Each row opens a field page
/// (`ProfileFieldEditorPage`) that hands back a [ProfilePatch]; it's shown
/// at once and saved in the background (rolled back with an error toast
/// if the save fails). Photo actions work the same way.
class EditProfileBloc extends Bloc<EditProfileEvent, EditProfileState> {
  EditProfileBloc(this._repo) : super(const EditProfileState()) {
    on<EditProfileStarted>(_onStarted, transformer: restartable());
    on<EditProfileTabSelected>((e, emit) => emit(state.copyWith(tab: e.tab)));
    on<GoldBadgeToggled>(_onGoldBadge, transformer: sequential());
    on<EditProfileUpdated>(
      (e, emit) => emit(state.copyWith(profile: e.profile, failure: null)),
    );
    on<EditProfileSaveRequested>(_onSave);
    on<EditProfilePhotoMadeMain>(_onMakeMain, transformer: droppable());
    on<EditProfilePhotoDeleted>(_onDelete, transformer: droppable());
  }

  final MenuRepository _repo;

  // Before: a loading screen on every visit until the API answered.
  // Future<void> _onStarted(
  //   EditProfileStarted event,
  //   Emitter<EditProfileState> emit,
  // ) async {
  //   emit(state.copyWith(status: EditProfileStatus.loading, failure: null));
  //   final profile = await _repo.fetchMyProfile();
  //   final settings = await _repo.fetchSettings();
  //   emit(
  //     profile
  //         .flatMap((p) => settings.map((s) => (p, s)))
  //         .fold(
  //           (f) => state.copyWith(
  //             status: EditProfileStatus.failure,
  //             failure: f,
  //           ),
  //           (r) => state.copyWith(
  //             status: EditProfileStatus.ready,
  //             profile: r.$1,
  //             settings: r.$2,
  //           ),
  //         ),
  //   );
  // }

  /// Cached profile at once (loading only when there's none), then every
  /// change from the repository, while a fresh copy loads quietly.
  Future<void> _onStarted(
    EditProfileStarted event,
    Emitter<EditProfileState> emit,
  ) async {
    final cached = state.profile ?? await _repo.cachedMyProfile();
    emit(
      state.copyWith(
        status: cached == null
            ? EditProfileStatus.loading
            : EditProfileStatus.ready,
        profile: cached,
        failure: null,
      ),
    );
    // Settings (only the gold crown on Preview) load alongside; they must
    // not hold up the cached profile.
    unawaited(
      _repo.fetchSettings().then((r) {
        if (!emit.isDone) r.map((s) => emit(state.copyWith(settings: s)));
      }),
    );
    final changes = emit.forEach<MyProfile>(
      _repo.myProfileChanges,
      onData: (p) =>
          state.copyWith(status: EditProfileStatus.ready, profile: p),
    );
    final fresh = await _repo.fetchMyProfile();
    fresh.fold(
      // With a cached copy on screen a failed refresh stays quiet.
      (f) {
        if (state.profile == null) {
          emit(state.copyWith(status: EditProfileStatus.failure, failure: f));
        }
      },
      (p) => emit(state.copyWith(status: EditProfileStatus.ready, profile: p)),
    );
    await changes;
  }

  Future<void> _onSave(
    EditProfileSaveRequested event,
    Emitter<EditProfileState> emit,
  ) async {
    emit(state.copyWith(failure: null));
    // The edited profile arrives through `myProfileChanges` straight away.
    final result = await _repo.updateMyProfile(event.patch);
    result.fold((f) => emit(state.copyWith(failure: f)), (_) {});
  }

  Future<void> _onMakeMain(
    EditProfilePhotoMadeMain event,
    Emitter<EditProfileState> emit,
  ) async {
    final photos = state.profile?.photos ?? const <String>[];
    if (!photos.contains(event.photoUrl) || photos.first == event.photoUrl) {
      return;
    }
    final order = [event.photoUrl, ...photos.where((u) => u != event.photoUrl)];
    await _savePhotos(
      emit,
      () => _repo.updateMyProfile(ProfilePatch(photoOrder: order)),
    );
  }

  Future<void> _onDelete(
    EditProfilePhotoDeleted event,
    Emitter<EditProfileState> emit,
  ) => _savePhotos(emit, () => _repo.deletePhoto(event.photoUrl));

  /// The change shows at once (through `myProfileChanges`); `photoBusy`
  /// only blocks a second photo action until the server answers.
  Future<void> _savePhotos(
    Emitter<EditProfileState> emit,
    Future<Either<Failure, MyProfile>> Function() save,
  ) async {
    emit(state.copyWith(photoBusy: true, failure: null));
    final result = await save();
    emit(
      result.fold(
        (f) => state.copyWith(photoBusy: false, failure: f),
        // (p) => state.copyWith(photoBusy: false, profile: p),
        (_) => state.copyWith(photoBusy: false),
      ),
    );
  }

  Future<void> _onGoldBadge(
    GoldBadgeToggled event,
    Emitter<EditProfileState> emit,
  ) async {
    final previous = state.settings;
    final next = previous.copyWith(showGoldBadge: event.visible);
    emit(state.copyWith(settings: next, failure: null));
    final saved = await _repo.saveSettings(next);
    saved.fold(
      (f) => emit(state.copyWith(settings: previous, failure: f)),
      (s) => emit(state.copyWith(settings: s)),
    );
  }
}
