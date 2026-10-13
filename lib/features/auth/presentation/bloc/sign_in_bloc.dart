import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:find_a_nikah/core/core.dart';
import 'package:find_a_nikah/features/auth/domain/domain.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'sign_in_bloc.freezed.dart';

sealed class SignInEvent {
  const SignInEvent();
}

final class SignInEmailSubmitted extends SignInEvent {
  const SignInEmailSubmitted({required this.email, required this.password});
  final String email;
  final String password;
}

final class SignInSocialRequested extends SignInEvent {
  const SignInSocialRequested(this.provider);
  final SocialProvider provider;
}

enum SignInStatus {
  idle,
  submitting,
  failure,

  /// Signed in. An account that hasn't started the wizard continues to
  /// "Get started"; a returning account — complete or mid-wizard — is
  /// moved on by the router.
  success,
}

@freezed
abstract class SignInState with _$SignInState {
  const factory SignInState({
    @Default(SignInStatus.idle) SignInStatus status,

    /// On [SignInStatus.success]: the account hasn't started the wizard
    /// yet (`resumeStep <= 4` — same threshold `resumeRouteFor` uses for
    /// "Get started"). Not the same as "onboarding incomplete": a
    /// returning user mid-wizard is also incomplete but isn't new, and
    /// is moved on by the router instead.
    @Default(false) bool isNewAccount,

    /// Shown once by the page's listener.
    Failure? failure,
  }) = _SignInState;
}

/// Page-scoped (welcome, login, intro).
class SignInBloc extends Bloc<SignInEvent, SignInState> {
  SignInBloc(this._repository) : super(const SignInState()) {
    // Every action is a submit button: ignore taps while one is in flight.
    on<SignInEmailSubmitted>(
      (e, emit) => _run(
        emit,
        () => _repository.signInWithEmail(
          email: e.email.trim(),
          password: e.password,
        ),
      ),
      transformer: droppable(),
    );
    on<SignInSocialRequested>(
      (e, emit) => _run(emit, () => _repository.signInWithSocial(e.provider)),
      transformer: droppable(),
    );
  }

  final AuthRepository _repository;

  Future<void> _run(
    Emitter<SignInState> emit,
    Future<Either<Failure, Unit>> Function() action,
  ) async {
    emit(const SignInState(status: SignInStatus.submitting));
    final result = await action();
    emit(
      result.fold(
        (failure) =>
            SignInState(status: SignInStatus.failure, failure: failure),
        (_) {
          final status = _repository.currentStatus;
          return SignInState(
            status: SignInStatus.success,
            // `!onboardingComplete` alone misclassifies every returning
            // mid-wizard user as "new" — resumeStep is the actual signal
            // for "hasn't started."
            isNewAccount:
                status is Authenticated && status.session.resumeStep <= 4,
          );
        },
      ),
    );
  }
}

/// Shared by the welcome, login and intro pages: reports failures, and
/// sends a brand-new account on to "Get started" (an existing account is
/// moved on by the router).
void onSignInStateChanged(
  void Function(Failure failure) showFailure,
  void Function() toGetStarted,
  SignInState state,
) {
  switch (state.status) {
    case SignInStatus.failure:
      showFailure(state.failure!);
    case SignInStatus.success when state.isNewAccount:
      toGetStarted();
    case SignInStatus.success || SignInStatus.idle || SignInStatus.submitting:
      break;
  }
}
