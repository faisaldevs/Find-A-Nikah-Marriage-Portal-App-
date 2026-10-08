import 'package:find_a_nikah/core/ui/components/app_primary_button.dart';
import 'package:find_a_nikah/core/ui/theme/text_font_style.dart';
import 'package:find_a_nikah/gen/colors.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

/// Standard loading state, so loading looks the same everywhere.
class AppLoadingView extends StatelessWidget {
  const AppLoadingView({super.key});

  @override
  Widget build(BuildContext context) => const Center(
    child: CircularProgressIndicator(color: AppColors.primaryColor),
  );
}

/// Standard empty / error / offline layout: icon, title, optional message
/// and an optional action button. Text is passed in, never hard-coded here.
class AppMessageView extends StatelessWidget {
  const AppMessageView({
    required this.icon,
    required this.title,
    super.key,
    this.message,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final String title;
  final String? message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48.r, color: AppColors.textMuted),
            SizedBox(height: 16.h),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextFontStyle.headline16w600textDarkStyleSatoshi,
            ),
            if (message != null) ...[
              SizedBox(height: 8.h),
              Text(
                message!,
                textAlign: TextAlign.center,
                style: TextFontStyle.headline14w400textMutedStyleSatoshi,
              ),
            ],
            if (actionLabel != null && onAction != null) ...[
              SizedBox(height: 24.h),
              AppPrimaryButton(label: actionLabel!, onPressed: onAction),
            ],
          ],
        ),
      ),
    );
  }
}

/// Nothing to show yet.
class AppEmptyView extends StatelessWidget {
  const AppEmptyView({required this.title, super.key, this.message});

  final String title;
  final String? message;

  @override
  Widget build(BuildContext context) => AppMessageView(
    icon: Icons.inbox_outlined,
    title: title,
    message: message,
  );
}

/// Something failed; [onRetry] repeats the action.
class AppErrorView extends StatelessWidget {
  const AppErrorView({
    required this.title,
    super.key,
    this.message,
    this.retryLabel,
    this.onRetry,
  });

  final String title;
  final String? message;
  final String? retryLabel;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) => AppMessageView(
    icon: Icons.error_outline,
    title: title,
    message: message,
    actionLabel: retryLabel,
    onAction: onRetry,
  );
}
