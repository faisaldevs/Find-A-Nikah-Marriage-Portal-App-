import 'package:find_a_nikah/core/ui/ui.dart';
import 'package:find_a_nikah/features/onboarding/presentation/bloc/onboarding_bloc.dart';
import 'package:find_a_nikah/features/onboarding/presentation/widgets/wizard_options.dart';
import 'package:find_a_nikah/router/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:go_router/go_router.dart';

class HeightPage extends StatefulWidget {
  const HeightPage({super.key});

  @override
  State<HeightPage> createState() => _HeightPageState();
}

class _HeightPageState extends State<HeightPage> {
  int? _cm;
  final List<({int cm, String label})> _options = buildHeightOptions();

  @override
  void initState() {
    super.initState();
    _cm = context.read<OnboardingBloc>().state.draft.heightCm;
  }

  void _continue() {
    context.read<OnboardingBloc>().add(
      OnboardingAnswerSaved((d) => d.copyWith(heightCm: _cm)),
    );
    context.read<OnboardingBloc>().add(const BasicsSubmitted());
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
          context.push<void>(RoutePaths.education).ignore();
        }
      },
      child: WizardScaffold(
        continueLabel: submitting ? 'Saving...' : 'Continue',
        onContinue: _cm == null || submitting ? null : _continue,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const WizardHeadline(text: 'How tall are you?'),
            SizedBox(height: 8.h),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                itemCount: _options.length,
                itemBuilder: (context, i) {
                  final option = _options[i];
                  final selected = option.cm == _cm;
                  return InkWell(
                    onTap: () => setState(() => _cm = option.cm),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      child: Row(
                        children: [
                          Container(
                            width: 22.r,
                            height: 22.r,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: selected
                                    ? AppColors.primaryColor
                                    : AppColors.textMuted,
                                width: 2,
                              ),
                            ),
                            child: selected
                                ? Center(
                                    child: Container(
                                      width: 11.r,
                                      height: 11.r,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: AppColors.primaryColor,
                                      ),
                                    ),
                                  )
                                : null,
                          ),
                          SizedBox(width: 12.w),
                          Text(
                            option.label,
                            style: selected
                                ? TextFontStyle
                                      .headline15w500primaryColorStyleSatoshi
                                : TextFontStyle
                                      .headline15w500textDarkStyleSatoshi,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
