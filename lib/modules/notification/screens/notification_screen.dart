import 'package:chat_365/common/widgets/app_error_widget.dart';
import 'package:chat_365/common/widgets/custom_refresh_indicator.dart';
import 'package:chat_365/core/constants/string_constants.dart';
import 'package:chat_365/core/theme/app_text_style.dart';
import 'package:chat_365/modules/notification/notification_bloc/notification_bloc.dart';
import 'package:chat_365/utils/ui/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'list_notify_item.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late final NotificationBloc _notificationBloc;

  @override
  void initState() {
    _notificationBloc = context.read<NotificationBloc>();
    _notificationBloc.add(NotificationEventGetListNotification());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          StringConst.notification,
        ),
        actions: [
          const SizedBox(width: 15),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              'Tất cả',
              style: AppTextStyles.regularW700(
                context,
                size: 16,
                lineHeight: 19.2,
              ),
            ),
          ),
          const SizedBox(height: 5),
          Expanded(
            child: BlocBuilder<NotificationBloc, NotificationState>(
              bloc: _notificationBloc,
              builder: (context, state) {
                if (state is NotificationStateGetListNotificationError) return AppErrorWidget(error: state.error.error);
                if (state is NotificationStateGetListNotificationSuccess) {
                  var notifications = _notificationBloc.notificationsNew;

                  return CustomRefreshIndicator(
                    onRefresh: _notificationBloc.onRefresh,
                    key: ValueKey('refresh-key'),
                    child: ListView.builder(
                        padding: EdgeInsets.only(top: 10),
                        itemCount: notifications.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 15),
                            child: ListNotifyItem(
                              checkLink: notifications[index].link,
                              link: notifications[index].link,
                              checkNotify: notifications[index].type,
                              // badge:
                              //
                              // Container(
                              //   height: 23,
                              //   width: 23,
                              //   decoration: BoxDecoration(
                              //     borderRadius: BorderRadius.circular(100),
                              //     color: notifications[index].type == 'ChangeSalary'
                              //         ? AppColors.orange
                              //         : notifications[index].type == 'DecilineOffer'
                              //             ? AppColors.red
                              //             : notifications[index].type == 'AcceptOffer'
                              //                 ? AppColors.lawnGreen
                              //                 : notifications[index].type == 'NTD'
                              //                     ? AppColors.primary
                              //                     : AppColors.primary,
                              //   ),
                              //   child: Padding(
                              //     padding: const EdgeInsets.all(4.0),
                              //     child: SvgPicture.asset(
                              //       notifications[index].type == 'ChangeSalary'
                              //           ? Images.ic_notify_money
                              //           : notifications[index].type == 'DecilineOffer'
                              //               ? Images.ic_notify_offer_refuse
                              //               : notifications[index].type == 'AcceptOffer'
                              //                   ? Images.ic_notify_offer
                              //                   : notifications[index].type == 'NTD'
                              //                       ? Images.ic_notify_user
                              //                       : Images.ic_notify_user,
                              //       height: 10,
                              //       width: 10,
                              //     ),
                              //   ),
                              // ),
                              title: notifications[index].message,
                              avatar: notifications[index].participant.linkAvatar,
                              source: notifications[index].participant.userName,
                              // subtitle:,
                              time: notifications[index].time,
                            ),
                          );
                        }),
                  );
                }
                return WidgetUtils.centerLoadingCircle;
              },
            ),
          ),
        ],
      ),
    );
  }
}
