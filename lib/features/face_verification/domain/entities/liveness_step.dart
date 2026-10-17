import 'package:find_a_nikah/features/face_verification/domain/entities/liveness_pose.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'liveness_step.freezed.dart';

/// One capture in the liveness plan. [fieldName] is the multipart field
/// the still is uploaded under — the challenge name the server sent
/// (`front` / `left` / `right`).
///
/// `TODO(api)`: field names unconfirmed — the verify endpoint's request
/// body isn't specified yet.
@freezed
abstract class LivenessStep with _$LivenessStep {
  const factory LivenessStep({
    required String fieldName,
    required LivenessPose pose,
  }) = _LivenessStep;
}

/// The ordered set of poses a liveness session captures.
///
/// Built from the `challenges` list in `/profile/face-verification/start`'s
/// response; [defaultPlan] only when the server sends none we recognise.
@freezed
abstract class LivenessStepPlan with _$LivenessStepPlan {
  const factory LivenessStepPlan({required List<LivenessStep> steps}) =
      _LivenessStepPlan;

  const LivenessStepPlan._();

  static const defaultPlan = LivenessStepPlan(
    steps: [
      LivenessStep(fieldName: 'front', pose: LivenessPose.front),
      LivenessStep(fieldName: 'left', pose: LivenessPose.left),
      LivenessStep(fieldName: 'right', pose: LivenessPose.right),
    ],
  );
}
