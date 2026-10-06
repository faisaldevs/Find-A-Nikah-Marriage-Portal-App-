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
const _maxSelections = 5;

class PersonalityScreen extends ConsumerStatefulWidget {
  const PersonalityScreen({super.key});

  @override
  ConsumerState<PersonalityScreen> createState() => _PersonalityScreenState();
}

class _PersonalityScreenState extends ConsumerState<PersonalityScreen> {
  late Set<String> _selected;

  @override
  void initState() {
    super.initState();
    _selected = ref
        .read(onboardingControllerProvider)
        .personalityTraits
        .toSet();
  }

  void _toggle(String value) {
    setState(() {
      if (!_selected.remove(value) && _selected.length < _maxSelections) {
        _selected.add(value);
      }
    });
  }

  void _next() => ref.read(appNavigatorProvider).toInterests();

  @override
  Widget build(BuildContext context) {
    final atMax = _selected.length >= _maxSelections;
    return WizardScaffold(
      // title: 'Personality',  // now from OnboardingRoutes.wizardSections
      // step: 16,
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
                  .patch(
                    (d) => d.copyWith(personalityTraits: _selected.toList()),
                  );
              _next();
            },
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const WizardHeadline(
              text: 'How would you describe\nyour personality?',
              subtitle: 'Choose up to 5 traits to show off your personality!',
              padding: EdgeInsets.zero,
            ),
            SizedBox(height: 20.h),
            WizardChipGroup(
              options: personalityTraitOptions,
              selected: _selected,
              onTap: _toggle,
              disabled: atMax ? personalityTraitOptions.toSet() : {},
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}
