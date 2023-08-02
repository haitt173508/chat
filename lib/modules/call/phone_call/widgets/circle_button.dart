
import 'package:chat_365/common/images.dart';
import 'package:chat_365/core/theme/app_colors.dart';
import 'package:chat_365/core/theme/app_text_style.dart';
import 'package:chat_365/utils/ui/app_padding.dart';
import 'package:chat_365/utils/ui/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CircleButton extends StatelessWidget {
  const CircleButton(
      {Key? key,
      required this.onTap,
      this.name,
      this.widthIcon = 30,
      required this.assestIcon,
      required this.enable,
      this.backgroundColor,
      this.iconColor,
      this.padding,
      this.enableBorder = true,
      this.enableShake = false})
      : super(key: key);
  final Function() onTap;
  final String? name;
  final double widthIcon;
  final String assestIcon;
  final EdgeInsetsGeometry? padding;
  final bool enable;
  final bool enableBorder;
  final Color? backgroundColor;
  final Color? iconColor;
  final bool enableShake;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: padding ?? AppPadding.paddingAll15,
            decoration: BoxDecoration(
                color: backgroundColor ??
                    (enable
                        ? AppColors.buttonCallScreenColor
                        : AppColors.buttonDisableCallScreenColor),
                borderRadius: BorderRadius.circular(50),
                border: Border.all(
                    color: enableBorder
                        ? AppColors.dustyGray
                        : Colors.transparent,
                    width: enableBorder ? 1 : 0)),
            child: SvgPicture.asset(assestIcon,
                width: widthIcon,
                color: iconColor ??
                    (enable
                        ? AppColors.iconCallScreenColor
                        : AppColors.iconDisableCallScreenColor)),
          ),
        ),
        if (name != null) SizedBoxExt.h5,
        if (name != null)
          Text(
            name!,
            style: AppTextStyles.regularW500(context,
                size: 12, color: AppColors.white),
          ),
      ],
    );
  }
}
