import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:find_a_nikah/core/core.dart';
import 'package:find_a_nikah/features/auth/domain/domain.dart';

enum ForgotPasswordStatus {
  idle,
  submitting,
  failure,

  /// Code emailed → the email page moves to the reset page.
  codeSent,

  /// Password changed → back to login.
  done,
}

class ForgotPasswordState extends Equatable {
  const ForgotPasswordState({
    this.email = '',
    this.status = ForgotPasswordStatus.idle,
    this.failure,
  });

  final String email;
  final ForgotPasswordStatus status;
  final Failure? failure;

  @override
  List<Object?> get props => [email, status, failure];
}

/// Shared by the two reset pages (email → code + new password); provided by
/// their shell route so the email survives between them.
class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  ForgotPasswordCubit(this._repository) : super(const ForgotPasswordState());

  final AuthRepository _repository;

  bool get _busy => state.status == ForgotPasswordStatus.submitting;

  Future<void> requestCode(String email) async {
    if (_busy) return;
    final trimmed = email.trim();
    emit(
      ForgotPasswordState(
        email: trimmed,
        status: ForgotPasswordStatus.submitting,
      ),
    );
    final result = await _repository.requestPasswordReset(trimmed);
    emit(
      ForgotPasswordState(
        email: trimmed,
        status: result.isRight()
            ? ForgotPasswordStatus.codeSent
            : ForgotPasswordStatus.failure,
        failure: result.fold((f) => f, (_) => null),
      ),
    );
  }

  Future<void> resetPassword({
    required String code,
    required String newPassword,
  }) async {
    if (_busy) return;
    emit(
      ForgotPasswordState(
        email: state.email,
        status: ForgotPasswordStatus.submitting,
      ),
    );
    final result = await _repository.resetPassword(
      email: state.email,
      code: code,
      newPassword: newPassword,
    );
    emit(
      ForgotPasswordState(
        email: state.email,
        status: result.isRight()
            ? ForgotPasswordStatus.done
            : ForgotPasswordStatus.failure,
        failure: result.fold((f) => f, (_) => null),
      ),
    );
  }
}
