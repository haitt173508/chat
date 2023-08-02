import 'dart:async';

import 'package:chat_365/common/images.dart';
import 'package:chat_365/core/theme/app_colors.dart';
import 'package:chat_365/modules/call/meeting/screens/meeting_screen.dart';
import 'package:chat_365/router/app_pages.dart';
import 'package:chat_365/router/app_router.dart';
import 'package:chat_365/utils/ui/app_border_and_radius.dart';
import 'package:chat_365/utils/ui/app_padding.dart';
import 'package:flutter/material.dart';
import 'package:chat_365/utils/data/extensions/context_extension.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WhiteBoard extends StatefulWidget {
  const WhiteBoard({Key? key}) : super(key: key);

  @override
  State<WhiteBoard> createState() => _WhiteBoardState();
}

class _WhiteBoardState extends State<WhiteBoard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: isFullScreen
          ? AppBar(
              elevation: 0,
              leadingWidth: 80,
              leading: Center(
                  child: Text(
                'Đang xem',
                style: context.theme.chatConversationDropdownTextStyle,
              )),
              title: Text(
                'Cuộc họp của phòng kỹ thuật',
                style:
                    context.theme.userListTileTextTheme.copyWith(fontSize: 14),
                overflow: TextOverflow.ellipsis,
              ),
              centerTitle: true,
              actions: [
                IconButton(
                  onPressed: () async => await AppRouter.toPage(
                      context, AppPages.MeetingWhiteBoard_ActionScreen),
                  icon: SvgPicture.asset(
                    Images.ic_more_hoz,
                    color: context.theme.iconColor,
                  ),
                ),
              ],
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.startDocked,
      floatingActionButton: FloatingActionButton(
        mini: true,
        onPressed: ()=>AppRouter.toPage(context, AppPages.MeetingWhiteBoard_PagesScreen),
        backgroundColor: context.theme.backgroundColor,
        child: Container(
          width: 40,
          height: 40,
          padding: AppPadding.paddingAll10,
          decoration: BoxDecoration(color: context.theme.backgroundColor, boxShadow: [
            BoxShadow(
              color: context.theme.iconColor,
              offset: Offset(0, 0),
              blurRadius: 7,
            ),
          ],
          borderRadius: BorderRadius.circular(100),),
          child: SvgPicture.asset(
            Images.ic_page,
            color: context.theme.iconColor,
          ),
        ),
      ),
    );
  }
}
