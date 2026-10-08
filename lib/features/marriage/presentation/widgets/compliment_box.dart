import 'package:find_a_nikah/core/ui/ui.dart';
import 'package:find_a_nikah/features/marriage/presentation/widgets/profile_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

/// White "Compliment" band: a quick first message to the profile. Submit
/// stays faded until something is typed.
class ComplimentBox extends StatefulWidget {
  const ComplimentBox({required this.name, required this.onSubmit, super.key});

  final String name;

  /// Receives the trimmed message; the box clears afterwards.
  final ValueChanged<String> onSubmit;

  @override
  State<ComplimentBox> createState() => _ComplimentBoxState();
}

class _ComplimentBoxState extends State<ComplimentBox> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    widget.onSubmit(text);
    _controller.clear();
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final fieldStyle = TextFontStyle.headline14w400textDarkStyleSatoshi
        .copyWith(color: kProfileInk)
        .lh(20);
    return ColoredBox(
      color: Colors.white,
      child: Padding(
        // Mockup: field and button end 21 from the right, not 19.
        padding: EdgeInsets.fromLTRB(kProfileGutter, 19.5.h, 21.w, 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Compliment',
              style: TextFontStyle.headline14w400textMutedStyleSatoshi
                  .copyWith(color: kProfileLabelGrey)
                  .lh(20),
            ),
            SizedBox(height: 4.5.h),
            Text(
              'Don’t wait , chat with ${widget.name} now.',
              style: TextFontStyle.headline16w700textDarkStyleSatoshi
                  .copyWith(color: kProfileInk)
                  .lh(22),
            ),
            SizedBox(height: 10.25.h),
            Container(
              height: 150.h,
              decoration: BoxDecoration(
                color: kProfilePageBackground,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: kProfileBorder),
              ),
              child: TextField(
                controller: _controller,
                expands: true,
                maxLines: null,
                textAlignVertical: TextAlignVertical.top,
                textCapitalization: TextCapitalization.sentences,
                style: fieldStyle,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  isCollapsed: true,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.fromLTRB(19.w, 17.5.h, 19.w, 17.h),
                  // Line break as in the mockup.
                  hintText:
                      'Let them know what you like about their\n'
                      'profile or about her',
                  hintMaxLines: 2,
                  hintStyle: fieldStyle.copyWith(color: kProfileHintGrey),
                ),
              ),
            ),
            SizedBox(height: 20.h),
            SizedBox(
              height: 48.h,
              child: FilledButton(
                onPressed: _controller.text.trim().isEmpty ? null : _submit,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  disabledBackgroundColor: AppColors.primaryColor.withValues(
                    alpha: 0.3,
                  ),
                  foregroundColor: Colors.white,
                  disabledForegroundColor: Colors.white,
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
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
    );
  }
}
