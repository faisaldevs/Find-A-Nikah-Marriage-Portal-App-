import 'package:find_a_nikah/features/menu/domain/entities/app_settings.dart';
import 'package:find_a_nikah/features/menu/domain/entities/membership.dart';

/// Membership + settings until their APIs exist. Settings changes live in
/// memory for the app session.
class DummyMenuDataSource {
  DummyMenuDataSource();

  static const _latency = Duration(milliseconds: 250);

  AppSettings _settings = const AppSettings();

  Future<Membership> fetchMembership() async {
    await Future<void>.delayed(_latency);
    return const Membership(
      planName: 'Basic plan',
      planDescription: 'Limited profiles, chats and filters.',
      likes: 20,
      compliments: 1,
      likesInFilters: 12,
      monthlyPrice: r'$10',
    );
  }

  Future<AppSettings> fetchSettings() async {
    await Future<void>.delayed(_latency);
    return _settings;
  }

  Future<AppSettings> saveSettings(AppSettings settings) async {
    await Future<void>.delayed(_latency);
    return _settings = settings;
  }
}
