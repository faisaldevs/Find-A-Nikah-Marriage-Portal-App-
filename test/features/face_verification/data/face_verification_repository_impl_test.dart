import 'dart:io';

import 'package:dio/dio.dart';
import 'package:find_a_nikah/core/core.dart';
import 'package:find_a_nikah/features/face_verification/data/data.dart';
import 'package:find_a_nikah/features/face_verification/domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:retrofit/retrofit.dart';

import '../../../helpers/fakes.dart';

class _FakeCapture extends ImageCaptureDataSource {
  _FakeCapture() : super(ImagePicker());
}

class _FakeDetector extends SelfieFaceDetector {}

HttpResponse<dynamic> _httpResponse({
  required int statusCode,
  Map<String, dynamic>? data,
}) => HttpResponse<dynamic>(
  data,
  Response<dynamic>(
    requestOptions: RequestOptions(path: '/test'),
    statusCode: statusCode,
    data: data,
  ),
);

void main() {
  late MockFaceVerificationRemoteDataSource remote;
  late MockImageCompressor compressor;
  late FaceVerificationRepositoryImpl repo;

  setUpAll(() {
    registerFallbackValue(
      HttpResponse<dynamic>(
        null,
        Response<dynamic>(requestOptions: RequestOptions(path: '/x')),
      ),
    );
    registerFallbackValue(FormData());
    registerFallbackValue(Options());
  });

  setUp(() {
    remote = MockFaceVerificationRemoteDataSource();
    compressor = MockImageCompressor();
    when(
      () => compressor.compress(any(), outputName: any(named: 'outputName')),
    ).thenAnswer((i) async => i.positionalArguments.first as String);
    repo = FaceVerificationRepositoryImpl(
      _FakeCapture(),
      _FakeDetector(),
      remote,
      testGuard(),
      compressor,
    );
  });

  group('startLivenessSession', () {
    test('maps a successful response to a FaceSession', () async {
      when(remote.startFaceSession).thenAnswer(
        (_) async => _httpResponse(
          statusCode: 201,
          data: {
            'data': {
              'sessionId': 's1',
              'challenges': ['front', 'left', 'right'],
              'expiresInSeconds': 120,
            },
          },
        ),
      );
      final result = await repo.startLivenessSession();
      final session = result.getRight().toNullable();
      expect(session?.sessionId, 's1');
      expect(session?.plan.steps, hasLength(3));
      expect(session?.expiresAt, isNotNull);
    });

    test('a network error becomes a Failure', () async {
      when(remote.startFaceSession).thenThrow(
        DioException.connectionError(
          requestOptions: RequestOptions(path: '/start'),
          reason: 'offline',
        ),
      );
      final result = await repo.startLivenessSession();
      final failure = result.getLeft().toNullable();
      expect(failure, isA<ApiResponseFailure>());
      expect((failure! as ApiResponseFailure).fallback, isA<NetworkFailure>());
    });
  });

  group('submitLivenessSteps', () {
    late Directory dir;
    late Map<String, String> paths;
    const session = FaceSession(sessionId: 's1');

    setUp(() {
      dir = Directory.systemTemp.createTempSync('face_verif_test');
      paths = {
        for (final name in ['front', 'left', 'right'])
          name: (File(
            '${dir.path}/$name.jpg',
          )..writeAsBytesSync([1, 2, 3])).path,
      };
    });

    tearDown(() => dir.deleteSync(recursive: true));

    test('sends sessionId + one compressed still per challenge', () async {
      when(
        () => remote.verifyFace(any(), options: any(named: 'options')),
      ).thenAnswer(
        (_) async => _httpResponse(
          statusCode: 200,
          data: {
            'data': {
              'isFaceVerified': true,
              'verification': {'status': 'approved'},
            },
          },
        ),
      );

      final result = await repo.submitLivenessSteps(
        session: session,
        stepFilePaths: paths,
      );

      expect(result.getRight().toNullable(), isA<Verified>());
      final form =
          verify(
                () => remote.verifyFace(
                  captureAny(),
                  options: any(named: 'options'),
                ),
              ).captured.single
              as FormData;
      expect(form.fields.map((f) => (f.key, f.value)), [('sessionId', 's1')]);
      // Confirmed contract: step1..step3 in challenge order.
      expect(form.files.map((f) => f.key), ['step1', 'step2', 'step3']);
      expect(form.files.map((f) => f.value.filename), [
        'front.jpg',
        'left.jpg',
        'right.jpg',
      ]);
      for (final name in ['front', 'left', 'right']) {
        verify(
          () => compressor.compress(paths[name]!, outputName: '$name.jpg'),
        ).called(1);
      }
    });

    test('a missing still for a challenge becomes a DeviceFailure', () async {
      final result = await repo.submitLivenessSteps(
        session: session,
        stepFilePaths: {'front': paths['front']!},
      );
      expect(result.getLeft().toNullable(), isA<DeviceFailure>());
      verifyNever(
        () => remote.verifyFace(any(), options: any(named: 'options')),
      );
    });

    test('an upload error becomes a Failure', () async {
      when(
        () => remote.verifyFace(any(), options: any(named: 'options')),
      ).thenThrow(
        DioException.connectionError(
          requestOptions: RequestOptions(path: '/profile/face-verification'),
          reason: 'offline',
        ),
      );
      final result = await repo.submitLivenessSteps(
        session: session,
        stepFilePaths: paths,
      );
      expect(result.isLeft(), isTrue);
    });

    test('a compressor failure becomes a DeviceFailure', () async {
      when(
        () => compressor.compress(any(), outputName: any(named: 'outputName')),
      ).thenThrow(const DeviceException('boom'));
      final result = await repo.submitLivenessSteps(
        session: session,
        stepFilePaths: paths,
      );
      expect(result.getLeft().toNullable(), isA<DeviceFailure>());
    });
  });
}
