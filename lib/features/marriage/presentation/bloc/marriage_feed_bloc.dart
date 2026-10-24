import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:find_a_nikah/core/core.dart';
import 'package:find_a_nikah/features/discovery/domain/domain.dart';
import 'package:find_a_nikah/features/marriage/domain/entities/marriage_profile.dart';
import 'package:find_a_nikah/features/marriage/domain/entities/swipe.dart';
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

/// Move to the next profile without a swipe (reloads the deck at the end).
final class MarriageProfileAdvanced extends MarriageFeedEvent {
  const MarriageProfileAdvanced();
}

/// ✕: pass on the current profile (`POST /profiles/swipe` `pass`), then
/// show the next one.
final class MarriageProfilePassed extends MarriageFeedEvent {
  const MarriageProfilePassed();
}

/// ✓: like the current profile (`like`), then show the next one.
final class MarriageProfileLiked extends MarriageFeedEvent {
  const MarriageProfileLiked();
}

/// Undo: rewinds the last pass (`undo`) and goes one profile back. A liked
/// profile can't be undone; no-op on the first.
final class MarriagePreviousRequested extends MarriageFeedEvent {
  const MarriagePreviousRequested();
}

/// End of the deck: fetch it again. Swiped profiles have left the server
/// deck, so this brings the ones still unseen (or the empty state).
final class MarriageDeckReloadRequested extends MarriageFeedEvent {
  const MarriageDeckReloadRequested();
}

/// Loads the next page once the user is near the end of what's loaded.
final class MarriageMoreRequested extends MarriageFeedEvent {
  const MarriageMoreRequested();
}

enum MarriageFeedStatus { initial, loading, ready, failure }

/// One-shot messages for the page to show (then cleared).
enum MarriageFeedNotice {
  /// A like turned into a match.
  matched,

  /// Undo on a profile that was liked.
  undoUnavailable,

  /// A swipe/undo call failed — see [MarriageFeedState.actionFailure].
  actionFailed,
}

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

    /// userId → what was sent for it, so undo knows whether the profile
    /// it would go back to was passed (undoable) or liked (not).
    @Default(<String, SwipeAction>{}) Map<String, SwipeAction> swiped,
    MarriageFeedNotice? notice,

    /// With [MarriageFeedNotice.actionFailed].
    Failure? actionFailure,

    /// Name of the profile behind [MarriageFeedNotice.matched].
    String? matchedName,
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
    // Swipes advance at once and send in the background; undo waits for
    // the server (it may refuse) before going back.
    on<MarriageProfilePassed>(
      (_, emit) => _onSwiped(SwipeAction.pass, emit),
      transformer: sequential(),
    );
    on<MarriageProfileLiked>(
      (_, emit) => _onSwiped(SwipeAction.like, emit),
      transformer: sequential(),
    );
    // on<MarriagePreviousRequested>(_onPrevious, transformer: sequential());
    on<MarriagePreviousRequested>(_onUndo, transformer: droppable());
    on<MarriageDeckReloadRequested>(
      (_, emit) => emit.forEach<MarriageFeedState>(
        _firstPage(state.filters),
        onData: (next) => next,
      ),
      transformer: droppable(),
    );
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
      // if (state.reachedEnd) emit(state.copyWith(index: 0));
      // Real API: swiped profiles leave the deck, so looping would show
      // them again — fetch what's still unseen instead.
      if (state.reachedEnd) {
        add(const MarriageDeckReloadRequested());
        return;
      }
      add(const MarriageMoreRequested());
      return;
    }
    emit(state.copyWith(index: next));
    if (state.profiles.length - next <= prefetchThreshold) {
      add(const MarriageMoreRequested());
    }
  }

  // Before the swipe API: just one profile back.
  // void _onPrevious(
  //   MarriagePreviousRequested event,
  //   Emitter<MarriageFeedState> emit,
  // ) {
  //   if (state.canGoBack) emit(state.copyWith(index: state.index - 1));
  // }

  Future<void> _onSwiped(
    SwipeAction action,
    Emitter<MarriageFeedState> emit,
  ) async {
    final profile = state.current;
    if (profile == null || state.status != MarriageFeedStatus.ready) return;
    emit(state.copyWith(swiped: {...state.swiped, profile.id: action}));
    // On the last card the advance reloads the deck — wait for the swipe
    // to land first, or the reload would still include this profile.
    final last = state.reachedEnd && state.index >= state.profiles.length - 1;
    if (!last) _onAdvanced(const MarriageProfileAdvanced(), emit);
    final result = await _feed.swipe(action, targetUserId: profile.id);
    if (last) _onAdvanced(const MarriageProfileAdvanced(), emit);
    result.fold(
      (f) => _notify(
        emit,
        MarriageFeedNotice.actionFailed,
        failure: f,
      ),
      (outcome) {
        if (outcome.isMatch) {
          _notify(emit, MarriageFeedNotice.matched, name: profile.name);
        }
      },
    );
  }

  Future<void> _onUndo(
    MarriagePreviousRequested event,
    Emitter<MarriageFeedState> emit,
  ) async {
    if (!state.canGoBack) return;
    final previous = state.profiles[state.index - 1];
    if (state.swiped[previous.id] == SwipeAction.like) {
      _notify(emit, MarriageFeedNotice.undoUnavailable);
      return;
    }
    // Not swiped (e.g. stepped past without a swipe): nothing to rewind.
    if (state.swiped[previous.id] == null) {
      emit(state.copyWith(index: state.index - 1));
      return;
    }
    final result = await _feed.swipe(SwipeAction.undo);
    result.fold(
      (f) => _notify(emit, MarriageFeedNotice.actionFailed, failure: f),
      (_) {
        final i = state.profiles.indexWhere((p) => p.id == previous.id);
        if (i < 0) return;
        emit(
          state.copyWith(
            index: i,
            swiped: {...state.swiped}..remove(previous.id),
          ),
        );
      },
    );
  }

  /// Emits [notice] and clears it again, so the same notice can fire twice
  /// in a row.
  void _notify(
    Emitter<MarriageFeedState> emit,
    MarriageFeedNotice notice, {
    Failure? failure,
    String? name,
  }) {
    emit(
      state.copyWith(notice: notice, actionFailure: failure, matchedName: name),
    );
    emit(
      state.copyWith(notice: null, actionFailure: null, matchedName: null),
    );
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
