import 'package:find_a_nikah/core/core.dart';
import 'package:find_a_nikah/features/face_verification/domain/entities/selfie_check_result.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

/// On-device quality gate for the verification selfie, powered by Google
/// ML Kit face detection (runs fully offline, no model downloads).
///
/// Throws [DeviceException] when ML Kit fails on the image.
class SelfieFaceDetector {
  SelfieFaceDetector()
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
    final List<Face> faces;
    try {
      faces = await _detector.processImage(InputImage.fromFilePath(imagePath));
    } on Object catch (e) {
      throw DeviceException('face detection: ${e.runtimeType}');
    }
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

  Future<void> dispose() => _detector.close();
}
