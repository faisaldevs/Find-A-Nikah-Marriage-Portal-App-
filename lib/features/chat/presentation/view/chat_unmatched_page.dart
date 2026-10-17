import 'package:find_a_nikah/core/ui/ui.dart';
import 'package:find_a_nikah/features/chat/presentation/widgets/chat_header.dart';
import 'package:find_a_nikah/features/chat/presentation/widgets/chat_style.dart';
import 'package:find_a_nikah/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:go_router/go_router.dart';

/// Unmatched profiles (Figma "chat_unmatched empty state"), inside the Chat
/// tab so the bottom nav stays.
class ChatUnmatchedPage extends StatelessWidget {
  const ChatUnmatchedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            ChatHeader(title: 'Unmatched', onBack: () => context.pop()),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(20.w, 28.w, 20.w, 24.w),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.fromLTRB(14.w, 14.w, 16.w, 16.6.w),
                      decoration: BoxDecoration(
                        color: kChatGrey100,
                        borderRadius: BorderRadius.circular(16.w),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AssetIcon(
                            Assets.icons.chatInfo,
                            size: 24,
                            color: kChatGrey500,
                          ),
                          SizedBox(width: 9.5.w),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(top: 1.4.w),
                              child: Text(
                                'Expired matches will now show in your '
                                'Marriage feed so you’ll have a second '
                                'chance to chat.',
                                style: figmaText(14, 20, color: kChatGrey500),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 104.w),
                    ChatEmptyMessage(
                      horizontalPadding: 0,
                      illustrationShift: 2,
                      illustration: Assets.images.chatWarningIllustration,
                      title: 'Unmatched profiles',
                      message:
                          'People who you have unmatched with will appear '
                          'here.',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
