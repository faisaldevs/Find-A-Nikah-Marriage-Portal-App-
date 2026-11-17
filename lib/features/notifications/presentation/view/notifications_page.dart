import 'package:find_a_nikah/app/di.dart';
import 'package:find_a_nikah/core/core.dart';
import 'package:find_a_nikah/core/ui/ui.dart';
import 'package:find_a_nikah/features/notifications/domain/app_notification.dart';
import 'package:find_a_nikah/features/notifications/presentation/bloc/notifications_cubit.dart';
import 'package:find_a_nikah/router/push_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:go_router/go_router.dart';

/// The bell: matches, likes, compliments, Feed activity and review results.
/// Full screen, over the bottom nav. Tapping a row marks it read and opens
/// what it is about (same routing as a tapped push).
class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<NotificationsCubit>()..load(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              const _Header(),
              const Expanded(child: _Body()),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final hasUnread = context.select<NotificationsCubit, bool>(
      (c) => c.state.hasUnread,
    );
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 5.h, 20.w, 8.w),
      child: SizedBox(
        height: 38.w,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Text(
              'Notifications',
              style: figmaText(20, 28, weight: FontWeight.w700),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: CircleIconButton(
                icon: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 16.r,
                  color: AppColors.textDark,
                ),
                tooltip: 'Back',
                onTap: () => context.pop(),
              ),
            ),
            if (hasUnread)
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () =>
                      context.read<NotificationsCubit>().markAllRead(),
                  child: const Text('Read all'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NotificationsCubit, NotificationsState>(
      listenWhen: (a, b) =>
          b.failure != null &&
          a.failure != b.failure &&
          b.status == NotificationsStatus.ready,
      listener: (context, state) => showFailureToast(context, state.failure!),
      builder: (context, state) {
        switch (state.status) {
          case NotificationsStatus.loading:
            return const AppLoadingView();
          case NotificationsStatus.failure:
            return AppErrorView(
              title: 'Couldn’t load notifications',
              retryLabel: 'Try again',
              onRetry: () => context.read<NotificationsCubit>().load(),
            );
          case NotificationsStatus.ready:
            if (state.items.isEmpty) {
              return Center(
                child: Text(
                  'No notifications yet',
                  style: TextFontStyle.headline14w400textMutedStyleSatoshi,
                ),
              );
            }
            return RefreshIndicator(
              onRefresh: () => context.read<NotificationsCubit>().load(),
              child: NotificationListener<ScrollNotification>(
                onNotification: (n) {
                  if (n.metrics.extentAfter < 300) {
                    context.read<NotificationsCubit>().loadMore();
                  }
                  return false;
                },
                child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: state.items.length,
                  itemBuilder: (context, i) => _Row(state.items[i]),
                ),
              ),
            );
        }
      },
    );
  }
}

class _Row extends StatelessWidget {
  const _Row(this.n);

  final AppNotification n;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<NotificationsCubit>();
    return Dismissible(
      key: ValueKey(n.id),
      direction: DismissDirection.endToStart,
      background: ColoredBox(
        color: AppColors.errorColor,
        child: Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: EdgeInsets.only(right: 20.w),
            child: const Icon(Icons.delete_outline, color: Colors.white),
          ),
        ),
      ),
      onDismissed: (_) => cubit.remove(n),
      child: InkWell(
        onTap: () {
          cubit.markRead(n);
          openPush(
            GoRouter.of(context),
            PushPayload(
              type: n.type,
              userId: n.userId,
              postId: n.postId,
              conversationId: n.conversationId,
              senderId: n.userId,
              senderName: n.actorName,
              senderPhoto: n.actorPhotoUrl,
            ),
          );
        },
        child: Container(
          color: n.isRead
              ? null
              : AppColors.primaryColor.withValues(alpha: .06),
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppAvatar(n.actorPhotoUrl ?? '', size: 44),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      n.title,
                      style: figmaText(
                        15,
                        20,
                        weight: n.isRead ? FontWeight.w500 : FontWeight.w700,
                      ),
                    ),
                    if (n.body.isNotEmpty)
                      Text(
                        n.body,
                        style:
                            TextFontStyle.headline14w400textMutedStyleSatoshi,
                      ),
                    if (n.createdAt != null)
                      Padding(
                        padding: EdgeInsets.only(top: 4.w),
                        child: Text(
                          _ago(n.createdAt!),
                          style:
                              TextFontStyle.headline12w400textMutedStyleSatoshi,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static String _ago(DateTime t) {
    final d = DateTime.now().difference(t);
    if (d.inMinutes < 1) return 'Just now';
    if (d.inHours < 1) return '${d.inMinutes}m ago';
    if (d.inDays < 1) return '${d.inHours}h ago';
    if (d.inDays < 7) return '${d.inDays}d ago';
    return '${t.day}/${t.month}/${t.year}';
  }
}
