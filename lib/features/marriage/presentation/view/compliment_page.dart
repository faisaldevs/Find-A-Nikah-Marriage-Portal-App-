import 'package:find_a_nikah/core/ui/ui.dart';
import 'package:find_a_nikah/features/marriage/presentation/widgets/profile_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

/// Full-screen "Compliment" writer opened by the middle action button.
/// Pops with the trimmed text on Submit, or null when closed.
Future<String?> showComplimentPage(
  BuildContext context, {
  required String name,
}) {
  return Navigator.of(context, rootNavigator: true).push<String>(
    PageRouteBuilder<String>(
      opaque: false,
      transitionDuration: const Duration(milliseconds: 300),
      reverseTransitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (_, _, _) => _ComplimentPage(name: name),
      // transitionsBuilder: (_, animation, _, child) =>
      //     FadeTransition(opacity: animation, child: child),
      // The reference slides the panel up from the bottom edge, with the
      // profile still showing above it while it rises.
      transitionsBuilder: (_, animation, _, child) => SlideTransition(
        position: Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
            .animate(
              CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutCubic,
                reverseCurve: Curves.easeInCubic,
              ),
            ),
        child: child,
      ),
    ),
  );
}

class _ComplimentPage extends StatefulWidget {
  const _ComplimentPage({required this.name});

  final String name;

  @override
  State<_ComplimentPage> createState() => _ComplimentPageState();
}

class _ComplimentPageState extends State<_ComplimentPage> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _canSubmit => _controller.text.trim().isNotEmpty;

  void _submit() {
    if (_canSubmit) Navigator.of(context).pop(_controller.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    final fieldStyle = TextFontStyle.headline14w400textDarkStyleSatoshi
        .copyWith(color: kProfileInk)
        .lh(20);
    return Scaffold(
      // backgroundColor: const Color(0xF2101012),
      // Translucent: the profile shows faintly through, as in the reference.
      backgroundColor: const Color(0xE00A0A0C),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            kProfileGutter,
            8.h,
            kProfileGutter,
            16.h,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close, color: Colors.white),
                  tooltip: 'Close',
                ),
              ),
              Text(
                'Message ${widget.name}',
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextFontStyle.headline14w400textMutedStyleSatoshi
                    .copyWith(
                      color: kProfileLabelGrey,
                      fontSize: 11.sp,
                      letterSpacing: 1.2,
                    ),
              ),
              SizedBox(height: 4.h),
              Text(
                'Compliment',
                textAlign: TextAlign.center,
                style: TextFontStyle.headline16w700textDarkStyleSatoshi
                    .copyWith(color: Colors.white, fontSize: 20.sp),
              ),
              SizedBox(height: 16.h),
              // Fills the space the keyboard leaves, as in the reference.
              Expanded(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: kProfilePageBackground,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: TextField(
                    controller: _controller,
                    autofocus: true,
                    expands: true,
                    maxLines: null,
                    textAlignVertical: TextAlignVertical.top,
                    textCapitalization: TextCapitalization.sentences,
                    style: fieldStyle,
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      isCollapsed: true,
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.fromLTRB(
                        19.w,
                        17.5.h,
                        19.w,
                        17.h,
                      ),
                      hintText:
                          'Let them know what you like about their profile',
                      hintMaxLines: 2,
                      hintStyle: fieldStyle.copyWith(color: kProfileHintGrey),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              SizedBox(
                height: 48.h,
                child: FilledButton(
                  onPressed: _canSubmit ? _submit : null,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    disabledBackgroundColor: Colors.white.withValues(
                      alpha: 0.25,
                    ),
                    foregroundColor: Colors.white,
                    disabledForegroundColor: Colors.white70,
                    shape: const StadiumBorder(),
                  ),
                  child: Text(
                    'Submit',
                    style: TextFontStyle.headline18w500textWhiteStyleSatoshi.lh(
                      24,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
