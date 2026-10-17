import 'package:find_a_nikah/core/core.dart';

/// Picks profile photos from the device gallery.
abstract interface class PhotoPickerRepository {
  /// Multi-select, at most [limit]. Right(empty) when the user cancels.
  /// Returns the picked files as-is — run [preparePhotos] on them before
  /// adding them to the draft.
  Future<Either<Failure, List<String>>> pickFromGallery({required int limit});

  /// Compresses picked files (long edge capped, EXIF stripped) into new
  /// temp files and returns their paths, in order. The slow part — split
  /// from [pickFromGallery] so the UI can show progress only once the
  /// gallery has closed.
  Future<Either<Failure, List<String>>> preparePhotos(List<String> paths);
}
