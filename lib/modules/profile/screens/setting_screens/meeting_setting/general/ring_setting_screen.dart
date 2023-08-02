import 'package:chat_365/common/images.dart';
import 'package:chat_365/core/theme/app_colors.dart';
import 'package:chat_365/core/theme/app_dimens.dart';
import 'package:chat_365/router/app_pages.dart';
import 'package:chat_365/router/app_router.dart';
import 'package:chat_365/utils/ui/app_padding.dart';
import 'package:flutter/material.dart';
import 'package:chat_365/utils/data/extensions/context_extension.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RingSettingScreen extends StatefulWidget {
  const RingSettingScreen({Key? key}) : super(key: key);

  @override
  State<RingSettingScreen> createState() => _RingSettingScreenState();
}

class _RingSettingScreenState extends State<RingSettingScreen> {
  double volume = 15;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nhạc chuông'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: AppPadding.paddingAll16,
              child: Text(
                'ÂM LƯỢNG',
                style: context.theme.chatConversationDropdownTextStyle,
              ),
            ),
            Container(
              height: 50,
              padding: AppDimens.paddingHorizontal16,
              decoration: BoxDecoration(
                border: Border(
                    top: BorderSide(color: AppColors.greyCC),
                    bottom: BorderSide(color: AppColors.greyCC)),
              ),
              child: Row(
                children: [
                  SvgPicture.asset(
                    Images.ic_speakerphone_minimum,
                    color: context.theme.iconColor,
                  ),
                  Expanded(
                    child: Slider(
                      max: 100,
                      min: 0,
                      onChanged: (double value) {
                        setState(() {
                          volume = value;
                        });
                      },
                      value: volume,
                    ),
                  ),
                  SvgPicture.asset(
                    Images.ic_speakerphone,
                    color: context.theme.iconColor,
                    width: 20,
                    height: 20,
                  ),
                ],
              ),
            ),
            Container(
              height: 60,
              margin: AppDimens.paddingVertical16,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                border: Border(
                    top: BorderSide(color: AppColors.greyCC),
                    bottom: BorderSide(color: AppColors.greyCC)),
              ),
              child: GestureDetector(
                onTap: () =>
                    AppRouter.toPage(context, AppPages.Meeting_SelectRing),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        'Nhạc chuông',
                        style: context.theme.userListTileTextTheme
                            .copyWith(fontSize: 14),
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Mặc định',
                              style: context
                                  .theme.chatConversationDropdownTextStyle,
                            ),
                          ),
                          SvgPicture.asset(
                            Images.ic_arrow_right,
                            color: context.theme.iconColor,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
