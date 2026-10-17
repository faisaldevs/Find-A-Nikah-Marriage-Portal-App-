import 'package:find_a_nikah/core/ui/ui.dart';
import 'package:find_a_nikah/features/onboarding/presentation/bloc/onboarding_bloc.dart';
import 'package:find_a_nikah/features/onboarding/presentation/widgets/wizard_radio_tile.dart';
import 'package:find_a_nikah/router/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:go_router/go_router.dart';

class LifestylePreferencesPage extends StatefulWidget {
  const LifestylePreferencesPage({super.key});

  @override
  State<LifestylePreferencesPage> createState() =>
      _LifestylePreferencesPageState();
}

class _LifestylePreferencesPageState extends State<LifestylePreferencesPage> {
  bool? _halal;
  bool? _smokes;
  bool? _drinks;

  @override
  void initState() {
    super.initState();
    final data = context.read<OnboardingBloc>().state.draft;
    _halal = data.eatsHalalOnly;
    _smokes = data.smokes;
    _drinks = data.drinksAlcohol;
  }

  @override
  Widget build(BuildContext context) {
    final canContinue = _halal != null && _smokes != null && _drinks != null;
    return WizardScaffold(
      onContinue: !canContinue
          ? null
          : () {
              context.read<OnboardingBloc>().add(
                OnboardingAnswerSaved(
                  (d) => d.copyWith(
                    eatsHalalOnly: _halal,
                    smokes: _smokes,
                    drinksAlcohol: _drinks,
                  ),
                ),
              );
              context.push<void>(RoutePaths.aboutYou).ignore();
            },
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          // Full width (the wizard body is loosely constrained).
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const WizardHeadline(
              text: 'Lifestyle preferences',
              subtitle:
                  'Tell us about your daily habits to help us personalize '
                  'your matches.',
              padding: EdgeInsets.zero,
              subtitleGap: 10,
            ),
            // SizedBox(height: 20.h),
            // Figma: subtitle sits in a 10pt-padded box, then 40pt.
            SizedBox(height: 50.h),
            YesNoQuestion(
              label: 'Do you only eat Halal food?',
              value: _halal,
              onChanged: (v) => setState(() => _halal = v),
            ),
            YesNoQuestion(
              label: 'Do you smoke?',
              value: _smokes,
              onChanged: (v) => setState(() => _smokes = v),
            ),
            YesNoQuestion(
              label: 'Do you drink alcohol?',
              value: _drinks,
              onChanged: (v) => setState(() => _drinks = v),
              trailingDivider: false,
            ),
            SizedBox(height: 12.h),
          ],
        ),
      ),
    );
  }
}
