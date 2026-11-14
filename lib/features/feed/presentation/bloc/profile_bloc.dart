import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:find_a_nikah/core/core.dart';
import 'package:find_a_nikah/core/ui/text/failure_text.dart';
import 'package:find_a_nikah/features/feed/domain/domain.dart';
import 'package:find_a_nikah/features/feed/presentation/bloc/feed_list_state.dart';

sealed class ProfileEvent {
  const ProfileEvent();
}

final class ProfileStarted extends ProfileEvent {
  const ProfileStarted();
}

enum ProfileTab { posts, comments, likes }

final class ProfileTabSelected extends ProfileEvent {
  const ProfileTabSelected(this.tab);

  final ProfileTab tab;
}

final class ProfileLoadMore extends ProfileEvent {
  const ProfileLoadMore();
}

/// The Marriage side was opened — load it (once).
final class ProfileMarriageRequested extends ProfileEvent {
  const ProfileMarriageRequested();
}

final class ProfileFollowToggled extends ProfileEvent {
  const ProfileFollowToggled();
}

final class ProfileMuteToggled extends ProfileEvent {
  const ProfileMuteToggled();
}

final class ProfileBlocked extends ProfileEvent {
  const ProfileBlocked();
}

final class ProfilePostDeleteRequested extends ProfileEvent {
  const ProfilePostDeleteRequested(this.postId);

  final String postId;
}

/// Mute or block the author of a post shown in a tab (not always the
/// member whose profile this is — the Likes tab lists others' posts).
final class ProfileAuthorHideRequested extends ProfileEvent {
  const ProfileAuthorHideRequested(this.userId, {required this.block});

  final String userId;
  final bool block;
}

final class ProfileReported extends ProfileEvent {
  const ProfileReported(this.report);

  final FeedReport report;
}

final class ProfilePostLikeToggled extends ProfileEvent {
  const ProfilePostLikeToggled(this.postId);

  final String postId;
}

/// A post changed on another screen (edited, deleted, counts).
final class ProfilePostChanged extends ProfileEvent {
  const ProfilePostChanged(this.post);

  final FeedPost post;
}

final class ProfilePostRemoved extends ProfileEvent {
  const ProfilePostRemoved(this.postId);

  final String postId;
}

enum ProfileStatus { loading, ready, failure }

/// The Marriage side of the profile.
class MarriageSide extends Equatable {
  const MarriageSide({
    this.status = ProfileStatus.loading,
    this.profile,
    this.failure,
    this.requested = false,
  });

  final ProfileStatus status;
  final FeedMarriageProfile? profile;
  final Failure? failure;
  final bool requested;

  @override
  List<Object?> get props => [status, profile, failure, requested];
}

class ProfileState extends Equatable {
  const ProfileState({
    required this.userId,
    this.author,
    this.status = ProfileStatus.loading,
    this.profile,
    this.tab = ProfileTab.posts,
    this.posts = const FeedListState<FeedPost>(),
    this.comments = const FeedListState<FeedUserComment>(),
    this.likes = const FeedListState<FeedPost>(),
    this.marriage = const MarriageSide(),
    this.muted = false,
    this.following = false,
    this.followBusy = false,
    this.failure,
    this.notice,
    this.exit = false,
  });

  final String userId;

  /// Known from the row that was tapped; the header shows it at once.
  final FeedAuthor? author;
  final ProfileStatus status;
  final FeedProfile? profile;
  final ProfileTab tab;
  final FeedListState<FeedPost> posts;
  final FeedListState<FeedUserComment> comments;

  /// Private: only filled on the member's own profile.
  final FeedListState<FeedPost> likes;
  final MarriageSide marriage;
  final bool muted;
  final bool following;
  final bool followBusy;
  final Failure? failure;
  final FeedNotice? notice;

  /// The member was blocked / muted from here — leave the page.
  final bool exit;

  FeedAuthor? get shownAuthor => profile?.author ?? author;
  bool get isMe => shownAuthor?.isMe ?? false;

  ProfileState copyWith({
    FeedAuthor? author,
    ProfileStatus? status,
    Object? profile = unchanged,
    ProfileTab? tab,
    FeedListState<FeedPost>? posts,
    FeedListState<FeedUserComment>? comments,
    FeedListState<FeedPost>? likes,
    MarriageSide? marriage,
    bool? muted,
    bool? following,
    bool? followBusy,
    Object? failure = unchanged,
    Object? notice = unchanged,
    bool? exit,
  }) {
    return ProfileState(
      userId: userId,
      author: author ?? this.author,
      status: status ?? this.status,
      profile: identical(profile, unchanged)
          ? this.profile
          : profile as FeedProfile?,
      tab: tab ?? this.tab,
      posts: posts ?? this.posts,
      comments: comments ?? this.comments,
      likes: likes ?? this.likes,
      marriage: marriage ?? this.marriage,
      muted: muted ?? this.muted,
      following: following ?? this.following,
      followBusy: followBusy ?? this.followBusy,
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
    userId,
    author,
    status,
    profile,
    tab,
    posts,
    comments,
    likes,
    marriage,
    muted,
    following,
    followBusy,
    failure,
    notice,
    exit,
  ];
}

/// A member's Feed profile (header, counters, posts / comments / likes
/// tabs, follow, mute, block), scoped to the profile page. Opened by
/// `userId`; [author] is the row that was tapped, drawn until the profile
/// arrives.
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc(this._repo, String userId, {FeedAuthor? author})
    : super(ProfileState(userId: userId, author: author)) {
    on<ProfileStarted>(_onStarted);
    on<ProfileTabSelected>(_onTabSelected);
    on<ProfileLoadMore>(_onLoadMore, transformer: droppable());
    on<ProfileMarriageRequested>(_onMarriage, transformer: droppable());
    on<ProfileFollowToggled>(_onFollow, transformer: droppable());
    on<ProfileMuteToggled>(_onMute, transformer: droppable());
    on<ProfileBlocked>(_onBlocked, transformer: droppable());
    on<ProfileReported>(_onReported);
    on<ProfilePostDeleteRequested>(_onDelete);
    on<ProfileAuthorHideRequested>(_onHideAuthor);
    on<ProfilePostLikeToggled>(_onLike);
    on<ProfilePostChanged>(_onPostChanged);
    on<ProfilePostRemoved>(_onPostRemoved);
  }

  final FeedRepository _repo;
  var _noticeId = 0;
  final _liking = <String>{};

  FeedNotice _notice(String text, {bool isError = false}) =>
      FeedNotice(++_noticeId, text, isError: isError);

  Future<void> _onStarted(
    ProfileStarted event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(status: ProfileStatus.loading));
    final profile = await _repo.fetchProfile(state.userId);
    final posts = await _repo.fetchProfilePosts(state.userId);
    emit(
      profile.fold(
        (f) => state.copyWith(status: ProfileStatus.failure, failure: f),
        (p) => state.copyWith(
          status: ProfileStatus.ready,
          profile: p,
          following: p.isFollowing,
          posts: posts.fold(
            (f) => state.posts.copyWith(
              status: FeedListStatus.failure,
              failure: f,
            ),
            (page) => const FeedListState<FeedPost>().loaded(page),
          ),
          failure: null,
        ),
      ),
    );
  }

  Future<void> _onTabSelected(
    ProfileTabSelected event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(tab: event.tab));
    switch (event.tab) {
      case ProfileTab.posts:
        return;
      case ProfileTab.comments:
        if (!state.comments.isIdle && !state.comments.hasFailed) return;
        emit(
          state.copyWith(
            comments: const FeedListState<FeedUserComment>(
              status: FeedListStatus.loading,
            ),
          ),
        );
        final r = await _repo.fetchProfileComments(state.userId);
        emit(
          state.copyWith(
            comments: r.fold(
              (f) => state.comments.copyWith(
                status: FeedListStatus.failure,
                failure: f,
              ),
              (page) => const FeedListState<FeedUserComment>().loaded(page),
            ),
          ),
        );
      case ProfileTab.likes:
        if (!state.likes.isIdle && !state.likes.hasFailed) return;
        emit(
          state.copyWith(
            likes: const FeedListState<FeedPost>(
              status: FeedListStatus.loading,
            ),
          ),
        );
        final r = await _repo.fetchProfileLikes(state.userId);
        emit(
          state.copyWith(
            likes: r.fold(
              (f) => state.likes.copyWith(
                status: FeedListStatus.failure,
                failure: f,
              ),
              (page) => const FeedListState<FeedPost>().loaded(page),
            ),
          ),
        );
    }
  }

  Future<void> _onLoadMore(
    ProfileLoadMore event,
    Emitter<ProfileState> emit,
  ) async {
    switch (state.tab) {
      case ProfileTab.posts:
        final l = state.posts;
        if (!l.canLoadMore) return;
        emit(state.copyWith(posts: l.copyWith(loadingMore: true)));
        final r = await _repo.fetchProfilePosts(
          state.userId,
          cursor: l.nextCursor,
        );
        emit(
          r.fold(
            (f) => state.copyWith(
              posts: state.posts.copyWith(loadingMore: false),
              notice: _notice(f.title, isError: true),
            ),
            (page) => state.copyWith(
              posts: state.posts.appended(page, idOf: (p) => p.id),
            ),
          ),
        );
      case ProfileTab.comments:
        final l = state.comments;
        if (!l.canLoadMore) return;
        emit(state.copyWith(comments: l.copyWith(loadingMore: true)));
        final r = await _repo.fetchProfileComments(
          state.userId,
          cursor: l.nextCursor,
        );
        emit(
          r.fold(
            (f) => state.copyWith(
              comments: state.comments.copyWith(loadingMore: false),
              notice: _notice(f.title, isError: true),
            ),
            (page) => state.copyWith(
              comments: state.comments.appended(
                page,
                idOf: (c) => c.comment.id,
              ),
            ),
          ),
        );
      case ProfileTab.likes:
        final l = state.likes;
        if (!l.canLoadMore) return;
        emit(state.copyWith(likes: l.copyWith(loadingMore: true)));
        final r = await _repo.fetchProfileLikes(
          state.userId,
          cursor: l.nextCursor,
        );
        emit(
          r.fold(
            (f) => state.copyWith(
              likes: state.likes.copyWith(loadingMore: false),
              notice: _notice(f.title, isError: true),
            ),
            (page) => state.copyWith(
              likes: state.likes.appended(page, idOf: (p) => p.id),
            ),
          ),
        );
    }
  }

  Future<void> _onMarriage(
    ProfileMarriageRequested event,
    Emitter<ProfileState> emit,
  ) async {
    final m = state.marriage;
    if (m.requested && m.status != ProfileStatus.failure) return;
    emit(
      state.copyWith(
        marriage: const MarriageSide(requested: true),
      ),
    );
    final r = await _repo.fetchMarriageProfile(state.userId);
    emit(
      state.copyWith(
        marriage: r.fold(
          (f) => MarriageSide(
            status: ProfileStatus.failure,
            failure: f,
            requested: true,
          ),
          (p) => MarriageSide(
            status: ProfileStatus.ready,
            profile: p,
            requested: true,
          ),
        ),
      ),
    );
  }

  Future<void> _onFollow(
    ProfileFollowToggled event,
    Emitter<ProfileState> emit,
  ) async {
    final profile = state.profile;
    if (profile == null || state.isMe) return;
    final want = !state.following;
    // Optimistic: flip the button and the counter, roll back on failure.
    emit(
      state.copyWith(
        following: want,
        followBusy: true,
        profile: profile.copyWith(
          followers: (profile.followers + (want ? 1 : -1)).clamp(0, 1 << 31),
          isFollowing: want,
        ),
      ),
    );
    final r = await _repo.setFollowing(state.userId, following: want);
    emit(
      r.fold(
        (f) => state.copyWith(
          following: !want,
          followBusy: false,
          profile: profile,
          notice: _notice(f.title, isError: true),
        ),
        (res) => state.copyWith(
          following: res.active,
          followBusy: false,
          profile: state.profile?.copyWith(
            isFollowing: res.active,
            followers: res.count ?? state.profile?.followers,
          ),
        ),
      ),
    );
  }

  Future<void> _onMute(
    ProfileMuteToggled event,
    Emitter<ProfileState> emit,
  ) async {
    final want = !state.muted;
    final r = await _repo.setMuted(state.userId, muted: want);
    emit(
      r.fold(
        (f) => state.copyWith(notice: _notice(f.title, isError: true)),
        (_) => state.copyWith(
          muted: want,
          notice: _notice(
            want ? 'Muted. Their posts are hidden from your feed.' : 'Unmuted',
          ),
        ),
      ),
    );
  }

  Future<void> _onBlocked(
    ProfileBlocked event,
    Emitter<ProfileState> emit,
  ) async {
    final r = await _repo.blockMember(state.userId);
    emit(
      r.fold(
        (f) => state.copyWith(notice: _notice(f.title, isError: true)),
        (_) => state.copyWith(exit: true),
      ),
    );
  }

  Future<void> _onReported(
    ProfileReported event,
    Emitter<ProfileState> emit,
  ) async {
    final r = await _repo.report(event.report);
    emit(
      r.fold(
        (f) => state.copyWith(
          notice: f.base is ConflictFailure
              ? _notice('You already reported this')
              : _notice(f.title, isError: true),
        ),
        (_) {
          // A reported post disappears from the reporter's lists.
          if (event.report.postId case final id?) {
            _onPostRemoved(ProfilePostRemoved(id), emit);
          }
          return state.copyWith(
            notice: _notice('Thanks — we received your report'),
          );
        },
      ),
    );
  }

  Future<void> _onDelete(
    ProfilePostDeleteRequested event,
    Emitter<ProfileState> emit,
  ) async {
    final r = await _repo.deletePost(event.postId);
    r.fold(
      (f) => emit(state.copyWith(notice: _notice(f.title, isError: true))),
      (_) {
        _onPostRemoved(ProfilePostRemoved(event.postId), emit);
        emit(
          state.copyWith(
            notice: _notice('Post deleted'),
            profile: state.profile?.copyWith(
              postsCount: ((state.profile?.postsCount ?? 1) - 1).clamp(
                0,
                1 << 31,
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _onHideAuthor(
    ProfileAuthorHideRequested event,
    Emitter<ProfileState> emit,
  ) async {
    final r = event.block
        ? await _repo.blockMember(event.userId)
        : await _repo.setMuted(event.userId, muted: true);
    r.fold(
      (f) => emit(state.copyWith(notice: _notice(f.title, isError: true))),
      (_) {
        bool keep(FeedPost p) => p.author.userId != event.userId;
        emit(
          state.copyWith(
            posts: state.posts.copyWith(
              items: state.posts.items.where(keep).toList(),
            ),
            likes: state.likes.copyWith(
              items: state.likes.items.where(keep).toList(),
            ),
            // Leaving the page only when it was this member's own profile.
            exit: event.block && event.userId == state.userId,
            notice: _notice(event.block ? 'Blocked' : 'Muted'),
          ),
        );
      },
    );
  }

  // ── Posts in the tabs ──────────────────────────────────────────────────
  FeedPost? _find(String id) => [
    ...state.posts.items,
    ...state.likes.items,
  ].where((p) => p.id == id).firstOrNull;

  void _swap(Emitter<ProfileState> emit, FeedPost post) {
    FeedPost swap(FeedPost p) => p.id == post.id ? post : p;
    emit(
      state.copyWith(
        posts: state.posts.copyWith(
          items: state.posts.items.map(swap).toList(),
        ),
        likes: state.likes.copyWith(
          items: state.likes.items.map(swap).toList(),
        ),
      ),
    );
  }

  Future<void> _onLike(
    ProfilePostLikeToggled event,
    Emitter<ProfileState> emit,
  ) async {
    if (!_liking.add(event.postId)) return;
    final before = _find(event.postId);
    if (before == null) {
      _liking.remove(event.postId);
      return;
    }
    final want = !before.likedByMe;
    _swap(
      emit,
      before.copyWith(
        likedByMe: want,
        likeCount: (before.likeCount + (want ? 1 : -1)).clamp(0, 1 << 31),
      ),
    );
    final r = await _repo.setPostLiked(event.postId, liked: want);
    _liking.remove(event.postId);
    r.fold(
      (f) {
        _swap(emit, before);
        emit(state.copyWith(notice: _notice(f.title, isError: true)));
      },
      (res) => _swap(
        emit,
        (_find(event.postId) ?? before).copyWith(
          likedByMe: res.active,
          likeCount: res.count ?? before.likeCount,
        ),
      ),
    );
  }

  void _onPostChanged(ProfilePostChanged event, Emitter<ProfileState> emit) =>
      _swap(emit, event.post);

  void _onPostRemoved(ProfilePostRemoved event, Emitter<ProfileState> emit) {
    bool keep(FeedPost p) => p.id != event.postId;
    emit(
      state.copyWith(
        posts: state.posts.copyWith(
          items: state.posts.items.where(keep).toList(),
        ),
        likes: state.likes.copyWith(
          items: state.likes.items.where(keep).toList(),
        ),
      ),
    );
  }
}
