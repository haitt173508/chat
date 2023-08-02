import 'package:chat_365/common/images.dart';
import 'package:chat_365/core/theme/app_colors.dart';
import 'package:chat_365/utils/ui/app_padding.dart';
import 'package:flutter/material.dart';
import 'package:chat_365/utils/data/extensions/context_extension.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AutoConnectAudioScreen extends StatefulWidget {
  const AutoConnectAudioScreen({Key? key}) : super(key: key);

  @override
  State<AutoConnectAudioScreen> createState() => _AutoConnectAudioScreenState();
}

class _AutoConnectAudioScreenState extends State<AutoConnectAudioScreen> {
  bool isOff = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tự động kết nối âm thanh',
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: Text('Hoàn thành'),
          )
        ],
      ),
      body: Container(
        height: 120,
        padding: AppPadding.paddingAll16,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: GestureDetector(
                onTap: (){
                  setState(() {
                    isOff=!isOff;
                  });
                },
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Tắt *',
                        style: context.theme.userListTileTextTheme
                            .copyWith(fontSize: 14),
                      ),
                    ),
                    isOff?SvgPicture.asset(Images.ic_tick,color: AppColors.blueGradients1,):Container(),
                  ],
                ),
              ),
            ),
            Divider(),
            Expanded(
              child: GestureDetector(
                onTap: (){
                  setState(() {
                    isOff=!isOff;
                  });
                },
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Wifi hoặc Dữ liệu di động',
                        style: context.theme.userListTileTextTheme
                            .copyWith(fontSize: 14),
                      ),
                    ),
                    Text('Bị tắt',style: context.theme.chatConversationDropdownTextStyle),
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
