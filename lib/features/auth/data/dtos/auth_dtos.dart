import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_dtos.g.dart';
part 'auth_dtos.freezed.dart';

/// Tokens and session metadata after mapping an auth API response.
@JsonSerializable()
class AuthSessionDto {
  const AuthSessionDto({
    required this.accessToken,
    required this.refreshToken,
    required this.userId,
    required this.onboardingComplete,
  });

  factory AuthSessionDto.fromJson(Map<String, dynamic> json) =>
      _$AuthSessionDtoFromJson(json);

  final String accessToken;
  final String refreshToken;
  final String userId;
  final bool onboardingComplete;

  Map<String, dynamic> toJson() => _$AuthSessionDtoToJson(this);
}

@JsonSerializable(createFactory: false)
class EmailPasswordRequestDto {
  const EmailPasswordRequestDto({
    required this.email,
    required this.password,
    this.confirmPassword,
  });

  final String email;
  final String password;

  @JsonKey(includeIfNull: false)
  final String? confirmPassword;

  Map<String, dynamic> toJson() => _$EmailPasswordRequestDtoToJson(this);
}

@JsonSerializable(createFactory: false)
class EmailRequestDto {
  const EmailRequestDto({required this.email});

  final String email;

  Map<String, dynamic> toJson() => _$EmailRequestDtoToJson(this);
}

@JsonSerializable(createFactory: false)
class EmailCodeRequestDto {
  const EmailCodeRequestDto({required this.email, required this.code});

  final String email;
  final String code;

  Map<String, dynamic> toJson() => _$EmailCodeRequestDtoToJson(this);
}

@JsonSerializable(createFactory: false)
class PhoneRequestDto {
  const PhoneRequestDto({required this.phoneNumber});

  final String phoneNumber;

  Map<String, dynamic> toJson() => _$PhoneRequestDtoToJson(this);
}

@JsonSerializable(createFactory: false)
class PhoneCodeRequestDto {
  const PhoneCodeRequestDto({required this.phoneNumber, required this.code});

  final String phoneNumber;
  final String code;

  Map<String, dynamic> toJson() => _$PhoneCodeRequestDtoToJson(this);
}

@JsonSerializable(createFactory: false)
class SocialSignInRequestDto {
  const SocialSignInRequestDto({required this.provider, required this.idToken});

  final String provider;
  final String idToken;

  Map<String, dynamic> toJson() => _$SocialSignInRequestDtoToJson(this);
}

@JsonSerializable(createFactory: false)
class RefreshRequestDto {
  const RefreshRequestDto({required this.refreshToken});

  final String refreshToken;

  Map<String, dynamic> toJson() => _$RefreshRequestDtoToJson(this);
}

@freezed
abstract class AuthApiSessionResponseDto with _$AuthApiSessionResponseDto {
  const factory AuthApiSessionResponseDto({
    required AuthApiSessionDataDto data,
  }) = _AuthApiSessionResponseDto;

  factory AuthApiSessionResponseDto.fromJson(Map<String, dynamic> json) =>
      _$AuthApiSessionResponseDtoFromJson(json);
}

@freezed
abstract class AuthApiSessionDataDto with _$AuthApiSessionDataDto {
  const factory AuthApiSessionDataDto({
    required String accessToken,
    required String refreshToken,
    required AuthApiSessionUserDto user,
  }) = _AuthApiSessionDataDto;

  factory AuthApiSessionDataDto.fromJson(Map<String, dynamic> json) =>
      _$AuthApiSessionDataDtoFromJson(json);
}

@freezed
abstract class AuthApiSessionUserDto with _$AuthApiSessionUserDto {
  const factory AuthApiSessionUserDto({
    @JsonKey(name: '_id') required String userId,
    @JsonKey(name: 'isOnboardingComplete') required bool onboardingComplete,
  }) = _AuthApiSessionUserDto;

  factory AuthApiSessionUserDto.fromJson(Map<String, dynamic> json) =>
      _$AuthApiSessionUserDtoFromJson(json);
}

@freezed
abstract class OnboardingStatusResponseDto with _$OnboardingStatusResponseDto {
  const factory OnboardingStatusResponseDto({
    required OnboardingStatusDataDto data,
  }) = _OnboardingStatusResponseDto;

  factory OnboardingStatusResponseDto.fromJson(Map<String, dynamic> json) =>
      _$OnboardingStatusResponseDtoFromJson(json);
}

@freezed
abstract class OnboardingStatusDataDto with _$OnboardingStatusDataDto {
  const factory OnboardingStatusDataDto({
    @JsonKey(name: 'isCompleted') required bool isCompleted,

    /// Which wizard section the user has yet to finish (4 Basics, 5
    /// Background & faith, 6 Lifestyle & personality, 7 Bio — matching
    /// `OnboardingSubmissionRepository`'s step literals). Defaults to 4
    /// (the first section) if the backend omits it.
    @JsonKey(name: 'currentStep') @Default(4) int currentStep,
    OnboardingStatusUserDto? user,
  }) = _OnboardingStatusDataDto;

  factory OnboardingStatusDataDto.fromJson(Map<String, dynamic> json) =>
      _$OnboardingStatusDataDtoFromJson(json);
}

@freezed
abstract class OnboardingStatusUserDto with _$OnboardingStatusUserDto {
  const factory OnboardingStatusUserDto({
    @Default(false) bool isPhoneVerified,
  }) = _OnboardingStatusUserDto;

  factory OnboardingStatusUserDto.fromJson(Map<String, dynamic> json) =>
      _$OnboardingStatusUserDtoFromJson(json);
}

extension AuthApiSessionResponseDtoSession on AuthApiSessionResponseDto {
  AuthSessionDto toAuthSession() => AuthSessionDto(
    accessToken: data.accessToken,
    refreshToken: data.refreshToken,
    userId: data.user.userId,
    onboardingComplete: data.user.onboardingComplete,
  );
}
