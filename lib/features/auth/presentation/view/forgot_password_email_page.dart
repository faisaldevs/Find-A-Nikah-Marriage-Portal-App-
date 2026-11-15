import 'package:find_a_nikah/core/ui/ui.dart';
import 'package:find_a_nikah/features/auth/domain/domain.dart';
import 'package:find_a_nikah/features/auth/presentation/bloc/forgot_password_cubit.dart';
import 'package:find_a_nikah/features/auth/presentation/widgets/auth_step_scaffold.dart';
import 'package:find_a_nikah/router/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:go_router/go_router.dart';

/// "Forgot Password?" step 1: the account's email gets a reset code.
class ForgotPasswordEmailPage extends StatefulWidget {
  const ForgotPasswordEmailPage({super.key});

  @override
  State<ForgotPasswordEmailPage> createState() =>
      _ForgotPasswordEmailPageState();
}

class _ForgotPasswordEmailPageState extends State<ForgotPasswordEmailPage> {
  final _controller = TextEditingController();
  bool _looksValid = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final busy = context.select<ForgotPasswordCubit, bool>(
      (c) => c.state.status == ForgotPasswordStatus.submitting,
    );
    return BlocListener<ForgotPasswordCubit, ForgotPasswordState>(
      listenWhen: (prev, next) => prev.status != next.status,
      listener: (context, state) {
        switch (state.status) {
          case ForgotPasswordStatus.codeSent:
            CustomToast.showSuccess(
              context,
              'If that email has an account, a code is on its way',
            );
            context.push<void>(RoutePaths.resetPassword).ignore();
          case ForgotPasswordStatus.failure:
            showFailureToast(context, state.failure!);
          case ForgotPasswordStatus.idle ||
              ForgotPasswordStatus.submitting ||
              ForgotPasswordStatus.done:
            break;
        }
      },
      child: AuthStepScaffold(
        title: 'Forgot your\npassword?',
        titleSize: 30,
        subtitle: "Enter your email and we'll send you a code to reset it.",
        isLoading: busy,
        loadingLabel: 'Sending code...',
        onContinue: _looksValid && !busy
            ? () => context.read<ForgotPasswordCubit>().requestCode(
                _controller.text,
              )
            : null,
        body: TextField(
          controller: _controller,
          onChanged: (v) {
            final valid = CredentialsPolicy.isValidEmail(v);
            if (valid != _looksValid) setState(() => _looksValid = valid);
          },
          keyboardType: TextInputType.emailAddress,
          textCapitalization: TextCapitalization.none,
          autocorrect: false,
          enableSuggestions: false,
          autofillHints: const [AutofillHints.email],
          style: figmaText(16, 22.4),
          decoration: InputDecoration(
            hintText: 'Email address',
            hintStyle: figmaText(16, 22.4, color: const Color(0xFFA3A3A3)),
            contentPadding: EdgeInsets.fromLTRB(10.w, 0, 10.w, 10.h),
            isDense: true,
            border: const UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFD4D4D4)),
            ),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFD4D4D4)),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.primaryColor),
            ),
          ),
        ),
      ),
    );
  }
}
