import 'package:find_a_nikah/core/ui/ui.dart';
import 'package:find_a_nikah/features/auth/presentation/bloc/phone_verification_bloc.dart';
import 'package:find_a_nikah/router/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  var _digits = '';
  var _isBd = true;

  /// Bangladesh: 11 digits when typed with the leading 0 (01903440069),
  /// 10 without it (1903440069). Other countries use the field's own limit.
  static int _bdMax(String digits) => digits.startsWith('0') ? 11 : 10;

  void _next() {
    context.read<PhoneVerificationBloc>().add(
      PhoneNumberSubmitted(_completeNumber!),
    );
    // Before the phone API existed: skip straight to the code screen.
    // context.push<void>(RoutePaths.phoneCode).ignore();
  }

  @override
  Widget build(BuildContext context) {
    final busy = context.select<PhoneVerificationBloc, bool>(
      (b) => b.state.status == PhoneVerificationStatus.submitting,
    );
    final lengthOk = _isBd
        ? _digits.length == _bdMax(_digits)
        : (_completeNumber ?? '').length > 6;
    final canContinue = lengthOk && !busy;
    return BlocListener<PhoneVerificationBloc, PhoneVerificationState>(
      // Only while on top: the code page (pushed over this one) handles
      // its own results — otherwise its errors would toast twice.
      listenWhen: (prev, next) =>
          prev.status != next.status &&
          (ModalRoute.of(context)?.isCurrent ?? true),
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
                // BD length rule is ours (above); the field's fixed limit
                // would block the 11-digit "0…" form.
                disableLengthCheck: _isBd,
                inputFormatters: _isBd
                    ? [
                        FilteringTextInputFormatter.digitsOnly,
                        TextInputFormatter.withFunction(
                          (old, next) =>
                              next.text.length > _bdMax(next.text) ? old : next,
                        ),
                      ]
                    : null,
                onCountryChanged: (c) => setState(() {
                  _isBd = c.code == 'BD';
                  _digits = '';
                  _completeNumber = null;
                }),
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
                onChanged: (phone) => setState(() {
                  _digits = phone.number;
                  // The leading trunk 0 is not part of the +880 number.
                  _completeNumber = _isBd
                      ? phone.countryCode +
                            phone.number.replaceFirst(RegExp('^0'), '')
                      : phone.completeNumber;
                }),
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
