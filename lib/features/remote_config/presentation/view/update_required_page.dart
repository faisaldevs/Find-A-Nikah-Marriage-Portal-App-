import 'package:find_a_nikah/core/ui/ui.dart';
import 'package:flutter/material.dart';

/// Shown in place of every route while this build is below the remote
/// minimum supported version.
class UpdateRequiredPage extends StatelessWidget {
  const UpdateRequiredPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: AppMessageView(
          icon: Icons.system_update_rounded,
          title: 'Update required',
          message:
              'This version of Find A Nikah is no longer supported. '
              'Please update from the App Store or Google Play.',
        ),
      ),
    );
  }
}
