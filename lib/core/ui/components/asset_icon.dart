import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// A design icon from `assets/icons/`: an SVG (drawn in its own colours
/// unless [color] is given) or a tintable alpha PNG cut from the 4× design
/// renders (drawn in [color]). [size] is in design points.
class AssetIcon extends StatelessWidget {
  const AssetIcon(this.asset, {required this.size, this.color, super.key});

  final String asset;
  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final s = size.w;
    if (asset.endsWith('.svg')) {
      return SvgPicture.asset(
        asset,
        width: s,
        height: s,
        colorFilter: color == null
            ? null
            : ColorFilter.mode(color!, BlendMode.srcIn),
      );
    }
    return Image.asset(asset, width: s, height: s, color: color);
  }
}
