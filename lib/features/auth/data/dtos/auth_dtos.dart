import 'package:json_annotation/json_annotation.dart';

part 'auth_dtos.g.dart';

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

  // Backend field is `phone` (was `phoneNumber` in the placeholder API).
  @JsonKey(name: 'phone')
  final String phoneNumber;

  Map<String, dynamic> toJson() => _$PhoneRequestDtoToJson(this);
}

@JsonSerializable(createFactory: false)
class PhoneCodeRequestDto {
  const PhoneCodeRequestDto({required this.phoneNumber, required this.code});

  @JsonKey(name: 'phone')
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

@JsonSerializable()
class AuthApiSessionResponseDto {
  const AuthApiSessionResponseDto({
    required this.data,
  });

  factory AuthApiSessionResponseDto.fromJson(Map<String, dynamic> json) =>
      _$AuthApiSessionResponseDtoFromJson(json);

  final AuthApiSessionDataDto data;

  Map<String, dynamic> toJson() => _$AuthApiSessionResponseDtoToJson(this);
}

@JsonSerializable()
class AuthApiSessionDataDto {
  const AuthApiSessionDataDto({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
  });

  factory AuthApiSessionDataDto.fromJson(Map<String, dynamic> json) =>
      _$AuthApiSessionDataDtoFromJson(json);

  final String accessToken;
  final String refreshToken;
  final AuthApiSessionUserDto user;

  Map<String, dynamic> toJson() => _$AuthApiSessionDataDtoToJson(this);
}

@JsonSerializable()
class AuthApiSessionUserDto {
  const AuthApiSessionUserDto({
    required this.userId,
    required this.onboardingComplete,
  });

  factory AuthApiSessionUserDto.fromJson(Map<String, dynamic> json) =>
      _$AuthApiSessionUserDtoFromJson(json);

  @JsonKey(name: '_id')
  final String userId;
  @JsonKey(name: 'isOnboardingComplete')
  final bool onboardingComplete;

  Map<String, dynamic> toJson() => _$AuthApiSessionUserDtoToJson(this);
}

@JsonSerializable()
class OnboardingStatusResponseDto {
  const OnboardingStatusResponseDto({
    required this.data,
  });

  factory OnboardingStatusResponseDto.fromJson(Map<String, dynamic> json) =>
      _$OnboardingStatusResponseDtoFromJson(json);

  final OnboardingStatusDataDto data;

  Map<String, dynamic> toJson() => _$OnboardingStatusResponseDtoToJson(this);
}

@JsonSerializable()
class OnboardingStatusDataDto {
  const OnboardingStatusDataDto({
    required this.isCompleted,
    this.currentStep = 4,
    this.user,
    this.profile,
  });

  factory OnboardingStatusDataDto.fromJson(Map<String, dynamic> json) =>
      _$OnboardingStatusDataDtoFromJson(json);

  @JsonKey(name: 'isCompleted')
  final bool isCompleted;

  /// Which wizard section the user has yet to finish (4 Basics, 5
  /// Background & faith, 6 Lifestyle & personality, 7 Bio — matching
  /// `OnboardingSubmissionRepository`'s step literals). Defaults to 4
  /// (the first section) if the backend omits it.
  @JsonKey(name: 'currentStep')
  final int currentStep;

  final OnboardingStatusUserDto? user;

  /// Only what resume needs (photo count, face check).
  final OnboardingStatusProfileDto? profile;

  Map<String, dynamic> toJson() => _$OnboardingStatusDataDtoToJson(this);
}

@JsonSerializable()
class OnboardingStatusProfileDto {
  const OnboardingStatusProfileDto({
    this.images = const <Object?>[],
    this.faceVerification,
  });

  factory OnboardingStatusProfileDto.fromJson(Map<String, dynamic> json) =>
      _$OnboardingStatusProfileDtoFromJson(json);

  final List<Object?> images;
  final Map<String, dynamic>? faceVerification;

  Map<String, dynamic> toJson() => _$OnboardingStatusProfileDtoToJson(this);
}

/// Photos needed before the face check (mirrors onboarding's minimum).
const _minPhotos = 3;

extension OnboardingStatusResume on OnboardingStatusDataDto {
  /// Where to resume (audit #6/#41). Steps 4–7 are the profile wizard as
  /// before. From 8 on the backend counter alone isn't reliable (it jumped
  /// 8→10 on phone verify and fell back to 9 on photo upload), so the next
  /// unfinished thing is read from the data and encoded for
  /// `resumeRouteFor`: 8 phone, 9 photos/face check, 11 location,
  /// 12 filters + finish.
  int get resumeStep {
    final step = [currentStep, user?.onboardingStep ?? 0].reduce(
      (a, b) => a > b ? a : b,
    );
    if (step < 8) return step;
    if (!(user?.isPhoneVerified ?? false)) return 8;
    final photos = profile?.images.length ?? 0;
    final faceVerified = profile?.faceVerification?['isFaceVerified'] == true;
    if (photos < _minPhotos || !faceVerified) return 9;
    if (step < 12) return 11;
    return 12;
  }

  /// TEMP until the backend's complete endpoint is fixed: saving Location
  /// (step 11) moves `currentStep` to 12, and that's treated as done —
  /// filters are no longer an onboarding step (Marriage → filters).
  bool get isEffectivelyCompleted => isCompleted || resumeStep >= 12;
}

@JsonSerializable()
class OnboardingStatusUserDto {
  const OnboardingStatusUserDto({
    this.isPhoneVerified = false,
    this.onboardingStep = 4,
  });

  factory OnboardingStatusUserDto.fromJson(Map<String, dynamic> json) =>
      _$OnboardingStatusUserDtoFromJson(json);

  final bool isPhoneVerified;
  final int onboardingStep;

  Map<String, dynamic> toJson() => _$OnboardingStatusUserDtoToJson(this);
}

extension AuthApiSessionResponseDtoSession on AuthApiSessionResponseDto {
  AuthSessionDto toAuthSession() => AuthSessionDto(
    accessToken: data.accessToken,
    refreshToken: data.refreshToken,
    userId: data.user.userId,
    onboardingComplete: data.user.onboardingComplete,
  );
}

/// `POST /onboarding/phone/send-code` → `{data: {phone, code, devCode}}`.
/// `devCode`/`code` are only present in the backend's demo mode.
@JsonSerializable()
class PhoneCodeSentResponseDto {
  const PhoneCodeSentResponseDto({
    this.data,
  });

  factory PhoneCodeSentResponseDto.fromJson(Map<String, dynamic> json) =>
      _$PhoneCodeSentResponseDtoFromJson(json);

  final PhoneCodeSentDataDto? data;

  Map<String, dynamic> toJson() => _$PhoneCodeSentResponseDtoToJson(this);
}

@JsonSerializable()
class PhoneCodeSentDataDto {
  const PhoneCodeSentDataDto({
    this.devCode,
    this.code,
  });

  factory PhoneCodeSentDataDto.fromJson(Map<String, dynamic> json) =>
      _$PhoneCodeSentDataDtoFromJson(json);

  final String? devCode;
  final String? code;

  Map<String, dynamic> toJson() => _$PhoneCodeSentDataDtoToJson(this);
}

/// `POST /onboarding/phone/verify-code` → `{data: {phone, isPhoneVerified,
/// verified}}`.
@JsonSerializable()
class PhoneVerifiedResponseDto {
  const PhoneVerifiedResponseDto({
    this.data,
  });

  factory PhoneVerifiedResponseDto.fromJson(Map<String, dynamic> json) =>
      _$PhoneVerifiedResponseDtoFromJson(json);

  final PhoneVerifiedDataDto? data;

  Map<String, dynamic> toJson() => _$PhoneVerifiedResponseDtoToJson(this);
}

@JsonSerializable()
class PhoneVerifiedDataDto {
  const PhoneVerifiedDataDto({
    this.isPhoneVerified = false,
    this.verified = false,
  });

  factory PhoneVerifiedDataDto.fromJson(Map<String, dynamic> json) =>
      _$PhoneVerifiedDataDtoFromJson(json);

  final bool isPhoneVerified;
  final bool verified;

  Map<String, dynamic> toJson() => _$PhoneVerifiedDataDtoToJson(this);
}
