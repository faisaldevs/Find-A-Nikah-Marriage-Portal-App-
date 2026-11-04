import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:find_a_nikah/core/core.dart';
import 'package:find_a_nikah/features/feed/domain/domain.dart';

sealed class ProfileEvent {
  const ProfileEvent();
}

final class ProfileStarted extends ProfileEvent {
  const ProfileStarted();
}

enum ProfileStatus { loading, ready, failure }

class ProfileState extends Equatable {
  const ProfileState({
    required this.author,
    this.status = ProfileStatus.loading,
    this.profile,
    this.posts = const <FeedPost>[],
    this.failure,
  });

  final FeedAuthor author;
  final ProfileStatus status;
  final FeedProfile? profile;
  final List<FeedPost> posts;
  final Failure? failure;

  ProfileState copyWith({
    FeedAuthor? author,
    ProfileStatus? status,
    Object? profile = unchanged,
    List<FeedPost>? posts,
    Object? failure = unchanged,
  }) {
    return ProfileState(
      author: author ?? this.author,
      status: status ?? this.status,
      profile: identical(profile, unchanged)
          ? this.profile
          : profile as FeedProfile?,
      posts: posts ?? this.posts,
      failure: identical(failure, unchanged)
          ? this.failure
          : failure as Failure?,
    );
  }

  @override
  List<Object?> get props => [
    author,
    status,
    profile,
    posts,
    failure,
  ];
}

/// A member's community profile and posts, scoped to the profile page.
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc(this._repo, FeedAuthor author)
    : super(ProfileState(author: author)) {
    on<ProfileStarted>(_onStarted);
  }

  final FeedRepository _repo;

  Future<void> _onStarted(
    ProfileStarted event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(status: ProfileStatus.loading));
    final handle = state.author.handle;
    final profile = await _repo.fetchProfile(handle);
    final posts = await _repo.fetchProfilePosts(handle);
    emit(
      profile
          .flatMap((p) => posts.map((list) => (p, list)))
          .fold(
            (f) => state.copyWith(status: ProfileStatus.failure, failure: f),
            (r) => state.copyWith(
              status: ProfileStatus.ready,
              profile: r.$1,
              posts: r.$2,
            ),
          ),
    );
  }
}
