import 'dart:developer';

import 'package:chat_365/common/images.dart';
import 'package:chat_365/common/widgets/form/outline_text_form_field.dart';
import 'package:chat_365/core/constants/app_constants.dart';
import 'package:chat_365/core/constants/string_constants.dart';
import 'package:chat_365/core/theme/app_colors.dart';
import 'package:chat_365/core/theme/app_dimens.dart';
import 'package:chat_365/router/app_router.dart';
import 'package:chat_365/utils/ui/app_border_and_radius.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:chat_365/utils/data/extensions/context_extension.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

import '../../../../utils/ui/widget_utils.dart';

List<String>? _selectedDateLoop;

class CreateAppointmentScreen extends StatefulWidget {
  final bool isCreate;

  const CreateAppointmentScreen({Key? key, this.isCreate = true})
      : super(key: key);

  static const String argIsCreate = 'isCreate';

  @override
  State<CreateAppointmentScreen> createState() =>
      _CreateAppointmentScreenState();
}

class _CreateAppointmentScreenState extends State<CreateAppointmentScreen> {
  String selectedEmoji = Images.img_clock;
  String? loop;
  List<String> _loops = [
    'Không lặp lại',
    'Hàng ngày',
    'Hàng tuần',
    'Nhiều ngày hàng tuần',
    'Hàng tháng',
    'hàng năm',
  ];
  late TextEditingController _textDateController;
  late TextEditingController _textTimeCalenderController;
  String temp = "";
  @override
  void initState() {
    // TODO: implement initState
    _textDateController = TextEditingController();
    _textTimeCalenderController = TextEditingController();
    super.initState();
  }

  _selectEmojiDialog() {
    return showDialog(
      context: context,
      builder: (_) => Dialog(
        insetPadding: AppDimens.paddingALl16,
        backgroundColor: Colors.transparent,
        child: Container(
          width: context.mediaQuerySize.width,
          height: context.mediaQuerySize.width,
          padding: AppDimens.paddingALl16,
          decoration: BoxDecoration(
            borderRadius: AppBorderAndRadius.defaultBorderRadius,
            color: context.theme.backgroundColor,
          ),
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5, crossAxisSpacing: 16, mainAxisSpacing: 16),
            itemCount: Images.appointmentEmoji.length,
            itemBuilder: (_, index) => InkWell(
              onTap: () {
                selectedEmoji = Images.appointmentEmoji[index];
                AppRouter.back(context);
              },
              child: Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                  image: AssetImage(Images.appointmentEmoji[index]),
                  fit: BoxFit.cover,
                )),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: Text(widget.isCreate ? 'Thêm nhắc hẹn' : 'Sửa nhắc hẹn'),
        actions: [
          TextButton(
            onPressed: () {},
            child: Text(widget.isCreate ? 'Tạo' : 'Lưu'),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: AppDimens.paddingHorizontal16,
          children: [
            InkWell(
              onTap: () async {
                await _selectEmojiDialog();
                setState(() {});
              },
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 50),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                        image: AssetImage(selectedEmoji),
                        fit: BoxFit.cover,
                      )),
                    ),
                    SvgPicture.asset(
                      Images.ic_arrow_down,
                      color: context.theme.iconColor,
                    )
                  ],
                ),
              ),
            ),
            OutlineTextFormField(
              decoration: context.theme.inputDecoration.copyWith(
                  hintText: 'Nhập tiêu đề nhắc hẹn',
                  prefixIcon: Padding(
                    padding: AppDimens.paddingHorizontal16.copyWith(right: 8),
                    child: SvgPicture.asset(
                      Images.ic_pencil,
                      color: context.theme.iconColor,
                    ),
                  )),
              maxLine: 4,
            ),
            SizedBoxExt.h20,

            InkWell(
              onTap: () async {
                DateTime? datePick;
                TimeOfDay? timePick;

                datePick = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2025),
                );
                timePick = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                _textDateController.text = (datePick != null
                        ? DateFormat("dd-MM-yyyy").format(datePick).toString()
                        : '') +
                    ". Lúc " +
                    (timePick != null
                        ? '${timePick.hour.toString().padLeft(2, '0')}:${timePick.minute.toString().padLeft(2, '0')}'
                        : '');
                log(_textDateController.text);
                // _textDateController.text = datePick != null
                //     ? DateFormat("dd-MM-yyyy").format(datePick).toString()
                //     : '';
                // //

                // _textTimeCalenderController.text = timePick != null
                //     ? '${timePick.hour.toString().padLeft(2, '0')}:${timePick.minute.toString().padLeft(2, '0')}'
                //     : '';
              },
              child: TextFormField(
                enabled: false,
                controller: _textDateController,
                style: context.theme.inputStyle,
                decoration: context.theme.inputDecoration.copyWith(
                    hintText: 'Chọn ngày',
                    disabledBorder: AppBorderAndRadius.outlineInputBorder,
                    hintStyle: context.theme.hintStyle,
                    prefixIcon: Padding(
                      padding: EdgeInsets.only(left: 16),
                      child: SvgPicture.asset(
                        Images.ic_clock,
                        color: context.theme.iconColor,
                      ),
                    )),
              ),
            ),

            ///
            // GestureDetector(
            //   onTap: () async {
            //     DateTime? datePick;
            //     datePick = await showDatePicker(
            //       context: context,
            //       initialDate: DateTime.now(),
            //       firstDate: DateTime(2000),
            //       lastDate: DateTime(2025),
            //     );
            //     _textDateController.text = datePick != null
            //         ? DateFormat("dd-MM-yyyy").format(datePick).toString()
            //         : '';
            //   },
            //   child: TextFormField(
            //     enabled: false,
            //     controller: _textDateController,
            //     style: context.theme.inputStyle,
            //     decoration: context.theme.inputDecoration.copyWith(
            //         hintText: 'Chọn ngày',
            //         disabledBorder: AppBorderAndRadius.outlineInputBorder,
            //         hintStyle: context.theme.hintStyle,
            //         prefixIcon: Padding(
            //           padding: EdgeInsets.only(left: 16),
            //           child: SvgPicture.asset(
            //             Images.ic_clock,
            //             color: context.theme.iconColor,
            //           ),
            //         )),
            //   ),
            // ),
            // SizedBoxExt.h20,

            // //Chọn giờ
            // Theme(
            //   data: Theme.of(context).copyWith(
            //     primaryColor: Colors.cyan, //color you want at header
            //     buttonTheme: ButtonTheme.of(context).copyWith(
            //       colorScheme: ColorScheme.light(
            //         secondary: Colors
            //             .cyan, // Color you want for action buttons (CANCEL and OK)
            //       ),
            //     ),
            //   ),
            //   child: GestureDetector(
            //     onTap: () async {
            //       TimeOfDay? timePick;
            //       timePick = await showTimePicker(
            //         context: context,
            //         initialTime: TimeOfDay.now(),
            //       );
            //       _textTimeCalenderController.text = timePick != null
            //           ? '${timePick.hour.toString().padLeft(2, '0')}:${timePick.minute.toString().padLeft(2, '0')}'
            //           : '';
            //     },
            //     child: TextFormField(
            //       enabled: false,
            //       controller: _textTimeCalenderController,
            //       style: context.theme.inputStyle,
            //       decoration: context.theme.inputDecoration.copyWith(
            //           hintText: 'Chọn giờ',
            //           disabledBorder: AppBorderAndRadius.outlineInputBorder,
            //           hintStyle: context.theme.hintStyle,
            //           suffixIcon: Padding(
            //             padding: EdgeInsets.only(right: 20),
            //             child: SvgPicture.asset(
            //               Images.ic_clock,
            //               color: context.theme.iconColor,
            //             ),
            //           )),
            //     ),
            //   ),
            // ),

            ///
            SizedBoxExt.h20,
            InkWell(
              onTap: () => showModalBottomSheet(
                backgroundColor: Colors.transparent,
                isScrollControlled: true,
                context: context,
                builder: (_) => Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.vertical(
                        top: AppBorderAndRadius.defaultRadius),
                    color: context.theme.backgroundColor,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(
                      _loops.length,
                      (index) => InkWell(
                        onTap: () async {
                          if (index == 3) {
                            await showDialog(
                              context: context,
                              builder: (_) => SelectLoopDialog(),
                            );
                            loop = 'Mỗi ' +
                                _selectedDateLoop
                                    .toString()
                                    .split('\[')
                                    .last
                                    .split('\]')
                                    .first
                                    .toLowerCase() +
                                ' hàng tuần';
                          } else {
                            _selectedDateLoop = null;
                            loop = _loops[index];
                          }
                          setState(() {});
                          AppRouter.back(context);
                        },
                        child: Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(_loops[index]),
                              if (index == 3)
                                SvgPicture.asset(
                                  Images.ic_arrow_right,
                                  color: context.theme.iconColor,
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: AppBorderAndRadius.defaultBorderRadius,
                  border: Border.all(color: AppColors.tundora),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: AppDimens.paddingHorizontal16,
                      child: SvgPicture.asset(
                        Images.ic_loop,
                        color: context.theme.iconColor,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        loop ?? 'Chọn lặp lại',
                        style: context.theme.chatConversationDropdownTextStyle
                            .copyWith(
                                fontSize: 16,
                                color: loop == null
                                    ? AppColors.boulder
                                    : context.theme.textColor),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
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

class SelectLoopDialog extends StatefulWidget {
  const SelectLoopDialog({Key? key}) : super(key: key);

  @override
  State<SelectLoopDialog> createState() => _SelectLoopDialogState();
}

class _SelectLoopDialogState extends State<SelectLoopDialog> {
  List<bool> _selectedDate = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
  ];
  List<String> _selectTemp = [];
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: AppBorderAndRadius.defaultBorderRadius,
      ),
      insetPadding: AppDimens.paddingALl16,
      actionsPadding: AppDimens.paddingALl16.copyWith(top: 0),
      contentPadding: AppDimens.paddingALl16.copyWith(bottom: 0),
      content: Container(
        width: context.mediaQuerySize.width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(
            AppConst.dayOfWeek.length,
            (index) => ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Checkbox(
                value: _selectedDate[index],
                onChanged: (v) {
                  _selectedDate[index] = !_selectedDate[index];
                  _selectTemp.add(AppConst.dayOfWeek[index]);
                  setState(() {});
                },
              ),
              onTap: () {
                _selectedDate[index] = !_selectedDate[index];
                _selectTemp.add(AppConst.dayOfWeek[index]);
                setState(() {});
              },
              title: Text(
                AppConst.dayOfWeek[index],
                style: context.theme.chatConversationDropdownTextStyle,
              ),
            ),
          ),
        ),
      ),
      actions: [
        InkWell(
          onTap: () {
            AppRouter.back(context);
          },
          child: Padding(
            padding: AppDimens.paddingHorizontal16,
            child: Text(
              'Đóng',
              style: context.theme.userListTileTextTheme.copyWith(fontSize: 16),
            ),
          ),
        ),
        InkWell(
          onTap: () {
            _selectedDateLoop = _selectTemp..sort();
            AppRouter.back(context);
          },
          child: Text(
            'Xong',
            style: context.theme.userListTileTextTheme.copyWith(
              color: AppColors.primary,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }
}
