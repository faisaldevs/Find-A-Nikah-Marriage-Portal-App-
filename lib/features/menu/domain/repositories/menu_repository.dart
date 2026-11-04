import 'package:find_a_nikah/core/core.dart';
import 'package:find_a_nikah/features/menu/domain/entities/app_settings.dart';
import 'package:find_a_nikah/features/menu/domain/entities/membership.dart';
import 'package:find_a_nikah/features/menu/domain/entities/my_profile.dart';
import 'package:find_a_nikah/features/menu/domain/entities/profile_patch.dart';

/// The signed-in member's own profile, plan and preferences.
///
/// The profile is cached: screens show [cachedMyProfile] at once, follow
/// [myProfileChanges], and call [fetchMyProfile] to refresh quietly.
abstract interface class MenuRepository {
  /// The latest profile this session, else the copy saved on the device;
  /// null when there's neither. Never calls the API.
  Future<MyProfile?> cachedMyProfile();

  /// Every new profile value: fresh loads, edits (shown before the server
  /// answers) and rollbacks of edits that failed.
  Stream<MyProfile> get myProfileChanges;

  /// Loads the profile from the API, saves it on the device and announces
  /// it on [myProfileChanges].
  Future<Either<Failure, MyProfile>> fetchMyProfile();

  /// Shows [patch] at once (on [myProfileChanges]), then saves it. On
  /// failure the change is rolled back and the failure returned.
  Future<Either<Failure, MyProfile>> updateMyProfile(ProfilePatch patch);

  /// Removes one uploaded photo (by its URL), shown at once like
  /// [updateMyProfile], and returns the updated profile.
  Future<Either<Failure, MyProfile>> deletePhoto(String photoUrl);

  Future<Either<Failure, Membership>> fetchMembership();

  Future<Either<Failure, AppSettings>> fetchSettings();

  Future<Either<Failure, AppSettings>> saveSettings(AppSettings settings);
}
