import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:find_a_nikah/core/core.dart';
import 'package:find_a_nikah/features/discovery/domain/domain.dart';
import 'package:find_a_nikah/features/marriage/domain/entities/marriage_profile.dart';
import 'package:find_a_nikah/features/marriage/domain/repositories/marriage_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'marriage_feed_bloc.freezed.dart';

sealed class MarriageFeedEvent {
  const MarriageFeedEvent();
}

/// Starts the feed and restarts it whenever the discovery filters change.
final class MarriageFeedSubscribed extends MarriageFeedEvent {
  const MarriageFeedSubscribed();
}

/// Cancel or Save: move to the next profile (loops at the end).
final class MarriageProfileAdvanced extends MarriageFeedEvent {
  const MarriageProfileAdvanced();
}

/// Previous: one profile back; no-op on the first.
final class MarriagePreviousRequested extends MarriageFeedEvent {
  const MarriagePreviousRequested();
}

/// Loads the next page once the user is near the end of what's loaded.
final class MarriageMoreRequested extends MarriageFeedEvent {
  const MarriageMoreRequested();
}

enum MarriageFeedStatus { initial, loading, ready, failure }

@freezed
abstract class MarriageFeedState with _$MarriageFeedState {
  const factory MarriageFeedState({
    @Default(MarriageFeedStatus.initial) MarriageFeedStatus status,
    @Default(<MarriageProfile>[]) List<MarriageProfile> profiles,
    @Default(0) int index,
    @Default(DiscoveryFilters()) DiscoveryFilters filters,
    String? nextCursor,
    @Default(false) bool loadingMore,
    Failure? failure,
  }) = _MarriageFeedState;

  const MarriageFeedState._();

  MarriageProfile? get current =>
      profiles.isEmpty ? null : profiles[index.clamp(0, profiles.length - 1)];

  bool get canGoBack => index > 0;

  bool get reachedEnd => nextCursor == null;
}

/// Page-scoped on the Marriage tab; the tab's `StatefulShellBranch` keeps
/// it alive across tab switches.
class MarriageFeedBloc extends Bloc<MarriageFeedEvent, MarriageFeedState> {
  MarriageFeedBloc(this._feed, this._filters)
    : super(const MarriageFeedState()) {
    on<MarriageFeedSubscribed>(_onSubscribed, transformer: restartable());
    on<MarriageProfileAdvanced>(_onAdvanced, transformer: sequential());
    on<MarriagePreviousRequested>(_onPrevious, transformer: sequential());
    on<MarriageMoreRequested>(_onMore, transformer: droppable());
  }

  final MarriageRepository _feed;
  final DiscoveryFiltersRepository _filters;

  /// Prefetch when this many profiles are left.
  static const prefetchThreshold = 1;

  Future<void> _onSubscribed(
    MarriageFeedSubscribed event,
    Emitter<MarriageFeedState> emit,
  ) => emit.forEach<MarriageFeedState>(
    _filters.watchFilters().asyncExpand(_firstPage),
    onData: (next) => next,
  );

  Stream<MarriageFeedState> _firstPage(DiscoveryFilters filters) async* {
    yield MarriageFeedState(
      status: MarriageFeedStatus.loading,
      filters: filters,
    );
    final result = await _feed.fetchPage(filters: filters);
    yield result.fold(
      (f) => MarriageFeedState(
        status: MarriageFeedStatus.failure,
        filters: filters,
        failure: f,
      ),
      (page) => MarriageFeedState(
        status: MarriageFeedStatus.ready,
        filters: filters,
        profiles: page.items,
        nextCursor: page.nextCursor,
      ),
    );
  }

  void _onAdvanced(
    MarriageProfileAdvanced event,
    Emitter<MarriageFeedState> emit,
  ) {
    if (state.profiles.isEmpty) return;
    final next = state.index + 1;
    // Loop only once every page is loaded; otherwise stay on the last
    // profile until the next page arrives.
    if (next >= state.profiles.length) {
      if (state.reachedEnd) emit(state.copyWith(index: 0));
      add(const MarriageMoreRequested());
      return;
    }
    emit(state.copyWith(index: next));
    if (state.profiles.length - next <= prefetchThreshold) {
      add(const MarriageMoreRequested());
    }
  }

  void _onPrevious(
    MarriagePreviousRequested event,
    Emitter<MarriageFeedState> emit,
  ) {
    if (state.canGoBack) emit(state.copyWith(index: state.index - 1));
  }

  Future<void> _onMore(
    MarriageMoreRequested event,
    Emitter<MarriageFeedState> emit,
  ) async {
    if (state.reachedEnd || state.status != MarriageFeedStatus.ready) return;
    final filters = state.filters;
    emit(state.copyWith(loadingMore: true));
    final result = await _feed.fetchPage(
      filters: filters,
      cursor: state.nextCursor,
    );
    // Filters changed while loading: the restarted feed wins.
    if (state.filters != filters) return;
    emit(
      result.fold(
        // Keep what's loaded; the next advance retries.
        (_) => state.copyWith(loadingMore: false),
        (page) => state.copyWith(
          profiles: [...state.profiles, ...page.items],
          nextCursor: page.nextCursor,
          loadingMore: false,
        ),
      ),
    );
  }
}
