import 'package:chat_365/common/images.dart';
import 'package:chat_365/common/widgets/button/fill_button.dart';
import 'package:chat_365/core/theme/app_colors.dart';
import 'package:chat_365/core/theme/app_dimens.dart';
import 'package:chat_365/utils/ui/app_border_and_radius.dart';
import 'package:chat_365/utils/ui/app_padding.dart';
import 'package:flutter/material.dart';
import 'package:chat_365/utils/data/extensions/context_extension.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ParticipantScreen extends StatefulWidget {
  const ParticipantScreen({Key? key}) : super(key: key);

  @override
  State<ParticipantScreen> createState() => _ParticipantScreenState();
}

class _ParticipantScreenState extends State<ParticipantScreen> {
  bool waitingExpand = true;
  bool joinedExpand = true;

  _waitingItem() {
    return Container(
      height: 44,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.orange,
          radius: 15,
        ),
        title: Row(children: [
          Expanded(
            flex: 4,
            child: Text('Nguyễn Văn Nam',
                style:
                    context.theme.userListTileTextTheme.copyWith(fontSize: 14)),
          ),
          Expanded(
            flex: 2,
            child: Container(
              margin: AppDimens.paddingHorizontal10.copyWith(left: 0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: AppColors.primary),
              child: Center(
                  child: Text('Chấp nhận',
                      style: context.theme.userListTileTextTheme
                          .copyWith(fontSize: 14, color: AppColors.white))),
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8), color: AppColors.red),
              child: Center(
                  child: Text('Xóa',
                      style: context.theme.userListTileTextTheme
                          .copyWith(fontSize: 14, color: AppColors.white))),
            ),
          ),
        ]),
      ),
    );
  }

  _joinedItem() {
    return Container(
      height: 44,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.orange,
          radius: 15,
        ),
        title: Row(
          children: [
            Expanded(
              child: Text('Nguyễn Văn Nam',
                  style: context.theme.userListTileTextTheme
                      .copyWith(fontSize: 14)),
            ),
            IconButton(
              onPressed: () {},
              icon: SvgPicture.asset(
                Images.ic_mic_off,
                color: AppColors.red,
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: SvgPicture.asset(
                Images.ic_video_off,
                color: AppColors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Người tham gia (10)'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  waitingExpand = !waitingExpand;
                });
              },
              child: Container(
                margin: AppDimens.paddingALl16,
                child: Row(
                  children: [
                    Text(
                      'Phòng chờ(8)',
                      style: context.theme.userListTileTextTheme
                          .copyWith(fontSize: 14),
                    ),
                    SvgPicture.asset(
                      waitingExpand ? Images.ic_arrow_up : Images.ic_arrow_down,
                      color: context.theme.iconColor,
                    )
                  ],
                ),
              ),
            ),
            Column(
              children: waitingExpand
                  ? List.generate(5, (index) => _waitingItem())
                  : [],
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  joinedExpand = !joinedExpand;
                });
              },
              child: Container(
                margin: AppDimens.paddingALl16,
                child: Row(
                  children: [
                    Text(
                      'Đã tham gia(8)',
                      style: context.theme.userListTileTextTheme
                          .copyWith(fontSize: 14),
                    ),
                    SvgPicture.asset(
                      waitingExpand ? Images.ic_arrow_up : Images.ic_arrow_down,
                      color: context.theme.iconColor,
                    )
                  ],
                ),
              ),
            ),
            Column(
              children: joinedExpand
                  ? List.generate(15, (index) => _joinedItem())
                  : [],
            ),
            const SizedBox(
              height: 16,
            ),
          ],
        ),
      ),
    );
  }
}
