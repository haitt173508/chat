import 'package:chat_365/common/images.dart';
import 'package:chat_365/common/widgets/form/outline_text_form_field.dart';
import 'package:chat_365/core/theme/app_colors.dart';
import 'package:chat_365/core/theme/app_dimens.dart';
import 'package:chat_365/core/theme/app_text_style.dart';
import 'package:chat_365/router/app_pages.dart';
import 'package:chat_365/router/app_router.dart';
import 'package:chat_365/utils/ui/app_border_and_radius.dart';
import 'package:flutter/material.dart';
import 'package:chat_365/utils/data/extensions/context_extension.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class EditMeetingSchedule extends StatefulWidget {
  const EditMeetingSchedule({Key? key}) : super(key: key);

  @override
  State<EditMeetingSchedule> createState() => _EditMeetingScheduleState();
}

class _EditMeetingScheduleState extends State<EditMeetingSchedule> {
  TextEditingController dateController = TextEditingController();
  TextEditingController durationController = TextEditingController();

  bool personalID = false;
  bool requirePassword = true;
  bool waitingRoom = false;
  bool hostsVideo = false;
  bool participantsVideos = false;
  bool showAdvanceSetting = false;

  String repeatValue = 'Không có';

  DateTime _dateTime = DateTime.now();
  DateTime _time = DateTime(0, 0, 0, 0, 30);
  DateFormat _durationFormat = DateFormat(' mm ');

  @override
  void initState() {
    super.initState();
    dateController.text = DateFormat('dd/MM/yyyy - hh:mm a').format(_dateTime);
    durationController.text = _durationFormat.format(_time) + 'phút';
  }

  @override
  void dispose() {
    super.dispose();
    dateController.dispose();
    durationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chỉnh sửa cuộc họp'),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {},
            child: Text(
              'Lưu',
              style: AppTextStyles.iconButton(context)
                  .copyWith(color: context.theme.primaryColor),
            ),
          )
        ],
      ),
      body: ListView(
        padding: AppDimens.paddingHorizontal16,
        shrinkWrap: true,
        children: [
          Container(
            height: 60,
            margin: AppDimens.paddingVertical16,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Chủ đề',
                  style:
                      context.theme.chatConversationDropdownTextStyle.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                OutlineTextFormField(
                  decoration: context.theme.inputDecoration
                      .copyWith(hintText: 'Nhập tiêu đề cuộc họp'),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {},
            child: Row(
              children: [
                SvgPicture.asset(
                  Images.ic_add_auth,
                  width: 20,
                  height: 20,
                ),
                Text(
                  'Thêm mô tả',
                  style: AppTextStyles.iconButton(context)
                      .copyWith(color: context.theme.primaryColor),
                ),
              ],
            ),
          ),
          Container(
            height: 69,
            margin: AppDimens.paddingVertical16,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Thời gian lên lịch',
                  style:
                      context.theme.chatConversationDropdownTextStyle.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                OutlineTextFormField(
                  controller: dateController,
                  decoration: context.theme.inputDecoration.copyWith(
                    hintText: 'aaaaa',
                    suffixIcon: IconButton(
                        onPressed: () {
                          showCupertinoModalPopup(
                            context: context,
                            builder: (_) => Container(
                              height: 200,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                  borderRadius: AppBorderAndRadius
                                      .chatMessageTopBorderRadius,
                                  color: AppColors.lightGray),
                              child: Column(
                                children: [
                                  Container(
                                    alignment: Alignment.centerRight,
                                    height: 44,
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                        borderRadius: AppBorderAndRadius
                                            .chatMessageTopBorderRadius,
                                        color: AppColors.white),
                                    child: TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text('Xong'),
                                    ),
                                  ),
                                  Expanded(
                                    child: CupertinoDatePicker(
                                      initialDateTime: DateTime.now(),
                                      onDateTimeChanged: (date) {
                                        setState(() {
                                          _dateTime = date;
                                          dateController.text =
                                              DateFormat('dd/MM/yyyy - hh:mm a')
                                                  .format(_dateTime);
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        icon: SvgPicture.asset(
                          Images.ic_calender_1,
                          color: context.theme.iconColor,
                        )),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 69,
            margin: AppDimens.paddingVertical16,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Thời lượng',
                  style:
                      context.theme.chatConversationDropdownTextStyle.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                OutlineTextFormField(
                  controller: durationController,
                  decoration: context.theme.inputDecoration.copyWith(
                    hintText: 'aaaaa',
                    suffixIcon: IconButton(
                      onPressed: () {
                        showCupertinoModalPopup(
                          context: context,
                          builder: (_) => Container(
                            height: 200,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                borderRadius: AppBorderAndRadius
                                    .chatMessageTopBorderRadius,
                                color: AppColors.lightGray),
                            child: Column(
                              children: [
                                Container(
                                  alignment: Alignment.centerRight,
                                  height: 44,
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                      borderRadius: AppBorderAndRadius
                                          .chatMessageTopBorderRadius,
                                      color: AppColors.white),
                                  child: TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text('Xong'),
                                  ),
                                ),
                                Expanded(
                                  child: CupertinoDatePicker(
                                    mode: CupertinoDatePickerMode.time,
                                    use24hFormat: true,
                                    initialDateTime: DateTime(0, 0, 0, 0, 30),
                                    onDateTimeChanged: (time) {
                                      setState(() {
                                        _time = time;
                                        durationController.text = _time.hour ==
                                                0
                                            ? DateFormat('mm ').format(_time) +
                                                'phút'
                                            : DateFormat('HH giờ mm ')
                                                    .format(_time) +
                                                'phút';
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      icon: SvgPicture.asset(
                        Images.ic_clock,
                        color: context.theme.iconColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 69,
            margin: AppDimens.paddingVertical16,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Lặp lại',
                  style:
                      context.theme.chatConversationDropdownTextStyle.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                DropdownButtonFormField(
                  dropdownColor: context.theme.dropdownColor,
                  decoration: context.theme.inputDecoration,
                  icon: SvgPicture.asset(
                    Images.ic_arrow_down,
                    color: context.theme.iconColor,
                  ),
                  isExpanded: true,
                  value: repeatValue,
                  items: <String>[
                    'Không có',
                    'Hàng ngày',
                    'Hàng tuần',
                    'Mỗi 2 tuần',
                    'Hàng tháng',
                    'Hàng năm',
                  ]
                      .map<DropdownMenuItem<String>>(
                        (value) => DropdownMenuItem(
                          child: Text(value),
                          value: value,
                        ),
                      )
                      .toList(),
                  onChanged: (String? value) {
                    setState(() {
                      repeatValue = value!;
                    });
                  },
                ),
              ],
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sử dụng ID cuộc họp cá nhân',
                      style: context.theme.chatConversationDropdownTextStyle
                          .copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '241 522 1654',
                      style: context.theme.chatConversationDropdownTextStyle,
                    ),
                  ],
                ),
              ),
              CupertinoSwitch(
                activeColor: AppColors.lawnGreen,
                onChanged: (value) {
                  setState(() {
                    personalID = value;
                  });
                },
                value: personalID,
              ),
            ],
          ),
          Container(
            margin: AppDimens.paddingVertical16,
            child: Text(
              'Nếu tùy chọn này được bật, mọi tùy chọn cuộc họp mà bạn thay đổi ở đây sẽ được áp dụng cho tất cả các cuộc họp sử dụng ID cuộc họp cá nhân của bạn.',
              style: context.theme.chatConversationDropdownTextStyle,
            ),
          ),
          Text('BẢO MẬT'),
          Container(
            margin: AppDimens.paddingVertical16,
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Yêu cầu mật mã cuộc họp',
                        style: context.theme.chatConversationDropdownTextStyle
                            .copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        'Chỉ những người dùng có liên kết mời hoặc nhập đúng mật mã mới được tham gia.',
                        style: context.theme.chatConversationDropdownTextStyle,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                CupertinoSwitch(
                  activeColor: AppColors.lawnGreen,
                  onChanged: (value) {
                    setState(() {
                      requirePassword = value;
                    });
                  },
                  value: requirePassword,
                ),
              ],
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Mật mã',
                  style: context.theme.chatConversationDropdownTextStyle,
                ),
              ),
              Text(
                'abczxy',
                style: context.theme.chatConversationDropdownTextStyle,
              ),
            ],
          ),
          Container(
            margin: AppDimens.paddingVertical16,
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Kích hoạt phòng chờ',
                        style: context.theme.chatConversationDropdownTextStyle
                            .copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        'Chỉ những người dùng được người chủ trì chấp nhận mới được tham gia.',
                        style: context.theme.chatConversationDropdownTextStyle,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                CupertinoSwitch(
                  activeColor: AppColors.lawnGreen,
                  onChanged: (value) {
                    setState(() {
                      waitingRoom = value;
                    });
                  },
                  value: waitingRoom,
                ),
              ],
            ),
          ),
          Container(
            margin: AppDimens.paddingVertical16,
            height: 100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'TÙY CHỌN CUỘC HỌP',
                  style: context.theme.chatConversationDropdownTextStyle,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Video người chủ trì',
                        style: context.theme.chatConversationDropdownTextStyle
                            .copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    CupertinoSwitch(
                      activeColor: AppColors.lawnGreen,
                      onChanged: (value) {
                        setState(() {
                          hostsVideo = value;
                        });
                      },
                      value: hostsVideo,
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Video người tham gia',
                        style: context.theme.chatConversationDropdownTextStyle
                            .copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    CupertinoSwitch(
                      activeColor: AppColors.lawnGreen,
                      onChanged: (value) {
                        setState(() {
                          participantsVideos = value;
                        });
                      },
                      value: participantsVideos,
                    ),
                  ],
                ),
              ],
            ),
          ),
          !showAdvanceSetting
              ? TextButton(
                  onPressed: () {
                    setState(() {
                      showAdvanceSetting = true;
                    });
                  },
                  child: Row(
                    children: [
                      Expanded(
                          child: Text(
                        'Tùy chọn nâng cao',
                      )),
                    ],
                  ),
                )
              : Container(
                  height: 200,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Cho phép người tham gia được vào bất cứ lúc nào',
                              style: context
                                  .theme.chatConversationDropdownTextStyle
                                  .copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          CupertinoSwitch(
                            activeColor: AppColors.lawnGreen,
                            onChanged: (value) {
                              setState(() {
                                hostsVideo = value;
                              });
                            },
                            value: hostsVideo,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Tắt tiếng người tham gia cuộc họp',
                              style: context
                                  .theme.chatConversationDropdownTextStyle
                                  .copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          CupertinoSwitch(
                            activeColor: AppColors.lawnGreen,
                            onChanged: (value) {
                              setState(() {
                                participantsVideos = value;
                              });
                            },
                            value: participantsVideos,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Tự động ghi lại cuộc họp',
                              style: context
                                  .theme.chatConversationDropdownTextStyle
                                  .copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          CupertinoSwitch(
                            activeColor: AppColors.lawnGreen,
                            onChanged: (value) {
                              setState(() {
                                participantsVideos = value;
                              });
                            },
                            value: participantsVideos,
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () => AppRouter.toPage(
                            context, AppPages.AcceptOrDenyAccess),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Phê duyệt hoặc chặn quyền truy cập của người dùng từ các quốc gia/khu vực',
                                style: context
                                    .theme.chatConversationDropdownTextStyle
                                    .copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            SvgPicture.asset(
                              Images.ic_arrow_down,
                              color: context.theme.iconColor,
                            ),
                          ],
                        ),
                      ),
                      Text(
                        'Không có',
                        style: context.theme.chatConversationDropdownTextStyle,
                      ),
                    ],
                  ),
                ),
        ],
      ),
    );
  }
}
