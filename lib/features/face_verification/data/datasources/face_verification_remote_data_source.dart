import 'dart:io';

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'face_verification_remote_data_source.g.dart';

/// Server-side selfie ↔ profile-photo matching (AWS Rekognition
/// `CompareFaces` or equivalent behind the backend).
@RestApi()
abstract class FaceVerificationRemoteDataSource {
  factory FaceVerificationRemoteDataSource(Dio dio) =
      _FaceVerificationRemoteDataSource;

  /// 202 Accepted: the match runs asynchronously; the profile is "under
  /// review" until the server pushes the verdict.
  @POST('/me/verification/face')
  @MultiPart()
  Future<void> submit(
    @Part(name: 'profilePhoto') File profilePhoto,
    @Part(name: 'selfie') File selfie,
  );

  /// Starts a liveness session. 201 with the standard envelope:
  /// `{data: {sessionId, challenges: [front, left, right],
  /// expiresInSeconds}}` — read by `FaceVerificationResponseMapper`.
  // Base URL is `…/api` (`API_BASE_URL`); `/v1` goes in the path, as
  // in `OnboardingRemoteDataSource`.
  @POST('/v1/profile/face-verification/start')
  Future<HttpResponse<dynamic>> startFaceSession();

  /// Uploads one still per challenge plus the `sessionId`, as multipart
  /// [body] (built by the repository from the session's plan, since the
  /// challenge list comes from the server).
  ///
  /// `TODO(api)`: request field names and the response shape are
  /// unconfirmed — the result is currently ignored and treated as success
  /// (see `FaceVerificationResponseMapper.mapResult`).
  /// [options] carries this call's longer timeouts — the backend runs face
  /// detection/matching on all stills before answering (seen >20s).
  @POST('/v1/profile/face-verification')
  Future<HttpResponse<dynamic>> verifyFace(
    @Body() FormData body, {
    @DioOptions() Options? options,
  });
}

/// Dev-flavor outcomes [FakeFaceVerificationRemoteDataSource.verifyFace] can
/// be made to return, so every bloc/UI state is reachable without a
/// backend. Toggle [FakeFaceVerificationRemoteDataSource.devOutcome]
/// manually while testing.
enum FakeLivenessOutcome { verified, underReview, rejected, networkError }

/// Offline stand-in (no longer wired into the dev flavor, which now hits
/// the real backend): accepts every single-selfie submission after a short
/// delay, and fakes the liveness endpoints per [devOutcome].
class FakeFaceVerificationRemoteDataSource
    implements FaceVerificationRemoteDataSource {
  const FakeFaceVerificationRemoteDataSource();

  static FakeLivenessOutcome devOutcome = FakeLivenessOutcome.underReview;

  @override
  Future<void> submit(File profilePhoto, File selfie) =>
      Future<void>.delayed(const Duration(milliseconds: 600));

  @override
  Future<HttpResponse<dynamic>> startFaceSession() async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    const body = {
      'statusCode': 201,
      'data': {
        'sessionId': 'dev-session',
        'challenges': ['front', 'left', 'right'],
        'expiresInSeconds': 120,
      },
      'message': 'Face check started',
      'success': true,
    };
    return HttpResponse<dynamic>(
      body,
      Response<dynamic>(
        requestOptions: RequestOptions(
          path: '/profile/face-verification/start',
        ),
        statusCode: 201,
        data: body,
      ),
    );
  }

  @override
  Future<HttpResponse<dynamic>> verifyFace(
    FormData body, {
    Options? options,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 1500));
    const path = '/v1/profile/face-verification';
    switch (devOutcome) {
      case FakeLivenessOutcome.verified:
        return HttpResponse<dynamic>(
          {'status': 'verified'},
          Response<dynamic>(
            requestOptions: RequestOptions(path: path),
            statusCode: 200,
          ),
        );
      case FakeLivenessOutcome.underReview:
        return HttpResponse<dynamic>(
          {'status': 'underReview'},
          Response<dynamic>(
            requestOptions: RequestOptions(path: path),
            statusCode: 202,
          ),
        );
      case FakeLivenessOutcome.rejected:
        return HttpResponse<dynamic>(
          {'reason': 'Face did not match', 'canRetry': true},
          Response<dynamic>(
            requestOptions: RequestOptions(path: path),
            statusCode: 422,
          ),
        );
      case FakeLivenessOutcome.networkError:
        throw DioException.connectionError(
          requestOptions: RequestOptions(path: path),
          reason: 'dev fake: simulated network error',
        );
    }
  }
}
