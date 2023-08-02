import 'package:chat_365/common/widgets/_forward_listview_builder.dart';
import 'package:chat_365/common/widgets/button/forward_message_done_button.dart';
import 'package:chat_365/common/widgets/dialogs/confirm_dialog.dart';
import 'package:chat_365/common/widgets/list_contact_view.dart';
import 'package:chat_365/common/widgets/send_message_search_appbar.dart';
import 'package:chat_365/core/interfaces/interface_user_info.dart';
import 'package:chat_365/modules/chat/model/api_message_model.dart';
import 'package:chat_365/modules/chat/model/result_socket_chat.dart';
import 'package:chat_365/modules/chat_conversations/models/conversation_basic_info.dart';
import 'package:chat_365/modules/contact/cubits/contact_list_cubit/contact_list_cubit.dart';
import 'package:chat_365/modules/contact/cubits/contact_list_cubit/contact_list_state.dart';
import 'package:chat_365/modules/contact/model/filter_contacts_by.dart';
import 'package:chat_365/modules/contact/repos/contact_list_repo.dart';
import 'package:chat_365/modules/debouncer/text_editing_controller_debouncer.dart';
import 'package:chat_365/utils/data/enums/message_type.dart';
import 'package:chat_365/utils/data/extensions/context_extension.dart';
import 'package:chat_365/utils/ui/app_dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForwardSearchScreen extends StatefulWidget {
  const ForwardSearchScreen({
    Key? key,
    required this.message,
    required this.senderInfo,
    required this.newMessage,
    required this.buttons,
  }) : super(key: key);

  final SocketSentMessageModel message;
  final IUserInfo senderInfo;
  final ValueNotifier<String?> newMessage;
  final Map<int, DialogState> buttons;

  @override
  State<ForwardSearchScreen> createState() => _ForwardSearchScreenState();
}

class _ForwardSearchScreenState extends State<ForwardSearchScreen> {
  final TextEditingController _controller = TextEditingController();
  late final IUserInfo _currentUser;
  late final ContactListCubit _contactListCubit;
  late final TextEditingControllerDebouncer _debouncer;
  late final ValueNotifier<DialogState> _stateNotifier;
  List<ConversationBasicInfo> _contactLists = [];

  @override
  void initState() {
    super.initState();
    _currentUser = context.userInfo();
    _contactListCubit = ContactListCubit(
      ContactListRepo(
        _currentUser.id,
        companyId: _currentUser.companyId!,
      ),
      initFilter: FilterContactsBy.conversations,
    );
    _debouncer = TextEditingControllerDebouncer(
      () => _contactListCubit.search(_controller.text),
      controller: _controller,
    );
    _stateNotifier = ValueNotifier(
        _mapContactListStateToDialogState(_contactListCubit.state));
    _contactListCubit.stream.listen(_listener);
  }

  @override
  void dispose() {
    _debouncer.dispose();
    super.dispose();
  }

  DialogState _mapContactListStateToDialogState(ContactListState state) {
    if (state is LoadingState)
      return DialogState.processing;
    else if (state is LoadSuccessState || state is LoadFailedState)
      return DialogState.success;
    return DialogState.init;
  }

  _listener(ContactListState state) =>
      _stateNotifier.value = _mapContactListStateToDialogState(state);

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _contactListCubit,
      child: Scaffold(
        appBar: SendMessageSearchAppBar(
          controller: _controller,
          stateNotifier: _stateNotifier,
        ),
        body: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            BlocConsumer<ContactListCubit, ContactListState>(
              listener: (context, state) {
                if (state is LoadFailedState) AppDialogs.toast(state.message);
              },
              buildWhen: (previous, current) => current is LoadSuccessState,
              builder: (context, state) {
                // if (state is LoadFailedState)
                //   return AppErrorWidget(
                //     error: state.message,
                //     onTap: _contactListCubit.loadContact,
                //   );
                if (state is LoadSuccessState) {
                  _contactLists = state.contactList;
                }

                return ListContactView(
                  loadMore: () => _contactListCubit.search(
                    _controller.text,
                    isLoadMore: true,
                  ),
                  itemBuilder: (_, index, child) {
                    var item = _contactLists[index];
                    var apiModel = ApiMessageModel(
                      senderId: context.userInfo().id,
                      conversationId: item.conversationId,
                      messageId: widget.message.messageId,
                      files: widget.message.files,
                      contact: widget.message.contact,
                      relyMessage: widget.message.type?.isText == true
                          ? ApiRelyMessageModel(
                              messageId: widget.message.messageId,
                              senderId: widget.senderInfo.id,
                              senderName: widget.senderInfo.name,
                              message: widget.message.message,
                              createAt: widget.message.createAt,
                            )
                          : null,
                      message: widget.newMessage.value,
                      type: widget.message.type ?? MessageType.text,
                    );
                    return Row(
                      children: [
                        Expanded(
                          child: child,
                        ),
                        SendButton(
                          key: ValueKey(item.id),
                          apiMessageModel: apiModel,
                          newMessage: widget.newMessage,
                          infoLink: widget.message.infoLink,
                          senderInfo: item.id,
                          dialogState:
                              widget.buttons[item.id] ?? DialogState.init,
                          onSendSuccess: () =>
                              widget.buttons[item.id] = DialogState.success,
                          onSending: () =>
                              widget.buttons[item.id] = DialogState.processing,
                          // senderInfo: widget.senderInfo,
                        ),
                      ],
                    );
                  },
                  userInfos: _contactLists,
                );
                // }
                // return WidgetUtils.centerLoadingCircle;
              },
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
    );
  }
}
