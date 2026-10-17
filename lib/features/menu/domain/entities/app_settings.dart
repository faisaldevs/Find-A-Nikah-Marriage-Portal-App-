import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_settings.freezed.dart';

/// The member's switchable preferences (Settings + Edit profile).
@freezed
abstract class AppSettings with _$AppSettings {
  const factory AppSettings({
    @Default('English') String language,
    @Default(true) bool notifications,
    @Default(false) bool chatMessagePreview,
    @Default(false) bool profileSharingLink,
    @Default(true) bool blockSocialRequestsFromWomen,
    @Default(false) bool showGoldBadge,
  }) = _AppSettings;
}
