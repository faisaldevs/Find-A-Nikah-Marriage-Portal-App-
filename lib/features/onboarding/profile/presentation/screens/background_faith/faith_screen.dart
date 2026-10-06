import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../../../../../../core/router/app_navigator.dart';
import '../../data/wizard_options.dart';
import '../../../../state/onboarding_controller.dart';
import '../../widgets/wizard_chip_group.dart';
// import '../widgets/wizard_scaffold.dart'; // moved to core/ui/components (shared with features/auth)
import '../../../../../../core/ui/components/wizard_scaffold.dart';

// const _totalSteps = 17; // step/progress now from OnboardingRoutes.wizardSections
const _maxSelections = 8;

class FaithScreen extends ConsumerStatefulWidget {
  const FaithScreen({super.key});

  @override
  ConsumerState<FaithScreen> createState() => _FaithScreenState();
}

class _FaithScreenState extends ConsumerState<FaithScreen> {
  late Set<String> _selected;

  @override
  void initState() {
    super.initState();
    _selected = ref.read(onboardingControllerProvider).faithTags.toSet();
  }

  void _toggle(String value) {
    setState(() {
      if (!_selected.remove(value) && _selected.length < _maxSelections) {
        _selected.add(value);
      }
    });
  }

  void _next() => ref.read(appNavigatorProvider).toReligiousPractice();

  @override
  Widget build(BuildContext context) {
    final atMax = _selected.length >= _maxSelections;
    return WizardScaffold(
      // title: 'Faith',  // now from OnboardingRoutes.wizardSections
      // step: 12,
      // totalSteps: _totalSteps,
      showSkip: true,
      onSkip: _next,
      continueLabel: _selected.isEmpty
          ? 'Continue'
          : 'Select (${_selected.length})',
      onContinue: _selected.isEmpty
          ? null
          : () {
              ref
                  .read(onboardingControllerProvider.notifier)
                  .patch((d) => d.copyWith(faithTags: _selected.toList()));
              _next();
            },
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const WizardHeadline(
              text: 'Faith',
              subtitle:
                  'Choose up to 8 to describe what matters most in your Islamic practise.',
              padding: EdgeInsets.zero,
            ),
            SizedBox(height: 20.h),
            WizardChipGroup(
              options: faithTagOptions,
              selected: _selected,
              onTap: _toggle,
              disabled: atMax ? faithTagOptions.toSet() : {},
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}
