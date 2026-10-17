import 'package:find_a_nikah/core/core.dart';
import 'package:find_a_nikah/features/menu/domain/entities/app_settings.dart';
import 'package:find_a_nikah/features/menu/domain/entities/membership.dart';
import 'package:find_a_nikah/features/menu/domain/entities/my_profile.dart';

/// The signed-in member's own profile, plan and preferences.
abstract interface class MenuRepository {
  Future<Either<Failure, MyProfile>> fetchMyProfile();

  Future<Either<Failure, Membership>> fetchMembership();

  Future<Either<Failure, AppSettings>> fetchSettings();

  Future<Either<Failure, AppSettings>> saveSettings(AppSettings settings);
}
