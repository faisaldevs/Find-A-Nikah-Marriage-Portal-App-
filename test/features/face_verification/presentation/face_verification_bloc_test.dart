import 'package:bloc_test/bloc_test.dart';
import 'package:find_a_nikah/core/core.dart';
import 'package:find_a_nikah/features/face_verification/domain/domain.dart';
import 'package:find_a_nikah/features/face_verification/presentation/presentation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/fakes.dart';

const _fastConfig = LivenessConfig(
  holdDuration: Duration(milliseconds: 1),
  stepTimeout: Duration(seconds: 30),
);

const _frontOk = FaceSnapshot(
  faceCount: 1,
  yaw: 0,
  pitch: 0,
  boxWidthRatio: 0.5,
  boxCenterOffsetRatio: 0,
  leftEyeOpenProbability: 0.9,
  rightEyeOpenProbability: 0.9,
);
const _leftOk = FaceSnapshot(
  faceCount: 1,
  yaw: 30,
  boxWidthRatio: 0.5,
  boxCenterOffsetRatio: 0,
  leftEyeOpenProbability: 0.9,
  rightEyeOpenProbability: 0.9,
);
const _rightOk = FaceSnapshot(
  faceCount: 1,
  yaw: -30,
  boxWidthRatio: 0.5,
  boxCenterOffsetRatio: 0,
  leftEyeOpenProbability: 0.9,
  rightEyeOpenProbability: 0.9,
);
const _noFace = FaceSnapshot(faceCount: 0);

const _session = FaceSession(sessionId: 's1');

void main() {
  late MockFaceVerificationRepository repo;

  setUpAll(() {
    registerFallbackValue(LivenessPose.front);
    registerFallbackValue(_session);
  });

  setUp(() {
    repo = MockFaceVerificationRepository();
  });

  group('old single-selfie path (unchanged)', () {
    blocTest<FaceVerificationBloc, FaceVerificationState>(
      'the first profile photo provided is kept; a later one is ignored',
      build: () => FaceVerificationBloc(repo),
      act: (bloc) => bloc
        ..add(const FaceVerificationProfilePhotoProvided('/a.jpg'))
        ..add(const FaceVerificationProfilePhotoProvided('/b.jpg')),
      expect: () => [
        const FaceVerificationState(profilePhotoPath: '/a.jpg'),
      ],
    );

    blocTest<FaceVerificationBloc, FaceVerificationState>(
      'change photo replaces the profile photo and clears any selfie',
      setUp: () => when(
        repo.pickProfilePhoto,
      ).thenAnswer((_) async => right('/new.jpg')),
      build: () => FaceVerificationBloc(repo),
      seed: () => const FaceVerificationState(
        profilePhotoPath: '/old.jpg',
        selfiePath: '/selfie.jpg',
        status: FaceVerificationStatus.selfieReady,
      ),
      act: (bloc) =>
          bloc.add(const FaceVerificationProfilePhotoChangeRequested()),
      expect: () => [const FaceVerificationState(profilePhotoPath: '/new.jpg')],
    );

    blocTest<FaceVerificationBloc, FaceVerificationState>(
      'capture → on-device check ok → selfieReady',
      setUp: () {
        when(
          repo.captureSelfie,
        ).thenAnswer((_) async => right('/selfie.jpg'));
        when(
          () => repo.checkSelfie(
            any(),
            expectedPose: any(named: 'expectedPose'),
          ),
        ).thenAnswer((_) async => right(SelfieCheckResult.ok));
      },
      build: () => FaceVerificationBloc(repo),
      act: (bloc) => bloc.add(const SelfieCaptureRequested()),
      expect: () => [
        const FaceVerificationState(
          selfiePath: '/selfie.jpg',
          status: FaceVerificationStatus.checkingSelfie,
        ),
        const FaceVerificationState(
          selfiePath: '/selfie.jpg',
          status: FaceVerificationStatus.selfieReady,
        ),
      ],
    );

    blocTest<FaceVerificationBloc, FaceVerificationState>(
      'capture → on-device check rejects → failed, selfie cleared',
      setUp: () {
        when(
          repo.captureSelfie,
        ).thenAnswer((_) async => right('/selfie.jpg'));
        when(
          () => repo.checkSelfie(
            any(),
            expectedPose: any(named: 'expectedPose'),
          ),
        ).thenAnswer((_) async => right(SelfieCheckResult.noFace));
      },
      build: () => FaceVerificationBloc(repo),
      act: (bloc) => bloc.add(const SelfieCaptureRequested()),
      expect: () => [
        const FaceVerificationState(
          selfiePath: '/selfie.jpg',
          status: FaceVerificationStatus.checkingSelfie,
        ),
        const FaceVerificationState(
          status: FaceVerificationStatus.failed,
          check: SelfieCheckResult.noFace,
        ),
      ],
    );

    blocTest<FaceVerificationBloc, FaceVerificationState>(
      'retake resets to idle, keeping the profile photo',
      build: () => FaceVerificationBloc(repo),
      seed: () => const FaceVerificationState(
        profilePhotoPath: '/a.jpg',
        selfiePath: '/selfie.jpg',
        status: FaceVerificationStatus.selfieReady,
      ),
      act: (bloc) => bloc.add(const SelfieRetakeRequested()),
      expect: () => [const FaceVerificationState(profilePhotoPath: '/a.jpg')],
    );

    blocTest<FaceVerificationBloc, FaceVerificationState>(
      'submit succeeds → underReview',
      setUp: () => when(
        () => repo.submit(
          profilePhotoPath: any(named: 'profilePhotoPath'),
          selfiePath: any(named: 'selfiePath'),
        ),
      ).thenAnswer((_) async => right(unit)),
      build: () => FaceVerificationBloc(repo),
      seed: () => const FaceVerificationState(
        profilePhotoPath: '/a.jpg',
        selfiePath: '/selfie.jpg',
        status: FaceVerificationStatus.selfieReady,
      ),
      act: (bloc) => bloc.add(const FaceVerificationSubmitted()),
      expect: () => [
        const FaceVerificationState(
          profilePhotoPath: '/a.jpg',
          selfiePath: '/selfie.jpg',
          status: FaceVerificationStatus.submitting,
        ),
        const FaceVerificationState(
          profilePhotoPath: '/a.jpg',
          selfiePath: '/selfie.jpg',
          status: FaceVerificationStatus.underReview,
        ),
      ],
    );

    blocTest<FaceVerificationBloc, FaceVerificationState>(
      'submit fails → back to selfieReady so the user can retry',
      setUp: () => when(
        () => repo.submit(
          profilePhotoPath: any(named: 'profilePhotoPath'),
          selfiePath: any(named: 'selfiePath'),
        ),
      ).thenAnswer((_) async => left(const NetworkFailure())),
      build: () => FaceVerificationBloc(repo),
      seed: () => const FaceVerificationState(
        profilePhotoPath: '/a.jpg',
        selfiePath: '/selfie.jpg',
        status: FaceVerificationStatus.selfieReady,
      ),
      act: (bloc) => bloc.add(const FaceVerificationSubmitted()),
      expect: () => [
        const FaceVerificationState(
          profilePhotoPath: '/a.jpg',
          selfiePath: '/selfie.jpg',
          status: FaceVerificationStatus.submitting,
        ),
        const FaceVerificationState(
          profilePhotoPath: '/a.jpg',
          selfiePath: '/selfie.jpg',
          status: FaceVerificationStatus.selfieReady,
          failure: NetworkFailure(),
        ),
      ],
    );
  });

  group('guided liveness', () {
    test('permission denied stops before starting a session', () async {
      when(
        repo.requestCameraPermission,
      ).thenAnswer((_) async => right(CameraPermissionStatus.denied));
      final bloc = FaceVerificationBloc(repo, _fastConfig)
        ..add(const LivenessSessionStartRequested());
      await expectLater(
        bloc.stream,
        emits(
          const FaceVerificationState(
            status: FaceVerificationStatus.cameraPermissionDenied,
          ),
        ),
      );
      verifyNever(repo.startLivenessSession);
      await bloc.close();
    });

    test('permanently denied permission is reported distinctly', () async {
      when(repo.requestCameraPermission).thenAnswer(
        (_) async => right(CameraPermissionStatus.permanentlyDenied),
      );
      final bloc = FaceVerificationBloc(repo, _fastConfig)
        ..add(const LivenessSessionStartRequested());
      await expectLater(
        bloc.stream,
        emits(
          const FaceVerificationState(
            status: FaceVerificationStatus.cameraPermissionPermanentlyDenied,
          ),
        ),
      );
      await bloc.close();
    });

    test('a session-start failure surfaces as failed', () async {
      when(
        repo.requestCameraPermission,
      ).thenAnswer((_) async => right(CameraPermissionStatus.granted));
      when(
        repo.startLivenessSession,
      ).thenAnswer((_) async => left(const NetworkFailure()));
      final bloc = FaceVerificationBloc(repo, _fastConfig);
      final states = <FaceVerificationState>[];
      bloc.stream.listen(states.add);
      bloc.add(const LivenessSessionStartRequested());
      await Future<void>.delayed(const Duration(milliseconds: 20));
      expect(states.last.status, FaceVerificationStatus.failed);
      expect(states.last.failure, const NetworkFailure());
      await bloc.close();
    });

    Future<FaceVerificationBloc> startedBloc() async {
      when(
        repo.requestCameraPermission,
      ).thenAnswer((_) async => right(CameraPermissionStatus.granted));
      when(
        repo.startLivenessSession,
      ).thenAnswer((_) async => right(_session));
      final bloc = FaceVerificationBloc(repo, _fastConfig)
        ..add(const LivenessSessionStartRequested());
      await Future<void>.delayed(const Duration(milliseconds: 10));
      expect(bloc.state.status, FaceVerificationStatus.capturingLiveness);
      expect(bloc.state.session, _session);
      return bloc;
    }

    /// Two `ok` snapshots far enough apart for the 1ms hold to complete.
    Future<void> holdStep(FaceVerificationBloc bloc, FaceSnapshot ok) async {
      bloc.add(LivenessSnapshotReceived(ok));
      await Future<void>.delayed(const Duration(milliseconds: 5));
      bloc.add(LivenessSnapshotReceived(ok));
      await Future<void>.delayed(const Duration(milliseconds: 5));
    }

    test('a non-ok snapshot resets hold progress', () async {
      // A longer hold than `_fastConfig`'s: two `ok` frames 5ms apart must
      // land mid-hold (not complete it), so the step stays open for the
      // noFace frame that follows to actually be processed.
      when(
        repo.requestCameraPermission,
      ).thenAnswer((_) async => right(CameraPermissionStatus.granted));
      when(
        repo.startLivenessSession,
      ).thenAnswer((_) async => right(_session));
      const slowHold = LivenessConfig(
        holdDuration: Duration(milliseconds: 500),
        stepTimeout: Duration(seconds: 30),
      );
      final bloc = FaceVerificationBloc(repo, slowHold)
        ..add(const LivenessSessionStartRequested());
      await Future<void>.delayed(const Duration(milliseconds: 10));

      // Two `ok` frames, not one: the hold clock starts on the first and
      // only shows progress on a later frame — far enough apart (and the
      // hold long enough) to cross the bloc's 0.1 emit threshold without
      // completing the hold.
      bloc.add(const LivenessSnapshotReceived(_frontOk));
      await Future<void>.delayed(const Duration(milliseconds: 150));
      bloc.add(const LivenessSnapshotReceived(_frontOk));
      await Future<void>.delayed(const Duration(milliseconds: 10));
      expect(bloc.state.holdProgress, greaterThan(0));
      expect(bloc.state.status, FaceVerificationStatus.capturingLiveness);

      bloc.add(const LivenessSnapshotReceived(_noFace));
      await Future<void>.delayed(const Duration(milliseconds: 5));
      expect(bloc.state.poseFeedback, PoseFeedback.noFace);
      expect(bloc.state.holdProgress, 0);
      expect(bloc.state.status, FaceVerificationStatus.capturingLiveness);
      await bloc.close();
    });

    test('hold completing asks the page to capture a still', () async {
      final bloc = await startedBloc();
      await holdStep(bloc, _frontOk);
      expect(
        bloc.state.status,
        FaceVerificationStatus.capturingLivenessStill,
      );
      await bloc.close();
    });

    test('step timeout then retry re-arms the same step', () async {
      when(
        repo.requestCameraPermission,
      ).thenAnswer((_) async => right(CameraPermissionStatus.granted));
      when(
        repo.startLivenessSession,
      ).thenAnswer((_) async => right(_session));
      const shortTimeout = LivenessConfig(
        stepTimeout: Duration(milliseconds: 10),
      );
      final bloc = FaceVerificationBloc(repo, shortTimeout)
        ..add(const LivenessSessionStartRequested());
      await Future<void>.delayed(const Duration(milliseconds: 40));
      expect(bloc.state.stepTimedOut, isTrue);

      bloc.add(const LivenessStepRetryRequested());
      await Future<void>.delayed(const Duration(milliseconds: 5));
      expect(bloc.state.stepTimedOut, isFalse);
      expect(bloc.state.currentStepIndex, 0);
      await bloc.close();
    });

    test(
      'full 3-step happy path then an UnderReview verdict → underReview',
      () async {
        when(
          () => repo.checkSelfie(
            any(),
            expectedPose: any(named: 'expectedPose'),
          ),
        ).thenAnswer((_) async => right(SelfieCheckResult.ok));
        when(
          () => repo.submitLivenessSteps(
            session: any(named: 'session'),
            stepFilePaths: any(named: 'stepFilePaths'),
          ),
        ).thenAnswer(
          (_) async => right(const FaceVerificationResult.underReview()),
        );

        final bloc = await startedBloc();

        await holdStep(bloc, _frontOk);
        bloc.add(const LivenessStillCaptured('/step1.jpg'));
        await Future<void>.delayed(const Duration(milliseconds: 10));
        expect(bloc.state.currentStepIndex, 1);

        await holdStep(bloc, _leftOk);
        bloc.add(const LivenessStillCaptured('/step2.jpg'));
        await Future<void>.delayed(const Duration(milliseconds: 10));
        expect(bloc.state.currentStepIndex, 2);

        await holdStep(bloc, _rightOk);
        bloc.add(const LivenessStillCaptured('/step3.jpg'));
        await Future<void>.delayed(const Duration(milliseconds: 20));

        expect(bloc.state.status, FaceVerificationStatus.underReview);
        expect(bloc.state.capturedStepPaths, {
          'front': '/step1.jpg',
          'left': '/step2.jpg',
          'right': '/step3.jpg',
        });
        verify(
          () => repo.submitLivenessSteps(
            session: _session,
            stepFilePaths: {
              'front': '/step1.jpg',
              'left': '/step2.jpg',
              'right': '/step3.jpg',
            },
          ),
        ).called(1);
        await bloc.close();
      },
    );

    test('a rejected verdict is distinct from a network failure', () async {
      when(
        () => repo.checkSelfie(
          any(),
          expectedPose: any(named: 'expectedPose'),
        ),
      ).thenAnswer((_) async => right(SelfieCheckResult.ok));
      when(
        () => repo.submitLivenessSteps(
          session: any(named: 'session'),
          stepFilePaths: any(named: 'stepFilePaths'),
        ),
      ).thenAnswer(
        (_) async =>
            right(const FaceVerificationResult.rejected(reason: 'no match')),
      );

      final bloc = await startedBloc();
      for (final ok in [_frontOk, _leftOk, _rightOk]) {
        await holdStep(bloc, ok);
        bloc.add(LivenessStillCaptured('/${ok.yaw}.jpg'));
        await Future<void>.delayed(const Duration(milliseconds: 10));
      }

      expect(bloc.state.status, FaceVerificationStatus.rejected);
      expect(bloc.state.rejectReason, 'no match');
      expect(bloc.state.canRetry, isTrue);
      await bloc.close();
    });

    test('a failed still capture re-arms the same step', () async {
      final bloc = await startedBloc();
      await holdStep(bloc, _frontOk);
      expect(bloc.state.status, FaceVerificationStatus.capturingLivenessStill);

      bloc.add(const LivenessStillCaptureFailed());
      await Future<void>.delayed(const Duration(milliseconds: 5));
      expect(bloc.state.status, FaceVerificationStatus.capturingLiveness);
      expect(bloc.state.currentStepIndex, 0);
      expect(bloc.state.holdProgress, 0);
      await bloc.close();
    });

    test('a camera failure surfaces as failed with a DeviceFailure', () async {
      final bloc = await startedBloc();
      bloc.add(const LivenessCameraFailed());
      await Future<void>.delayed(const Duration(milliseconds: 5));
      expect(bloc.state.status, FaceVerificationStatus.failed);
      expect(bloc.state.failure, isA<DeviceFailure>());
      await bloc.close();
    });

    test('a timed-out step does not leak into the next step', () async {
      when(
        () => repo.checkSelfie(
          any(),
          expectedPose: any(named: 'expectedPose'),
        ),
      ).thenAnswer((_) async => right(SelfieCheckResult.ok));
      when(
        repo.requestCameraPermission,
      ).thenAnswer((_) async => right(CameraPermissionStatus.granted));
      when(
        repo.startLivenessSession,
      ).thenAnswer((_) async => right(_session));
      const shortTimeout = LivenessConfig(
        holdDuration: Duration(milliseconds: 1),
        stepTimeout: Duration(milliseconds: 10),
      );
      final bloc = FaceVerificationBloc(repo, shortTimeout)
        ..add(const LivenessSessionStartRequested());
      await Future<void>.delayed(const Duration(milliseconds: 40));
      expect(bloc.state.stepTimedOut, isTrue);

      await holdStep(bloc, _frontOk);
      bloc.add(const LivenessStillCaptured('/step1.jpg'));
      await Future<void>.delayed(const Duration(milliseconds: 5));
      expect(bloc.state.currentStepIndex, 1);
      expect(bloc.state.stepTimedOut, isFalse);
      await bloc.close();
    });

    test(
      'an expired session stops the capture with a retryable reject',
      () async {
        when(
          repo.requestCameraPermission,
        ).thenAnswer((_) async => right(CameraPermissionStatus.granted));
        when(repo.startLivenessSession).thenAnswer(
          (_) async => right(
            FaceSession(
              sessionId: 's1',
              expiresAt: DateTime.now().add(const Duration(milliseconds: 20)),
            ),
          ),
        );
        final bloc = FaceVerificationBloc(repo, _fastConfig)
          ..add(const LivenessSessionStartRequested());
        await Future<void>.delayed(const Duration(milliseconds: 10));
        expect(bloc.state.status, FaceVerificationStatus.capturingLiveness);

        await Future<void>.delayed(const Duration(milliseconds: 40));
        expect(bloc.state.status, FaceVerificationStatus.rejected);
        expect(bloc.state.canRetry, isTrue);
        expect(bloc.state.rejectReason, isNotNull);
        verifyNever(
          () => repo.submitLivenessSteps(
            session: any(named: 'session'),
            stepFilePaths: any(named: 'stepFilePaths'),
          ),
        );
        await bloc.close();
      },
    );

    blocTest<FaceVerificationBloc, FaceVerificationState>(
      'retry after rejected starts a brand-new session',
      setUp: () {
        when(
          repo.requestCameraPermission,
        ).thenAnswer((_) async => right(CameraPermissionStatus.granted));
        when(
          repo.startLivenessSession,
        ).thenAnswer((_) async => right(_session));
      },
      build: () => FaceVerificationBloc(repo, _fastConfig),
      seed: () => const FaceVerificationState(
        status: FaceVerificationStatus.rejected,
        rejectReason: 'no match',
      ),
      act: (bloc) => bloc.add(const LivenessRetryRequested()),
      wait: const Duration(milliseconds: 20),
      verify: (bloc) {
        expect(bloc.state.status, FaceVerificationStatus.capturingLiveness);
        expect(bloc.state.rejectReason, isNull);
        verify(repo.startLivenessSession).called(1);
      },
    );
  });
}
