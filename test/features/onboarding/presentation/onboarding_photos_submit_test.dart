import 'package:find_a_nikah/core/core.dart';
import 'package:find_a_nikah/features/onboarding/domain/domain.dart';
import 'package:find_a_nikah/features/onboarding/presentation/bloc/onboarding_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/fakes.dart';

class _UnusedAiBio implements AiBioRepository {
  @override
  Future<Either<Failure, String>> generateBio() => throw UnimplementedError();
}

void main() {
  late FakeOnboardingDraftRepository drafts;
  late MockOnboardingSubmissionRepository submissions;
  late MockPhotoPickerRepository picker;
  late OnboardingBloc bloc;

  const photos = ['/a.jpg', '/b.jpg', '/c.jpg'];

  setUpAll(() => registerFallbackValue(const OnboardingData()));

  setUp(() async {
    drafts = FakeOnboardingDraftRepository();
    await drafts.save(const OnboardingData(photoPaths: photos));
    submissions = MockOnboardingSubmissionRepository();
    picker = MockPhotoPickerRepository();
    bloc = OnboardingBloc(
      drafts,
      picker,
      _UnusedAiBio(),
      submissions,
      MockOnboardingProfileRepository(),
    );
  });

  tearDown(() => bloc.close());

  Future<List<OnboardingState>> submit() async {
    final states = <OnboardingState>[];
    final sub = bloc.stream.listen(states.add);
    bloc.add(const PhotosSubmitted());
    await Future<void>.delayed(const Duration(milliseconds: 10));
    await sub.cancel();
    return states;
  }

  test('uploads the draft photos as step 8 and clears the flag', () async {
    when(
      () => submissions.submitPhotos(any()),
    ).thenAnswer((_) async => right(unit));

    final states = await submit();

    expect(states.map((s) => s.submittingStep), [true, false]);
    expect(states.last.failure, isNull);
    final sent =
        verify(() => submissions.submitPhotos(captureAny())).captured.single
            as OnboardingData;
    expect(sent.photoPaths, photos);
  });

  test('a failed upload surfaces the failure', () async {
    when(
      () => submissions.submitPhotos(any()),
    ).thenAnswer((_) async => left(const NetworkFailure()));

    final states = await submit();

    expect(states.last.submittingStep, isFalse);
    expect(states.last.failure, isA<NetworkFailure>());
  });

  test('unchanged photos are not uploaded twice; changed ones are', () async {
    when(
      () => submissions.submitPhotos(any()),
    ).thenAnswer((_) async => right(unit));

    await submit();
    final second = await submit();
    // Same true → false pulse, so the page still moves on.
    expect(second.map((s) => s.submittingStep), [true, false]);
    verify(() => submissions.submitPhotos(any())).called(1);

    await drafts.save(const OnboardingData(photoPaths: ['/a.jpg', '/d.jpg']));
    await submit();
    verify(() => submissions.submitPhotos(any())).called(1);
  });

  test('a failed upload is retried next time', () async {
    when(
      () => submissions.submitPhotos(any()),
    ).thenAnswer((_) async => left(const NetworkFailure()));
    await submit();

    when(
      () => submissions.submitPhotos(any()),
    ).thenAnswer((_) async => right(unit));
    await submit();

    verify(() => submissions.submitPhotos(any())).called(2);
  });

  group('picking', () {
    Future<List<OnboardingState>> pick() async {
      final states = <OnboardingState>[];
      final sub = bloc.stream.listen(states.add);
      bloc.add(const ProfilePhotosPickRequested());
      await Future<void>.delayed(const Duration(milliseconds: 10));
      await sub.cancel();
      return states;
    }

    setUp(() async {
      await drafts.save(const OnboardingData());
    });

    test('processing flag wraps only the compress step', () async {
      when(
        () => picker.pickFromGallery(limit: any(named: 'limit')),
      ).thenAnswer((_) async => right(['/raw1.heic', '/raw2.heic']));
      when(
        () => picker.preparePhotos(any()),
      ).thenAnswer((_) async => right(['/p1.jpg', '/p2.jpg']));

      final states = await pick();

      expect(states.map((s) => (s.pickingPhotos, s.processingPhotos)), [
        (true, false),
        (false, false),
        (false, true),
        (false, false),
      ]);
      expect(drafts.current.photoPaths, ['/p1.jpg', '/p2.jpg']);
      verify(() => picker.preparePhotos(['/raw1.heic', '/raw2.heic']));
    });

    test('a gallery that ignores the limit is trimmed to the max', () async {
      await drafts.save(
        const OnboardingData(photoPaths: ['/a.jpg', '/b.jpg', '/c.jpg']),
      );
      // 2 slots left (max 5), but the gallery hands back 4.
      when(
        () => picker.pickFromGallery(limit: any(named: 'limit')),
      ).thenAnswer((_) async => right(['/1', '/2', '/3', '/4']));
      when(() => picker.preparePhotos(any())).thenAnswer(
        (i) async =>
            right((i.positionalArguments.first as List<String>).toList()),
      );

      final states = await pick();

      verify(() => picker.pickFromGallery(limit: 2));
      verify(() => picker.preparePhotos(['/1', '/2']));
      expect(drafts.current.photoPaths, hasLength(OnboardingData.maxPhotos));
      expect(states.map((s) => s.photosOverLimit), contains(2));
    });

    test('cancelling the gallery never shows processing', () async {
      when(
        () => picker.pickFromGallery(limit: any(named: 'limit')),
      ).thenAnswer((_) async => right(const []));

      final states = await pick();

      expect(states.any((s) => s.processingPhotos), isFalse);
      verifyNever(() => picker.preparePhotos(any()));
    });

    test('a compress failure clears processing and surfaces it', () async {
      when(
        () => picker.pickFromGallery(limit: any(named: 'limit')),
      ).thenAnswer((_) async => right(['/raw.heic']));
      when(
        () => picker.preparePhotos(any()),
      ).thenAnswer((_) async => left(const DeviceFailure()));

      final states = await pick();

      expect(states.last.processingPhotos, isFalse);
      expect(states.last.failure, isA<DeviceFailure>());
      expect(drafts.current.photoPaths, isEmpty);
    });
  });

  group('removing', () {
    const uploaded = 'https://img.example.com/public/upload/a.jpg';

    setUp(() async {
      await drafts.save(
        const OnboardingData(photoPaths: [uploaded, '/local.jpg']),
      );
    });

    Future<List<OnboardingState>> remove(int index) async {
      final states = <OnboardingState>[];
      final sub = bloc.stream.listen(states.add);
      bloc.add(ProfilePhotoRemoved(index));
      await Future<void>.delayed(const Duration(milliseconds: 10));
      await sub.cancel();
      return states;
    }

    test('a local photo is removed without any API call', () async {
      await remove(1);
      expect(drafts.current.photoPaths, [uploaded]);
      verifyNever(() => submissions.deleteUploadedPhoto(any()));
    });

    test('an uploaded photo is deleted on the server, then removed', () async {
      when(
        () => submissions.deleteUploadedPhoto(any()),
      ).thenAnswer((_) async => right(unit));

      final states = await remove(0);

      expect(states.first.deletingPhoto, uploaded);
      expect(states.last.deletingPhoto, isNull);
      expect(drafts.current.photoPaths, ['/local.jpg']);
      verify(() => submissions.deleteUploadedPhoto(uploaded)).called(1);
    });

    test(
      'a failed server delete keeps the photo and shows the error',
      () async {
        when(
          () => submissions.deleteUploadedPhoto(any()),
        ).thenAnswer((_) async => left(const NetworkFailure()));

        final states = await remove(0);

        expect(drafts.current.photoPaths, [uploaded, '/local.jpg']);
        expect(states.last.failure, isA<NetworkFailure>());
        expect(states.last.deletingPhoto, isNull);
      },
    );
  });
}
