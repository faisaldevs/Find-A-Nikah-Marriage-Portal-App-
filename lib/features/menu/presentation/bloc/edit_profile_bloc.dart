import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:find_a_nikah/core/core.dart';
import 'package:find_a_nikah/features/menu/domain/domain.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'edit_profile_bloc.freezed.dart';

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

enum EditProfileTab { preview, edit }

enum EditProfileStatus { loading, ready, failure }

@freezed
abstract class EditProfileState with _$EditProfileState {
  const factory EditProfileState({
    @Default(EditProfileStatus.loading) EditProfileStatus status,
    @Default(EditProfileTab.edit) EditProfileTab tab,
    MyProfile? profile,
    @Default(AppSettings()) AppSettings settings,
    Failure? failure,
  }) = _EditProfileState;
}

/// Edit profile: the member's profile grouped into sections. Rows don't
/// edit yet (no profile API) — only the gold badge toggle is live.
class EditProfileBloc extends Bloc<EditProfileEvent, EditProfileState> {
  EditProfileBloc(this._repo) : super(const EditProfileState()) {
    on<EditProfileStarted>(_onStarted, transformer: restartable());
    on<EditProfileTabSelected>((e, emit) => emit(state.copyWith(tab: e.tab)));
    on<GoldBadgeToggled>(_onGoldBadge, transformer: sequential());
  }

  final MenuRepository _repo;

  Future<void> _onStarted(
    EditProfileStarted event,
    Emitter<EditProfileState> emit,
  ) async {
    emit(state.copyWith(status: EditProfileStatus.loading, failure: null));
    final profile = await _repo.fetchMyProfile();
    final settings = await _repo.fetchSettings();
    emit(
      profile
          .flatMap((p) => settings.map((s) => (p, s)))
          .fold(
            (f) =>
                state.copyWith(status: EditProfileStatus.failure, failure: f),
            (r) => state.copyWith(
              status: EditProfileStatus.ready,
              profile: r.$1,
              settings: r.$2,
            ),
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
