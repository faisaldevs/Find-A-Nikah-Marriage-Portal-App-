import 'dart:io';

import 'package:dio/dio.dart';
import 'package:find_a_nikah/features/onboarding/data/datasources/onboarding_remote_data_source.dart';
import 'package:find_a_nikah/features/onboarding/data/repositories/onboarding_submission_repository_impl.dart';
import 'package:find_a_nikah/features/onboarding/domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/fakes.dart';

class _MockRemote extends Mock implements OnboardingRemoteDataSource {}

void main() {
  late _MockRemote remote;
  late OnboardingSubmissionRepositoryImpl repo;
  late Directory dir;
  late List<String> photos;

  setUpAll(() => registerFallbackValue(FormData()));

  setUp(() {
    remote = _MockRemote();
    repo = OnboardingSubmissionRepositoryImpl(remote, testGuard());
    dir = Directory.systemTemp.createTempSync('onboarding_photos_test');
    photos = [
      for (final name in ['main.jpg', 'second.png', 'third'])
        (File('${dir.path}/$name')..writeAsBytesSync([1, 2, 3])).path,
    ];
  });

  tearDown(() => dir.deleteSync(recursive: true));

  test('sends step=8 and every photo as a repeated images field', () async {
    when(() => remote.submitPhotos(any())).thenAnswer((_) async {});

    final result = await repo.submitPhotos(OnboardingData(photoPaths: photos));

    expect(result.isRight(), isTrue);
    final form =
        verify(() => remote.submitPhotos(captureAny())).captured.single
            as FormData;
    expect(form.fields.map((f) => (f.key, f.value)), [('step', '8')]);
    expect(form.files.map((f) => f.key), ['images', 'images', 'images']);
    // Order kept (first = main photo); extension kept, .jpg when missing.
    expect(form.files.map((f) => f.value.filename), [
      'photo_1.jpg',
      'photo_2.png',
      'photo_3.jpg',
    ]);
  });

  test('an upload error becomes a Failure', () async {
    when(() => remote.submitPhotos(any())).thenThrow(
      DioException.connectionError(
        requestOptions: RequestOptions(path: '/v1/onboarding/step'),
        reason: 'offline',
      ),
    );
    final result = await repo.submitPhotos(OnboardingData(photoPaths: photos));
    expect(result.isLeft(), isTrue);
  });

  test('a missing file becomes a Failure, nothing is sent', () async {
    final result = await repo.submitPhotos(
      OnboardingData(photoPaths: ['${dir.path}/gone.jpg']),
    );
    expect(result.isLeft(), isTrue);
    verifyNever(() => remote.submitPhotos(any()));
  });

  // TODO(api): revisit once step 8's keep/remove contract is known.
  test('already-uploaded photos (URLs) are not re-sent', () async {
    when(() => remote.submitPhotos(any())).thenAnswer((_) async {});

    final result = await repo.submitPhotos(
      OnboardingData(
        photoPaths: [
          'https://img.example.com/public/upload/old.jpg',
          photos.first,
        ],
      ),
    );

    expect(result.isRight(), isTrue);
    final form =
        verify(() => remote.submitPhotos(captureAny())).captured.single
            as FormData;
    expect(form.files, hasLength(1));
  });

  test('only uploaded photos → no request at all', () async {
    final result = await repo.submitPhotos(
      const OnboardingData(
        photoPaths: [
          'https://img.example.com/public/upload/a.jpg',
          'https://img.example.com/public/upload/b.jpg',
          'https://img.example.com/public/upload/c.jpg',
        ],
      ),
    );
    expect(result.isRight(), isTrue);
    verifyNever(() => remote.submitPhotos(any()));
  });

  group('deleteUploadedPhoto', () {
    test('sends just the file name from the photo URL', () async {
      when(() => remote.deletePhoto(any())).thenAnswer((_) async {});
      final result = await repo.deleteUploadedPhoto(
        'https://img.example.com/public/upload/1792-abc.jpg',
      );
      expect(result.isRight(), isTrue);
      verify(() => remote.deletePhoto('1792-abc.jpg')).called(1);
    });

    test('a server error becomes a Failure', () async {
      when(() => remote.deletePhoto(any())).thenThrow(
        DioException.connectionError(
          requestOptions: RequestOptions(path: '/v1/onboarding/images'),
          reason: 'offline',
        ),
      );
      final result = await repo.deleteUploadedPhoto(
        'https://img.example.com/public/upload/x.jpg',
      );
      expect(result.isLeft(), isTrue);
    });
  });
}
