import 'package:find_a_nikah/app/di.dart';
import 'package:find_a_nikah/core/ui/ui.dart';
import 'package:find_a_nikah/features/messaging/presentation/bloc/blocked_users_cubit.dart';
import 'package:find_a_nikah/features/messaging/presentation/widgets/messaging_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:go_router/go_router.dart';

/// Settings → "Profiles I've blocked": everyone blocked, with Unblock.
class BlockedProfilesPage extends StatelessWidget {
  const BlockedProfilesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<BlockedUsersCubit>()..load(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(8.w, 8.w, 20.w, 8.w),
                child: Row(
                  children: [
                    IconButton(
                      tooltip: 'Back',
                      onPressed: () => context.pop(),
                      icon: const Icon(Icons.arrow_back_rounded),
                    ),
                    Text(
                      'Profiles I’ve blocked',
                      style: figmaText(20, 28, weight: FontWeight.w700),
                    ),
                  ],
                ),
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
    return BlocConsumer<BlockedUsersCubit, BlockedUsersState>(
      listenWhen: (a, b) =>
          (b.failure != null && a.failure != b.failure) ||
          (b.unblockedName != null && a.unblockedName != b.unblockedName),
      listener: (context, state) {
        if (state.failure != null) {
          showFailureToast(context, state.failure!);
        } else if (state.unblockedName != null) {
          CustomToast.showInfo(context, 'Unblocked ${state.unblockedName}');
        }
      },
      builder: (context, state) {
        switch (state.status) {
          case BlockedUsersStatus.loading:
            return const AppLoadingView();
          case BlockedUsersStatus.failure:
            return AppErrorView(
              title: 'Couldn’t load blocked profiles',
              retryLabel: 'Try again',
              onRetry: () => context.read<BlockedUsersCubit>().load(),
            );
          case BlockedUsersStatus.ready:
            if (state.users.isEmpty) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(32.w),
                  child: Text(
                    'You haven’t blocked anyone.',
                    textAlign: TextAlign.center,
                    style: figmaText(15, 22, color: kMsgGrey500),
                  ),
                ),
              );
            }
            return ListView.builder(
              itemCount: state.users.length,
              itemBuilder: (context, i) {
                final user = state.users[i];
                return ListTile(
                  leading: AppAvatar(user.photoUrl ?? '', size: 44),
                  title: Text(
                    user.name.isEmpty ? 'Member' : user.name,
                    style: figmaText(16, 22, weight: FontWeight.w700),
                  ),
                  trailing: TextButton(
                    onPressed: () =>
                        context.read<BlockedUsersCubit>().unblock(user),
                    child: const Text('Unblock'),
                  ),
                );
              },
            );
        }
      },
    );
  }
}
