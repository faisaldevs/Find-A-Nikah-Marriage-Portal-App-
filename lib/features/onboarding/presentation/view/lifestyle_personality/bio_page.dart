import 'package:find_a_nikah/core/ui/ui.dart';
import 'package:find_a_nikah/features/onboarding/presentation/bloc/onboarding_bloc.dart';
import 'package:find_a_nikah/router/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:go_router/go_router.dart';

class BioPage extends StatefulWidget {
  const BioPage({super.key});

  @override
  State<BioPage> createState() => _BioPageState();
}

class _BioPageState extends State<BioPage> {
  late final TextEditingController _controller;
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: context.read<OnboardingBloc>().state.draft.bio ?? '',
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _submit() {
    context.read<OnboardingBloc>().add(
      OnboardingAnswerSaved((d) => d.copyWith(bio: _controller.text.trim())),
    );
    context.read<OnboardingBloc>().add(const BioSubmitted());
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<OnboardingBloc>().state;
    final hasBio = _controller.text.trim().isNotEmpty;
    return MultiBlocListener(
      listeners: [
        BlocListener<OnboardingBloc, OnboardingState>(
          listenWhen: (previous, current) =>
              previous.generatingBio && !current.generatingBio,
          listener: (context, state) {
            if (state.failure != null) {
              showFailureToast(context, state.failure!);
            }
            if (state.generatedBio case final bio?) {
              setState(() {
                _controller.value = TextEditingValue(
                  text: bio,
                  selection: TextSelection.collapsed(offset: bio.length),
                );
              });
            }
          },
        ),
        BlocListener<OnboardingBloc, OnboardingState>(
          listenWhen: (previous, current) =>
              previous.submittingStep && !current.submittingStep,
          listener: (context, state) {
            if (state.failure != null) {
              showFailureToast(context, state.failure!);
            } else {
              // End of the Profile part → Verification part starts with
              // phone.
              context.push<void>(RoutePaths.phoneNumber).ignore();
            }
          },
        ),
      ],
      child: WizardScaffold(
        continueLabel: state.submittingStep
            ? 'Saving...'
            : hasBio
            ? 'Add this bio'
            : 'Add bio',
        onContinue: hasBio && !state.generatingBio && !state.submittingStep
            ? _submit
            : null,
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const WizardHeadline(
                text: 'Bio',
                subtitle:
                    'Tell us about yourself, your hobbies & future plans!',
                padding: EdgeInsets.zero,
              ),
              SizedBox(height: 16.h),
              if (hasBio)
                Row(
                  children: [
                    _BioActionLink(
                      icon: Icons.refresh,
                      label: 'Regenerate',
                      color: AppColors.primaryColor,
                      onTap: state.generatingBio
                          ? null
                          : () => context.read<OnboardingBloc>().add(
                              const BioGenerationRequested(),
                            ),
                    ),
                    SizedBox(width: 20.w),
                    _BioActionLink(
                      icon: Icons.edit_outlined,
                      label: 'Edit manually',
                      color: AppColors.textMuted,
                      onTap: _focusNode.requestFocus,
                    ),
                  ],
                )
              else
                _BioActionLink(
                  icon: Icons.auto_awesome,
                  label: 'Generate with AI',
                  color: AppColors.primaryColor,
                  onTap: state.generatingBio
                      ? null
                      : () => context.read<OnboardingBloc>().add(
                          const BioGenerationRequested(),
                        ),
                ),
              SizedBox(height: 16.h),
              if (state.generatingBio)
                const Center(child: CircularProgressIndicator())
              else
                TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  maxLines: 8,
                  minLines: 3,
                  onChanged: (_) => setState(() {}),
                  style: TextFontStyle.headline15w400textDarkStyleSatoshi
                      .copyWith(height: 1.4),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Write a little about yourself…',
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BioActionLink extends StatelessWidget {
  const _BioActionLink({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16.r, color: color),
          SizedBox(width: 6.w),
          Text(
            label,
            style: TextFontStyle.headline14w600StyleSatoshi.copyWith(
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
