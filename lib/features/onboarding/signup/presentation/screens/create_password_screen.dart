import 'package:find_a_nikah/gen/colors.gen.dart';
import 'package:find_a_nikah/core/constants/text_font_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../../../../../core/router/app_navigator.dart';
import '../../../widgets/app_text_field.dart';
import '../widgets/auth_step_scaffold.dart';

/// Final step of the sign-up sub-flow. No backend exists yet — the
/// checklist below is pure client-side validation of the typed password,
/// gating Continue; nothing is sent anywhere.
class CreatePasswordScreen extends ConsumerStatefulWidget {
  const CreatePasswordScreen({super.key});

  @override
  ConsumerState<CreatePasswordScreen> createState() =>
      _CreatePasswordScreenState();
}

class _CreatePasswordScreenState extends ConsumerState<CreatePasswordScreen> {
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  bool get _hasMinLength => _passwordController.text.length >= 8;
  bool get _hasNumber => RegExp(r'[0-9]').hasMatch(_passwordController.text);
  bool get _hasLetter => RegExp(r'[a-zA-Z]').hasMatch(_passwordController.text);
  bool get _passwordsMatch =>
      _confirmController.text.isNotEmpty &&
      _confirmController.text == _passwordController.text;

  bool get _canContinue =>
      _hasMinLength && _hasNumber && _hasLetter && _passwordsMatch;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthStepScaffold(
      title: 'Create your password',
      onContinue: _canContinue
          ? () => ref.read(appNavigatorProvider).toGetStarted()
          : null,
      body: Column(
        children: [
          AppTextField(
            controller: _passwordController,
            hint: 'Enter new password',
            icon: Icons.lock_outline,
            filled: false,
            obscureText: _obscurePassword,
            onChanged: (_) => setState(() {}),
            trailing: IconButton(
              icon: Icon(
                _obscurePassword
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: AppColors.textMuted,
                size: 20.r,
              ),
              onPressed: () =>
                  setState(() => _obscurePassword = !_obscurePassword),
            ),
          ),
          SizedBox(height: 14.h),
          AppTextField(
            controller: _confirmController,
            hint: 'Confirm your password',
            icon: Icons.lock_outline,
            filled: false,
            obscureText: _obscureConfirm,
            onChanged: (_) => setState(() {}),
            trailing: IconButton(
              icon: Icon(
                _obscureConfirm
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: AppColors.textMuted,
                size: 20.r,
              ),
              onPressed: () =>
                  setState(() => _obscureConfirm = !_obscureConfirm),
            ),
          ),
          SizedBox(height: 16.h),
          _RuleRow(met: _hasMinLength, label: 'Minimum 8 characters'),
          SizedBox(height: 6.h),
          _RuleRow(met: _hasNumber, label: 'At least 1 number (1-9)'),
          SizedBox(height: 6.h),
          _RuleRow(
            met: _hasLetter,
            label: 'At least lowercase or uppercase letters',
          ),
        ],
      ),
    );
  }
}

class _RuleRow extends StatelessWidget {
  const _RuleRow({required this.met, required this.label});

  final bool met;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          met ? Icons.check_circle : Icons.cancel,
          size: 18.r,
          color: met ? AppColors.successColor : AppColors.errorColor,
        ),
        SizedBox(width: 8.w),
        Text(label, style: TextFontStyle.headline13w400textDarkStyleSatoshi),
      ],
    );
  }
}
