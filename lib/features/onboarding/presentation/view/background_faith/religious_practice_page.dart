import 'package:find_a_nikah/core/ui/ui.dart';
import 'package:find_a_nikah/features/onboarding/presentation/bloc/onboarding_bloc.dart';
import 'package:find_a_nikah/features/onboarding/presentation/widgets/wizard_options.dart';
import 'package:find_a_nikah/features/onboarding/presentation/widgets/wizard_radio_tile.dart';
import 'package:find_a_nikah/router/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:go_router/go_router.dart';

class ReligiousPracticePage extends StatefulWidget {
  const ReligiousPracticePage({super.key});

  @override
  State<ReligiousPracticePage> createState() => _ReligiousPracticePageState();
}

class _ReligiousPracticePageState extends State<ReligiousPracticePage> {
  String? _value;

  @override
  void initState() {
    super.initState();
    _value = context.read<OnboardingBloc>().state.draft.religionPracticeLevel;
  }

  void _continue() {
    context.read<OnboardingBloc>().add(
      OnboardingAnswerSaved((d) => d.copyWith(religionPracticeLevel: _value)),
    );
    context.read<OnboardingBloc>().add(const BackgroundFaithSubmitted());
  }

  @override
  Widget build(BuildContext context) {
    final submitting = context.select<OnboardingBloc, bool>(
      (b) => b.state.submittingStep,
    );
    return BlocListener<OnboardingBloc, OnboardingState>(
      listenWhen: (prev, next) => prev.submittingStep && !next.submittingStep,
      listener: (context, state) {
        if (state.failure != null) {
          showFailureToast(context, state.failure!);
        } else {
          context.push<void>(RoutePaths.lifestylePreferences).ignore();
        }
      },
      child: WizardScaffold(
        continueLabel: submitting ? 'Saving...' : 'Continue',
        onContinue: _value == null || submitting ? null : _continue,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const WizardHeadline(text: 'How do you practise\nyour religion?'),
            SizedBox(height: 8.h),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: WizardRadioGroup(
                  options: religionPracticeOptions,
                  value: _value,
                  divider: true,
                  onChanged: (v) => setState(() => _value = v),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
