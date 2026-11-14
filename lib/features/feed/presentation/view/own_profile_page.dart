import 'package:find_a_nikah/app/di.dart';
import 'package:find_a_nikah/core/core.dart';
import 'package:find_a_nikah/core/ui/ui.dart';
import 'package:find_a_nikah/features/feed/domain/domain.dart';
import 'package:find_a_nikah/features/feed/presentation/view/profile_page.dart';
import 'package:flutter/material.dart';

/// The signed-in member's own Feed profile (posts, comments, private
/// Likes). The Menu opens it without knowing the member's id, so look the
/// id up first, then show the ordinary [ProfilePage].
class OwnProfilePage extends StatefulWidget {
  const OwnProfilePage({super.key});

  @override
  State<OwnProfilePage> createState() => _OwnProfilePageState();
}

class _OwnProfilePageState extends State<OwnProfilePage> {
  late Future<Either<Failure, FeedAuthor>> _me = _load();

  Future<Either<Failure, FeedAuthor>> _load() =>
      getIt<FeedRepository>().fetchMe();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Either<Failure, FeedAuthor>>(
      future: _me,
      builder: (context, snapshot) {
        final result = snapshot.data;
        if (result == null) {
          return const Scaffold(body: AppLoadingView());
        }
        return result.fold(
          (f) => Scaffold(
            appBar: AppBar(backgroundColor: Colors.white),
            backgroundColor: Colors.white,
            body: AppErrorView(
              title: f.title,
              message: f.message,
              retryLabel: 'Try again',
              onRetry: () => setState(() => _me = _load()),
            ),
          ),
          (me) => ProfilePage(userId: me.userId, author: me),
        );
      },
    );
  }
}
