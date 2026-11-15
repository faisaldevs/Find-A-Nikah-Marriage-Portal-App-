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
    void Function()? onDeckReset,
    // A private field can't be a named initializing formal.
    // ignore: prefer_initializing_formals
  }) : _cache = cache,
       _onDeckReset = onDeckReset,
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

  /// Restarts the Marriage deck after "Start again" (wired in `di.dart`).
  final void Function()? _onDeckReset;

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

  // Plan name and the three counters come from `/v1/subscriptions/me`. The
  // description and the price line are still placeholders (the plan list
  // and purchases are not built — see remaining/menu_settings.md SET-02).
  @override
  Future<Either<Failure, Membership>> fetchMembership() => _guard(() async {
    final base = await _dummy.fetchMembership();
    final body = (await _remote.getSubscription()).data;
    final data = body is Map ? body['data'] : null;
    if (data is! Map) return base;
    final sub = data['subscription'];
    final plan = sub is Map ? sub['planId'] : null;
    final planName = plan is Map ? plan['name'] as String? : null;
    final endsAt = sub is Map ? DateTime.tryParse('${sub['endsAt']}') : null;
    int count(String key, int fallback) =>
        (data[key] as num?)?.toInt() ?? fallback;
    return base.copyWith(
      planName: planName ?? 'Basic plan',
      planDescription: planName == null
          ? base.planDescription
          : endsAt == null
          ? 'Your plan is active.'
          : 'Active until ${_dayMonthYear(endsAt.toLocal())}.',
      likes: count('likesRemainingToday', base.likes),
      compliments: count('complimentsRemaining', base.compliments),
      likesInFilters: count('likesInYourFiltersCount', base.likesInFilters),
    );
  });

  static String _dayMonthYear(DateTime d) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${d.day} ${months[d.month - 1]} ${d.year}';
  }
  // Was: _guard(_dummy.fetchMembership).

  // Settings: the two switches the server knows (`notifications` →
  // `messageNotifications`, `chatMessagePreview` → `messagePreview`) are
  // saved on `/v1/me/settings`; the rest (language, sharing link, chat
  // requests, gold badge) still live in memory for the session — see
  // resources/docs/remaining/menu_settings.md.
  @override
  Future<Either<Failure, AppSettings>> fetchSettings() => _guard(() async {
    final local = await _dummy.fetchSettings();
    final body = (await _remote.getMySettings()).data;
    final server = body is Map ? body['data'] : null;
    if (server is! Map) return local;
    return _dummy.saveSettings(
      local.copyWith(
        notifications: server['messageNotifications'] as bool?,
        chatMessagePreview: server['messagePreview'] as bool?,
      ),
    );
  });

  @override
  Future<Either<Failure, AppSettings>> saveSettings(AppSettings settings) =>
      _guard(() async {
        final before = await _dummy.fetchSettings();
        final changed = <String, dynamic>{
          if (settings.notifications != before.notifications)
            'messageNotifications': settings.notifications,
          if (settings.chatMessagePreview != before.chatMessagePreview)
            'messagePreview': settings.chatMessagePreview,
        };
        if (changed.isNotEmpty) await _remote.updateMySettings(changed);
        return _dummy.saveSettings(settings);
      });
  // Was: _guard(_dummy.fetchSettings) / _guard(() => _dummy.saveSettings(s)).

  @override
  Future<Either<Failure, int>> startAgain() => _guard(() async {
    final body = (await _remote.resetDeck()).data;
    final data = body is Map ? body['data'] : null;
    final cleared = data is Map
        ? (data['passesCleared'] as num?)?.toInt()
        : null;
    _onDeckReset?.call();
    return cleared ?? 0;
  });

  @override
  Future<Either<Failure, Unit>> deleteAccount() => _guard(() async {
    await _remote.deleteAccount();
    return unit;
  });

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
