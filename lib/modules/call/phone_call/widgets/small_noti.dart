import 'package:chat_365/core/theme/app_colors.dart';
import 'package:chat_365/core/theme/app_text_style.dart';
import 'package:chat_365/utils/ui/app_padding.dart';
import 'package:chat_365/utils/ui/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SmallNoti extends StatelessWidget {
  const SmallNoti({
    Key? key,
    required this.assestIcon,
    required this.title,
    this.widthIcon = 16,
  }) : super(key: key);
  final String assestIcon;
  final String title;
  final double? widthIcon;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppPadding.paddingHor12Vert5,
      margin: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
          color: AppColors.buttonCallScreenColor,
          borderRadius: BorderRadius.circular(100)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            assestIcon,
            width: widthIcon,
            color: AppColors.iconCallScreenColor,
          ),
          SizedBoxExt.w5,
          Flexible(
            child: Text(
              title,
              // overflow: TextOverflow.fade,
              // textAlign: TextAlign.center,
              style: AppTextStyles.regularW400(context,
                  size: 14, color: AppColors.white),
            ),
          ),
        ],
      ),
    );
  }
}
