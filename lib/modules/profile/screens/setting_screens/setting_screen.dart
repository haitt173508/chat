import 'package:chat_365/common/images.dart';
import 'package:chat_365/core/theme/app_text_style.dart';
import 'package:chat_365/router/app_pages.dart';
import 'package:chat_365/router/app_router.dart';
import 'package:chat_365/utils/data/extensions/context_extension.dart';
import 'package:chat_365/utils/ui/app_padding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        listTileTheme: ListTileThemeData(
          contentPadding: EdgeInsets.zero,
          dense: true,
          minLeadingWidth: 20,
          minVerticalPadding: 0,
        ),
      ),
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: Text('Cài đặt'),
            elevation: 1,
          ),
          body: Column(
            children: [
              //Chung
              ListTile(
                contentPadding: AppPadding.paddingHor15Vert21,
                onTap: () {
                  AppRouter.toPage(context, AppPages.General_Setting);
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
              //Âm thanh và video
              // ListTile(
              //   contentPadding: AppPadding.paddingHor15Vert21,
              //   onTap: () {},
              //   leading: SvgPicture.asset(
              //     Images.ic_micro,
              //     color: context.theme.iconColor,
              //     width: 28,
              //   ),
              //   title: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: [
              //       Text(
              //         "Âm thanh và video",
              //         style: AppTextStyles.titleListTileSetting(context),
              //       ),
              //       SvgPicture.asset(
              //         Images.ic_arrow_right,
              //         color: context.theme.iconColor,
              //       )
              //     ],
              //   ),
              // ),
              //Nhắn tin
              ListTile(
                contentPadding: AppPadding.paddingHor15Vert21,
                onTap: () {
                  AppRouter.toPage(context, AppPages.Message_Setting);
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
                      "Nhắn tin",
                      style: AppTextStyles.titleListTileSetting(context),
                    ),
                    SvgPicture.asset(
                      Images.ic_arrow_right,
                      color: context.theme.iconColor,
                    )
                  ],
                ),
              ),

              //Cuộc họp
              ListTile(
                contentPadding: AppPadding.paddingHor15Vert21,
                onTap: () {
                  AppRouter.toPage(context, AppPages.Meeting_Setting_Main);
                },
                leading: SvgPicture.asset(
                  Images.ic_video_call_1,
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

              //Thông báo
              ListTile(
                contentPadding: AppPadding.paddingHor15Vert21,
                onTap: () {
                  AppRouter.toPage(context, AppPages.Notification_Setting);
                },
                leading: SvgPicture.asset(
                  Images.ic_bell,
                  color: context.theme.iconColor,
                  width: 28,
                ),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Thông báo",
                      style: AppTextStyles.titleListTileSetting(context),
                    ),
                    SvgPicture.asset(
                      Images.ic_arrow_right,
                      color: context.theme.iconColor,
                    )
                  ],
                ),
              ),
              //Danh bạ
              ListTile(
                contentPadding: AppPadding.paddingHor15Vert21,
                onTap: () {
                  AppRouter.toPage(context, AppPages.Contact_Block);
                },
                leading: SvgPicture.asset(
                  Images.ic_contact,
                  color: context.theme.iconColor,
                  width: 28,
                ),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Danh bạ",
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
          )),
    );
  }
}
