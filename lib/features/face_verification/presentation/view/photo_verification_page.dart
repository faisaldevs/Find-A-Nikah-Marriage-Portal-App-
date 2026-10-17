// import 'dart:io'; // only the commented-out Image.file used it

import 'package:find_a_nikah/core/ui/ui.dart';
import 'package:find_a_nikah/features/face_verification/presentation/bloc/face_verification_bloc.dart';
import 'package:find_a_nikah/router/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:go_router/go_router.dart';

/// Step 3 of face verification: submission received, profile under review.
/// Continue leads into the Location step, then the discovery filters.
class PhotoVerificationPage extends StatelessWidget {
  const PhotoVerificationPage({super.key, this.userName});

  /// Shown in the "Jazakallah, {name}." greeting. Onboarding doesn't collect
  /// a display name yet, so this stays null and the greeting is generic.
  final String? userName;

  @override
  Widget build(BuildContext context) {
    final photoPath = context.select<FaceVerificationBloc, String?>(
      (b) => b.state.profilePhotoPath,
    );
    // final greeting = userName == null
    //     ? "Jazakallah. We're reviewing your profile."
    //     : "Jazakallah, $userName. We're reviewing your profile.";
    // Figma: "Jazakallah, {full name}." — the router passes the name from
    // the onboarding draft; an instant approval says so instead of
    // "reviewing" (audit #40).
    final verified = context.select<FaceVerificationBloc, bool>(
      (b) => b.state.verified,
    );
    final name = userName?.trim();
    final hello = name == null || name.isEmpty
        ? 'Jazakallah.'
        : 'Jazakallah, $name.';
    final greeting = verified
        ? '$hello Your profile is verified.'
        : "$hello We're reviewing your profile.";

    return WizardScaffold(
      // Verification done → mandatory Location step, then Add filters.
      onContinue: () => context.push<void>(RoutePaths.location).ignore(),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16.h),
            Center(child: _ProfileAvatar(path: photoPath)),
            SizedBox(height: 36.h),
            WizardHeadline(
              text: greeting,
              subtitle: verified
                  ? 'Your profile will now be shown to other single Muslims.'
                  : 'Once approved, your profile will be shown to other '
                        'single Muslims.',
              padding: EdgeInsets.zero,
              titleHeight: 1.3,
              subtitleColor: const Color(0xFFA3A3A3),
            ),
          ],
        ),
      ),
    );
  }
}

/// 135pt circular avatar with a soft white ring + drop shadow.
class _ProfileAvatar extends StatelessWidget {
  const _ProfileAvatar({required this.path});

  final String? path;

  @override
  Widget build(BuildContext context) {
    final diameter = 135.r;
    return Container(
      width: diameter,
      height: diameter,
      padding: EdgeInsets.all(5.r),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipOval(
        child: path == null
            ? ColoredBox(
                color: Colors.grey.shade200,
                child: Icon(
                  Icons.person_outline,
                  size: 56.r,
                  color: Colors.grey.shade500,
                ),
              )
            // The main photo may be an already-uploaded URL.
            // : Image.file(File(path!), fit: BoxFit.cover),
            : AppPhoto(path!),
      ),
    );
  }
}
