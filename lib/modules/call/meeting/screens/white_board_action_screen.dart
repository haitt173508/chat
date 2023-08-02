import 'dart:async';

import 'package:chat_365/common/images.dart';
import 'package:chat_365/core/theme/app_colors.dart';
import 'package:chat_365/core/theme/app_dimens.dart';
import 'package:chat_365/utils/ui/app_border_and_radius.dart';
import 'package:flutter/material.dart';
import 'package:chat_365/utils/data/extensions/context_extension.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WhiteBoardActionScreen extends StatefulWidget {
  const WhiteBoardActionScreen({Key? key}) : super(key: key);

  @override
  State<WhiteBoardActionScreen> createState() => _WhiteBoardActionScreenState();
}

class _WhiteBoardActionScreenState extends State<WhiteBoardActionScreen> {
  late Timer _timer;

  _showSavedDialog() {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      // false = user must tap button, true = tap outside dialog
      builder: (BuildContext dialogContext) {
        _timer =
            Timer(Duration(seconds: 2), () => Navigator.pop(dialogContext));
        return AlertDialog(
          backgroundColor: Colors.transparent,
          content: Container(
            height: 120,
            decoration: BoxDecoration(
              borderRadius: AppBorderAndRadius.defaultBorderRadius,
              color: AppColors.tundora.withOpacity(0.5),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SvgPicture.asset(
                  Images.ic_check_green,
                  width: 40,
                  height: 40,
                ),
                Text(
                  'Đã lưu vào ảnh',
                  style: context.theme.chatConversationDropdownTextStyle
                      .copyWith(color: AppColors.white),
                ),
              ],
            ),
          ),
        );
      },
    ).then((value) {
      if (_timer.isActive) {
        _timer.cancel();
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Thêm hành động'),
        centerTitle: true,

      ),
      body: SafeArea(
        child: InkWell(
          onTap: (){
            Navigator.pop(context);
            _showSavedDialog();
          },
          child: Container(
            margin: AppDimens.paddingVertical16,
            padding: AppDimens.paddingHorizontal16,
            width: MediaQuery.of(context).size.width,
            height: 60,
            child: Text('Xuất',style: context.theme.chatConversationDropdownTextStyle,),
          ),
        ),
      ),
    );
  }
}
