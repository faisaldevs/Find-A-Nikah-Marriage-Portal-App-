import 'dart:io';

import 'package:find_a_nikah/core/core.dart';
import 'package:find_a_nikah/features/face_verification/data/datasources/face_verification_remote_data_source.dart';
import 'package:find_a_nikah/features/face_verification/data/datasources/image_capture_data_source.dart';
import 'package:find_a_nikah/features/face_verification/data/datasources/selfie_face_detector.dart';
import 'package:find_a_nikah/features/face_verification/domain/entities/selfie_check_result.dart';
import 'package:find_a_nikah/features/face_verification/domain/repositories/face_verification_repository.dart';

class FaceVerificationRepositoryImpl implements FaceVerificationRepository {
  const FaceVerificationRepositoryImpl(
    this._capture,
    this._detector,
    this._remote,
    this._guard,
  );

  final ImageCaptureDataSource _capture;
  final SelfieFaceDetector _detector;
  final FaceVerificationRemoteDataSource _remote;
  final Guard _guard;

  @override
  Future<Either<Failure, String?>> captureSelfie() =>
      _guard(_capture.captureSelfie);

  @override
  Future<Either<Failure, String?>> pickProfilePhoto() =>
      _guard(_capture.pickFromGallery);

  @override
  Future<Either<Failure, SelfieCheckResult>> checkSelfie(String path) =>
      _guard(() => _detector.check(path));

  @override
  Future<Either<Failure, Unit>> submit({
    required String profilePhotoPath,
    required String selfiePath,
  }) => _guard(() async {
    await _remote.submit(File(profilePhotoPath), File(selfiePath));
    return unit;
  });
}
