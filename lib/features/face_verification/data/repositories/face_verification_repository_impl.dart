import 'dart:io';

import 'package:dio/dio.dart';
import 'package:find_a_nikah/core/core.dart';
import 'package:find_a_nikah/features/face_verification/data/datasources/face_verification_remote_data_source.dart';
import 'package:find_a_nikah/features/face_verification/data/datasources/image_capture_data_source.dart';
import 'package:find_a_nikah/features/face_verification/data/datasources/selfie_face_detector.dart';
import 'package:find_a_nikah/features/face_verification/data/mappers/face_verification_response_mapper.dart';
import 'package:find_a_nikah/features/face_verification/domain/entities/camera_permission_status.dart';
import 'package:find_a_nikah/features/face_verification/domain/entities/face_session.dart';
import 'package:find_a_nikah/features/face_verification/domain/entities/face_snapshot.dart';
import 'package:find_a_nikah/features/face_verification/domain/entities/face_verification_result.dart';
import 'package:find_a_nikah/features/face_verification/domain/entities/liveness_pose.dart';
import 'package:find_a_nikah/features/face_verification/domain/entities/selfie_check_result.dart';
import 'package:find_a_nikah/features/face_verification/domain/repositories/face_verification_repository.dart';
import 'package:permission_handler/permission_handler.dart';

class FaceVerificationRepositoryImpl implements FaceVerificationRepository {
  const FaceVerificationRepositoryImpl(
    this._capture,
    this._detector,
    this._remote,
    this._guard,
    this._compressor, [
    this._mapper = const FaceVerificationResponseMapper(),
  ]);

  final ImageCaptureDataSource _capture;
  final SelfieFaceDetector _detector;
  final FaceVerificationRemoteDataSource _remote;
  final Guard _guard;
  final ImageCompressor _compressor;
  final FaceVerificationResponseMapper _mapper;

  /// Face verification is slow server-side (3 photos through detection +
  /// matching) — the app-wide 20s receive timeout cut it off.
  static const _verifyTimeout = Duration(seconds: 90);

  @override
  Future<Either<Failure, String?>> captureSelfie() =>
      _guard(_capture.captureSelfie);

  @override
  Future<Either<Failure, String?>> pickProfilePhoto() =>
      _guard(_capture.pickFromGallery);

  @override
  Future<Either<Failure, SelfieCheckResult>> checkSelfie(
    String path, {
    LivenessPose expectedPose = LivenessPose.front,
  }) => _guard(() => _detector.check(path, expectedPose: expectedPose));

  @override
  Future<Either<Failure, FaceSnapshot>> analyzeStill(String path) =>
      _guard(() => _detector.analyze(path));

  @override
  Future<Either<Failure, CameraPermissionStatus>> requestCameraPermission() =>
      _guard(() async {
        final status = await Permission.camera.request();
        if (status.isGranted) return CameraPermissionStatus.granted;
        if (status.isPermanentlyDenied) {
          return CameraPermissionStatus.permanentlyDenied;
        }
        return CameraPermissionStatus.denied;
      });

  @override
  Future<Either<Failure, Unit>> submit({
    required String profilePhotoPath,
    required String selfiePath,
  }) => _guard(() async {
    await _remote.submit(File(profilePhotoPath), File(selfiePath));
    return unit;
  });

  @override
  Future<Either<Failure, FaceSession>> startLivenessSession() => _guard(
    () async => _mapper.mapSession((await _remote.startFaceSession()).response),
  );

  @override
  Future<Either<Failure, FaceVerificationResult>> submitLivenessSteps({
    required FaceSession session,
    required Map<String, String> stepFilePaths,
  }) => _guard(() async {
    final form = FormData();
    final sessionId = session.sessionId;
    if (sessionId != null) form.fields.add(MapEntry('sessionId', sessionId));
    for (final (i, step) in session.plan.steps.indexed) {
      final path = stepFilePaths[step.fieldName];
      if (path == null) {
        throw DeviceException('missing still for ${step.fieldName}');
      }
      final compressed = await _compressor.compress(
        path,
        outputName: '${step.fieldName}.jpg',
      );
      // Confirmed contract: `sessionId` + `step1`..`step3`, one per
      // `/start` challenge in order (challenge-named fields were rejected
      // with 400 "Unexpected file field").
      form.files.add(
        MapEntry(
          // step.fieldName,
          'step${i + 1}',
          await MultipartFile.fromFile(
            compressed,
            filename: '${step.fieldName}.jpg',
          ),
        ),
      );
    }
    final response = await _remote.verifyFace(
      form,
      options: Options(
        sendTimeout: _verifyTimeout,
        receiveTimeout: _verifyTimeout,
        // A rejected face (e.g. 422 "no face detected") is a verdict, not
        // an error — let it reach the mapper. 401/403/429/5xx still throw
        // (token refresh, rate limiting, server errors).
        validateStatus: (s) =>
            s != null && s < 500 && s != 401 && s != 403 && s != 429,
      ),
    );
    return _mapper.mapResult(response.response);
  });
}
