import 'package:find_a_nikah/core/core.dart';
import 'package:image_picker/image_picker.dart';

/// System camera / gallery. Returns a local file path, or null when the
/// user cancels. Throws [DeviceException] when the picker fails (e.g.
/// camera permission permanently denied).
class ImageCaptureDataSource {
  const ImageCaptureDataSource(this._picker);

  final ImagePicker _picker;

  // TODO(liveness): swap for a live `camera` stream + ML Kit challenge
  // (blink / turn head) once the backend verification vendor is chosen.
  // A single still from the system camera is the minimum viable capture.
  Future<String?> captureSelfie() => _pick(
    () => _picker.pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.front,
      imageQuality: 90,
    ),
  );

  Future<String?> pickFromGallery() => _pick(
    () => _picker.pickImage(source: ImageSource.gallery, imageQuality: 85),
  );

  Future<String?> _pick(Future<XFile?> Function() pick) async {
    try {
      return (await pick())?.path;
    } on Object catch (e) {
      throw DeviceException('image picker: ${e.runtimeType}');
    }
  }
}
