import 'package:chat_365/common/blocs/user_info_bloc/bloc/user_info_bloc.dart';
import 'package:chat_365/common/images.dart';
import 'package:chat_365/common/models/selectable_Item.dart';
import 'package:chat_365/common/widgets/button/border_button.dart';
import 'package:chat_365/common/widgets/form/custom_dropdown_button.dart';
import 'package:chat_365/core/interfaces/interface_user_info.dart';
import 'package:chat_365/core/theme/app_text_style.dart';
import 'package:chat_365/modules/chat/blocs/chat_bloc/chat_bloc.dart';
import 'package:chat_365/router/app_router.dart';
import 'package:chat_365/router/app_router_helper.dart';
import 'package:chat_365/utils/data/enums/time_nofication.dart';
import 'package:chat_365/utils/data/extensions/context_extension.dart';
import 'package:chat_365/utils/ui/app_border_and_radius.dart';
import 'package:chat_365/utils/ui/app_dialogs.dart';
import 'package:chat_365/utils/ui/app_padding.dart';
import 'package:chat_365/utils/ui/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

TextStyle _style(BuildContext context, {Color? color}) =>
    AppTextStyles.regularW500(
      context,
      size: 14,
      lineHeight: 22,
      color: color ?? context.theme.textColor,
    );

class CalenderPhoneCallScreen extends StatefulWidget {
  const CalenderPhoneCallScreen({
    Key? key,
    required this.userInfo,
    required this.isGroup,
    required this.isUser,
  }) : super(key: key);

  static const userInfoArg = 'userInfoArg';
  static const isGroupArg = 'isGroupArg';

  final IUserInfo userInfo;
  final bool isGroup;
  final bool isUser;

  @override
  State<CalenderPhoneCallScreen> createState() =>
      _CalenderPhoneCallScreenState();
}

class _CalenderPhoneCallScreenState extends State<CalenderPhoneCallScreen> {
  TextEditingController _textNameCalenderController = TextEditingController();
  TextEditingController _textDateController = TextEditingController();
  TextEditingController _textTimeCalenderController = TextEditingController();
  SelectableItem? _timeNoti = TimeNotification.selectableItemList.first;
  late final int currentUserId;
  late final ChatBloc _chatBloc;
  // late final ProfileCubit _profileCubit;

  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    // _profileCubit = context.read<ProfileCubit>();
    currentUserId = context.userInfo().id;
    _chatBloc = context.read<ChatBloc>();
    _textNameCalenderController.text = '';
    _textDateController.text = '';
    _textTimeCalenderController.text = '';
    super.initState();
  }

  @override
  void dispose() {
    _textNameCalenderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final ProfileCubit _profileCubit = ProfileCubit(
    //   widget.userInfo.id,
    //   isGroup: false,
    // );

    return Theme(
      data: Theme.of(context).copyWith(
        listTileTheme: ListTileThemeData(
          contentPadding: EdgeInsets.zero,
          dense: true,
          minLeadingWidth: 20,
          minVerticalPadding: 0,
        ),
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text('Cài đặt'),
          elevation: 1,
        ),
        body: BlocListener<ChatBloc, ChatState>(
          bloc: _chatBloc,
          listenWhen: (_, current) =>
              mounted &&
              (current is ChatStateGettingConversationId ||
                  current is ChatStateGetConversationIdSuccess ||
                  current is ChatStateGetConversationIdError),
          listener: (context, state) {
            if (state is ChatStateGettingConversationId)
              AppDialogs.showLoadingCircle(context);
            else if (state is ChatStateGetConversationIdError)
              AppDialogs.toast(state.error.toString());
            else if (state is ChatStateGetConversationIdSuccess)
              AppRouterHelper.toChatPage(
                context,
                userInfoBloc: UserInfoBloc(
                  widget.userInfo,
                ),
                isGroup: false,
                senderId: currentUserId,
                conversationId: state.conversationId,
              );
          },
          child: Padding(
              padding: EdgeInsets.all(15),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //Tên cuộc gọi
                      Text(
                        'Tiêu đề',
                        style: AppTextStyles.regularW400(context, size: 14),
                      ),
                      SizedBoxExt.h5,
                      TextFormField(
                        controller: _textNameCalenderController,
                        style: context.theme.inputStyle,
                        decoration: context.theme.inputDecoration.copyWith(
                          hintText: 'Nhập tiêu đề cuộc gọi',
                          hintStyle: context.theme.hintStyle,
                        ),
                      ),

                      SizedBoxExt.h20,
                      Text(
                        'Thời gian lên lịch',
                        style: AppTextStyles.regularW400(context, size: 14),
                      ),
                      SizedBoxExt.h5,
                      //Chọn ngày
                      GestureDetector(
                        onTap: () async {
                          DateTime? datePick;
                          datePick = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2025),
                          );
                          _textDateController.text = datePick != null
                              ? DateFormat("dd-MM-yyyy")
                                  .format(datePick)
                                  .toString()
                              : '';
                        },
                        child: TextFormField(
                          enabled: false,
                          controller: _textDateController,
                          style: context.theme.inputStyle,
                          decoration: context.theme.inputDecoration.copyWith(
                              hintText: 'Chọn ngày',
                              disabledBorder:
                                  AppBorderAndRadius.outlineInputBorder,
                              hintStyle: context.theme.hintStyle,
                              suffixIcon: Padding(
                                padding: EdgeInsets.only(right: 20),
                                child: SvgPicture.asset(
                                  Images.ic_calender_1,
                                  color: context.theme.iconColor,
                                ),
                              )),
                        ),
                      ),
                      SizedBoxExt.h20,

                      //Chọn giờ
                      Theme(
                        data: Theme.of(context).copyWith(
                          primaryColor: Colors.cyan, //color you want at header
                          buttonTheme: ButtonTheme.of(context).copyWith(
                            colorScheme: ColorScheme.light(
                              secondary: Colors
                                  .cyan, // Color you want for action buttons (CANCEL and OK)
                            ),
                          ),
                        ),
                        child: GestureDetector(
                          onTap: () async {
                            TimeOfDay? timePick;
                            timePick = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            );
                            _textTimeCalenderController.text = timePick != null
                                ? '${timePick.hour.toString().padLeft(2, '0')}:${timePick.minute.toString().padLeft(2, '0')}'
                                : '';
                          },
                          child: TextFormField(
                            enabled: false,
                            controller: _textTimeCalenderController,
                            style: context.theme.inputStyle,
                            decoration: context.theme.inputDecoration.copyWith(
                                hintText: 'Chọn giờ',
                                disabledBorder:
                                    AppBorderAndRadius.outlineInputBorder,
                                hintStyle: context.theme.hintStyle,
                                suffixIcon: Padding(
                                  padding: EdgeInsets.only(right: 20),
                                  child: SvgPicture.asset(
                                    Images.ic_clock,
                                    color: context.theme.iconColor,
                                  ),
                                )),
                          ),
                        ),
                      ),
                      SizedBoxExt.h20,
                      Text(
                        'Thông báo',
                        style: AppTextStyles.regularW400(context, size: 14),
                      ),
                      SizedBoxExt.h5,
                      CustomDropdownButtonFormField<SelectableItem>(
                        decoration: context.theme.inputDecoration.copyWith(
                          hintStyle: context.theme.hintStyle,
                        ),
                        icon: SvgPicture.asset(Images.ic_arrow_down),
                        items: TimeNotification.selectableItemList
                            .map<CustomDropdownMenuItem<SelectableItem>>(
                              (e) => CustomDropdownMenuItem<SelectableItem>(
                                child: Text(
                                  e.name,
                                  style: AppTextStyles.iconButton(context),
                                ),
                                value: e,
                              ),
                            )
                            .toList(),
                        value: _timeNoti,
                        onChanged: (value) {
                          setState(() {
                            _timeNoti = value;
                          });
                          // bloc.model.gender.value = value!;
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                      ),
                    ],
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    left: 0,
                    child: Container(
                      alignment: Alignment.center,
                      child: RoundedButton(
                          label: 'Lên lịch',
                          fillStyle: true,
                          onPressed: () {
                            AppDialogs.showConfirmDialog(context,
                                title: 'Xác nhận đặt lịch cuộg gọi',
                                content: Padding(
                                  padding: AppPadding.paddingVertical20,
                                  child: Text(
                                    'Đồng ý lên lịch cuộc gọi ${_textNameCalenderController.text} vào ${_textDateController.text} lúc ${_textTimeCalenderController.text}?',
                                    textAlign: TextAlign.center,
                                  ),
                                ), onFunction: (_) {
                              Future.delayed(Duration(milliseconds: 900), () {
                                AppRouter.back(context);
                                // Do something
                              });
                              return null;
                            },
                                successMessage:
                                    'Lịch gọi sẽ được báo trước ${_timeNoti!.name}',
                                nameFunction: 'Xác nhận');
                          }),
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}

class _ChangeStatusTextFieldListTile extends StatefulWidget {
  const _ChangeStatusTextFieldListTile({
    Key? key,
    required this.initStatus,
  }) : super(key: key);

  final String initStatus;

  @override
  State<_ChangeStatusTextFieldListTile> createState() =>
      __ChangeStatusTextFieldListTileState();
}

class __ChangeStatusTextFieldListTileState
    extends State<_ChangeStatusTextFieldListTile> {
  // late final ProfileCubit _profileCubit;
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // _profileCubit = context.read<ProfileCubit>();
    _controller.text = widget.initStatus;
  }

  bool _isEdit = false;

  Widget _buildTrailing(
    BuildContext context,
  ) =>
      InkWell(
        child: SvgPicture.asset(
          _isEdit ? Images.ic_tick : Images.ic_pencil,
        ),
        onTap: _changeMode,
      );

  _changeMode() {
    setState(() => _isEdit = !_isEdit);
    if (_isEdit) _focusNode.requestFocus();
    // else
    //   _profileCubit.changeStatus(_controller.text);
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: SvgPicture.asset(
        Images.ic_emoji,
      ),
      dense: true,
      trailing: _buildTrailing(context),
      title: TextField(
        style: _style(
          context,
        ),
        readOnly: !_isEdit,
        controller: _controller,
        focusNode: _focusNode,
        decoration: InputDecoration(
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 0),
        ),
      ),
    );
  }
}
