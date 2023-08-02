import 'package:chat_365/core/theme/app_colors.dart';
import 'package:chat_365/utils/ui/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CusPopItem {
  static PopupMenuItem getPopupMenuItem(
          {required int value,
          required String iconAsset,
          required String title,
          bool underLine = true,
          // VoidCallback? ontap,
          disable = false}) =>
      PopupMenuItem(
        // onTap: ontap,
        value: value,
        padding: EdgeInsets.only(left: 13, top: 10),
        height: double.minPositive,
        child: Stack(
          // mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              children: [
                Row(
                  children: [
                    SvgPicture.asset(
                      iconAsset,
                      width: 18,
                      color: AppColors.text,
                    ),
                    SizedBoxExt.w10,
                    Text(title),
                  ],
                ),
                SizedBoxExt.h10,
              ],
            ),
            if (underLine)
              Positioned(
                left: 26,
                right: 0,
                bottom: 0,
                child: Container(
                  height: 1,
                  decoration: BoxDecoration(color: AppColors.greyCC),
                ),
              )
          ],
        ),
      );
}
