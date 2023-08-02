import 'package:chat_365/core/constants/string_constants.dart';
import 'package:chat_365/core/theme/app_colors.dart';
import 'package:chat_365/core/theme/app_text_style.dart';
import 'package:chat_365/modules/new_conversation/create_conversation_cubit/create_conversation_cubit.dart';
import 'package:chat_365/modules/new_conversation/screens/login_history/history_item.dart';
import 'package:chat_365/router/app_pages.dart';
import 'package:chat_365/router/app_router.dart';
import 'package:chat_365/utils/data/extensions/context_extension.dart';
import 'package:chat_365/utils/ui/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class LoginHistoryScreen extends StatefulWidget {
  const LoginHistoryScreen({Key? key}) : super(key: key);

  @override
  State<LoginHistoryScreen> createState() => _LoginHistoryScreenState();
}

class _LoginHistoryScreenState extends State<LoginHistoryScreen> {
  late final CreateConversationCubit _createConversationCubit;

  @override
  void initState() {
    _createConversationCubit = context.read<CreateConversationCubit>();
    _createConversationCubit.listLoginHistory(context.userInfo().id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: context.theme.backgroundFormFieldColor,
        appBar: AppBar(
          title: Text(
            StringConst.loginHistory,
          ),
          elevation: 1,
        ),
        body: BlocProvider.value(
          value: _createConversationCubit,
          child: BlocBuilder(
            bloc: _createConversationCubit,
            builder: (context, state) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      StringConst.newDevice,
                      style: AppTextStyles.regularW500(context, size: 14),
                    ),
                    SizedBoxExt.h15,
                    if (_createConversationCubit.latestDevice != null)
                      HistoryItem(
                        logUot: _createConversationCubit.latestDevice?.status ??
                            false,
                        checkBrand: _createConversationCubit
                            .latestDevice?.nameDevice
                            .split('- ')
                            .last,
                        loginMethod:
                            _createConversationCubit.latestDevice?.method,
                        nameDevice: _createConversationCubit
                            .latestDevice?.nameDevice
                            .split(' -')
                            .first,
                        time:
                            _createConversationCubit.timeNew?.split('T').first,
                        location:
                            _createConversationCubit.latestDevice?.location,
                      ),
                    SizedBoxExt.h16,
                    Divider(
                      color: AppColors.greyCACA,
                    ),
                    SizedBoxExt.h20,
                    Text(
                      StringConst.listDevice,
                      style: AppTextStyles.regularW500(context, size: 14),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemBuilder: (context, index) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 7.5),
                          child: HistoryItem(
                            logUot: _createConversationCubit
                                .loginHistoryData[index].status,
                            checkBrand: _createConversationCubit
                                .loginHistoryData[index].nameDevice
                                .split('- ')
                                .last,
                            loginMethod: _createConversationCubit
                                .loginHistoryData[index].method,
                            nameDevice: _createConversationCubit
                                .loginHistoryData[index].nameDevice
                                .split('-')
                                .first,
                            time: DateFormat('dd.MM.yyyy').format(
                                _createConversationCubit
                                    .loginHistoryData[index].time),
                            location: _createConversationCubit
                                .loginHistoryData[index].location,
                          ),
                        ),
                        itemCount:
                            _createConversationCubit.loginHistoryData.length,
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ));
  }
}
