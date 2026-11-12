import 'package:find_a_nikah/core/ui/ui.dart';
import 'package:find_a_nikah/features/messaging/domain/domain.dart';
import 'package:find_a_nikah/features/messaging/presentation/widgets/image_viewer.dart';
import 'package:find_a_nikah/features/messaging/presentation/widgets/messaging_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:go_router/go_router.dart';

/// "View profile" from the chat room: photos, name, age and the card facts
/// the matches API returns. The peer (with its profile) travels as the
/// route's `extra`; there is no extra request, so a chat opened before a
/// match shows just the name and photo.
class PeerProfilePage extends StatelessWidget {
  const PeerProfilePage({required this.peer, super.key});

  final ChatPeer peer;

  @override
  Widget build(BuildContext context) {
    final profile = peer.profile;
    final photos = [
      if (profile != null && profile.images.isNotEmpty)
        ...profile.images
      else if (peer.photoUrl.isNotEmpty)
        peer.photoUrl,
    ];
    final facts = <(String, String)>[
      if (_join([profile?.city, profile?.country]) case final v?)
        ('Lives in', v),
      if (_join([profile?.profession]) case final v?) ('Profession', v),
      if (_join([profile?.education]) case final v?) ('Education', v),
      if (_join([profile?.maritalStatus]) case final v?) ('Marital status', v),
      if (_join([profile?.religion, profile?.sect]) case final v?)
        ('Religion', v),
      if (_join([profile?.faith]) case final v?) ('Practice', v),
    ];
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          Stack(
            children: [
              SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.5,
                width: double.infinity,
                child: photos.isEmpty
                    ? const ColoredBox(color: kMsgGrey200)
                    : _Photos(photos: photos),
              ),
              SafeArea(
                child: Padding(
                  padding: EdgeInsets.all(8.w),
                  child: IconButton.filled(
                    tooltip: 'Back',
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.white.withValues(alpha: 0.9),
                    ),
                    onPressed: () => context.pop(),
                    icon: const Icon(
                      Icons.arrow_back_rounded,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20.w, 20.w, 20.w, 32.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        [
                          peer.name,
                          if (profile?.age case final a?) '$a',
                        ].join(', '),
                        style: figmaText(24, 32, weight: FontWeight.w700),
                      ),
                    ),
                    if (profile?.isVerified ?? false) ...[
                      SizedBox(width: 8.w),
                      Icon(
                        Icons.verified_rounded,
                        size: 22.r,
                        color: AppColors.primaryColor,
                      ),
                    ],
                  ],
                ),
                SizedBox(height: 16.w),
                if (facts.isEmpty)
                  Text(
                    'No more details to show yet.',
                    style: figmaText(14, 20, color: kMsgGrey500),
                  )
                else
                  for (final (label, value) in facts) ...[
                    Text(label, style: figmaText(13, 18, color: kMsgGrey500)),
                    SizedBox(height: 2.w),
                    Text(
                      value,
                      style: figmaText(16, 22, weight: FontWeight.w600),
                    ),
                    SizedBox(height: 14.w),
                  ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Non-empty parts joined, tokens made readable (`never_married` →
  /// `Never married`); null when nothing is left.
  static String? _join(List<String?> parts) {
    final p = [
      for (final x in parts)
        if (x != null && x.trim().isNotEmpty) _pretty(x.trim()),
    ];
    return p.isEmpty ? null : p.join(', ');
  }

  static String _pretty(String raw) {
    final spaced = raw.replaceAll('_', ' ');
    return spaced[0].toUpperCase() + spaced.substring(1);
  }
}

/// Swipeable photos with page dots; tap one for the full-screen viewer.
class _Photos extends StatefulWidget {
  const _Photos({required this.photos});

  final List<String> photos;

  @override
  State<_Photos> createState() => _PhotosState();
}

class _PhotosState extends State<_Photos> {
  var _page = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        PageView.builder(
          itemCount: widget.photos.length,
          onPageChanged: (i) => setState(() => _page = i),
          itemBuilder: (_, i) => GestureDetector(
            onTap: () => showImageViewer(context, widget.photos[i]),
            child: AppPhoto(widget.photos[i]),
          ),
        ),
        if (widget.photos.length > 1)
          Positioned(
            bottom: 12.w,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var i = 0; i < widget.photos.length; i++)
                  Container(
                    width: 7.r,
                    height: 7.r,
                    margin: EdgeInsets.symmetric(horizontal: 3.w),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: i == _page
                          ? Colors.white
                          : Colors.white.withValues(alpha: 0.5),
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}
