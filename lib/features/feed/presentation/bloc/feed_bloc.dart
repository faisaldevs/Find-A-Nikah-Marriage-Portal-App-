import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:find_a_nikah/core/core.dart';
import 'package:find_a_nikah/features/feed/domain/domain.dart';

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

/// Live search from the top bar's search mode; empty shows everything.
final class FeedQueryChanged extends FeedEvent {
  const FeedQueryChanged(this.query);

  final String query;
}

/// The member just published [post] from the compose screen.
final class FeedPostAdded extends FeedEvent {
  const FeedPostAdded(this.post);

  final FeedPost post;
}

enum FeedStatus { initial, loading, ready, failure }

class FeedState extends Equatable {
  const FeedState({
    this.status = FeedStatus.initial,
    this.filter = const FeedFilter.forYou(),
    this.topics = const <FeedTopic>[],
    this.posts = const <FeedPost>[],
    this.query = '',
    this.failure,
  });

  final FeedStatus status;
  final FeedFilter filter;
  final List<FeedTopic> topics;
  final List<FeedPost> posts;
  final String query;
  final Failure? failure;

  /// [posts] matching [query] in the body, author, handle or topic.
  List<FeedPost> get visiblePosts {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return posts;
    return posts
        .where(
          (p) =>
              p.body.toLowerCase().contains(q) ||
              p.author.name.toLowerCase().contains(q) ||
              p.author.handle.toLowerCase().contains(q) ||
              p.topic.toLowerCase().contains(q),
        )
        .toList();
  }

  FeedState copyWith({
    FeedStatus? status,
    FeedFilter? filter,
    List<FeedTopic>? topics,
    List<FeedPost>? posts,
    String? query,
    Object? failure = unchanged,
  }) {
    return FeedState(
      status: status ?? this.status,
      filter: filter ?? this.filter,
      topics: topics ?? this.topics,
      posts: posts ?? this.posts,
      query: query ?? this.query,
      failure: identical(failure, unchanged)
          ? this.failure
          : failure as Failure?,
    );
  }

  @override
  List<Object?> get props => [
    status,
    filter,
    topics,
    posts,
    query,
    failure,
  ];
}

/// Page-scoped on the Feed tab; the tab's `StatefulShellBranch` keeps it
/// alive across tab switches, same as `ExploreBloc`.
class FeedBloc extends Bloc<FeedEvent, FeedState> {
  FeedBloc(this._repo) : super(const FeedState()) {
    on<FeedSubscribed>(_onSubscribed);
    on<FeedFilterSelected>(_onFilterSelected, transformer: restartable());
    on<FeedPostAdded>(_onPostAdded);
    on<FeedQueryChanged>((e, emit) => emit(state.copyWith(query: e.query)));
  }

  final FeedRepository _repo;

  Future<void> _onSubscribed(
    FeedSubscribed event,
    Emitter<FeedState> emit,
  ) async {
    emit(state.copyWith(status: FeedStatus.loading));
    final topics = await _repo.fetchTopics();
    final posts = await _repo.fetchPosts(state.filter);
    emit(
      topics
          .flatMap((t) => posts.map((p) => (t, p)))
          .fold(
            (f) => state.copyWith(status: FeedStatus.failure, failure: f),
            (r) => state.copyWith(
              status: FeedStatus.ready,
              topics: r.$1,
              posts: r.$2,
            ),
          ),
    );
  }

  Future<void> _onFilterSelected(
    FeedFilterSelected event,
    Emitter<FeedState> emit,
  ) async {
    if (event.filter == state.filter && state.status == FeedStatus.ready) {
      return;
    }
    emit(state.copyWith(filter: event.filter, status: FeedStatus.loading));
    final posts = await _repo.fetchPosts(event.filter);
    emit(
      posts.fold(
        (f) => state.copyWith(status: FeedStatus.failure, failure: f),
        (p) => state.copyWith(status: FeedStatus.ready, posts: p),
      ),
    );
  }

  void _onPostAdded(FeedPostAdded event, Emitter<FeedState> emit) {
    final shows = switch (state.filter) {
      FeedForYou() || FeedNewest() => true,
      FeedTopicFilter(:final topic) => topic.name == event.post.topic,
    };
    if (shows) emit(state.copyWith(posts: [event.post, ...state.posts]));
  }
}
