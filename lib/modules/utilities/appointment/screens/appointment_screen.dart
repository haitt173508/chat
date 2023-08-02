import 'package:chat_365/common/images.dart';
import 'package:chat_365/common/widgets/user_list_tile.dart';
import 'package:chat_365/core/theme/app_colors.dart';
import 'package:chat_365/core/theme/app_dimens.dart';
import 'package:chat_365/modules/profile/screens/profile_chat_screens/profile_chat_screen.dart';
import 'package:chat_365/router/app_router_helper.dart';
import 'package:chat_365/utils/ui/app_padding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:chat_365/utils/data/extensions/context_extension.dart';

class AppointmentScreen extends StatefulWidget {
  final bool isAdmin;
  const AppointmentScreen({Key? key, this.isAdmin = true}) : super(key: key);
  static const argIsAdmin = 'isAdmin';
  @override
  State<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  bool reply = false;
  bool accept = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: Text('Chi tiết nhắc hẹn'),
        actions: widget.isAdmin
            ? [
                IconButton(
                    onPressed: () => AppRouterHelper.toCreateAppointmentPage(
                        context,
                        isCreate: false),
                    icon: SvgPicture.asset(
                      Images.ic_pencil,
                      color: AppColors.primary,
                    )),
                IconButton(
                    onPressed: () {},
                    icon: SvgPicture.asset(
                      Images.ic_trash,
                      color: AppColors.error,
                    )),
              ]
            : null,
      ),
      // body: AppointmentItem(avatar: Images.img_profile_test_2, appointmentTitle: 'Tên lịch hẹn', dateTime: DateTime.parse('2022-09-16 11:30:00'),loop: 'Lặp lại hàng ngày',),
      body: SafeArea(
        child: ListView(
          padding: AppDimens.paddingALl16,
          shrinkWrap: true,
          children: [
            UserListTile(
              avatar: CircleAvatar(
                radius: 20,
                backgroundImage: AssetImage(Images.img_profile_test_3),
              ),
              userName: 'Tên người tạo lịch hẹn',
              bottom: Text('1 giờ trước'),
            ),
            ListTile(
              leading: SvgPicture.asset(
                Images.ic_calendar,
                color: AppColors.primary,
              ),
              title: Text(
                'Lịch nhóm',
                style: context.theme.userListTileTextTheme.copyWith(
                  fontSize: 16,
                  color: AppColors.primary,
                ),
              ),
            ),
            UnderlineWidget(
              child: ListTile(
                leading: Image.asset(Images.img_celebration),
                title: Text(
                  'Tên lịch hẹn',
                  style: context.theme.chatConversationDropdownTextStyle
                      .copyWith(fontSize: 18),
                ),
              ),
            ),
            UnderlineWidget(
              child: ListTile(
                leading: SvgPicture.asset(
                  Images.ic_clock,
                  color: context.theme.iconColor,
                ),
                title: Text(
                  'Khoảng 2 ngày 1 tiếng 30 phút nữa',
                  style: context.theme.chatConversationDropdownTextStyle,
                ),
                subtitle: Text('Thứ năm, 01 tháng 09, 2022 . Lúc 11:30'),
              ),
            ),
            UnderlineWidget(
              child: ListTile(
                leading: SvgPicture.asset(
                  Images.ic_loop,
                  color: AppColors.tundora,
                ),
                title: Text(
                  'Lặp lại hàng ngày',
                  style: context.theme.chatConversationDropdownTextStyle,
                ),
              ),
            ),
            UnderlineWidget(
              child: ListTile(
                leading: SvgPicture.asset(
                  Images.ic_people_group,
                  color: AppColors.tundora,
                ),
                title: Text(
                  '2 tham gia, 1 từ chối',
                  style: context.theme.chatConversationDropdownTextStyle,
                ),
              ),
            ),
          ],
        ),
      ),
      bottomSheet: Container(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: reply
              ? [
                  Container(
                    width: 20,
                    height: 20,
                    padding: AppPadding.paddingAll4,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: accept
                                ? AppColors.primary
                                : AppColors.tundora)),
                    child: accept
                        ? SvgPicture.asset(
                            Images.ic_tick_bold,
                            color: AppColors.primary,
                          )
                        : SvgPicture.asset(
                            Images.ic_x,
                            color: AppColors.tundora,
                          ),
                  ),
                  Padding(
                    padding: AppDimens.paddingHorizontal8,
                    child: accept
                        ? Text(
                            'Bạn đã tham gia',
                            style: context
                                .theme.chatConversationDropdownTextStyle
                                .copyWith(
                                    color: AppColors.primary, fontSize: 12),
                          )
                        : Text(
                            'Bạn đã từ chối',
                            style: context
                                .theme.chatConversationDropdownTextStyle
                                .copyWith(
                                    color: AppColors.tundora, fontSize: 12),
                          ),
                  ),
                  IconButton(
                    onPressed: () => AppRouterHelper.toCreateAppointmentPage(
                        context,
                        isCreate: false),
                    icon: SvgPicture.asset(
                      Images.ic_pencil,
                      color: AppColors.tundora,
                    ),
                  ),
                ]
              : [
                  InkWell(
                    onTap: () {
                      reply = true;
                      setState(() {});
                    },
                    child: Text('Từ chối',
                        style: context.theme.chatConversationDropdownTextStyle
                            .copyWith(
                          fontSize: 12,
                        )),
                  ),
                  const SizedBox(
                    width: 30,
                  ),
                  InkWell(
                    onTap: () {
                      reply = true;
                      accept = true;
                      setState(() {});
                    },
                    child: Text(
                      'Tham gia',
                      style: context.theme.chatConversationDropdownTextStyle
                          .copyWith(
                        fontSize: 12,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
        ),
      ),
    );
  }
}
