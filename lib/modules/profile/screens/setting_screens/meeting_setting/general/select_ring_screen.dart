import 'package:chat_365/common/images.dart';
import 'package:chat_365/core/theme/app_colors.dart';
import 'package:chat_365/core/theme/app_dimens.dart';
import 'package:flutter/material.dart';
import 'package:chat_365/utils/data/extensions/context_extension.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SelectRingScreen extends StatefulWidget {
  const SelectRingScreen({Key? key}) : super(key: key);

  @override
  State<SelectRingScreen> createState() => _SelectRingScreenState();
}

class _SelectRingScreenState extends State<SelectRingScreen> {
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nhạc chuông'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView.separated(
          padding: EdgeInsets.only(top: 16),
          shrinkWrap: true,
          itemCount: 20,
          itemBuilder: (_,index){
            return GestureDetector(
              onTap: (){
                setState(() {
                  selectedIndex = index;
                });
              },
              child: Container(
                padding: AppDimens.paddingHorizontal16,
                height: 50,
                child: Row(
                  children: [
                    Expanded(child: Text('Gợn sóng',style: context.theme.userListTileTextTheme.copyWith(fontSize: 14),),),
                    selectedIndex==index?SvgPicture.asset(Images.ic_tick,color: AppColors.blueGradients1,):Container(),
                  ],
                ),
              ),
            );
          },
          separatorBuilder: (_,index)=>Divider(),
        ),
      ),
    );
  }
}
