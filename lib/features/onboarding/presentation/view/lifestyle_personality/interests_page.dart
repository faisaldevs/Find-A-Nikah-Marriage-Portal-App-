import 'package:find_a_nikah/core/ui/ui.dart';
import 'package:find_a_nikah/features/onboarding/presentation/bloc/onboarding_bloc.dart';
import 'package:find_a_nikah/features/onboarding/presentation/widgets/wizard_chip_group.dart';
import 'package:find_a_nikah/features/onboarding/presentation/widgets/wizard_options.dart';
import 'package:find_a_nikah/router/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:go_router/go_router.dart';

const _maxSelections = 15;

class InterestsPage extends StatefulWidget {
  const InterestsPage({super.key});

  @override
  State<InterestsPage> createState() => _InterestsPageState();
}

class _InterestsPageState extends State<InterestsPage> {
  late Set<String> _selected;

  @override
  void initState() {
    super.initState();
    _selected = context.read<OnboardingBloc>().state.draft.interests.toSet();
  }

  void _toggle(String value) {
    setState(() {
      if (!_selected.remove(value) && _selected.length < _maxSelections) {
        _selected.add(value);
      }
    });
  }

  void _submit() {
    context.read<OnboardingBloc>().add(
      OnboardingAnswerSaved((d) => d.copyWith(interests: _selected.toList())),
    );
    context.read<OnboardingBloc>().add(const LifestylePersonalitySubmitted());
  }

  @override
  Widget build(BuildContext context) {
    final submitting = context.select<OnboardingBloc, bool>(
      (b) => b.state.submittingStep,
    );
    final atMax = _selected.length >= _maxSelections;
    final allOptions = interestCategories.values.expand((v) => v).toSet();
    return BlocListener<OnboardingBloc, OnboardingState>(
      listenWhen: (prev, next) => prev.submittingStep && !next.submittingStep,
      listener: (context, state) {
        if (state.failure != null) {
          showFailureToast(context, state.failure!);
        } else {
          context.push<void>(RoutePaths.bio).ignore();
        }
      },
      child: WizardScaffold(
        showSkip: true,
        onSkip: submitting ? null : _submit,
        continueLabel: submitting
            ? 'Saving...'
            : _selected.isEmpty
            ? 'Continue'
            : 'Select (${_selected.length})',
        onContinue: _selected.isEmpty || submitting ? null : _submit,
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const WizardHeadline(
                text: 'What are your interests?',
                subtitle:
                    'Select up to 15 interests to make your profile stand '
                    'out!',
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
      ),
    );
  }
}
