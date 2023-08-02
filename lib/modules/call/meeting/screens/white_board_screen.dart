import 'dart:ui';
import 'package:chat_365/common/widgets/form/outline_text_form_field.dart';
import 'package:chat_365/core/constants/asset_path.dart';
import 'package:chat_365/core/theme/app_form_field.dart';
import 'package:chat_365/modules/call/meeting/screens/meeting_screen.dart';
import 'package:chat_365/modules/call/meeting/widgets/white_board_setting.dart';
import 'package:flutter/services.dart';
import 'package:chat_365/common/images.dart';
import 'package:chat_365/core/theme/app_colors.dart';
import 'package:chat_365/core/theme/app_dimens.dart';
import 'package:chat_365/utils/ui/app_border_and_radius.dart';
import 'package:chat_365/utils/ui/app_padding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:chat_365/utils/data/extensions/context_extension.dart';

class WhiteBoardScreen extends StatefulWidget {
  const WhiteBoardScreen({Key? key}) : super(key: key);

  @override
  State<WhiteBoardScreen> createState() => _WhiteBoardScreenState();
}

class _WhiteBoardScreenState extends State<WhiteBoardScreen> {
  List _whiteBoardItem = <Widget>[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _whiteBoardItem = <Widget>[_buildWhiteBoardItem(),_buildWhiteBoardItem()];
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  _buildWhiteBoardItem(){
    return InkWell(
      onTap: ()=>_whiteBoardSetting(),
      child: Container(
        height: 70,
        margin: AppPadding.paddingVertical8,
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: AppBorderAndRadius.defaultBorderRadius,
                  color: AppColors.white,
                ),
              ),
            ),
            Expanded(child: Padding(
              padding: AppDimens.paddingHorizontal16,
              child: Text('Untitled',style: TextStyle(color: AppColors.white),),
            ),),
          ],
        ),
      ),
    );
  }

  _whiteBoardSetting({bool isNew = false}) {
    return showModalBottomSheet(
      isDismissible: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.transparent,
      context: context,
      builder: (_) => WhiteBoardSetting(isNew: isNew,),
    ).whenComplete((){
      if(isShowWhiteBoard){
        Navigator.pop(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.tundora,
      appBar: AppBar(
        systemOverlayStyle:
            SystemUiOverlayStyle(statusBarColor: AppColors.tundora),
        elevation: 0,
        backgroundColor: AppColors.tundora,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: SvgPicture.asset(
            Images.ic_arrow_back,
            color: AppColors.white,
          ),
        ),
        title: Text(
          'Bảng trắng',
          style: TextStyle(color: AppColors.white),
        ),
        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: () => _whiteBoardSetting(isNew: true),
            child: Container(
              margin: AppPadding.paddingAll8,
              padding: EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                borderRadius: AppBorderAndRadius.defaultBorderRadius,
                gradient: AppColors.blueGradients,
              ),
              child: Row(
                children: [
                  SvgPicture.asset(
                    Images.ic_board_add,
                    color: AppColors.white,
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  Text(
                    'Mới',
                    style: TextStyle(color: AppColors.white),
                  )
                ],
              ),
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Container(
          margin: AppPadding.paddingHor15,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: OutlineTextFormField(
                      decoration: AppFormField.inputDecorationDark.copyWith(
                        prefixIcon: SvgPicture.asset(AssetPath.search),
                        hintText: 'Tìm kiếm bảng trắng',
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Container(
                    width: 40,
                    height: 40,
                    padding: AppPadding.paddingAll8,
                    decoration: BoxDecoration(
                      borderRadius: AppBorderAndRadius.defaultBorderRadius,
                      color: AppColors.black50,
                    ),
                    child: SvgPicture.asset(
                      Images.ic_redo,
                      color: AppColors.white,
                    ),
                  ),
                ],
              ),
              ListView.builder(
                  padding: AppDimens.paddingVertical16,
                  shrinkWrap: true,
                  itemCount: _whiteBoardItem.length,
                  itemBuilder: (_, index) {
                    return _whiteBoardItem[index];
                  }),
              Text(
                'Hết danh sách',
                style: TextStyle(color: AppColors.black99),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
