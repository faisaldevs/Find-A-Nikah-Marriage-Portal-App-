import 'package:find_a_nikah/features/chat/presentation/widgets/chat_header.dart';
import 'package:find_a_nikah/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:go_router/go_router.dart';

/// Chats the member has left (Figma "chat_archived chats empty state");
/// full screen, over the bottom nav.
class ChatArchivedPage extends StatelessWidget {
  const ChatArchivedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            ChatHeader(title: 'Archived chats', onBack: () => context.pop()),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(top: 216.w, bottom: 24.w),
                child: ChatEmptyMessage(
                  illustration: Assets.images.chatWarningIllustration,
                  title: 'Archived chats',
                  message: "Chats you've left will appear here.",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
