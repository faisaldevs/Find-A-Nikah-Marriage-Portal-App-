import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:find_a_nikah/core/core.dart';
import 'package:find_a_nikah/core/ui/text/failure_text.dart';
import 'package:find_a_nikah/features/feed/domain/domain.dart';
import 'package:find_a_nikah/features/feed/presentation/bloc/feed_list_state.dart';

sealed class FeedEvent {
  const FeedEvent();
}

final class FeedSubscribed extends FeedEvent {
  const FeedSubscribed();
}

final class FeedFilterSelected extends FeedEvent {
  const FeedFilterSelected(this.filter);

  final FeedFilter filter;
}

/// Pull-to-refresh; [done] completes when the reload has finished.
final class FeedRefreshed extends FeedEvent {
  const FeedRefreshed([this.done]);

  final Completer<void>? done;
}

final class FeedLoadMore extends FeedEvent {
  const FeedLoadMore();
}

/// Live search from the top bar's search mode; empty shows the feed.
final class FeedQueryChanged extends FeedEvent {
  const FeedQueryChanged(this.query);

  final String query;
}

/// The member just published [post] from the compose screen.
final class FeedPostAdded extends FeedEvent {
  const FeedPostAdded(this.post);

  final FeedPost post;
}

/// A post changed on another screen (like, edit, comment count).
final class FeedPostChanged extends FeedEvent {
  const FeedPostChanged(this.post);

  final FeedPost post;
}

final class FeedPostRemoved extends FeedEvent {
  const FeedPostRemoved(this.postId);

  final String postId;
}

/// Hide every post of [userId] (muted / blocked).
final class FeedAuthorRemoved extends FeedEvent {
  const FeedAuthorRemoved(this.userId);

  final String userId;
}

final class FeedPostLikeToggled extends FeedEvent {
  const FeedPostLikeToggled(this.postId);

  final String postId;
}

/// A post card was shown — counted as a view (batched, once per post).
final class FeedPostSeen extends FeedEvent {
  const FeedPostSeen(this.postId);

  final String postId;
}

final class FeedPostDeleteRequested extends FeedEvent {
  const FeedPostDeleteRequested(this.postId);

  final String postId;
}

final class FeedAuthorMuteRequested extends FeedEvent {
  const FeedAuthorMuteRequested(this.userId);

  final String userId;
}

final class FeedAuthorBlockRequested extends FeedEvent {
  const FeedAuthorBlockRequested(this.userId);

  final String userId;
}

final class FeedReportRequested extends FeedEvent {
  const FeedReportRequested(this.report);

  final FeedReport report;
}

class FeedState extends Equatable {
  const FeedState({
    this.filter = const FeedFilter.forYou(),
    this.topics = const <FeedTopic>[],
    this.feed = const FeedListState<FeedPost>(),
    this.query = '',
    this.results = const FeedListState<FeedPost>(),
    this.notice,
  });

  final FeedFilter filter;
  final List<FeedTopic> topics;
  final FeedListState<FeedPost> feed;

  /// The raw text in the search box.
  final String query;

  /// Server search results for [query] (only used while [searching]).
  final FeedListState<FeedPost> results;
  final FeedNotice? notice;

  /// Search mode: a non-blank query shows [results] instead of [feed].
  bool get searching => query.trim().isNotEmpty;

  /// What the list shows right now.
  FeedListState<FeedPost> get shown => searching ? results : feed;

  FeedState copyWith({
    FeedFilter? filter,
    List<FeedTopic>? topics,
    FeedListState<FeedPost>? feed,
    String? query,
    FeedListState<FeedPost>? results,
    Object? notice = unchanged,
  }) {
    return FeedState(
      filter: filter ?? this.filter,
      topics: topics ?? this.topics,
      feed: feed ?? this.feed,
      query: query ?? this.query,
      results: results ?? this.results,
      notice: identical(notice, unchanged)
          ? this.notice
          : notice as FeedNotice?,
    );
  }

  @override
  List<Object?> get props => [filter, topics, feed, query, results, notice];
}

/// Page-scoped on the Feed tab; the tab's `StatefulShellBranch` keeps it
/// alive across tab switches, same as `ExploreBloc`.
class FeedBloc extends Bloc<FeedEvent, FeedState> {
  FeedBloc(this._repo) : super(const FeedState()) {
    on<FeedSubscribed>(_onSubscribed);
    on<FeedFilterSelected>(_onFilterSelected, transformer: restartable());
    on<FeedRefreshed>(_onRefreshed, transformer: droppable());
    on<FeedLoadMore>(_onLoadMore, transformer: droppable());
    on<FeedQueryChanged>(_onQueryChanged, transformer: restartable());
    on<FeedPostAdded>(_onPostAdded);
    on<FeedPostChanged>(_onPostChanged);
    on<FeedPostRemoved>(_onPostRemoved);
    on<FeedAuthorRemoved>(_onAuthorRemoved);
    on<FeedPostLikeToggled>(_onLikeToggled);
    on<FeedPostSeen>(_onSeen);
    on<FeedPostDeleteRequested>(_onDelete);
    on<FeedAuthorMuteRequested>(_onMute);
    on<FeedAuthorBlockRequested>(_onBlock);
    on<FeedReportRequested>(_onReport);
  }

  final FeedRepository _repo;

  /// Wait before searching, so typing does not fire a request per letter.
  static const searchDelay = Duration(milliseconds: 350);

  /// Wait before sending the batch of seen posts.
  static const viewsDelay = Duration(seconds: 3);

  var _noticeId = 0;
  final _liking = <String>{};
  final _seen = <String>{};
  final _unsentViews = <String>[];
  Timer? _viewsTimer;

  FeedNotice _notice(String text, {bool isError = false}) =>
      FeedNotice(++_noticeId, text, isError: isError);

  // ── Loading ────────────────────────────────────────────────────────────
  Future<void> _onSubscribed(
    FeedSubscribed event,
    Emitter<FeedState> emit,
  ) async {
    emit(
      state.copyWith(feed: state.feed.copyWith(status: FeedListStatus.loading)),
    );
    // Topics and posts are independent: a topics failure leaves the chips
    // empty but the posts still load.
    final topics = _repo.fetchTopics();
    final posts = await _repo.fetchPosts(state.filter);
    final topicList = (await topics).getOrElse((_) => state.topics);
    emit(
      state.copyWith(
        topics: topicList,
        feed: posts.fold(
          (f) => state.feed.copyWith(
            status: FeedListStatus.failure,
            failure: f,
          ),
          (page) => const FeedListState<FeedPost>().loaded(page),
        ),
      ),
    );
  }

  Future<void> _onFilterSelected(
    FeedFilterSelected event,
    Emitter<FeedState> emit,
  ) async {
    if (event.filter == state.filter && state.feed.isReady) return;
    emit(
      state.copyWith(
        filter: event.filter,
        feed: const FeedListState<FeedPost>(status: FeedListStatus.loading),
      ),
    );
    await _loadFirstPage(emit);
  }

  Future<void> _onRefreshed(
    FeedRefreshed event,
    Emitter<FeedState> emit,
  ) async {
    if (state.searching) {
      await _search(emit, state.query.trim());
    } else {
      // Keep the list on screen while refreshing; only replace on success.
      final posts = await _repo.fetchPosts(state.filter);
      final topics = await _repo.fetchTopics();
      emit(
        state.copyWith(
          topics: topics.getOrElse((_) => state.topics),
          feed: posts.fold(
            (f) => state.feed.isReady
                ? state.feed
                : state.feed.copyWith(
                    status: FeedListStatus.failure,
                    failure: f,
                  ),
            (page) => const FeedListState<FeedPost>().loaded(page),
          ),
          notice: posts.fold(
            (f) => _notice(f.title, isError: true),
            (_) => state.notice,
          ),
        ),
      );
    }
    event.done?.complete();
  }

  Future<void> _loadFirstPage(Emitter<FeedState> emit) async {
    final posts = await _repo.fetchPosts(state.filter);
    emit(
      state.copyWith(
        feed: posts.fold(
          (f) => state.feed.copyWith(
            status: FeedListStatus.failure,
            failure: f,
          ),
          (page) => const FeedListState<FeedPost>().loaded(page),
        ),
      ),
    );
  }

  Future<void> _onLoadMore(
    FeedLoadMore event,
    Emitter<FeedState> emit,
  ) async {
    final list = state.shown;
    if (!list.canLoadMore) return;
    _setShown(emit, list.copyWith(loadingMore: true));
    final result = state.searching
        ? await _repo.searchPosts(state.query.trim(), cursor: list.nextCursor)
        : await _repo.fetchPosts(state.filter, cursor: list.nextCursor);
    final current = state.shown;
    result.fold(
      (f) {
        _setShown(emit, current.copyWith(loadingMore: false));
        emit(state.copyWith(notice: _notice(f.title, isError: true)));
      },
      (page) => _setShown(emit, current.appended(page, idOf: (p) => p.id)),
    );
  }

  // ── Search ─────────────────────────────────────────────────────────────
  Future<void> _onQueryChanged(
    FeedQueryChanged event,
    Emitter<FeedState> emit,
  ) async {
    emit(state.copyWith(query: event.query));
    if (!state.searching) return;
    emit(
      state.copyWith(
        results: const FeedListState<FeedPost>(status: FeedListStatus.loading),
      ),
    );
    final q = event.query.trim();
    await Future<void>.delayed(searchDelay);
    // `restartable` only mutes the older handler's emits — it keeps
    // running, so it must drop out itself when the member typed on.
    if (state.query.trim() != q) return;
    await _search(emit, q);
  }

  Future<void> _search(Emitter<FeedState> emit, String q) async {
    if (q.isEmpty) return;
    final result = await _repo.searchPosts(q);
    if (state.query.trim() != q) return; // typed on meanwhile
    emit(
      state.copyWith(
        results: result.fold(
          (f) => state.results.copyWith(
            status: FeedListStatus.failure,
            failure: f,
          ),
          (page) => const FeedListState<FeedPost>().loaded(page),
        ),
      ),
    );
  }

  void _setShown(Emitter<FeedState> emit, FeedListState<FeedPost> list) => emit(
    state.searching
        ? state.copyWith(results: list)
        : state.copyWith(feed: list),
  );

  // ── Local changes ──────────────────────────────────────────────────────
  void _onPostAdded(FeedPostAdded event, Emitter<FeedState> emit) {
    final shows = switch (state.filter) {
      FeedForYou() || FeedNewest() => true,
      FeedTopicFilter(:final topic) => topic.id == event.post.topicId,
    };
    if (shows) {
      emit(
        state.copyWith(
          feed: state.feed.copyWith(items: [event.post, ...state.feed.items]),
          notice: _notice('Posted'),
        ),
      );
    } else {
      emit(state.copyWith(notice: _notice('Posted in ${event.post.topic}')));
    }
  }

  void _onPostChanged(FeedPostChanged event, Emitter<FeedState> emit) =>
      _swap(emit, event.post);

  void _swap(Emitter<FeedState> emit, FeedPost post) {
    FeedPost swap(FeedPost p) => p.id == post.id ? post : p;
    emit(
      state.copyWith(
        feed: state.feed.copyWith(items: state.feed.items.map(swap).toList()),
        results: state.results.copyWith(
          items: state.results.items.map(swap).toList(),
        ),
      ),
    );
  }

  void _onPostRemoved(FeedPostRemoved event, Emitter<FeedState> emit) {
    bool keep(FeedPost p) => p.id != event.postId;
    emit(
      state.copyWith(
        feed: state.feed.copyWith(
          items: state.feed.items.where(keep).toList(),
        ),
        results: state.results.copyWith(
          items: state.results.items.where(keep).toList(),
        ),
      ),
    );
  }

  void _onAuthorRemoved(FeedAuthorRemoved event, Emitter<FeedState> emit) {
    bool keep(FeedPost p) => p.author.userId != event.userId;
    emit(
      state.copyWith(
        feed: state.feed.copyWith(
          items: state.feed.items.where(keep).toList(),
        ),
        results: state.results.copyWith(
          items: state.results.items.where(keep).toList(),
        ),
      ),
    );
  }

  /// Flip the heart at once; the server's answer corrects the count, and a
  /// failure rolls it back.
  Future<void> _onLikeToggled(
    FeedPostLikeToggled event,
    Emitter<FeedState> emit,
  ) async {
    if (!_liking.add(event.postId)) return;
    FeedPost? find() => [
      ...state.feed.items,
      ...state.results.items,
    ].where((p) => p.id == event.postId).firstOrNull;
    final before = find();
    if (before == null) {
      _liking.remove(event.postId);
      return;
    }
    final want = !before.likedByMe;
    void apply(FeedPost Function(FeedPost) fn) =>
        _swap(emit, fn(find() ?? before));
    apply(
      (p) => p.copyWith(
        likedByMe: want,
        likeCount: (p.likeCount + (want ? 1 : -1)).clamp(0, 1 << 31),
      ),
    );
    final result = await _repo.setPostLiked(event.postId, liked: want);
    _liking.remove(event.postId);
    result.fold(
      (f) {
        apply(
          (p) => p.copyWith(
            likedByMe: before.likedByMe,
            likeCount: before.likeCount,
          ),
        );
        emit(state.copyWith(notice: _notice(f.title, isError: true)));
      },
      (r) => apply(
        (p) => p.copyWith(
          likedByMe: r.active,
          likeCount: r.count ?? p.likeCount,
        ),
      ),
    );
  }

  // ── Post actions ───────────────────────────────────────────────────────
  Future<void> _onDelete(
    FeedPostDeleteRequested event,
    Emitter<FeedState> emit,
  ) async {
    final r = await _repo.deletePost(event.postId);
    r.fold(
      (f) => emit(state.copyWith(notice: _notice(f.title, isError: true))),
      (_) {
        _onPostRemoved(FeedPostRemoved(event.postId), emit);
        emit(state.copyWith(notice: _notice('Post deleted')));
      },
    );
  }

  Future<void> _onMute(
    FeedAuthorMuteRequested event,
    Emitter<FeedState> emit,
  ) async {
    final r = await _repo.setMuted(event.userId, muted: true);
    r.fold(
      (f) => emit(state.copyWith(notice: _notice(f.title, isError: true))),
      (_) {
        _onAuthorRemoved(FeedAuthorRemoved(event.userId), emit);
        emit(
          state.copyWith(
            notice: _notice('Muted. Their posts are hidden from your feed.'),
          ),
        );
      },
    );
  }

  Future<void> _onBlock(
    FeedAuthorBlockRequested event,
    Emitter<FeedState> emit,
  ) async {
    final r = await _repo.blockMember(event.userId);
    r.fold(
      (f) => emit(state.copyWith(notice: _notice(f.title, isError: true))),
      (_) {
        _onAuthorRemoved(FeedAuthorRemoved(event.userId), emit);
        emit(state.copyWith(notice: _notice('Blocked')));
      },
    );
  }

  Future<void> _onReport(
    FeedReportRequested event,
    Emitter<FeedState> emit,
  ) async {
    final r = await _repo.report(event.report);
    r.fold(
      (f) => emit(
        state.copyWith(
          notice: f.base is ConflictFailure
              ? _notice('You already reported this')
              : _notice(f.title, isError: true),
        ),
      ),
      (_) {
        // A reported post disappears from the reporter's feed.
        if (event.report.postId case final id?) {
          _onPostRemoved(FeedPostRemoved(id), emit);
        }
        emit(
          state.copyWith(notice: _notice('Thanks — we received your report')),
        );
      },
    );
  }

  // ── Views ──────────────────────────────────────────────────────────────
  void _onSeen(FeedPostSeen event, Emitter<FeedState> emit) {
    if (!_seen.add(event.postId)) return;
    _unsentViews.add(event.postId);
    if (_unsentViews.length >= 50) {
      unawaited(_flushViews());
    } else {
      _viewsTimer ??= Timer(viewsDelay, () => unawaited(_flushViews()));
    }
  }

  Future<void> _flushViews() async {
    _viewsTimer?.cancel();
    _viewsTimer = null;
    if (_unsentViews.isEmpty) return;
    final batch = List<String>.of(_unsentViews);
    _unsentViews.clear();
    // Best effort: a lost batch only under-counts views.
    await _repo.recordViews(batch);
  }

  @override
  Future<void> close() {
    _viewsTimer?.cancel();
    return super.close();
  }
}
