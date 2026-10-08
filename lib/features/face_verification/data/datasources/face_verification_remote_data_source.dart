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
}

/// Dev flavor: accepts every submission after a short delay.
class FakeFaceVerificationRemoteDataSource
    implements FaceVerificationRemoteDataSource {
  const FakeFaceVerificationRemoteDataSource();

  @override
  Future<void> submit(File profilePhoto, File selfie) =>
      Future<void>.delayed(const Duration(milliseconds: 600));
}
