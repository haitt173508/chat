import 'dart:ui';

import 'package:chat_365/common/images.dart';
import 'package:chat_365/core/theme/app_colors.dart';
import 'package:chat_365/core/theme/app_dimens.dart';
import 'package:chat_365/modules/call/meeting/screens/meeting_screen.dart';
import 'package:chat_365/utils/ui/app_border_and_radius.dart';
import 'package:chat_365/utils/ui/app_padding.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:chat_365/utils/data/extensions/context_extension.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/cupertino.dart';

class WhiteBoardSetting extends StatefulWidget {
  final bool isNew;
  WhiteBoardSetting({Key? key,this.isNew=false}) : super(key: key);

  @override
  State<WhiteBoardSetting> createState() => _WhiteBoardSettingState();
}

class _WhiteBoardSettingState extends State<WhiteBoardSetting> {
  bool readOnly = false;
  bool allowAccessLate = true;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: AppDimens.paddingVertical16,
        height: 350,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius:
          BorderRadius.vertical(top: AppBorderAndRadius.defaultRadius),
          color: AppColors.black50,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!widget.isNew)
              Padding(
                padding: AppDimens.paddingHorizontal16,
                child: Text(
                  'Cuộc họp của phòng kỹ thuật 2022 - 08 - 06 10:10 AM',
                  style: context.theme.userListTileTextTheme.copyWith(
                    color: AppColors.white,
                    fontSize: 14,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            Padding(
              padding: AppDimens.paddingALl16.copyWith(top: widget.isNew?0:16),
              child: Text(
                'TẤT CẢ NGƯỜI THAM GIA CÓ THỂ',
                style: context.theme.chatConversationDropdownTextStyle
                    .copyWith(color: AppColors.black99),
              ),
            ),
            Container(
              color: AppColors.tundora,
              child: Column(
                children: [
                  InkWell(
                    onTap: (){
                      setState(() {
                        readOnly = false;
                      });
                    },
                    child: Container(
                      padding: AppDimens.paddingHorizontal16,
                      height: 40,
                      child: Row(
                        children: [
                          Expanded(
                            child: Text('Chỉnh sửa',style: context.theme.chatConversationDropdownTextStyle.copyWith(color: AppColors.white),),
                          ),
                          readOnly?Container():SvgPicture.asset(Images.ic_tick,color: AppColors.primary,),
                        ],
                      ),
                    ),
                  ),
                  Divider(
                    color: context.theme.dividerDefaultColor,
                    thickness: 1,
                  ),
                  InkWell(
                    onTap: (){
                      setState(() {
                        readOnly =true;
                      });
                    },
                    child: Container(
                      padding: AppDimens.paddingHorizontal16,
                      height: 40,
                      child: Row(
                        children: [
                          Expanded(
                            child: Text('Xem',style: context.theme.chatConversationDropdownTextStyle.copyWith(color: AppColors.white),),
                          ),
                          !readOnly?Container():SvgPicture.asset(Images.ic_tick,color: AppColors.primary,),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: AppPadding.paddingVertical8,
              padding: AppDimens.paddingHorizontal16,
              height: 50,
              color: AppColors.tundora,
              child: Row(
                children: [
                  Expanded(
                    child: Text('Cho phép người tham gia truy cập sau cuộc họp',style: context.theme.chatConversationDropdownTextStyle.copyWith(color: AppColors.white),),
                  ),
                  Transform.scale(
                    scale: 0.75,
                    child: CupertinoSwitch(
                      onChanged: (v){
                        setState(() {
                          allowAccessLate=v;
                        });
                      },
                      value: allowAccessLate,
                    ),
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: (){
                isShowWhiteBoard = true;
                Navigator.pop(context);
              },
              child: Container(
                margin: AppDimens.paddingHorizontal16,
                height: 44,
                decoration: BoxDecoration(
                  borderRadius: AppBorderAndRadius.defaultBorderRadius,
                  gradient: AppColors.blueGradients,
                ),
                child: Center(
                  child: Text('Mở và cộng tác',style: TextStyle(color: AppColors.white),),
                ),
              ),
            ),
            InkWell(
              onTap: ()=>Navigator.pop(context),
              child: Container(
                height: 44,
                child: Center(child: Text('Hủy',style: TextStyle(color: AppColors.white),),),
              ),
            )
          ],
        ),
      );
  }
}
