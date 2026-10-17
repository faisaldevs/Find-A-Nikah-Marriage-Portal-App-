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
        // body: SingleChildScrollView(
        // padding: EdgeInsets.symmetric(horizontal: 20.w),
        // child: Column(
        // crossAxisAlignment: CrossAxisAlignment.start,
        // children: [
        // const WizardHeadline(
        // text: 'Bio',
        // subtitle:
        // 'Tell us about yourself, your hobbies & future plans!',
        // padding: EdgeInsets.zero,
        // ),
        // SizedBox(height: 16.h),
        // if (hasBio)
        // Row(
        // children: [
        // _BioActionLink(
        // icon: Icons.refresh,
        // label: 'Regenerate',
        // color: AppColors.primaryColor,
        // onTap: state.generatingBio
        // ? null
        // : () => context.read<OnboardingBloc>().add(
        // const BioGenerationRequested(),
        // ),
        // ),
        // SizedBox(width: 20.w),
        // _BioActionLink(
        // icon: Icons.edit_outlined,
        // label: 'Edit manually',
        // color: AppColors.textMuted,
        // onTap: _focusNode.requestFocus,
        // ),
        // ],
        // )
        // else
        // _BioActionLink(
        // icon: Icons.auto_awesome,
        // label: 'Generate with AI',
        // color: AppColors.primaryColor,
        // onTap: state.generatingBio
        // ? null
        // : () => context.read<OnboardingBloc>().add(
        // const BioGenerationRequested(),
        // ),
        // ),
        // SizedBox(height: 16.h),
        // if (state.generatingBio)
        // const Center(child: CircularProgressIndicator())
        // else
        // TextField(
        // controller: _controller,
        // focusNode: _focusNode,
        // maxLines: 8,
        // minLines: 3,
        // onChanged: (_) => setState(() {}),
        // style: TextFontStyle.headline15w400textDarkStyleSatoshi
        // .copyWith(height: 1.4),
        // decoration: const InputDecoration(
        // border: InputBorder.none,
        // hintText: 'Write a little about yourself…',
        // ),
        // ),
        // ],
        // ),
        // ),
        // Figma 883:4737 / 883:4689: the prompt (empty) or the bio itself
        // sits 20pt under the title — grey #A3A3A3 hint, #525252 text,
        // Regular 15 — with the AI actions 40pt below it.
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const WizardHeadline(text: 'Bio', padding: EdgeInsets.zero),
              SizedBox(height: 20.h),
              TextField(
                controller: _controller,
                focusNode: _focusNode,
                // Grows with the text — a fixed 8 lines clipped long bios.
                maxLines: null,
                enabled: !state.generatingBio,
                onChanged: (_) => setState(() {}),
                style: figmaText(15, 21, color: const Color(0xFF525252)),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                  hintText:
                      'Tell us about yourself, your hobbies & future plans!',
                  hintStyle: figmaText(15, 21, color: const Color(0xFFA3A3A3)),
                ),
              ),
              SizedBox(height: 50.h),
              if (state.generatingBio)
                Row(
                  children: [
                    SizedBox.square(
                      dimension: 18.r,
                      child: const CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.errorColor,
                      ),
                    ),
                    SizedBox(width: 7.w),
                    Text(
                      'Generating…',
                      style: figmaText(
                        16,
                        22.4,
                        weight: FontWeight.w500,
                        color: AppColors.errorColor,
                      ),
                    ),
                  ],
                )
              else if (hasBio)
                Row(
                  children: [
                    _BioActionLink(
                      icon: Icons.replay,
                      label: 'Regenerate',
                      color: AppColors.errorColor,
                      onTap: () => context.read<OnboardingBloc>().add(
                        const BioGenerationRequested(),
                      ),
                    ),
                    SizedBox(width: 24.w),
                    _BioActionLink(
                      icon: Icons.edit_outlined,
                      label: 'Edit manually',
                      color: const Color(0xFF737373),
                      onTap: _focusNode.requestFocus,
                    ),
                  ],
                )
              else
                Align(
                  alignment: Alignment.centerLeft,
                  child: _BioActionLink(
                    icon: Icons.auto_awesome_outlined,
                    label: 'Generate with AI',
                    color: AppColors.errorColor,
                    iconColor: AppColors.primaryColor,
                    onTap: () => context.read<OnboardingBloc>().add(
                      const BioGenerationRequested(),
                    ),
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
    this.iconColor,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback? onTap;

  /// Figma tints the sparkle pink while its label is red.
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        // children: [
        // Icon(icon, size: 16.r, color: color),
        // SizedBox(width: 6.w),
        // Text(
        // label,
        // style: TextFontStyle.headline14w600StyleSatoshi.copyWith(
        // color: color,
        // ),
        // ),
        // ],
        // Figma: 18pt icon, 7pt gap, Medium 16.
        children: [
          Icon(icon, size: 18.r, color: iconColor ?? color),
          SizedBox(width: 7.w),
          Text(
            label,
            style: figmaText(16, 22.4, weight: FontWeight.w500, color: color),
          ),
        ],
      ),
    );
  }
}
