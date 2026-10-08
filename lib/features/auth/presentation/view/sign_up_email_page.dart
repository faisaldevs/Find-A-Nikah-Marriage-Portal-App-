import 'package:find_a_nikah/core/ui/ui.dart';
import 'package:find_a_nikah/features/auth/domain/domain.dart';
import 'package:find_a_nikah/features/auth/presentation/bloc/sign_up_bloc.dart';
import 'package:find_a_nikah/features/auth/presentation/presentation.dart'
    show LoginPage;
import 'package:find_a_nikah/features/auth/presentation/view/login_page.dart'
    show LoginPage;
import 'package:find_a_nikah/features/auth/presentation/widgets/auth_step_scaffold.dart';
import 'package:find_a_nikah/router/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// First step of the sign-up sub-flow, reached from [LoginPage]'s
/// "Sign up now". Sends a one-time code to the email.
class SignUpEmailPage extends StatefulWidget {
  const SignUpEmailPage({super.key});

  @override
  State<SignUpEmailPage> createState() => _SignUpEmailPageState();
}

class _SignUpEmailPageState extends State<SignUpEmailPage> {
  final _controller = TextEditingController();
  bool _looksValid = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    final valid = CredentialsPolicy.isValidEmail(value);
    if (valid != _looksValid) setState(() => _looksValid = valid);
  }

  @override
  Widget build(BuildContext context) {
    final busy = context.select<SignUpBloc, bool>(
      (b) => b.state.status == SignUpStatus.submitting,
    );
    return BlocListener<SignUpBloc, SignUpState>(
      listenWhen: (prev, next) =>
          prev.status != next.status &&
          next.operation == SignUpOperation.requestCode,
      listener: (context, state) {
        switch (state.status) {
          case SignUpStatus.codeSent:
            CustomToast.showSuccess(
              context,
              'Verification code sent to your email',
            );
            context.push<void>(RoutePaths.signUpCode);
            break;
          case SignUpStatus.failure:
            showFailureToast(context, state.failure!);
            break;
          case SignUpStatus.idle ||
                SignUpStatus.submitting ||
                SignUpStatus.emailVerified ||
                SignUpStatus.registered:
            break;
        }
      },
      child: AuthStepScaffold(
        title: "What's your email address?",
        subtitle: "We'll email you a code to verify your identity.",
        isLoading: busy,
        loadingLabel: 'Sending code...',
        onContinue: _looksValid && !busy
            ? () => context.read<SignUpBloc>().add(
                SignUpEmailSubmitted(_controller.text),
              )
            : null,
        body: TextField(
          controller: _controller,
          onChanged: _onChanged,
          keyboardType: TextInputType.emailAddress,
          style: TextFontStyle.headline16w400textDarkStyleSatoshi,
          decoration: InputDecoration(
            hintText: 'Email address',
            hintStyle: TextFontStyle.headline16w400textMutedStyleSatoshi,
            border: const UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.textMuted),
            ),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.textMuted),
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
