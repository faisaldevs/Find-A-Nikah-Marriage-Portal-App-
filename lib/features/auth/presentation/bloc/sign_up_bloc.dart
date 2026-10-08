import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:find_a_nikah/core/core.dart';
import 'package:find_a_nikah/features/auth/domain/domain.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'sign_up_bloc.freezed.dart';

sealed class SignUpEvent {
  const SignUpEvent();
}

final class SignUpEmailSubmitted extends SignUpEvent {
  const SignUpEmailSubmitted(this.email);
  final String email;
}

final class SignUpCodeResendRequested extends SignUpEvent {
  const SignUpCodeResendRequested();
}

final class SignUpCodeSubmitted extends SignUpEvent {
  const SignUpCodeSubmitted(this.code);
  final String code;
}

final class SignUpPasswordSubmitted extends SignUpEvent {
  const SignUpPasswordSubmitted(this.password);
  final String password;
}

enum SignUpStatus {
  idle,
  submitting,
  failure,

  /// Email accepted, code sent → the email page moves to the code page.
  codeSent,

  /// Code accepted → the code page moves to the password page.
  emailVerified,

  /// Account created; the session started, the router takes over.
  registered,
}

enum SignUpOperation { none, requestCode, resendCode, verifyCode, createAccount }

@freezed
abstract class SignUpState with _$SignUpState {
  const factory SignUpState({
    @Default('') String email,
    @Default(SignUpStatus.idle) SignUpStatus status,
    @Default(SignUpOperation.none) SignUpOperation operation,
    Failure? failure,
  }) = _SignUpState;
}

/// Shared by the three sign-up pages (email → code → password); provided by
/// their shell route so the email survives between steps.
class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  SignUpBloc(this._repository) : super(const SignUpState()) {
    on<SignUpEmailSubmitted>(_onEmailSubmitted, transformer: droppable());
    on<SignUpCodeResendRequested>(_onResend, transformer: droppable());
    on<SignUpCodeSubmitted>(_onCodeSubmitted, transformer: droppable());
    on<SignUpPasswordSubmitted>(_onPassword, transformer: droppable());
  }

  final AuthRepository _repository;

  Future<void> _step(
    Emitter<SignUpState> emit,
    Future<Either<Failure, Unit>> Function() action,
    SignUpStatus onSuccess,
    SignUpOperation operation,
  ) async {
    emit(
      state.copyWith(
        status: SignUpStatus.submitting,
        operation: operation,
        failure: null,
      ),
    );
    final result = await action();
    emit(
      result.fold(
        (f) => state.copyWith(status: SignUpStatus.failure, failure: f),
        (_) => state.copyWith(status: onSuccess),
      ),
    );
  }

  Future<void> _onEmailSubmitted(
    SignUpEmailSubmitted event,
    Emitter<SignUpState> emit,
  ) {
    final email = event.email.trim();
    emit(state.copyWith(email: email));
    return _step(
      emit,
      () => _repository.requestSignUpCode(email),
      SignUpStatus.codeSent,
      SignUpOperation.requestCode,
    );
  }

  Future<void> _onResend(
    SignUpCodeResendRequested event,
    Emitter<SignUpState> emit,
  ) => _step(
    emit,
    () => _repository.requestSignUpCode(state.email),
    SignUpStatus.idle,
    SignUpOperation.resendCode,
  );

  Future<void> _onCodeSubmitted(
    SignUpCodeSubmitted event,
    Emitter<SignUpState> emit,
  ) => _step(
    emit,
    () => _repository.verifySignUpCode(email: state.email, code: event.code),
    SignUpStatus.emailVerified,
    SignUpOperation.verifyCode,
  );

  Future<void> _onPassword(
    SignUpPasswordSubmitted event,
    Emitter<SignUpState> emit,
  ) => _step(
    emit,
    () => _repository.register(email: state.email, password: event.password),
    SignUpStatus.registered,
    SignUpOperation.createAccount,
  );
}
