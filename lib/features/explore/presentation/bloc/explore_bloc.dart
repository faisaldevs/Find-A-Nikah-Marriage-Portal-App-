import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:find_a_nikah/core/core.dart';
import 'package:find_a_nikah/features/explore/domain/domain.dart';

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

/// Events for one [ExploreLiveSection]. Each section's events run one at
/// a time (a load-more queued while page 1 refreshes runs against the
/// fresh page); different sections run side by side.
sealed class ExploreLiveEvent extends ExploreEvent {
  const ExploreLiveEvent(this.section);

  final ExploreLiveSection section;
}

/// Cache first (if any), then page 1 from the API. Fired for every live
/// section by [ExploreSubscribed].
final class ExploreLiveRefreshed extends ExploreLiveEvent {
  const ExploreLiveRefreshed(super.section);
}

/// The section's sideways strip is near its end — load the next page.
final class ExploreLiveMoreRequested extends ExploreLiveEvent {
  const ExploreLiveMoreRequested(super.section);
}

enum ExploreStatus { initial, loading, ready, failure }

/// One live section's state. `loading` only on a first launch with no
/// cache (shimmer); a cached copy is `ready` straight away.
class ExploreLiveState extends Equatable {
  const ExploreLiveState({
    this.status = ExploreStatus.initial,
    this.section = const ExploreSection(),
    this.loadingMore = false,
  });

  final ExploreStatus status;
  final ExploreSection section;
  final bool loadingMore;

  ExploreLiveState copyWith({
    ExploreStatus? status,
    ExploreSection? section,
    bool? loadingMore,
  }) {
    return ExploreLiveState(
      status: status ?? this.status,
      section: section ?? this.section,
      loadingMore: loadingMore ?? this.loadingMore,
    );
  }

  @override
  List<Object?> get props => [
    status,
    section,
    loadingMore,
  ];
}

class ExploreState extends Equatable {
  const ExploreState({
    this.status = ExploreStatus.initial,
    this.feed = const ExploreFeed(),
    this.failure,
    this.historyStatus = ExploreStatus.initial,
    this.history = const ExploreHistoryFeed(),
    this.historyFailure,
    this.live = const <ExploreLiveSection, ExploreLiveState>{},
  });

  final ExploreStatus status;
  final ExploreFeed feed;
  final Failure? failure;
  final ExploreStatus historyStatus;
  final ExploreHistoryFeed history;
  final Failure? historyFailure;

  /// Real-API, cached, paged sections live outside [feed] — read them
  /// with [liveOf].
  final Map<ExploreLiveSection, ExploreLiveState> live;

  ExploreLiveState liveOf(ExploreLiveSection section) =>
      live[section] ?? const ExploreLiveState();

  ExploreState copyWith({
    ExploreStatus? status,
    ExploreFeed? feed,
    Object? failure = unchanged,
    ExploreStatus? historyStatus,
    ExploreHistoryFeed? history,
    Object? historyFailure = unchanged,
    Map<ExploreLiveSection, ExploreLiveState>? live,
  }) {
    return ExploreState(
      status: status ?? this.status,
      feed: feed ?? this.feed,
      failure: identical(failure, unchanged)
          ? this.failure
          : failure as Failure?,
      historyStatus: historyStatus ?? this.historyStatus,
      history: history ?? this.history,
      historyFailure: identical(historyFailure, unchanged)
          ? this.historyFailure
          : historyFailure as Failure?,
      live: live ?? this.live,
    );
  }

  @override
  List<Object?> get props => [
    status,
    feed,
    failure,
    historyStatus,
    history,
    historyFailure,
    live,
  ];

  ExploreState withLive(ExploreLiveSection section, ExploreLiveState next) =>
      copyWith(live: Map.unmodifiable({...live, section: next}));
}

/// Page-scoped on the Explore tab; the tab's `StatefulShellBranch` keeps it
/// alive across tab switches, same as `MarriageFeedBloc`.
class ExploreBloc extends Bloc<ExploreEvent, ExploreState> {
  ExploreBloc(this._repo) : super(const ExploreState()) {
    on<ExploreSubscribed>(_onSubscribed);
    on<ExploreHistoryRequested>(_onHistoryRequested);
    on<ExploreLiveEvent>(_onLive);
  }

  final ExploreRepository _repo;

  /// Tail of each section's event queue (see [ExploreLiveEvent]).
  final _queues = <ExploreLiveSection, Future<void>>{};

  /// Sections with a load-more already waiting in [_queues]: a second one
  /// would just fetch a page nobody scrolled to.
  final _moreQueued = <ExploreLiveSection>{};

  Future<void> _onSubscribed(
    ExploreSubscribed event,
    Emitter<ExploreState> emit,
  ) async {
    for (final section in ExploreLiveSection.values) {
      add(ExploreLiveRefreshed(section));
    }
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

  Future<void> _onLive(ExploreLiveEvent event, Emitter<ExploreState> emit) {
    final section = event.section;
    if (event is ExploreLiveMoreRequested && !_moreQueued.add(section)) {
      return Future<void>.value();
    }
    final run = (_queues[section] ?? Future<void>.value()).then((_) {
      if (event is ExploreLiveMoreRequested) _moreQueued.remove(section);
      if (emit.isDone) return null;
      return switch (event) {
        ExploreLiveRefreshed() => _refresh(section, emit),
        ExploreLiveMoreRequested() => _loadMore(section, emit),
      };
    });
    _queues[section] = run.catchError((Object _) {});
    return run;
  }

  /// Offline-first: show the cached page 1 at once (no shimmer), fetch
  /// page 1, then quietly swap it in. With a cache on screen a failed
  /// fetch changes nothing; without one the section is hidden.
  Future<void> _refresh(
    ExploreLiveSection section,
    Emitter<ExploreState> emit,
  ) async {
    if (state.liveOf(section).status == ExploreStatus.initial) {
      final cached = await _repo.cachedSection(section);
      if (cached != null) {
        emit(
          state.withLive(
            section,
            ExploreLiveState(status: ExploreStatus.ready, section: cached),
          ),
        );
      }
    }
    if (state.liveOf(section).status != ExploreStatus.ready) {
      emit(
        state.withLive(
          section,
          state.liveOf(section).copyWith(status: ExploreStatus.loading),
        ),
      );
    }
    final result = await _repo.fetchSection(section, page: 1);
    result.fold(
      (_) {
        final current = state.liveOf(section);
        if (current.status != ExploreStatus.ready) {
          emit(
            state.withLive(
              section,
              current.copyWith(status: ExploreStatus.failure),
            ),
          );
        }
      },
      (fresh) => emit(
        state.withLive(
          section,
          ExploreLiveState(status: ExploreStatus.ready, section: fresh),
        ),
      ),
    );
  }

  Future<void> _loadMore(
    ExploreLiveSection section,
    Emitter<ExploreState> emit,
  ) async {
    final current = state.liveOf(section);
    if (current.status != ExploreStatus.ready ||
        !current.section.hasMore ||
        current.loadingMore) {
      return;
    }
    emit(state.withLive(section, current.copyWith(loadingMore: true)));
    final result = await _repo.fetchSection(
      section,
      page: current.section.page + 1,
    );
    final latest = state.liveOf(section);
    result.fold(
      // Next scroll towards the end retries.
      (_) => emit(state.withLive(section, latest.copyWith(loadingMore: false))),
      (next) {
        // Skip anyone already shown — offset paging repeats a profile when
        // the list shifts between requests.
        final shown = latest.section.profiles;
        final seen = {for (final p in shown) p.id};
        emit(
          state.withLive(
            section,
            latest.copyWith(
              loadingMore: false,
              section: next.copyWith(
                profiles: List.unmodifiable([
                  ...shown,
                  ...next.profiles.where((p) => !seen.contains(p.id)),
                ]),
              ),
            ),
          ),
        );
      },
    );
  }
}
