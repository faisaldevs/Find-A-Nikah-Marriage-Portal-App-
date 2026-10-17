import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:find_a_nikah/core/core.dart';
import 'package:find_a_nikah/features/menu/domain/domain.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'settings_bloc.freezed.dart';

sealed class SettingsEvent {
  const SettingsEvent();
}

final class SettingsStarted extends SettingsEvent {
  const SettingsStarted();
}

/// A toggle flipped — applied right away, rolled back if saving fails.
final class SettingsChanged extends SettingsEvent {
  const SettingsChanged(this.update);
  final AppSettings Function(AppSettings settings) update;
}

enum SettingsStatus { loading, ready, failure }

@freezed
abstract class SettingsState with _$SettingsState {
  const factory SettingsState({
    @Default(SettingsStatus.loading) SettingsStatus status,
    MyProfile? profile,
    @Default(AppSettings()) AppSettings settings,

    /// Shown once by the page's listener.
    Failure? failure,
  }) = _SettingsState;
}

/// Settings page: personal info (read-only for now) + switchable
/// preferences. Also backs Edit profile's "Gold member badge" toggle.
class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc(this._repo) : super(const SettingsState()) {
    on<SettingsStarted>(_onStarted, transformer: restartable());
    on<SettingsChanged>(_onChanged, transformer: sequential());
  }

  final MenuRepository _repo;

  Future<void> _onStarted(
    SettingsStarted event,
    Emitter<SettingsState> emit,
  ) async {
    emit(state.copyWith(status: SettingsStatus.loading, failure: null));
    final profile = await _repo.fetchMyProfile();
    final settings = await _repo.fetchSettings();
    emit(
      profile
          .flatMap((p) => settings.map((s) => (p, s)))
          .fold(
            (f) => state.copyWith(status: SettingsStatus.failure, failure: f),
            (r) => state.copyWith(
              status: SettingsStatus.ready,
              profile: r.$1,
              settings: r.$2,
            ),
          ),
    );
  }

  Future<void> _onChanged(
    SettingsChanged event,
    Emitter<SettingsState> emit,
  ) async {
    final previous = state.settings;
    final next = event.update(previous);
    emit(state.copyWith(settings: next, failure: null));
    final saved = await _repo.saveSettings(next);
    saved.fold(
      (f) => emit(state.copyWith(settings: previous, failure: f)),
      (s) => emit(state.copyWith(settings: s)),
    );
  }
}
