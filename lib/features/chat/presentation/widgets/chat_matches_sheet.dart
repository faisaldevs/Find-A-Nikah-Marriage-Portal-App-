import 'package:find_a_nikah/core/ui/ui.dart';
import 'package:find_a_nikah/features/chat/presentation/widgets/chat_header.dart';
import 'package:find_a_nikah/features/chat/presentation/widgets/chat_style.dart';
import 'package:find_a_nikah/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

/// "Matches (0)" panel (Figma "chat_matches expanded"): rises from the
/// bottom nav over the tab content, 20pt corners and a grab handle. Empty
/// for now — no matches exist yet — so it shows the "go like profiles"
/// prompt.
class ChatMatchesSheet extends StatelessWidget {
  const ChatMatchesSheet({
    required this.onHide,
    required this.onGoToMarriage,
    super.key,
  });

  final VoidCallback onHide;
  final VoidCallback onGoToMarriage;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Swipe down on the sheet to hide it, like the handle suggests.
      onVerticalDragEnd: (d) {
        if ((d.primaryVelocity ?? 0) > 200) onHide();
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.w)),
        ),
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            children: [
              SizedBox(height: 8.w),
              Container(
                width: 66.w,
                height: 4.w,
                decoration: BoxDecoration(
                  color: kChatGrey300,
                  borderRadius: BorderRadius.circular(2.w),
                ),
              ),
              SizedBox(height: 9.5.w),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Row(
                  children: [
                    Text(
                      'Matches (0)',
                      style: figmaText(16, 22, weight: FontWeight.w700),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: onHide,
                      behavior: HitTestBehavior.opaque,
                      child: Row(
                        children: [
                          Text(
                            'Hide',
                            style: figmaText(13, 20, color: kChatGrey500),
                          ),
                          SizedBox(width: 2.w),
                          AssetIcon(
                            Assets.icons.chatChevronDown,
                            size: 16,
                            color: kChatGrey500,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 122.5.w),
              // Figma centres it 3pt left of the screen centre.
              Transform.translate(
                offset: Offset(-3.w, 0),
                child: Image.asset(
                  Assets.images.chatMatchesIllustration,
                  width: 136.5.w,
                  height: 134.w,
                ),
              ),
              SizedBox(height: 36.2.w),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 60.w),
                child: Text(
                  'No matches yet, like new profiles in the marriage tab',
                  textAlign: TextAlign.center,
                  style: figmaText(20, 30, weight: FontWeight.w700),
                ),
              ),
              SizedBox(height: 23.8.w),
              ChatPinkButton(
                label: 'Go to Marriage',
                height: 44,
                width: 190,
                onTap: onGoToMarriage,
              ),
              SizedBox(height: 32.w),
            ],
          ),
        ),
      ),
    );
  }
}
