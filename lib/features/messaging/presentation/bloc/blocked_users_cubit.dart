import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:find_a_nikah/core/core.dart';
import 'package:find_a_nikah/features/messaging/domain/domain.dart';

enum BlockedUsersStatus { loading, ready, failure }

class BlockedUsersState extends Equatable {
  const BlockedUsersState({
    this.status = BlockedUsersStatus.loading,
    this.users = const <BlockedUser>[],
    this.failure,
    this.unblockedName,
  });

  final BlockedUsersStatus status;
  final List<BlockedUser> users;

  /// Set when an action fails; shown once.
  final Failure? failure;

  /// Set after a successful unblock; shown once.
  final String? unblockedName;

  BlockedUsersState copyWith({
    BlockedUsersStatus? status,
    List<BlockedUser>? users,
    Object? failure = unchanged,
    Object? unblockedName = unchanged,
  }) => BlockedUsersState(
    status: status ?? this.status,
    users: users ?? this.users,
    failure: identical(failure, unchanged) ? this.failure : failure as Failure?,
    unblockedName: identical(unblockedName, unchanged)
        ? this.unblockedName
        : unblockedName as String?,
  );

  @override
  List<Object?> get props => [status, users, failure, unblockedName];
}

/// Settings → "Profiles I've blocked": the list, and unblocking.
class BlockedUsersCubit extends Cubit<BlockedUsersState> {
  BlockedUsersCubit(this._repo) : super(const BlockedUsersState());

  final MessagingRepository _repo;

  Future<void> load() async {
    emit(state.copyWith(status: BlockedUsersStatus.loading, failure: null));
    final res = await _repo.fetchBlocked();
    res.match(
      (f) => emit(
        state.copyWith(status: BlockedUsersStatus.failure, failure: f),
      ),
      (users) => emit(
        state.copyWith(status: BlockedUsersStatus.ready, users: users),
      ),
    );
  }

  Future<void> unblock(BlockedUser user) async {
    final res = await _repo.unblockUser(user.id);
    res.match(
      (f) => emit(state.copyWith(failure: f, unblockedName: null)),
      (_) => emit(
        state.copyWith(
          users: [
            for (final u in state.users)
              if (u.id != user.id) u,
          ],
          failure: null,
          unblockedName: user.name,
        ),
      ),
    );
  }
}
