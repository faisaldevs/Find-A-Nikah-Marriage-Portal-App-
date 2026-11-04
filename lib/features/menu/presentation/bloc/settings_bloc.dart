import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:find_a_nikah/core/core.dart';
import 'package:find_a_nikah/features/menu/domain/domain.dart';

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

class SettingsState extends Equatable {
  const SettingsState({
    this.status = SettingsStatus.loading,
    this.profile,
    this.settings = const AppSettings(),
    this.failure,
  });

  final SettingsStatus status;
  final MyProfile? profile;
  final AppSettings settings;

  /// Shown once by the page's listener.
  final Failure? failure;

  SettingsState copyWith({
    SettingsStatus? status,
    Object? profile = unchanged,
    AppSettings? settings,
    Object? failure = unchanged,
  }) {
    return SettingsState(
      status: status ?? this.status,
      profile: identical(profile, unchanged)
          ? this.profile
          : profile as MyProfile?,
      settings: settings ?? this.settings,
      failure: identical(failure, unchanged)
          ? this.failure
          : failure as Failure?,
    );
  }

  @override
  List<Object?> get props => [
    status,
    profile,
    settings,
    failure,
  ];
}

/// Settings page: personal info (read-only for now) + switchable
/// preferences. Also backs Edit profile's "Gold member badge" toggle.
class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc(this._repo) : super(const SettingsState()) {
    on<SettingsStarted>(_onStarted, transformer: restartable());
    on<SettingsChanged>(_onChanged, transformer: sequential());
  }

  final MenuRepository _repo;

  // Before: a loading screen on every visit until the API answered.
  // Future<void> _onStarted(
  //   SettingsStarted event,
  //   Emitter<SettingsState> emit,
  // ) async {
  //   emit(state.copyWith(status: SettingsStatus.loading, failure: null));
  //   final profile = await _repo.fetchMyProfile();
  //   final settings = await _repo.fetchSettings();
  //   emit(
  //     profile
  //         .flatMap((p) => settings.map((s) => (p, s)))
  //         .fold(
  //           (f) => state.copyWith(
  //             status: SettingsStatus.failure,
  //             failure: f,
  //           ),
  //           (r) => state.copyWith(
  //             status: SettingsStatus.ready,
  //             profile: r.$1,
  //             settings: r.$2,
  //           ),
  //         ),
  //   );
  // }

  /// Cached profile at once (email / phone rows), then every change, while
  /// a fresh copy loads quietly.
  Future<void> _onStarted(
    SettingsStarted event,
    Emitter<SettingsState> emit,
  ) async {
    final settings = (await _repo.fetchSettings()).toNullable();
    final cached = state.profile ?? await _repo.cachedMyProfile();
    emit(
      state.copyWith(
        status: cached == null ? SettingsStatus.loading : SettingsStatus.ready,
        profile: cached,
        settings: settings,
        failure: null,
      ),
    );
    final changes = emit.forEach<MyProfile>(
      _repo.myProfileChanges,
      onData: (p) => state.copyWith(status: SettingsStatus.ready, profile: p),
    );
    final fresh = await _repo.fetchMyProfile();
    fresh.fold(
      (f) {
        if (state.profile == null) {
          emit(state.copyWith(status: SettingsStatus.failure, failure: f));
        }
      },
      (p) => emit(state.copyWith(status: SettingsStatus.ready, profile: p)),
    );
    await changes;
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
