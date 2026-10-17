import 'package:find_a_nikah/core/ui/theme/figma_text.dart';
import 'package:find_a_nikah/gen/colors.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

class SelectListItem {
  const SelectListItem({
    required this.value,
    required this.label,
    this.leading,
  });

  final String value;
  final String label;
  final Widget? leading;
}

/// Search field + optional "Suggested" shortlist + alphabetical "All" list,
/// each row ending in either a checkmark circle (multi-select, e.g.
/// nationality) or a plain radio dot (single-select, e.g. grew-up country).
/// Used by the nationality/country/ethnicity/profession screens.
class SearchableSelectList extends StatefulWidget {
  const SearchableSelectList({
    required this.items,
    required this.selected,
    required this.onToggle,
    super.key,
    this.suggested = const [],
    this.multiSelect = false,
    this.maxSelections,
    this.hintText = 'Search',
    this.radioFirst = false,
  });

  final List<SelectListItem> items;
  final List<SelectListItem> suggested;
  final Set<String> selected;
  final ValueChanged<String> onToggle;
  final bool multiSelect;
  final int? maxSelections;
  final String hintText;

  /// Single-select only: radio before the label (Figma's Profession list,
  /// like the other wizard radio pages) instead of trailing it.
  final bool radioFirst;

  @override
  State<SearchableSelectList> createState() => _SearchableSelectListState();
}

class _SearchableSelectListState extends State<SearchableSelectList> {
  final _queryController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _queryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _query.isEmpty
        ? null
        : widget.items
              .where(
                (i) => i.label.toLowerCase().contains(_query.toLowerCase()),
              )
              .toList();
    final atMax =
        widget.maxSelections != null &&
        widget.selected.length >= widget.maxSelections!;

    Widget tile(SelectListItem item) {
      final isSelected = widget.selected.contains(item.value);
      final isDisabled = widget.multiSelect && atMax && !isSelected;
      return Opacity(
        opacity: isDisabled ? 0.4 : 1,
        child: InkWell(
          onTap: isDisabled ? null : () => widget.onToggle(item.value),
          // Figma 358:2139: 8pt padding + 14pt between rows, flag → 16pt →
          // Bold 16 #131416 name.
          child: Padding(
            // padding: EdgeInsets.symmetric(vertical: 12.h),
            padding: EdgeInsets.symmetric(vertical: 15.h),
            child: Row(
              children: [
                if (widget.radioFirst && !widget.multiSelect) ...[
                  _RadioDot(selected: isSelected, figma: true),
                  SizedBox(width: 16.w),
                ],
                if (item.leading != null) ...[
                  item.leading!,
                  // SizedBox(width: 12.w),
                  SizedBox(width: 16.w),
                ],
                Expanded(
                  child: Text(
                    item.label,
                    // style: TextFontStyle.headline15w500textDarkStyleSatoshi,
                    style: figmaText(
                      16,
                      20,
                      weight: FontWeight.w700,
                      color: const Color(0xFF131416),
                    ),
                  ),
                ),
                if (widget.multiSelect)
                  _CheckCircle(selected: isSelected)
                else if (!widget.radioFirst)
                  _RadioDot(selected: isSelected),
              ],
            ),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Figma 361:2450: 18pt #A3A3A3 search icon inset 10pt, 10pt gap,
        // Regular 16 #A3A3A3 hint, 10pt above a #D4D4D4 rule; list 20pt below.
        TextField(
          controller: _queryController,
          onChanged: (v) => setState(() => _query = v),
          // style: TextFontStyle.headline15w400textDarkStyleSatoshi,
          style: figmaText(16, 22.4),
          decoration: InputDecoration(
            hintText: widget.hintText,
            // hintStyle: TextFontStyle.headline15w400textMutedStyleSatoshi,
            hintStyle: figmaText(16, 22.4, color: const Color(0xFFA3A3A3)),
            prefixIcon: Padding(
              // Bottom inset matches the text's so the icon centres on it.
              padding: EdgeInsets.only(left: 10.w, right: 10.w, bottom: 10.h),
              child: Icon(
                Icons.search,
                color: const Color(0xFFA3A3A3),
                size: 18.r,
              ),
            ),
            prefixIconConstraints: const BoxConstraints(),
            isDense: true,
            contentPadding: EdgeInsets.only(bottom: 10.h),
            border: const UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFD4D4D4)),
            ),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFD4D4D4)),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFD4D4D4)),
            ),
          ),
        ),
        // SizedBox(height: 4.h),
        SizedBox(height: 13.h),
        Expanded(
          // Figma fades the list out behind the CTA.
          child: ShaderMask(
            blendMode: BlendMode.dstIn,
            shaderCallback: (rect) => LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: const [Colors.black, Colors.black, Colors.transparent],
              stops: [0, 1 - 56 / rect.height.clamp(56, double.infinity), 1],
            ).createShader(rect),
            child: ListView(
              children: [
                if (filtered == null && widget.suggested.isNotEmpty) ...[
                  const _SectionLabel('Suggested'),
                  ...widget.suggested.map(tile),
                  SizedBox(height: 4.h),
                  const _SectionLabel('All'),
                ],
                ...(filtered ?? widget.items).map(tile),
                // SizedBox(height: 12.h),
                SizedBox(height: 40.h),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    // Figma 358:2217: Bold 15 #A3A3A3, 10pt vertical padding.
    return Padding(
      // padding: EdgeInsets.symmetric(vertical: 8.h),
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Text(
        label,
        // style: TextFontStyle.headline13w600textMutedStyleSatoshi,
        style: figmaText(
          15,
          20,
          weight: FontWeight.w700,
          color: const Color(0xFFA3A3A3),
        ),
      ),
    );
  }
}

class _CheckCircle extends StatelessWidget {
  const _CheckCircle({required this.selected});

  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24.r,
      height: 24.r,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: selected ? AppColors.primaryColor : Colors.white,
        border: selected ? null : Border.all(color: Colors.grey.shade400),
      ),
      child: selected
          ? Icon(Icons.check, size: 16.r, color: Colors.white)
          : null,
    );
  }
}

class _RadioDot extends StatelessWidget {
  const _RadioDot({required this.selected, this.figma = false});

  final bool selected;

  /// The wizard radio: 24pt, 1.5pt #131416 ring (see WizardRadioTile).
  final bool figma;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: (figma ? 24 : 22).r,
      height: (figma ? 24 : 22).r,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: selected
              ? AppColors.primaryColor
              : figma
              ? const Color(0xFF131416)
              : Colors.grey.shade400,
          width: figma ? 1.5 : 2,
        ),
      ),
      child: selected
          ? Center(
              child: Container(
                width: (figma ? 12 : 11).r,
                height: (figma ? 12 : 11).r,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primaryColor,
                ),
              ),
            )
          : null,
    );
  }
}
