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

enum ExploreStatus { initial, loading, ready, failure }

@freezed
abstract class ExploreState with _$ExploreState {
  const factory ExploreState({
    @Default(ExploreStatus.initial) ExploreStatus status,
    @Default(ExploreFeed()) ExploreFeed feed,
    Failure? failure,
  }) = _ExploreState;
}

/// Page-scoped on the Explore tab; the tab's `StatefulShellBranch` keeps it
/// alive across tab switches, same as `MarriageFeedBloc`.
class ExploreBloc extends Bloc<ExploreEvent, ExploreState> {
  ExploreBloc(this._repo) : super(const ExploreState()) {
    on<ExploreSubscribed>(_onSubscribed);
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
}
