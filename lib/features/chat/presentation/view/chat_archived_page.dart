import 'package:find_a_nikah/app/di.dart';
import 'package:find_a_nikah/core/ui/ui.dart';
import 'package:find_a_nikah/features/chat/presentation/bloc/archived_chats_cubit.dart';
import 'package:find_a_nikah/features/chat/presentation/widgets/chat_header.dart';
import 'package:find_a_nikah/features/chat/presentation/widgets/conversation_tile.dart';
import 'package:find_a_nikah/gen/assets.gen.dart';
import 'package:find_a_nikah/router/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:go_router/go_router.dart';

/// Chats the member archived (Figma "chat_archived chats empty state");
/// full screen, over the bottom nav. Restore puts one back on the Chat tab.
class ChatArchivedPage extends StatelessWidget {
  const ChatArchivedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ArchivedChatsCubit>()..load(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              ChatHeader(
                title: 'Archived chats',
                onBack: () => context.pop(),
              ),
              const Expanded(child: _Body()),
            ],
          ),
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ArchivedChatsCubit, ArchivedChatsState>(
      listenWhen: (a, b) => b.failure != null && a.failure != b.failure,
      listener: (context, state) => showFailureToast(context, state.failure!),
      builder: (context, state) {
        switch (state.status) {
          case ArchivedChatsStatus.loading:
            return const AppLoadingView();
          case ArchivedChatsStatus.failure:
            return AppErrorView(
              title: 'Couldn’t load archived chats',
              retryLabel: 'Try again',
              onRetry: () => context.read<ArchivedChatsCubit>().load(),
            );
          case ArchivedChatsStatus.ready:
            if (state.chats.isEmpty) {
              return SingleChildScrollView(
                padding: EdgeInsets.only(top: 216.w, bottom: 24.w),
                child: ChatEmptyMessage(
                  illustration: Assets.images.chatWarningIllustration,
                  title: 'Archived chats',
                  message: "Chats you've archived will appear here.",
                ),
              );
            }
            return ListView.builder(
              itemCount: state.chats.length,
              itemBuilder: (context, i) {
                final chat = state.chats[i];
                return Row(
                  children: [
                    Expanded(
                      child: ConversationTile(
                        conversation: chat,
                        onTap: () => context
                            .push<void>(RoutePaths.chatRoom, extra: chat.peer)
                            .ignore(),
                      ),
                    ),
                    TextButton(
                      onPressed: () =>
                          context.read<ArchivedChatsCubit>().restore(chat),
                      child: const Text('Restore'),
                    ),
                    SizedBox(width: 8.w),
                  ],
                );
              },
            );
        }
      },
    );
  }
}
