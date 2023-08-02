import 'package:chat_365/common/images.dart';
import 'package:chat_365/core/theme/app_colors.dart';
import 'package:chat_365/core/theme/app_text_style.dart';
import 'package:chat_365/modules/home_qr_code/model/detail_company_model.dart';
import 'package:chat_365/utils/data/enums/user_type.dart';
import 'package:chat_365/utils/data/extensions/context_extension.dart';
import 'package:chat_365/utils/ui/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailInfo extends StatelessWidget {
  const DetailInfo({
    Key? key,
    required this.type,
    required this.detailInfo,
  }) : super(key: key);

  final DetailModel detailInfo;
  final UserType type;

  @override
  Widget build(BuildContext context) {

    if (type != UserType.staff && type != UserType.company && type != UserType.customer)
      throw Exception('Sai thông tin userType $type truyền vào !');

    Widget _iconText(
      String icon,
      String text,
    ) {
      return Row(
        children: [
          SvgPicture.asset(
            icon,
            height: 20,
            width: 20,
            color: AppColors.doveGray,
          ),
          SizedBox(width: 13.5),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.regularW400(context, size: 16),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          )
        ],
      );
    }

    return Container(
      width: context.mediaQuerySize.width,
      padding: EdgeInsets.symmetric(horizontal: 23, vertical: 15),
      // margin: EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: AppColors.blueEDF8FD,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            detailInfo.username,
            style: AppTextStyles.regularW500(
              context,
              size: 16,
              color: context.theme.primaryColor,
            ),
          ),
          SizedBoxExt.h5,
          if (type == UserType.company)
            Text(
              detailInfo.title,
              style: AppTextStyles.regularW400(
                context,
                size: 16,
                color: context.theme.primaryColor,
              ),
            ),
          SizedBoxExt.h5,
          Divider(
            color: AppColors.grayDCDCDC,
          ),
          SizedBoxExt.h10,
          _iconText(Images.ic_bag, detailInfo.cate),
          SizedBoxExt.h10,
          if (type == UserType.company) _iconText(Images.ic_notify_money, detailInfo.money),
          if (type == UserType.company) SizedBoxExt.h10,
          _iconText(Images.ic_choose_location, detailInfo.city),
          SizedBoxExt.h15,
          Divider(
            color: AppColors.grayDCDCDC,
          ),
          TextButton(
              onPressed: () {
                _launchURL(detailInfo.link);
              },
              child: Text(
                type == UserType.company ? 'Xem chi tiết nhà tuyển dụng' : 'Xem chi tiết ứng viên',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  decoration: TextDecoration.underline,
                  color: AppColors.primary,
                ),
              ))
        ],
      ),
    );
  }
}

_launchURL(url) async {
  await launch(url);
}
