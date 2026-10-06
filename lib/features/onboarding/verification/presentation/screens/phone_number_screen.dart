import 'package:find_a_nikah/gen/colors.gen.dart';
import 'package:find_a_nikah/core/constants/text_font_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../../../../../core/router/app_navigator.dart';
import '../../../state/onboarding_controller.dart';
// import '../widgets/wizard_scaffold.dart'; // moved to core/ui/components (shared with features/auth)
import '../../../../../core/ui/components/wizard_scaffold.dart';

// const _totalSteps = 17; // step/progress now from OnboardingRoutes.wizardSections

/// Still part of the "Photos" section of the mockups — title bar keeps that
/// label even though this screen collects the phone number.
class PhoneNumberScreen extends ConsumerStatefulWidget {
  const PhoneNumberScreen({super.key});

  @override
  ConsumerState<PhoneNumberScreen> createState() => _PhoneNumberScreenState();
}

class _PhoneNumberScreenState extends ConsumerState<PhoneNumberScreen> {
  String? _completeNumber;

  void _next() {
    ref
        .read(onboardingControllerProvider.notifier)
        .patch((d) => d.copyWith(phoneNumber: _completeNumber));
    ref.read(appNavigatorProvider).toPhoneVerificationCode();
  }

  @override
  Widget build(BuildContext context) {
    final canContinue = (_completeNumber ?? '').length > 6;
    return WizardScaffold(
      // title: 'Photos',  // now from OnboardingRoutes.wizardSections
      // step: _totalSteps,
      // totalSteps: _totalSteps,
      onContinue: canContinue ? _next : null,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const WizardHeadline(
              text: 'Verify your phone\nnumber on WhatsApp',
              padding: EdgeInsets.zero,
            ),
            SizedBox(height: 20.h),
            IntlPhoneField(
              initialCountryCode: 'BD',
              style: TextFontStyle.headline15w400textDarkStyleSatoshi,
              dropdownTextStyle:
                  TextFontStyle.headline15w400textDarkStyleSatoshi,
              decoration: const InputDecoration(
                hintText: 'Enter your phone number',
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.textMuted),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.primaryColor),
                ),
              ),
              onChanged: (phone) =>
                  setState(() => _completeNumber = phone.completeNumber),
            ),
            SizedBox(height: 12.h),
            Text(
              'Your number is only used to send a verification code and '
              'will never be shared on your profile.',
              style: TextFontStyle.headline13w400textMutedStyleSatoshi.copyWith(
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
