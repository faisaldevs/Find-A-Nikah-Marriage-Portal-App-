import 'dart:async';
import 'dart:math' as math;

import 'package:camera/camera.dart';
import 'package:find_a_nikah/core/ui/ui.dart';
import 'package:find_a_nikah/features/face_verification/domain/domain.dart';
import 'package:find_a_nikah/features/face_verification/presentation/bloc/liveness_capture_bloc.dart';
import 'package:find_a_nikah/features/face_verification/presentation/services/liveness_camera_controller.dart';
import 'package:find_a_nikah/router/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';

/// Guided face photos: a round camera view with a 3-segment progress ring
/// and one clear instruction at a time ("Look straight at the camera",
/// "Turn your head to the right", …, in the `/start` challenge order).
/// Each pose takes a short burst and keeps the clearest photo; the three
/// photos are then uploaded for backend verification.
///
/// Driven by [LivenessCaptureBloc] (provided by the route). The camera
/// lifecycle is owned here — see `LivenessCameraController`.
class LivenessCapturePage extends StatefulWidget {
  const LivenessCapturePage({super.key});

  @override
  State<LivenessCapturePage> createState() => _LivenessCapturePageState();
}

class _LivenessCapturePageState extends State<LivenessCapturePage>
    with WidgetsBindingObserver {
  final _camera = LivenessCameraController();
  StreamSubscription<FaceSnapshot>? _frames;
  bool _cameraReady = false;
  bool _cameraStarting = false;

  LivenessCaptureBloc get _bloc => context.read<LivenessCaptureBloc>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _bloc.add(const LivenessPermissionRequested());
  }

  Future<void> _startCamera() async {
    if (_cameraReady || _cameraStarting) return;
    _cameraStarting = true;
    try {
      await _camera.initialize();
    } on Object {
      _cameraStarting = false;
      if (mounted) _bloc.add(const LivenessCameraUnavailable());
      return;
    }
    _cameraStarting = false;
    if (!mounted) return;
    setState(() => _cameraReady = true);
    await _frames?.cancel();
    _frames = _camera.snapshots.listen((frame) {
      if (mounted) _bloc.add(LivenessFrameReceived(frame));
    });
  }

  Future<void> _stopCamera() async {
    await _frames?.cancel();
    _frames = null;
    if (mounted) setState(() => _cameraReady = false);
    await _camera.dispose();
  }

  Future<void> _takeBurst(int count) async {
    final bloc = _bloc;
    try {
      final paths = await _camera.captureBurst(count);
      unawaited(HapticFeedback.mediumImpact());
      bloc.add(LivenessBurstCaptured(paths));
    } on Object {
      bloc.add(const LivenessBurstFailed());
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
        // Also fires for the iOS permission prompt — harmless, the camera
        // isn't open yet then.
        if (_cameraReady) unawaited(_stopCamera());
      case AppLifecycleState.resumed:
        if (_bloc.state.cameraActive) unawaited(_startCamera());
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
        break;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    unawaited(_frames?.cancel());
    unawaited(_camera.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LivenessCaptureBloc, LivenessCaptureState>(
      listenWhen: (prev, next) => prev.status != next.status,
      listener: (context, state) {
        switch (state.status) {
          case LivenessCaptureStatus.ready:
            unawaited(_startCamera());
          case LivenessCaptureStatus.takingPhotos:
            unawaited(_takeBurst(CaptureConfig.standard.burstCount));
          case LivenessCaptureStatus.done:
            // Replace, don't push: disposing this page releases the camera.
            context.pushReplacement(RoutePaths.photoVerification);
          case LivenessCaptureStatus.requestingPermission:
          case LivenessCaptureStatus.permissionDenied:
          case LivenessCaptureStatus.permissionPermanentlyDenied:
          case LivenessCaptureStatus.startingSession:
          case LivenessCaptureStatus.capturing:
          case LivenessCaptureStatus.choosingPhoto:
          case LivenessCaptureStatus.submitting:
          case LivenessCaptureStatus.rejected:
          case LivenessCaptureStatus.failed:
            break;
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: BlocBuilder<LivenessCaptureBloc, LivenessCaptureState>(
            builder: (context, state) => switch (state.status) {
              LivenessCaptureStatus.permissionDenied => _MessageView(
                icon: Icons.videocam_off_outlined,
                message:
                    'We need camera access to take your verification '
                    'photos. Please allow it to continue.',
                ctaLabel: 'Try again',
                onCta: () => _bloc.add(const LivenessPermissionRequested()),
              ),
              LivenessCaptureStatus.permissionPermanentlyDenied =>
                const _MessageView(
                  icon: Icons.videocam_off_outlined,
                  message:
                      'Camera access is turned off for Find A Nikah. Enable '
                      'it in Settings to continue verification.',
                  ctaLabel: 'Open settings',
                  onCta: openAppSettings,
                ),
              LivenessCaptureStatus.rejected => _MessageView(
                icon: Icons.error_outline,
                message:
                    state.rejectReason ??
                    "We couldn't verify your photos. Please try again.",
                ctaLabel: state.canRetry ? 'Try again' : null,
                onCta: state.canRetry
                    ? () => _bloc.add(const LivenessCaptureRetried())
                    : null,
              ),
              LivenessCaptureStatus.failed => _MessageView(
                icon: Icons.error_outline,
                message: state.failure?.message ?? 'Something went wrong.',
                ctaLabel: 'Try again',
                onCta: () {
                  // A camera failure needs the camera reopened too.
                  unawaited(_startCamera());
                  _bloc.add(const LivenessCaptureRetried());
                },
              ),
              _ => _CaptureView(
                state: state,
                controller: _cameraReady ? _camera.cameraController : null,
                onReady: () => _bloc.add(const LivenessCaptureStarted()),
              ),
            },
          ),
        ),
      ),
    );
  }
}

class _CaptureView extends StatelessWidget {
  const _CaptureView({
    required this.state,
    required this.controller,
    required this.onReady,
  });

  final LivenessCaptureState state;
  final CameraController? controller;
  final VoidCallback onReady;

  @override
  Widget build(BuildContext context) {
    final steps = state.plan.steps;
    final step = state.currentStep;
    final ready =
        state.status == LivenessCaptureStatus.ready ||
        state.status == LivenessCaptureStatus.requestingPermission;
    final submitting = state.status == LivenessCaptureStatus.submitting;
    final diameter = math.min(1.sw * 0.72, 300.r);

    final String title;
    if (ready || state.status == LivenessCaptureStatus.startingSession) {
      title = 'Position your face in the circle';
    } else if (submitting || step == null) {
      title = 'Uploading your photos…';
    } else {
      title = step.pose.instruction;
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        children: [
          SizedBox(height: 24.h),
          Text(
            ready || submitting || step == null
                ? 'Face verification'
                : 'Step ${state.stepIndex + 1} of ${steps.length}',
            style: TextFontStyle.headline14w600StyleSatoshi.copyWith(
              color: AppColors.textMuted,
            ),
          ),
          SizedBox(height: 8.h),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: Text(
              title,
              key: ValueKey(title),
              textAlign: TextAlign.center,
              style: TextFontStyle.headline22w700textDarkStyleSatoshi,
            ),
          ),
          SizedBox(height: 12.h),
          SizedBox(
            height: 32.r,
            child: !ready && !submitting && step != null
                ? _DirectionCue(pose: step.pose)
                : null,
          ),
          SizedBox(height: 16.h),
          _CameraCircle(
            diameter: diameter,
            controller: controller,
            segments: steps.length,
            completed: state.captured.length,
            // Flash once the shots are taken — a white screen during the
            // capture lit the face and overexposed the front-camera stills.
            // flashing: state.status == LivenessCaptureStatus.takingPhotos,
            flashing: state.status == LivenessCaptureStatus.choosingPhoto,
            busy:
                submitting ||
                state.status == LivenessCaptureStatus.startingSession ||
                controller == null,
          ),
          SizedBox(height: 20.h),
          if (!ready && !submitting)
            Text(
              state.hint?.message ?? '',
              textAlign: TextAlign.center,
              style: TextFontStyle.headline15w400textMutedStyleSatoshi,
            ),
          const Spacer(),
          if (ready) ...[
            Text(
              'Good light, nothing covering your face, and hold the phone '
              'at eye level.',
              textAlign: TextAlign.center,
              style: TextFontStyle.headline13w400textMutedStyleSatoshi.copyWith(
                height: 1.4,
              ),
            ),
            SizedBox(height: 16.h),
            AppPrimaryButton(
              label: "I'm ready",
              onPressed:
                  state.status == LivenessCaptureStatus.ready &&
                      controller != null
                  ? onReady
                  : null,
            ),
          ],
          SizedBox(height: 24.h),
        ],
      ),
    );
  }
}

/// Front camera clipped to a circle, with the step ring around it.
class _CameraCircle extends StatelessWidget {
  const _CameraCircle({
    required this.diameter,
    required this.controller,
    required this.segments,
    required this.completed,
    required this.flashing,
    required this.busy,
  });

  final double diameter;
  final CameraController? controller;
  final int segments;
  final int completed;
  final bool flashing;
  final bool busy;

  @override
  Widget build(BuildContext context) {
    final ringWidth = 6.r;
    final controller = this.controller;
    return SizedBox.square(
      dimension: diameter + ringWidth * 4,
      child: CustomPaint(
        painter: _StepRingPainter(
          segments: segments,
          completed: completed,
          strokeWidth: ringWidth,
        ),
        child: Center(
          child: ClipOval(
            child: SizedBox.square(
              dimension: diameter,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (controller != null && controller.value.isInitialized)
                    // Cover-fit the (portrait) preview into the circle.
                    // `TODO(device)`: confirm the front preview is mirrored
                    // on both platforms, so "turn right" moves right.
                    FittedBox(
                      fit: BoxFit.cover,
                      child: SizedBox(
                        width: diameter,
                        height: diameter * controller.value.aspectRatio,
                        child: CameraPreview(controller),
                      ),
                    )
                  else
                    ColoredBox(color: Colors.grey.shade200),
                  // Brief white flash while the burst is taken.
                  AnimatedOpacity(
                    opacity: flashing ? 0.6 : 0,
                    duration: const Duration(milliseconds: 150),
                    child: const ColoredBox(color: Colors.white),
                  ),
                  if (busy)
                    const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryColor,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// One arc per pose: done = green, current = brand, pending = grey.
class _StepRingPainter extends CustomPainter {
  _StepRingPainter({
    required this.segments,
    required this.completed,
    required this.strokeWidth,
  });

  final int segments;
  final int completed;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    if (segments <= 0) return;
    final rect = (Offset.zero & size).deflate(strokeWidth);
    const gap = 0.12; // radians between segments
    final sweep = (2 * math.pi) / segments;
    for (var i = 0; i < segments; i++) {
      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round
        ..color = i < completed
            ? AppColors.successColor
            : i == completed
            ? AppColors.primaryColor
            : Colors.grey.shade300;
      canvas.drawArc(
        rect,
        -math.pi / 2 + i * sweep + gap / 2,
        sweep - gap,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _StepRingPainter old) =>
      old.segments != segments ||
      old.completed != completed ||
      old.strokeWidth != strokeWidth;
}

/// Nudging arrow for the turn steps (on the mirrored preview the user's
/// own right is screen right); a small face icon for "front".
class _DirectionCue extends StatefulWidget {
  const _DirectionCue({required this.pose});

  final LivenessPose pose;

  @override
  State<_DirectionCue> createState() => _DirectionCueState();
}

class _DirectionCueState extends State<_DirectionCue>
    with SingleTickerProviderStateMixin {
  late final AnimationController _nudge = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 700),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _nudge.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final icon = switch (widget.pose) {
      LivenessPose.front => Icons.face_outlined,
      LivenessPose.right => Icons.arrow_forward_rounded,
      LivenessPose.left => Icons.arrow_back_rounded,
    };
    final direction = switch (widget.pose) {
      LivenessPose.front => 0.0,
      LivenessPose.right => 1.0,
      LivenessPose.left => -1.0,
    };
    return AnimatedBuilder(
      animation: _nudge,
      builder: (_, child) => Transform.translate(
        offset: Offset(direction * 10.w * _nudge.value, 0),
        child: child,
      ),
      child: Icon(icon, size: 32.r, color: AppColors.primaryColor),
    );
  }
}

class _MessageView extends StatelessWidget {
  const _MessageView({
    required this.icon,
    required this.message,
    required this.ctaLabel,
    required this.onCta,
  });

  final IconData icon;
  final String message;
  final String? ctaLabel;
  final VoidCallback? onCta;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48.r, color: AppColors.textMuted),
            SizedBox(height: 16.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextFontStyle.headline15w400textMutedStyleSatoshi.copyWith(
                height: 1.4,
              ),
            ),
            if (ctaLabel != null) ...[
              SizedBox(height: 20.h),
              AppPrimaryButton(label: ctaLabel!, onPressed: onCta),
            ],
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────
// Previous version (hold-to-capture against FaceVerificationBloc's
// Liveness* events): strict distance/centre/hold checks made the movement
// hard to match. Superseded by the guided burst capture above.
// ─────────────────────────────────────────────────────────────────────────
// import 'dart:async';
//
// import 'package:camera/camera.dart';
// import 'package:find_a_nikah/core/ui/ui.dart';
// import 'package:find_a_nikah/features/face_verification/domain/domain.dart';
// import 'package:find_a_nikah/features/face_verification/presentation/bloc/face_verification_bloc.dart';
// import 'package:find_a_nikah/features/face_verification/presentation/services/liveness_camera_controller.dart';
// import 'package:find_a_nikah/router/route_paths.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
// import 'package:go_router/go_router.dart';
// import 'package:permission_handler/permission_handler.dart';
//
// /// Guided 3-pose liveness capture (`livenessEnabled`): full-screen front
// /// camera with a pose-feedback oval, auto-capturing each step on a hold.
// /// Lives inside the face-verification `ShellRoute`, so it shares the one
// /// `FaceVerificationBloc` — camera lifecycle itself is owned here (a
// /// widget-tree concern), not by the bloc; see `LivenessCameraController`'s
// /// doc comment for why.
// class LivenessCapturePage extends StatefulWidget {
//   const LivenessCapturePage({super.key});
//
//   @override
//   State<LivenessCapturePage> createState() => _LivenessCapturePageState();
// }
//
// class _LivenessCapturePageState extends State<LivenessCapturePage>
//     with WidgetsBindingObserver {
//   final _camera = LivenessCameraController();
//   bool _cameraReady = false;
//
//   /// So a step-to-step `capturingLiveness` re-entry (after each capture)
//   /// doesn't re-open the camera — only the first arrival, and a resume
//   /// after backgrounding, should.
//   bool _cameraStarted = false;
//   StreamSubscription<FaceSnapshot>? _snapshots;
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addObserver(this);
//     context.read<FaceVerificationBloc>().add(
//       const LivenessSessionStartRequested(),
//     );
//   }
//
//   Future<void> _startCamera() async {
//     _cameraStarted = true;
//     try {
//       await _camera.initialize();
//     } on Object {
//       // Let a retry (LivenessRetryRequested → capturingLiveness) open it
//       // again.
//       _cameraStarted = false;
//       if (mounted) {
//         context.read<FaceVerificationBloc>().add(
//           const LivenessCameraFailed(),
//         );
//       }
//       return;
//     }
//     if (!mounted) return;
//     setState(() => _cameraReady = true);
//     await _snapshots?.cancel();
//     _snapshots = _camera.snapshots.listen((snapshot) {
//       if (!mounted) return;
//       context.read<FaceVerificationBloc>().add(
//         LivenessSnapshotReceived(snapshot),
//       );
//     });
//   }
//
//   Future<void> _captureStill() async {
//     final bloc = context.read<FaceVerificationBloc>();
//     final String path;
//     try {
//       path = await _camera.captureStill();
//     } on Object {
//       // Don't leave the bloc parked in capturingLivenessStill.
//       bloc.add(const LivenessStillCaptureFailed());
//       return;
//     }
//     unawaited(HapticFeedback.lightImpact());
//     bloc.add(LivenessStillCaptured(path));
//   }
//
//   /// Only a capture in progress needs the camera back after a resume — not
//   /// the permission prompt (which itself fires inactive → resumed on iOS)
//   /// or an error/result screen.
//   bool get _capturing =>
//       switch (context.read<FaceVerificationBloc>().state.status) {
//         FaceVerificationStatus.capturingLiveness ||
//         FaceVerificationStatus.capturingLivenessStill => true,
//         _ => false,
//       };
//
//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     switch (state) {
//       case AppLifecycleState.paused:
//       case AppLifecycleState.inactive:
//         _cameraStarted = false;
//         setState(() => _cameraReady = false);
//         unawaited(_camera.dispose());
//       case AppLifecycleState.resumed:
//         if (!_cameraReady && !_cameraStarted && _capturing) {
//           unawaited(_startCamera());
//         }
//       case AppLifecycleState.detached:
//       case AppLifecycleState.hidden:
//         break;
//     }
//   }
//
//   @override
//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this);
//     unawaited(_snapshots?.cancel());
//     unawaited(_camera.dispose());
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocListener<FaceVerificationBloc, FaceVerificationState>(
//       listenWhen: (prev, next) => prev.status != next.status,
//       listener: (context, state) {
//         if (state.status == FaceVerificationStatus.capturingLiveness &&
//             !_cameraStarted) {
//           unawaited(_startCamera());
//         } else if (state.status ==
//             FaceVerificationStatus.capturingLivenessStill) {
//           unawaited(_captureStill());
//         } else if (state.status == FaceVerificationStatus.underReview) {
//           // Replace, don't push: disposing this page releases the camera
//           // instead of leaving it streaming under the result page.
//           context.pushReplacement(RoutePaths.photoVerification);
//         }
//       },
//       child: Scaffold(
//         backgroundColor: Colors.black,
//         body: SafeArea(
//           child: BlocBuilder<FaceVerificationBloc, FaceVerificationState>(
//             builder: (context, state) => _Body(
//               state: state,
//               camera: _camera,
//               cameraReady: _cameraReady,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class _Body extends StatelessWidget {
//   const _Body({
//     required this.state,
//     required this.camera,
//     required this.cameraReady,
//   });
//
//   final FaceVerificationState state;
//   final LivenessCameraController camera;
//   final bool cameraReady;
//
//   @override
//   Widget build(BuildContext context) {
//     switch (state.status) {
//       case FaceVerificationStatus.cameraPermissionDenied:
//         return _PermissionBanner(
//           message:
//               "We need camera access to verify it's you. Please allow it "
//               'to continue.',
//           ctaLabel: 'Try again',
//           onCta: () => context.read<FaceVerificationBloc>().add(
//             const LivenessSessionStartRequested(),
//           ),
//         );
//       case FaceVerificationStatus.cameraPermissionPermanentlyDenied:
//         return const _PermissionBanner(
//           message:
//               'Camera access is turned off for Find A Nikah. Enable it in '
//               'Settings to continue verification.',
//           ctaLabel: 'Open settings',
//           onCta: openAppSettings,
//         );
//       case FaceVerificationStatus.rejected:
//         return _PermissionBanner(
//           message:
//               state.rejectReason ??
//               "We couldn't verify your photos. Please try again.",
//           ctaLabel: state.canRetry ? 'Try again' : null,
//           onCta: state.canRetry
//               ? () => context.read<FaceVerificationBloc>().add(
//                   const LivenessRetryRequested(),
//                 )
//               : null,
//         );
//       case FaceVerificationStatus.failed:
//         return _PermissionBanner(
//           message: state.failure == null
//               ? 'Something went wrong.'
//               : state.failure!.message,
//           ctaLabel: 'Try again',
//           onCta: () => context.read<FaceVerificationBloc>().add(
//             const LivenessRetryRequested(),
//           ),
//         );
//       case FaceVerificationStatus.idle:
//       case FaceVerificationStatus.checkingSelfie:
//       case FaceVerificationStatus.selfieReady:
//       case FaceVerificationStatus.submitting:
//       case FaceVerificationStatus.underReview:
//       case FaceVerificationStatus.startingLivenessSession:
//       case FaceVerificationStatus.capturingLiveness:
//       case FaceVerificationStatus.capturingLivenessStill:
//       case FaceVerificationStatus.submittingLiveness:
//         return _CameraView(state: state, camera: camera, ready: cameraReady);
//     }
//   }
// }
//
// class _PermissionBanner extends StatelessWidget {
//   const _PermissionBanner({
//     required this.message,
//     required this.ctaLabel,
//     required this.onCta,
//   });
//
//   final String message;
//   final String? ctaLabel;
//   final VoidCallback? onCta;
//
//   @override
//   Widget build(BuildContext context) {
//     return ColoredBox(
//       color: Colors.white,
//       child: Center(
//         child: Padding(
//           padding: EdgeInsets.symmetric(horizontal: 24.w),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Icon(
//                 Icons.videocam_off_outlined,
//                 size: 48.r,
//                 color: AppColors.textMuted,
//               ),
//               SizedBox(height: 16.h),
//               Text(
//                 message,
//                 textAlign: TextAlign.center,
//                 style: TextFontStyle.headline15w400textMutedStyleSatoshi
//                     .copyWith(height: 1.4),
//               ),
//               if (ctaLabel != null) ...[
//                 SizedBox(height: 20.h),
//                 AppPrimaryButton(label: ctaLabel!, onPressed: onCta),
//               ],
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class _CameraView extends StatelessWidget {
//   const _CameraView({
//     required this.state,
//     required this.camera,
//     required this.ready,
//   });
//
//   final FaceVerificationState state;
//   final LivenessCameraController camera;
//   final bool ready;
//
//   @override
//   Widget build(BuildContext context) {
//     final controller = camera.cameraController;
//     final step = state.currentLivenessStep;
//     final feedback = state.poseFeedback;
//
//     return Stack(
//       fit: StackFit.expand,
//       children: [
//         if (ready && controller != null && controller.value.isInitialized)
//           Transform(
//             alignment: Alignment.center,
//             // Mirror the front camera so "turn left" visually matches.
//             transform: Matrix4.rotationY(3.14159),
//             child: CameraPreview(controller),
//           )
//         else
//           const ColoredBox(color: Colors.black),
//         Container(color: Colors.black.withValues(alpha: 0.35)),
//         Center(
//           child: CustomPaint(
//             painter: _PoseOvalPainter(
//               progress: state.holdProgress,
//               ok: feedback == PoseFeedback.ok,
//             ),
//             child: SizedBox(width: 260.w, height: 340.h),
//           ),
//         ),
//         Positioned(
//           top: 16.h,
//           left: 0,
//           right: 0,
//           child: Text(
//             step == null
//                 ? ''
//                 : 'Step ${state.currentStepIndex + 1}/${state.plan.steps.length}',
//             textAlign: TextAlign.center,
//             style: TextFontStyle.headline14w600StyleSatoshi.copyWith(
//               color: Colors.white,
//             ),
//           ),
//         ),
//         Positioned(
//           bottom: 48.h,
//           left: 24.w,
//           right: 24.w,
//           child: Column(
//             children: [
//               Text(
//                 feedback?.message ?? 'Finding your face…',
//                 textAlign: TextAlign.center,
//                 style: TextFontStyle.headline18w500textWhiteStyleSatoshi,
//               ),
//               if (state.stepTimedOut) ...[
//                 SizedBox(height: 16.h),
//                 TextButton(
//                   onPressed: () => context.read<FaceVerificationBloc>().add(
//                     const LivenessStepRetryRequested(),
//                   ),
//                   child: const Text(
//                     'Try again',
//                     style: TextStyle(color: Colors.white),
//                   ),
//                 ),
//               ],
//               if (kDebugMode) ...[
//                 SizedBox(height: 12.h),
//                 Text(
//                   'feedback=${state.poseFeedback} '
//                   'progress=${state.holdProgress.toStringAsFixed(2)}',
//                   style: const TextStyle(
//                     color: Colors.white54,
//                     fontSize: 11,
//                   ),
//                 ),
//               ],
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
//
// /// Dashed-when-waiting, solid-green-when-ok oval with a hold-progress
// /// ring. Private to this page, like the other dashed-circle/-border
// /// painters elsewhere in `face_verification`/`onboarding`.
// class _PoseOvalPainter extends CustomPainter {
//   _PoseOvalPainter({required this.progress, required this.ok});
//
//   final double progress;
//   final bool ok;
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     final rect = Offset.zero & size;
//     final base = Paint()
//       ..color = ok ? Colors.greenAccent : Colors.white70
//       ..strokeWidth = 3
//       ..style = PaintingStyle.stroke;
//     canvas.drawOval(rect.deflate(3), base);
//
//     if (progress > 0) {
//       final ring = Paint()
//         ..color = Colors.greenAccent
//         ..strokeWidth = 5
//         ..style = PaintingStyle.stroke
//         ..strokeCap = StrokeCap.round;
//       canvas.drawArc(
//         rect.deflate(3),
//         -1.5708, // -90deg, start at top
//         progress * 6.28319,
//         false,
//         ring,
//       );
//     }
//   }
//
//   @override
//   bool shouldRepaint(covariant _PoseOvalPainter oldDelegate) =>
//       oldDelegate.progress != progress || oldDelegate.ok != ok;
// }
