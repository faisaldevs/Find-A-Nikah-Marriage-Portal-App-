import 'dart:io';

import 'package:find_a_nikah/core/ui/ui.dart';
import 'package:find_a_nikah/features/face_verification/presentation/bloc/face_verification_bloc.dart';
import 'package:find_a_nikah/features/face_verification/presentation/presentation.dart'
    show StartVerificationPage;
import 'package:find_a_nikah/features/face_verification/presentation/view/start_verification_page.dart'
    show StartVerificationPage;
import 'package:find_a_nikah/features/face_verification/presentation/widgets/verification_legal_footer.dart';
import 'package:find_a_nikah/router/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:go_router/go_router.dart';

/// Step 1 of face verification: "Confirm it's you in this photo".
/// Shows the profile photo handed over from onboarding (via route `extra`)
/// with a blue check badge, explains the automated scan, then hands off to
/// [StartVerificationPage]. The photo lives in [FaceVerificationBloc] so the
/// next steps see a changed one.
class ScanYourFacePage extends StatefulWidget {
  const ScanYourFacePage({super.key, this.profilePhotoPath});

  /// Main onboarding photo. Null when the user reached this page without
  /// one (e.g. deep link) — "Change photo" then acts as "Add photo".
  final String? profilePhotoPath;

  @override
  State<ScanYourFacePage> createState() => _ScanYourFacePageState();
}

class _ScanYourFacePageState extends State<ScanYourFacePage> {
  @override
  void initState() {
    super.initState();
    context.read<FaceVerificationBloc>().add(
      FaceVerificationProfilePhotoProvided(widget.profilePhotoPath),
    );
  }

  void _changePhoto() => context.read<FaceVerificationBloc>().add(
    const FaceVerificationProfilePhotoChangeRequested(),
  );

  @override
  Widget build(BuildContext context) {
    final photoPath = context.select<FaceVerificationBloc, String?>(
      (b) => b.state.profilePhotoPath,
    );
    return WizardScaffold(
      continueLabel: 'Verify photo',
      onContinue: photoPath == null
          ? null
          : () => context.push<void>(RoutePaths.startVerification),
      secondaryLabel: photoPath == null ? 'Add photo' : 'Change photo',
      onSecondary: _changePhoto,
      footer: const VerificationLegalFooter(),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8.h),
            _ProfilePhotoThumb(path: photoPath),
            SizedBox(height: 28.h),
            const WizardHeadline(
              text: "Confirm it's you in this photo to get verified",
              subtitle:
                  'This ensures that you only meet genuine people on '
                  'Find A Nikah.',
              padding: EdgeInsets.zero,
            ),
            SizedBox(height: 40.h),
            const _ScanExplainerRow(),
          ],
        ),
      ),
    );
  }
}

/// 105×140 rounded profile photo with the blue "verified" check badge
/// overlapping its bottom-right corner.
class _ProfilePhotoThumb extends StatelessWidget {
  const _ProfilePhotoThumb({required this.path});

  final String? path;

  @override
  Widget build(BuildContext context) {
    final size = Size(105.w, 140.h);
    return SizedBox(
      width: size.width + 14.r,
      height: size.height + 14.r,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: SizedBox(
              width: size.width,
              height: size.height,
              child: path == null
                  ? ColoredBox(
                      color: Colors.grey.shade200,
                      child: Icon(
                        Icons.person_outline,
                        size: 48.r,
                        color: Colors.grey.shade500,
                      ),
                    )
                  : Image.file(File(path!), fit: BoxFit.cover),
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: 28.r,
              height: 28.r,
              decoration: BoxDecoration(
                color: AppColors.infoColor,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2.5),
              ),
              child: Icon(Icons.check, size: 16.r, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class _ScanExplainerRow extends StatelessWidget {
  const _ScanExplainerRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40.r,
          height: 40.r,
          decoration: BoxDecoration(
            color: AppColors.primaryColor.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(6.r),
          ),
          child: Icon(
            Icons.face_retouching_natural_outlined,
            size: 22.r,
            color: AppColors.primaryColor,
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Scan your face',
                style: TextFontStyle.headline16w600textDarkStyleSatoshi,
              ),
              SizedBox(height: 4.h),
              Text(
                'This is an automated process to check your face matches '
                'your photo.',
                style: TextFontStyle.headline13w400textMutedStyleSatoshi
                    .copyWith(height: 1.4),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
