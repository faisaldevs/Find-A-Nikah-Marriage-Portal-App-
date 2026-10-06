import 'package:flutter/material.dart';

import '../../../../../core/ui/components/wizard_shell.dart';
import '../../../onboarding_routes.dart';

/// `ShellRoute` builder for the Profile part of the wizard (Account type →
/// Bio): persistent header + 3-segment progress bar; only [child] changes.
///
/// The router-listening logic moved into the generic [RoutedWizardShell]
/// (core) so the Verification part can reuse it.
class OnboardingWizardShell extends StatelessWidget {
  const OnboardingWizardShell({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => RoutedWizardShell(
    sections: OnboardingRoutes.wizardSections,
    child: child,
  );
}

// Previous implementation — same logic, now generic in RoutedWizardShell.
// class _OnboardingWizardShellState extends State<OnboardingWizardShell> {
//   WizardProgress? _last;
//
//   @override
//   Widget build(BuildContext context) {
//     final router = GoRouter.of(context);
//     return ListenableBuilder(
//       listenable: router.routerDelegate,
//       builder: (context, _) {
//         final progress =
//             OnboardingRoutes.wizardProgressFor(router.state.matchedLocation) ??
//             _last ??
//             OnboardingRoutes.wizardProgressFor(OnboardingRoutes.accountType)!;
//         _last = progress;
//         return WizardShell(progress: progress, child: widget.child);
//       },
//     );
//   }
// }
