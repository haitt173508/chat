import 'dart:async';

import 'package:chat_365/common/images.dart';
import 'package:chat_365/core/theme/app_colors.dart';
import 'package:chat_365/utils/ui/app_border_and_radius.dart';
import 'package:chat_365/utils/ui/app_padding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:chat_365/utils/data/extensions/context_extension.dart';
import 'package:flutter/cupertino.dart';

class ShareScreen extends StatefulWidget {
  const ShareScreen({Key? key}) : super(key: key);

  @override
  State<ShareScreen> createState() => _ShareScreenState();
}

class _ShareScreenState extends State<ShareScreen> {
  late double _width = MediaQuery.of(context).size.width;
  late double _height = MediaQuery.of(context).size.height;

  int _lineWidth = 1;
  int _color = 1;
  bool isEditIconTap = false;
  bool isOptionShow = false;

  late List _option = [];

  _optionItem(
      {required void Function() onPressed,
      required Widget icon,
      required String label,
      Color color = AppColors.white}) {
    return Expanded(
      child: InkWell(
        onTap: onPressed,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            icon,
            Text(
              label,
              style: context.theme.chatConversationDropdownTextStyle
                  .copyWith(color: color, fontSize: 9),
            ),
          ],
        ),
      ),
    );
  }

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
  void initState() {
    super.initState();
    _option = [
      _optionItem(
          onPressed: () {},
          icon: SvgPicture.asset(
            Images.ic_filter,
            color: AppColors.white,
            width: 20,
            height: 20,
          ),
          label: 'Nổi bật'),
      _optionItem(
          onPressed: () {},
          icon: SvgPicture.asset(
            Images.ic_pencil,
            color: AppColors.white,
            width: 20,
            height: 20,
          ),
          label: 'Bút'),
      _optionItem(
          onPressed: (){
            setState(() {
              isOptionShow=!isOptionShow;
            });
          },
          icon: SvgPicture.asset(
            Images.ic_color,
            color: AppColors.peachGradients1,
            width: 20,
            height: 20,
          ),
          label: 'Màu sắc'),
      _optionItem(
          onPressed: () {},
          icon: SvgPicture.asset(
            Images.ic_eraser,
            color: AppColors.white,
            width: 20,
            height: 20,
          ),
          label: 'Cục tẩy'),
      _optionItem(
          onPressed: _showSavedDialog,
          icon: SvgPicture.asset(
            Images.ic_save,
            color: AppColors.white,
            width: 20,
            height: 20,
          ),
          label: 'Lưu'),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomLeft,
      children: [
        Container(
          margin: AppPadding.paddingAll8,
          height: isEditIconTap ? 50 : null,
          width: isEditIconTap ? _width * 0.75 : null,
          decoration: BoxDecoration(
            color: isEditIconTap ? AppColors.tundora : null,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: List.generate(
                isEditIconTap ? 6 : 1,
                (index) => index == 0
                    ? Container(
                        margin: isEditIconTap
                            ? EdgeInsets.only(left: 8)
                            : AppPadding.paddingAll8,
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.white),
                          color: isEditIconTap
                              ? AppColors.primary
                              : Colors.transparent,
                        ),
                        child: IconButton(
                            padding: AppPadding.paddingAll8,
                            onPressed: () {
                              setState(() {
                                isEditIconTap = !isEditIconTap;
                              });
                            },
                            icon: SvgPicture.asset(
                              Images.ic_pencil,
                              color: AppColors.white,
                            )),
                      )
                    : isEditIconTap
                        ? _option[index - 1]
                        : Container()),
          ),
        ),
        Positioned(
          bottom: 75,
          left: _width*0.33,
          child: Visibility(
            visible: isOptionShow,
            child: Container(
              padding: AppPadding.paddingAll16,
              height: 160,
              width: 180,
              decoration: BoxDecoration(
                borderRadius: AppBorderAndRadius.defaultBorderRadius,
                color: AppColors.tundora,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    'ĐỘ RỘNG DÒNG',
                    style: context.theme.chatConversationDropdownTextStyle
                        .copyWith(color: AppColors.white, fontSize: 10),
                  ),
                  Container(
                    height: 36,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              _lineWidth = 1;
                            });
                          },
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: _lineWidth == 1 ? AppColors.primary : null,
                            ),
                            child: SvgPicture.asset(Images.ic_pencil),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              _lineWidth = 2;
                            });
                          },
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: _lineWidth == 2 ? AppColors.primary : null,
                            ),
                            child: SvgPicture.asset(Images.ic_pencil),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              _lineWidth = 3;
                            });
                          },
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: _lineWidth == 3 ? AppColors.primary : null,
                            ),
                            child: SvgPicture.asset(Images.ic_pencil),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              _lineWidth = 4;
                            });
                          },
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: _lineWidth == 4 ? AppColors.primary : null,
                            ),
                            child: SvgPicture.asset(Images.ic_pencil),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    'MÀU SẮC',
                    style: context.theme.chatConversationDropdownTextStyle
                        .copyWith(color: AppColors.white, fontSize: 10),
                  ),
                  Container(
                    height: 36,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              _color = 1;
                            });
                          },
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: _color == 1 ? AppColors.primary : null,
                            ),
                            child: Center(
                              child: Container(
                                width:  25,
                                height:  25,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.black,
                                  border: Border.all(color: AppColors.white),
                                ),
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              _color = 2;
                            });
                          },
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: _color == 2 ? AppColors.primary : null,
                            ),
                            child: Center(
                              child: Container(
                                width:  25,
                                height:  25,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.primary,
                                  border: Border.all(color: AppColors.white),
                                ),
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              _color = 3;
                            });
                          },
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: _color == 3 ? AppColors.primary : null,
                            ),
                            child: Center(
                              child: Container(
                                width:  25,
                                height:  25,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.red,
                                  border: Border.all(color: AppColors.white),
                                ),
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              _color = 4;
                            });
                          },
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: _color == 4 ? AppColors.primary : null,
                            ),
                            child: Center(
                              child: Container(
                                width:  25,
                                height:  25,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.lawnGreen,
                                  border: Border.all(color: AppColors.white),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
