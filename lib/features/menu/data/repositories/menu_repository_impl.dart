import 'dart:async';

import 'package:find_a_nikah/core/core.dart';
import 'package:find_a_nikah/core/database/database.dart';
import 'package:find_a_nikah/features/menu/data/datasources/dummy_menu_data_source.dart';
import 'package:find_a_nikah/features/menu/data/datasources/menu_remote_data_source.dart';
import 'package:find_a_nikah/features/menu/data/dtos/my_profile_response.dart';
import 'package:find_a_nikah/features/menu/data/dtos/profile_patch_body.dart';
import 'package:find_a_nikah/features/menu/domain/domain.dart';

/// Holds the signed-in member's profile for the session (session scope,
/// so it never outlives a sign-out) and keeps a copy on the device in
/// [JsonCache], which is cleared on sign-out.
///
/// Edits are shown at once: the screens get the edited profile before the
/// server answers, and the change is rolled back if the save fails.
class MenuRepositoryImpl implements MenuRepository {
  MenuRepositoryImpl(
    this._remote,
    this._dummy,
    this._guard, {
    required String imageBaseUrl,
    JsonCache? cache,
    // A private field can't be a named initializing formal.
    // ignore: prefer_initializing_formals
  }) : _cache = cache,
       _imageBaseUrl = imageBaseUrl.endsWith('/')
           ? imageBaseUrl.substring(0, imageBaseUrl.length - 1)
           : imageBaseUrl;

  /// [JsonCache] key of the saved `/v1/profiles/me` data.
  static const profileCacheKey = 'menu.profile.me';

  final MenuRemoteDataSource _remote;

  // Membership + settings: no API yet.
  final DummyMenuDataSource _dummy;
  final Guard _guard;
  final String _imageBaseUrl;

  /// Null in tests that don't need the device copy.
  final JsonCache? _cache;

  /// The last profile the server sent (or the device copy until then).
  MyProfile? _confirmed;

  /// Edits shown but not yet confirmed, oldest first.
  final _pending = <_PendingEdit>[];

  final _changes = StreamController<MyProfile>.broadcast();

  /// What screens should show: the confirmed profile with pending edits.
  MyProfile? get _shown {
    final base = _confirmed;
    if (base == null) return null;
    return _pending.fold<MyProfile>(base, (p, e) => e.patch.applyTo(p));
  }

  void _publish() {
    final shown = _shown;
    if (shown != null && !_changes.isClosed) _changes.add(shown);
  }

  @override
  Stream<MyProfile> get myProfileChanges => _changes.stream;

  @override
  Future<MyProfile?> cachedMyProfile() async {
    if (_shown case final shown?) return shown;
    final cache = _cache;
    if (cache == null) return null;
    final stored = await _guard(() async {
      final json = await cache.read(profileCacheKey);
      return json == null ? null : _toEntity(MyProfileDataDto.fromJson(json));
    });
    // A broken copy is reported by the guard and treated as "no copy". A
    // fetch may have finished during the read; it wins.
    _confirmed ??= stored.getOrElse((_) => null);
    return _shown;
  }

  // @override
  // Future<Either<Failure, MyProfile>> fetchMyProfile() => _guard(() async {
  //   final data = (await _remote.getMyProfile()).data;
  //   return _toEntity(data);
  // });
  @override
  Future<Either<Failure, MyProfile>> fetchMyProfile() async {
    final result = await _guard(
      () async => _confirm(
        (await _remote.getMyProfile()).data,
      ),
    );
    return result.map((_) => _shown!);
  }

  // Before: waited for the server, nothing shown until it answered.
  // @override
  // Future<Either<Failure, MyProfile>> updateMyProfile(ProfilePatch patch) =>
  //     _guard(() async {
  //       final body = profilePatchBody(patch, imagePath: _imagePath);
  //       final data = (await _remote.updateMyProfile(body)).data;
  //       return _toEntity(data);
  //     });
  @override
  Future<Either<Failure, MyProfile>> updateMyProfile(ProfilePatch patch) =>
      _optimistic(patch, () async {
        final body = profilePatchBody(patch, imagePath: _imagePath);
        return (await _remote.updateMyProfile(body)).data;
      });

  // @override
  // Future<Either<Failure, MyProfile>> deletePhoto(String photoUrl) =>
  //     _guard(() async {
  //       final segments = Uri.parse(photoUrl).pathSegments;
  //       if (segments.isEmpty || segments.last.isEmpty) {
  //         throw const DeviceException('no file name in photo url');
  //       }
  //       await _remote.deletePhoto(segments.last);
  //       return _toEntity((await _remote.getMyProfile()).data);
  //     });
  @override
  Future<Either<Failure, MyProfile>> deletePhoto(String photoUrl) {
    final photos = _shown?.photos ?? const <String>[];
    return _optimistic(
      ProfilePatch(photoOrder: [...photos.where((u) => u != photoUrl)]),
      () async {
        final segments = Uri.parse(photoUrl).pathSegments;
        if (segments.isEmpty || segments.last.isEmpty) {
          throw const DeviceException('no file name in photo url');
        }
        await _remote.deletePhoto(segments.last);
        return (await _remote.getMyProfile()).data;
      },
    );
  }

  /// Shows [shown] at once, runs [send], then shows the server's answer —
  /// or rolls [shown] back when [send] fails.
  Future<Either<Failure, MyProfile>> _optimistic(
    ProfilePatch shown,
    Future<MyProfileDataDto> Function() send,
  ) async {
    final edit = _PendingEdit(shown);
    _pending.add(edit);
    _publish();
    final result = await _guard(() async => _confirm(await send(), edit));
    if (result.isLeft()) {
      _pending.remove(edit);
      _publish();
    }
    return result.map((_) => _shown!);
  }

  /// Takes [data] as the server's truth (dropping [settled] from the
  /// pending edits), saves it on the device and announces it.
  Future<MyProfile> _confirm(
    MyProfileDataDto data, [
    _PendingEdit? settled,
  ]) async {
    _confirmed = _toEntity(data);
    _pending.remove(settled);
    _publish();
    // Saved only after a successful response; a failed write just means
    // the next launch shows the loading state once.
    if (_cache case final cache?) {
      await _guard(() => cache.write(profileCacheKey, data.toJson()));
    }
    return _confirmed!;
  }

  /// Ends the session's stream (session scope dispose).
  Future<void> dispose() => _changes.close();

  @override
  Future<Either<Failure, Membership>> fetchMembership() =>
      _guard(_dummy.fetchMembership);

  @override
  Future<Either<Failure, AppSettings>> fetchSettings() =>
      _guard(_dummy.fetchSettings);

  @override
  Future<Either<Failure, AppSettings>> saveSettings(AppSettings settings) =>
      _guard(() => _dummy.saveSettings(settings));

  /// First non-empty list, in priority order.
  List<String> _firstFilled(List<List<String>?> lists) => [
    ...lists.firstWhere((l) => l != null && l.isNotEmpty, orElse: () => null) ??
        const <String>[],
  ];

  MyProfile _toEntity(MyProfileDataDto data) {
    final user = data.user;
    final p = data.profile;
    final interests = p?.interests;
    final grewUpIn = _firstFilled([
      p?.grewUpIn,
      data.grewUpIn,
      p?.grewUpInAlt,
      data.grewUpInAlt,
    ]);
    return MyProfile(
      fullName: user?.fullName ?? '',
      email: user?.email,
      phone: user?.phone,
      photos: [...?p?.images.map(_imageUrl)],
      isVerified: p?.faceVerification?.isFaceVerified ?? false,
      completeness: (p?.completeness ?? 0).round().clamp(0, 100),
      dateOfBirth: DateTime.tryParse(p?.dateOfBirth ?? data.dateOfBirth ?? ''),
      gender: p?.gender,
      religion: p?.religion,
      currentLocation: p?.country,
      grewUpIn: grewUpIn.isEmpty ? null : grewUpIn.first,
      heightCm: (p?.heightCm ?? data.heightCm)?.round(),
      maritalStatus: p?.maritalStatus,
      hasChildren: p?.aboutYou?.haveChildren,
      bio: p?.aboutMe,
      gettingToKnow: p?.marriageIntentions?.getToknowDuration,
      marriageTimeline: p?.marriageIntentions?.marriageTimeline,
      relocateAbroad: p?.aboutYou?.relocateAbroad,
      bornMuslim: p?.aboutYou?.bornMuslim,
      religiousPractice: p == null || p.religiousPractices.isEmpty
          ? null
          : p.religiousPractices.first,
      faith: p?.faith ?? const [],
      halalFood: p?.lifestyle?.halalFood,
      alcohol: p?.lifestyle?.alcohol,
      smoking: p?.lifestyle?.smoking,
      // interests: [
      //   ...?interests?.cultural,
      //   ...?interests?.foodDrinks,
      //   ...?interests?.sports,
      //   ...?interests?.fashion,
      //   ...?interests?.activities,
      // ],
      // Kept per category so an edit can send every group back whole.
      interestGroups: {
        InterestCategory.cultural: [...?interests?.cultural],
        InterestCategory.foodDrinks: [...?interests?.foodDrinks],
        InterestCategory.sports: [...?interests?.sports],
        InterestCategory.fashion: [...?interests?.fashion],
        InterestCategory.activities: [...?interests?.activities],
      },
      personality: p?.personalityTraits ?? const [],
      education: p?.educationLevel,
      profession: p?.professionTitle,
      ethnicity: _firstFilled([
        p?.ethnicity,
        data.ethnicity,
        p?.ethnicityAlt,
        data.ethnicityAlt,
      ]),
      nationality: _firstFilled([
        p?.nationality,
        data.nationality,
        p?.nationalityAlt,
        data.nationalityAlt,
      ]),
      languages: p?.languages ?? const [],
    );
  }

  String _imageUrl(String path) {
    if (path.startsWith('http://') || path.startsWith('https://')) return path;
    return '$_imageBaseUrl${path.startsWith('/') ? '' : '/'}$path';
  }

  /// Reverse of [_imageUrl]: the relative path the API stores.
  String _imagePath(String url) =>
      url.startsWith(_imageBaseUrl) ? url.substring(_imageBaseUrl.length) : url;
}

/// One edit being saved. A wrapper so two equal patches stay separate.
class _PendingEdit {
  _PendingEdit(this.patch);
  final ProfilePatch patch;
}
