import 'package:chat_365/core/theme/app_colors.dart';
import 'package:chat_365/core/theme/app_text_style.dart';
import 'package:chat_365/utils/data/extensions/overlay_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class FeatureItem extends StatelessWidget {
  const FeatureItem({
    Key? key,
    required this.assetPath,
    required this.gradient,
    required this.label,
    required this.onTap,
  }) : super(key: key);

  final String assetPath;
  final Gradient gradient;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      child: MaterialButton(
        onPressed: () async {
          // Navigator.of(context).popUntil((r) => r is! OverlayRoute);
          Overlay.of(context)?.clearObserveOverlay();
          await Future.delayed(Duration(milliseconds: 200));
          onTap();
        },
        child: Column(
          children: [
            Container(
              height: 46,
              width: 46,
              alignment: Alignment.center,
              padding: EdgeInsets.all((46 - 24) / 2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: gradient,
              ),
              child: SvgPicture.asset(
                assetPath,
                color: AppColors.white,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              label,
              maxLines: 2,
              textAlign: TextAlign.center,
              style: AppTextStyles.regularW500(
                context,
                size: 12,
                lineHeight: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
