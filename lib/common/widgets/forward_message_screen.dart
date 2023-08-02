import 'package:chat_365/common/blocs/user_info_bloc/bloc/user_info_bloc.dart';
import 'package:chat_365/common/images.dart';
import 'package:chat_365/common/widgets/_forward_listview_builder.dart';
import 'package:chat_365/common/widgets/button/forward_message_done_button.dart';
import 'package:chat_365/common/widgets/dialogs/confirm_dialog.dart';
import 'package:chat_365/common/widgets/ellipsized_text.dart';
import 'package:chat_365/common/widgets/forward_search_screen.dart';
import 'package:chat_365/common/widgets/navigator_search_field.dart';
import 'package:chat_365/core/interfaces/interface_user_info.dart';
import 'package:chat_365/core/theme/app_colors.dart';
import 'package:chat_365/modules/chat/model/api_message_model.dart';
import 'package:chat_365/modules/chat/model/result_socket_chat.dart';
import 'package:chat_365/modules/chat/widgets/chat_input_field.dart';
import 'package:chat_365/modules/chat/widgets/message_box.dart';
import 'package:chat_365/modules/chat_conversations/bloc/chat_conversation_bloc.dart';
import 'package:chat_365/utils/data/enums/message_type.dart';
import 'package:chat_365/utils/data/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ForwardMessageScreen extends StatefulWidget {
  const ForwardMessageScreen({
    Key? key,
    required this.message,
    required this.senderInfo,
  }) : super(key: key);

  static const String messageArg = 'messageArg';
  static const String senderInfoArg = 'senderInfoArg';

  final SocketSentMessageModel message;

  /// Thông tin của chủ tin nhắn đang forward
  final IUserInfo senderInfo;

  @override
  State<ForwardMessageScreen> createState() => _ForwardMessageScreenState();
}

class _ForwardMessageScreenState extends State<ForwardMessageScreen> {
  late final ChatConversationBloc _chatConversationBloc;
  final ValueNotifier<String> _newMessage = ValueNotifier('');
  late final IUserInfo _currentUser;
  Map<int, DialogState> _buttons = {};
  var _list;
  late SocketSentMessageModel _originMessage;
  late final IUserInfo _senderInfo;

  @override
  void initState() {
    _currentUser = context.userInfo();
    _chatConversationBloc = context.read<ChatConversationBloc>();
    _list = _chatConversationBloc.chats
        .map(
          (e) => e.conversationBasicInfo,
        )
        .toList();
    _originMessage = widget.message;
    _senderInfo = widget.senderInfo;
    if (widget.message.type == MessageType.document) {
      _newMessage.value = widget.message.message!;
      _originMessage = _originMessage.copyWith(
        infoLink: InfoLink(
          link: _originMessage.linkNotification,
          haveImage: false,
        ),
      );
    }
    // _contactListCubit = ContactListCubit(
    //   ContactListRepo(
    //     currentUser.id,
    //     companyId: currentUser.companyId!,
    //   ),
    //   initFilter: FilterContactsBy.conversations,
    // );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_originMessage.type?.isSpecialType == true) _newMessage.value = _originMessage.message ?? '';
    var listUserInfoBlocs = <int, UserInfoBloc>{};
    var quoteIcon = SvgPicture.asset(
      Images.ic_quote,
      color: context.theme.textColor,
      height: 16,
      width: 18,
    );
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: Text('Chuyển tiếp tin nhắn'),
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              vertical: 20,
            ),
            color: context.theme.backgroundColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: context.theme.messageBoxColor,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    children: [
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: context.mediaQuerySize.height / 6,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            quoteIcon,
                            const SizedBox(width: 5),
                            Expanded(
                              child: _originMessage.type?.isText == true
                                  ? EllipsizedText(
                                      _originMessage.hasRelyMessage ? _originMessage.relyMessage!.message! : _originMessage.message ?? '',
                                      maxLines: 3,
                                      style: context.theme.messageTextStyle,
                                    )
                                  : AbsorbPointer(
                                      absorbing: true,
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: MessageBox(
                                          hasReplyMessage: false,
                                          messageModel: _originMessage,
                                          isSentByCurrentUser: false,
                                          borderRadius: BorderRadius.circular(15),
                                          listUserInfoBlocs: listUserInfoBlocs,
                                        ),
                                      ),
                                    ),
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        color: AppColors.dustyGray,
                        height: 20,
                      ),
                      if (_originMessage.type?.isText == true)
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            maxHeight: 75,
                          ),
                          child: ChatInputField(
                            onChanged: (value) => _newMessage.value = value,
                          ),
                        ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 15,
                  ),
                  child: NavigatorSearchField(
                    onNavigate: () => Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => ForwardSearchScreen(
                          buttons: _buttons,
                          message: _originMessage,
                          newMessage: _newMessage,
                          senderInfo: _senderInfo,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: SendMessageListConversationBuilder(
                    list: _list,
                    apiMessageModelBuilder: (item) {
                      return ApiMessageModel(
                        senderId: _currentUser.id,
                        conversationId: item.conversationId,
                        messageId: _originMessage.messageId,
                        files: _originMessage.files,
                        contact: _originMessage.contact,
                        relyMessage: _originMessage.hasRelyMessage
                            ? _originMessage.relyMessage
                            : _originMessage.type?.isText == true
                                ? ApiRelyMessageModel(
                                    messageId: _originMessage.messageId,
                                    senderId: _senderInfo.id,
                                    senderName: _senderInfo.name,
                                    message: _originMessage.message,
                                    createAt: _originMessage.createAt,
                                  )
                                : null,
                        message: _newMessage.value,
                        type: _originMessage.type ?? MessageType.text,
                      );
                    },
                    sendIds: _buttons,
                    message: _originMessage,
                    newMessage: _newMessage,
                  ),
                ),
              ],
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
    );
  }
}
