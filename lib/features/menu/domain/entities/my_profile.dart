import 'package:freezed_annotation/freezed_annotation.dart';

part 'my_profile.freezed.dart';

/// The signed-in member's own profile, as shown on the Menu tab, Settings
/// and Edit profile. Raw values (backend tokens, booleans); formatting for
/// display happens in the presentation layer.
@freezed
abstract class MyProfile with _$MyProfile {
  const factory MyProfile({
    @Default('') String fullName,

    /// Full image URLs, first = main photo.
    @Default(<String>[]) List<String> photos,
    @Default(false) bool isVerified,

    /// 0–100.
    @Default(0) int completeness,
    String? email,
    String? phone,
    DateTime? dateOfBirth,
    String? gender,
    String? currentLocation,
    String? grewUpIn,
    int? heightCm,
    String? maritalStatus,
    bool? hasChildren,
    String? bio,
    String? gettingToKnow,
    String? marriageTimeline,
    bool? relocateAbroad,
    bool? bornMuslim,
    String? religiousPractice,
    @Default(<String>[]) List<String> faith,
    bool? halalFood,
    bool? alcohol,
    bool? smoking,
    @Default(<String>[]) List<String> interests,
    @Default(<String>[]) List<String> personality,
    String? education,
    String? profession,
    @Default(<String>[]) List<String> ethnicity,
    @Default(<String>[]) List<String> nationality,
    @Default(<String>[]) List<String> languages,
  }) = _MyProfile;

  const MyProfile._();

  String? get mainPhoto => photos.isEmpty ? null : photos.first;

  String get firstName => fullName.trim().split(RegExp(r'\s+')).first;
}
