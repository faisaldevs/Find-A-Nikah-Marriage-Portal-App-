import 'package:find_a_nikah/core/core.dart';
import 'package:image_picker/image_picker.dart';

/// Device gallery via `image_picker`. Throws [DeviceException] when the
/// picker fails.
class GalleryDataSource {
  const GalleryDataSource(this._picker);

  final ImagePicker _picker;

  Future<List<String>> pick({required int limit}) async {
    if (limit <= 0) return const [];
    try {
      if (limit == 1) {
        // pickMultiImage asserts limit >= 2.
        final one = await _picker.pickImage(source: ImageSource.gallery);
        return one == null ? const [] : [one.path];
      }
      final picked = await _picker.pickMultiImage(limit: limit);
      return [for (final f in picked) f.path];
    } on Object catch (e) {
      throw DeviceException('gallery: ${e.runtimeType}');
    }
  }
}
