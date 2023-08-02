import 'package:chat_365/common/images.dart';
import 'package:chat_365/core/theme/app_colors.dart';
import 'package:chat_365/core/theme/app_text_style.dart';
import 'package:chat_365/modules/profile/screens/profile_chat_screens/profile_chat_screen.dart';
import 'package:chat_365/router/app_router.dart';
import 'package:chat_365/router/app_router_helper.dart';
import 'package:chat_365/utils/ui/app_padding.dart';
import 'package:flutter/material.dart';
import 'package:chat_365/utils/data/extensions/context_extension.dart';
import 'package:chat_365/utils/data/extensions/date_time_extension.dart';

class GroupCalendarScreen extends StatefulWidget {
  const GroupCalendarScreen({Key? key}) : super(key: key);

  @override
  State<GroupCalendarScreen> createState() => _GroupCalendarScreenState();
}

class _GroupCalendarScreenState extends State<GroupCalendarScreen> {

  _timeToString(DateTime time){
    String twoDigits(int n) => n.toString().padLeft(2,'0');
    String month = twoDigits(time.month);
    String date = twoDigits(time.day);
    String hour = twoDigits(time.hour);
    String minute = twoDigits(time.minute);
    String second = twoDigits(time.second);
    String dayInWeek = time.diffWith(showSpecialTime: true,showTimeStamp: false);
    return '$dayInWeek, $date tháng $month, ${time.year}. Lúc $hour:$minute';
  }

  _appointmentItem({required String iconPath,required String title,required DateTime time}){
    return ListTile(
      onTap: ()=>AppRouterHelper.toAppointmentPage(context),
      contentPadding: AppPadding.paddingVertical10,
      minLeadingWidth: 60,
      leading: Image.asset(iconPath,width: 50,height: 50,fit: BoxFit.cover,),
      title: Text(title,style: AppTextStyles.regularW400(context, size: 14),),
      subtitle: Text(_timeToString(time),style: AppTextStyles.regularW400(context, size: 12),),
    );
  }

  _addAppointment(){
    return ListTile(
      onTap: ()=>AppRouterHelper.toCreateAppointmentPage(context),
      contentPadding: AppPadding.paddingVertical10,
      minLeadingWidth: 60,
      leading: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: AppColors.blueGradients,
        ),
        child: Center(child: Text('+',style: AppTextStyles.regularW600(context, size: 20,color: AppColors.white),),),
      ),
      title: Text('Thêm kỷ niệm',style: AppTextStyles.regularW400(context, size: 14),),
      subtitle: Text('Sinh nhật, dấu mốc,...',style: AppTextStyles.regularW400(context, size: 12),),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: Text('Lịch nhóm'),
      ),
      body: SafeArea(
        child: ListView(
          shrinkWrap: true,
          padding: AppPadding.paddingHor15,
          children: [
            UnderlineWidget(
              child: Container(
                padding: AppPadding.paddingAll15,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Image.asset(Images.img_calendar),
                    Text(
                      'Cùng chia sẻ nhắc hẹn & kỉ niệm nhóm',
                      style: AppTextStyles.regularW500(context,
                          size: 16, lineHeight: 20),
                    ),
                    Text(
                      'Giúp cả nhóm ghi nhớ các sự kiện, sinh nhật và ngày kỉ niệm quan trọng trong năm',
                      style: AppTextStyles.regularW400(context,
                          size: 14, lineHeight: 20),
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
              ),
            ),
            //danh sach lich hen
            UnderlineWidget(
              child: Padding(
                padding: AppPadding.paddingVertical15,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Nhắc hẹn lịch sắp tới',style: AppTextStyles.regularW500(context, size: 14),),
                    _addAppointment(),
                    _appointmentItem(iconPath: Images.img_clock,title: 'Nhắc hẹn 1', time: DateTime.now()),
                    _appointmentItem(iconPath: Images.img_clock,title: 'Nhắc hẹn 1', time: DateTime.now()),
                    _appointmentItem(iconPath: Images.img_clock,title: 'Nhắc hẹn 1', time: DateTime.now()),
                    TextButton(onPressed: (){}, child: Text('Xem thêm')),
                  ],
                ),
              ),
            ),
            Padding(padding: AppPadding.paddingVertical15,child: Text('Ngày kỷ niệm hàng năm',style: AppTextStyles.regularW500(context, size: 14),),),
            _addAppointment(),
          ],
        ),
      ),
    );
  }
}
