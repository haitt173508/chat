import 'package:chat_365/core/theme/app_colors.dart';
import 'package:chat_365/core/theme/app_text_style.dart';
import 'package:flutter/material.dart';

class ButtonBorderIndex extends StatelessWidget {
  const ButtonBorderIndex({
    Key? key,
    required this.onPressed,
    required this.enable,
    required this.title,
    required this.width,
  }) : super(key: key);
  final VoidCallback onPressed;
  final String title;
  final double width;
  final bool enable;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: TextButton(
          child: Text(
            title,
            style: AppTextStyles.regularW500(context,
                size: 12, color: AppColors.white),
          ),
          style: TextButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 6),
            backgroundColor:
                enable ? AppColors.white.withOpacity(0.2) : AppColors.text,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
              side: BorderSide(
                color: AppColors.white.withOpacity(0.4),
              ),
            ),
            splashFactory: NoSplash.splashFactory,
          ),
          onPressed: () {
            onPressed();
          }),
    );
  }
}
