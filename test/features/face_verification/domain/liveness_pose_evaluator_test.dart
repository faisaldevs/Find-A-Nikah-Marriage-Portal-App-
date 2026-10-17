import 'package:find_a_nikah/features/face_verification/domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const evaluator = LivenessPoseEvaluator();

  const goodSnapshot = FaceSnapshot(
    faceCount: 1,
    yaw: 0,
    pitch: 0,
    boxWidthRatio: 0.5,
    boxCenterOffsetRatio: 0,
    leftEyeOpenProbability: 0.9,
    rightEyeOpenProbability: 0.9,
  );

  group('face presence', () {
    test('no face', () {
      const snapshot = FaceSnapshot(faceCount: 0);
      expect(
        evaluator.evaluate(snapshot, LivenessPose.front),
        PoseFeedback.noFace,
      );
    });

    test('multiple faces', () {
      const snapshot = FaceSnapshot(faceCount: 2);
      expect(
        evaluator.evaluate(snapshot, LivenessPose.front),
        PoseFeedback.multipleFaces,
      );
    });
  });

  group('distance', () {
    test('too far (ratio below minFaceRatio)', () {
      final snapshot = goodSnapshot.copyWith(boxWidthRatio: 0.34);
      expect(
        evaluator.evaluate(snapshot, LivenessPose.front),
        PoseFeedback.moveCloser,
      );
    });

    test('right at minFaceRatio passes the distance check', () {
      final snapshot = goodSnapshot.copyWith(boxWidthRatio: 0.35);
      expect(
        evaluator.evaluate(snapshot, LivenessPose.front),
        PoseFeedback.ok,
      );
    });

    test('too close (ratio above maxFaceRatio)', () {
      final snapshot = goodSnapshot.copyWith(boxWidthRatio: 0.71);
      expect(
        evaluator.evaluate(snapshot, LivenessPose.front),
        PoseFeedback.moveBack,
      );
    });

    test('right at maxFaceRatio passes the distance check', () {
      final snapshot = goodSnapshot.copyWith(boxWidthRatio: 0.70);
      expect(
        evaluator.evaluate(snapshot, LivenessPose.front),
        PoseFeedback.ok,
      );
    });

    test('null ratio skips the distance check entirely', () {
      final snapshot = goodSnapshot.copyWith(boxWidthRatio: null);
      expect(
        evaluator.evaluate(snapshot, LivenessPose.front),
        PoseFeedback.ok,
      );
    });
  });

  group('centering', () {
    test('off-center beyond maxCenterOffset', () {
      final snapshot = goodSnapshot.copyWith(boxCenterOffsetRatio: 0.16);
      expect(
        evaluator.evaluate(snapshot, LivenessPose.front),
        PoseFeedback.centerFace,
      );
    });

    test('right at maxCenterOffset passes', () {
      final snapshot = goodSnapshot.copyWith(boxCenterOffsetRatio: 0.15);
      expect(
        evaluator.evaluate(snapshot, LivenessPose.front),
        PoseFeedback.ok,
      );
    });
  });

  group('front pose', () {
    test('yaw beyond frontYawMax', () {
      final snapshot = goodSnapshot.copyWith(yaw: 11);
      expect(
        evaluator.evaluate(snapshot, LivenessPose.front),
        PoseFeedback.lookStraight,
      );
    });

    test('yaw right at frontYawMax passes', () {
      final snapshot = goodSnapshot.copyWith(yaw: 10);
      expect(
        evaluator.evaluate(snapshot, LivenessPose.front),
        PoseFeedback.ok,
      );
    });

    test('pitch beyond frontPitchMax', () {
      final snapshot = goodSnapshot.copyWith(pitch: 13);
      expect(
        evaluator.evaluate(snapshot, LivenessPose.front),
        PoseFeedback.lookStraight,
      );
    });

    test('eyes closed', () {
      final snapshot = goodSnapshot.copyWith(
        leftEyeOpenProbability: 0.1,
        rightEyeOpenProbability: 0.1,
      );
      expect(
        evaluator.evaluate(snapshot, LivenessPose.front),
        PoseFeedback.openEyes,
      );
    });

    test('one eye open is enough', () {
      final snapshot = goodSnapshot.copyWith(
        leftEyeOpenProbability: 0.9,
        rightEyeOpenProbability: 0.1,
      );
      expect(
        evaluator.evaluate(snapshot, LivenessPose.front),
        PoseFeedback.ok,
      );
    });

    test('null eye probabilities never block (signal unavailable)', () {
      final snapshot = goodSnapshot.copyWith(
        leftEyeOpenProbability: null,
        rightEyeOpenProbability: null,
      );
      expect(
        evaluator.evaluate(snapshot, LivenessPose.front),
        PoseFeedback.ok,
      );
    });
  });

  group('turn poses, default yawSign (+1)', () {
    test('left: not turned far enough', () {
      final snapshot = goodSnapshot.copyWith(yaw: 24);
      expect(
        evaluator.evaluate(snapshot, LivenessPose.left),
        PoseFeedback.turnLeft,
      );
    });

    test('left: right at turnYawMin passes', () {
      final snapshot = goodSnapshot.copyWith(yaw: 25);
      expect(
        evaluator.evaluate(snapshot, LivenessPose.left),
        PoseFeedback.ok,
      );
    });

    test('left: turned the wrong way still prompts turnLeft', () {
      final snapshot = goodSnapshot.copyWith(yaw: -25);
      expect(
        evaluator.evaluate(snapshot, LivenessPose.left),
        PoseFeedback.turnLeft,
      );
    });

    test('right: not turned far enough', () {
      final snapshot = goodSnapshot.copyWith(yaw: -24);
      expect(
        evaluator.evaluate(snapshot, LivenessPose.right),
        PoseFeedback.turnRight,
      );
    });

    test('right: right at turnYawMin passes', () {
      final snapshot = goodSnapshot.copyWith(yaw: -25);
      expect(
        evaluator.evaluate(snapshot, LivenessPose.right),
        PoseFeedback.ok,
      );
    });
  });

  group('yawSign flipped (-1)', () {
    const flipped = LivenessPoseEvaluator(
      LivenessConfig(yawSign: -1),
    );

    test('left now requires negative raw yaw', () {
      final snapshot = goodSnapshot.copyWith(yaw: -25);
      expect(flipped.evaluate(snapshot, LivenessPose.left), PoseFeedback.ok);
    });

    test('right now requires positive raw yaw', () {
      final snapshot = goodSnapshot.copyWith(yaw: 25);
      expect(flipped.evaluate(snapshot, LivenessPose.right), PoseFeedback.ok);
    });
  });

  test('priority: no face wins over every other check', () {
    const snapshot = FaceSnapshot(
      faceCount: 0,
      boxWidthRatio: 0.9,
      boxCenterOffsetRatio: 0.9,
    );
    expect(
      evaluator.evaluate(snapshot, LivenessPose.front),
      PoseFeedback.noFace,
    );
  });
}
