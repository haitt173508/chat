import 'package:chat_365/common/images.dart';
import 'package:chat_365/common/widgets/button/fill_button.dart';
import 'package:chat_365/core/theme/app_colors.dart';
import 'package:chat_365/core/theme/app_dimens.dart';
import 'package:chat_365/router/app_pages.dart';
import 'package:chat_365/router/app_router.dart';
import 'package:chat_365/utils/ui/app_border_and_radius.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:chat_365/utils/data/extensions/context_extension.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum timeLimit {
  limited,
  unlimited,
}

class TimeLimited extends StatefulWidget {
  const TimeLimited({Key? key,this.isCreate = true}) : super(key: key);
  final bool isCreate;

  @override
  State<TimeLimited> createState() => _TimeLimitedState();
}

class _TimeLimitedState extends State<TimeLimited> {
  late double _width = MediaQuery.of(context).size.width;
  DateTime date = DateTime.now();
  timeLimit _timeLimited = timeLimit.unlimited;

  _pickDateTime() {
    return showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (_) => Container(
        padding: AppDimens.paddingVertical16,
        height: 400,
        width: _width,
        decoration: BoxDecoration(
          borderRadius:
              BorderRadius.vertical(top: AppBorderAndRadius.defaultRadius),
          color: context.theme.backgroundColor,
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: IconButton(
                    onPressed: () => AppRouter.back(context),
                    icon: SvgPicture.asset(
                      Images.ic_arrow_left,
                      color: context.theme.iconColor,
                    ),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Center(
                    child: Text(
                      'Đặt thời hạn',
                      style: context.theme.userListTileTextTheme
                          .copyWith(fontSize: 14),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(),
                ),
              ],
            ),
            Expanded(
              child: CupertinoDatePicker(
                onDateTimeChanged: (value){},
                initialDateTime: date,
                // minimumDate: date,
                // maximumDate: DateTime(2022,date.month,date.day+7),
              ),
            ),
            InkWell(
              onTap: () =>AppRouter.backToPage(context, widget.isCreate?AppPages.MeetingVote_CreateScreen:AppPages.MeetingVote_EditScreen),
              child: Container(
                height: 44,
                margin: AppDimens.paddingALl16,
                decoration: BoxDecoration(
                  borderRadius: AppBorderAndRadius.defaultBorderRadius,
                  gradient: AppColors.blueGradients,
                ),
                child: Center(
                  child: Text(
                    'Xong',
                    style: context.theme.searchBigTextStyle
                        .copyWith(color: AppColors.white, fontSize: 16),
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () => AppRouter.back(context),
              child: Container(
                height: 44,
                margin: AppDimens.paddingHorizontal16,
                child: Center(
                  child: Text(
                    'Hủy',
                    style: context.theme.chatConversationDropdownTextStyle
                        .copyWith(fontSize: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppDimens.paddingVertical16,
      height: 300,
      width: _width,
      decoration: BoxDecoration(
        borderRadius:
            BorderRadius.vertical(top: AppBorderAndRadius.defaultRadius),
        color: context.theme.backgroundColor,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            'Đặt thời hạn',
            style: context.theme.userListTileTextTheme.copyWith(fontSize: 14),
          ),
          Divider(
            thickness: 1,
          ),
          RadioListTile<timeLimit>(
            contentPadding: AppDimens.paddingHorizontal16,
            title: Text('Không có thời hạn'),
            onChanged: (timeLimit? value) {
              setState(() {
                _timeLimited = value!;
              });
            },
            value: timeLimit.unlimited,
            groupValue: _timeLimited,
          ),
          Divider(
            thickness: 1,
          ),
          RadioListTile<timeLimit>(
            contentPadding: AppDimens.paddingHorizontal16,
            title: Text('Chọn thời diển kết thúc'),
            onChanged: (timeLimit? value) {
              setState(() {
                _timeLimited = value!;
              });
            },
            value: timeLimit.limited,
            groupValue: _timeLimited,
          ),
          Divider(
            thickness: 1,
          ),
          InkWell(
            onTap: () {
              _timeLimited == timeLimit.limited
                  ? _pickDateTime()
                  : Navigator.pop(context);
            },
            child: Container(
              height: 44,
              margin: AppDimens.paddingHorizontal16,
              decoration: BoxDecoration(
                borderRadius: AppBorderAndRadius.defaultBorderRadius,
                gradient: AppColors.blueGradients,
              ),
              child: Center(
                child: Text(
                  'Xong',
                  style: context.theme.searchBigTextStyle
                      .copyWith(color: AppColors.white, fontSize: 16),
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () => AppRouter.back(context),
            child: Container(
              height: 44,
              margin: AppDimens.paddingHorizontal16,
              child: Center(
                child: Text(
                  'Hủy',
                  style: context.theme.chatConversationDropdownTextStyle
                      .copyWith(fontSize: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
