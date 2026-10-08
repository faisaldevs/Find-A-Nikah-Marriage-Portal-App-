import 'package:find_a_nikah/core/ui/ui.dart';
import 'package:find_a_nikah/features/auth/presentation/bloc/phone_verification_bloc.dart';
import 'package:find_a_nikah/router/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:go_router/go_router.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

/// First step of the Verification part: the phone number that receives a
/// one-time code on WhatsApp. Never shown on the profile.
class PhoneNumberPage extends StatefulWidget {
  const PhoneNumberPage({super.key});

  @override
  State<PhoneNumberPage> createState() => _PhoneNumberPageState();
}

class _PhoneNumberPageState extends State<PhoneNumberPage> {
  String? _completeNumber;

  void _next() => context.read<PhoneVerificationBloc>().add(
    PhoneNumberSubmitted(_completeNumber!),
  );

  @override
  Widget build(BuildContext context) {
    final busy = context.select<PhoneVerificationBloc, bool>(
      (b) => b.state.status == PhoneVerificationStatus.submitting,
    );
    final canContinue = (_completeNumber ?? '').length > 6 && !busy;
    return BlocListener<PhoneVerificationBloc, PhoneVerificationState>(
      listenWhen: (prev, next) => prev.status != next.status,
      listener: (context, state) => switch (state.status) {
        PhoneVerificationStatus.codeSent => context.push<void>(
          RoutePaths.phoneCode,
        ),
        PhoneVerificationStatus.failure => showFailureToast(
          context,
          state.failure!,
        ),
        _ => null,
      },
      child: WizardScaffold(
        onContinue: canContinue ? _next : null,
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const WizardHeadline(
                text: 'Verify your phone\nnumber on WhatsApp',
                padding: EdgeInsets.zero,
              ),
              SizedBox(height: 20.h),
              IntlPhoneField(
                initialCountryCode: 'BD',
                style: TextFontStyle.headline15w400textDarkStyleSatoshi,
                dropdownTextStyle:
                    TextFontStyle.headline15w400textDarkStyleSatoshi,
                decoration: const InputDecoration(
                  hintText: 'Enter your phone number',
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.textMuted),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.primaryColor),
                  ),
                ),
                onChanged: (phone) =>
                    setState(() => _completeNumber = phone.completeNumber),
              ),
              SizedBox(height: 12.h),
              Text(
                'Your number is only used to send a verification code and '
                'will never be shared on your profile.',
                style: TextFontStyle.headline13w400textMutedStyleSatoshi
                    .copyWith(
                      height: 1.4,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
