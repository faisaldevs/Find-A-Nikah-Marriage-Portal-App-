import 'package:find_a_nikah/features/onboarding/data/data.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/fakes.dart';

class _FakeOnboardingRemoteDataSource implements OnboardingRemoteDataSource {
  late OnboardingProfileResponseDto response;

  @override
  Future<OnboardingProfileResponseDto> getProfile() async => response;

  @override
  Future<void> submitBasics(OnboardingBasicsRequestDto body) =>
      throw UnimplementedError();
  @override
  Future<void> submitBackgroundFaith(
    OnboardingBackgroundFaithRequestDto body,
  ) => throw UnimplementedError();
  @override
  Future<void> submitLifestylePersonality(
    OnboardingLifestylePersonalityRequestDto body,
  ) => throw UnimplementedError();
  @override
  Future<void> submitBio(OnboardingBioRequestDto body) =>
      throw UnimplementedError();
  @override
  Future<void> submitImages(OnboardingImagesRequestDto body) =>
      throw UnimplementedError();
}

/// A real post-Basics (`currentStep: 5`) payload — step 4 submitted, 5-7
/// untouched, so the Background & faith / Lifestyle / Bio objects below
/// are schema defaults, not real user choices (they must stay unread).
Map<String, dynamic> _payloadAtStep(
  int step, {
  bool sectionsBeyondBasics = false,
}) {
  return {
    'data': {
      'user': {'fullName': 'Dev Team'},
      'profile': {
        'accountType': 'individual',
        'country': 'Bangladesh',
        'dateOfBirth': '2005-04-02T00:00:00.000Z',
        'ethnicity': <String>[],
        'gender': 'male',
        'languages': ['English'],
        'nationality': ['Bangladesh'],
        'grewUpIn': ['Bangladesh'],
        'maritalStatus': sectionsBeyondBasics
            ? 'never_married'
            : 'never_married',
        'faith': sectionsBeyondBasics
            ? ['prays_on_time', 'fasting']
            : <String>[],
        'religiousPractices': sectionsBeyondBasics ? ['strict'] : <String>[],
        'educationLevel': sectionsBeyondBasics ? 'bachelors' : null,
        'professionTitle': sectionsBeyondBasics ? 'Engineer' : null,
        'getToknowDuration': sectionsBeyondBasics ? '1-2_months' : null,
        'marriageTimeline': sectionsBeyondBasics ? '6-12_months' : null,
        'personalityTraits': sectionsBeyondBasics
            ? ['Kind', 'Funny']
            : <String>[],
        'aboutMe': sectionsBeyondBasics ? 'Hello world' : null,
        'aboutYou': {
          'bornMuslim': true,
          'haveChildren': false,
          'relocateAbroad': true,
        },
        'lifestyle': {'alcohol': false, 'halalFood': true, 'smoking': false},
        'interests': {
          'cultural': ['Music'],
          'foodDrinks': ['Coffee'],
          'sports': ['Football'],
          'fashion': <String>[],
          'activities': <String>[],
        },
      },
      'currentStep': step,
      'isCompleted': false,
    },
  };
}

void main() {
  late _FakeOnboardingRemoteDataSource remote;
  late OnboardingProfileRepositoryImpl repo;

  setUp(() {
    remote = _FakeOnboardingRemoteDataSource();
    repo = OnboardingProfileRepositoryImpl(remote, testGuard());
  });

  test('nothing submitted yet (step 4) → null, nothing to prefill', () async {
    remote.response = OnboardingProfileResponseDto.fromJson(
      _payloadAtStep(4),
    );

    final result = await repo.fetchSubmittedDraft();

    expect(result.getRight().toNullable(), isNull);
  });

  test(
    'step 5 (Basics done) prefills Basics only — later sections stay blank '
    'even though the backend already shows default values for them',
    () async {
      remote.response = OnboardingProfileResponseDto.fromJson(
        _payloadAtStep(5),
      );

      final draft = (await repo.fetchSubmittedDraft()).getRight().toNullable();

      expect(draft, isNotNull);
      expect(draft!.accountType, 'individual');
      expect(draft.fullName, 'Dev Team');
      expect(draft.gender, 'male');
      expect(draft.dateOfBirth, DateTime.parse('2005-04-02T00:00:00.000Z'));
      expect(draft.languages, ['English']);
      expect(draft.nationalities, ['BD']);
      expect(draft.grewUpCountry, 'BD');
      // Background & faith (step 5) not yet submitted — must not leak the
      // backend's schema-default `maritalStatus`/`faith` values.
      expect(draft.maritalStatus, isNull);
      expect(draft.faithTags, isEmpty);
    },
  );

  test('step 6 (Background & faith done) also prefills that section', () async {
    remote.response = OnboardingProfileResponseDto.fromJson(
      _payloadAtStep(6, sectionsBeyondBasics: true),
    );

    final draft = (await repo.fetchSubmittedDraft()).getRight().toNullable();

    expect(draft, isNotNull);
    expect(draft!.maritalStatus, 'never_married');
    expect(draft.educationLevel, 'bachelors');
    expect(draft.profession, 'Engineer');
    expect(draft.knowSomeoneDuration, '1_2_months');
    expect(draft.marriedWithinDuration, '6_12_months');
    expect(draft.faithTags, containsAll(['Prays on time', 'Fasting']));
    expect(draft.religionPracticeLevel, 'strict');
    // Lifestyle (step 6) not yet submitted.
    expect(draft.bornMuslim, isNull);
  });

  test('step 7 (Lifestyle & personality done) prefills it too', () async {
    remote.response = OnboardingProfileResponseDto.fromJson(
      _payloadAtStep(7, sectionsBeyondBasics: true),
    );

    final draft = (await repo.fetchSubmittedDraft()).getRight().toNullable();

    expect(draft, isNotNull);
    expect(draft!.eatsHalalOnly, isTrue);
    expect(draft.smokes, isFalse);
    expect(draft.drinksAlcohol, isFalse);
    expect(draft.bornMuslim, isTrue);
    expect(draft.hasChildren, isFalse);
    expect(draft.wouldRelocate, isTrue);
    expect(draft.personalityTraits, ['Kind', 'Funny']);
    expect(draft.interests, containsAll(['Music', 'Coffee', 'Football']));
    // Bio (step 7) not yet submitted.
    expect(draft.bio, isNull);
  });

  test('step 8 (Bio done) prefills the bio', () async {
    remote.response = OnboardingProfileResponseDto.fromJson(
      _payloadAtStep(8, sectionsBeyondBasics: true),
    );

    final draft = (await repo.fetchSubmittedDraft()).getRight().toNullable();

    expect(draft!.bio, 'Hello world');
  });
}
