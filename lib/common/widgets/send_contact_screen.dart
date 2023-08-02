import 'package:chat_365/common/blocs/friend_cubit/cubit/friend_cubit.dart';
import 'package:chat_365/common/widgets/_forward_listview_builder.dart';
import 'package:chat_365/common/widgets/app_error_widget.dart';
import 'package:chat_365/common/widgets/button/forward_message_done_button.dart';
import 'package:chat_365/common/widgets/dialogs/confirm_dialog.dart';
import 'package:chat_365/common/widgets/form/search_field.dart';
import 'package:chat_365/common/widgets/list_contact_view.dart';
import 'package:chat_365/core/constants/string_constants.dart';
import 'package:chat_365/main.dart';
import 'package:chat_365/modules/chat/model/api_message_model.dart';
import 'package:chat_365/modules/chat_conversations/models/conversation_basic_info.dart';
import 'package:chat_365/modules/contact/cubits/contact_list_cubit/contact_list_cubit.dart';
import 'package:chat_365/modules/contact/cubits/contact_list_cubit/contact_list_state.dart';
import 'package:chat_365/modules/contact/model/filter_contacts_by.dart';
import 'package:chat_365/modules/contact/repos/contact_list_repo.dart';
import 'package:chat_365/utils/data/extensions/context_extension.dart';
import 'package:chat_365/utils/data/extensions/string_extension.dart';
import 'package:chat_365/utils/helpers/system_utils.dart';
import 'package:chat_365/utils/ui/app_dialogs.dart';
import 'package:chat_365/utils/ui/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SendContactScreen extends StatelessWidget {
  const SendContactScreen({
    Key? key,
    required this.conversationBasicInfo,
  }) : super(key: key);

  static const conversationBasicInfoArg = 'conversationBasicInfo';

  final int conversationBasicInfo;

  @override
  Widget build(BuildContext context) {
    String? keyword;
    var userInfo = context.userInfo();
    Map<int, DialogState> _buttons = {};

    final ContactListCubit _contactListCubit = ContactListCubit(
      ContactListRepo(
        userInfo.id,
        companyId: userInfo.companyId!,
      ),
      initFilter: FilterContactsBy.allInCompany,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Gửi danh thiếp'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: SearchField(
              callBack: (value) {
                _contactListCubit.search(value);
                keyword = value;
              },
            ),
          ),
          Text(StringConst.recommend),
          Expanded(
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                BlocProvider.value(
                  value: _contactListCubit,
                  child: BlocConsumer<ContactListCubit, ContactListState>(
                    listener: (context, state) {
                      if (state is LoadFailedState) {
                        if (sendMessagePreSearchData.isNotEmpty)
                          _contactListCubit.emit(
                            LoadSuccessState(
                              _contactListCubit.filterContactsBy.value,
                              contactList: sendMessagePreSearchData,
                            ),
                          );
                        else
                          AppDialogs.toast(state.message);
                      }
                    },
                    builder: (context, state) {
                      if (state is LoadSuccessState) {
                        var friend = <ConversationBasicInfo>[];
                        var listFriends =
                            (context.read<FriendCubit>().listFriends ?? {})
                                .map((e) => ConversationBasicInfo(
                                      userId: e.id,
                                      isGroup: false,
                                      conversationId: -1,
                                      name: e.name,
                                      avatar: e.avatar,
                                      companyId: e.companyId,
                                      userStatus: e.userStatus,
                                    ));
                        if (keyword.isBlank)
                          friend.addAll(listFriends);
                        else
                          friend.addAll(SystemUtils.searchFunction(
                            keyword!,
                            listFriends,
                          ));
                        var list = [...friend, ...state.contactList];
                        return ListContactView(
                          userInfos: list,
                          itemBuilder: (_, index, child) {
                            var item = list[index];
                            return Row(
                              children: [
                                Expanded(
                                  child: child,
                                ),
                                SendButton(
                                  key: ValueKey(item.id),
                                  newMessage: ValueNotifier(null),
                                  apiMessageModel: ApiMessageModel(
                                    messageId: '',
                                    conversationId: conversationBasicInfo,
                                    senderId: userInfo.id,
                                    contact: item,
                                  ),
                                  dialogState:
                                      _buttons[item.id] ?? DialogState.init,
                                  onSendSuccess: () =>
                                      _buttons[item.id] = DialogState.success,
                                  onSending: () => _buttons[item.id] =
                                      DialogState.processing,
                                ),
                              ],
                            );
                          },
                        );
                      }
                      if (state is LoadFailedState)
                        return AppErrorWidget(error: state.message);
                      return WidgetUtils.centerLoadingCircle;
                    },
                  ),
                ),
                Container(
                  height: 60,
                  color: context.theme.backgroundColor,
                  alignment: Alignment.center,
                  child: Container(
                    height: 40,
                    alignment: Alignment.center,
                    child: ForwardMessageDoneButton(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
