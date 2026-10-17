import 'package:find_a_nikah/core/core.dart';
import 'package:find_a_nikah/features/onboarding/data/datasources/gallery_data_source.dart';
import 'package:find_a_nikah/features/onboarding/domain/repositories/photo_picker_repository.dart';

class PhotoPickerRepositoryImpl implements PhotoPickerRepository {
  const PhotoPickerRepositoryImpl(this._gallery, this._guard, this._compressor);

  final GalleryDataSource _gallery;
  final Guard _guard;
  final ImageCompressor _compressor;

  @override
  Future<Either<Failure, List<String>>> pickFromGallery({
    required int limit,
  }) => _guard(() => _gallery.pick(limit: limit));

  @override
  Future<Either<Failure, List<String>>> preparePhotos(List<String> paths) =>
      _guard(() async {
        // Unique per call (not just per index): a second pick must not
        // overwrite a still-displayed photo from an earlier one.
        final batch = DateTime.now().microsecondsSinceEpoch;
        final compressed = <String>[];
        for (var i = 0; i < paths.length; i++) {
          compressed.add(
            await _compressor.compress(
              paths[i],
              outputName: 'profile_${batch}_$i.jpg',
            ),
          );
        }
        return compressed;
      });

  // Before: pick + compress in one call, so the UI couldn't tell "gallery
  // open" from "processing the picked photos".
  // @override
  // Future<Either<Failure, List<String>>> pickFromGallery({
  //   required int limit,
  // }) => _guard(() async {
  //   final picked = await _gallery.pick(limit: limit);
  //   // Unique per call (not just per index): a second pick must not
  //   // overwrite a still-displayed photo from an earlier one.
  //   final batch = DateTime.now().microsecondsSinceEpoch;
  //   final compressed = <String>[];
  //   for (var i = 0; i < picked.length; i++) {
  //     compressed.add(
  //       await _compressor.compress(
  //         picked[i],
  //         outputName: 'profile_${batch}_$i.jpg',
  //       ),
  //     );
  //   }
  //   return compressed;
  // });
}
