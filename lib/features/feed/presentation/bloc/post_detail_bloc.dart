import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:find_a_nikah/core/core.dart';
import 'package:find_a_nikah/features/feed/domain/domain.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'post_detail_bloc.freezed.dart';

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

@freezed
abstract class PostDetailState with _$PostDetailState {
  const factory PostDetailState({
    required FeedPost post,
    @Default(PostDetailStatus.loading) PostDetailStatus status,
    @Default(CommentSort.mostPopular) CommentSort sort,
    @Default(<FeedComment>[]) List<FeedComment> comments,
    FeedAuthor? me,
    Failure? failure,
  }) = _PostDetailState;
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
