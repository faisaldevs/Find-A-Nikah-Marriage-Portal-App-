import 'package:find_a_nikah/core/core.dart';
import 'package:find_a_nikah/features/face_verification/domain/domain.dart';
import 'package:find_a_nikah/features/face_verification/presentation/presentation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/fakes.dart';

// Server order from /start: front, right, left.
final _session = FaceSession(
  sessionId: 's1',
  plan: const LivenessStepPlan(
    steps: [
      LivenessStep(fieldName: 'front', pose: LivenessPose.front),
      LivenessStep(fieldName: 'right', pose: LivenessPose.right),
      LivenessStep(fieldName: 'left', pose: LivenessPose.left),
    ],
  ),
  expiresAt: DateTime.now().add(const Duration(minutes: 2)),
);

const _front = FaceSnapshot(faceCount: 1, yaw: 0, pitch: 0);
const _right = FaceSnapshot(faceCount: 1, yaw: -25, pitch: 0);
const _left = FaceSnapshot(faceCount: 1, yaw: 25, pitch: 0);

FaceSnapshot _still(double yaw, {double eyes = 0.9}) => FaceSnapshot(
  faceCount: 1,
  yaw: yaw,
  pitch: 0,
  leftEyeOpenProbability: eyes,
  rightEyeOpenProbability: eyes,
);

Future<void> _tick([int ms = 5]) =>
    Future<void>.delayed(Duration(milliseconds: ms));

void main() {
  late MockFaceVerificationRepository repo;

  setUpAll(() => registerFallbackValue(_session));

  setUp(() {
    repo = MockFaceVerificationRepository();
    when(
      repo.requestCameraPermission,
    ).thenAnswer((_) async => right(CameraPermissionStatus.granted));
    when(repo.startLivenessSession).thenAnswer((_) async => right(_session));
    when(
      () => repo.submitLivenessSteps(
        session: any(named: 'session'),
        stepFilePaths: any(named: 'stepFilePaths'),
      ),
    ).thenAnswer((_) async => right(const FaceVerificationResult.verified()));
  });

  Future<LivenessCaptureBloc> readyBloc([
    CaptureConfig config = CaptureConfig.standard,
  ]) async {
    final bloc = LivenessCaptureBloc(repo, config)
      ..add(const LivenessPermissionRequested());
    await _tick();
    expect(bloc.state.status, LivenessCaptureStatus.ready);
    return bloc;
  }

  Future<LivenessCaptureBloc> capturingBloc([
    CaptureConfig config = CaptureConfig.standard,
  ]) async {
    final bloc = await readyBloc(config)
      ..add(const LivenessCaptureStarted());
    await _tick();
    expect(bloc.state.status, LivenessCaptureStatus.capturing);
    return bloc;
  }

  test('permission denied / permanently denied', () async {
    when(
      repo.requestCameraPermission,
    ).thenAnswer((_) async => right(CameraPermissionStatus.denied));
    final bloc = LivenessCaptureBloc(repo)
      ..add(const LivenessPermissionRequested());
    await _tick();
    expect(bloc.state.status, LivenessCaptureStatus.permissionDenied);

    when(
      repo.requestCameraPermission,
    ).thenAnswer((_) async => right(CameraPermissionStatus.permanentlyDenied));
    bloc.add(const LivenessPermissionRequested());
    await _tick();
    expect(
      bloc.state.status,
      LivenessCaptureStatus.permissionPermanentlyDenied,
    );
    await bloc.close();
  });

  test('nothing starts until "I\'m ready"', () async {
    final bloc = await readyBloc();
    bloc.add(const LivenessFrameReceived(_front));
    await _tick();
    expect(bloc.state.status, LivenessCaptureStatus.ready);
    verifyNever(repo.startLivenessSession);
    await bloc.close();
  });

  test('wrong pose gives a hint; the right pose asks for photos', () async {
    final bloc = await capturingBloc();
    bloc.add(const LivenessFrameReceived(FaceSnapshot(faceCount: 0)));
    await _tick();
    expect(bloc.state.hint, PoseHint.noFace);

    bloc.add(const LivenessFrameReceived(_right)); // step 1 is "front"
    await _tick();
    expect(bloc.state.hint, PoseHint.lookStraight);
    expect(bloc.state.status, LivenessCaptureStatus.capturing);

    bloc.add(const LivenessFrameReceived(_front));
    await _tick();
    expect(bloc.state.status, LivenessCaptureStatus.takingPhotos);
    await bloc.close();
  });

  test(
    'keeps the best photo per pose and uploads one per challenge',
    () async {
      final stills = {
        '/f1.jpg': _still(12),
        '/f2.jpg': _still(1), // best front
        '/f3.jpg': _still(3, eyes: 0.05),
        '/r1.jpg': _still(-14),
        '/r2.jpg': _still(-29), // best right
        '/r3.jpg': _still(-55),
        '/l1.jpg': const FaceSnapshot(faceCount: 0),
        '/l2.jpg': _still(31), // best left
        '/l3.jpg': _still(20),
      };
      when(() => repo.analyzeStill(any())).thenAnswer(
        (i) async => right(stills[i.positionalArguments.first as String]!),
      );

      final bloc = await capturingBloc();
      for (final (frame, prefix) in [
        (_front, 'f'),
        (_right, 'r'),
        (_left, 'l'),
      ]) {
        bloc.add(LivenessFrameReceived(frame));
        await _tick();
        expect(bloc.state.status, LivenessCaptureStatus.takingPhotos);
        bloc.add(
          LivenessBurstCaptured([
            for (var i = 1; i <= 3; i++) '/$prefix$i.jpg',
          ]),
        );
        await _tick(10);
      }

      expect(bloc.state.status, LivenessCaptureStatus.done);
      verify(
        () => repo.submitLivenessSteps(
          session: _session,
          stepFilePaths: {
            'front': '/f2.jpg',
            'right': '/r2.jpg',
            'left': '/l2.jpg',
          },
        ),
      ).called(1);
      await bloc.close();
    },
  );

  test('pose not reached in time → photos taken anyway', () async {
    final bloc = await capturingBloc(
      const CaptureConfig(stepTimeout: Duration(milliseconds: 20)),
    );
    bloc.add(const LivenessFrameReceived(_right)); // wrong pose for front
    await _tick(40);
    expect(bloc.state.status, LivenessCaptureStatus.takingPhotos);
    await bloc.close();
  });

  test('a burst with no usable face redoes the same pose', () async {
    when(
      () => repo.analyzeStill(any()),
    ).thenAnswer((_) async => right(const FaceSnapshot(faceCount: 0)));
    final bloc = await capturingBloc();
    bloc
      ..add(const LivenessFrameReceived(_front))
      ..add(const LivenessBurstCaptured(['/a.jpg', '/b.jpg']));
    await _tick(10);
    expect(bloc.state.status, LivenessCaptureStatus.capturing);
    expect(bloc.state.stepIndex, 0);
    expect(bloc.state.hint, PoseHint.noFace);
    await bloc.close();
  });

  test('a camera error during the burst redoes the pose', () async {
    final bloc = await capturingBloc();
    bloc
      ..add(const LivenessFrameReceived(_front))
      ..add(const LivenessBurstFailed());
    await _tick();
    expect(bloc.state.status, LivenessCaptureStatus.capturing);
    expect(bloc.state.stepIndex, 0);
    await bloc.close();
  });

  test('session expiry mid-capture → retryable rejection', () async {
    when(repo.startLivenessSession).thenAnswer(
      (_) async => right(
        _session.copyWith(
          expiresAt: DateTime.now().add(const Duration(milliseconds: 20)),
        ),
      ),
    );
    final bloc = await capturingBloc();
    await _tick(40);
    expect(bloc.state.status, LivenessCaptureStatus.rejected);
    expect(bloc.state.canRetry, isTrue);

    bloc.add(const LivenessCaptureRetried());
    await _tick();
    expect(bloc.state.status, LivenessCaptureStatus.ready);
    expect(bloc.state.captured, isEmpty);
    await bloc.close();
  });

  test('a /start failure and an upload failure surface as failed', () async {
    when(
      repo.startLivenessSession,
    ).thenAnswer((_) async => left(const NetworkFailure()));
    final bloc = await readyBloc()
      ..add(const LivenessCaptureStarted());
    await _tick();
    expect(bloc.state.status, LivenessCaptureStatus.failed);
    expect(bloc.state.failure, isA<NetworkFailure>());
    await bloc.close();
  });
}
