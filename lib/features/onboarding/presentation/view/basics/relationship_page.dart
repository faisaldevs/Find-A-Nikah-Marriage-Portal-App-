import 'package:find_a_nikah/core/ui/ui.dart';
import 'package:find_a_nikah/features/onboarding/presentation/bloc/onboarding_bloc.dart';
import 'package:find_a_nikah/features/onboarding/presentation/widgets/wizard_options.dart';
import 'package:find_a_nikah/features/onboarding/presentation/widgets/wizard_radio_tile.dart';
import 'package:find_a_nikah/router/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:go_router/go_router.dart';

const relationshipOptions = [
  WizardOption('son', 'Son'),
  WizardOption('daughter', 'Daughter'),
  WizardOption('brother', 'Brother'),
  WizardOption('sister', 'Sister'),
  WizardOption('other_family_member', 'Other family member'),
];

/// Family flow only — asked right after "Family account" is chosen on
/// Account type, before Basic Information (whose copy then uses this
/// relationship's pronoun).
class RelationshipPage extends StatefulWidget {
  const RelationshipPage({super.key});

  @override
  State<RelationshipPage> createState() => _RelationshipPageState();
}

class _RelationshipPageState extends State<RelationshipPage> {
  String? _value;

  @override
  void initState() {
    super.initState();
    _value = context.read<OnboardingBloc>().state.draft.relationship;
  }

  @override
  Widget build(BuildContext context) {
    return WizardScaffold(
      onContinue: _value == null
          ? null
          : () {
              context.read<OnboardingBloc>().add(
                OnboardingAnswerSaved((d) => d.copyWith(relationship: _value)),
              );
              context.push<void>(RoutePaths.basicInformation).ignore();
            },
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const WizardHeadline(
            // text: 'Who are you creating\nthis profile for?',
            text: 'Who are you creating this profile for?',
            subtitle:
                "Select your relationship with the person you're helping.",
            subtitleGap: 24,
          ),
          // SizedBox(height: 8.h),
          SizedBox(height: 50.h),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: WizardRadioGroup(
                options: relationshipOptions,
                value: _value,
                onChanged: (v) => setState(() => _value = v),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
