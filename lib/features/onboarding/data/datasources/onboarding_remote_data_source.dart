import 'package:dio/dio.dart';
import 'package:find_a_nikah/features/onboarding/data/dtos/onboarding_profile_response.dart';
import 'package:find_a_nikah/features/onboarding/data/dtos/onboarding_step_request.dart';
import 'package:retrofit/retrofit.dart';

part 'onboarding_remote_data_source.g.dart';

/// Profile wizard steps 4-8. Same base as `AiBioRemoteDataSource`: plain
/// `api.dio`, `/v1` hardcoded in the path.
@RestApi()
abstract class OnboardingRemoteDataSource {
  factory OnboardingRemoteDataSource(Dio dio) = _OnboardingRemoteDataSource;

  /// Same endpoint auth's `fetchOnboardingStatus` calls — read again here
  /// for `profile`, to prefill the wizard when resuming.
  @GET('/v1/onboarding/status')
  Future<OnboardingProfileResponseDto> getProfile();

  @PATCH('/v1/onboarding/step')
  Future<void> submitBasics(@Body() OnboardingBasicsRequestDto body);

  @PATCH('/v1/onboarding/step')
  Future<void> submitBackgroundFaith(
    @Body() OnboardingBackgroundFaithRequestDto body,
  );

  @PATCH('/v1/onboarding/step')
  Future<void> submitLifestylePersonality(
    @Body() OnboardingLifestylePersonalityRequestDto body,
  );

  @PATCH('/v1/onboarding/step')
  Future<void> submitBio(@Body() OnboardingBioRequestDto body);

  // Replaced: step 8 takes the image files themselves as multipart, not a
  // JSON list of already-uploaded URLs.
  // /// Built for the images step; not called anywhere yet.
  // @PATCH('/v1/onboarding/step')
  // Future<void> submitImages(@Body() OnboardingImagesRequestDto body);

  /// Step 8 — Photos, multipart: `step=8` plus one repeated `images` file
  /// field per photo (built by `OnboardingSubmissionRepositoryImpl`). The
  /// server stores them and returns their `/public/upload/...` paths in
  /// `profile.images` (not read yet — nothing needs them).
  @PATCH('/v1/onboarding/step')
  Future<void> submitPhotos(@Body() FormData body);

  /// Deletes one already-uploaded photo by its file name (the last segment
  /// of `/public/upload/<filename>`).
  @DELETE('/v1/onboarding/images')
  Future<void> deletePhoto(@Query('filename') String filename);
}
