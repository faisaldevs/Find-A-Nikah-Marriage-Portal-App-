import 'package:find_a_nikah/core/ui/ui.dart';
import 'package:find_a_nikah/features/onboarding/presentation/bloc/onboarding_bloc.dart';
import 'package:find_a_nikah/features/onboarding/presentation/widgets/wizard_chip_group.dart';
import 'package:find_a_nikah/features/onboarding/presentation/widgets/wizard_options.dart';
import 'package:find_a_nikah/router/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:go_router/go_router.dart';

const _maxSelections = 5;

class PersonalityPage extends StatefulWidget {
  const PersonalityPage({super.key});

  @override
  State<PersonalityPage> createState() => _PersonalityPageState();
}

class _PersonalityPageState extends State<PersonalityPage> {
  late Set<String> _selected;

  @override
  void initState() {
    super.initState();
    _selected = context
        .read<OnboardingBloc>()
        .state
        .draft
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

  void _next() => context.push<void>(RoutePaths.interests).ignore();

  @override
  Widget build(BuildContext context) {
    final atMax = _selected.length >= _maxSelections;
    return WizardScaffold(
      showSkip: true,
      onSkip: _next,
      continueLabel: _selected.isEmpty
          ? 'Continue'
          : 'Select (${_selected.length})',
      onContinue: _selected.isEmpty
          ? null
          : () {
              context.read<OnboardingBloc>().add(
                OnboardingAnswerSaved(
                  (d) => d.copyWith(personalityTraits: _selected.toList()),
                ),
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
