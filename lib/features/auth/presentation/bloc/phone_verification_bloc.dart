import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:find_a_nikah/core/core.dart';
import 'package:find_a_nikah/features/auth/domain/domain.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'phone_verification_bloc.freezed.dart';

sealed class PhoneVerificationEvent {
  const PhoneVerificationEvent();
}

/// [phoneNumber] in E.164 (`+8801…`).
final class PhoneNumberSubmitted extends PhoneVerificationEvent {
  const PhoneNumberSubmitted(this.phoneNumber);
  final String phoneNumber;
}

final class PhoneCodeResendRequested extends PhoneVerificationEvent {
  const PhoneCodeResendRequested();
}

final class PhoneCodeSubmitted extends PhoneVerificationEvent {
  const PhoneCodeSubmitted(this.code);
  final String code;
}

enum PhoneVerificationStatus { idle, submitting, failure, codeSent, verified }

@freezed
abstract class PhoneVerificationState with _$PhoneVerificationState {
  const factory PhoneVerificationState({
    @Default('') String phoneNumber,
    @Default(PhoneVerificationStatus.idle) PhoneVerificationStatus status,

    /// The code the backend echoed back in demo mode (`devCode`), if any —
    /// the code page autofills it in debug builds only.
    String? demoCode,
    Failure? failure,
  }) = _PhoneVerificationState;
}

/// Phone number → OTP. Provided by the Verification wizard shell so both
/// pages share the number.
class PhoneVerificationBloc
    extends Bloc<PhoneVerificationEvent, PhoneVerificationState> {
  PhoneVerificationBloc(this._repository)
    : super(const PhoneVerificationState()) {
    on<PhoneNumberSubmitted>(_onNumber, transformer: droppable());
    on<PhoneCodeResendRequested>(_onResend, transformer: droppable());
    on<PhoneCodeSubmitted>(_onCode, transformer: droppable());
  }

  final AuthRepository _repository;

  Future<void> _step<T>(
    Emitter<PhoneVerificationState> emit,
    Future<Either<Failure, T>> Function() action,
    PhoneVerificationStatus onSuccess, {
    PhoneVerificationState Function(PhoneVerificationState s, T value)? onValue,
  }) async {
    emit(
      state.copyWith(
        status: PhoneVerificationStatus.submitting,
        failure: null,
      ),
    );
    final result = await action();
    emit(
      result.fold(
        (f) => state.copyWith(
          status: PhoneVerificationStatus.failure,
          failure: f,
        ),
        (value) => (onValue?.call(state, value) ?? state).copyWith(
          status: onSuccess,
        ),
      ),
    );
  }

  Future<void> _onNumber(
    PhoneNumberSubmitted event,
    Emitter<PhoneVerificationState> emit,
  ) {
    emit(state.copyWith(phoneNumber: event.phoneNumber));
    return _step(
      emit,
      () => _repository.requestPhoneCode(event.phoneNumber),
      PhoneVerificationStatus.codeSent,
      onValue: (s, demoCode) => s.copyWith(demoCode: demoCode),
    );
  }

  Future<void> _onResend(
    PhoneCodeResendRequested event,
    Emitter<PhoneVerificationState> emit,
  ) => _step(
    emit,
    () => _repository.requestPhoneCode(state.phoneNumber),
    PhoneVerificationStatus.idle,
    onValue: (s, demoCode) => s.copyWith(demoCode: demoCode),
  );

  Future<void> _onCode(
    PhoneCodeSubmitted event,
    Emitter<PhoneVerificationState> emit,
  ) => _step(
    emit,
    () => _repository.verifyPhoneCode(
      phoneNumber: state.phoneNumber,
      code: event.code,
    ),
    PhoneVerificationStatus.verified,
  );
}
