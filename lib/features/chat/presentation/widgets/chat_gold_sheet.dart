import 'package:find_a_nikah/core/ui/ui.dart';
import 'package:find_a_nikah/features/chat/presentation/widgets/chat_header.dart';
import 'package:find_a_nikah/features/chat/presentation/widgets/chat_style.dart';
import 'package:find_a_nikah/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

/// One Gold subscription option on the pricing sheet.
class ChatGoldPlan {
  const ChatGoldPlan({
    required this.title,
    required this.detail,
    required this.price,
    this.bestValue = false,
  });

  final String title;
  final String detail;
  final String price;
  final bool bestValue;
}

// Copy and prices from the Figma "chat_pricing plan" frame. Placeholder
// until store products exist.
const _plans = [
  ChatGoldPlan(title: '1 month', detail: 'Billed monthly', price: r'$31.99'),
  ChatGoldPlan(
    title: '3 months',
    detail: r'$24.66/month · Save 23%',
    price: r'$73.99',
  ),
  ChatGoldPlan(
    title: '1 year',
    detail: r'$20.00/month · Save 37%',
    price: r'$239.99',
    bestValue: true,
  ),
];

/// "More room for meaningful conversations" (Figma "chat_pricing plan"),
/// over everything including the bottom nav. Resolves to the picked plan
/// on Continue, or null when closed.
Future<ChatGoldPlan?> showChatGoldSheet(BuildContext context) {
  return showModalBottomSheet<ChatGoldPlan>(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    barrierColor: kChatScrim,
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20.w)),
    ),
    builder: (_) => const _GoldSheet(),
  );
}

class _GoldSheet extends StatefulWidget {
  const _GoldSheet();

  @override
  State<_GoldSheet> createState() => _GoldSheetState();
}

class _GoldSheetState extends State<_GoldSheet> {
  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    final plan = _plans[_selected];
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        20.w,
        24.w,
        20.w,
        18.w + MediaQuery.viewPaddingOf(context).bottom,
      ),
      child: Column(
        children: [
          SizedBox(
            height: 121.w,
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      width: 32.w,
                      height: 32.w,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: kChatGrey200),
                      ),
                      child: AssetIcon(
                        Assets.icons.chatClose,
                        size: 16,
                        color: kChatCloseGrey,
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Image.asset(
                    Assets.images.chatGoldIllustration,
                    width: 122.w,
                    height: 121.w,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 12.75.w),
          Text(
            'More room for meaningful conversations',
            textAlign: TextAlign.center,
            style: figmaText(26, 32, weight: FontWeight.w700),
          ),
          SizedBox(height: 12.85.w),
          Text(
            'Unlock up to 10 active chats with Gold.',
            textAlign: TextAlign.center,
            style: figmaText(16, 22, color: kChatGrey500),
          ),
          SizedBox(height: 42.7.w),
          GestureDetector(
            onTap: () => CustomToast.showInfo(
              context,
              'Gold benefits — coming soon',
            ),
            child: Text(
              'What else do I get with Gold?',
              style: figmaText(
                14,
                20,
                weight: FontWeight.w700,
                color: AppColors.primaryColor,
              ),
            ),
          ),
          SizedBox(height: 42.7.w),
          for (final (i, p) in _plans.indexed) ...[
            if (i > 0) SizedBox(height: 8.w),
            _PlanTile(
              plan: p,
              selected: i == _selected,
              onTap: () => setState(() => _selected = i),
            ),
          ],
          SizedBox(height: 40.w),
          ChatPinkButton(
            label: 'Continue · ${plan.price}',
            height: 48,
            onTap: () => Navigator.of(context).pop(plan),
          ),
          SizedBox(height: 18.w),
          Text(
            'Your subscription renews automatically unless cancelled',
            textAlign: TextAlign.center,
            style: figmaText(12, 16, color: kChatGrey500),
          ),
        ],
      ),
    );
  }
}

class _PlanTile extends StatelessWidget {
  const _PlanTile({
    required this.plan,
    required this.selected,
    required this.onTap,
  });

  final ChatGoldPlan plan;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // Border sits outside the padding (Container adds it), so the content
    // insets below are the Figma ones minus the stroke.
    final stroke = selected ? 1.5 : 1.0;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 56.w,
        padding: EdgeInsets.only(left: (16 - stroke).w, right: (14 - stroke).w),
        decoration: BoxDecoration(
          color: selected ? kChatPinkTint : Colors.white,
          borderRadius: BorderRadius.circular(12.w),
          border: Border.all(
            color: selected ? AppColors.primaryColor : kChatGrey200,
            width: stroke.w,
          ),
        ),
        child: Row(
          children: [
            _Radio(selected: selected),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        plan.title,
                        style: figmaText(16, 22, weight: FontWeight.w700),
                      ),
                      if (plan.bestValue) ...[
                        SizedBox(width: 8.w),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 4.75.w,
                            vertical: 3.3.w,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor,
                            borderRadius: BorderRadius.circular(5.w),
                          ),
                          child: Text(
                            'Best value',
                            style: figmaText(
                              10,
                              14,
                              weight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  SizedBox(height: 2.5.w),
                  Text(
                    plan.detail,
                    style: figmaText(12, 16, color: kChatGrey500),
                  ),
                ],
              ),
            ),
            Text(plan.price, style: figmaText(16, 22, weight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }
}

class _Radio extends StatelessWidget {
  const _Radio({required this.selected});

  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20.w,
      height: 20.w,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: selected ? AppColors.primaryColor : const Color(0xFF0A0A0A),
          width: 2.w,
        ),
      ),
      child: selected
          ? Container(
              width: 10.w,
              height: 10.w,
              decoration: const BoxDecoration(
                color: AppColors.primaryColor,
                shape: BoxShape.circle,
              ),
            )
          : null,
    );
  }
}
