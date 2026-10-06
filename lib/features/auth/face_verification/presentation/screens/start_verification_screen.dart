import 'dart:io';
import 'package:find_a_nikah/core/constants/text_font_style.dart';

import 'package:find_a_nikah/gen/colors.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../core/router/app_navigator.dart';
import '../../../../../core/ui/components/wizard_scaffold.dart';
import '../state/face_verification_controller.dart';
import '../state/face_verification_state.dart';

/// Step 2 of face verification: capture a private selfie.
///
/// Empty state shows the dashed "Won't be shown on your profile" circle;
/// once a selfie passes the on-device face check it fills the circle and the
/// CTA flips to "Continue", which submits for server-side review.
class StartVerificationScreen extends ConsumerWidget {
  const StartVerificationScreen({super.key});

  Future<void> _captureSelfie(WidgetRef ref) async {
    // TODO(liveness): swap for a live `camera` stream + ML Kit challenge
    // (blink / turn head) once the backend verification vendor is chosen.
    // A single still from the system camera is the minimum viable capture.
    final picked = await ImagePicker().pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.front,
      imageQuality: 90,
    );
    if (picked == null) return;
    await ref
        .read(faceVerificationControllerProvider.notifier)
        .onSelfieCaptured(picked.path);
  }

  Future<void> _submit(WidgetRef ref) async {
    await ref.read(faceVerificationControllerProvider.notifier).submit();
    final status = ref.read(faceVerificationControllerProvider).status;
    if (status == FaceVerificationStatus.underReview) {
      ref.read(appNavigatorProvider).toPhotoVerification();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(faceVerificationControllerProvider);
    final busy =
        state.status == FaceVerificationStatus.checkingSelfie ||
        state.status == FaceVerificationStatus.submitting;
    final hasSelfie =
        state.selfiePath != null &&
        state.status == FaceVerificationStatus.selfieReady;

    return WizardScaffold(
      // title: 'Start Verification',  // now from verificationSections (core/router/verification_routes.dart)
      // step: 3,
      // totalSteps: 4,
      continueLabel: hasSelfie ? 'Continue' : 'Start verification',
      onContinue: busy
          ? null
          : hasSelfie
          ? () => _submit(ref)
          : () => _captureSelfie(ref),
      secondaryLabel: hasSelfie ? 'Retake selfie' : null,
      onSecondary: hasSelfie
          ? ref.read(faceVerificationControllerProvider.notifier).retake
          : null,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            SizedBox(height: 48.h),
            _SelfieCircle(
              path: hasSelfie ? state.selfiePath : null,
              busy: busy,
            ),
            if (state.status == FaceVerificationStatus.failed &&
                state.errorMessage != null) ...[
              SizedBox(height: 24.h),
              Text(
                state.errorMessage!,
                textAlign: TextAlign.center,
                style: TextFontStyle.headline13w400errorColorStyleSatoshi
                    .copyWith(height: 1.4),
              ),
            ],
          ],
        ),
      ),
    );
  }
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
/// rounded-rect and private to AddPhotosScreen).
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
