import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:find_a_nikah/core/core.dart';
import 'package:find_a_nikah/features/menu/domain/domain.dart';

sealed class MenuEvent {
  const MenuEvent();
}

/// Menu tab opened (or pulled to refresh).
final class MenuStarted extends MenuEvent {
  const MenuStarted();
}

final class MenuTabSelected extends MenuEvent {
  const MenuTabSelected(this.tab);
  final MenuTab tab;
}

/// The chip row under the profile header. Help and Safety open their own
/// pages; only these two switch the content in place.
enum MenuTab { membership, invite }

enum MenuStatus { loading, ready, failure }

class MenuState extends Equatable {
  const MenuState({
    this.status = MenuStatus.loading,
    this.tab = MenuTab.membership,
    this.profile,
    this.membership,
    this.failure,
    this.refreshing = false,
  });

  final MenuStatus status;
  final MenuTab tab;
  final MyProfile? profile;
  final Membership? membership;
  final Failure? failure;

  /// A fresh copy is loading behind the cached one (pull to refresh waits
  /// for it).
  final bool refreshing;

  MenuState copyWith({
    MenuStatus? status,
    MenuTab? tab,
    Object? profile = unchanged,
    Object? membership = unchanged,
    Object? failure = unchanged,
    bool? refreshing,
  }) {
    return MenuState(
      status: status ?? this.status,
      tab: tab ?? this.tab,
      profile: identical(profile, unchanged)
          ? this.profile
          : profile as MyProfile?,
      membership: identical(membership, unchanged)
          ? this.membership
          : membership as Membership?,
      failure: identical(failure, unchanged)
          ? this.failure
          : failure as Failure?,
      refreshing: refreshing ?? this.refreshing,
    );
  }

  @override
  List<Object?> get props => [
    status,
    tab,
    profile,
    membership,
    failure,
    refreshing,
  ];
}

/// Menu tab: the member's header (photo, name, verified) + Membership /
/// Invite content.
class MenuBloc extends Bloc<MenuEvent, MenuState> {
  MenuBloc(this._repo) : super(const MenuState()) {
    on<MenuStarted>(_onStarted, transformer: restartable());
    on<MenuTabSelected>((e, emit) => emit(state.copyWith(tab: e.tab)));
  }

  final MenuRepository _repo;

  // Before: waited for the API on every visit.
  // Future<void> _onStarted(MenuStarted event, Emitter<MenuState> emit) async {
  //   if (state.profile == null) {
  //     emit(state.copyWith(status: MenuStatus.loading, failure: null));
  //   }
  //   final profile = await _repo.fetchMyProfile();
  //   final membership = await _repo.fetchMembership();
  //   emit(
  //     profile
  //         .flatMap((p) => membership.map((m) => (p, m)))
  //         .fold(
  //           (f) => state.copyWith(status: MenuStatus.failure, failure: f),
  //           (r) => state.copyWith(
  //             status: MenuStatus.ready,
  //             profile: r.$1,
  //             membership: r.$2,
  //             failure: null,
  //           ),
  //         ),
  //   );
  // }

  /// Cached profile at once, then every change (edits made in Edit profile
  /// show here too), while a fresh copy loads quietly.
  Future<void> _onStarted(MenuStarted event, Emitter<MenuState> emit) async {
    final cached = state.profile ?? await _repo.cachedMyProfile();
    emit(
      state.copyWith(
        status: cached == null ? MenuStatus.loading : MenuStatus.ready,
        profile: cached,
        failure: null,
        refreshing: true,
      ),
    );
    // The plan card loads alongside; it must not hold up the header.
    unawaited(
      _repo.fetchMembership().then((r) {
        if (!emit.isDone) r.map((m) => emit(state.copyWith(membership: m)));
      }),
    );
    final changes = emit.forEach<MyProfile>(
      _repo.myProfileChanges,
      onData: (p) => state.copyWith(status: MenuStatus.ready, profile: p),
    );
    final fresh = await _repo.fetchMyProfile();
    emit(
      fresh.fold(
        // With a cached copy on screen a failed refresh stays quiet.
        (f) => state.profile == null
            ? state.copyWith(
                status: MenuStatus.failure,
                failure: f,
                refreshing: false,
              )
            : state.copyWith(refreshing: false),
        (p) => state.copyWith(
          status: MenuStatus.ready,
          profile: p,
          refreshing: false,
        ),
      ),
    );
    await changes;
  }
}
