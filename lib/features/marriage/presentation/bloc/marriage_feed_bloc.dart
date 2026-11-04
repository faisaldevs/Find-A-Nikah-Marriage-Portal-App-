import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:find_a_nikah/core/core.dart';
import 'package:find_a_nikah/features/discovery/domain/domain.dart';
import 'package:find_a_nikah/features/marriage/domain/entities/marriage_profile.dart';
import 'package:find_a_nikah/features/marriage/domain/entities/swipe.dart';
import 'package:find_a_nikah/features/marriage/domain/repositories/marriage_repository.dart';

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

/// Middle button / compliment box: sends [text] to the current profile
/// (`complement`). Stays on the profile so the sent message shows on it.
final class MarriageComplimentSubmitted extends MarriageFeedEvent {
  const MarriageComplimentSubmitted(this.text);

  final String text;
}

enum MarriageFeedStatus { initial, loading, ready, failure }

enum ComplimentStatus { sending, sent }

/// The compliment sent to one profile, shown above its photo.
class SentCompliment extends Equatable {
  const SentCompliment(this.text, this.status);

  final String text;
  final ComplimentStatus status;

  @override
  List<Object?> get props => [text, status];
}

/// One-shot messages for the page to show (then cleared).
enum MarriageFeedNotice {
  /// A like turned into a match.
  matched,

  /// Undo on a profile that was liked.
  undoUnavailable,

  /// A swipe/undo call failed — see [MarriageFeedState.actionFailure].
  actionFailed,
}

class MarriageFeedState extends Equatable {
  const MarriageFeedState({
    this.status = MarriageFeedStatus.initial,
    this.profiles = const <MarriageProfile>[],
    this.index = 0,
    this.filters = const DiscoveryFilters(),
    this.nextCursor,
    this.loadingMore = false,
    this.failure,
    this.swiped = const <String, SwipeAction>{},
    this.compliments = const <String, SentCompliment>{},
    this.notice,
    this.actionFailure,
    this.matchedName,
  });

  final MarriageFeedStatus status;
  final List<MarriageProfile> profiles;
  final int index;
  final DiscoveryFilters filters;
  final String? nextCursor;
  final bool loadingMore;
  final Failure? failure;

  /// userId → what was sent for it, so undo knows whether the profile
  /// it would go back to was passed (undoable) or liked (not).
  final Map<String, SwipeAction> swiped;

  /// userId → the compliment sent to them (sending, then sent).
  final Map<String, SentCompliment> compliments;

  final MarriageFeedNotice? notice;

  /// With [MarriageFeedNotice.actionFailed].
  final Failure? actionFailure;

  /// Name of the profile behind [MarriageFeedNotice.matched].
  final String? matchedName;

  MarriageProfile? get current =>
      profiles.isEmpty ? null : profiles[index.clamp(0, profiles.length - 1)];

  bool get canGoBack => index > 0;

  bool get reachedEnd => nextCursor == null;

  MarriageFeedState copyWith({
    MarriageFeedStatus? status,
    List<MarriageProfile>? profiles,
    int? index,
    DiscoveryFilters? filters,
    Object? nextCursor = unchanged,
    bool? loadingMore,
    Object? failure = unchanged,
    Map<String, SwipeAction>? swiped,
    Map<String, SentCompliment>? compliments,
    Object? notice = unchanged,
    Object? actionFailure = unchanged,
    Object? matchedName = unchanged,
  }) {
    return MarriageFeedState(
      status: status ?? this.status,
      profiles: profiles ?? this.profiles,
      index: index ?? this.index,
      filters: filters ?? this.filters,
      nextCursor: identical(nextCursor, unchanged)
          ? this.nextCursor
          : nextCursor as String?,
      loadingMore: loadingMore ?? this.loadingMore,
      failure: identical(failure, unchanged)
          ? this.failure
          : failure as Failure?,
      swiped: swiped ?? this.swiped,
      compliments: compliments ?? this.compliments,
      notice: identical(notice, unchanged)
          ? this.notice
          : notice as MarriageFeedNotice?,
      actionFailure: identical(actionFailure, unchanged)
          ? this.actionFailure
          : actionFailure as Failure?,
      matchedName: identical(matchedName, unchanged)
          ? this.matchedName
          : matchedName as String?,
    );
  }

  @override
  List<Object?> get props => [
    status,
    profiles,
    index,
    filters,
    nextCursor,
    loadingMore,
    failure,
    swiped,
    compliments,
    notice,
    actionFailure,
    matchedName,
  ];
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
    on<MarriageComplimentSubmitted>(_onCompliment, transformer: sequential());
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

  Future<void> _onCompliment(
    MarriageComplimentSubmitted event,
    Emitter<MarriageFeedState> emit,
  ) async {
    final profile = state.current;
    final text = event.text.trim();
    if (profile == null || text.isEmpty) return;
    if (state.status != MarriageFeedStatus.ready) return;
    void setCompliment(SentCompliment? c) => emit(
      state.copyWith(
        compliments: {...state.compliments}
          ..remove(profile.id)
          ..addAll({profile.id: ?c}),
      ),
    );
    setCompliment(SentCompliment(text, ComplimentStatus.sending));
    final result = await _feed.swipe(
      SwipeAction.complement,
      targetUserId: profile.id,
      text: text,
    );
    result.fold(
      (f) {
        setCompliment(null);
        _notify(emit, MarriageFeedNotice.actionFailed, failure: f);
      },
      (outcome) {
        // The server counts it as a like: undo can't bring it back.
        emit(
          state.copyWith(
            swiped: {...state.swiped, profile.id: SwipeAction.complement},
          ),
        );
        setCompliment(SentCompliment(text, ComplimentStatus.sent));
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
    if (state.swiped[previous.id] == SwipeAction.like ||
        state.swiped[previous.id] == SwipeAction.complement) {
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
