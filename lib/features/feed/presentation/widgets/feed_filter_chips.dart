import 'package:find_a_nikah/core/ui/ui.dart';
import 'package:find_a_nikah/features/feed/domain/domain.dart';
import 'package:find_a_nikah/features/feed/presentation/widgets/feed_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

/// "For you" · "New" · one chip per topic, scrolling sideways (the last one
/// runs off the screen edge in Figma). Selected = solid pink, the rest
/// white with a grey outline drawn outside the padding — so outlined chips
/// are 30pt high and the solid one 28pt, centred on one row.
class FeedFilterChips extends StatelessWidget {
  const FeedFilterChips({
    required this.topics,
    required this.selected,
    required this.onSelected,
    super.key,
  });

  final List<FeedTopic> topics;
  final FeedFilter selected;
  final ValueChanged<FeedFilter> onSelected;

  @override
  Widget build(BuildContext context) {
    final filters = <FeedFilter>[
      const FeedFilter.forYou(),
      const FeedFilter.newest(),
      for (final t in topics) FeedFilter.topic(t),
    ];
    return SizedBox(
      height: 30.w,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: kFeedGutter),
        itemCount: filters.length,
        separatorBuilder: (_, _) => SizedBox(width: 12.w),
        itemBuilder: (context, i) {
          final filter = filters[i];
          return Center(
            child: _Chip(
              filter: filter,
              selected: filter == selected,
              onTap: () => onSelected(filter),
            ),
          );
        },
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.filter,
    required this.selected,
    required this.onTap,
  });

  final FeedFilter filter;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final (label, imageUrl) = switch (filter) {
      FeedForYou() => ('For you', null),
      FeedNewest() => ('New', null),
      FeedTopicFilter(:final topic) => (topic.name, topic.imageUrl),
    };
    return GestureDetector(
      onTap: onTap,
      child: Container(
        // Container adds the 1pt border outside this padding.
        padding: EdgeInsets.fromLTRB(
          (imageUrl != null ? 4 : 10).w,
          4.w,
          10.w,
          4.w,
        ),
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(4.w),
          border: selected ? null : Border.all(color: kFeedGrey300),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (imageUrl != null) ...[
              _TopicThumb(url: imageUrl),
              SizedBox(width: 7.w),
            ],
            Text(
              label,
              style: feedText(
                13,
                20,
                weight: FontWeight.w500,
                color: selected ? Colors.white : kFeedGrey950,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopicThumb extends StatelessWidget {
  const _TopicThumb({required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    final size = 20.w;
    // Figma crops the portrait photo slightly below centre.
    const alignment = Alignment(0, 0.62);
    return ClipRRect(
      borderRadius: BorderRadius.circular(1.w),
      child: url.startsWith('assets/')
          ? Image.asset(
              url,
              width: size,
              height: size,
              fit: BoxFit.cover,
              alignment: alignment,
            )
          : Image.network(
              url,
              width: size,
              height: size,
              fit: BoxFit.cover,
              alignment: alignment,
            ),
    );
  }
}
