import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:find_a_nikah/features/remote_config/domain/entities/remote_config.dart';
import 'package:find_a_nikah/features/remote_config/domain/repositories/remote_config_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'remote_config_bloc.freezed.dart';

sealed class RemoteConfigEvent {
  const RemoteConfigEvent();
}

/// App start and every return to the foreground.
final class RemoteConfigRefreshRequested extends RemoteConfigEvent {
  const RemoteConfigRefreshRequested();
}

@freezed
abstract class RemoteConfigState with _$RemoteConfigState {
  const factory RemoteConfigState({
    required String appVersion,
    @Default(RemoteConfig()) RemoteConfig config,
  }) = _RemoteConfigState;

  const RemoteConfigState._();

  /// The router sends every route to the force-update page while true.
  bool get updateRequired => config.requiresUpdate(appVersion);

  bool isEnabled(FeatureFlag flag) => config.isEnabled(flag);
}

/// App-scoped (above the router).
class RemoteConfigBloc extends Bloc<RemoteConfigEvent, RemoteConfigState> {
  RemoteConfigBloc(this._repository, String appVersion)
    : super(RemoteConfigState(appVersion: appVersion)) {
    on<RemoteConfigRefreshRequested>(_onRefresh, transformer: restartable());
  }

  final RemoteConfigRepository _repository;

  Future<void> _onRefresh(
    RemoteConfigRefreshRequested event,
    Emitter<RemoteConfigState> emit,
  ) async {
    final result = await _repository.fetch();
    // On failure keep whatever we had (defaults on first launch): a config
    // outage must never lock users out.
    result.fold((_) {}, (config) => emit(state.copyWith(config: config)));
  }
}
