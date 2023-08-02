import 'package:chat_365/core/theme/app_text_style.dart';
import 'package:chat_365/utils/data/extensions/context_extension.dart';
import 'package:chat_365/utils/ui/app_border_and_radius.dart';
import 'package:chat_365/utils/ui/app_padding.dart';
import 'package:flutter/material.dart';

class FillButton extends StatelessWidget {
  final Function()? onPressed;
  final String title;
  final TextStyle? style;
  final double? elevation;
  final EdgeInsetsGeometry? padding;
  final OutlinedBorder? shape;
  final double? width;
  final Color? backgroundColor;

  const FillButton(
      {Key? key,
      this.onPressed,
      required this.title,
      this.style,
      this.elevation,
      this.padding,
      this.shape,
      this.width,
      this.backgroundColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final button = ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        elevation: elevation ?? 0,
        padding: padding ?? AppPadding.paddingHor15Vert10,
        shape: shape ?? AppBorderAndRadius.roundedRectangleBorder,
        primary: backgroundColor ?? context.theme.primaryColor,
      ),
      child: Text(
        title,
        style: style ??
            AppTextStyles.button(context)
                .copyWith(color: context.theme.backgroundColor),
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
