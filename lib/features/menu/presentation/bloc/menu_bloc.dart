import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:find_a_nikah/core/core.dart';
import 'package:find_a_nikah/features/menu/domain/domain.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'menu_bloc.freezed.dart';

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

@freezed
abstract class MenuState with _$MenuState {
  const factory MenuState({
    @Default(MenuStatus.loading) MenuStatus status,
    @Default(MenuTab.membership) MenuTab tab,
    MyProfile? profile,
    Membership? membership,
    Failure? failure,
  }) = _MenuState;
}

/// Menu tab: the member's header (photo, name, verified) + Membership /
/// Invite content.
class MenuBloc extends Bloc<MenuEvent, MenuState> {
  MenuBloc(this._repo) : super(const MenuState()) {
    on<MenuStarted>(_onStarted, transformer: restartable());
    on<MenuTabSelected>((e, emit) => emit(state.copyWith(tab: e.tab)));
  }

  final MenuRepository _repo;

  Future<void> _onStarted(MenuStarted event, Emitter<MenuState> emit) async {
    if (state.profile == null) {
      emit(state.copyWith(status: MenuStatus.loading, failure: null));
    }
    final profile = await _repo.fetchMyProfile();
    final membership = await _repo.fetchMembership();
    emit(
      profile
          .flatMap((p) => membership.map((m) => (p, m)))
          .fold(
            (f) => state.copyWith(status: MenuStatus.failure, failure: f),
            (r) => state.copyWith(
              status: MenuStatus.ready,
              profile: r.$1,
              membership: r.$2,
              failure: null,
            ),
          ),
    );
  }
}
