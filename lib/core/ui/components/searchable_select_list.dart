import 'package:find_a_nikah/core/ui/theme/text_font_style.dart';
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
  });

  final List<SelectListItem> items;
  final List<SelectListItem> suggested;
  final Set<String> selected;
  final ValueChanged<String> onToggle;
  final bool multiSelect;
  final int? maxSelections;
  final String hintText;

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
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 12.h),
            child: Row(
              children: [
                if (item.leading != null) ...[
                  item.leading!,
                  SizedBox(width: 12.w),
                ],
                Expanded(
                  child: Text(
                    item.label,
                    style: TextFontStyle.headline15w500textDarkStyleSatoshi,
                  ),
                ),
                if (widget.multiSelect)
                  _CheckCircle(selected: isSelected)
                else
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
        TextField(
          controller: _queryController,
          onChanged: (v) => setState(() => _query = v),
          style: TextFontStyle.headline15w400textDarkStyleSatoshi,
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: TextFontStyle.headline15w400textMutedStyleSatoshi,
            prefixIcon: Icon(
              Icons.search,
              color: AppColors.textMuted,
              size: 20.r,
            ),
            isDense: true,
            border: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.primaryColor),
            ),
          ),
        ),
        SizedBox(height: 4.h),
        Expanded(
          child: ListView(
            children: [
              if (filtered == null && widget.suggested.isNotEmpty) ...[
                const _SectionLabel('Suggested'),
                ...widget.suggested.map(tile),
                SizedBox(height: 4.h),
                const _SectionLabel('All'),
              ],
              ...(filtered ?? widget.items).map(tile),
              SizedBox(height: 12.h),
            ],
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
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Text(
        label,
        style: TextFontStyle.headline13w600textMutedStyleSatoshi,
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
  const _RadioDot({required this.selected});

  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22.r,
      height: 22.r,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: selected ? AppColors.primaryColor : Colors.grey.shade400,
          width: 2,
        ),
      ),
      child: selected
          ? Center(
              child: Container(
                width: 11.r,
                height: 11.r,
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
