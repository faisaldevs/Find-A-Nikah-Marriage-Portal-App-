import 'package:find_a_nikah/core/core.dart';
import 'package:find_a_nikah/features/menu/data/datasources/dummy_menu_data_source.dart';
import 'package:find_a_nikah/features/menu/data/datasources/menu_remote_data_source.dart';
import 'package:find_a_nikah/features/menu/data/dtos/my_profile_response.dart';
import 'package:find_a_nikah/features/menu/domain/domain.dart';

class MenuRepositoryImpl implements MenuRepository {
  MenuRepositoryImpl(
    this._remote,
    this._dummy,
    this._guard, {
    required String imageBaseUrl,
  }) : _imageBaseUrl = imageBaseUrl.endsWith('/')
           ? imageBaseUrl.substring(0, imageBaseUrl.length - 1)
           : imageBaseUrl;

  final MenuRemoteDataSource _remote;

  // Membership + settings: no API yet.
  final DummyMenuDataSource _dummy;
  final Guard _guard;
  final String _imageBaseUrl;

  @override
  Future<Either<Failure, MyProfile>> fetchMyProfile() => _guard(() async {
    final data = (await _remote.getMyProfile()).data;
    return _toEntity(data.user, data.profile);
  });

  @override
  Future<Either<Failure, Membership>> fetchMembership() =>
      _guard(_dummy.fetchMembership);

  @override
  Future<Either<Failure, AppSettings>> fetchSettings() =>
      _guard(_dummy.fetchSettings);

  @override
  Future<Either<Failure, AppSettings>> saveSettings(AppSettings settings) =>
      _guard(() => _dummy.saveSettings(settings));

  MyProfile _toEntity(MyProfileUserDto? user, MyProfileDto? p) {
    final interests = p?.interests;
    return MyProfile(
      fullName: user?.fullName ?? '',
      email: user?.email,
      phone: user?.phone,
      photos: [...?p?.images.map(_imageUrl)],
      isVerified: p?.faceVerification?.isFaceVerified ?? false,
      completeness: (p?.completeness ?? 0).round().clamp(0, 100),
      dateOfBirth: p?.dateOfBirth == null
          ? null
          : DateTime.tryParse(p!.dateOfBirth!),
      gender: p?.gender,
      currentLocation: p?.country,
      grewUpIn: p == null || p.grewUpIn.isEmpty ? null : p.grewUpIn.first,
      heightCm: p?.heightCm?.round(),
      maritalStatus: p?.maritalStatus,
      hasChildren: p?.aboutYou?.haveChildren,
      bio: p?.aboutMe,
      gettingToKnow: p?.getToknowDuration,
      marriageTimeline: p?.marriageTimeline,
      relocateAbroad: p?.aboutYou?.relocateAbroad,
      bornMuslim: p?.aboutYou?.bornMuslim,
      religiousPractice: p == null || p.religiousPractices.isEmpty
          ? null
          : p.religiousPractices.first,
      faith: p?.faith ?? const [],
      halalFood: p?.lifestyle?.halalFood,
      alcohol: p?.lifestyle?.alcohol,
      smoking: p?.lifestyle?.smoking,
      interests: [
        ...?interests?.cultural,
        ...?interests?.foodDrinks,
        ...?interests?.sports,
        ...?interests?.fashion,
        ...?interests?.activities,
      ],
      personality: p?.personalityTraits ?? const [],
      education: p?.educationLevel,
      profession: p?.professionTitle,
      ethnicity: p?.ethnicity ?? const [],
      nationality: p?.nationality ?? const [],
      languages: p?.languages ?? const [],
    );
  }

  String _imageUrl(String path) {
    if (path.startsWith('http://') || path.startsWith('https://')) return path;
    return '$_imageBaseUrl${path.startsWith('/') ? '' : '/'}$path';
  }
}
