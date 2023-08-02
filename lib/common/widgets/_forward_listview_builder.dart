import 'dart:async';

import 'package:chat_365/common/images.dart';
import 'package:chat_365/common/widgets/dialogs/confirm_dialog.dart';
import 'package:chat_365/common/widgets/list_contact_view.dart';
import 'package:chat_365/core/constants/string_constants.dart';
import 'package:chat_365/core/interfaces/interface_user_info.dart';
import 'package:chat_365/core/theme/app_colors.dart';
import 'package:chat_365/core/theme/app_text_style.dart';
import 'package:chat_365/data/services/generator_service.dart';
import 'package:chat_365/modules/chat/blocs/chat_bloc/chat_bloc.dart';
import 'package:chat_365/modules/chat/model/api_message_model.dart';
import 'package:chat_365/modules/chat/model/result_socket_chat.dart';
import 'package:chat_365/modules/chat/repo/chat_repo.dart';
import 'package:chat_365/modules/chat_conversations/bloc/chat_conversation_bloc.dart';
import 'package:chat_365/modules/chat_conversations/models/conversation_basic_info.dart';
import 'package:chat_365/utils/data/extensions/context_extension.dart';
import 'package:chat_365/utils/data/extensions/string_extension.dart';
import 'package:chat_365/utils/helpers/logger.dart';
import 'package:chat_365/utils/helpers/system_utils.dart';
import 'package:chat_365/utils/ui/app_dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SendMessageListConversationBuilder extends StatefulWidget {
  const SendMessageListConversationBuilder({
    Key? key,
    required this.sendIds,
    required this.list,
    required this.message,
    required this.apiMessageModelBuilder,
    this.newMessage,
    this.padding = const EdgeInsets.only(
      left: 20,
      right: 20,
      top: 20,
      bottom: 60,
    ),
  }) : super(key: key);

  final Map<int, DialogState> sendIds;
  final List<ConversationBasicInfo> list;
  final SocketSentMessageModel message;
  final ApiMessageModel Function(ConversationBasicInfo) apiMessageModelBuilder;
  final ValueNotifier<String>? newMessage;
  final EdgeInsets padding;

  @override
  State<SendMessageListConversationBuilder> createState() =>
      _SendMessageListConversationBuilderState();
}

class _SendMessageListConversationBuilderState
    extends State<SendMessageListConversationBuilder> {
  @override
  Widget build(BuildContext context) {
    return ListContactView(
      userBloc: true,
      userInfos: widget.list,
      padding: widget.padding,
      itemBuilder: (_, index, child) {
        var item = widget.list[index];
        final ApiMessageModel apiModel = widget.apiMessageModelBuilder(
          item,
        );
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: child,
                ),
                SendButton(
                  key: ValueKey(item.id),
                  apiMessageModel: apiModel,
                  newMessage: widget.newMessage ?? ValueNotifier(null),
                  infoLink: widget.message.infoLink,
                  dialogState: widget.sendIds[item.id] ?? DialogState.init,
                  senderInfo: item.id,
                  onSendSuccess: () =>
                      widget.sendIds[item.id] = DialogState.success,
                  onSending: () =>
                      widget.sendIds[item.id] = DialogState.processing,
                  // senderInfo: senderInfo,
                ),
              ],
            ),
            Container(
              height: 0.5,
              width: double.infinity,
              color: AppColors.greyCC,
              margin: EdgeInsets.only(left: 60, top: 10),
            ),
          ],
        );
      },
    );
  }
}

/// OnTap sẽ generate ra 1 [message] mới
///
/// và có thể thêm [message] đính kèm tin nhắn cần gửi thông qua [newMessage]
class SendButton extends StatefulWidget {
  const SendButton({
    Key? key,
    required this.newMessage,
    required this.apiMessageModel,
    this.infoLink,
    this.onSendSuccess,
    this.isSend = false,
    this.onSending,
    this.dialogState = DialogState.init,
    this.senderInfo,
  }) : super(key: key);

  final int? senderInfo;
  final InfoLink? infoLink;
  final ValueNotifier<String?> newMessage;
  final ApiMessageModel apiMessageModel;
  final VoidCallback? onSendSuccess;
  final VoidCallback? onSending;
  final bool isSend;
  final DialogState dialogState;

  @override
  State<SendButton> createState() => _SendButtonState();
}

class _SendButtonState extends State<SendButton>
    with AutomaticKeepAliveClientMixin {
  late final ChatBloc _chatBloc;
  late final ValueNotifier<List<String?>> allMessageTypeIdsNotifier;
  String? newMessageId;
  late final ValueNotifier<DialogState> _stateNotifier;
  late final StreamSubscription<ChatState> _subscription;
  var textColor;
  var gradientColor;
  late final IUserInfo _userInfo;
  late int conversationId;

  @override
  void initState() {
    conversationId = widget.apiMessageModel.conversationId;
    _userInfo = context.userInfo();
    _chatBloc = context.read<ChatBloc>();

    allMessageTypeIdsNotifier = ValueNotifier([newMessageId]);
    _stateNotifier = ValueNotifier(widget.dialogState);

    textColor = AppColors.white;
    gradientColor = context.theme.gradient;

    _subscription = _chatBloc.stream.listen((current) {
      if (current is ChatStateSendMessageSuccess &&
          allMessageTypeIds.contains(current.messageId)) {
        _stateNotifier.value = DialogState.success;
        widget.onSendSuccess?.call();
        _subscription.cancel();
      } else if (current is ChatStateSendMessageError &&
          allMessageTypeIds.contains(current.message.messageId)) {
        _stateNotifier.value = DialogState.init;
        AppDialogs.toast(current.error.error);
      }
    });

    super.initState();
  }

  List<String?> get allMessageTypeIds => allMessageTypeIdsNotifier.value;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  _onPressed() async {
    if (_stateNotifier.value != DialogState.init) {
      var chatItemModel =
          context.read<ChatConversationBloc>().chatsMap[conversationId];
      return _chatBloc.tryToChatScreen(
        chatInfo: chatItemModel,
        conversationId: conversationId,
      );
    }

    // if ((state is ChatStateSendMessageSuccess &&
    //         allMessageTypeIds.contains(state.messageId)) ||
    //     (state is ChatStateInProcessingMessage &&
    //         allMessageTypeIds.contains(state.message.messageId)) ||
    //     widget.isSend) return null;

    _stateNotifier.value = DialogState.processing;
    widget.onSending?.call();

    var currentUserId = context.userInfo().id;

    newMessageId = GeneratorService.generateMessageId(
      currentUserId,
    );

    var newMessageTick = newMessageId!.tickFromMessageId;

    allMessageTypeIdsNotifier.value = {
      ...allMessageTypeIds,
      ...List.generate(
        5,
        (index) => GeneratorService.generateMessageId(
          currentUserId,
          newMessageTick + index,
        ),
      ),
    }.toList();

    logger.log(allMessageTypeIds, name: 'AllMessageTypeIds');

    IUserInfo? fullInfoContact;

    if (widget.apiMessageModel.contact != null) {
      fullInfoContact =
          await chatRepo.getUserInfo(widget.apiMessageModel.contact!.id);
    }

    if (conversationId == -1) {
      try {
        conversationId = await context.read<ChatBloc>().getConversationId(
              currentUserId,
              widget.senderInfo!,
            );
      } catch (e, s) {
        logger.logError(e, s);
        _stateNotifier.value = DialogState.init;
        AppDialogs.toast('Gửi tin nhắn thất bại');
        return;
      }
    }

    var newMessageModel = widget.apiMessageModel.copyWith(
      messageId: newMessageId!,
      message: widget.newMessage.value,
      contact: fullInfoContact,
    );

    var listMessage = SystemUtils.getListApiMessageModels(
      senderInfo: _userInfo,
      conversationId: conversationId,
      contact: newMessageModel.contact,
      files: [],
      uploadedFiles: newMessageModel.files ?? [],
      messageId: newMessageId,
      replyModel: newMessageModel.relyMessage,
      text: widget.newMessage.value,
      infoLink: widget.infoLink,
      infoLinkMessageType: widget.apiMessageModel.type,
    );

    for (var message in listMessage)
      _chatBloc.sendMessage(message, memberIds: []);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return AnimatedBuilder(
      animation: Listenable.merge([allMessageTypeIdsNotifier, _stateNotifier]),
      builder: (context, state) {
        bool isSuccess = false;
        var text = StringConst.send;
        if (_stateNotifier.value == DialogState.init) {
        } else if (_stateNotifier.value == DialogState.processing) {
          text = 'Đang gửi';
        } else {
          isSuccess = true;
          text = 'Đã gửi';
          textColor = context.theme.primaryColor;
          widget.onSendSuccess?.call();
        }
        return InkWell(
          onTap: _onPressed,
          borderRadius: BorderRadius.circular(100),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: isSuccess ? 16 : 24,
              vertical: 7,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              gradient: isSuccess ? null : gradientColor,
              border: isSuccess
                  ? _GradientBorder(
                      gradient: gradientColor,
                      r: 100,
                    )
                  : null,
            ),
            child: Row(
              children: [
                if (isSuccess)
                  Padding(
                    padding: const EdgeInsets.only(right: 6.0),
                    child: ShaderMask(
                      child: SvgPicture.asset(
                        Images.ic_check,
                        height: 20,
                        width: 20,
                      ),
                      shaderCallback: (Rect bounds) =>
                          gradientColor.createShader(bounds),
                    ),
                  ),
                Text(
                  text,
                  style: AppTextStyles.regularW500(
                    context,
                    size: 14,
                    lineHeight: 16,
                    color: textColor,
                  ).copyWith(
                    foreground: isSuccess
                        ? (Paint()
                          ..shader = gradientColor.createShader(Rect.largest))
                        : null,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class _GradientBorder extends BoxBorder {
  final double r;
  final Gradient gradient;

  _GradientBorder({
    required this.gradient,
    required this.r,
  });

  @override
  BorderSide get bottom => BorderSide.none;

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.zero;

  @override
  bool get isUniform => true;

  @override
  void paint(
    Canvas canvas,
    Rect rect, {
    TextDirection? textDirection,
    BoxShape shape = BoxShape.rectangle,
    BorderRadius? borderRadius,
  }) {
    var paint = Paint()
      ..strokeWidth = 1.0
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.stroke;
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, Radius.circular(r)),
      paint,
    );
  }

  @override
  ShapeBorder scale(double t) => RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(r),
      );

  @override
  BorderSide get top => BorderSide.none;
}
