import 'package:freezed_annotation/freezed_annotation.dart';

part 'onboarding_data.freezed.dart';

/// Everything the profile wizard collects (account type through bio) plus
/// the photos picked on "Add your photos". The phone number belongs to
/// account verification (`features/auth`), not to the profile draft.
@freezed
abstract class OnboardingData with _$OnboardingData {
  const factory OnboardingData({
    String? accountType,

    /// Set only on the family flow: `son`/`daughter`/`brother`/`sister`/
    /// `other_family_member` — who the profile is being created for.
    String? relationship,
    String? fullName,
    DateTime? dateOfBirth,
    String? gender,
    String? religion,
    @Default(<String>[]) List<String> languages,
    String? lookingForIntent,
    String? howHeard,
    @Default(<String>[]) List<String> nationalities,
    String? grewUpCountry,
    @Default(<String>[]) List<String> ethnicities,
    int? heightCm,
    String? educationLevel,
    String? profession,
    String? maritalStatus,
    String? knowSomeoneDuration,
    String? marriedWithinDuration,
    @Default(<String>[]) List<String> faithTags,
    String? religionPracticeLevel,
    bool? eatsHalalOnly,
    bool? smokes,
    bool? drinksAlcohol,
    bool? bornMuslim,
    bool? hasChildren,
    bool? wouldRelocate,
    @Default(<String>[]) List<String> personalityTraits,
    @Default(<String>[]) List<String> interests,
    String? bio,

    /// Local file paths; the first is the main photo used by face
    /// verification.
    @Default(<String>[]) List<String> photoPaths,
  }) = _OnboardingData;

  const OnboardingData._();

  /// Profiles need at least this many photos to continue.
  static const minPhotos = 3;

  /// Photo slots on "Add your photos".
  static const maxPhotos = 5;

  int get remainingPhotoSlots => maxPhotos - photoPaths.length;

  bool get hasEnoughPhotos => photoPaths.length >= minPhotos;

  /// Appends [paths] up to [maxPhotos] (older Android galleries can ignore
  /// the picker's limit).
  OnboardingData withPhotosAdded(List<String> paths) => copyWith(
    photoPaths: [...photoPaths, ...paths.take(remainingPhotoSlots)],
  );

  OnboardingData withPhotoRemoved(int index) =>
      copyWith(photoPaths: [...photoPaths]..removeAt(index));

  /// The photo face verification compares the selfie against.
  String? get mainPhotoPath => photoPaths.isEmpty ? null : photoPaths.first;

  /// Whole years since [dateOfBirth], null until it's set.
  int? get age {
    final dob = dateOfBirth;
    if (dob == null) return null;
    final now = DateTime.now();
    var years = now.year - dob.year;
    if (now.month < dob.month ||
        (now.month == dob.month && now.day < dob.day)) {
      years--;
    }
    return years;
  }

  static const minAge = 18;

  bool get isEligibleAge => (age ?? 0) >= minAge;
}
