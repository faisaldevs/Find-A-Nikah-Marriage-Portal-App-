import 'package:find_a_nikah/core/ui/ui.dart';
import 'package:find_a_nikah/features/auth/domain/domain.dart';
import 'package:find_a_nikah/features/auth/presentation/bloc/sign_up_bloc.dart';
import 'package:find_a_nikah/features/auth/presentation/widgets/app_text_field.dart';
import 'package:find_a_nikah/features/auth/presentation/widgets/auth_step_scaffold.dart';
import 'package:find_a_nikah/router/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:go_router/go_router.dart';

/// Final step of the sign-up sub-flow: creates the account. The checklist
/// gates Continue; on success the session starts and the router moves on
/// to "Get started".
class CreatePasswordPage extends StatefulWidget {
  const CreatePasswordPage({super.key});

  @override
  State<CreatePasswordPage> createState() => _CreatePasswordPageState();
}

class _CreatePasswordPageState extends State<CreatePasswordPage> {
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  bool get _hasMinLength =>
      CredentialsPolicy.hasMinLength(_passwordController.text);
  bool get _hasNumber => CredentialsPolicy.hasDigit(_passwordController.text);
  bool get _hasLetter => CredentialsPolicy.hasLetter(_passwordController.text);
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
    final busy = context.select<SignUpBloc, bool>(
      (b) => b.state.status == SignUpStatus.submitting,
    );
    return BlocListener<SignUpBloc, SignUpState>(
      listenWhen: (prev, next) =>
          prev.status != next.status &&
          next.operation == SignUpOperation.createAccount,
      listener: (context, state) => switch (state.status) {
        // Account created → "Get started" (back returns here, as before).
        SignUpStatus.registered => _onAccountCreated(context),
        SignUpStatus.failure => showFailureToast(context, state.failure!),
        _ => null,
      },
      child: AuthStepScaffold(
        title: 'Create your password',
        bodyGap: 60,
        // Figma 883:6098 has no Terms line on this step.
        showLegalFooter: false,
        isLoading: busy,
        loadingLabel: 'Creating account...',
        onContinue: _canContinue && !busy
            ? () => context.read<SignUpBloc>().add(
                SignUpPasswordSubmitted(_passwordController.text),
              )
            : null,
        body: Column(
          children: [
            AppTextField(
              controller: _passwordController,
              hint: 'Enter new password',
              icon: Icons.lock_outline,
              // filled: false,
              fontSize: 15,
              obscureText: _obscurePassword,
              onChanged: (_) => setState(() {}),
              trailing: IconButton(
                icon: Icon(
                  _obscurePassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  // color: AppColors.textMuted,
                  color: AppColors.greyColor,
                  size: 20.r,
                ),
                onPressed: () =>
                    setState(() => _obscurePassword = !_obscurePassword),
              ),
            ),
            // SizedBox(height: 14.h),
            SizedBox(height: 24.h),
            AppTextField(
              controller: _confirmController,
              hint: 'Confirm your password',
              icon: Icons.lock_outline,
              // filled: false,
              fontSize: 15,
              obscureText: _obscureConfirm,
              onChanged: (_) => setState(() {}),
              trailing: IconButton(
                icon: Icon(
                  _obscureConfirm
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  // color: AppColors.textMuted,
                  color: AppColors.greyColor,
                  size: 20.r,
                ),
                onPressed: () =>
                    setState(() => _obscureConfirm = !_obscureConfirm),
              ),
            ),
            SizedBox(height: 16.h),
            // Figma 883:6130: rules inset 10pt, 8pt apart.
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Column(
                children: [
                  _RuleRow(met: _hasMinLength, label: 'Minimum 8 characters'),
                  // SizedBox(height: 6.h),
                  SizedBox(height: 8.h),
                  _RuleRow(met: _hasNumber, label: 'At least 1 number (1-9)'),
                  // SizedBox(height: 6.h),
                  SizedBox(height: 8.h),
                  _RuleRow(
                    met: _hasLetter,
                    label: 'At least lowercase or uppercase letters',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onAccountCreated(BuildContext context) {
    context.push<void>(RoutePaths.getStarted, extra: true).ignore();
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
        // Icon(
        //   met ? Icons.check_circle : Icons.cancel,
        //   size: 18.r,
        //   color: met ? AppColors.successColor : AppColors.errorColor,
        // ),
        // SizedBox(width: 8.w),
        // Text(label, style: TextFontStyle.headline13w400textDarkStyleSatoshi),
        // Figma: outlined check/x circles — green-500 met, red-500 unmet.
        Icon(
          met ? Icons.check_circle_outline : Icons.highlight_off,
          size: 18.r,
          color: met ? const Color(0xFF00C191) : const Color(0xFFE54848),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            label,
            style: figmaText(12, 18, color: const Color(0xFF121212)),
          ),
        ),
      ],
    );
  }
}
