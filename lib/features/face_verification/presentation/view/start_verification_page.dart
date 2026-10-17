import 'dart:io';

import 'package:find_a_nikah/core/ui/ui.dart';
import 'package:find_a_nikah/features/face_verification/presentation/bloc/face_verification_bloc.dart';
import 'package:find_a_nikah/router/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:go_router/go_router.dart';

/// Step 2 of face verification: "Start verification" opens the guided
/// liveness capture (`LivenessCapturePage`), which photographs the user
/// front/left/right and uploads the stills for server-side verification.
class StartVerificationPage extends StatelessWidget {
  const StartVerificationPage({super.key});

  // Liveness is now the only path — the `livenessEnabled` flag and the old
  // single-selfie capture (system camera → on-device check → submit) are
  // disabled below, kept for reference.
  // const StartVerificationPage({required this.livenessEnabled, super.key});
  //
  // /// Resolved by the router (the one place allowed to see every feature's
  // /// state) from the `livenessEnabled` remote-config flag.
  // final bool livenessEnabled;

  @override
  Widget build(BuildContext context) {
    final busy = context.select<FaceVerificationBloc, bool>(
      (b) => b.state.busy,
    );
    return WizardScaffold(
      continueLabel: 'Start verification',
      onContinue: busy
          ? null
          : () => context.push<void>(RoutePaths.livenessCapture),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            SizedBox(height: 48.h),
            _SelfieCircle(path: null, busy: busy),
          ],
        ),
      ),
    );
  }

  /*
  @override
  Widget build(BuildContext context) {
    final state = context.watch<FaceVerificationBloc>().state;
    final bloc = context.read<FaceVerificationBloc>();
    final rejection = state.check;

    // Also reacted to the liveness flow's statuses while LivenessCapturePage
    // sat on top of this page — pushing the result page twice.
    return BlocListener<FaceVerificationBloc, FaceVerificationState>(
      listenWhen: (prev, next) =>
          prev.status != next.status || prev.failure != next.failure,
      listener: (context, state) {
        if (state.status == FaceVerificationStatus.underReview) {
          context.push<void>(RoutePaths.photoVerification).ignore();
        } else if (state.failure != null) {
          showFailureToast(context, state.failure!);
        }
      },
      child: WizardScaffold(
        continueLabel: state.hasSelfie ? 'Continue' : 'Start verification',
        onContinue: state.busy
            ? null
            : state.hasSelfie
            ? () => bloc.add(const FaceVerificationSubmitted())
            : livenessEnabled
            ? () => context.push<void>(RoutePaths.livenessCapture)
            : () => bloc.add(const SelfieCaptureRequested()),
        secondaryLabel: state.hasSelfie ? 'Retake selfie' : null,
        onSecondary: state.hasSelfie
            ? () => bloc.add(const SelfieRetakeRequested())
            : null,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: [
              SizedBox(height: 48.h),
              _SelfieCircle(
                path: state.hasSelfie ? state.selfiePath : null,
                busy: state.busy,
              ),
              if (state.status == FaceVerificationStatus.failed &&
                  rejection != null) ...[
                SizedBox(height: 24.h),
                Text(
                  rejection.message,
                  textAlign: TextAlign.center,
                  style: TextFontStyle.headline13w400errorColorStyleSatoshi
                      .copyWith(height: 1.4),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
  */
}

/// 270pt dashed circle. Empty: grey fill + eye-off badge + caption. Filled:
/// the captured selfie clipped to the circle. [busy] overlays a spinner.
class _SelfieCircle extends StatelessWidget {
  const _SelfieCircle({required this.path, required this.busy});

  final String? path;
  final bool busy;

  @override
  Widget build(BuildContext context) {
    final diameter = 270.r;
    return CustomPaint(
      painter: _DashedCirclePainter(color: AppColors.textDark),
      child: SizedBox(
        width: diameter,
        height: diameter,
        child: ClipOval(
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (path == null)
                ColoredBox(
                  color: const Color(0xFFE8E8E8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 48.r,
                        height: 48.r,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.visibility_off_outlined,
                          size: 22.r,
                          color: AppColors.primaryColor,
                        ),
                      ),
                      SizedBox(height: 20.h),
                      Text(
                        "Won't be shown\non your profile",
                        textAlign: TextAlign.center,
                        style: TextFontStyle.headline15w400textMutedStyleSatoshi
                            .copyWith(height: 1.4),
                      ),
                    ],
                  ),
                )
              else
                Image.file(File(path!), fit: BoxFit.cover),
              if (busy)
                const ColoredBox(
                  color: Colors.black26,
                  child: Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Circle variant of onboarding's `_DashedBorderPainter` (that one is
/// rounded-rect and private to AddPhotosPage).
class _DashedCirclePainter extends CustomPainter {
  _DashedCirclePainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    final path = Path()..addOval(Offset.zero & size);
    const dashWidth = 6.0;
    const dashSpace = 5.0;
    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        canvas.drawPath(
          metric.extractPath(distance, distance + dashWidth),
          paint,
        );
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedCirclePainter oldDelegate) =>
      oldDelegate.color != color;
}
