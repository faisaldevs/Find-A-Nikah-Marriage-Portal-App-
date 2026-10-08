import 'package:dio/dio.dart';
import 'package:find_a_nikah/core/network/network.dart';
import 'package:find_a_nikah/features/auth/data/dtos/auth_dtos.dart';
import 'package:retrofit/retrofit.dart';

part 'auth_remote_data_source.g.dart';

/// Auth endpoints. Every method throws `DioException` on failure, which
/// `Guard` maps to an `ApiException` → `Failure`.
@RestApi()
abstract class AuthRemoteDataSource {
  factory AuthRemoteDataSource(Dio dio, {String? baseUrl}) =
      _AuthRemoteDataSource;

  @POST('/auth/login')
  @Extra({requiresAuthExtraKey: false})
  Future<AuthApiSessionResponseDto> login(
    @Body() EmailPasswordRequestDto body,
  );

  @POST('/auth/social')
  @Extra({requiresAuthExtraKey: false})
  Future<AuthSessionDto> socialSignIn(@Body() SocialSignInRequestDto body);

  @POST('/onboarding/email/send-code')
  @Extra({requiresAuthExtraKey: false})
  Future<void> requestSignUpCode(@Body() EmailRequestDto body);

  @POST('/onboarding/email/verify-code')
  @Extra({requiresAuthExtraKey: false})
  Future<void> verifySignUpCode(@Body() EmailCodeRequestDto body);

  @POST('/onboarding/account')
  @Extra({requiresAuthExtraKey: false})
  Future<AuthApiSessionResponseDto> register(
    @Body() EmailPasswordRequestDto body,
  );

  /// Throws [DioException] (401) when the refresh token is rejected.
  @POST('/auth/refresh')
  @Extra({requiresAuthExtraKey: false})
  Future<AuthSessionDto> refresh(@Body() RefreshRequestDto body);

  @POST('/auth/logout')
  Future<void> logout(@Body() RefreshRequestDto body);

  @POST('/me/phone/code')
  Future<void> requestPhoneCode(@Body() PhoneRequestDto body);

  @POST('/me/phone/verify')
  Future<void> verifyPhoneCode(@Body() PhoneCodeRequestDto body);

  @POST('/me/onboarding/complete')
  Future<void> completeOnboarding();

  @GET('/onboarding/status')
  Future<OnboardingStatusResponseDto> fetchOnboardingStatus();
}
