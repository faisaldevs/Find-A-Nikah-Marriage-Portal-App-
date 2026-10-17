// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_dtos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthSessionDto _$AuthSessionDtoFromJson(Map<String, dynamic> json) =>
    AuthSessionDto(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      userId: json['userId'] as String,
      onboardingComplete: json['onboardingComplete'] as bool,
    );

Map<String, dynamic> _$AuthSessionDtoToJson(AuthSessionDto instance) =>
    <String, dynamic>{
      'accessToken': instance.accessToken,
      'refreshToken': instance.refreshToken,
      'userId': instance.userId,
      'onboardingComplete': instance.onboardingComplete,
    };

Map<String, dynamic> _$EmailPasswordRequestDtoToJson(
  EmailPasswordRequestDto instance,
) => <String, dynamic>{
  'email': instance.email,
  'password': instance.password,
  'confirmPassword': ?instance.confirmPassword,
};

Map<String, dynamic> _$EmailRequestDtoToJson(EmailRequestDto instance) =>
    <String, dynamic>{'email': instance.email};

Map<String, dynamic> _$EmailCodeRequestDtoToJson(
  EmailCodeRequestDto instance,
) => <String, dynamic>{'email': instance.email, 'code': instance.code};

Map<String, dynamic> _$PhoneRequestDtoToJson(PhoneRequestDto instance) =>
    <String, dynamic>{'phone': instance.phoneNumber};

Map<String, dynamic> _$PhoneCodeRequestDtoToJson(
  PhoneCodeRequestDto instance,
) => <String, dynamic>{'phone': instance.phoneNumber, 'code': instance.code};

Map<String, dynamic> _$SocialSignInRequestDtoToJson(
  SocialSignInRequestDto instance,
) => <String, dynamic>{
  'provider': instance.provider,
  'idToken': instance.idToken,
};

Map<String, dynamic> _$RefreshRequestDtoToJson(RefreshRequestDto instance) =>
    <String, dynamic>{'refreshToken': instance.refreshToken};

_AuthApiSessionResponseDto _$AuthApiSessionResponseDtoFromJson(
  Map<String, dynamic> json,
) => _AuthApiSessionResponseDto(
  data: AuthApiSessionDataDto.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$AuthApiSessionResponseDtoToJson(
  _AuthApiSessionResponseDto instance,
) => <String, dynamic>{'data': instance.data};

_AuthApiSessionDataDto _$AuthApiSessionDataDtoFromJson(
  Map<String, dynamic> json,
) => _AuthApiSessionDataDto(
  accessToken: json['accessToken'] as String,
  refreshToken: json['refreshToken'] as String,
  user: AuthApiSessionUserDto.fromJson(json['user'] as Map<String, dynamic>),
);

Map<String, dynamic> _$AuthApiSessionDataDtoToJson(
  _AuthApiSessionDataDto instance,
) => <String, dynamic>{
  'accessToken': instance.accessToken,
  'refreshToken': instance.refreshToken,
  'user': instance.user,
};

_AuthApiSessionUserDto _$AuthApiSessionUserDtoFromJson(
  Map<String, dynamic> json,
) => _AuthApiSessionUserDto(
  userId: json['_id'] as String,
  onboardingComplete: json['isOnboardingComplete'] as bool,
);

Map<String, dynamic> _$AuthApiSessionUserDtoToJson(
  _AuthApiSessionUserDto instance,
) => <String, dynamic>{
  '_id': instance.userId,
  'isOnboardingComplete': instance.onboardingComplete,
};

_OnboardingStatusResponseDto _$OnboardingStatusResponseDtoFromJson(
  Map<String, dynamic> json,
) => _OnboardingStatusResponseDto(
  data: OnboardingStatusDataDto.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$OnboardingStatusResponseDtoToJson(
  _OnboardingStatusResponseDto instance,
) => <String, dynamic>{'data': instance.data};

_OnboardingStatusDataDto _$OnboardingStatusDataDtoFromJson(
  Map<String, dynamic> json,
) => _OnboardingStatusDataDto(
  isCompleted: json['isCompleted'] as bool,
  currentStep: (json['currentStep'] as num?)?.toInt() ?? 4,
  user: json['user'] == null
      ? null
      : OnboardingStatusUserDto.fromJson(json['user'] as Map<String, dynamic>),
  profile: json['profile'] == null
      ? null
      : OnboardingStatusProfileDto.fromJson(
          json['profile'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$OnboardingStatusDataDtoToJson(
  _OnboardingStatusDataDto instance,
) => <String, dynamic>{
  'isCompleted': instance.isCompleted,
  'currentStep': instance.currentStep,
  'user': instance.user,
  'profile': instance.profile,
};

_OnboardingStatusProfileDto _$OnboardingStatusProfileDtoFromJson(
  Map<String, dynamic> json,
) => _OnboardingStatusProfileDto(
  images: json['images'] as List<dynamic>? ?? const <Object?>[],
  faceVerification: json['faceVerification'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$OnboardingStatusProfileDtoToJson(
  _OnboardingStatusProfileDto instance,
) => <String, dynamic>{
  'images': instance.images,
  'faceVerification': instance.faceVerification,
};

_OnboardingStatusUserDto _$OnboardingStatusUserDtoFromJson(
  Map<String, dynamic> json,
) => _OnboardingStatusUserDto(
  isPhoneVerified: json['isPhoneVerified'] as bool? ?? false,
  onboardingStep: (json['onboardingStep'] as num?)?.toInt() ?? 4,
);

Map<String, dynamic> _$OnboardingStatusUserDtoToJson(
  _OnboardingStatusUserDto instance,
) => <String, dynamic>{
  'isPhoneVerified': instance.isPhoneVerified,
  'onboardingStep': instance.onboardingStep,
};

_PhoneCodeSentResponseDto _$PhoneCodeSentResponseDtoFromJson(
  Map<String, dynamic> json,
) => _PhoneCodeSentResponseDto(
  data: json['data'] == null
      ? null
      : PhoneCodeSentDataDto.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$PhoneCodeSentResponseDtoToJson(
  _PhoneCodeSentResponseDto instance,
) => <String, dynamic>{'data': instance.data};

_PhoneCodeSentDataDto _$PhoneCodeSentDataDtoFromJson(
  Map<String, dynamic> json,
) => _PhoneCodeSentDataDto(
  devCode: json['devCode'] as String?,
  code: json['code'] as String?,
);

Map<String, dynamic> _$PhoneCodeSentDataDtoToJson(
  _PhoneCodeSentDataDto instance,
) => <String, dynamic>{'devCode': instance.devCode, 'code': instance.code};

_PhoneVerifiedResponseDto _$PhoneVerifiedResponseDtoFromJson(
  Map<String, dynamic> json,
) => _PhoneVerifiedResponseDto(
  data: json['data'] == null
      ? null
      : PhoneVerifiedDataDto.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$PhoneVerifiedResponseDtoToJson(
  _PhoneVerifiedResponseDto instance,
) => <String, dynamic>{'data': instance.data};

_PhoneVerifiedDataDto _$PhoneVerifiedDataDtoFromJson(
  Map<String, dynamic> json,
) => _PhoneVerifiedDataDto(
  isPhoneVerified: json['isPhoneVerified'] as bool? ?? false,
  verified: json['verified'] as bool? ?? false,
);

Map<String, dynamic> _$PhoneVerifiedDataDtoToJson(
  _PhoneVerifiedDataDto instance,
) => <String, dynamic>{
  'isPhoneVerified': instance.isPhoneVerified,
  'verified': instance.verified,
};
