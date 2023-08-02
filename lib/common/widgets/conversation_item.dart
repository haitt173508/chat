import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_365/common/blocs/theme_cubit/theme_cubit.dart';
import 'package:chat_365/common/blocs/typing_detector_bloc/typing_detector_bloc.dart';
import 'package:chat_365/common/blocs/unread_message_counter_cubit/unread_message_counter_cubit.dart';
import 'package:chat_365/common/blocs/user_info_bloc/bloc/user_info_bloc.dart';
import 'package:chat_365/common/blocs/user_info_bloc/bloc/user_info_state.dart';
import 'package:chat_365/common/components/display/time_badge.dart';
import 'package:chat_365/common/components/display_image_with_status_badge.dart';
import 'package:chat_365/common/images.dart';
import 'package:chat_365/common/notification_message_display.dart';
import 'package:chat_365/common/widgets/ellipsized_text.dart';
import 'package:chat_365/common/widgets/typing_detector.dart';
import 'package:chat_365/core/constants/string_constants.dart';
import 'package:chat_365/core/interfaces/interface_user_info.dart';
import 'package:chat_365/core/theme/app_colors.dart';
import 'package:chat_365/core/theme/app_text_style.dart';
import 'package:chat_365/modules/chat/blocs/chat_bloc/chat_bloc.dart';
import 'package:chat_365/modules/chat/model/chat_member_model.dart';
import 'package:chat_365/modules/chat_conversations/bloc/chat_conversation_bloc.dart';
import 'package:chat_365/modules/chat_conversations/models/conversation_basic_info.dart';
import 'package:chat_365/modules/chat_conversations/models/result_chat_conversation.dart';
import 'package:chat_365/router/app_router_helper.dart';
import 'package:chat_365/utils/data/enums/choice_dialog_type.dart';
import 'package:chat_365/utils/data/enums/message_type.dart';
import 'package:chat_365/utils/data/enums/themes.dart';
import 'package:chat_365/utils/data/enums/user_status.dart';
import 'package:chat_365/utils/data/extensions/context_extension.dart';
import 'package:chat_365/utils/data/extensions/date_time_extension.dart';
import 'package:chat_365/utils/helpers/logger.dart';
import 'package:chat_365/utils/ui/app_dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConversationItem extends StatefulWidget {
  const ConversationItem({
    Key? key,
    this.isFavorited = false,
    required this.isGroup,
    required this.conversationBasicInfo,
    required this.message,
    required this.createdAt,
    required this.userInfoBloc,
    required this.unreadMessageCubit,
    required this.messageType,
    this.padding,
    this.users = const [],
    // this.lastSenderId,
    this.messageDisplay,
    this.chatItemModel,
    this.totalMessage,
    this.lastMessageId,
  }) : super(key: key);

  final UserInfoBloc userInfoBloc;
  final UnreadMessageCounterCubit unreadMessageCubit;
  final ConversationBasicInfo conversationBasicInfo;
  final String message;
  final String? lastMessageId;
  final bool isGroup;
  final DateTime createdAt;
  final EdgeInsetsGeometry? padding;
  final bool isFavorited;
  final List<IUserInfo> users;
  // final int? lastSenderId;
  final MessageType? messageType;
  final int? messageDisplay;
  final ChatItemModel? chatItemModel;
  final ValueNotifier<int>? totalMessage;

  @override
  State<ConversationItem> createState() => _ConversationItemState();
}

class _ConversationItemState extends State<ConversationItem> {
  late UserInfoBloc _userInfoBloc;
  var senderAvatar = '';
  late final int conversationId;
  late final ValueNotifier<String> displayMsg;
  late final ValueNotifier<MessageType?> messageTypeNotifier;
  late Widget _msgWidget;
  late Widget _displayMsgText;
  late Widget _unreadMessageIndicator;
  late final ValueNotifier<int?> _lastSenderId;
  late final ChatConversationBloc _chatConversationBloc;
  late final ValueNotifier<List<IUserInfo>> _usersNotifier;
  late final ChatBloc _chatBloc;
  late final int _currentUserId;
  late final TypingDetectorBloc _typingDetectorBloc;
  late UnreadMessageCounterCubit _unreadMessageCounterCubit;
  late final MyTheme _theme;
  String? _lastMessageId;

  List<IUserInfo> get users => _usersNotifier.value;

  String _getSenderAvatar(int senderId) {
    try {
      final IUserInfo user = users.firstWhere((e) => e.id == senderId);
      widget.chatItemModel?.senderId = user.id;
      return user.avatar;
    } catch (e) {
      logger.logError(
        'Không tìm thấy userId = $senderId trong groupId = $conversationId',
      );
    }
    return '';
  }

  @override
  void initState() {
    _lastMessageId = widget.lastMessageId;
    _theme = context.theme;
    _chatConversationBloc = context.read<ChatConversationBloc>();
    conversationId = widget.conversationBasicInfo.conversationId;
    _unreadMessageCounterCubit = widget.unreadMessageCubit;
    _typingDetectorBloc = _chatConversationBloc.typingBlocs[conversationId] ??
        TypingDetectorBloc(conversationId);
    _currentUserId = context.userInfo().id;
    _chatBloc = context.read<ChatBloc>();
    _usersNotifier = ValueNotifier([...widget.users]);

    _userInfoBloc = widget.userInfoBloc;

    displayMsg = ValueNotifier(widget.message);
    messageTypeNotifier = ValueNotifier(widget.messageType);
    _lastSenderId =
        ValueNotifier(widget.conversationBasicInfo.groupLastSenderId)
          ..addListener(() {
            if (_lastSenderId.value != null)
              _getSenderAvatar(_lastSenderId.value!);
          });

    if (widget.isGroup &&
        widget.conversationBasicInfo.groupLastSenderId != null)
      senderAvatar =
          _getSenderAvatar(widget.conversationBasicInfo.groupLastSenderId!);

    _setup();

    super.initState();
  }

  @override
  void didUpdateWidget(covariant ConversationItem oldWidget) {
    _userInfoBloc.close();
    _userInfoBloc = widget.userInfoBloc;
    _lastSenderId.value = widget.conversationBasicInfo.groupLastSenderId;
    _lastMessageId = widget.lastMessageId;
    displayMsg.value = widget.message;
    if (messageTypeNotifier.value != widget.messageType)
      messageTypeNotifier.value = widget.messageType;
    _setup();
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _userInfoBloc.close();
    widget.totalMessage?.dispose();
    // _unreadMessageCounterCubit.close();
    // widget.userInfoBloc.close();
    super.dispose();
  }

  _setup() {
    _unreadMessageCounterCubit = widget.unreadMessageCubit;
    _unreadMessageIndicator = BlocProvider.value(
      value: _unreadMessageCounterCubit,
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          var color = state.theme.primaryColor;
          return BlocBuilder(
            bloc: _unreadMessageCounterCubit,
            builder: (_, __) {
              final bool isLargeNumber =
                  _unreadMessageCounterCubit.countUnreadMessage > 9;
              return Visibility(
                visible: _unreadMessageCounterCubit.hasUnreadMessage,
                child: Container(
                  margin: const EdgeInsets.only(top: 4),
                  width: isLargeNumber ? null : 18,
                  height: 18,
                  padding: isLargeNumber
                      ? const EdgeInsets.symmetric(horizontal: 6)
                      : null,
                  alignment: Alignment.center,
                  decoration: isLargeNumber
                      ? BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.all(Radius.circular(18)),
                        )
                      : BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                        ),
                  child: Text(
                    _unreadMessageCounterCubit.countUnreadMessage.toString(),
                    style: AppTextStyles.regularW700(
                      context,
                      size: 10,
                      lineHeight: 11.4,
                      color: AppColors.white,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );

    if (widget.conversationBasicInfo.groupLastSenderId == _currentUserId) {
      Future.delayed(const Duration(milliseconds: 100), () {
        if (_unreadMessageCounterCubit.hasUnreadMessage)
          _chatBloc.markReadMessages(
            conversationId: conversationId,
            memebers: _usersNotifier.value.map((e) => e.id).toList(),
            senderId: _currentUserId,
          );
      });
    }

    _displayMsgText = BlocProvider.value(
      value: _unreadMessageCounterCubit,
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, themeState) {
          var messageTextStyle = themeState.theme.messageTextStyle;
          return BlocBuilder<UnreadMessageCounterCubit,
              UnreadMessageCounterState>(
            builder: (context, state) {
              final bool hasUnreadMessage =
                  _unreadMessageCounterCubit.hasUnreadMessage;
              final TextStyle textStyle = messageTextStyle.copyWith(
                fontWeight: hasUnreadMessage ? FontWeight.w700 : null,
                color: hasUnreadMessage || _theme.isDarkTheme
                    ? null
                    : AppColors.gray7777777,
              );
              return AnimatedBuilder(
                  key: Key(
                      widget.conversationBasicInfo.conversationId.toString()),
                  animation: Listenable.merge(
                      [displayMsg, messageTypeNotifier, _usersNotifier]),
                  builder: (context, child) {
                    if (messageTypeNotifier.value?.isNotification == true) {
                      return NotificationMessageDisplay(
                        message: displayMsg.value,
                        conversationId: conversationId,
                        textBuilder: (_, text) {
                          // logger.log(text, name: 'Notification text: ');
                          return EllipsizedText(
                            text,
                            style: textStyle,
                          );
                        },
                        listUserInfos: Map.fromIterable(
                          users,
                          key: (key) => (key as IUserInfo).id,
                          value: (value) => UserInfoBloc(
                            (value as IUserInfo),
                          ),
                        ),
                        onGetUnknownUserIdsFound: (blocs) {
                          WidgetsBinding.instance?.addPostFrameCallback((_) =>
                              _usersNotifier.value = [
                                ...users,
                                ...blocs.map((e) => e.userInfo)
                              ]);
                          blocs.forEach((bloc) {
                            // var index = _chatConversationBloc.chats.indexWhere(
                            //   (e) => e.conversationId == conversationId,
                            // );

                            if (widget.chatItemModel != null) {
                              StreamSubscription? stream;
                              stream = bloc.stream.listen((state) {
                                var members = widget.chatItemModel!.memberList;
                                var info = state.userInfo;
                                if (!members.map((e) => e.id).contains(info.id))
                                  stream?.cancel();
                                else if (!RegExp(r'Người dùng \d+')
                                    .hasMatch(info.name)) {
                                  widget.chatItemModel!.memberList = [
                                    ChatMemberModel(
                                      id: info.id,
                                      name: info.name,
                                      avatar: info.avatar ?? '',
                                      unReader: widget.totalMessage?.value ?? 0,
                                    ),
                                    ...members,
                                  ];
                                  stream?.cancel();
                                }
                              });
                            }
                          });
                        },
                      );
                    }

                    // final isSendByCurrentUser =
                    //     _lastSenderId.value == context.userInfo().id;

                    return EllipsizedText(
                      // (isSendByCurrentUser ? 'Bạn: ' : '') +
                      displayMsg.value,
                      style: textStyle,
                      maxLines: 1,
                      // overflow: TextOverflow.ellipsis,
                      // softWrap: false,
                    );
                  });
            },
          );
        },
      ),
    );

    _msgWidget = BlocBuilder<TypingDetectorBloc, TypingDetectorState>(
      bloc: _typingDetectorBloc,
      builder: (context, typingState) {
        if (typingState.typingUserIds.isNotEmpty) {
          return TypingDetector(
            conversationId: widget.conversationBasicInfo.conversationId,
          );
        }
        return _displayMsgText;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    var time = Text(
      widget.createdAt.diffWith(
        showSpecialTime: true,
        showYesterdayImediately: true,
      ),
      style: theme.textTheme.bodyText1!,
    );

    var displayImage = BlocBuilder<UserInfoBloc, UserInfoState>(
      bloc: _userInfoBloc,
      builder: (context, state) {
        return DisplayImageWithStatusBadge(
          isGroup: widget.isGroup,
          model: widget.conversationBasicInfo,
          userStatus: widget.conversationBasicInfo.userStatus,
          enable: false,
          size: 50,
          badgeSize: 15,
          badge: widget.isGroup
              ? BlocBuilder<ChatBloc, ChatState>(
                  buildWhen: (_, current) =>
                      current is ChatStateRecieveMessage &&
                      current.msg.conversationId ==
                          widget.conversationBasicInfo.conversationId,
                  builder: (_, chatState) {
                    if (chatState is ChatStateRecieveMessage &&
                        chatState.msg.conversationId ==
                            widget.conversationBasicInfo.conversationId) {
                      senderAvatar = _getSenderAvatar(chatState.msg.senderId);
                    }

                    // logger.log(
                    //   '${conversationBasicInfo.name} - ${conversationBasicInfo.groupLastSenderId} - $senderAvatar',
                    //   name: conversationBasicInfo.name,
                    //   color: StrColor.red,
                    // );

                    return CircleAvatar(
                      radius: (22 + 1.5) / 2,
                      backgroundColor: AppColors.white,
                      child: CircleAvatar(
                        radius: 22 / 2,
                        backgroundColor: Colors.transparent,
                        backgroundImage: AssetImage(Images.img_non_avatar),
                        foregroundImage: CachedNetworkImageProvider(
                          senderAvatar,
                        ),
                      ),
                    );
                  },
                )
              : TimeBadge(
                  lastOnlineTime: state.userInfo.lastActive,
                  onlineWidget:
                      state.userInfo.userStatus.getStatusBadge(context),
                ),
        );
      },
    );

    var nameWidget = BlocBuilder<UserInfoBloc, UserInfoState>(
      bloc: _userInfoBloc,
      builder: (context, userState) {
        return BlocBuilder(
            bloc: _unreadMessageCounterCubit,
            builder: (context, state) {
              bool hasUnreadMessage =
                  _unreadMessageCounterCubit.hasUnreadMessage;
              return Text(
                userState.userInfo.name,
                // conversationId.toString(),
                style: TextStyle(
                  fontWeight:
                      hasUnreadMessage ? FontWeight.w700 : FontWeight.w400,
                  fontSize: _theme.messageTextSize + 2,
                  height: 22 / 16.75,
                  color: _theme.isDarkTheme ? AppColors.white : AppColors.black,
                ),
                maxLines: 1,
              );
            });
      },
    );

    return MultiBlocProvider(
      providers: [
        BlocProvider.value(
          value: _userInfoBloc,
        ),
        BlocProvider.value(
          value: _typingDetectorBloc,
        ),
      ],
      child: InkWell(
        onTap: () => AppRouterHelper.toChatPage(
          context,
          userInfoBloc: _userInfoBloc,
          isGroup: widget.isGroup,
          senderId: context.userInfo().id,
          conversationId: widget.conversationBasicInfo.conversationId,
          unreadMessageCounterCubit: _unreadMessageCounterCubit,
          typingDetectorBloc: _typingDetectorBloc,
          messageDisplay: widget.messageDisplay,
          chatItemModel: widget.chatItemModel,
        ),
        onLongPress: () {
          AppDialogs.showChoicesDialog(
            context,
            title: widget.conversationBasicInfo.name,
            choices: [
              if (!widget.isFavorited)
                ChoiceDialogTypes.addConversationToFavorite(
                  context,
                  conversationId: widget.conversationBasicInfo.conversationId,
                  chatConversationBloc: _chatConversationBloc,
                )
              else
                ChoiceDialogTypes.removeConversationToFavorite(
                  context,
                  conversationId: conversationId,
                  chatConversationBloc: _chatConversationBloc,
                ),
              if (_unreadMessageCounterCubit.hasUnreadMessage)
                ChoiceDialogTypes.markReadAllMessage(
                  context,
                  conversationId: conversationId,
                  members: _chatConversationBloc.chats
                      .singleWhere((e) => e.conversationId == conversationId)
                      .memberList
                      .map((e) => e.id)
                      .toList(),
                ),
              ChoiceDialogTypes.deleteConversation(
                context,
                conversationId: widget.conversationBasicInfo.conversationId,
                chatConversationBloc: _chatConversationBloc,
              ),
            ],
          );
        },
        child: BlocListener<ChatBloc, ChatState>(
          listenWhen: (_, current) =>
              _lastMessageId != null &&
              current is ChatMessageState &&
              current.messageId == _lastMessageId,
          listener: (context, state) {
            if (state is ChatStateEditMessageSuccess)
              displayMsg.value = state.newMessage;
            else if (state is ChatStateDeleteMessageSuccess) {
              if (state.messageBelow != null) {
                var newMessage = state.messageBelow;
                displayMsg.value = (newMessage!.type)?.displayMessageType(
                      newMessage.message,
                      isSentByCurrentUser:
                          newMessage.messageId == _currentUserId,
                    ) ??
                    StringConst.canNotDisplayMessage;
                _lastMessageId = newMessage.messageId;
                _lastSenderId.value = newMessage.senderId;
              } else {
                // var deleterId = int.tryParse(state.messageId.split('_').last);
                // var deleter;
                _lastSenderId.value = null;
                // if (deleterId != null)
                //   try {
                //     deleter = users.firstWhere((e) => e.id == deleterId);
                //   } catch (e) {}
                // if (deleter != null)
                //   displayMsg.value = '${deleter.name} đã xóa 1 tin nhắn';
                // else
                displayMsg.value = 'Tin nhắn đã bị xóa';
                _lastMessageId = null;
                widget.chatItemModel?.lastMessages
                    ?.removeWhere((e) => e.messageId == state.messageId);
                _chatConversationBloc
                    .chatsMap[state.conversationId]?.lastMessages
                    ?.removeWhere((e) => e.messageId == state.messageId);
              }
            }
          },
          child: Column(
            children: [
              Padding(
                padding: widget.padding ??
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    displayImage,
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            nameWidget,
                            const SizedBox(height: 4),
                            _msgWidget,
                          ],
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        time,
                        _unreadMessageIndicator,
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 50 + 15, right: 15),
                height: 0.5,
                width: double.infinity,
                color: AppColors.greyCC,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
