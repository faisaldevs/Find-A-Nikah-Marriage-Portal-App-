import 'dart:io';
import 'package:find_a_nikah/core/constants/text_font_style.dart';

import 'package:find_a_nikah/gen/colors.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../core/router/app_navigator.dart';
import '../../../state/onboarding_controller.dart';
// import '../widgets/wizard_scaffold.dart'; // moved to core/ui/components (shared with features/auth)
import '../../../../../core/ui/components/wizard_scaffold.dart';

// const _totalSteps = 17; // step/progress now from OnboardingRoutes.wizardSections
const _minPhotos = 3;
const _slotCount = 5;

class AddPhotosScreen extends ConsumerStatefulWidget {
  const AddPhotosScreen({super.key});

  @override
  ConsumerState<AddPhotosScreen> createState() => _AddPhotosScreenState();
}

class _AddPhotosScreenState extends ConsumerState<AddPhotosScreen> {
  late List<String> _photos;

  @override
  void initState() {
    super.initState();
    _photos = List.of(ref.read(onboardingControllerProvider).photoPaths);
  }

  /// Opens the gallery in multi-select mode, capped at the number of empty
  /// slots, and fills them all at once.
  Future<void> _pickPhotos() async {
    final remaining = _slotCount - _photos.length;
    if (remaining <= 0) return;
    final picker = ImagePicker();
    final List<XFile> picked;
    if (remaining == 1) {
      // pickMultiImage asserts limit >= 2, so a single free slot uses the
      // single picker.
      final one = await picker.pickImage(source: ImageSource.gallery);
      picked = one == null ? const [] : [one];
    } else {
      picked = await picker.pickMultiImage(limit: remaining);
    }
    if (picked.isEmpty || !mounted) return;
    setState(
      // take(): older Android gallery apps can ignore `limit`.
      () => _photos.addAll(picked.take(remaining).map((f) => f.path)),
    );
  }

  // Previously one photo per tap.
  // Future<void> _pickPhoto() async {
  //   final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
  //   if (picked == null) return;
  //   setState(() => _photos.add(picked.path));
  // }

  void _removePhoto(int index) => setState(() => _photos.removeAt(index));

  void _showGuidelines() {
    showModalBottomSheet(
      context: context,
      // Cover the whole screen, not just the body under the persistent
      // wizard header (the shell has its own nested navigator).
      useRootNavigator: true,
      builder: (context) => Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Photo guidelines',
              style: TextFontStyle.headline18w700StyleSatoshi,
            ),
            SizedBox(height: 12.h),
            Text(
              '• Show your face clearly in your first photo\n'
              '• No group photos as your main picture\n'
              '• Recent photos only\n'
              '• No offensive or explicit content',
              style: TextFontStyle.headline14w400textMutedStyleSatoshi.copyWith(
                height: 1.5,
              ),
            ),
            SizedBox(height: 12.h),
          ],
        ),
      ),
    );
  }

  void _next() {
    ref
        .read(onboardingControllerProvider.notifier)
        .patch((d) => d.copyWith(photoPaths: _photos));
    // Photos → face verification (features/auth), carrying the main photo
    // so the user can confirm it's them.
    ref
        .read(appNavigatorProvider)
        .toScanYourFace(profilePhotoPath: _photos.first);
    // ref.read(appNavigatorProvider).toPhoneNumber();  // phone now comes before photos
  }

  @override
  Widget build(BuildContext context) {
    final canContinue = _photos.length >= _minPhotos;
    return WizardScaffold(
      // title: 'Photos',  // now from OnboardingRoutes.wizardSections
      // step: _totalSteps,
      // totalSteps: _totalSteps,
      continueLabel: _photos.isEmpty ? 'Add photos' : 'Continue',
      onContinue: canContinue ? _next : null,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const WizardHeadline(
              text: 'Add your profile photos',
              subtitle:
                  'You need to upload at least $_minPhotos photos to '
                  'continue your profile. You can change them later.',
              padding: EdgeInsets.zero,
            ),
            SizedBox(height: 20.h),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _slotCount + 1,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 12.w,
                mainAxisSpacing: 12.h,
                childAspectRatio: 0.78,
              ),
              itemBuilder: (context, index) {
                if (index == _slotCount) {
                  return _GuidelinesTile(onTap: _showGuidelines);
                }
                final path = index < _photos.length ? _photos[index] : null;
                return _PhotoSlot(
                  path: path,
                  onTap: path == null ? _pickPhotos : null,
                  // onTap: path == null ? _pickPhoto : null,
                  onRemove: path == null ? null : () => _removePhoto(index),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _PhotoSlot extends StatelessWidget {
  const _PhotoSlot({required this.path, required this.onTap, this.onRemove});

  final String? path;
  final VoidCallback? onTap;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (path == null)
            CustomPaint(
              painter: _DashedBorderPainter(color: Colors.grey.shade400),
              child: Center(
                child: Icon(Icons.add, color: Colors.grey.shade500, size: 24.r),
              ),
            )
          else
            ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: Image.file(File(path!), fit: BoxFit.cover),
            ),
          if (onRemove != null)
            Positioned(
              top: 4,
              right: 4,
              child: GestureDetector(
                onTap: onRemove,
                child: Container(
                  padding: EdgeInsets.all(2.r),
                  decoration: const BoxDecoration(
                    color: Colors.black54,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.close, size: 14.r, color: Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _GuidelinesTile extends StatelessWidget {
  const _GuidelinesTile({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 28.r,
            height: 28.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.textMuted),
            ),
            child: Icon(
              Icons.info_outline,
              size: 16.r,
              color: AppColors.textDark,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            'Photo\nguidelines',
            textAlign: TextAlign.center,
            style: TextFontStyle.headline11w400textMutedStyleSatoshi,
          ),
        ],
      ),
    );
  }
}

/// No dashed-border widget exists in the design system yet and this is the
/// only screen that needs one — a tiny local painter beats pulling in a
/// package for one visual.
class _DashedBorderPainter extends CustomPainter {
  _DashedBorderPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    final rrect = RRect.fromRectAndRadius(
      Offset.zero & size,
      const Radius.circular(8),
    );
    final path = Path()..addRRect(rrect);
    const dashWidth = 5.0;
    const dashSpace = 4.0;
    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        canvas.drawPath(
          metric.extractPath(distance, distance + dashWidth),
          paint,
        );
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedBorderPainter oldDelegate) =>
      oldDelegate.color != color;
}
