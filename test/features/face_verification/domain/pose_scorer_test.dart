import 'package:find_a_nikah/features/face_verification/domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';

FaceSnapshot _face({
  double yaw = 0,
  double pitch = 0,
  double? eyes = 0.9,
}) => FaceSnapshot(
  faceCount: 1,
  yaw: yaw,
  pitch: pitch,
  leftEyeOpenProbability: eyes,
  rightEyeOpenProbability: eyes,
);

void main() {
  const scorer = PoseScorer();

  group('check (live gate)', () {
    test('no face / several faces', () {
      expect(
        scorer.check(const FaceSnapshot(faceCount: 0), LivenessPose.front),
        PoseHint.noFace,
      );
      expect(
        scorer.check(const FaceSnapshot(faceCount: 2), LivenessPose.front),
        PoseHint.multipleFaces,
      );
    });

    test('front accepts a roughly straight face only', () {
      expect(scorer.check(_face(yaw: 10), LivenessPose.front), PoseHint.ok);
      expect(
        scorer.check(_face(yaw: 25), LivenessPose.front),
        PoseHint.lookStraight,
      );
      expect(
        scorer.check(_face(pitch: 25), LivenessPose.front),
        PoseHint.lookStraight,
      );
    });

    test('left/right need a 15° turn in their own direction', () {
      // yawSign 1: positive = the user's own left.
      expect(scorer.check(_face(yaw: 18), LivenessPose.left), PoseHint.ok);
      expect(
        scorer.check(_face(yaw: 10), LivenessPose.left),
        PoseHint.turnMore,
      );
      expect(
        scorer.check(_face(yaw: -18), LivenessPose.left),
        PoseHint.turnMore,
      );
      expect(scorer.check(_face(yaw: -18), LivenessPose.right), PoseHint.ok);
      expect(
        scorer.check(_face(yaw: 18), LivenessPose.right),
        PoseHint.turnMore,
      );
    });

    test('yawSign flips the direction', () {
      const flipped = PoseScorer(CaptureConfig(yawSign: -1));
      expect(flipped.check(_face(yaw: -18), LivenessPose.left), PoseHint.ok);
      expect(flipped.check(_face(yaw: 18), LivenessPose.right), PoseHint.ok);
    });
  });

  group('stillScore (best of burst)', () {
    test('unusable photos score null', () {
      expect(
        scorer.stillScore(const FaceSnapshot(faceCount: 0), LivenessPose.front),
        isNull,
      );
      expect(
        scorer.stillScore(const FaceSnapshot(faceCount: 2), LivenessPose.left),
        isNull,
      );
    });

    test('front prefers the straightest, eyes-open shot', () {
      final straight = scorer.stillScore(_face(yaw: 2), LivenessPose.front)!;
      final angled = scorer.stillScore(_face(yaw: 12), LivenessPose.front)!;
      final blinking = scorer.stillScore(
        _face(yaw: 2, eyes: 0.05),
        LivenessPose.front,
      )!;
      expect(straight, greaterThan(angled));
      expect(straight, greaterThan(blinking));
    });

    test('sides prefer ~30° regardless of sign (mirroring-safe)', () {
      final ideal = scorer.stillScore(_face(yaw: 30), LivenessPose.right)!;
      final idealMirrored = scorer.stillScore(
        _face(yaw: -30),
        LivenessPose.right,
      )!;
      final tooLittle = scorer.stillScore(_face(yaw: 12), LivenessPose.right)!;
      final tooMuch = scorer.stillScore(_face(yaw: 60), LivenessPose.right)!;
      expect(ideal, idealMirrored);
      expect(ideal, greaterThan(tooLittle));
      expect(ideal, greaterThan(tooMuch));
    });
  });
}
