import 'package:find_a_nikah/core/core.dart';
import 'package:find_a_nikah/features/onboarding/data/datasources/gallery_data_source.dart';
import 'package:find_a_nikah/features/onboarding/domain/repositories/photo_picker_repository.dart';

class PhotoPickerRepositoryImpl implements PhotoPickerRepository {
  const PhotoPickerRepositoryImpl(this._gallery, this._guard);

  final GalleryDataSource _gallery;
  final Guard _guard;

  @override
  Future<Either<Failure, List<String>>> pickFromGallery({
    required int limit,
  }) => _guard(() => _gallery.pick(limit: limit));
}
