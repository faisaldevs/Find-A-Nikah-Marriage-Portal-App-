import 'package:find_a_nikah/core/ui/ui.dart';
import 'package:find_a_nikah/features/auth/domain/domain.dart';
import 'package:find_a_nikah/features/auth/presentation/bloc/forgot_password_cubit.dart';
import 'package:find_a_nikah/features/auth/presentation/widgets/auth_step_scaffold.dart';
import 'package:find_a_nikah/router/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:go_router/go_router.dart';

/// "Forgot Password?" step 2: the emailed code and the new password.
class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _code = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  bool _obscure = true;

  bool get _codeOk => CredentialsPolicy.isValidCode(_code.text);
  bool get _hasMinLength => CredentialsPolicy.hasMinLength(_password.text);
  bool get _hasNumber => CredentialsPolicy.hasDigit(_password.text);
  bool get _hasLetter => CredentialsPolicy.hasLetter(_password.text);
  bool get _match =>
      _confirm.text.isNotEmpty && _confirm.text == _password.text;
  bool get _canSubmit =>
      _codeOk && _hasMinLength && _hasNumber && _hasLetter && _match;

  @override
  void dispose() {
    _code.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  InputDecoration _decoration(String hint, {Widget? suffix}) => InputDecoration(
    hintText: hint,
    hintStyle: figmaText(16, 22.4, color: const Color(0xFFA3A3A3)),
    contentPadding: EdgeInsets.fromLTRB(10.w, 0, 10.w, 10.h),
    isDense: true,
    suffixIcon: suffix,
    // Keeps the eye button from making this field taller than the others.
    suffixIconConstraints: BoxConstraints(minWidth: 36.w, minHeight: 24.h),
    border: const UnderlineInputBorder(
      borderSide: BorderSide(color: Color(0xFFD4D4D4)),
    ),
    enabledBorder: const UnderlineInputBorder(
      borderSide: BorderSide(color: Color(0xFFD4D4D4)),
    ),
    focusedBorder: const UnderlineInputBorder(
      borderSide: BorderSide(color: AppColors.primaryColor),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final busy = context.select<ForgotPasswordCubit, bool>(
      (c) => c.state.status == ForgotPasswordStatus.submitting,
    );
    return BlocListener<ForgotPasswordCubit, ForgotPasswordState>(
      listenWhen: (prev, next) => prev.status != next.status,
      listener: (context, state) {
        switch (state.status) {
          case ForgotPasswordStatus.done:
            CustomToast.showSuccess(
              context,
              'Password changed. Please sign in.',
            );
            context.go(RoutePaths.login);
          case ForgotPasswordStatus.failure:
            showFailureToast(context, state.failure!);
          case ForgotPasswordStatus.idle ||
              ForgotPasswordStatus.submitting ||
              ForgotPasswordStatus.codeSent:
            break;
        }
      },
      child: AuthStepScaffold(
        title: 'Reset your\npassword',
        titleSize: 30,
        subtitle:
            'Enter the 6-digit code we emailed you and choose a new '
            'password.',
        isLoading: busy,
        loadingLabel: 'Saving...',
        onContinue: _canSubmit && !busy
            ? () => context.read<ForgotPasswordCubit>().resetPassword(
                code: _code.text.trim(),
                newPassword: _password.text,
              )
            : null,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _code,
              onChanged: (_) => setState(() {}),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(6),
              ],
              style: figmaText(16, 22.4),
              decoration: _decoration('6-digit code'),
            ),
            SizedBox(height: 24.h),
            TextField(
              controller: _password,
              onChanged: (_) => setState(() {}),
              obscureText: _obscure,
              style: figmaText(16, 22.4),
              decoration: _decoration(
                'New password',
                suffix: IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: Icon(
                    _obscure
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    size: 20.r,
                  ),
                  onPressed: () => setState(() => _obscure = !_obscure),
                ),
              ),
            ),
            SizedBox(height: 24.h),
            TextField(
              controller: _confirm,
              onChanged: (_) => setState(() {}),
              obscureText: _obscure,
              style: figmaText(16, 22.4),
              decoration: _decoration('Confirm new password'),
            ),
            SizedBox(height: 20.h),
            _Rule(met: _hasMinLength, label: 'Minimum 8 characters'),
            _Rule(met: _hasNumber, label: 'At least 1 number'),
            _Rule(
              met: _hasLetter,
              label: 'At least lowercase or uppercase letters',
            ),
            _Rule(met: _match, label: 'Both passwords match'),
          ],
        ),
      ),
    );
  }
}

class _Rule extends StatelessWidget {
  const _Rule({required this.met, required this.label});

  final bool met;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 10.w),
      child: Row(
        children: [
          Icon(
            met ? Icons.check_circle_outline : Icons.cancel_outlined,
            size: 18.r,
            color: met ? const Color(0xFF3FB68B) : const Color(0xFFD9534F),
          ),
          SizedBox(width: 8.w),
          Text(label, style: figmaText(14, 20)),
        ],
      ),
    );
  }
}
