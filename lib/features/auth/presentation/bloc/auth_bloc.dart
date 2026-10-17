import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:find_a_nikah/core/core.dart';
import 'package:find_a_nikah/features/auth/domain/domain.dart';

sealed class AuthEvent {
  const AuthEvent();
}

/// App start: restore stored credentials and follow status changes.
final class AuthStatusSubscriptionRequested extends AuthEvent {
  const AuthStatusSubscriptionRequested();
}

final class AuthSignOutRequested extends AuthEvent {
  const AuthSignOutRequested();
}

/// Dev-only: the intro carousel's "Skip" button. See
/// [AuthRepository.devSkipToApp].
final class AuthDevSkipRequested extends AuthEvent {
  const AuthDevSkipRequested();
}

/// App-scoped (sits above the router). Its state is the [AuthStatus] the
/// router's redirect guards on.
class AuthBloc extends Bloc<AuthEvent, AuthStatus> {
  AuthBloc(this._repository, this._signOut)
    : super(const AuthStatus.unknown()) {
    on<AuthStatusSubscriptionRequested>(
      _onSubscriptionRequested,
      transformer: restartable(),
    );
    on<AuthSignOutRequested>(_onSignOutRequested, transformer: droppable());
    on<AuthDevSkipRequested>(
      (event, emit) => _repository.devSkipToApp(),
      transformer: droppable(),
    );
  }

  final AuthRepository _repository;
  final SignOut _signOut;

  Future<void> _onSubscriptionRequested(
    AuthStatusSubscriptionRequested event,
    Emitter<AuthStatus> emit,
  ) async {
    final subscription = emit.forEach<AuthStatus>(
      _repository.watchStatus(),
      onData: (status) => status,
    );
    await _repository.restoreSession();
    await subscription;
  }

  Future<void> _onSignOutRequested(
    AuthSignOutRequested event,
    Emitter<AuthStatus> emit,
  ) async {
    await _signOut(const NoParams());
  }
}
