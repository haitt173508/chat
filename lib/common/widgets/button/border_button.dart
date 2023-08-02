import 'package:chat_365/core/theme/app_dimens.dart';
import 'package:chat_365/core/theme/app_text_style.dart';
import 'package:chat_365/utils/data/extensions/context_extension.dart';
import 'package:chat_365/utils/ui/app_border_and_radius.dart';
import 'package:chat_365/utils/ui/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RoundedButton extends StatelessWidget {
  const RoundedButton({
    Key? key,
    required this.label,
    this.onPressed,
    this.labelStyle,
    required this.fillStyle,
    this.padding,
    this.width,
    this.color,
    this.icon,
    this.onLongPress,
  }) : super(key: key);

  final void Function()? onPressed;
  final void Function()? onLongPress;
  final String label;
  final TextStyle? labelStyle;
  final bool fillStyle;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final Color? color;
  final SvgPicture? icon;
  @override
  Widget build(BuildContext context) {
    final button = OutlinedButton(
      onPressed: onPressed,
      onLongPress: onLongPress,
      style: OutlinedButton.styleFrom(
        elevation: 0,
        padding: padding ?? AppDimens.paddingButton,
        side: BorderSide(
          color: context.theme.primaryColor,
          width: 1,
        ),
        shape: AppBorderAndRadius.roundedRectangleBorder,
        backgroundColor: fillStyle ? context.theme.primaryColor : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon ?? SizedBox(),
          icon != null ? SizedBoxExt.w10 : SizedBox(),
          Text(
            label,
            style: labelStyle ??
                AppTextStyles.button(context).copyWith(
                  color: fillStyle
                      ? context.theme.backgroundColor
                      : context.theme.primaryColor,
                ),
          ),
        ],
      ),
    );

    return width == null
        ? button
        : SizedBox(
            width: width,
            child: button,
          );
  }
}
