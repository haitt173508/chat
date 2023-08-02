import 'package:chat_365/common/images.dart';
import 'package:chat_365/core/theme/app_text_style.dart';
import 'package:chat_365/router/app_pages.dart';
import 'package:chat_365/router/app_router.dart';
import 'package:chat_365/utils/ui/app_padding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:chat_365/utils/data/extensions/context_extension.dart';

class MeetingSettingMainScreen extends StatefulWidget {
  const MeetingSettingMainScreen({Key? key}) : super(key: key);

  @override
  State<MeetingSettingMainScreen> createState() => _MeetingSettingMainScreenState();
}

class _MeetingSettingMainScreenState extends State<MeetingSettingMainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cài đặt cuộc họp'),
        centerTitle: true,
      ),
      body: ListView(
        padding: AppPadding.paddingAll16.copyWith(top: 0),
        children: [
          //Cuộc họp
          ListTile(
            contentPadding: AppPadding.paddingHor15Vert21,
            onTap: () {
              AppRouter.toPage(context, AppPages.Meeting_Setting);
            },
            leading: SvgPicture.asset(
              Images.ic_clock,
              color: context.theme.iconColor,
              width: 28,
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Cuộc họp",
                  style: AppTextStyles.titleListTileSetting(context),
                ),
                SvgPicture.asset(
                  Images.ic_arrow_right,
                  color: context.theme.iconColor,
                )
              ],
            ),
          ),

          //Trò chuyện
          ListTile(
            contentPadding: AppPadding.paddingHor15Vert21,
            onTap: () {
              AppRouter.toPage(context, AppPages.MessageMeeting_Setting);
            },
            leading: SvgPicture.asset(
              Images.ic_chat,
              color: context.theme.iconColor,
              width: 28,
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Trò chuyện",
                  style: AppTextStyles.titleListTileSetting(context),
                ),
                SvgPicture.asset(
                  Images.ic_arrow_right,
                  color: context.theme.iconColor,
                )
              ],
            ),
          ),

          //Chung
          ListTile(
            contentPadding: AppPadding.paddingHor15Vert21,
            onTap: () {
              AppRouter.toPage(context, AppPages.GeneralMeeting_Setting);
            },
            leading: SvgPicture.asset(
              Images.ic_setting,
              color: context.theme.iconColor,
              width: 28,
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Chung",
                  style: AppTextStyles.titleListTileSetting(context),
                ),
                SvgPicture.asset(
                  Images.ic_arrow_right,
                  color: context.theme.iconColor,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
