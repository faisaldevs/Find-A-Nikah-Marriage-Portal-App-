import 'package:equatable/equatable.dart';
import 'package:find_a_nikah/features/face_verification/domain/entities/liveness_pose.dart';

/// One capture in the liveness plan. [fieldName] is the multipart field
/// the still is uploaded under — the challenge name the server sent
/// (`front` / `left` / `right`).
///
/// `TODO(api)`: field names unconfirmed — the verify endpoint's request
/// body isn't specified yet.
class LivenessStep extends Equatable {
  const LivenessStep({
    required this.fieldName,
    required this.pose,
  });

  final String fieldName;
  final LivenessPose pose;

  LivenessStep copyWith({
    String? fieldName,
    LivenessPose? pose,
  }) {
    return LivenessStep(
      fieldName: fieldName ?? this.fieldName,
      pose: pose ?? this.pose,
    );
  }

  @override
  List<Object?> get props => [
    fieldName,
    pose,
  ];
}

/// The ordered set of poses a liveness session captures.
///
/// Built from the `challenges` list in `/profile/face-verification/start`'s
/// response; [defaultPlan] only when the server sends none we recognise.
class LivenessStepPlan extends Equatable {
  const LivenessStepPlan({
    required this.steps,
  });

  final List<LivenessStep> steps;

  static const defaultPlan = LivenessStepPlan(
    steps: [
      LivenessStep(fieldName: 'front', pose: LivenessPose.front),
      LivenessStep(fieldName: 'left', pose: LivenessPose.left),
      LivenessStep(fieldName: 'right', pose: LivenessPose.right),
    ],
  );

  LivenessStepPlan copyWith({
    List<LivenessStep>? steps,
  }) {
    return LivenessStepPlan(
      steps: steps ?? this.steps,
    );
  }

  @override
  List<Object?> get props => [
    steps,
  ];
}
