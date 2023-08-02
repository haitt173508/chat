import 'dart:ui';

import 'package:chat_365/common/images.dart';
import 'package:chat_365/common/widgets/form/outline_text_form_field.dart';
import 'package:chat_365/core/constants/asset_path.dart';
import 'package:chat_365/core/theme/app_colors.dart';
import 'package:chat_365/core/theme/app_dimens.dart';
import 'package:chat_365/core/theme/app_form_field.dart';
import 'package:chat_365/modules/call/meeting/widgets/vote_view_item.dart';
import 'package:chat_365/router/app_pages.dart';
import 'package:chat_365/router/app_router.dart';
import 'package:chat_365/utils/ui/app_border_and_radius.dart';
import 'package:chat_365/utils/ui/app_padding.dart';
import 'package:flutter/material.dart';
import 'package:chat_365/utils/data/extensions/context_extension.dart';
import 'package:flutter_svg/flutter_svg.dart';



class VoteListScreen extends StatefulWidget {
  const VoteListScreen({Key? key}) : super(key: key);

  @override
  State<VoteListScreen> createState() => _VoteListScreenState();
}

class _VoteListScreenState extends State<VoteListScreen> {
  List<Widget> voteListItem = [VoteViewItem(),VoteViewItem()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColorDarkTheme,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.primaryColorDarkTheme,
        leading: IconButton(
          onPressed: ()=>Navigator.pop(context),
          icon: SvgPicture.asset(Images.ic_arrow_left,color: AppColors.white,),
        ),
        title: Text('Bỏ phiếu',style: TextStyle(color: AppColors.white),),
        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: () =>AppRouter.toPage(context, AppPages.MeetingVote_CreateScreen),
            child: Container(
              margin: AppPadding.paddingAll8,
              padding: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: AppBorderAndRadius.defaultBorderRadius,
                gradient: AppColors.blueGradients,
              ),
              child: Row(
                children: [
                  SvgPicture.asset(
                    Images.ic_vote,
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
                        hintText: 'Tìm kiếm bỏ phiếu',
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
              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.only(top: 16),
                  children: [
                    Column(
                      children: List.generate(voteListItem.length, (index)=>voteListItem[index]),
                    ),
                    Text(
                      'Hết danh sách',
                      style: TextStyle(color: AppColors.black99),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 32,),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
