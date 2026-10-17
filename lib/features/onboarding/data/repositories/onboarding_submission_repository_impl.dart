import 'package:dio/dio.dart';
import 'package:find_a_nikah/core/core.dart';
import 'package:find_a_nikah/features/onboarding/data/datasources/onboarding_remote_data_source.dart';
import 'package:find_a_nikah/features/onboarding/data/dtos/onboarding_step_request.dart';
import 'package:find_a_nikah/features/onboarding/data/repositories/onboarding_option_tokens.dart';
import 'package:find_a_nikah/features/onboarding/domain/entities/onboarding_data.dart';
import 'package:find_a_nikah/features/onboarding/domain/repositories/onboarding_submission_repository.dart';

class OnboardingSubmissionRepositoryImpl
    implements OnboardingSubmissionRepository {
  OnboardingSubmissionRepositoryImpl(this._remote, this._guard);

  final OnboardingRemoteDataSource _remote;
  final Guard _guard;

  @override
  Future<Either<Failure, Unit>> submitBasics(OnboardingData draft) =>
      _guard(() async {
        await _remote.submitBasics(
          OnboardingBasicsRequestDto(
            accountType: draft.accountType,
            profileFor: draft.relationship,
            fullName: draft.fullName,
            gender: draft.gender,
            religion: draft.religion,
            dateOfBirth: _isoDate(draft.dateOfBirth),
            intent: draft.lookingForIntent,
            // referralSource: draft.howHeard,
            // Required by the backend (null or missing → 400 "must be one
            // of …"); "Skip" on How did you hear sends `other`.
            referralSource: draft.howHeard ?? 'other',
            nationality: draft.nationalities.map(_countryName).toList(),
            // grewUpIn: draft.grewUpCountry == null
            //     ? null
            //     : _countryName(draft.grewUpCountry!),
            grewUpIn: [
              if (draft.grewUpCountry case final code?) _countryName(code),
            ],
            ethnicity: draft.ethnicities.map(_countryName).toList(),
            heightCm: draft.heightCm,
            languages: draft.languages,
          ),
        );
        return unit;
      });

  @override
  Future<Either<Failure, Unit>> submitBackgroundFaith(OnboardingData draft) =>
      _guard(() async {
        await _remote.submitBackgroundFaith(
          OnboardingBackgroundFaithRequestDto(
            educationLevel: draft.educationLevel,
            professionTitle: draft.profession,
            maritalStatus: draft.maritalStatus,
            getToknowDuration: _hyphenateRange(draft.knowSomeoneDuration),
            marriageTimeline: _hyphenateRange(draft.marriedWithinDuration),
            faith: draft.faithTags
                .map((t) => faithTagTokens[t] ?? t)
                .toSet()
                .toList(),
            religiousPractices: [?draft.religionPracticeLevel],
          ),
        );
        return unit;
      });

  @override
  Future<Either<Failure, Unit>> submitLifestylePersonality(
    OnboardingData draft,
  ) => _guard(() async {
    await _remote.submitLifestylePersonality(
      OnboardingLifestylePersonalityRequestDto(
        halalFood: draft.eatsHalalOnly,
        smoking: draft.smokes,
        alcohol: draft.drinksAlcohol,
        bornMuslim: draft.bornMuslim,
        haveChildren: draft.hasChildren,
        relocateAbroad: draft.wouldRelocate,
        personalityTraits: draft.personalityTraits,
        cultural: draft.interests.where(culturalTags.contains).toList(),
        foodDrinks: draft.interests.where(foodDrinkTags.contains).toList(),
        sports: draft.interests.where(sportTags.contains).toList(),
      ),
    );
    return unit;
  });

  @override
  Future<Either<Failure, Unit>> submitBio(OnboardingData draft) =>
      _guard(() async {
        await _remote.submitBio(OnboardingBioRequestDto(aboutMe: draft.bio));
        return unit;
      });

  @override
  Future<Either<Failure, Unit>> submitPhotos(OnboardingData draft) =>
      _guard(() async {
        // `TODO(api)`: photos already on the server (prefilled as URLs)
        // can't be re-sent as files, and how step 8 keeps/removes them is
        // unconfirmed (replace vs append, kept-paths field, delete API) —
        // see resources/docs/PENDING.md. For now only newly picked local
        // files go up, and nothing is sent when there are none.
        final local = draft.photoPaths.where((p) => !_isRemote(p)).toList();
        if (local.isEmpty) return unit;
        final form = FormData()..fields.add(const MapEntry('step', '8'));
        // Before: every draft photo was a local file.
        // for (final (i, path) in draft.photoPaths.indexed) {
        for (final (i, path) in local.indexed) {
          form.files.add(
            MapEntry(
              'images',
              await MultipartFile.fromFile(path, filename: _fileName(path, i)),
            ),
          );
        }
        await _remote.submitPhotos(form);
        return unit;
      });

  @override
  Future<Either<Failure, Unit>> deleteUploadedPhoto(String url) =>
      _guard(() async {
        final segments = Uri.parse(url).pathSegments;
        if (segments.isEmpty || segments.last.isEmpty) {
          throw const DeviceException('no file name in photo url');
        }
        await _remote.deletePhoto(segments.last);
        return unit;
      });

  static bool _isRemote(String path) =>
      path.startsWith('http://') || path.startsWith('https://');

  /// Keeps the picked file's extension (the server stores it as-is).
  String _fileName(String path, int index) {
    final dot = path.lastIndexOf('.');
    final ext = dot == -1 || dot < path.lastIndexOf('/')
        ? '.jpg'
        : path.substring(dot);
    return 'photo_${index + 1}$ext';
  }

  String _countryName(String code) {
    for (final country in [...allCountries, ...suggestedCountries]) {
      if (country.code == code) return country.name;
    }
    return code;
  }

  String? _isoDate(DateTime? date) {
    if (date == null) return null;
    final y = date.year.toString().padLeft(4, '0');
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  /// `1_2_months` → `1-2_months` (first two numeric segments only; tokens
  /// without that shape, e.g. `agree_together`, pass through unchanged).
  static final _rangePattern = RegExp(r'^(\d+)_(\d+)_(.+)$');

  String? _hyphenateRange(String? value) {
    if (value == null) return null;
    final match = _rangePattern.firstMatch(value);
    if (match == null) return value;
    return '${match[1]}-${match[2]}_${match[3]}';
  }
}
