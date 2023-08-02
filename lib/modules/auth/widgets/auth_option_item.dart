import 'package:chat_365/core/theme/app_colors.dart';
import 'package:chat_365/core/theme/app_dimens.dart';
import 'package:chat_365/core/theme/app_text_style.dart';
import 'package:chat_365/utils/data/extensions/context_extension.dart';
import 'package:chat_365/utils/ui/app_border_and_radius.dart';
import 'package:chat_365/utils/ui/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AuthOptionItem extends StatelessWidget {
  final String title;
  final String icon;
  final void Function()? onTap;

  const AuthOptionItem(
      {Key? key, required this.title, this.onTap, required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: AppDimens.paddingVertical15,
        // width: double.infinity,
        decoration: BoxDecoration(
            color: context.theme.backgroundColor,
            borderRadius: AppBorderAndRadius.defaultBorderRadius,
            border: AppBorderAndRadius.buttonBorder,
            boxShadow: [
              BoxShadow(
                color: context.theme.primaryColor.withOpacity(0.1),
                spreadRadius: 0,
                blurRadius: 8,
                offset: Offset(0, 6), // changes position of shadow
              ),
            ]),
        child: Row(
          children: [
            SizedBoxExt.w20,
            SvgPicture.asset(
              icon,
              color: AppColors.primary,
            ),
            SizedBoxExt.w15,
            Expanded(
              child: Text(
                title.toUpperCase(),
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.button(context).copyWith(
                  color: AppColors.primary,
                ),
              ),
            ),
            SizedBoxExt.w20,
          ],
        ),
      ),
    );
  }
}
