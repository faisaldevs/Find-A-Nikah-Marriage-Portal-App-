import 'package:find_a_nikah/core/ui/ui.dart';
import 'package:find_a_nikah/features/menu/presentation/editing/profile_options.dart';
import 'package:find_a_nikah/features/menu/presentation/widgets/menu_style.dart';
import 'package:find_a_nikah/features/menu/presentation/widgets/menu_widgets.dart';
import 'package:find_a_nikah/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:go_router/go_router.dart';

// Building blocks of the Edit profile field pages (Muzz-style: one field
// per page, current value pre-selected, pinned "Update"). The radio and
// chip looks copy onboarding's `WizardRadioTile` / `WizardChipGroup`;
// features can't share presentation code.

/// Field page chrome: back button + title, optional helper line, the
/// editor, and a pinned "Update" button.
class EditorScaffold extends StatelessWidget {
  const EditorScaffold({
    required this.title,
    required this.body,
    required this.onUpdate,
    required this.saving,
    super.key,
    this.helper,
  });

  final String title;

  /// Short instruction under the title ("Choose up to 8 …").
  final String? helper;
  final Widget body;

  /// Null disables the button (nothing changed yet, or invalid).
  final VoidCallback? onUpdate;
  final bool saving;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _EditorTitleBar(title: title),
            if (helper != null)
              Padding(
                padding: EdgeInsets.fromLTRB(kMenuGutter, 8.w, kMenuGutter, 0),
                child: Text(
                  helper!,
                  style: menuText(14, 20, color: kMenuGrey500),
                ),
              ),
            Expanded(child: body),
            Padding(
              padding: EdgeInsets.fromLTRB(kMenuGutter, 8.w, kMenuGutter, 24.h),
              child: AppPrimaryButton(
                label: 'Update',
                loadingLabel: 'Saving...',
                isLoading: saving,
                onPressed: onUpdate,
                height: 48.h,
                borderRadius: 8.r,
                labelStyle: figmaText(
                  18,
                  23.4,
                  weight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 62pt bar like Settings': round back button left, title centred.
class _EditorTitleBar extends StatelessWidget {
  const _EditorTitleBar({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 62.w,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            left: kMenuGutter,
            child: MenuCircleButton(
              icon: Assets.icons.menuBack,
              iconSize: 18,
              semanticLabel: 'Back',
              onTap: () => context.pop(),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 70.w),
            child: Text(
              title,
              overflow: TextOverflow.ellipsis,
              style: menuText(20, 28, weight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}

/// Single-choice list (marital status, education, Yes/No questions …).
class EditorRadioList extends StatelessWidget {
  const EditorRadioList({
    required this.options,
    required this.value,
    required this.onChanged,
    super.key,
    this.controller,
  });

  final List<EditOption> options;
  final String? value;
  final ValueChanged<String> onChanged;
  final ScrollController? controller;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      controller: controller,
      padding: EdgeInsets.fromLTRB(kMenuGutter, 20.w, kMenuGutter, 20.w),
      itemCount: options.length,
      separatorBuilder: (_, _) => SizedBox(height: 14.h),
      itemBuilder: (_, i) {
        final o = options[i];
        return EditorRadioTile(
          title: o.title,
          subtitle: o.subtitle,
          selected: value == o.value,
          onTap: () => onChanged(o.value),
        );
      },
    );
  }
}

/// Onboarding's radio row: 24pt circle, Bold 16 title (pink when
/// selected), optional Regular 14 description.
class EditorRadioTile extends StatelessWidget {
  const EditorRadioTile({
    required this.title,
    required this.selected,
    required this.onTap,
    super.key,
    this.subtitle,
  });

  final String title;
  final String? subtitle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      selected: selected,
      inMutuallyExclusiveGroup: true,
      button: true,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          child: Row(
            crossAxisAlignment: subtitle != null
                ? CrossAxisAlignment.start
                : CrossAxisAlignment.center,
            children: [
              _RadioCircle(selected: selected),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: figmaText(
                        16,
                        20,
                        weight: FontWeight.w700,
                        color: selected
                            ? AppColors.primaryColor
                            : kMenuRowTitle,
                      ),
                    ),
                    if (subtitle != null) ...[
                      SizedBox(height: 4.h),
                      Text(
                        subtitle!,
                        style: figmaText(
                          14,
                          16,
                          color: const Color(0xFF383C42),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RadioCircle extends StatelessWidget {
  const _RadioCircle({required this.selected});

  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24.r,
      height: 24.r,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: selected ? AppColors.primaryColor : const Color(0xFF131416),
          width: 1.5,
        ),
      ),
      alignment: Alignment.center,
      child: selected
          ? Container(
              width: 12.r,
              height: 12.r,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryColor,
              ),
            )
          : null,
    );
  }
}

/// Wrap of pill chips: navy when selected, faded when [disabled].
class EditorChips extends StatelessWidget {
  const EditorChips({
    required this.options,
    required this.selected,
    required this.onTap,
    super.key,
    this.disabled = const {},
  });

  final List<EditOption> options;
  final Set<String> selected;
  final ValueChanged<String> onTap;

  /// Values that can't be picked right now (limit reached, or a rule).
  final Set<String> disabled;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.w,
      runSpacing: 10.h,
      children: [
        for (final o in options)
          _Chip(
            label: o.title,
            selected: selected.contains(o.value),
            disabled: !selected.contains(o.value) && disabled.contains(o.value),
            onTap: () => onTap(o.value),
          ),
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.selected,
    required this.disabled,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final bool disabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      selected: selected,
      button: true,
      enabled: !disabled,
      child: Opacity(
        opacity: disabled ? 0.4 : 1,
        child: InkWell(
          onTap: disabled ? null : onTap,
          borderRadius: BorderRadius.circular(24.r),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: selected ? AppColors.secondaryColor : Colors.white,
              borderRadius: BorderRadius.circular(24.r),
              border: selected ? null : Border.all(color: Colors.grey.shade300),
            ),
            child: Text(
              label,
              style: selected
                  ? TextFontStyle.headline14w500textWhiteStyleSatoshi
                  : TextFontStyle.headline14w500textDarkStyleSatoshi,
            ),
          ),
        ),
      ),
    );
  }
}

/// Bold label above a group of chips ("Arts & Culture", "I'd like to …").
class EditorGroupLabel extends StatelessWidget {
  const EditorGroupLabel(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.w),
      child: Text(
        text,
        style: figmaText(16, 20, weight: FontWeight.w700, color: kMenuRowTitle),
      ),
    );
  }
}
