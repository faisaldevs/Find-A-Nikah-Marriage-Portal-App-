import 'package:find_a_nikah/core/constants/text_font_style.dart';
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
const _maxSelections = 15;

class InterestsScreen extends ConsumerStatefulWidget {
  const InterestsScreen({super.key});

  @override
  ConsumerState<InterestsScreen> createState() => _InterestsScreenState();
}

class _InterestsScreenState extends ConsumerState<InterestsScreen> {
  late Set<String> _selected;

  @override
  void initState() {
    super.initState();
    _selected = ref.read(onboardingControllerProvider).interests.toSet();
  }

  void _toggle(String value) {
    setState(() {
      if (!_selected.remove(value) && _selected.length < _maxSelections) {
        _selected.add(value);
      }
    });
  }

  void _next() => ref.read(appNavigatorProvider).toBio();

  @override
  Widget build(BuildContext context) {
    final atMax = _selected.length >= _maxSelections;
    final allOptions = interestCategories.values.expand((v) => v).toSet();
    return WizardScaffold(
      // title: 'Interests',  // now from OnboardingRoutes.wizardSections
      // step: 17,
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
                  .patch((d) => d.copyWith(interests: _selected.toList()));
              _next();
            },
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const WizardHeadline(
              text: 'What are your interests?',
              subtitle:
                  'Select up to 15 interests to make your profile stand out!',
              padding: EdgeInsets.zero,
            ),
            for (final entry in interestCategories.entries) ...[
              SizedBox(height: 24.h),
              Text(
                entry.key,
                style: TextFontStyle.headline16w700textDarkStyleSatoshi,
              ),
              SizedBox(height: 12.h),
              WizardChipGroup(
                options: entry.value,
                selected: _selected,
                onTap: _toggle,
                disabled: atMax ? allOptions : {},
              ),
            ],
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}
