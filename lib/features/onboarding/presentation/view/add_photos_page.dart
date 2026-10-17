import 'dart:async';
// import 'dart:io'; // only the commented-out Image.file used it

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
    return MultiBlocListener(
      listeners: [
        BlocListener<OnboardingBloc, OnboardingState>(
          listenWhen: (prev, next) =>
              next.failure != null && prev.failure != next.failure,
          listener: (context, state) =>
              showFailureToast(context, state.failure!),
        ),
        // More picked than slots left → tell the user only some were added.
        BlocListener<OnboardingBloc, OnboardingState>(
          listenWhen: (prev, next) =>
              next.photosOverLimit > 0 &&
              prev.photosOverLimit != next.photosOverLimit,
          listener: (context, state) => CustomToast.showInfo(
            context,
            'You can add up to ${OnboardingData.maxPhotos} photos',
            description: state.photosOverLimit == 1
                ? '1 extra photo was not added.'
                : '${state.photosOverLimit} extra photos were not added.',
          ),
        ),
        // Photos chosen → block the screen while they're compressed (can
        // take a few seconds for a multi-select). The dialog closes itself.
        BlocListener<OnboardingBloc, OnboardingState>(
          listenWhen: (prev, next) =>
              !prev.processingPhotos && next.processingPhotos,
          listener: (context, _) => _AddingPhotosDialog.show(context),
        ),
        // Step-8 upload finished: on to face verification with the main
        // photo. A failure stays here (toast above).
        BlocListener<OnboardingBloc, OnboardingState>(
          listenWhen: (prev, next) =>
              prev.submittingStep && !next.submittingStep,
          listener: (context, state) {
            final photos = state.draft.photoPaths;
            if (state.failure == null && photos.isNotEmpty) {
              _AddPhotosView._next(context, photos.first);
            }
          },
        ),
      ],
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
        isScrollControlled: true,
        showDragHandle: true,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        builder: (_) => const _PhotoGuidelinesSheet(),
      ),
    );
  }

  // Before: a plain title + bullet-text sheet; replaced by the info-style
  // _PhotoGuidelinesSheet.
  // void _showGuidelines(BuildContext context) {
  //   unawaited(
  //     showModalBottomSheet<void>(
  //       context: context,
  //       // Cover the whole screen, not just the body under the persistent
  //       // wizard header (the shell has its own nested navigator).
  //       useRootNavigator: true,
  //       builder: (context) => Padding(
  //         padding: EdgeInsets.all(24.w),
  //         child: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Text(
  //               'Photo guidelines',
  //               style: TextFontStyle.headline18w700StyleSatoshi,
  //             ),
  //             SizedBox(height: 12.h),
  //             Text(
  //               '• Show your face clearly in your first photo\n'
  //               '• No group photos as your main picture\n'
  //               '• Recent photos only\n'
  //               '• No offensive or explicit content',
  //               style: TextFontStyle.headline14w400textMutedStyleSatoshi
  //                   .copyWith(
  //                     height: 1.5,
  //                   ),
  //             ),
  //             SizedBox(height: 12.h),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  /// Photos → face verification, carrying the main photo so the user can
  /// confirm it's them. The router skips face verification when it's
  /// switched off remotely.
  static void _next(BuildContext context, String mainPhotoPath) =>
      context.push<void>(RoutePaths.scanYourFace, extra: mainPhotoPath);

  @override
  Widget build(BuildContext context) {
    final state = context.watch<OnboardingBloc>().state;
    final photos = state.draft.photoPaths;
    final bloc = context.read<OnboardingBloc>();
    void pick() => bloc.add(const ProfilePhotosPickRequested());
    return WizardScaffold(
      continueLabel: state.submittingStep
          ? 'Uploading...'
          // : photos.isEmpty
          // ? 'Add photos'
          // : 'Continue',
          : state.draft.hasEnoughPhotos
          ? 'Continue'
          : 'Add photos',
      // Previously went straight to face verification; now uploads the
      // photos (step 8) first and the listener above moves on.
      // onContinue: state.draft.hasEnoughPhotos
      //     ? () => _next(context, photos.first)
      //     : null,
      // onContinue: state.draft.hasEnoughPhotos && !state.submittingStep
      //     ? () => bloc.add(const PhotosSubmitted())
      //     : null,
      // Figma: "Add photos" is live and opens the picker until there are
      // enough photos; then it becomes Continue (upload).
      onContinue: state.submittingStep
          ? null
          : state.draft.hasEnoughPhotos
          ? () => bloc.add(const PhotosSubmitted())
          : state.pickingPhotos ||
                state.processingPhotos ||
                photos.length >= OnboardingData.maxPhotos
          ? null
          : pick,
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
            // SizedBox(height: 20.h),
            // Figma 883:5524: grid 34pt under the subtitle, 140pt slots 14pt
            // apart.
            SizedBox(height: 34.h),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: OnboardingData.maxPhotos + 1,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                // crossAxisSpacing: 12.w,
                // mainAxisSpacing: 12.h,
                // childAspectRatio: 0.78,
                crossAxisSpacing: 14.w,
                mainAxisSpacing: 14.h,
                mainAxisExtent: 140.h,
              ),
              itemBuilder: (context, index) {
                if (index == OnboardingData.maxPhotos) {
                  return _GuidelinesTile(
                    onTap: () => _showGuidelines(context),
                  );
                }
                final path = index < photos.length ? photos[index] : null;
                final busy =
                    state.submittingStep || state.deletingPhoto != null;
                return _PhotoSlot(
                  path: path,
                  deleting: path != null && path == state.deletingPhoto,
                  // Locked while the step-8 upload is in flight.
                  onTap:
                      path == null &&
                          !state.pickingPhotos &&
                          !state.processingPhotos &&
                          !state.submittingStep
                      ? pick
                      : null,
                  // Locked during the upload and while a server delete runs.
                  onRemove: path == null || busy
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
  const _PhotoSlot({
    required this.path,
    required this.onTap,
    this.onRemove,
    this.deleting = false,
  });

  /// This (uploaded) photo is being deleted on the server.
  final bool deleting;

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
              // painter: _DashedBorderPainter(color: Colors.grey.shade400),
              painter: _DashedBorderPainter(color: const Color(0xFFD4D4D4)),
              child: Center(
                // child:
                //     Icon(Icons.add, color: Colors.grey.shade500, size: 24.r),
                child: Icon(
                  Icons.add,
                  color: const Color(0xFF525252),
                  size: 18.r,
                ),
              ),
            )
          else
            ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              // Local file (just picked) or URL (already uploaded).
              // child: Image.file(File(path!), fit: BoxFit.cover),
              child: AppPhoto(path!),
            ),
          if (deleting)
            ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: const ColoredBox(
                color: Colors.black38,
                child: Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              ),
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

/// Floating, non-dismissible spinner over the whole screen (root
/// navigator, so it covers the wizard header too). Pops itself
/// once [OnboardingState.processingPhotos] clears.
class _AddingPhotosDialog extends StatefulWidget {
  const _AddingPhotosDialog();

  static void show(BuildContext context) {
    final bloc = context.read<OnboardingBloc>();
    unawaited(
      showDialog<void>(
        context: context,
        barrierDismissible: false,
        barrierColor: Colors.black54,
        builder: (_) => BlocProvider.value(
          value: bloc,
          child: const _AddingPhotosDialog(),
        ),
      ),
    );
  }

  @override
  State<_AddingPhotosDialog> createState() => _AddingPhotosDialogState();
}

class _AddingPhotosDialogState extends State<_AddingPhotosDialog> {
  bool _closed = false;

  @override
  void initState() {
    super.initState();
    // Processing may already be over by the time the route builds.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!context.read<OnboardingBloc>().state.processingPhotos) _close();
    });
  }

  void _close() {
    if (_closed || !mounted) return;
    _closed = true;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OnboardingBloc, OnboardingState>(
      listenWhen: (prev, next) =>
          prev.processingPhotos && !next.processingPhotos,
      listener: (_, _) => _close(),
      child: const PopScope(
        canPop: false,
        // Just the spinner — no card, no text.
        child: Center(
          child: CircularProgressIndicator(color: AppColors.primaryColor),
        ),
      ),
    );
  }
}

/// "Photo guidelines" info sheet: info header, do / don't rows, "Got it".
class _PhotoGuidelinesSheet extends StatelessWidget {
  const _PhotoGuidelinesSheet();

  // Photos are matched against the face-verification scan — keep it to
  // the essentials.
  static const _dos = [
    'Clear face, looking at the camera',
    'Only you in the photo',
    'Good lighting',
  ];
  static const _donts = [
    'Sunglasses, masks or filters',
    'Blurry or group photos',
  ];
  // Before (longer face-verification list — too much to read):
  // static const _dos = [
  //   'Your face clearly visible, looking at the camera',
  //   'Only you in the photo — especially your first one',
  //   'Good, even lighting (daylight works best)',
  //   'Recent photos that look like you today',
  //   'Hijab is fine — just keep your full face visible',
  // ];
  // static const _donts = [
  //   'No sunglasses, masks or anything covering your face',
  //   'No heavy filters, stickers or edited faces',
  //   'No blurry, dark or far-away shots',
  //   'No group photos, celebrities or someone else',
  //   'No offensive or explicit content',
  // ];
  // Before (general profile-photo rules):
  // static const _dos = [
  //   'Show your face clearly in your first photo',
  //   'Use recent photos of yourself',
  // ];
  // static const _donts = [
  //   'No group photos as your main picture',
  //   'No offensive or explicit content',
  // ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      // Scrolls on short screens — the list is long.
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 16.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40.r,
                  height: 40.r,
                  decoration: BoxDecoration(
                    color: AppColors.infoColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.info_outline_rounded,
                    size: 22.r,
                    color: AppColors.infoColor,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    'Photo guidelines',
                    style: TextFontStyle.headline18w700StyleSatoshi,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Text(
              "Used to verify it's really you.",
              style: TextFontStyle.headline14w400textMutedStyleSatoshi.copyWith(
                height: 1.4,
              ),
            ),
            SizedBox(height: 20.h),
            for (final text in _dos) _GuidelineRow(text: text, allowed: true),
            for (final text in _donts)
              _GuidelineRow(text: text, allowed: false),
            SizedBox(height: 4.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(12.r),
              decoration: BoxDecoration(
                color: AppColors.infoColor.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Text(
                'Tip: your first photo is used for the face match.',
                style: TextFontStyle.headline13w400textMutedStyleSatoshi
                    .copyWith(color: AppColors.infoColor),
              ),
            ),
            SizedBox(height: 20.h),
            AppPrimaryButton(
              label: 'Got it',
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }
}

class _GuidelineRow extends StatelessWidget {
  const _GuidelineRow({required this.text, required this.allowed});

  final String text;
  final bool allowed;

  @override
  Widget build(BuildContext context) {
    final color = allowed ? AppColors.successColor : AppColors.errorColor;
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            allowed ? Icons.check_circle_rounded : Icons.cancel_rounded,
            size: 20.r,
            color: color,
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              text,
              style: TextFontStyle.headline14w400textMutedStyleSatoshi.copyWith(
                color: AppColors.textDark,
                height: 1.4,
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
      // child: Column(
      // mainAxisAlignment: MainAxisAlignment.center,
      // children: [
      // Container(
      // width: 28.r,
      // height: 28.r,
      // decoration: BoxDecoration(
      // shape: BoxShape.circle,
      // border: Border.all(color: AppColors.textMuted),
      // ),
      // child: Icon(
      // Icons.info_outline,
      // size: 16.r,
      // color: AppColors.textDark,
      // ),
      // ),
      // SizedBox(height: 6.h),
      // Text(
      // 'Photo\nguidelines',
      // textAlign: TextAlign.center,
      // style: TextFontStyle.headline11w400textMutedStyleSatoshi,
      // ),
      // ],
      // ),
      // Figma 883:5547: plain 18pt info icon, 12pt gap, Medium 12 Grey-950.
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.info_outline, size: 18.r, color: const Color(0xFF0A0A0A)),
          SizedBox(height: 12.h),
          Text(
            'Photo\nguidelines',
            textAlign: TextAlign.center,
            style: figmaText(12, 15.6, weight: FontWeight.w500),
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
