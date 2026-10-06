import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../../../../../../core/router/app_navigator.dart';
import '../../../../state/onboarding_controller.dart';
import '../../widgets/wizard_radio_tile.dart';
// import '../widgets/wizard_scaffold.dart'; // moved to core/ui/components (shared with features/auth)
import '../../../../../../core/ui/components/wizard_scaffold.dart';

// const _totalSteps = 17; // step/progress now from OnboardingRoutes.wizardSections

class AboutYouScreen extends ConsumerStatefulWidget {
  const AboutYouScreen({super.key});

  @override
  ConsumerState<AboutYouScreen> createState() => _AboutYouScreenState();
}

class _AboutYouScreenState extends ConsumerState<AboutYouScreen> {
  bool? _bornMuslim;
  bool? _hasChildren;
  bool? _wouldRelocate;

  @override
  void initState() {
    super.initState();
    final data = ref.read(onboardingControllerProvider);
    _bornMuslim = data.bornMuslim;
    _hasChildren = data.hasChildren;
    _wouldRelocate = data.wouldRelocate;
  }

  @override
  Widget build(BuildContext context) {
    final canContinue =
        _bornMuslim != null && _hasChildren != null && _wouldRelocate != null;
    return WizardScaffold(
      // title: 'About you',  // now from OnboardingRoutes.wizardSections
      // step: 15,
      // totalSteps: _totalSteps,
      onContinue: !canContinue
          ? null
          : () {
              ref
                  .read(onboardingControllerProvider.notifier)
                  .patch(
                    (d) => d.copyWith(
                      bornMuslim: _bornMuslim,
                      hasChildren: _hasChildren,
                      wouldRelocate: _wouldRelocate,
                    ),
                  );
              ref.read(appNavigatorProvider).toPersonality();
            },
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const WizardHeadline(
              text: 'About you',
              subtitle:
                  'Tell us about yourself to help us personalize your matches.',
              padding: EdgeInsets.zero,
            ),
            SizedBox(height: 20.h),
            YesNoQuestion(
              label: 'Were you born a Muslim?',
              value: _bornMuslim,
              onChanged: (v) => setState(() => _bornMuslim = v),
            ),
            YesNoQuestion(
              label: 'Do you have children?',
              value: _hasChildren,
              onChanged: (v) => setState(() => _hasChildren = v),
            ),
            YesNoQuestion(
              label: 'Would you move abroad for marriage?',
              value: _wouldRelocate,
              onChanged: (v) => setState(() => _wouldRelocate = v),
              trailingDivider: false,
            ),
            SizedBox(height: 12.h),
          ],
        ),
      ),
    );
  }
}
