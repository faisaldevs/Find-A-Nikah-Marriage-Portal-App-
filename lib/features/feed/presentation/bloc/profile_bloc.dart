import 'package:bloc/bloc.dart';
import 'package:find_a_nikah/core/core.dart';
import 'package:find_a_nikah/features/feed/domain/domain.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_bloc.freezed.dart';

sealed class ProfileEvent {
  const ProfileEvent();
}

final class ProfileStarted extends ProfileEvent {
  const ProfileStarted();
}

enum ProfileStatus { loading, ready, failure }

@freezed
abstract class ProfileState with _$ProfileState {
  const factory ProfileState({
    required FeedAuthor author,
    @Default(ProfileStatus.loading) ProfileStatus status,
    FeedProfile? profile,
    @Default(<FeedPost>[]) List<FeedPost> posts,
    Failure? failure,
  }) = _ProfileState;
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
