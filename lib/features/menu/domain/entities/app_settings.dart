import 'package:equatable/equatable.dart';

/// The member's switchable preferences (Settings + Edit profile).
class AppSettings extends Equatable {
  const AppSettings({
    this.language = 'English',
    this.notifications = true,
    this.chatMessagePreview = false,
    this.profileSharingLink = false,
    this.blockSocialRequestsFromWomen = true,
    this.showGoldBadge = false,
  });

  final String language;
  final bool notifications;
  final bool chatMessagePreview;
  final bool profileSharingLink;
  final bool blockSocialRequestsFromWomen;
  final bool showGoldBadge;

  AppSettings copyWith({
    String? language,
    bool? notifications,
    bool? chatMessagePreview,
    bool? profileSharingLink,
    bool? blockSocialRequestsFromWomen,
    bool? showGoldBadge,
  }) {
    return AppSettings(
      language: language ?? this.language,
      notifications: notifications ?? this.notifications,
      chatMessagePreview: chatMessagePreview ?? this.chatMessagePreview,
      profileSharingLink: profileSharingLink ?? this.profileSharingLink,
      blockSocialRequestsFromWomen:
          blockSocialRequestsFromWomen ?? this.blockSocialRequestsFromWomen,
      showGoldBadge: showGoldBadge ?? this.showGoldBadge,
    );
  }

  @override
  List<Object?> get props => [
    language,
    notifications,
    chatMessagePreview,
    profileSharingLink,
    blockSocialRequestsFromWomen,
    showGoldBadge,
  ];
}
