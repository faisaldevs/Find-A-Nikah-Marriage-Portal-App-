import 'package:find_a_nikah/core/ui/ui.dart';
import 'package:find_a_nikah/features/onboarding/presentation/bloc/onboarding_bloc.dart';
import 'package:find_a_nikah/features/onboarding/presentation/widgets/wizard_chip_group.dart';
import 'package:find_a_nikah/features/onboarding/presentation/widgets/wizard_options.dart';
import 'package:find_a_nikah/router/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:go_router/go_router.dart';

const _maxSelections = 8;

class FaithPage extends StatefulWidget {
  const FaithPage({super.key});

  @override
  State<FaithPage> createState() => _FaithPageState();
}

class _FaithPageState extends State<FaithPage> {
  late Set<String> _selected;

  @override
  void initState() {
    super.initState();
    _selected = context.read<OnboardingBloc>().state.draft.faithTags.toSet();
  }

  void _toggle(String value) {
    setState(() {
      if (!_selected.remove(value) && _selected.length < _maxSelections) {
        _selected.add(value);
      }
    });
  }

  void _next() => context.push<void>(RoutePaths.religiousPractice).ignore();

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
                  (d) => d.copyWith(faithTags: _selected.toList()),
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
              text: 'Faith',
              subtitle:
                  'Choose up to 8 to describe what matters most in your '
                  'Islamic practise.',
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
