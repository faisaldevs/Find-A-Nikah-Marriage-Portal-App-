// import 'package:find_a_nikah/core/constants/countries.dart';
import 'package:find_a_nikah/core/utils/profile_mapping.dart';
import 'package:find_a_nikah/features/marriage/data/dtos/profile_card_dto.dart';
import 'package:find_a_nikah/features/marriage/domain/entities/marriage_profile.dart';

/// Card (+ optional full profile as a fallback for older servers whose
/// cards lack the detail fields) → [MarriageProfile]. Raw backend codes
/// become display text here so the widgets never see `never_married`.
/// Anything the API doesn't send yet comes out as '' / [] / null and the
/// UI hides it.
extension ProfileCardMapper on ProfileCardDto {
  MarriageProfile toEntity({
    required String imageBaseUrl,
    ProfileDetailDto? detail,
    DateTime? now,
  }) {
    final photos = [
      ?primaryPhoto,
      ...images.where((p) => p != primaryPhoto),
    ].map((p) => resolveImageUrl(imageBaseUrl, p)).toList();
    final countryName = country?.trim() ?? '';
    final ethnicityName = ethnicity.isEmpty ? '' : ethnicity.first;
    final grewUp = grewUpIn.isNotEmpty
        ? grewUpIn
        : detail?.grewUpIn ?? const <String>[];
    final grewUpName = grewUp.isEmpty ? '' : grewUp.first;
    final intentions = marriageIntentions ?? detail?.marriageIntentions;
    final about = aboutYou ?? detail?.aboutYou;
    final practices = religiousPractices.isNotEmpty
        ? religiousPractices
        : detail?.religiousPractices ?? const <String>[];
    final languageList = languages.isNotEmpty
        ? languages
        : detail?.languages ?? const <String>[];
    final traits = personalityTraits.isNotEmpty
        ? personalityTraits
        : detail?.personalityTraits ?? const <String>[];
    final relocate = about?.relocateAbroad;
    return MarriageProfile(
      id: userId,
      name: fullName,
      age: age ?? 0,
      distanceKm: distanceKm,
      area: city?.trim() ?? '',
      country: countryName,
      countryFlag: flagForCountryName(countryName),
      profession: professionTitle?.trim() ?? '',
      practice: practices.isEmpty ? '' : labelFromCode(practices.first),
      ethnicity: ethnicityName,
      ethnicityFlag: flagForCountryName(ethnicityName),
      photoUrls: List.unmodifiable(photos),
      isVerified: isVerified,
      isActiveToday: isActiveWithinADay(lastActiveAt, now ?? DateTime.now()),
      similarities: List.unmodifiable(sharedInterests),
      heightCm: heightCm,
      maritalStatus: labelFromCode(maritalStatus),
      children: switch (about?.haveChildren) {
        true => 'Has children',
        false => "Doesn't have children",
        null => '',
      },
      involveFamily: labelFromCode(intentions?.involveFamily),
      chatFor: labelFromCode(intentions?.getToknowDuration),
      marryWithin: labelFromCode(intentions?.marriageTimeline),
      faith: List.unmodifiable(faith.map(labelFromCode)),
      futurePlans: List.unmodifiable([
        ?switch (relocate) {
          true => 'Open to relocate globally',
          false => 'Not open to relocate',
          null => null,
        },
      ]),
      interests: List.unmodifiable(allInterests),
      personality: List.unmodifiable(traits),
      education: labelFromCode(educationLevel),
      languages: List.unmodifiable(languageList),
      grewUpIn: grewUpName,
      grewUpFlag: flagForCountryName(grewUpName),
      bio: aboutMe?.trim() ?? '',
      isPhotoVerified:
          isFaceVerified ||
          (faceVerification ?? detail?.faceVerification)?.isFaceVerified ==
              true,
      isAgeVerified: isAgeVerified,
      isIdVerified: isIdVerified,
      isPremium: isPremium,
    );
  }
}

// Moved to core/utils/profile_mapping.dart (shared with Explore):
// /// `never_married` → `Never married`, `3-4_months` → `3-4 months`.
// String _label(String? raw) {
//   final v = raw?.trim() ?? '';
//   if (v.isEmpty) return '';
//   final words = v.replaceAll('_', ' ');
//   return words[0].toUpperCase() + words.substring(1);
// }
//
// /// Countries come as names ("Bangladesh"); '' when not in our list.
// String _flagFor(String countryName) {
//   if (countryName.isEmpty) return '';
//   final key = countryName.toLowerCase();
//   for (final c in allCountries) {
//     if (c.name.toLowerCase() == key) return c.flag;
//   }
//   return '';
// }
//
// String _imageUrl(String base, String path) {
//   if (path.startsWith('http')) return path;
//   final b = base.endsWith('/') ? base.substring(0, base.length - 1) : base;
//   return '$b${path.startsWith('/') ? '' : '/'}$path';
// }
//
// bool _activeWithinADay(String? iso, DateTime now) {
//   final at = iso == null ? null : DateTime.tryParse(iso);
//   return at != null && now.difference(at).inHours < 24;
// }
