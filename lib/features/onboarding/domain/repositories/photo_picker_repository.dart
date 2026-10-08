import 'package:find_a_nikah/core/core.dart';

/// Picks profile photos from the device gallery.
abstract interface class PhotoPickerRepository {
  /// Multi-select, at most [limit]. Right(empty) when the user cancels.
  Future<Either<Failure, List<String>>> pickFromGallery({required int limit});
}
