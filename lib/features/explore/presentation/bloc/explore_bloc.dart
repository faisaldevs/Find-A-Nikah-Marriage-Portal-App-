import 'package:bloc/bloc.dart';
import 'package:find_a_nikah/core/core.dart';
import 'package:find_a_nikah/features/explore/domain/domain.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'explore_bloc.freezed.dart';

sealed class ExploreEvent {
  const ExploreEvent();
}

final class ExploreSubscribed extends ExploreEvent {
  const ExploreSubscribed();
}

/// Fired once, the first time the "My history" tab is opened. The bloc
/// guards against refetching on every tab switch.
final class ExploreHistoryRequested extends ExploreEvent {
  const ExploreHistoryRequested();
}

enum ExploreStatus { initial, loading, ready, failure }

@freezed
abstract class ExploreState with _$ExploreState {
  const factory ExploreState({
    @Default(ExploreStatus.initial) ExploreStatus status,
    @Default(ExploreFeed()) ExploreFeed feed,
    Failure? failure,
    @Default(ExploreStatus.initial) ExploreStatus historyStatus,
    @Default(ExploreHistoryFeed()) ExploreHistoryFeed history,
    Failure? historyFailure,
  }) = _ExploreState;
}

/// Page-scoped on the Explore tab; the tab's `StatefulShellBranch` keeps it
/// alive across tab switches, same as `MarriageFeedBloc`.
class ExploreBloc extends Bloc<ExploreEvent, ExploreState> {
  ExploreBloc(this._repo) : super(const ExploreState()) {
    on<ExploreSubscribed>(_onSubscribed);
    on<ExploreHistoryRequested>(_onHistoryRequested);
  }

  final ExploreRepository _repo;

  Future<void> _onSubscribed(
    ExploreSubscribed event,
    Emitter<ExploreState> emit,
  ) async {
    emit(state.copyWith(status: ExploreStatus.loading));
    final result = await _repo.fetchFeed();
    emit(
      result.fold(
        (f) => state.copyWith(status: ExploreStatus.failure, failure: f),
        (feed) => state.copyWith(status: ExploreStatus.ready, feed: feed),
      ),
    );
  }

  Future<void> _onHistoryRequested(
    ExploreHistoryRequested event,
    Emitter<ExploreState> emit,
  ) async {
    if (state.historyStatus == ExploreStatus.loading ||
        state.historyStatus == ExploreStatus.ready) {
      return;
    }
    emit(state.copyWith(historyStatus: ExploreStatus.loading));
    final result = await _repo.fetchHistory();
    emit(
      result.fold(
        (f) => state.copyWith(
          historyStatus: ExploreStatus.failure,
          historyFailure: f,
        ),
        (history) => state.copyWith(
          historyStatus: ExploreStatus.ready,
          history: history,
        ),
      ),
    );
  }
}
