import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:find_a_nikah/core/core.dart';
import 'package:find_a_nikah/core/ui/text/failure_text.dart';
import 'package:find_a_nikah/features/feed/domain/domain.dart';
import 'package:find_a_nikah/features/feed/presentation/bloc/feed_list_state.dart';

enum MemberSearchIn { posts, comments }

sealed class MemberSearchEvent {
  const MemberSearchEvent();
}

final class MemberSearchQueryChanged extends MemberSearchEvent {
  const MemberSearchQueryChanged(this.query);

  final String query;
}

final class MemberSearchInChanged extends MemberSearchEvent {
  const MemberSearchInChanged(this.where);

  final MemberSearchIn where;
}

final class MemberSearchLoadMore extends MemberSearchEvent {
  const MemberSearchLoadMore();
}

class MemberSearchState extends Equatable {
  const MemberSearchState({
    this.query = '',
    this.where = MemberSearchIn.posts,
    this.posts = const FeedListState<FeedPost>(),
    this.comments = const FeedListState<FeedUserComment>(),
    this.error,
  });

  final String query;
  final MemberSearchIn where;
  final FeedListState<FeedPost> posts;
  final FeedListState<FeedUserComment> comments;
  final String? error;

  bool get hasQuery => query.trim().isNotEmpty;

  MemberSearchState copyWith({
    String? query,
    MemberSearchIn? where,
    FeedListState<FeedPost>? posts,
    FeedListState<FeedUserComment>? comments,
    Object? error = unchanged,
  }) => MemberSearchState(
    query: query ?? this.query,
    where: where ?? this.where,
    posts: posts ?? this.posts,
    comments: comments ?? this.comments,
    error: identical(error, unchanged) ? this.error : error as String?,
  );

  @override
  List<Object?> get props => [query, where, posts, comments, error];
}

/// Search one member's posts and comments on the server.
class MemberSearchBloc extends Bloc<MemberSearchEvent, MemberSearchState> {
  MemberSearchBloc(this._repo, this.userId) : super(const MemberSearchState()) {
    on<MemberSearchQueryChanged>(_onQuery, transformer: restartable());
    on<MemberSearchInChanged>(_onIn, transformer: restartable());
    on<MemberSearchLoadMore>(_onLoadMore, transformer: droppable());
  }

  final FeedRepository _repo;
  final String userId;

  static const searchDelay = Duration(milliseconds: 350);

  Future<void> _onQuery(
    MemberSearchQueryChanged event,
    Emitter<MemberSearchState> emit,
  ) async {
    emit(state.copyWith(query: event.query, error: null));
    if (!state.hasQuery) return;
    final q = event.query.trim();
    await Future<void>.delayed(searchDelay);
    // An older handler keeps running after a restart; drop out if the
    // member typed on.
    if (state.query.trim() != q) return;
    await _run(emit);
  }

  Future<void> _onIn(
    MemberSearchInChanged event,
    Emitter<MemberSearchState> emit,
  ) async {
    emit(state.copyWith(where: event.where, error: null));
    if (state.hasQuery) await _run(emit);
  }

  Future<void> _run(Emitter<MemberSearchState> emit) async {
    final q = state.query.trim();
    switch (state.where) {
      case MemberSearchIn.posts:
        emit(
          state.copyWith(
            posts: const FeedListState<FeedPost>(
              status: FeedListStatus.loading,
            ),
          ),
        );
        final r = await _repo.searchMemberPosts(userId, q);
        emit(
          r.fold(
            (f) => state.copyWith(
              posts: const FeedListState<FeedPost>(
                status: FeedListStatus.failure,
              ),
              error: f.title,
            ),
            (page) => state.copyWith(
              posts: const FeedListState<FeedPost>().loaded(page),
            ),
          ),
        );
      case MemberSearchIn.comments:
        emit(
          state.copyWith(
            comments: const FeedListState<FeedUserComment>(
              status: FeedListStatus.loading,
            ),
          ),
        );
        final r = await _repo.searchMemberComments(userId, q);
        emit(
          r.fold(
            (f) => state.copyWith(
              comments: const FeedListState<FeedUserComment>(
                status: FeedListStatus.failure,
              ),
              error: f.title,
            ),
            (page) => state.copyWith(
              comments: const FeedListState<FeedUserComment>().loaded(page),
            ),
          ),
        );
    }
  }

  Future<void> _onLoadMore(
    MemberSearchLoadMore event,
    Emitter<MemberSearchState> emit,
  ) async {
    final q = state.query.trim();
    switch (state.where) {
      case MemberSearchIn.posts:
        final l = state.posts;
        if (!l.canLoadMore) return;
        emit(state.copyWith(posts: l.copyWith(loadingMore: true)));
        final r = await _repo.searchMemberPosts(
          userId,
          q,
          cursor: l.nextCursor,
        );
        emit(
          r.fold(
            (f) => state.copyWith(
              posts: state.posts.copyWith(loadingMore: false),
            ),
            (page) => state.copyWith(
              posts: state.posts.appended(page, idOf: (p) => p.id),
            ),
          ),
        );
      case MemberSearchIn.comments:
        final l = state.comments;
        if (!l.canLoadMore) return;
        emit(state.copyWith(comments: l.copyWith(loadingMore: true)));
        final r = await _repo.searchMemberComments(
          userId,
          q,
          cursor: l.nextCursor,
        );
        emit(
          r.fold(
            (f) => state.copyWith(
              comments: state.comments.copyWith(loadingMore: false),
            ),
            (page) => state.copyWith(
              comments: state.comments.appended(
                page,
                idOf: (c) => c.comment.id,
              ),
            ),
          ),
        );
    }
  }
}
