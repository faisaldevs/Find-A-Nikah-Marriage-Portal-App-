import 'package:find_a_nikah/core/core.dart';
import 'package:find_a_nikah/features/onboarding/data/datasources/onboarding_remote_data_source.dart';
import 'package:find_a_nikah/features/onboarding/data/repositories/onboarding_option_tokens.dart';
import 'package:find_a_nikah/features/onboarding/domain/entities/onboarding_data.dart';
import 'package:find_a_nikah/features/onboarding/domain/repositories/onboarding_profile_repository.dart';

class OnboardingProfileRepositoryImpl implements OnboardingProfileRepository {
  OnboardingProfileRepositoryImpl(this._remote, this._guard);

  final OnboardingRemoteDataSource _remote;
  final Guard _guard;

  @override
  Future<Either<Failure, OnboardingData?>> fetchSubmittedDraft() =>
      _guard(() async {
        final data = (await _remote.getProfile()).data;
        final profile = data.profile;
        final step = data.currentStep;
        // Step 4 (Basics) not submitted yet — nothing to prefill.
        if (profile == null || step <= 4) return null;

        var draft = OnboardingData(
          accountType: profile.accountType,
          fullName: data.user?.fullName,
          gender: profile.gender,
          religion: profile.religion,
          dateOfBirth: _parseDate(profile.dateOfBirth),
          languages: profile.languages,
          nationalities: profile.nationality.map(_countryCode).toList(),
          grewUpCountry: profile.grewUpIn.isEmpty
              ? null
              : _countryCode(profile.grewUpIn.first),
          ethnicities: profile.ethnicity.map(_countryCode).toList(),
          heightCm: profile.heightCm,
        );

        if (step > 5) {
          draft = draft.copyWith(
            educationLevel: profile.educationLevel,
            profession: profile.professionTitle,
            maritalStatus: profile.maritalStatus,
            knowSomeoneDuration: _unhyphenateRange(profile.getToknowDuration),
            marriedWithinDuration: _unhyphenateRange(profile.marriageTimeline),
            faithTags: profile.faith
                .map((token) => faithTagDisplayNames[token] ?? token)
                .toList(),
            religionPracticeLevel: profile.religiousPractices.isEmpty
                ? null
                : profile.religiousPractices.first,
          );
        }

        if (step > 6) {
          final interests = profile.interests;
          draft = draft.copyWith(
            eatsHalalOnly: profile.lifestyle?.halalFood,
            smokes: profile.lifestyle?.smoking,
            drinksAlcohol: profile.lifestyle?.alcohol,
            bornMuslim: profile.aboutYou?.bornMuslim,
            hasChildren: profile.aboutYou?.haveChildren,
            wouldRelocate: profile.aboutYou?.relocateAbroad,
            personalityTraits: profile.personalityTraits,
            interests: [
              ...?interests?.cultural,
              ...?interests?.foodDrinks,
              ...?interests?.sports,
              ...?interests?.fashion,
              ...?interests?.activities,
            ],
          );
        }

        if (step > 7) {
          draft = draft.copyWith(bio: profile.aboutMe);
        }

        return draft;
      });

  /// Reverse of the submission repository's `_countryName` — full country
  /// name → ISO code. Falls back to the raw name if it's not in the list
  /// (e.g. one of the ~135 countries outside `allCountries`'s ~60).
  String _countryCode(String name) {
    for (final country in [...allCountries, ...suggestedCountries]) {
      if (country.name == name) return country.code;
    }
    return name;
  }

  DateTime? _parseDate(String? iso) =>
      iso == null ? null : DateTime.tryParse(iso);

  /// Reverse of the submission repository's `_hyphenateRange`:
  /// `1-2_months` → `1_2_months`.
  static final _rangePattern = RegExp(r'^(\d+)-(\d+)_(.+)$');

  String? _unhyphenateRange(String? value) {
    if (value == null) return null;
    final match = _rangePattern.firstMatch(value);
    if (match == null) return value;
    return '${match[1]}_${match[2]}_${match[3]}';
  }
}
