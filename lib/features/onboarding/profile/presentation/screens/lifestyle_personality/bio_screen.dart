import 'dart:math';
import 'package:find_a_nikah/core/constants/text_font_style.dart';

import 'package:find_a_nikah/gen/colors.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../../../../../../core/router/app_navigator.dart';
import '../../../../state/onboarding_controller.dart';
// import '../widgets/wizard_scaffold.dart'; // moved to core/ui/components (shared with features/auth)
import '../../../../../../core/ui/components/wizard_scaffold.dart';

// const _totalSteps = 17; // step/progress now from OnboardingRoutes.wizardSections

/// No AI backend exists yet — "Generate with AI" / "Regenerate" just pick a
/// canned sample bio after a short fake delay, same spirit as the sign-up
/// verification screen accepting any code.
const _sampleBios = [
  "I'm a Lead designer focused on creating intuitive, user-centered digital "
      'experiences for web, mobile, SaaS, and dashboard products. I combine '
      'ux research, information architecture, user flows, wireframes, and '
      'modern ui design to turn complex ideas into simple, engaging '
      'experiences',
  'Family-oriented and easygoing, I love exploring new places, trying out '
      'new recipes, and spending quiet evenings with a good book. Looking '
      'to build a life together grounded in faith, kindness, and shared '
      'goals.',
  'Career-driven but never too busy for the people who matter. I enjoy '
      'football on weekends, volunteering locally, and long conversations '
      'over chai. Hoping to find someone who values honesty and growth as '
      'much as I do.',
];

class BioScreen extends ConsumerStatefulWidget {
  const BioScreen({super.key});

  @override
  ConsumerState<BioScreen> createState() => _BioScreenState();
}

class _BioScreenState extends ConsumerState<BioScreen> {
  late final TextEditingController _controller;
  final _focusNode = FocusNode();
  bool _generating = false;
  String? _lastGenerated;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: ref.read(onboardingControllerProvider).bio ?? '',
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _generate() async {
    setState(() => _generating = true);
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    final options = _sampleBios.where((b) => b != _lastGenerated).toList();
    final next = options[Random().nextInt(options.length)];
    setState(() {
      _generating = false;
      _lastGenerated = next;
      _controller.text = next;
    });
  }

  void _next() {
    ref
        .read(onboardingControllerProvider.notifier)
        .patch((d) => d.copyWith(bio: _controller.text.trim()));
    // End of the Profile part → Verification part starts with phone.
    ref.read(appNavigatorProvider).toPhoneNumber();
    // ref.read(appNavigatorProvider).toAddPhotos();  // photos now come after the phone OTP
  }

  @override
  Widget build(BuildContext context) {
    final hasBio = _controller.text.trim().isNotEmpty;
    return WizardScaffold(
      // title: 'Bio',  // now from OnboardingRoutes.wizardSections
      // step: _totalSteps,
      // totalSteps: _totalSteps,
      continueLabel: hasBio ? 'Add this bio' : 'Add bio',
      onContinue: hasBio ? _next : null,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const WizardHeadline(
              text: 'Bio',
              subtitle: 'Tell us about yourself, your hobbies & future plans!',
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
                    onTap: _generating ? null : _generate,
                  ),
                  SizedBox(width: 20.w),
                  _BioActionLink(
                    icon: Icons.edit_outlined,
                    label: 'Edit manually',
                    color: AppColors.textMuted,
                    onTap: () => _focusNode.requestFocus(),
                  ),
                ],
              )
            else
              _BioActionLink(
                icon: Icons.auto_awesome,
                label: 'Generate with AI',
                color: AppColors.primaryColor,
                onTap: _generating ? null : _generate,
              ),
            SizedBox(height: 16.h),
            if (_generating)
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
