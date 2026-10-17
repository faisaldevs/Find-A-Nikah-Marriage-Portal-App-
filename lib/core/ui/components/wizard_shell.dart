import 'package:find_a_nikah/core/ui/components/wizard_progress_bar.dart';
import 'package:find_a_nikah/core/ui/components/wizard_scaffold.dart'
    show WizardScaffold;
import 'package:find_a_nikah/core/ui/theme/figma_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:go_router/go_router.dart';

/// Where a wizard screen sits in the flow: its app-bar title, which of the
/// 4 progress-bar sections it belongs to, and its 1-based position inside
/// that section.
@immutable
class WizardProgress {
  const WizardProgress({
    required this.title,
    required this.section,
    required this.step,
    required this.sectionLength,
    this.sectionCount = 4,
  });

  final String title;

  /// 0-based index of the progress-bar segment this screen fills.
  final int section;

  /// 1-based position within [section].
  final int step;
  final int sectionLength;

  /// Total segments in the bar — one per section of the flow.
  final int sectionCount;

  /// Looks [path] up in [sections] (flow order, each entry `(path, title)`)
  /// and returns its title + position, or null if [path] isn't in the flow.
  static WizardProgress? forPath(WizardSections sections, String path) {
    for (var s = 0; s < sections.length; s++) {
      final section = sections[s];
      for (var i = 0; i < section.length; i++) {
        if (section[i].$1 == path) {
          return WizardProgress(
            title: section[i].$2,
            section: s,
            step: i + 1,
            sectionLength: section.length,
            sectionCount: sections.length,
          );
        }
      }
    }
    return null;
  }

  /// The path immediately before [path] in [sections]' flow order (crossing
  /// section boundaries), or null if [path] is the flow's first page or
  /// isn't in it. Used to step backward when a user lands mid-flow (e.g.
  /// resumed from a saved step) with nothing pushed to pop.
  static String? previousPathFor(WizardSections sections, String path) {
    final flat = [for (final section in sections) ...section];
    final index = flat.indexWhere((entry) => entry.$1 == path);
    if (index <= 0) return null;
    return flat[index - 1].$1;
  }
}

/// A wizard flow as progress-bar sections, in order. Each entry is
/// `(route path, app-bar title)`.
typedef WizardSections = List<List<(String, String)>>;

/// `ShellRoute` builder for a wizard flow: keeps [WizardShell]'s header +
/// progress bar on screen and swaps only [child] between steps.
///
/// Reads the *top* route from go_router (so `push`ed steps count, not just
/// the shell's first match) and maps it through [sections].
class RoutedWizardShell extends StatefulWidget {
  const RoutedWizardShell({
    required this.sections,
    required this.child,
    super.key,
    this.exitPath,
    this.hideBackFor = const {},
    this.bareHeaderFor = const {},
  });

  final WizardSections sections;
  final Widget child;

  /// Where back goes from this flow's first page (e.g. a resumed user who
  /// walks all the way back). Null disables back there.
  final String? exitPath;

  /// Pages with no back button at all — for a step that can't be undone
  /// once passed (e.g. phone verification locks in before Photos), so
  /// there's nothing sensible to go back to.
  final Set<String> hideBackFor;

  /// Routes whose Figma frame has only back + help — no title, rule or
  /// progress bar (e.g. phone verification code, audit #37).
  final Set<String> bareHeaderFor;

  @override
  State<RoutedWizardShell> createState() => _RoutedWizardShellState();
}

class _RoutedWizardShellState extends State<RoutedWizardShell> {
  /// Last step seen. Held on to when the top route leaves this flow (e.g.
  /// the next part pushed on the root navigator) so the shell keeps the
  /// right title while it animates out underneath.
  WizardProgress? _last;

  @override
  Widget build(BuildContext context) {
    final router = GoRouter.of(context);
    return ListenableBuilder(
      listenable: router.routerDelegate,
      builder: (context, _) {
        final location = router.state.matchedLocation;
        final progress =
            WizardProgress.forPath(widget.sections, location) ??
            _last ??
            WizardProgress.forPath(
              widget.sections,
              widget.sections.first.first.$1,
            )!;
        _last = progress;
        // Landing here via a redirect (e.g. resuming a saved step) pushes
        // nothing, so there's nothing to pop — step to the previous page
        // in flow order instead, or [exitPath] from the very first one.
        final previousPath =
            WizardProgress.previousPathFor(widget.sections, location) ??
            widget.exitPath;
        return WizardShell(
          progress: progress,
          showBack: !widget.hideBackFor.contains(location),
          bare: widget.bareHeaderFor.contains(location),
          onBack: () {
            if (context.canPop()) {
              context.pop();
            } else if (previousPath != null) {
              context.go(previousPath);
            }
          },
          child: widget.child,
        );
      },
    );
  }
}

/// Persistent wizard chrome — header + progress bar — that stays on screen
/// while only [child] (the routed page below it) transitions. Hosted by a
/// go_router `ShellRoute`; the feature that owns the routes decides the
/// current [progress]. The title cross-fades and the bar animates between
/// steps.
class WizardShell extends StatelessWidget {
  const WizardShell({
    required this.progress,
    required this.child,
    super.key,
    this.onHelp,
    this.onBack,
    this.showBack = true,
    this.bare = false,
  });

  final WizardProgress progress;
  final Widget child;
  final VoidCallback? onHelp;

  /// Overrides the header's default `context.pop()`.
  final VoidCallback? onBack;

  /// False removes the back arrow entirely (see [RoutedWizardShell.
  /// hideBackFor]), rather than just disabling it.
  final bool showBack;

  /// Back + help only (no title, rule or progress bar).
  final bool bare;

  @override
  Widget build(BuildContext context) {
    if (bare) {
      // Figma 883:6645: 24pt below the status bar, 40pt to the headline.
      return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (showBack)
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: onBack ?? () => context.pop(),
                        child: Icon(
                          Icons.arrow_back,
                          color: const Color(0xFF0A0A0A),
                          size: 20.r,
                        ),
                      )
                    else
                      const SizedBox.shrink(),
                    GestureDetector(
                      onTap: onHelp,
                      child: Icon(
                        Icons.help_outline,
                        size: 18.r,
                        color: const Color(0xFF0A0A0A),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40.h),
              Expanded(child: WizardShellScope(child: child)),
            ],
          ),
        ),
      );
    }
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            WizardHeader(
              title: progress.title,
              onHelp: onHelp,
              onBack: onBack,
              showBack: showBack,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: WizardProgressBar(
                step: progress.step,
                totalSteps: progress.sectionLength,
                activeSegment: progress.section,
                segmentCount: progress.sectionCount,
              ),
            ),
            // SizedBox(height: 16.h),
            // Figma: 24pt under the bar, then 20pt to the page headline.
            SizedBox(height: 44.h),
            // Pages inside the shell see this and render body-only
            // (see [WizardScaffold]).
            Expanded(child: WizardShellScope(child: child)),
          ],
        ),
      ),
    );
  }
}

/// Marks the subtree as living inside a [WizardShell], so [WizardScaffold]
/// skips drawing its own header/progress bar.
class WizardShellScope extends InheritedWidget {
  const WizardShellScope({required super.child, super.key});

  static bool isInShell(BuildContext context) =>
      context.getInheritedWidgetOfExactType<WizardShellScope>() != null;

  @override
  bool updateShouldNotify(WizardShellScope oldWidget) => false;
}

/// Back arrow + title + help icon + divider. Shared by [WizardShell] and the
/// standalone [WizardScaffold] so both look identical. The title
/// cross-fades when it changes.
class WizardHeader extends StatelessWidget {
  const WizardHeader({
    required this.title,
    super.key,
    this.onHelp,
    this.onBack,
    this.showBack = true,
  });

  final String title;
  final VoidCallback? onHelp;

  /// Defaults to `context.pop()` when null.
  final VoidCallback? onBack;

  /// False removes the back arrow entirely, instead of just disabling it.
  final bool showBack;

  @override
  Widget build(BuildContext context) {
    // return Column(
    // children: [
    // // SizedBox(height: 16.h),
    // Padding(
    // padding: EdgeInsets.fromLTRB(4.w, 10.h, 16.w, 4.h),
    // child: Row(
    // children: [
    // if (showBack)
    // IconButton(
    // onPressed: onBack ?? () => context.pop(),
    // icon: Icon(
    // Icons.arrow_back,
    // color: AppColors.textDark,
    // size: 22.r,
    // ),
    // )
    // else
    // SizedBox(width: 48.r, height: 48.r),
    // Expanded(
    // child: AnimatedSwitcher(
    // duration: const Duration(milliseconds: 200),
    // // Default layout centres the children; keep the title
    // // left-aligned like the design.
    // layoutBuilder: (current, previous) => Stack(
    // alignment: Alignment.centerLeft,
    // children: [...previous, ?current],
    // ),
    // child: Text(
    // title,
    // key: ValueKey(title),
    // style: TextFontStyle.headline16w600textDarkStyleSatoshi,
    // ),
    // ),
    // ),
    // GestureDetector(
    // onTap: onHelp,
    // child: Container(
    // width: 28.r,
    // height: 28.r,
    // decoration: BoxDecoration(
    // shape: BoxShape.circle,
    // border: Border.all(color: AppColors.textMuted),
    // ),
    // child: Icon(
    // Icons.help_outline,
    // size: 16.r,
    // color: AppColors.textDark,
    // ),
    // ),
    // ),
    // ],
    // ),
    // ),
    // SizedBox(height: 0.h),
    // const Divider(),
    // SizedBox(height: 16.h),
    // ],
    // );
    // Figma (e.g. 883:3951): 20pt padding, 20pt back arrow, 14pt gap,
    // Satoshi Medium 16 title, plain 18pt (?) — no circle — over a 1px
    // #D4D4D4 rule; the progress bar sits 24pt below it.
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(20.r),
          child: Row(
            children: [
              if (showBack)
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: onBack ?? () => context.pop(),
                  child: Padding(
                    padding: EdgeInsets.only(right: 14.w),
                    child: Icon(
                      Icons.arrow_back,
                      color: const Color(0xFF0A0A0A),
                      size: 20.r,
                    ),
                  ),
                ),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  layoutBuilder: (current, previous) => Stack(
                    alignment: Alignment.centerLeft,
                    children: [...previous, ?current],
                  ),
                  child: Text(
                    title,
                    key: ValueKey(title),
                    style: figmaText(16, 22.4, weight: FontWeight.w500),
                  ),
                ),
              ),
              GestureDetector(
                onTap: onHelp,
                child: Icon(
                  Icons.help_outline,
                  size: 18.r,
                  color: const Color(0xFF0A0A0A),
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1, thickness: 1, color: Color(0xFFD4D4D4)),
        SizedBox(height: 24.h),
      ],
    );
  }
}
