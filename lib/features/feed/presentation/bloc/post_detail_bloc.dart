import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:find_a_nikah/core/core.dart';
import 'package:find_a_nikah/core/ui/text/failure_text.dart';
import 'package:find_a_nikah/features/feed/domain/domain.dart';
import 'package:find_a_nikah/features/feed/presentation/bloc/feed_list_state.dart';

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

final class PostDetailLoadMore extends PostDetailEvent {
  const PostDetailLoadMore();
}

final class PostDetailPostLiked extends PostDetailEvent {
  const PostDetailPostLiked();
}

/// The post was edited on the compose screen.
final class PostDetailPostEdited extends PostDetailEvent {
  const PostDetailPostEdited(this.post);

  final FeedPost post;
}

final class PostDetailPostDeleted extends PostDetailEvent {
  const PostDetailPostDeleted();
}

final class PostDetailCommentLiked extends PostDetailEvent {
  const PostDetailCommentLiked(this.commentId);

  final String commentId;
}

/// Reply to [comment] (a reply to a reply goes under the same parent, with
/// a mention). Null cancels reply / edit mode.
final class PostDetailReplyStarted extends PostDetailEvent {
  const PostDetailReplyStarted(this.comment);

  final FeedComment comment;
}

final class PostDetailEditStarted extends PostDetailEvent {
  const PostDetailEditStarted(this.comment);

  final FeedComment comment;
}

final class PostDetailComposerCancelled extends PostDetailEvent {
  const PostDetailComposerCancelled();
}

final class PostDetailCommentSubmitted extends PostDetailEvent {
  const PostDetailCommentSubmitted(this.text);

  final String text;
}

final class PostDetailCommentDeleted extends PostDetailEvent {
  const PostDetailCommentDeleted(this.commentId);

  final String commentId;
}

/// "View more replies" under [commentId].
final class PostDetailRepliesRequested extends PostDetailEvent {
  const PostDetailRepliesRequested(this.commentId);

  final String commentId;
}

final class PostDetailReported extends PostDetailEvent {
  const PostDetailReported(this.report);

  final FeedReport report;
}

final class PostDetailFollowToggled extends PostDetailEvent {
  const PostDetailFollowToggled();
}

final class PostDetailAuthorMuted extends PostDetailEvent {
  const PostDetailAuthorMuted();
}

final class PostDetailAuthorBlocked extends PostDetailEvent {
  const PostDetailAuthorBlocked();
}

enum PostDetailStatus { loading, ready, failure }

/// What the "Add a comment" bar is doing.
sealed class ComposerMode extends Equatable {
  const ComposerMode();
}

final class ComposerNew extends ComposerMode {
  const ComposerNew();

  @override
  List<Object?> get props => [];
}

final class ComposerReply extends ComposerMode {
  const ComposerReply(this.to);

  final FeedComment to;

  @override
  List<Object?> get props => [to];
}

final class ComposerEdit extends ComposerMode {
  const ComposerEdit(this.comment);

  final FeedComment comment;

  @override
  List<Object?> get props => [comment];
}

/// How the page should close, once the bloc decides it must.
enum PostDetailExit { none, deleted, authorHidden }

class PostDetailState extends Equatable {
  const PostDetailState({
    required this.postId,
    this.post,
    this.status = PostDetailStatus.loading,
    this.sort = CommentSort.mostPopular,
    this.comments = const FeedListState<FeedComment>(),
    this.me,
    this.composer = const ComposerNew(),
    this.sending = false,
    this.following,
    this.failure,
    this.notice,
    this.exit = PostDetailExit.none,
  });

  final String postId;

  /// Null until the post has loaded (when opened from a link).
  final FeedPost? post;
  final PostDetailStatus status;
  final CommentSort sort;
  final FeedListState<FeedComment> comments;
  final FeedAuthor? me;
  final ComposerMode composer;
  final bool sending;

  /// Whether the signed-in member follows the author; null until known
  /// (the Follow pill stays hidden until then).
  final bool? following;

  /// Why the post itself could not load.
  final Failure? failure;
  final FeedNotice? notice;
  final PostDetailExit exit;

  PostDetailState copyWith({
    FeedPost? post,
    PostDetailStatus? status,
    CommentSort? sort,
    FeedListState<FeedComment>? comments,
    Object? me = unchanged,
    ComposerMode? composer,
    bool? sending,
    Object? following = unchanged,
    Object? failure = unchanged,
    Object? notice = unchanged,
    PostDetailExit? exit,
  }) {
    return PostDetailState(
      postId: postId,
      post: post ?? this.post,
      status: status ?? this.status,
      sort: sort ?? this.sort,
      comments: comments ?? this.comments,
      me: identical(me, unchanged) ? this.me : me as FeedAuthor?,
      composer: composer ?? this.composer,
      sending: sending ?? this.sending,
      following: identical(following, unchanged)
          ? this.following
          : following as bool?,
      failure: identical(failure, unchanged)
          ? this.failure
          : failure as Failure?,
      notice: identical(notice, unchanged)
          ? this.notice
          : notice as FeedNotice?,
      exit: exit ?? this.exit,
    );
  }

  @override
  List<Object?> get props => [
    postId,
    post,
    status,
    sort,
    comments,
    me,
    composer,
    sending,
    following,
    failure,
    notice,
    exit,
  ];
}

/// One post and its comments, scoped to the post page. Opened by id: the
/// post is loaded from the server, with an optional [initial] copy shown
/// meanwhile (from the feed card).
class PostDetailBloc extends Bloc<PostDetailEvent, PostDetailState> {
  PostDetailBloc(this._repo, String postId, {FeedPost? initial})
    : super(
        PostDetailState(
          postId: postId,
          post: initial,
          status: initial == null
              ? PostDetailStatus.loading
              : PostDetailStatus.ready,
        ),
      ) {
    on<PostDetailStarted>(_onStarted);
    on<PostDetailSortChanged>(_onSortChanged, transformer: restartable());
    on<PostDetailLoadMore>(_onLoadMore, transformer: droppable());
    on<PostDetailPostLiked>(_onPostLiked, transformer: droppable());
    on<PostDetailPostEdited>(
      (e, emit) => emit(state.copyWith(post: e.post)),
    );
    on<PostDetailPostDeleted>(_onPostDeleted, transformer: droppable());
    on<PostDetailCommentLiked>(_onCommentLiked);
    on<PostDetailReplyStarted>(
      (e, emit) => emit(state.copyWith(composer: ComposerReply(e.comment))),
    );
    on<PostDetailEditStarted>(
      (e, emit) => emit(state.copyWith(composer: ComposerEdit(e.comment))),
    );
    on<PostDetailComposerCancelled>(
      (e, emit) => emit(state.copyWith(composer: const ComposerNew())),
    );
    on<PostDetailCommentSubmitted>(_onSubmitted, transformer: droppable());
    on<PostDetailCommentDeleted>(_onCommentDeleted);
    on<PostDetailRepliesRequested>(_onReplies);
    on<PostDetailReported>(_onReported);
    on<PostDetailFollowToggled>(_onFollow, transformer: droppable());
    on<PostDetailAuthorMuted>(_onMuted);
    on<PostDetailAuthorBlocked>(_onBlocked);
  }

  final FeedRepository _repo;
  var _noticeId = 0;
  final _liking = <String>{};

  FeedNotice _notice(String text, {bool isError = false}) =>
      FeedNotice(++_noticeId, text, isError: isError);

  // ── Loading ────────────────────────────────────────────────────────────
  Future<void> _onStarted(
    PostDetailStarted event,
    Emitter<PostDetailState> emit,
  ) async {
    final me = _repo.fetchMe();
    final post = _repo.fetchPost(state.postId);
    final comments = _repo.fetchComments(state.postId, state.sort);
    final meResult = await me;
    emit(state.copyWith(me: meResult.toNullable()));

    final postResult = await post;
    final hadPost = state.post != null;
    final stop = postResult.fold<bool>(
      (f) {
        // A post we cannot show: keep an already-shown copy (offline), else
        // show why.
        if (!hadPost) {
          emit(state.copyWith(status: PostDetailStatus.failure, failure: f));
          return true;
        }
        if (f.base is NotFoundFailure || f.base is ForbiddenFailure) {
          emit(state.copyWith(exit: PostDetailExit.deleted));
          return true;
        }
        return false;
      },
      (p) {
        emit(
          state.copyWith(
            post: p,
            status: PostDetailStatus.ready,
            failure: null,
          ),
        );
        return false;
      },
    );
    if (stop) return;
    // Best effort: tells us whether to show "Follow" or "Following".
    final author = state.post?.author;
    if (author != null && !author.isMe) {
      final profile = await _repo.fetchProfile(author.userId);
      profile.fold(
        (_) {},
        (p) => emit(state.copyWith(following: p.isFollowing)),
      );
    }
    final result = await comments;
    emit(
      state.copyWith(
        comments: result.fold(
          (f) => state.comments.copyWith(
            status: FeedListStatus.failure,
            failure: f,
          ),
          (page) => const FeedListState<FeedComment>().loaded(page),
        ),
      ),
    );
    // Opening a post counts as a view.
    await _repo.recordViews([state.postId]);
  }

  Future<void> _onSortChanged(
    PostDetailSortChanged event,
    Emitter<PostDetailState> emit,
  ) async {
    if (event.sort == state.sort) return;
    emit(
      state.copyWith(
        sort: event.sort,
        comments: const FeedListState<FeedComment>(
          status: FeedListStatus.loading,
        ),
      ),
    );
    final result = await _repo.fetchComments(state.postId, event.sort);
    emit(
      state.copyWith(
        comments: result.fold(
          (f) => state.comments.copyWith(
            status: FeedListStatus.failure,
            failure: f,
          ),
          (page) => const FeedListState<FeedComment>().loaded(page),
        ),
      ),
    );
  }

  Future<void> _onLoadMore(
    PostDetailLoadMore event,
    Emitter<PostDetailState> emit,
  ) async {
    final list = state.comments;
    if (!list.canLoadMore) return;
    emit(state.copyWith(comments: list.copyWith(loadingMore: true)));
    final result = await _repo.fetchComments(
      state.postId,
      state.sort,
      cursor: list.nextCursor,
    );
    result.fold(
      (f) => emit(
        state.copyWith(
          comments: state.comments.copyWith(loadingMore: false),
          notice: _notice(f.title, isError: true),
        ),
      ),
      (page) => emit(
        state.copyWith(
          comments: state.comments.appended(page, idOf: (c) => c.id),
        ),
      ),
    );
  }

  // ── Post actions ───────────────────────────────────────────────────────
  Future<void> _onPostLiked(
    PostDetailPostLiked event,
    Emitter<PostDetailState> emit,
  ) async {
    final before = state.post;
    if (before == null) return;
    final want = !before.likedByMe;
    emit(
      state.copyWith(
        post: before.copyWith(
          likedByMe: want,
          likeCount: (before.likeCount + (want ? 1 : -1)).clamp(0, 1 << 31),
        ),
      ),
    );
    final result = await _repo.setPostLiked(before.id, liked: want);
    result.fold(
      (f) => emit(
        state.copyWith(
          post: before,
          notice: _notice(f.title, isError: true),
        ),
      ),
      (r) => emit(
        state.copyWith(
          post: state.post?.copyWith(
            likedByMe: r.active,
            likeCount: r.count ?? state.post?.likeCount,
          ),
        ),
      ),
    );
  }

  Future<void> _onPostDeleted(
    PostDetailPostDeleted event,
    Emitter<PostDetailState> emit,
  ) async {
    final result = await _repo.deletePost(state.postId);
    result.fold(
      (f) => emit(state.copyWith(notice: _notice(f.title, isError: true))),
      (_) => emit(state.copyWith(exit: PostDetailExit.deleted)),
    );
  }

  Future<void> _onReported(
    PostDetailReported event,
    Emitter<PostDetailState> emit,
  ) async {
    final result = await _repo.report(event.report);
    result.fold(
      (f) {
        // Reporting the same thing twice is fine from the member's side.
        final already = f.base is ConflictFailure;
        emit(
          state.copyWith(
            notice: _notice(
              already ? 'You already reported this' : f.title,
              isError: !already,
            ),
          ),
        );
      },
      (_) {
        emit(
          state.copyWith(notice: _notice('Thanks — we received your report')),
        );
        // A reported post disappears from the reporter's feed.
        if (event.report.target == FeedReportTarget.post) {
          emit(state.copyWith(exit: PostDetailExit.deleted));
        }
      },
    );
  }

  Future<void> _onFollow(
    PostDetailFollowToggled event,
    Emitter<PostDetailState> emit,
  ) async {
    final author = state.post?.author;
    final was = state.following;
    if (author == null || was == null) return;
    emit(state.copyWith(following: !was));
    final r = await _repo.setFollowing(author.userId, following: !was);
    r.fold(
      (f) => emit(
        state.copyWith(following: was, notice: _notice(f.title, isError: true)),
      ),
      (res) => emit(state.copyWith(following: res.active)),
    );
  }

  Future<void> _onMuted(
    PostDetailAuthorMuted event,
    Emitter<PostDetailState> emit,
  ) async {
    final author = state.post?.author;
    if (author == null) return;
    final result = await _repo.setMuted(author.userId, muted: true);
    result.fold(
      (f) => emit(state.copyWith(notice: _notice(f.title, isError: true))),
      (_) => emit(state.copyWith(exit: PostDetailExit.authorHidden)),
    );
  }

  Future<void> _onBlocked(
    PostDetailAuthorBlocked event,
    Emitter<PostDetailState> emit,
  ) async {
    final author = state.post?.author;
    if (author == null) return;
    final result = await _repo.blockMember(author.userId);
    result.fold(
      (f) => emit(state.copyWith(notice: _notice(f.title, isError: true))),
      (_) => emit(state.copyWith(exit: PostDetailExit.authorHidden)),
    );
  }

  // ── Comments ───────────────────────────────────────────────────────────
  Future<void> _onSubmitted(
    PostDetailCommentSubmitted event,
    Emitter<PostDetailState> emit,
  ) async {
    final text = event.text.trim();
    if (text.isEmpty || state.sending) return;
    emit(state.copyWith(sending: true));
    switch (state.composer) {
      case ComposerEdit(:final comment):
        final result = await _repo.editComment(comment.id, text);
        result.fold(
          (f) => emit(
            state.copyWith(
              sending: false,
              notice: _notice(f.title, isError: true),
            ),
          ),
          (c) => emit(
            state.copyWith(
              sending: false,
              composer: const ComposerNew(),
              comments: _updateComment(
                state.comments,
                c.id,
                (old) => old.copyWith(body: c.body, editedAt: c.editedAt),
              ),
            ),
          ),
        );
      case ComposerReply(:final to):
        // One level deep: replying to a reply goes under its parent.
        final parentId = to.parentId ?? to.id;
        final result = await _repo.createComment(
          state.postId,
          text,
          parentId: parentId,
          mentionUserId: to.author.userId,
        );
        result.fold(
          (f) => emit(
            state.copyWith(
              sending: false,
              notice: _notice(f.title, isError: true),
            ),
          ),
          (c) => emit(
            state.copyWith(
              sending: false,
              composer: const ComposerNew(),
              post: state.post?.copyWith(
                commentCount: (state.post?.commentCount ?? 0) + 1,
              ),
              comments: _updateComment(
                state.comments,
                parentId,
                (p) => p.copyWith(
                  replyCount: p.replyCount + 1,
                  replies: [...p.replies, c],
                ),
              ),
            ),
          ),
        );
      case ComposerNew():
        final result = await _repo.createComment(state.postId, text);
        result.fold(
          (f) => emit(
            state.copyWith(
              sending: false,
              notice: _notice(f.title, isError: true),
            ),
          ),
          (c) => emit(
            state.copyWith(
              sending: false,
              post: state.post?.copyWith(
                commentCount: (state.post?.commentCount ?? 0) + 1,
              ),
              comments: state.comments.copyWith(
                status: FeedListStatus.ready,
                items: [c, ...state.comments.items],
              ),
            ),
          ),
        );
    }
  }

  Future<void> _onCommentDeleted(
    PostDetailCommentDeleted event,
    Emitter<PostDetailState> emit,
  ) async {
    final result = await _repo.deleteComment(event.commentId);
    result.fold(
      (f) => emit(state.copyWith(notice: _notice(f.title, isError: true))),
      (_) {
        // Remove it (and its replies, if it was top-level) and fix counts.
        var removed = 0;
        final items = <FeedComment>[];
        for (final c in state.comments.items) {
          if (c.id == event.commentId) {
            removed += 1 + c.replies.length;
            continue;
          }
          final kept = c.replies.where((r) => r.id != event.commentId).toList();
          if (kept.length != c.replies.length) {
            removed += c.replies.length - kept.length;
            items.add(
              c.copyWith(
                replies: kept,
                replyCount: (c.replyCount - 1).clamp(0, 1 << 31),
              ),
            );
          } else {
            items.add(c);
          }
        }
        emit(
          state.copyWith(
            comments: state.comments.copyWith(items: items),
            post: state.post?.copyWith(
              commentCount: ((state.post?.commentCount ?? 0) - removed).clamp(
                0,
                1 << 31,
              ),
            ),
            notice: _notice('Comment deleted'),
          ),
        );
      },
    );
  }

  Future<void> _onCommentLiked(
    PostDetailCommentLiked event,
    Emitter<PostDetailState> emit,
  ) async {
    if (!_liking.add(event.commentId)) return;
    final before = _find(state.comments.items, event.commentId);
    if (before == null) {
      _liking.remove(event.commentId);
      return;
    }
    final want = !before.likedByMe;
    FeedListState<FeedComment> set(bool liked, int count) => _updateComment(
      state.comments,
      event.commentId,
      (c) => c.copyWith(likedByMe: liked, likeCount: count),
    );
    emit(
      state.copyWith(
        comments: set(
          want,
          (before.likeCount + (want ? 1 : -1)).clamp(0, 1 << 31),
        ),
      ),
    );
    final result = await _repo.setCommentLiked(event.commentId, liked: want);
    _liking.remove(event.commentId);
    result.fold(
      (f) => emit(
        state.copyWith(
          comments: set(before.likedByMe, before.likeCount),
          notice: _notice(f.title, isError: true),
        ),
      ),
      (r) => emit(
        state.copyWith(comments: set(r.active, r.count ?? before.likeCount)),
      ),
    );
  }

  Future<void> _onReplies(
    PostDetailRepliesRequested event,
    Emitter<PostDetailState> emit,
  ) async {
    final parent = _find(state.comments.items, event.commentId);
    if (parent == null) return;
    // The first replies are inlined; ask for everything after the last.
    final result = await _repo.fetchReplies(event.commentId);
    result.fold(
      (f) => emit(state.copyWith(notice: _notice(f.title, isError: true))),
      (page) {
        final have = {for (final r in parent.replies) r.id};
        emit(
          state.copyWith(
            comments: _updateComment(
              state.comments,
              event.commentId,
              (p) => p.copyWith(
                replies: [
                  ...p.replies,
                  for (final r in page.items)
                    if (!have.contains(r.id)) r,
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  FeedComment? _find(List<FeedComment> list, String id) {
    for (final c in list) {
      if (c.id == id) return c;
      for (final r in c.replies) {
        if (r.id == id) return r;
      }
    }
    return null;
  }

  /// Apply [update] to the comment (or reply) with [id].
  FeedListState<FeedComment> _updateComment(
    FeedListState<FeedComment> list,
    String id,
    FeedComment Function(FeedComment) update,
  ) => list.copyWith(
    items: [
      for (final c in list.items)
        if (c.id == id)
          update(c)
        else
          c.copyWith(
            replies: [for (final r in c.replies) r.id == id ? update(r) : r],
          ),
    ],
  );
}
