import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

/// App-wide, consistent toast notifications.
class CustomToast {
  CustomToast._();

  static const _defaultDuration = Duration(seconds: 3);

  static void _show({
    required BuildContext context,
    required ToastificationType type,
    required String title,
    required IconData icon,
    required Color color,
    String? description,
    Duration duration = _defaultDuration,
  }) {
    Toastification().show(
      context: context,
      type: type,
      style: ToastificationStyle.fillColored,
      alignment: Alignment.topRight,
      autoCloseDuration: duration,
      animationDuration: const Duration(milliseconds: 250),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
          color: Colors.white,
        ),
      ),
      description: description == null
          ? null
          : Text(description, style: const TextStyle(color: Colors.white)),
      icon: Icon(icon, color: Colors.white),
      primaryColor: color,
      backgroundColor: color,
      foregroundColor: Colors.white,
      borderRadius: BorderRadius.circular(10),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      boxShadow: const [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 10,
          offset: Offset(0, 4),
        ),
      ],
      showIcon: true,
      showProgressBar: false,
      closeOnClick: true,
      dragToClose: true,
      applyBlurEffect: true,
    );
  }

  static void showSuccess(
    BuildContext context,
    String message, {
    String? description,
  }) => _show(
    context: context,
    type: ToastificationType.success,
    title: message,
    description: description,
    icon: Icons.check_circle_rounded,
    color: const Color(0xFF15803D),
  );

  static void showWarning(
    BuildContext context,
    String message, {
    String? description,
  }) => _show(
    context: context,
    type: ToastificationType.warning,
    title: message,
    description: description,
    icon: Icons.warning_amber_rounded,
    color: const Color(0xFFC2410C),
  );

  static void showError(
    BuildContext context,
    String message, {
    String? description,
  }) => _show(
    context: context,
    type: ToastificationType.error,
    title: message,
    description: description,
    icon: Icons.error_outline_rounded,
    color: const Color(0xFFB91C1C),
  );

  static void showInfo(
    BuildContext context,
    String message, {
    String? description,
  }) => _show(
    context: context,
    type: ToastificationType.info,
    title: message,
    description: description,
    icon: Icons.info_outline_rounded,
    color: const Color(0xFF1D4ED8),
  );
}
