import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

/// Outcome of the on-device selfie gate. Only [ok] proceeds to submission.
enum SelfieCheckResult { ok, noFace, multipleFaces, notFrontal, eyesClosed }

extension SelfieCheckResultMessage on SelfieCheckResult {
  String get message => switch (this) {
    SelfieCheckResult.ok => '',
    SelfieCheckResult.noFace =>
      "We couldn't find a face. Make sure you're in good lighting and "
          'your face fills the frame.',
    SelfieCheckResult.multipleFaces =>
      'Only you should be in the photo. Please retake it alone.',
    SelfieCheckResult.notFrontal =>
      'Please look straight at the camera and try again.',
    SelfieCheckResult.eyesClosed =>
      'Keep your eyes open and look at the camera.',
  };
}

/// On-device quality gate for the verification selfie, powered by Google
/// ML Kit face detection (runs fully offline, no model downloads).
///
/// This is deliberately *not* identity matching. Comparing the selfie to
/// the profile photo has to happen server-side (e.g. AWS Rekognition
/// `CompareFaces`) — a client-side match result can be faked, so the app
/// only guarantees "a single, frontal, eyes-open face" before uploading.
class SelfieFaceChecker {
  SelfieFaceChecker()
    : _detector = FaceDetector(
        options: FaceDetectorOptions(
          performanceMode: FaceDetectorMode.accurate,
          enableClassification: true, // eye-open / smiling probabilities
          minFaceSize: 0.2, // face must span ≥20% of the frame
        ),
      );

  final FaceDetector _detector;

  static const _maxYawDegrees = 25.0;
  static const _maxPitchDegrees = 20.0;
  static const _minEyeOpenProbability = 0.3;

  Future<SelfieCheckResult> check(String imagePath) async {
    final faces = await _detector.processImage(
      InputImage.fromFilePath(imagePath),
    );
    if (faces.isEmpty) return SelfieCheckResult.noFace;
    if (faces.length > 1) return SelfieCheckResult.multipleFaces;

    final face = faces.single;
    final yaw = face.headEulerAngleY?.abs() ?? 0;
    final pitch = face.headEulerAngleX?.abs() ?? 0;
    if (yaw > _maxYawDegrees || pitch > _maxPitchDegrees) {
      return SelfieCheckResult.notFrontal;
    }

    final left = face.leftEyeOpenProbability;
    final right = face.rightEyeOpenProbability;
    // Probabilities are null when classification couldn't run (rare) — don't
    // block the user on a signal we don't have.
    if (left != null &&
        right != null &&
        left < _minEyeOpenProbability &&
        right < _minEyeOpenProbability) {
      return SelfieCheckResult.eyesClosed;
    }
    return SelfieCheckResult.ok;
  }

  void dispose() => _detector.close();
}

final selfieFaceCheckerProvider = Provider<SelfieFaceChecker>((ref) {
  final checker = SelfieFaceChecker();
  ref.onDispose(checker.dispose);
  return checker;
});
