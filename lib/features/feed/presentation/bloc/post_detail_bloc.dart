import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:find_a_nikah/core/core.dart';
import 'package:find_a_nikah/features/feed/domain/domain.dart';

sealed class PostDetailEvent {
  const PostDetailEvent();
}

final class PostDetailStarted extends PostDetailEvent {
  const PostDetailStarted();
}

final class PostDetailSortChanged extends PostDetailEvent {
  const PostDetailSortChanged(this.sort);

  final CommentSort sort;
}

enum PostDetailStatus { loading, ready, failure }

class PostDetailState extends Equatable {
  const PostDetailState({
    required this.post,
    this.status = PostDetailStatus.loading,
    this.sort = CommentSort.mostPopular,
    this.comments = const <FeedComment>[],
    this.me,
    this.failure,
  });

  final FeedPost post;
  final PostDetailStatus status;
  final CommentSort sort;
  final List<FeedComment> comments;
  final FeedAuthor? me;
  final Failure? failure;

  PostDetailState copyWith({
    FeedPost? post,
    PostDetailStatus? status,
    CommentSort? sort,
    List<FeedComment>? comments,
    Object? me = unchanged,
    Object? failure = unchanged,
  }) {
    return PostDetailState(
      post: post ?? this.post,
      status: status ?? this.status,
      sort: sort ?? this.sort,
      comments: comments ?? this.comments,
      me: identical(me, unchanged) ? this.me : me as FeedAuthor?,
      failure: identical(failure, unchanged)
          ? this.failure
          : failure as Failure?,
    );
  }

  @override
  List<Object?> get props => [
    post,
    status,
    sort,
    comments,
    me,
    failure,
  ];
}

/// One post and its comments, scoped to the post page.
class PostDetailBloc extends Bloc<PostDetailEvent, PostDetailState> {
  PostDetailBloc(this._repo, FeedPost post)
    : super(PostDetailState(post: post)) {
    on<PostDetailStarted>(_onStarted);
    on<PostDetailSortChanged>(_onSortChanged, transformer: restartable());
  }

  final FeedRepository _repo;

  Future<void> _onStarted(
    PostDetailStarted event,
    Emitter<PostDetailState> emit,
  ) async {
    final me = await _repo.fetchMe();
    emit(state.copyWith(me: me.toNullable()));
    await _load(emit);
  }

  Future<void> _onSortChanged(
    PostDetailSortChanged event,
    Emitter<PostDetailState> emit,
  ) async {
    if (event.sort == state.sort) return;
    emit(state.copyWith(sort: event.sort, status: PostDetailStatus.loading));
    await _load(emit);
  }

  Future<void> _load(Emitter<PostDetailState> emit) async {
    final result = await _repo.fetchComments(state.post.id, state.sort);
    emit(
      result.fold(
        (f) => state.copyWith(status: PostDetailStatus.failure, failure: f),
        (c) => state.copyWith(status: PostDetailStatus.ready, comments: c),
      ),
    );
  }
}
