import 'dart:async';
import 'dart:io';

import 'package:find_a_nikah/core/ui/ui.dart';
import 'package:find_a_nikah/features/onboarding/domain/domain.dart';
import 'package:find_a_nikah/features/onboarding/presentation/bloc/onboarding_bloc.dart';
import 'package:find_a_nikah/router/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:go_router/go_router.dart';

/// "Add your photos" (Verification part). Photos live in the onboarding
/// draft, so they survive leaving and returning to this page.
class AddPhotosPage extends StatelessWidget {
  const AddPhotosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<OnboardingBloc, OnboardingState>(
      listenWhen: (prev, next) =>
          next.failure != null && prev.failure != next.failure,
      listener: (context, state) =>
          showFailureToast(context, state.failure!),
      child: const _AddPhotosView(),
    );
  }
}

class _AddPhotosView extends StatelessWidget {
  const _AddPhotosView();

  void _showGuidelines(BuildContext context) {
    unawaited(
      showModalBottomSheet<void>(
        context: context,
        // Cover the whole screen, not just the body under the persistent
        // wizard header (the shell has its own nested navigator).
        useRootNavigator: true,
        builder: (context) => Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Photo guidelines',
                style: TextFontStyle.headline18w700StyleSatoshi,
              ),
              SizedBox(height: 12.h),
              Text(
                '• Show your face clearly in your first photo\n'
                '• No group photos as your main picture\n'
                '• Recent photos only\n'
                '• No offensive or explicit content',
                style: TextFontStyle.headline14w400textMutedStyleSatoshi
                    .copyWith(
                      height: 1.5,
                    ),
              ),
              SizedBox(height: 12.h),
            ],
          ),
        ),
      ),
    );
  }

  /// Photos → face verification, carrying the main photo so the user can
  /// confirm it's them. The router skips face verification when it's
  /// switched off remotely.
  void _next(BuildContext context, String mainPhotoPath) =>
      context.push<void>(RoutePaths.scanYourFace, extra: mainPhotoPath);

  @override
  Widget build(BuildContext context) {
    final state = context.watch<OnboardingBloc>().state;
    final photos = state.draft.photoPaths;
    final bloc = context.read<OnboardingBloc>();
    void pick() => bloc.add(const ProfilePhotosPickRequested());
    return WizardScaffold(
      continueLabel: photos.isEmpty ? 'Add photos' : 'Continue',
      onContinue: state.draft.hasEnoughPhotos
          ? () => _next(context, photos.first)
          : null,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const WizardHeadline(
              text: 'Add your profile photos',
              subtitle:
                  'You need to upload at least '
                  '${OnboardingData.minPhotos} photos to '
                  'continue your profile. You can change them later.',
              padding: EdgeInsets.zero,
            ),
            SizedBox(height: 20.h),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: OnboardingData.maxPhotos + 1,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 12.w,
                mainAxisSpacing: 12.h,
                childAspectRatio: 0.78,
              ),
              itemBuilder: (context, index) {
                if (index == OnboardingData.maxPhotos) {
                  return _GuidelinesTile(
                    onTap: () => _showGuidelines(context),
                  );
                }
                final path = index < photos.length ? photos[index] : null;
                return _PhotoSlot(
                  path: path,
                  onTap: path == null && !state.pickingPhotos ? pick : null,
                  onRemove: path == null
                      ? null
                      : () => bloc.add(ProfilePhotoRemoved(index)),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _PhotoSlot extends StatelessWidget {
  const _PhotoSlot({required this.path, required this.onTap, this.onRemove});

  final String? path;
  final VoidCallback? onTap;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (path == null)
            CustomPaint(
              painter: _DashedBorderPainter(color: Colors.grey.shade400),
              child: Center(
                child: Icon(Icons.add, color: Colors.grey.shade500, size: 24.r),
              ),
            )
          else
            ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: Image.file(File(path!), fit: BoxFit.cover),
            ),
          if (onRemove != null)
            Positioned(
              top: 4,
              right: 4,
              child: GestureDetector(
                onTap: onRemove,
                child: Container(
                  padding: EdgeInsets.all(2.r),
                  decoration: const BoxDecoration(
                    color: Colors.black54,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.close, size: 14.r, color: Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _GuidelinesTile extends StatelessWidget {
  const _GuidelinesTile({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 28.r,
            height: 28.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.textMuted),
            ),
            child: Icon(
              Icons.info_outline,
              size: 16.r,
              color: AppColors.textDark,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            'Photo\nguidelines',
            textAlign: TextAlign.center,
            style: TextFontStyle.headline11w400textMutedStyleSatoshi,
          ),
        ],
      ),
    );
  }
}

/// No dashed-border widget exists in the design system yet and this is the
/// only screen that needs one — a tiny local painter beats pulling in a
/// package for one visual.
class _DashedBorderPainter extends CustomPainter {
  _DashedBorderPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    final rrect = RRect.fromRectAndRadius(
      Offset.zero & size,
      const Radius.circular(8),
    );
    final path = Path()..addRRect(rrect);
    const dashWidth = 5.0;
    const dashSpace = 4.0;
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
  bool shouldRepaint(covariant _DashedBorderPainter oldDelegate) =>
      oldDelegate.color != color;
}
