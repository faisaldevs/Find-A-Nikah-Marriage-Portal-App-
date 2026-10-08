import 'package:bloc_test/bloc_test.dart';
import 'package:find_a_nikah/core/core.dart';
import 'package:find_a_nikah/features/onboarding/domain/domain.dart';
import 'package:find_a_nikah/features/onboarding/presentation/bloc/onboarding_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/fakes.dart';

class _FakeAiBioRepository implements AiBioRepository {
  _FakeAiBioRepository(this.result);

  final Either<Failure, String> result;
  int calls = 0;

  @override
  Future<Either<Failure, String>> generateBio() async {
    calls++;
    return result;
  }
}

void main() {
  late FakeOnboardingDraftRepository drafts;
  late MockPhotoPickerRepository photos;
  late _FakeAiBioRepository aiBio;

  setUp(() {
    drafts = FakeOnboardingDraftRepository();
    photos = MockPhotoPickerRepository();
    aiBio = _FakeAiBioRepository(right('Generated profile bio'));
  });

  blocTest<OnboardingBloc, OnboardingState>(
    'generates and saves the returned bio',
    build: () => OnboardingBloc(drafts, photos, aiBio),
    act: (bloc) => bloc.add(const BioGenerationRequested()),
    expect: () => [
      const OnboardingState(
        draft: OnboardingData(),
        generatingBio: true,
      ),
      const OnboardingState(
        draft: OnboardingData(bio: 'Generated profile bio'),
        generatedBio: 'Generated profile bio',
      ),
    ],
    verify: (_) {
      expect(aiBio.calls, 1);
      expect(drafts.current.bio, 'Generated profile bio');
    },
  );

  blocTest<OnboardingBloc, OnboardingState>(
    'surfaces generation failures and does not change the saved bio',
    setUp: () {
      aiBio = _FakeAiBioRepository(left(const ServerFailure()));
    },
    build: () => OnboardingBloc(drafts, photos, aiBio),
    act: (bloc) => bloc.add(const BioGenerationRequested()),
    expect: () => [
      const OnboardingState(
        draft: OnboardingData(),
        generatingBio: true,
      ),
      const OnboardingState(
        draft: OnboardingData(),
        failure: ServerFailure(),
      ),
    ],
    verify: (_) {
      expect(aiBio.calls, 1);
      expect(drafts.current.bio, isNull);
    },
  );
}
