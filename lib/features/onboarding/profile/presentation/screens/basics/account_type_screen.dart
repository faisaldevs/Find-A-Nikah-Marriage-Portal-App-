import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../../../../../../core/router/app_navigator.dart';
import '../../data/wizard_options.dart';
import '../../../../state/onboarding_controller.dart';
import '../../widgets/wizard_radio_tile.dart';
// import '../widgets/wizard_scaffold.dart'; // moved to core/ui/components (shared with features/auth)
import '../../../../../../core/ui/components/wizard_scaffold.dart';

// const _totalSteps = 17; // step/progress now from OnboardingRoutes.wizardSections

class AccountTypeScreen extends ConsumerStatefulWidget {
  const AccountTypeScreen({super.key});

  @override
  ConsumerState<AccountTypeScreen> createState() => _AccountTypeScreenState();
}

class _AccountTypeScreenState extends ConsumerState<AccountTypeScreen> {
  String? _value;

  @override
  void initState() {
    super.initState();
    _value = ref.read(onboardingControllerProvider).accountType;
  }

  @override
  Widget build(BuildContext context) {
    return WizardScaffold(
      // title: 'Choose account type',  // now from OnboardingRoutes.wizardSections
      // step: 1,
      // totalSteps: _totalSteps,
      onContinue: _value == null
          ? null
          : () {
              ref
                  .read(onboardingControllerProvider.notifier)
                  .patch((d) => d.copyWith(accountType: _value));
              ref.read(appNavigatorProvider).toIntentions();
            },
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const WizardHeadline(
            text: 'How would you like to use ',
            highlight: 'Find A Nikah?',
            subtitle:
                'Tell us about yourself so we can help you find '
                'meaningful, compatible matches nearby.',
          ),
          SizedBox(height: 8.h),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: WizardRadioGroup(
                options: accountTypeOptions,
                value: _value,
                divider: true,
                onChanged: (v) => setState(() => _value = v),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
