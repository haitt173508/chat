import 'dart:async';

import 'package:chat_365/common/blocs/friend_cubit/cubit/friend_cubit.dart';
import 'package:chat_365/common/blocs/network_cubit/network_cubit.dart';
import 'package:chat_365/common/blocs/reaction_cubit/reaction_cubit.dart';
import 'package:chat_365/common/blocs/typing_detector_bloc/typing_detector_bloc.dart';
import 'package:chat_365/common/blocs/unread_message_counter_cubit/unread_message_counter_cubit.dart';
import 'package:chat_365/common/blocs/user_info_bloc/bloc/user_info_bloc.dart';
import 'package:chat_365/common/blocs/user_info_bloc/bloc/user_info_state.dart';
import 'package:chat_365/common/blocs/user_info_bloc/repo/user_info_repo.dart';
import 'package:chat_365/common/components/choice_dialog_item.dart';
import 'package:chat_365/common/components/display/display_avatar.dart';
import 'package:chat_365/common/images.dart';
import 'package:chat_365/common/models/auto_delete_message_time_model.dart';
import 'package:chat_365/common/notification_message_display.dart';
import 'package:chat_365/common/widgets/app_error_widget.dart';
import 'package:chat_365/common/widgets/painter/percent_indicator.dart';
import 'package:chat_365/common/widgets/user_list_tile.dart';
import 'package:chat_365/common/widgets/user_list_tile_appbar.dart';
import 'package:chat_365/core/constants/app_constants.dart';
import 'package:chat_365/core/constants/string_constants.dart';
import 'package:chat_365/core/interfaces/interface_user_info.dart';
import 'package:chat_365/core/theme/app_colors.dart';
import 'package:chat_365/core/theme/app_text_style.dart';
import 'package:chat_365/data/services/generator_service.dart';
import 'package:chat_365/main.dart';
import 'package:chat_365/modules/auth/repo/auth_repo.dart';
import 'package:chat_365/modules/call/phone_call/screens/main_phonecall_screen.dart';
import 'package:chat_365/modules/chat/blocs/chat_bloc/chat_bloc.dart';
import 'package:chat_365/modules/chat/blocs/chat_detail_bloc/chat_detail_bloc.dart';
import 'package:chat_365/modules/chat/model/api_message_model.dart';
import 'package:chat_365/modules/chat/model/result_socket_chat.dart';
import 'package:chat_365/modules/chat/repo/chat_repo.dart';
import 'package:chat_365/modules/chat/screens/custom_menu.dart';
import 'package:chat_365/modules/chat/widgets/_chat_screen_input_bar.dart';
import 'package:chat_365/modules/chat/widgets/chat_input_bar.dart';
import 'package:chat_365/modules/chat/widgets/emoji_bar.dart';
import 'package:chat_365/modules/chat/widgets/message_box.dart';
import 'package:chat_365/modules/chat/widgets/text_divider.dart';
import 'package:chat_365/modules/chat_conversations/bloc/chat_conversation_bloc.dart';
import 'package:chat_365/modules/chat_conversations/models/conversation_basic_info.dart';
import 'package:chat_365/modules/chat_conversations/models/draft_model.dart';
import 'package:chat_365/modules/chat_conversations/models/result_chat_conversation.dart';
import 'package:chat_365/modules/home_qr_code/model/detail_company_model.dart';
import 'package:chat_365/modules/profile/repos/group_profile_repo.dart';
import 'package:chat_365/router/app_pages.dart';
import 'package:chat_365/router/app_route_observer.dart';
import 'package:chat_365/router/app_router.dart';
import 'package:chat_365/router/app_router_helper.dart';
import 'package:chat_365/utils/data/enums/chat_feature_action.dart';
import 'package:chat_365/utils/data/enums/choice_dialog_type.dart';
import 'package:chat_365/utils/data/enums/emoji.dart';
import 'package:chat_365/utils/data/enums/friend_status.dart';
import 'package:chat_365/utils/data/enums/message_status.dart';
import 'package:chat_365/utils/data/enums/message_type.dart';
import 'package:chat_365/utils/data/enums/process_message_type.dart';
import 'package:chat_365/utils/data/enums/user_type.dart';
import 'package:chat_365/utils/data/extensions/context_extension.dart';
import 'package:chat_365/utils/data/extensions/date_time_extension.dart';
import 'package:chat_365/utils/data/extensions/list_extension.dart';
import 'package:chat_365/utils/data/extensions/string_extension.dart';
import 'package:chat_365/utils/helpers/system_utils.dart';
import 'package:chat_365/utils/ui/app_border_and_radius.dart';
import 'package:chat_365/utils/ui/app_decoration.dart';
import 'package:chat_365/utils/ui/app_dialogs.dart';
import 'package:chat_365/utils/ui/app_padding.dart';
import 'package:chat_365/utils/ui/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:visibility_detector/visibility_detector.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({
    Key? key,
    required this.isGroup,
    required this.conversationId,
    required this.senderId,
    this.chatItemModel,
    this.messageDisplay,
    this.action,
  }) : super(key: key);

  static const String isGroupArg = 'isGroupArg';
  static const String conversationIdArg = 'conversationIdArg';
  static const String senderIdArg = 'senderIdArg';
  static const String messageDisplayArg = 'messageDisplayArg';
  static const String chatItemModelArg = 'chatItemModelArg';
  static const String actionArg = 'actionArg';

  final bool isGroup;
  final int conversationId;
  final int senderId;
  final int? messageDisplay;
  final ChatItemModel? chatItemModel;
  final ChatFeatureAction? action;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late final ChatBloc _chatBloc;
  late final ChatDetailBloc _chatDetailBloc;

  late final UserInfoBloc _userInfoBloc;
  late final FriendCubit _friendCubit;
  late final bool _isGroup;
  final ScrollController _scrollController = ScrollController();
  late final int _senderId;
  late final int _conversationId;
  final ValueKey _centerKey = ValueKey('center-key');
  var kSliverExpandedHeight = 60.0;
  late final GroupProfileRepo? _groupProfileRepo;
  late final int _currentUserId;
  final GlobalKey<ChatInputBarState> _chatInputBarKey =
      GlobalObjectKey<ChatInputBarState>(DateTime.now());
  final String pageName = AppPages.Chat_Detail.name;
  late final ChatConversationBloc _chatConversationBloc;

  late final StreamSubscription _addImageSubscription;

  /// Check trạng thái đang fetch list message, khi đó [SliverAppBar] sẽ hiển thị
  /// loading
  final ValueNotifier<bool> _isFetchingListMsgs = ValueNotifier(false);

  /// Check show nút cuộn xuống cuối danh sách tin
  final ValueNotifier<bool> _isShowFAB = ValueNotifier(false);

  /// Check show [SliverAppBar]
  ///
  /// Trong trường hợp list message không fill viewport, ẩn [SliverAppBar]
  final ValueNotifier<bool> _isShowSliverAppBar = ValueNotifier(false);

  late final UnreadMessageCounterCubit _unreadMessageCounterCubit;

  late final TypingDetectorBloc _typingDetectorBloc;

  bool _showPinnedMessage = true;
  bool _extendAppBar = false;

  @override
  void initState() {
    super.initState();
    _isGroup = widget.isGroup;
    _userInfoBloc = context.read<UserInfoBloc>();
    _friendCubit = context.read<FriendCubit>()..fetchFriendData();

    _chatConversationBloc = context.read<ChatConversationBloc>();

    _senderId = widget.senderId;
    _conversationId = widget.conversationId;
    _currentUserId = context.userInfo().id;
    _unreadMessageCounterCubit = context.read<UnreadMessageCounterCubit>();

    if (_isGroup)
      _groupProfileRepo = GroupProfileRepo(_conversationId, _isGroup);

    _chatBloc = context.read<ChatBloc>();
    _scrollController.addListener(_scrollListener);
    _typingDetectorBloc = context.read<TypingDetectorBloc>();
    _chatDetailBloc = ChatDetailBloc(
      conversationId: _conversationId,
      senderId: _senderId,
      userInfoRepo: context.read<UserInfoRepo>(),
      chatRepo: context.read<ChatRepo>(),
      isGroup: _isGroup,
      initMemberHasNickname: widget.isGroup ? [] : [_userInfoBloc.userInfo],
      messageDisplay: widget.messageDisplay,
      chatItemModel: widget.chatItemModel,
      unreadMessageCounterCubit: _unreadMessageCounterCubit,
    )..add(ChatDetailEventLoadConversationDetail());

    _addImageSubscription = _chatBloc.stream.listen((state) {
      if (state is ChatStateRecieveMessage &&
          state.msg.conversationId == _conversationId) {
        _chatDetailBloc.listImageFiles
            .addAll(_chatDetailBloc.getImageFilesFromListMessages([state.msg]));
      }
    });

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      if (widget.action != null) {
        switch (widget.action) {
          case ChatFeatureAction.sendLocation:
            AppRouterHelper.toSendLocationPage(
              context,
              chatDetailBloc: _chatDetailBloc,
            );
            break;
          default:
        }
      }

      if (_chatConversationBloc.drafts[_conversationId] != null) {
        var draftModel = _chatConversationBloc.drafts[_conversationId]!;
        if (draftModel.editingMessasge != null)
          _chatInputBarKey.currentState!
              .editMessage(draftModel.editingMessasge!);
        else if (draftModel.replyingMessage != null)
          _chatInputBarKey.currentState!
              .replyMessage(draftModel.replyingMessage!);
        _chatInputBarKey.currentState!.inputController.text =
            draftModel.draftContent;
      }
    });
  }

  @override
  void deactivate() {
    super.deactivate();
    var chatInputBarState = _chatInputBarKey.currentState!;
    var draftContent = chatInputBarState.inputController.text;
    var draftModel;
    if (draftContent.isNotEmpty) {
      if (chatInputBarState.replyingMessage != null)
        draftModel = DraftModel(
          draftContent,
          replyingMessage: chatInputBarState.replyingMessage,
        );
      else if (chatInputBarState.isEditing)
        draftModel = DraftModel(
          draftContent,
          editingMessasge: chatInputBarState.originMessage,
        );
      else
        draftModel = DraftModel(draftContent);
      _chatConversationBloc.drafts[_conversationId] = draftModel;
    } else
      _chatConversationBloc.drafts.remove(_conversationId);
  }

  @override
  void dispose() {
    if (!_chatDetailBloc.isShowOfflineMessage)
      _chatConversationBloc.chatsMap[_conversationId]?.lastMessages =
          _chatDetailBloc.currentLastMessages;
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    _chatBloc
      // ..errorMessage.clear()
      // ..sendingMessage.clear()
      ..cachedMessageImageFile.clear();
    _addImageSubscription.cancel();
    _chatDetailBloc.close();
    try {
      _onTypingStatusChanged(navigatorKey.currentContext!, isTyping: false);
    } catch (e) {}
    // _unreadMessageCounterCubit.close();
    super.dispose();
  }

  _scrollListener() {
    if (_scrollController.hasClients) {
      _computeToShowFAB();
      _computeToLoadMoreMessages();
      _computeReadAllMessage();
    }
  }

  _computeToShowFAB() {
    var isAtBottom =
        _scrollController.position.atEdge && _scrollController.offset == 0;
    if (isAtBottom && _isShowFAB.value) {
      _isShowFAB.value = false;
    } else if (!isAtBottom && !_isShowFAB.value) {
      _isShowFAB.value = true;
    }
  }

  _computeToLoadMoreMessages() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent -
                kSliverExpandedHeight &&
        _scrollController.position.userScrollDirection ==
            ScrollDirection.reverse) {
      if (_scrollController.position.atEdge) {
        _isFetchingListMsgs.value = true;
        _chatDetailBloc.add(ChatDetailEventFetchListMessges());
      }
    }
  }

  _computeToShowSliverAppBar(BuildContext context) {
    if (_scrollController.position.maxScrollExtent -
                MediaQuery.of(context).viewInsets.bottom <=
            0 &&
        _isShowSliverAppBar.value) {
      _isShowSliverAppBar.value = false;
    } else if (_scrollController.position.maxScrollExtent != 0 &&
        !_isShowSliverAppBar.value) {
      _isShowSliverAppBar.value = true;
    }
  }

  _scrollToTheEnd() {
    if (_scrollController.hasClients)
      _scrollController.jumpTo(
        0,
      );
  }

  _computeReadAllMessage() {
    if (_scrollController.position.atEdge &&
        _scrollController.offset == 0 &&
        _unreadMessageCounterCubit.hasUnreadMessage) {
      _chatBloc.markReadMessages(
        senderId: context.userInfo().id,
        conversationId: _conversationId,
        memebers: listMemeberIds.toList(),
      );
    }
  }

  Iterable<int> get listMemeberIds => _chatDetailBloc.listUserInfoBlocs.keys;

  _onTypingStatusChanged(
    BuildContext context, {
    required bool isTyping,
  }) =>
      _chatBloc.add(
        ChatEventEmitTypingChanged(
          isTyping,
          conversationId: _conversationId,
          listMembers: listMemeberIds.toList(),
          userId: context.userInfo().id,
        ),
      );

  _sendMessage(List<ApiMessageModel> messages) {
    _onTypingStatusChanged(context, isTyping: false);

    if (_chatInputBarKey.currentState!.isEditMode) {
      return _chatBloc.add(
        ChatEventEmitEditMessage(
          messages[0],
          memebers: _chatDetailBloc.listUserInfoBlocs.keys.toList(),
        ),
      );
    }

    Future.delayed(
      const Duration(milliseconds: 200),
      _scrollToTheEnd,
    );

    for (var message in messages) {
      _chatDetailBloc.add(
        ChatDetailEventAddNewListMessages(
          [
            SocketSentMessageModel(
              conversationId: message.conversationId,
              messageId: message.messageId,
              senderId: message.senderId,
              type: message.type,
              contact: message.contact,
              files: message.files,
              message: message.message,
              relyMessage: message.relyMessage,
              createAt: DateTime.now(),
              messageStatus: MessageStatus.sending,
              autoDeleteMessageTimeModel:
                  AutoDeleteMessageTimeModel.defaultModel(),
            ),
          ],
          isTempMessage: true,
        ),
      );
      var members = Map<int, int>();

      for (var entry in _chatDetailBloc.listUserInfoBlocs.entries) {
        members[entry.key] =
            entry.value.state.userInfo.lastActive == null ? 1 : 0;
      }

      _chatBloc.sendMessage(
        message,
        memberIds: members.keys.toList(),
        conversationId: _conversationId,
        conversationBasicInfo: ConversationBasicInfo(
          conversationId: _conversationId,
          isGroup: _isGroup,
          name: _isGroup
              ? _userInfoBloc.state.userInfo.name
              : context.userInfo().name,
          userId: _userInfoBloc.userInfo.id,
        ),
        onlineUsers: members.values.toList(),
      );
    }
  }

  // Future<File> getImageFileFromAssets(String path) async {
  //   final byteData = await rootBundle.load('$path');

  //   final file =
  //       File('${(await getTemporaryDirectory()).path}/${path.split('/').last}');
  //   await file.writeAsBytes(byteData.buffer
  //       .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

  //   return file;
  // }

  TextEditingController get inputController =>
      _chatInputBarKey.currentState!.inputController;

  DateTime _lastTimeFetchDataOnReconnectInternet =
      AppConst.defaultFirstTimeFetchSuccess;

  _detailStateListener(BuildContext context, ChatDetailState detailState) {
    Fluttertoast.cancel();
    if (detailState is ChatDetailStateError ||
        detailState is ChatDetailStateLoadDoneListMessages) {
      _isFetchingListMsgs.value = false;
    }
    if (detailState is ChatDetailStateError) {
      if (detailState.error.error != 'Cuộc trò chuyện không tồn tại' &&
          !detailState.error.isExceedListChat)
        AppDialogs.toast(detailState.error.toString());
      Future.delayed(const Duration(milliseconds: 500), () {
        if (_scrollController.hasClients)
          _scrollController.animateTo(
            _scrollController.offset -
                kSliverExpandedHeight +
                context.mediaQueryPadding.top,
            duration: const Duration(milliseconds: 500),
            curve: Curves.ease,
          );
      });
    } else if (detailState is ChatDetailStateLoading &&
        !detailState.markNeedBuild) {
      AppDialogs.toast(
        'Đang cập nhật cuộc trò chuyện ...',
        color: context.theme.primaryColor,
        textColor: AppColors.white,
      );
    } else if (detailState is ChatDetailStateLoadDetailDone &&
        detailState.isBroadcastUpdate) {
      var userInfoRepo = context.read<UserInfoRepo>();
      if (_isGroup)
        userInfoRepo.broadCastConversationInfo(
          detailState.detail.conversationBasicInfo,
        );
      else
        userInfoRepo.broadCastUserInfo(
          detailState.detail.firstOtherMember(_currentUserId),
        );
    }
  }

  videoCall() {
    AppRouter.toPage(context, AppPages.Video_Call, arguments: {
      'idCaller': context.read<AuthRepo>().userId.toString(),
      'idCallee': _chatDetailBloc.listUserInfoBlocs.keys.toList()
        ..remove(context.read<AuthRepo>().userId),
      'idConversation': _conversationId.toString(),
      'userInfor': context.read<AuthRepo>().userInfo,
      'idRoom': context.read<AuthRepo>().userId.toString(),
      'checkCallee': false
    });
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      if (_scrollController.hasClients) _computeToShowSliverAppBar(context);
    });
    return BlocListener<NetworkCubit, NetworkState>(
      listener: (context, state) async {
        if (state.hasInternet) {
          // if (!state.socketDisconnected) {
          //   var lenght = _chatBloc.errorMessage.length;
          //   _chatBloc
          //     ..add(
          //       ChatEventResendMessage(
          //         _conversationId,
          //         [..._chatBloc.errorMessage],
          //         listMemeberIds.toList(),
          //         onResend: (message) => _chatDetailBloc.add(
          //           ChatDetailEventAddNewListMessages(
          //             [
          //               SocketSentMessageModellúc nào bấm vào xem ngay mà infoLink null thì hiển thị toast k thể xem tin hay gì đấy cũng dc(
          //                 conversationId: message.conversationId,
          //                 messageId: message.messageId,
          //                 senderId: message.senderId,
          //                 type: message.type,
          //                 contact: message.contact,
          //                 // files: message.files,
          //                 message: message.message,
          //                 relyMessage: message.relyMessage,
          //                 createAt: DateTime.now(),
          //               ),
          //             ],
          //             isTempMessage: true,
          //           ),
          //         ),
          //       ),
          //     )
          //     ..errorMessage.clear();
          //   await Future.delayed(Duration(milliseconds: lenght * 200));
          // }
          if (DateTime.now()
                  .difference(_lastTimeFetchDataOnReconnectInternet)
                  .inMinutes >=
              3) {
            _chatDetailBloc.add(ChatDetailEventLoadConversationDetail());
            _friendCubit.fetchFriendData();
            _lastTimeFetchDataOnReconnectInternet = DateTime.now();
          }
        }
      },
      child: Scaffold(
        appBar: UserListTileAppBar(
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(_extendAppBar ? 20 : 0),
              child: ValueListenableBuilder<DetailModel?>(
                valueListenable: _chatDetailBloc.detailModel,
                builder: (context, detailModel, child) {
                  var userType =
                      _chatDetailBloc.detail?.conversationBasicInfo.userType;
                  if (detailModel != null &&
                      (userType == UserType.company ||
                          userType == UserType.staff ||
                          userType == UserType.customer)) {
                    if (!_extendAppBar)
                      WidgetsBinding.instance?.addPostFrameCallback(
                        (timeStamp) => setState(() => _extendAppBar = true),
                      );

                    return InkWell(
                      onTap: () => AppDialogs.showDetailInfo(
                        context,
                        type: userType!,
                        detailModel: _chatDetailBloc.getDetailInfo,
                      ),
                      child: Container(
                        height: 18,
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        margin: EdgeInsets.only(bottom: 8, top: 4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: context.theme.primaryColor,
                        ),
                        child: Text(
                          userType == UserType.company
                              ? 'Thông tin tuyển dụng'
                              : 'Thông tin ứng viên',
                          style: AppTextStyles.regularW400(
                            context,
                            size: 12,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    );
                  }
                  return child!;
                },
                child: const SizedBox(),
              ),
            ),
            userInfoBloc: _userInfoBloc,
            chatDetailBloc: _chatDetailBloc,
            isGroup: _isGroup,
            elevation: 2.0,
            countConversationMember: _chatDetailBloc.countConversationMember,
            actions: [
              // Ẩn phần call để đẩy app
              Align(
                child: GestureDetector(
                  onTap: () {
                    if (_isGroup)
                      AppRouter.toPage(context, AppPages.Group_Video_call);
                    if (!_isGroup) {
                      try {
                        videoCall();
                      } catch (e, s) {
                        print(s);
                      }
                    }
                  },
                  child: Container(
                    padding: AppPadding.paddingAll8,
                    decoration: BoxDecoration(
                        gradient: context.theme.gradient,
                        borderRadius: BorderRadius.all(Radius.circular(100))),
                    child: SvgPicture.asset(
                      Images.ic_video_call_1,
                      color: context.theme.backgroundColor,
                    ),
                  ),
                ),
              ),
              if (!_isGroup) SizedBoxExt.w10,
              if (!_isGroup)
                Align(
                  child: GestureDetector(
                    onTap: () {
                      AppRouter.toPage(context, AppPages.Call, arguments: {
                        MainPhoneCallScreen.arugUserInfo: _userInfoBloc.userInfo
                      });
                    },
                    child: Container(
                      padding: AppPadding.paddingAll8,
                      decoration: BoxDecoration(
                          gradient: context.theme.gradient,
                          borderRadius: BorderRadius.all(Radius.circular(100))),
                      child: SvgPicture.asset(
                        Images.ic_call,
                        color: context.theme.backgroundColor,
                      ),
                    ),
                  ),
                ),

              if (_isGroup) SizedBoxExt.w10,
              if (_isGroup)
                Align(
                  child: GestureDetector(
                    onTap: () => AppRouterHelper.toSelectListUserCheckBox(
                      context,
                      title: 'Thêm thành viên vào nhóm',
                      onSubmitted: (users) => _groupProfileRepo!.addMember(
                        newMemberIds: users.map((e) => e.id).toList(),
                        oldMemberIds: listMemeberIds,
                      ),
                      onSuccess: (users) {
                        var messageId =
                            GeneratorService.generateMessageId(_currentUserId);
                        var memberIds =
                            _chatDetailBloc.listUserInfoBlocs.keys.toList();
                        for (var i = 0; i < users.length; i++) {
                          var user = users[i];
                          _chatBloc.sendMessage(
                            ApiMessageModel(
                              messageId:
                                  GeneratorService.addToMessageId(messageId, i),
                              conversationId: _conversationId,
                              senderId: _currentUserId,
                              type: MessageType.notification,
                              message:
                                  '$_currentUserId added ${users[i].id} to this consersation',
                            ),
                            memberIds: memberIds,
                          );
                          _chatDetailBloc.listUserInfoBlocs.putIfAbsent(
                            user.id,
                            () => UserInfoBloc(user),
                          );
                        }
                        _chatDetailBloc.countConversationMember.value =
                            _chatDetailBloc.listUserInfoBlocs.length;
                      },
                    ),
                    child: Container(
                      padding: AppPadding.paddingAll8,
                      decoration: BoxDecoration(
                          gradient: context.theme.gradient,
                          borderRadius: BorderRadius.all(Radius.circular(100))),
                      child: SvgPicture.asset(
                        Images.ic_fluent_people_add,
                        color: context.theme.backgroundColor,
                      ),
                    ),
                  ),
                ),
            ]),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 60.0),
          child: ValueListenableBuilder<bool>(
            valueListenable: _isShowFAB,
            builder: (_, isShow, child) => isShow ? child! : const SizedBox(),
            child: Stack(
              alignment: Alignment.topRight,
              children: [
                FloatingActionButton(
                  onPressed: _scrollToTheEnd,
                  child: Icon(
                    Icons.keyboard_arrow_down,
                    color: AppColors.white,
                    size: 40,
                  ),
                  backgroundColor: AppColors.dustyGray,
                ),
                BlocBuilder<UnreadMessageCounterCubit,
                    UnreadMessageCounterState>(
                  bloc: _unreadMessageCounterCubit,
                  builder: (_, state) {
                    if (_unreadMessageCounterCubit.hasUnreadMessage)
                      return CircleAvatar(
                        backgroundColor: AppColors.red,
                        radius: 12,
                        child: Text(
                          _unreadMessageCounterCubit.countUnreadMessage
                              .toString(),
                          style: AppTextStyles.regularW500(
                            context,
                            size: 14,
                            color: AppColors.white,
                          ),
                        ),
                      );
                    return SizedBox();
                  },
                ),
              ],
            ),
          ),
        ),
        // floatingActionButton: _addFriendButton(),
        body: DefaultTextStyle(
          style: AppTextStyles.regularW400(
            context,
            size: 16,
            lineHeight: 20,
          ),
          child: Column(
            children: [
              StatefulBuilder(
                builder: (context, setState) {
                  if (!_showPinnedMessage) return const SizedBox();
                  return ValueListenableBuilder<SocketSentMessageModel?>(
                    valueListenable: _chatDetailBloc.pinnedMessage,
                    builder: (context, message, child) {
                      if (message != null)
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 15.0,
                                  ),
                                  child: SvgPicture.asset(
                                    Images.ic_pin,
                                    color: context.theme.primaryColor,
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Tin nhắn',
                                        style: AppTextStyles.regularW500(
                                          context,
                                          size: 16,
                                          lineHeight: 20,
                                        ),
                                      ),
                                      RichText(
                                        text: TextSpan(
                                          text:
                                              '${_chatDetailBloc.allUserInfoBlocsAppearInConversation[message.senderId]?.userInfo.name}: ',
                                          style: AppTextStyles.regularW500(
                                            context,
                                            size: 16,
                                            lineHeight: 20,
                                          ),
                                          children: [
                                            TextSpan(
                                              text: '${message.message}',
                                              style: context
                                                  .theme.messageTextStyle,
                                            ),
                                          ],
                                        ),
                                        maxLines: 2,
                                      ),
                                    ],
                                  ),
                                ),
                                child!,
                                const SizedBox(width: 15),
                              ],
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 8),
                              color: context.theme.isDarkTheme
                                  ? AppColors.white
                                  : AppColors.greyCC,
                              height: 1,
                              width: double.infinity,
                            ),
                          ],
                        );
                      return const SizedBox(
                        key: ValueKey('non-pinned-message'),
                      );
                    },
                    child: PopupMenuButton(
                      offset: Offset(20, 20),
                      padding: EdgeInsets.zero,
                      color: AppColors.whiteLilac,
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      onSelected: (value) async {},
                      itemBuilder: (context) {
                        return [
                          PopupMenuItem(
                            height: double.minPositive,
                            value: 1,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Sao chép',
                                style: context.theme.pinDropdownItemTextStyle,
                              ),
                            ),
                            onTap: () => SystemUtils.copyToClipboard(
                              _chatDetailBloc.pinnedMessage.value!.message!,
                            ),
                          ),
                          PopupMenuItem(
                            height: double.minPositive,
                            value: 2,
                            onTap: () =>
                                setState(() => _showPinnedMessage = false),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Ẩn ghim tin nhắn',
                                style: context.theme.pinDropdownItemTextStyle,
                              ),
                            ),
                          ),
                          PopupMenuItem(
                            height: double.minPositive,
                            value: 3,
                            onTap: () => _chatDetailBloc.unPinMessage(
                              _chatDetailBloc.pinnedMessage.value!.message ??
                                  '',
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Bỏ ghim tin nhắn',
                                style: context.theme.pinDropdownItemTextStyle
                                    .copyWith(
                                  color: AppColors.red,
                                ),
                              ),
                            ),
                          ),
                        ];
                      },
                      child: SvgPicture.asset(
                        Images.ic_3_dot,
                        color: context.theme.primaryColor,
                        width: 24,
                        height: 20,
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),

              /// [SliverList] bên trong chỉ thay đổi UI khi [detailState]
              /// is [ChatDetailStateLoadDoneListMessages]
              Expanded(
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: BlocConsumer<ChatDetailBloc, ChatDetailState>(
                        bloc: _chatDetailBloc,
                        listenWhen: (_, __) {
                          var currentRoute =
                              routeObserver.currentPageRoute?.settings.name;
                          return currentRoute == pageName;
                        },
                        listener: _detailStateListener,
                        buildWhen: (prev, current) =>
                            mounted &&
                            (current is ChatDetailStateLoadDoneListMessages ||
                                (current is ChatDetailStateError &&
                                    (!_chatDetailBloc
                                            .fetchListMessasgeSuccessFirstTime ||
                                        current.error.isServerError)) ||
                                (current is ChatDetailStateLoading &&
                                    current.markNeedBuild)),
                        builder: (context, detailState) {
                          if (detailState
                              is ChatDetailStateLoadDoneListMessages) {
                            WidgetsBinding.instance?.addPostFrameCallback(
                              (_) => _computeToShowSliverAppBar(context),
                            );
                            var msgs = detailState.listMsgModels;
                            return BlocListener<ChatBloc, ChatState>(
                              listenWhen: (previous, current) {
                                /// Nhận được tin nhắn và cùng [conversationId]
                                var isReciveMessage =
                                    current is ChatStateRecieveMessage &&
                                        current.msg.conversationId ==
                                            _conversationId;

                                var isEdittedMessage =
                                    current is ChatStateEditMessageSuccess &&
                                        current.messageId ==
                                            _chatInputBarKey
                                                .currentState!.messageId;

                                var isAddedNewMemberToThisGroup = current
                                        is ChatStateNewMemberAddedToGroup &&
                                    current.conversationId == _conversationId;

                                var isMessageDeleted = current
                                        is ChatStateDeleteMessageSuccess &&
                                    current.conversationId == _conversationId;

                                var isMemberOutGroup = current
                                        is ChatStateOutGroup &&
                                    current.conversationId == _conversationId;

                                return mounted && isReciveMessage ||
                                    isEdittedMessage ||
                                    isAddedNewMemberToThisGroup ||
                                    isMemberOutGroup ||
                                    isMessageDeleted;
                              },
                              listener: (context, state) {
                                if (state is ChatStateRecieveMessage) {
                                  if (state.msg.senderId == _currentUserId) {
                                    _chatBloc.markReadMessages(
                                      senderId: _currentUserId,
                                      conversationId: _conversationId,
                                      memebers: listMemeberIds.toList(),
                                    );
                                  }
                                  if (!state.isTempMessage)
                                    _chatDetailBloc
                                      ..totalMessages += 1
                                      ..loadedMessages += 1;
                                  if (!detailState.listMsgModels
                                      .contains(state.msg)) {
                                    _chatDetailBloc.add(
                                      ChatDetailEventAddNewListMessages(
                                        [state.msg],
                                      ),
                                    );
                                  }
                                } else if (state
                                    is ChatStateEditMessageSuccess) {
                                  _chatInputBarKey.currentState!.exitEditMode();
                                } else if (state
                                    is ChatStateNewMemberAddedToGroup) {
                                  _chatDetailBloc.listUserInfoBlocs.addAll(
                                    Map<int, UserInfoBloc>.fromIterable(
                                      state.members,
                                      key: (e) => (e as IUserInfo).id,
                                      value: (v) =>
                                          UserInfoBloc(v as IUserInfo),
                                    ),
                                  );
                                  _chatDetailBloc
                                          .countConversationMember.value =
                                      _chatDetailBloc.listUserInfoBlocs.length;
                                  // .addAll([...state.members]);
                                } else if (state is ChatStateOutGroup) {
                                  var deletedId = state.deletedId;
                                  var member = _chatDetailBloc.listUserInfoBlocs
                                      .remove(deletedId);
                                  _chatDetailBloc
                                          .countConversationMember.value =
                                      _chatDetailBloc.listUserInfoBlocs.length;

                                  if (member != null) {
                                    _chatDetailBloc
                                      ..tempListUserInfoBlocs[deletedId] =
                                          member
                                      ..unreadMessageUserAndMessageId
                                          .remove(deletedId)
                                      ..unreadMessageUserAndMessageIndex
                                          .remove(deletedId);
                                  }
                                } else if (state
                                        is ChatStateDeleteMessageSuccess &&
                                    state.messageIndex == null) {
                                  var msgs = _chatDetailBloc.msgs;
                                  var messageIndex = msgs.indexWhere(
                                    (e) => e.messageId == state.messageId,
                                  );

                                  if (messageIndex != -1) {
                                    var aboveMsg;
                                    var belowMsg;
                                    try {
                                      aboveMsg = msgs[messageIndex - 1];
                                    } catch (e) {}
                                    try {
                                      belowMsg = msgs[messageIndex + 1];
                                    } catch (e) {}
                                    _chatBloc.add(
                                      ChatEventToEmitDeleteMessageWithMessageIndexInConversation(
                                        state.conversationId,
                                        state.messageId,
                                        messageIndex,
                                        aboveMessage: aboveMsg,
                                        belowMessage: belowMsg,
                                      ),
                                    );
                                  }
                                }
                              },
                              child: CustomScrollView(
                                controller: _scrollController,
                                center: _centerKey,
                                physics: const ClampingScrollPhysics(),

                                /// [reverse = true] và [currentIndex = msgs.length - 1 - index]
                                /// để [SliverList] ở cuối màn hình khi số lượng tin nhắn ít
                                reverse: true,
                                slivers: [
                                  SliverList(
                                    key: _centerKey,
                                    delegate: SliverChildBuilderDelegate(
                                      (context, index) {
                                        try {
                                          var currentIndex =
                                              msgs.length - 1 - index;
                                          var msg = msgs[currentIndex];
                                          var prevMsg;
                                          var nextMsg;
                                          if (currentIndex != 0)
                                            prevMsg = msgs[currentIndex - 1];
                                          if (currentIndex < msgs.length - 1)
                                            nextMsg = msgs[currentIndex + 1];
                                          var msgItem = MultiBlocProvider(
                                              providers: [
                                                BlocProvider.value(
                                                  value: _chatDetailBloc,
                                                ),
                                                BlocProvider.value(
                                                  value:
                                                      _unreadMessageCounterCubit,
                                                ),
                                              ],
                                              child: MessageItem(
                                                key: ValueKey(
                                                  _chatDetailBloc
                                                          .isShowOfflineMessage
                                                      ? msg.messageId +
                                                          '_offline'
                                                      : msg.messageId,
                                                ),
                                                messageItemModel: msg,
                                                prevMessageItemModel: prevMsg,
                                                nextMessageItemModel: nextMsg,
                                              ));
                                          return RepositoryProvider.value(
                                            value: _chatInputBarKey,
                                            child: msgItem,
                                          );
                                        } catch (e) {
                                          return null;
                                        }
                                      },
                                      childCount: msgs.length,
                                      addRepaintBoundaries: true,
                                      addAutomaticKeepAlives: true,
                                    ),
                                  ),
                                  const SliverToBoxAdapter(
                                    child: SizedBox(height: 16),
                                  ),

                                  /// vì [reverse] = true nên [SliverAppBar] nằm dưới
                                  SliverToBoxAdapter(
                                    child: ValueListenableBuilder<bool>(
                                      valueListenable: _isShowSliverAppBar,
                                      builder: (context, isShow, child) {
                                        return isShow
                                            ? child!
                                            : const SizedBox();
                                      },
                                      child: AppBar(
                                        elevation: 0,
                                        backgroundColor: Theme.of(context)
                                            .scaffoldBackgroundColor
                                            .withOpacity(0.6),
                                        leading: const SizedBox.shrink(),
                                        centerTitle: true,
                                        title: ValueListenableBuilder<bool>(
                                          valueListenable: _isFetchingListMsgs,
                                          builder:
                                              (context, isFetching, child) {
                                            return SizedBox.square(
                                              dimension: 20,
                                              child: isFetching
                                                  ? CircularProgressIndicator
                                                      .adaptive(
                                                      strokeWidth: 2,
                                                    )
                                                  : null,
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                          if (detailState is ChatDetailStateError &&
                              _chatDetailBloc
                                  .msgs.isEmpty) if (detailState
                              .error.isNetworkException) {
                            return AppErrorWidget(
                              error: detailState.error.toString(),
                              onTap: () {
                                _chatDetailBloc.add(
                                    ChatDetailEventLoadConversationDetail());
                                _friendCubit.fetchFriendData();
                              },
                            );
                          } else {
                            return const SizedBox();
                          }

                          return Center(
                            child: WidgetUtils.loadingCircle(context),
                          );
                        },
                      ),
                    ),
                    if (!_isGroup &&
                        !(_currentUserId == _userInfoBloc.userInfo.id))
                      BlocProvider.value(
                        value: _chatDetailBloc,
                        child: BlocBuilder<ChatDetailBloc, ChatDetailState>(
                          bloc: _chatDetailBloc,
                          buildWhen: (prev, currentChatDetailState) =>
                              mounted &&
                              ((prev is ChatDetailStateError &&
                                      prev ==
                                          'Cuộc trò chuyện không tồn tại') ||
                                  (currentChatDetailState
                                          is ChatDetailStateError ||
                                      currentChatDetailState ==
                                          'Cuộc trò chuyện không tồn tại')),
                          builder: (context, chatDetailState) {
                            return BlocConsumer<FriendCubit, FriendState>(
                              bloc: _friendCubit,
                              listenWhen: (_, current) {
                                var isResponseAddFriend =
                                    current is FriendStateResponseAddFriend;
                                var isAddFriend =
                                    current is FriendStateAddFriend;
                                return mounted &&
                                    (isResponseAddFriend || isAddFriend);
                              },
                              listener: (_, friendState) {
                                AppRouter.removeAllDialog(context);
                                if (friendState
                                        is FriendStateAddFriendSuccess ||
                                    (friendState is FriendStateAddFriendError &&
                                        friendState.error.error ==
                                            'User đã tồn tại lời mời')) {
                                  _friendCubit.changeStatus(
                                    _currentUserId,
                                    _userInfoBloc.userInfo.id,
                                    FriendStatus.send,
                                  );
                                  _sendMessage(
                                    [
                                      ApiMessageModel(
                                        messageId:
                                            GeneratorService.generateMessageId(
                                          _currentUserId,
                                        ),
                                        conversationId: _conversationId,
                                        senderId: _currentUserId,
                                        type: MessageType.notification,
                                        message:
                                            '${_currentUserId} was add friend to ${_userInfoBloc.userInfo.id}',
                                      ),
                                    ],
                                  );
                                } else if (friendState
                                    is FriendStateAddFriendLoading) {
                                  AppDialogs.showLoadingCircle(context);
                                } else if (friendState
                                    is FriendStateResponseAddFriendLoading) {
                                  AppDialogs.showLoadingCircle(context);
                                } else if (friendState
                                    is FriendStateResponseAddFriendError) {
                                  AppDialogs.toast(friendState.error.error);
                                }
                                // else if (friendState
                                //     is FriendStateResponseAddFriendSuccess) {
                                //   _friendCubit.changeStatus(
                                //     _currentUserId,
                                //     friendState.requestId,
                                //     friendState.status,
                                //   );
                                // }
                              },
                              buildWhen: (_, currentFriendState) {
                                var isAddFriend = (currentFriendState
                                        is FriendStateAddFriend &&
                                    currentFriendState.chatId ==
                                        _userInfoBloc.userInfo.id);
                                var isLoadSuccess = currentFriendState
                                    is FriendStateLoadSuccess;
                                var isDeleteContact = currentFriendState
                                        is FriendStateDeleteContact &&
                                    {
                                      currentFriendState.userId,
                                      currentFriendState.chatId,
                                    }.containsAll([
                                      _currentUserId,
                                      _userInfoBloc.userInfo.id
                                    ]);
                                return mounted &&
                                    (isAddFriend ||
                                        isLoadSuccess ||
                                        isDeleteContact);
                              },
                              builder: (context, friendState) {
                                var recieveId = _userInfoBloc.userInfo.id;
                                var recieveFriendModel =
                                    _friendCubit.friendsRequest?[recieveId];

                                var visible = false;

                                final bool isDeletedContact =
                                    friendState is FriendStateDeleteContact;

                                bool hasAcceptedStatus =
                                    (friendState is FriendStateLoadSuccess &&
                                        (recieveFriendModel == null ||
                                            recieveFriendModel.status ==
                                                FriendStatus.accept));

                                var isSameCompany =
                                    context.userInfo().companyId ==
                                        _userInfoBloc.userInfo.companyId;

                                var isNotExistConversation =
                                    (chatDetailState is ChatDetailStateError &&
                                        chatDetailState.error.error ==
                                            'Cuộc trò chuyện không tồn tại');

                                /// Mặc định hiển thị khi:
                                /// - 1 trong 2 xóa liên hệ (Realtime)
                                /// Hoặc
                                /// - Không cùng công ty và 2 người chưa chat với nhau bao giờ hoặc
                                /// trạng thái khác [FriendStatus.accept]
                                visible = isDeletedContact ||
                                    (!isSameCompany &&
                                        (isNotExistConversation ||
                                            !hasAcceptedStatus));

                                /// Nếu không hiển thị, check tiếp:
                                /// Nếu là bạn bè hoặc cùng công ty thì tiếp tục không hiển thị
                                if (!visible) {
                                  var existInListFriend = _friendCubit
                                          .listFriends
                                          ?.toList()
                                          .indexWhere((e) =>
                                              e.id ==
                                              _userInfoBloc.userInfo.id) !=
                                      -1;
                                  var isFriend =
                                      isSameCompany || existInListFriend;

                                  visible = !isFriend;
                                }

                                /// Check 2 người có tương tác bạn bè với nhau không:
                                /// 1 trong 2 gửi đang chờ phản hồi kết bạn, từ chối
                                bool hasFriendInteractive = false;

                                var child;

                                // Liên hệ bạn bè bị xóa
                                if (friendState is FriendStateDeleteContact) {
                                  child = Column(
                                    children: [
                                      Text(
                                        'Kết bạn với ${_userInfoBloc.userInfo.name} để tiếp tục trò chuyện',
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(height: 20),
                                      _addFriendButton(),
                                    ],
                                  );
                                }

                                // Người kia gửi kết bạn cho user hiện tại
                                else if (recieveFriendModel?.status ==
                                    FriendStatus.request) {
                                  hasFriendInteractive = true;
                                  child = Column(
                                    children: [
                                      Text(
                                        '${_userInfoBloc.userInfo.name} muốn kết nối với bạn',
                                      ),
                                      const SizedBox(height: 16),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: OutlinedButton(
                                              onPressed: () => _friendCubit
                                                  .responseAddFriend(
                                                _currentUserId,
                                                _userInfoBloc.userInfo,
                                                FriendStatus.decline,
                                              ),
                                              child: Text('Chặn'),
                                            ),
                                          ),
                                          const SizedBox(width: 20),
                                          Expanded(
                                            child: ElevatedButton(
                                              onPressed: () => _friendCubit
                                                  .responseAddFriend(
                                                _currentUserId,
                                                _userInfoBloc.userInfo,
                                                FriendStatus.accept,
                                              ),
                                              child: Text('Chấp nhận'),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                                }

                                // Từ chối lời mời
                                else if (recieveFriendModel?.status ==
                                    FriendStatus.decline) {
                                  hasFriendInteractive = true;
                                  child = Column(
                                    children: [
                                      Text('Lời mời kết bạn đã bị từ chối'),
                                      const SizedBox(height: 20),
                                      _addFriendButton(
                                        label: 'Gửi lại lời mời kết bạn',
                                      ),
                                    ],
                                  );
                                }

                                // Chờ chấp nhận lời mời
                                else if (recieveFriendModel?.status ==
                                    FriendStatus.send) {
                                  hasFriendInteractive = true;
                                  child = Text(
                                    'Đang chờ ${_userInfoBloc.userInfo.name} chấp nhận lời mời',
                                    textAlign: TextAlign.center,
                                  );
                                }

                                // Đang gửi lời mời kết bạn
                                else if (friendState is FriendStateAddFriend) {
                                  hasFriendInteractive = true;
                                  if (friendState
                                      is FriendStateAddFriendLoading)
                                    child = Text(
                                      'Đang gửi lời mời kết bạn',
                                    );
                                  else if (friendState is FriendStateLoadError)
                                    child = AppErrorWidget(
                                      error:
                                          (friendState as FriendStateLoadError)
                                              .error
                                              .toString(),
                                    );
                                  else if (friendState is FriendStateLoading)
                                    child = Text(
                                      'Đang tải dữ liệu, vui lòng đợi ...',
                                      textAlign: TextAlign.center,
                                    );
                                }

                                // Chưa có đề nghị kết bạn từ 2 phía
                                else
                                  child = Column(
                                    children: [
                                      Text(
                                        'Nói lời chào với ${_userInfoBloc.userInfo.name} bằng một cái vẫy tay',
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(height: 20),
                                      _addFriendButton(),
                                    ],
                                  );

                                if (hasFriendInteractive) visible = true;

                                return Visibility(
                                  visible: visible,
                                  child: Container(
                                    // height: double.infinity,
                                    width: double.infinity,
                                    color: context.theme.backgroundColor,
                                    // color: AppColors.red,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const SizedBox(height: 20),
                                        // userListTile
                                        SizedBox(
                                          width: context.mediaQuerySize.width *
                                              2 /
                                              3,
                                          child: UserListTile(
                                            avatar: DisplayAvatar(
                                              model: _userInfoBloc.userInfo,
                                              isGroup: false,
                                              size: 50,
                                              enable: false,
                                            ),
                                            userName:
                                                _userInfoBloc.userInfo.name,
                                            bottom: Row(
                                              children: [
                                                SvgPicture.asset(
                                                  Images.ic_people,
                                                  height: 20,
                                                  width: 20,
                                                  color:
                                                      context.theme.iconColor,
                                                ),
                                                const SizedBox(width: 6),
                                                Flexible(
                                                  child: Text(
                                                    'Không có liên hệ chung',
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        SizedBox(
                                          width: double.infinity,
                                          child: Card(
                                            color:
                                                context.theme.messageBoxColor,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 16),
                                            child: Center(
                                              child: Padding(
                                                padding: const EdgeInsets.all(
                                                  14.0,
                                                ),
                                                child: child,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      )
                  ],
                ),
              ),

              // ChatInputBar
              MultiBlocProvider(
                providers: [
                  BlocProvider.value(value: _chatDetailBloc),
                  BlocProvider.value(value: _typingDetectorBloc),
                ],
                child: ChatScreenInputBar(
                  onSend: _sendMessage,
                  chatInputBarKey: _chatInputBarKey,
                  onTypingChanged: (value) => _onTypingStatusChanged(
                    context,
                    isTyping: value,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ElevatedButton _addFriendButton({String label = 'Nói xin chào'}) {
    return ElevatedButton(
      onPressed: () async {
        _friendCubit.addFriend(
          _userInfoBloc.userInfo,
        );
        // var byteData = await getImageFileFromAssets(
        //   Images.img_wave,
        // );
        // var apiFileModel = ApiFileModel(
        //   fileName: GeneratorService.generateFileName(
        //     Images.img_wave.split('/').last,
        //   ),
        //   fileType: MessageType.image,
        //   fileSize: byteData.lengthSync(),
        //   fileDatas: byteData.path,
        // );
        // _sendMessage([
        //   ApiMessageModel(
        //     messageId: GeneratorService.generateMessageId(
        //       _currentUserId,
        //     ),
        //     conversationId: _conversationId,
        //     senderId: _currentUserId,
        //     type: MessageType.image,
        //     files: [
        //       apiFileModel,
        //     ],
        //   ),
        // ]);
      },
      child: Text(label),
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            15,
          ),
        ),
      ),
    );
  }
}

class MessageItem extends StatefulWidget {
  const MessageItem({
    Key? key,
    required this.messageItemModel,
    this.prevMessageItemModel,
    this.nextMessageItemModel,
  }) : super(key: key);

  final SocketSentMessageModel messageItemModel;
  final SocketSentMessageModel? prevMessageItemModel;
  final SocketSentMessageModel? nextMessageItemModel;

  @override
  State<MessageItem> createState() => _MessageItemState();
}

class _MessageItemState extends State<MessageItem>
    with AutomaticKeepAliveClientMixin {
  late SocketSentMessageModel _messageModel;
  late bool _isSentByCurrentUser;
  late final GlobalKey<ChatInputBarState> _chatInputBarKey;
  late final UnreadMessageCounterCubit _unreadMessageCounterCubit;
  late SocketSentMessageModel? _nextMessageItemModel;
  late SocketSentMessageModel? _prevMessageItemModel;
  bool _isInit = false;

  /// Sender avatar
  late Widget _userAvatar;

  /// Sender info
  late UserInfoBloc _userInfoBloc;
  late final ChatBloc _chatBloc;
  late bool _isShowDateTimeDivider;

  // late final AnimationController _animationController;
  late final ReactionCubit _reactionCubit;
  late final ChatDetailBloc _chatDetailBloc;
  late final bool _isMergedUnderMessage;

  late final BorderRadius _borderRadius;

  late Iterable<int> _listUserUnReadThisMessage;

  late List<UserInfoBloc> _listUserReadThisMessage;

  late final _currentUserId;

  late final int _conversationId;

  late final ValueNotifier<double> _msgBoxWidth;

  // late bool _isLastMessage;

  /// Check show avatar và tên (+ thời gian) người gửi
  ///
  /// Show khi tin trước và tin sau khác người gửi,
  ///
  /// Nếu cùng người gửi, thời gian gửi 2 tin nhắn phải cách nhau >= 15p
  late bool _isShowUserListTile;

  late bool _hasRelyMessage;

  late ValueNotifier<bool> _isShowUnreadMessageDivider;

  Widget? _dateTimeDivider;

  late final Widget _unreadMessageDivider;

  late final ValueNotifier<bool> _showLikeButton;

  late ValueNotifier<Duration> _deleteMessageCountdown;

  Timer? _timer;

  int? _tempMessageIndex;

  late Widget likeButton;

  late List<ChoiceDialogItem> choices;

  late final ValueNotifier<MessageStatus> _messageStatusListenable;
  late final bool hasSpeaker;

  /// Bắt đầu cho hiển thị đếm ngược
  _setDeleteTime(Duration duration) {
    try {
      _deleteMessageCountdown.value = duration;
    } catch (e) {}
    if (_messageModel.autoDeleteMessageTimeModel.autoDeleteType ==
        AutoDeleteMessageType.secrect) _startCoundownToDelete();
  }

  _startCoundownToDelete() {
    _timer ??= Timer.periodic(const Duration(seconds: 1), (_) {
      final seconds = _deleteMessageCountdown.value.inSeconds - 1;

      if (seconds <= 0) {
        _chatBloc.add(
          ChatEventEmitDeleteMessage(
            ApiMessageModel(
              messageId: _messageModel.messageId,
              conversationId: _messageModel.conversationId,
              senderId: _messageModel.senderId,
              type: _messageModel.type ?? MessageType.text,
            ),
            _chatDetailBloc.listUserInfoBlocs.keys.toList(),
          ),
        );
        _timer?.cancel();
        _timer = null;
      }

      _deleteMessageCountdown.value = Duration(seconds: seconds);
    });
  }

  @override
  void initState() {
    super.initState();
    _chatBloc = context.read<ChatBloc>();
    _unreadMessageCounterCubit = context.read<UnreadMessageCounterCubit>();
    _nextMessageItemModel = widget.nextMessageItemModel;
    _prevMessageItemModel = widget.prevMessageItemModel;

    _onInit();
  }

  _setMsgBoxWidth(double initWidth) {
    double newValue = initWidth +
        (_deleteMessageCountdown.value.inSeconds != 0
            ? AppConst.kCountDeleteRemainTimeWidgetMaxWidth
            : 0);
    if (_msgBoxWidth.value != newValue) _msgBoxWidth.value = newValue;
  }

  _onInit() async {
    _messageModel = widget.messageItemModel;
    setupCountdown();

    // Duration _d = const Duration(seconds: 0);
    // var autoDeleteMessageTimeModel = _messageModel.autoDeleteMessageTimeModel;
    // if (autoDeleteMessageTimeModel.autoDeleteType != null) {
    //   _d = DateTime.now().difference(autoDeleteMessageTimeModel.deleteDate!);
    // }
    // if (_d.inSeconds >= 0) _setDeleteTime(_d);
    // _deleteMessageCountdown = ValueNotifier(_d);
    hasSpeaker = _messageModel.type == MessageType.applying ||
        _messageModel.type == MessageType.OfferReceive;
    _messageStatusListenable = ValueNotifier(_messageModel.messageStatus);
    _msgBoxWidth = ValueNotifier(_deleteMessageCountdown.value.inSeconds > 0
        ? AppConst.kCountDeleteRemainTimeWidgetMaxWidth + 20
        : 0);

    _showLikeButton = ValueNotifier(_messageModel.type?.isVideoCall == true
        ? false
        : _messageModel.messageStatus != MessageStatus.sending);

    _chatInputBarKey = context.read<GlobalKey<ChatInputBarState>>();

    _currentUserId = context.userInfo().id;

    _hasRelyMessage = _messageModel.hasRelyMessage;

    _reactionCubit = ReactionCubit(
      _messageModel.messageId,
      chatRepo: context.read<ChatRepo>(),
      initEmotions: _messageModel.emotion,
    );

    // final List<Emoji> emojies = [];

    // var reactionState = _reactionCubit.state;
    // var emotions = reactionState.reactions;
    // var lastEmoji = reactionState.lastEmoji;

    _setMsgBoxWidth(_msgBoxWidth.value);
    // _msgBoxWidth.value += AppConst.kCountDeleteRemainTimeWidgetMaxWidth;

    _chatDetailBloc = context.read<ChatDetailBloc>();

    _conversationId = _chatDetailBloc.conversationId;

    _isShowUnreadMessageDivider = ValueNotifier(
        _chatDetailBloc.unreadMessageUserAndMessageId[_currentUserId] ==
            _messageModel.messageId);

    var infoBloc = _chatDetailBloc
        .allUserInfoBlocsAppearInConversation[_messageModel.senderId];

    if (infoBloc != null) {
      _userInfoBloc = infoBloc;
    } else {
      var unknownInfoBloc = UserInfoBloc.unknown(_messageModel.senderId);
      _userInfoBloc = unknownInfoBloc;
      _chatDetailBloc.tempListUserInfoBlocs[_messageModel.senderId] =
          unknownInfoBloc;
    }

    _isSentByCurrentUser = _currentUserId == _messageModel.senderId;

    _isShowDateTimeDivider = _messageModel.createAt.toDmYString() !=
        _prevMessageItemModel?.createAt.toDmYString();

    if (_isShowDateTimeDivider)
      _dateTimeDivider = TextDivider(
        text: _messageModel.createAt.diffWith(
          showTimeStamp: false,
          showSpecialTime: true,
        ),
      );

    _isShowUserListTile = _isShowDateTimeDivider ||
        _prevMessageItemModel?.senderId != _messageModel.senderId ||
        (_prevMessageItemModel == null ||
            _messageModel.createAt
                    .difference(_prevMessageItemModel!.createAt)
                    .inMinutes >=
                15);

    _isMergedUnderMessage =
        _nextMessageItemModel?.senderId == _messageModel.senderId &&
            _nextMessageItemModel!.createAt
                    .difference(_messageModel.createAt)
                    .inMinutes <=
                15;

    bool cutTop = _isShowUserListTile && _isMergedUnderMessage;
    bool cutBot = !cutTop && !_isMergedUnderMessage;

    _borderRadius = AppBorderAndRadius.defaultChatBorder(
      _isSentByCurrentUser,
      cutBot: cutBot,
      cutTop: cutTop,
    );

    _userAvatar = _isShowUserListTile
        ? BlocBuilder<UserInfoBloc, UserInfoState>(
            bloc: _userInfoBloc,
            builder: (_, state) => DisplayAvatar(
              isGroup: false,
              model: state.userInfo,
              enable: _chatDetailBloc.isGroup,
              enabledTapCallback: () => _chatBloc.tryToChatScreen(
                chatInfo: _userInfoBloc.userInfo,
              ),
              // userStatus: state.userInfo.userStatus,
            ),
          )
        : const SizedBox(width: 36); // 36: default avatar size

    _setUpUnreadMessageDivider();

    likeButton = ValueListenableBuilder<bool>(
      valueListenable: _showLikeButton,
      builder: (context, isShow, child) {
        return Visibility(
          visible: isShow,
          child: child!,
        );
      },
      child: _ShowEmotionButton(
        reactionCubit: _reactionCubit,
        key: ValueKey('emoji-btn'),
        onTapLikeButton: () {
          _reactionCubit.like(
            context.userInfo().id,
            _messageModel,
            _chatDetailBloc.listUserInfoBlocs.keys.toList(),
          );
        },
        onSelected: _onReactEmoji,
      ),
    );
  }

  void setupCountdown() {
    Duration _d = const Duration(seconds: 0);
    var autoDeleteMessageTimeModel = _messageModel.autoDeleteMessageTimeModel;
    if (autoDeleteMessageTimeModel.autoDeleteType != null &&
        autoDeleteMessageTimeModel.deleteDate != null) {
      _d = autoDeleteMessageTimeModel.deleteDate!.difference(DateTime.now());
    }
    _deleteMessageCountdown = ValueNotifier(_d);
    if (_d.inSeconds > 0) _setDeleteTime(_d);
  }

  void _onReactEmoji(emoji) => _reactionCubit.changeReaction(
        ChatEventEmitChangeReationMessage(
          _currentUserId,
          _messageModel.messageId,
          _messageModel.conversationId,
          emoji,
          (_reactionCubit.state.reactions[emoji]
                  ?.didReact(context.userInfo().id) ??
              false),
          _messageModel.type ?? MessageType.text,
          _messageModel.message ?? '',
          _chatDetailBloc.listUserInfoBlocs.keys.toList(),
          _reactionCubit.state.reactions[emoji]?.listUserId ?? [],
        ),
      );

  _setShowLikeButtonValue(bool value) {
    if (_messageModel.type?.isVideoCall == true) return;
    if (_showLikeButton.value != value)
      WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
        _showLikeButton.value = value;
      });
  }

  _updateMessageStatus(MessageStatus status) {
    _messageModel.messageStatus = status;
    if (_messageModel.messageStatus != _messageStatusListenable.value)
      _messageStatusListenable.value = status;
  }

  @override
  void didUpdateWidget(covariant MessageItem oldWidget) {
    _nextMessageItemModel = widget.nextMessageItemModel;
    _prevMessageItemModel = widget.prevMessageItemModel;
    _messageModel = widget.messageItemModel;

    setupCountdown();

    _isShowUnreadMessageDivider.value =
        _chatDetailBloc.unreadMessageUserAndMessageId[_currentUserId] ==
            _messageModel.messageId;

    // _setUpUnreadMessageDivider();

    // if (!_isShowDateTimeDivider)
    _isShowDateTimeDivider = _messageModel.createAt.toDmYString() !=
        _prevMessageItemModel?.createAt.toDmYString();

    if (_isShowDateTimeDivider)
      _dateTimeDivider = TextDivider(
        text: _messageModel.createAt.diffWith(
          showTimeStamp: false,
          showSpecialTime: true,
        ),
      );
    super.didUpdateWidget(oldWidget);
  }

  void _setUpUnreadMessageDivider() {
    _unreadMessageDivider = ValueListenableBuilder<bool>(
      valueListenable: _isShowUnreadMessageDivider,
      builder: (_, isShow, child) {
        if (isShow && _messageModel.senderId == _currentUserId) {
          if (_unreadMessageCounterCubit.hasUnreadMessage)
            _chatBloc.markReadMessages(
              senderId: _currentUserId,
              conversationId: _conversationId,
              memebers: _chatDetailBloc.listUserInfoBlocs.keys.toList(),
            );
          return const SizedBox();
        }
        return Visibility(
          visible: isShow,
          child: child!,
        );
      },
      child: VisibilityDetector(
        key: ValueKey(_messageModel.messageId),
        onVisibilityChanged: _readMessageOnVisibilityChanged,
        child: TextDivider(
          text: 'Tin nhắn chưa đọc',
          color: AppColors.red,
        ),
      ),
    );
  }

  @override
  void dispose() {
    // _animationController.dispose();
    _reactionCubit.close();
    try {
      _listUserReadThisMessage.forEach((e) => e.close());
    } catch (e) {}
    Fluttertoast.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (_isShowUnreadMessageDivider.value) {
      _isShowUnreadMessageDivider.value =
          _chatDetailBloc.unreadMessageUserAndMessageId[_currentUserId] ==
              _messageModel.messageId;
    }

    var nameAndTimeText = BlocBuilder<UserInfoBloc, UserInfoState>(
      bloc: _userInfoBloc,
      builder: (_, state) => Text(
        (!_isSentByCurrentUser ? '${state.userInfo.name}, ' : '') +
            _messageModel.createAt.toHmString(),
        style: AppTextStyles.regularW400(
          context,
          size: 12,
          color: AppColors.doveGray,
          lineHeight: 15,
        ),
      ),
    );

    var seenUsers = BlocConsumer<ChatDetailBloc, ChatDetailState>(
      listenWhen: (_, current) => current is ChatDetailStateMarkReadMessage,
      listener: (_, state) {
        if (_messageModel.autoDeleteMessageTimeModel.autoDeleteType ==
                AutoDeleteMessageType.secrect &&
            _timer?.isActive != true) _startCoundownToDelete();
      },
      buildWhen: (prev, current) =>
          current is ChatDetailStateMarkReadMessage &&
          // Không cần hiển thị mặt mình nên không cần build khi người đọc là mình
          current.senderId != _currentUserId &&
          // Tin nhắn cuối cùng
          (_nextMessageItemModel == null ||
              // Tin nhắn tiếp theo là tin nhắn chưa đọc của [current.senderId]
              // _nextMessageItemModel?.messageId ==
              //     _chatDetailBloc
              //         .unreadMessageUserAndMessageId[current.senderId]),
              _listUserReadThisMessage
                  .map((e) => e.userInfo.id)
                  .contains(current.senderId)),
      builder: (context, state) {
        if (_isInit && state is ChatDetailStateMarkReadMessage) {
          if (_nextMessageItemModel == null) {
            try {
              var senderInfo =
                  _chatDetailBloc.listUserInfoBlocs[state.senderId];
              if (senderInfo?.userInfo.id != _currentUserId &&
                  senderInfo != null &&
                  !_listUserReadThisMessage
                      .map((e) => e.userInfo.id)
                      .contains(senderInfo.userInfo.id))
                _listUserReadThisMessage
                    .add(_chatDetailBloc.listUserInfoBlocs[state.senderId]!);
            } catch (e) {}
          } else
            _listUserReadThisMessage
                .removeWhere((e) => e.userInfo.id == state.senderId);
        } else if (!_isInit) {
          _listUserUnReadThisMessage =
              _chatDetailBloc.listUserIdUnreadMessageId(
            _messageModel.messageId,
          );
          // logger.log(
          //   _chatDetailBloc.listUserInfoBlocs.values.map((e) => e.hashCode),
          //   name: _messageModel.messageId,
          // );
          // logger.log(
          //   [..._chatDetailBloc.listUserInfoBlocs.values]
          //       .map((e) => e.hashCode),
          //   name: _messageModel.messageId,
          // );
          _listUserReadThisMessage = ([
            ..._chatDetailBloc.listUserInfoBlocs.values
          ]..removeWhere((e) =>
              _chatDetailBloc.unreadMessageUserAndMessageId[e.userInfo.id] !=
                  _nextMessageItemModel?.messageId ||
              _listUserUnReadThisMessage.contains(e.userInfo.id) ||
              e.userInfo.id == _currentUserId));
          _isInit = true;
        }

        // if (!_messageModel.message.isBlank &&
        //     _messageModel.status != MessageStatus.deleted)
        //   logger.log(
        //     '${_messageModel.message}(${_messageModel.messageId}): ${_listUserReadThisMessage.map((e) => e.userInfo.name)}',
        //     name: 'LogReader',
        //   );

        // _listUserReadThisMessage = ;

        var row = Row(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(width: 10),
            ..._listUserReadThisMessage
                .slice(end: 4)
                .map(
                  (e) => DisplayAvatar(
                    isGroup: false,
                    model: e.userInfo,
                    size: 18,
                    enable: false,
                  ),
                )
                .toList(),
            if (_listUserReadThisMessage.length > 4)
              CircleAvatar(
                radius: 20 / 2,
                backgroundColor: AppColors.greyCC,
                child: Center(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      '+${_listUserReadThisMessage.length - 4}',
                      style: AppTextStyles.regularW400(
                        context,
                        size: 12,
                        color: AppColors.tundora,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
        return Container(
          key: ValueKey(_messageModel.messageId),
          // padding: const EdgeInsets.only(bottom: 4.0),
          alignment: Alignment.centerRight,
          child: InkWell(
            onTap: () {
              Map<IUserInfo, DateTime> detail = {};
              for (var user in _listUserReadThisMessage) {
                detail[user.userInfo] =
                    _chatDetailBloc.readMessageTime[user.userInfo.id] ??
                        DateTime.now();
              }
              AppDialogs.showReadMessageDialog(
                context,
                detail,
              );
            },
            child: row,
          ),
        );
      },
    );

    choices = [
      if (_messageModel.type?.isText == true) ...[
        ChoiceDialogTypes.pinMessage(
          context,
          messageId: _messageModel.messageId,
          messageContent: _messageModel.message ?? '',
        ),
      ] else if (_messageModel.type?.isLink == true)
        ChoiceDialogTypes.copy(
          context,
          content: _messageModel.infoLink?.link ?? _messageModel.message,
          text: StringConst.copyUrl,
        ),
      if (_hasRelyMessage && !_messageModel.relyMessage!.message.isBlank)
        ChoiceDialogTypes.copy(
          context,
          content: _messageModel.relyMessage!.message,
          text: StringConst.copyReplyMessage,
        ),
      if (_messageModel.type?.isMap == false &&
          _messageModel.type?.isVideoCall == false)
        ChoiceDialogTypes.forward(
          context,
          message: _messageModel,
          senderInfo: _userInfoBloc.state.userInfo,
        ),
      if (_isSentByCurrentUser)
        ChoiceDialogTypes.delete(
          context,
          message: ApiMessageModel(
            messageId: _messageModel.messageId,
            conversationId: _messageModel.conversationId,
            senderId: _messageModel.senderId,
            type: _messageModel.type ?? MessageType.text,
          ),
          members: _chatDetailBloc.listUserInfoBlocs.keys.toList(),
        ),
    ];

    /// [MessageType.notification] là trường hợp đặc biệt, chỉ cần show text
    if (_messageModel.type?.isNotification ?? false) {
      return BlocListener<ChatDetailBloc, ChatDetailState>(
        listenWhen: (prev, current) {
          return current is ChatDetailStateMarkReadMessage &&
              current.senderId == _currentUserId;
        },
        listener: (context, state) {
          if (state is ChatDetailStateMarkReadMessage &&
              state.senderId == _currentUserId) {
            _isShowUnreadMessageDivider.value = false;
          }
        },
        child: Container(
          alignment: Alignment.center,
          margin: EdgeInsets.only(top: 12, bottom: 4),
          child: Column(
            children: [
              if (_isShowDateTimeDivider) _dateTimeDivider!,
              _unreadMessageDivider,
              BlocBuilder<ChatBloc, ChatState>(
                buildWhen: (previous, current) =>
                    current is ChatStateSendMessageSuccess &&
                    current.messageId == _messageModel.messageId,
                builder: (context, chatState) {
                  if (chatState is ChatStateSendMessageSuccess &&
                      chatState.messageId == _messageModel.messageId) {
                    _onSendMessageSuccessSetUserReadMessage();
                  }
                  return NotificationMessageDisplay(
                    message: _messageModel.message,
                    listUserInfos:
                        _chatDetailBloc.allUserInfoBlocsAppearInConversation,
                    conversationId: _conversationId,
                    onGetUnknownUserIdsFound: (blocs) {
                      for (var bloc in blocs) {
                        _chatDetailBloc
                            .tempListUserInfoBlocs[bloc.userInfo.id] = bloc;
                      }
                    },
                  );
                },
              ),
              seenUsers,
            ],
          ),
        ),
      );
    }

    var reactionBar = BlocBuilder<ReactionCubit, ReactionState>(
      bloc: _reactionCubit,
      builder: (context, state) {
        var emotions = state.reactions;
        var lastEmoji = state.lastEmoji;
        var remain = 0;
        int? remainIndex;

        final List<Emoji> emojies = [];

        for (var emoji in Emoji.values) {
          if (emotions[emoji]?.listUserId.isNotEmpty == true) {
            if (emojies.length < 3 && emoji != lastEmoji)
              emojies.add(emoji);
            else if (emojies.length >= 3) {
              if (remainIndex == null && emoji != lastEmoji)
                remainIndex = emoji.id;
              remain++;
            }
          }
        }

        if (lastEmoji != null)
          emojies.length <= 2
              ? emojies.add(lastEmoji)
              : emojies.length >= 1
                  ? emojies[emojies.length - 1] = lastEmoji
                  : null;

        if (emojies.isNotEmpty)
          WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
            _setMsgBoxWidth(
              emojies.length * (AppConst.kEmotionSize + 20) +
                  28 + // 20 + 8
                  AppConst.kLikeButtonSize,
            );
          });

        if (_tempMessageIndex != null) {
          if (_tempMessageIndex! >= _chatDetailBloc.msgs.length - 1 &&
              _messageModel.messageId == _chatDetailBloc.msgs.last.messageId)
            _tempMessageIndex = _chatDetailBloc.msgs.length - 1;
          _chatDetailBloc.msgs[_tempMessageIndex!].emotion = state.reactions;
        }

        // if (_nextMessageItemModel == null)
        //   _setShowLikeButtonValue(true);
        // else if (emojies.isNotEmpty)
        //   _setShowLikeButtonValue(true);
        // else
        //   _setShowLikeButtonValue(false);

        return _ReactionBar(
          remain: remain,
          remainIndex: remainIndex,
          emojies: emojies.map((e) => emotions[e]!).toList(),
          onTapEmoji: (emoij) => AppDialogs.showReactionDetailDialog(
            context,
            initIndex: emoij.id - 1,
            reactions: state.reactions,
            users:
                _chatDetailBloc.listUserInfoBlocs.values.map((e) => e.userInfo),
          ),
        );
      },
    );

    var msgBox = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_isSentByCurrentUser)
          Padding(
            padding: const EdgeInsets.only(right: 4),
            child: ValueListenableBuilder<MessageStatus>(
              valueListenable: _messageStatusListenable,
              builder: (_, status, __) {
                if (status == MessageStatus.sending ||
                    status == MessageStatus.deleting)
                  return Text(
                    status.name,
                    style: AppTextStyles.regularW400(
                      context,
                      size: 12,
                      color: AppColors.boulder,
                    ),
                  );
                else if (status == MessageStatus.sendError)
                  return Icon(
                    Icons.warning_amber_rounded,
                    color: AppColors.red,
                    size: 24,
                  );
                else if (status == MessageStatus.edited)
                  return Icon(
                    Icons.edit_outlined,
                    color: AppColors.greyCC,
                    size: 24,
                  );
                return const SizedBox(key: ValueKey('none'));
              },
            ),
          ),
        Stack(
          clipBehavior: Clip.none,
          alignment: _isSentByCurrentUser
              ? Alignment.bottomLeft
              : Alignment.bottomRight,
          children: [
            ValueListenableBuilder<bool>(
              valueListenable: _showLikeButton,
              builder: (context, isShow, child) {
                var msgBoxPadding = isShow
                    ? EdgeInsets.only(
                        left: _isSentByCurrentUser
                            ? AppConst.kEmotionSize / 2
                            : 0,
                        right: _isSentByCurrentUser
                            ? 0
                            : AppConst.kEmotionSize / 2,
                        bottom: AppConst.kEmotionSize / 2 + 6,
                      )
                    : const EdgeInsets.all(2);
                return Padding(
                  padding: msgBoxPadding,
                  child: child!,
                );
              },
              child: BlocListener<ChatBloc, ChatState>(
                bloc: _chatBloc,
                listenWhen: _messageBoxBuildWhen,
                listener: (_, chatState) {
                  _setShowLikeButtonValue(true);
                  if (chatState is ChatStateRecieveMessage) {
                    setState(() {
                      _messageModel = chatState.msg;
                    });
                    // _updateMessageStatus(MessageStatus.normal);
                    var index = _chatDetailBloc.msgs.indexWhere(
                        (e) => e.messageId == _messageModel.messageId);
                    if (index != -1) {
                      _tempMessageIndex = index;
                      _chatDetailBloc.msgs[index] = chatState.msg;
                    }
                  } else if (chatState is ChatStateSendMessageSuccess) {
                    _updateMessageStatus(MessageStatus.normal);
                  } else if (chatState is ChatStateSendMessageError) {
                    _setShowLikeButtonValue(false);
                    _updateMessageStatus(MessageStatus.sendError);
                  } else if (chatState is ChatStateInProcessingMessage) {
                    _setShowLikeButtonValue(false);
                    if (chatState.processingType == ProcessMessageType.deleting)
                      _updateMessageStatus(MessageStatus.deleting);
                    else
                      _updateMessageStatus(MessageStatus.sending);
                  } else if (chatState is ChatStateEditMessageSuccess) {
                    _updateMessageStatus(MessageStatus.edited);
                    _messageModel = _messageModel.copyWith(
                      type: _messageModel.type,
                      message: chatState.newMessage,
                      status: MessageStatus.edited,
                    );
                    setState(() {});
                    var index = _chatDetailBloc.msgs
                        .indexWhere((e) => e.messageId == chatState.messageId);
                    if (index != -1)
                      _chatDetailBloc.msgs[index] = _messageModel;
                  } else if (chatState is ChatStateWarningMessageError) {
                    _updateMessageStatus(MessageStatus.sendError);
                  } else if (chatState is ChatStateDeleteMessageSuccess) {
                    // final msgs = _chatDetailBloc.msgs;
                    final String deletedMessageId = chatState.messageId;

                    /// Đối với tin nhắn mà tin nhắn phía trước là tin nhắn bị xóa
                    if (_prevMessageItemModel?.messageId == deletedMessageId) {
                      _prevMessageItemModel = chatState.messageAbove;
                      Future.delayed(Duration(milliseconds: 300), () {
                        if (mounted)
                          setState(() {
                            _isInit = false;
                          });
                        // logger.log(
                        //   'New PrevMessage of ${_messageModel.message}(${_messageModel.messageId}) is ${_prevMessageItemModel?.message}(${_prevMessageItemModel?.messageId})',
                        //   name: 'LogReader_NewPrev',
                        // );
                      });
                    }

                    /// Đối với tin nhắn mà tin nhắn tiếp theo là tin nhắn bị xóa
                    else if (_nextMessageItemModel?.messageId ==
                        deletedMessageId) {
                      _nextMessageItemModel = chatState.messageBelow;
                      Future.delayed(Duration(milliseconds: 300), () {
                        if (mounted)
                          setState(() {
                            _isInit = false;
                          });
                        // logger.log(
                        //   'New NextMessage of ${_messageModel.message}(${_messageModel.messageId}) is ${_nextMessageItemModel?.message}(${_nextMessageItemModel?.messageId})',
                        //   name: 'LogReader_NewNext',
                        // );
                      });
                    }

                    /// Đối với tin nhắn mà tin nhắn hiện tại là tin nhắn bị xóa
                    else {
                      _updateMessageStatus(MessageStatus.deleted);

                      _chatDetailBloc.unreadMessageUserAndMessageIndex
                          .forEach((userId, index) {
                        _chatDetailBloc
                                .unreadMessageUserAndMessageIndex[userId] =
                            index - 1;
                      });

                      final String? nextMessageId =
                          chatState.messageBelow?.messageId;

                      // logger.log(
                      //   '======================================================\nReader: ${_listUserReadThisMessage.map((e) => e.userInfo.id)}\n',
                      //   name: 'LogReader_UnreadMessageUserAndMessageId',
                      // );

                      /// Nếu tin nhắn tiếp theo không phải tin nhắn cuối cùng
                      ///
                      /// - Set unreadMessageId của những người đã xem tin nhắn này thành tin nhắn tiếp theo
                      /// - Set unreadMessageId của những người mà tin nhắn chưa xem là tin nhắn này thành tin nhắn tiếp theo
                      if (nextMessageId != null)
                        for (int userId in [
                          ..._listUserReadThisMessage.map((e) => e.userInfo.id),
                          ..._chatDetailBloc.unreadMessageUserAndMessageId.keys
                              .where(
                            (e) =>
                                _chatDetailBloc
                                    .unreadMessageUserAndMessageId[e] ==
                                deletedMessageId,
                          ),
                        ])
                          _chatDetailBloc
                                  .unreadMessageUserAndMessageId[userId] =
                              nextMessageId;

                      /// Còn nếu tin nhắn tiếp theo là tin nhắn cuối cùng
                      /// Set tin nhắn chưa xem của những người này thành null
                      else {
                        for (var user in _listUserReadThisMessage) {
                          var userId = user.userInfo.id;
                          _chatDetailBloc.unreadMessageUserAndMessageId
                              .remove(userId);
                          _chatDetailBloc
                              .unreadMessageUserAndMessageIndex[userId] = 0;
                        }
                      }
                      // logger.log(
                      //   'DeletedMessageId: \n{Prev: ${chatState.messageAbove?.messageId}\nDeleted: ${chatState.messageId}\nNext: ${chatState.messageBelow?.messageId}}\n=========================================================',
                      //   name: 'LogReader_UnreadMessageUserAndMessageId',
                      // );
                      // logger.log(
                      //   'UnreadMessageUserAndMessageId: ${_chatDetailBloc.unreadMessageUserAndMessageId}',
                      //   name: 'LogReader_UnreadMessageUserAndMessageId',
                      // );
                      _chatDetailBloc.msgs.removeAt(chatState.messageIndex!);
                    }
                  }
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    ValueListenableBuilder<double>(
                      valueListenable: _msgBoxWidth,
                      builder: (context, width, child) {
                        return ConstrainedBox(
                          constraints: BoxConstraints(
                            minWidth: width,
                          ),
                          child: child,
                        );
                      },
                      child: MessageBox(
                        messageModel: _messageModel,
                        hasReplyMessage: _hasRelyMessage,
                        isSentByCurrentUser: _isSentByCurrentUser,
                        borderRadius: _borderRadius,
                        listUserInfoBlocs: _chatDetailBloc.listUserInfoBlocs,
                      ),
                    ),
                    if (_chatBloc
                            .fileProgressListener[_messageModel.messageId] !=
                        null)
                      SizedBox.square(
                        dimension: 40,
                        child: ValueListenableBuilder<double>(
                          valueListenable: _chatBloc
                              .fileProgressListener[_messageModel.messageId]!,
                          builder: (_, progress, __) => progress == 1
                              ? const SizedBox()
                              : CircularPercentIndicator(
                                  radius: 20,
                                  percent: progress,
                                ),
                        ),
                      )
                  ],
                ),
              ),
            ),
            Positioned(
              left: _isSentByCurrentUser ? -12 : null,
              right: _isSentByCurrentUser ? null : -12,
              bottom: -AppConst.kLikeButtonSize / 2 + 8,
              child: Row(
                children: [
                  likeButton,
                  if (_messageModel
                      .autoDeleteMessageTimeModel.isAutoDeleteMessage)
                    ValueListenableBuilder<Duration>(
                      valueListenable: _deleteMessageCountdown,
                      builder: (_, myDuration, child) {
                        final hours = myDuration.inHours;
                        final minutes = myDuration.inMinutes.remainder(60);
                        final seconds = myDuration.inSeconds.remainder(60);
                        return Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: context.theme.backgroundColor,
                            // boxShadow: [
                            //   BoxShadow(
                            //     color: AppColors.black.withOpacity(10),
                            //     offset: const Offset(0, 2),
                            //     blurRadius: 4,
                            //   ),
                            // ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              child!,
                              Text(
                                '  $hours:$minutes:$seconds  ',
                                style: AppTextStyles.regularW400(
                                  context,
                                  size: 12,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      child: SvgPicture.asset(
                        Images.ic_timer_pause,
                        height: 14,
                        width: 14,
                      ),
                    ),
                ],
              ),
            ),
            Positioned(
              left: _isSentByCurrentUser ? null : 0,
              right: _isSentByCurrentUser ? 0 : null,
              child: reactionBar,
            ),
            if (hasSpeaker)
              Positioned(
                left: _isSentByCurrentUser ? -12 : null,
                right: _isSentByCurrentUser ? null : -12,
                top: -AppConst.kLikeButtonSize / 2 + 8,
                child: Image.asset(
                  !_isSentByCurrentUser
                      ? Images.img_notify_message
                      : Images.img_my_notify_message,
                  width: 50,
                  height: 50,
                ),
              ),
          ],
        ),
        if (!_isSentByCurrentUser)
          ValueListenableBuilder<MessageStatus>(
            valueListenable: _messageStatusListenable,
            builder: (_, status, __) {
              if (status == MessageStatus.edited)
                return Icon(
                  Icons.edit_outlined,
                  color: AppColors.greyCC,
                  size: 24,
                );
              return const SizedBox(key: ValueKey('none'));
            },
          ),
      ],
    );

    var rowItem = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: _isSentByCurrentUser
          ? MainAxisAlignment.end
          : MainAxisAlignment.start,
      children: [
        if (!_isSentByCurrentUser) _userAvatar,
        const SizedBox(width: 4),
        if (_isSentByCurrentUser) ...[
          const SizedBox(width: 4),
          msgBox,
        ] else ...[
          msgBox,
        ],
      ],
    );

    return ValueListenableBuilder<MessageStatus>(
      valueListenable: _messageStatusListenable,
      builder: (context, status, child) {
        return Visibility(
          visible: status != MessageStatus.deleted,
          child: AbsorbPointer(
            absorbing: !status.enableInteractive,
            child: child!,
          ),
        );
      },
      child: BlocListener<ChatDetailBloc, ChatDetailState>(
        listenWhen: (prev, current) {
          return current is ChatDetailStateMarkReadMessage &&
              current.senderId == _currentUserId;
        },
        listener: (context, state) {
          if (state is ChatDetailStateMarkReadMessage &&
              state.senderId == _currentUserId) {
            _isShowUnreadMessageDivider.value = false;
          }
        },
        child: Column(
          key: ValueKey('column'),
          crossAxisAlignment: _isSentByCurrentUser
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            // const SizedBox(height: 4),
            if (_isShowDateTimeDivider) _dateTimeDivider!,
            _unreadMessageDivider,
            if (_isShowUserListTile)
              Padding(
                padding: EdgeInsets.only(
                  top: 16,
                  bottom: 2,
                  left: 40,
                ),
                child: nameAndTimeText,
              ),
            InkWell(
              overlayColor: MaterialStateProperty.all(Colors.transparent),
              highlightColor: Colors.transparent,
              onDoubleTap: _showActionBottomSheet,
              onLongPress: _showActionBottomSheet,
              child: rowItem,
            ),
            // const SizedBox(height: 2),
            seenUsers,
            if (_nextMessageItemModel == null)
              const SizedBox(height: 40)
            else
              SizedBox(height: hasSpeaker ? 10 : 2),
          ],
        ),
      ),
    );
  }

  bool _messageBoxBuildWhen(ChatState _, ChatState chatState) {
    if (chatState is! ChatMessageState ||
        (chatState is ChatStateDeleteMessageSuccess &&
            chatState.messageIndex == null)) return false;
    final String messageId = chatState.messageId;
    return messageId == _messageModel.messageId ||
        (chatState is ChatStateDeleteMessageSuccess &&
            (messageId == _nextMessageItemModel?.messageId ||
                messageId == _prevMessageItemModel?.messageId));
  }

  void _readMessageOnVisibilityChanged(VisibilityInfo info) async {
    if (_isShowUnreadMessageDivider.value && info.visibleFraction == 1.0) {
      await Future.delayed(const Duration(milliseconds: 200));
      if (_unreadMessageCounterCubit.hasUnreadMessage)
        _chatBloc.markReadMessages(
          senderId: _currentUserId,
          conversationId: _conversationId,
          memebers: _chatDetailBloc.listUserInfoBlocs.keys.toList(),
        );
    }
  }

  _showActionBottomSheet() {
    var reactions = _reactionCubit.state.reactions;
    return AppDialogs.showModalBottomSheetChoicesDialog(
      context,
      title: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: _isSentByCurrentUser
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!_isSentByCurrentUser)
                DisplayAvatar(
                  isGroup: false,
                  model: _userInfoBloc.state.userInfo,
                ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: AppConst.maxMessageBoxWidth,
                    minHeight: 0,
                  ),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: MessageBox(
                      isSentByCurrentUser: _isSentByCurrentUser,
                      messageModel: _messageModel,
                      listUserInfoBlocs: _chatDetailBloc.listUserInfoBlocs,
                      hasReplyMessage: _hasRelyMessage,
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (_messageModel.type?.isVideoCall == false)
            Card(
              margin: EdgeInsets.symmetric(vertical: 8),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 2.0),
                child: EmojiBar(
                  emotion: reactions,
                  onSelected: _onReactEmoji,
                ),
              ),
            ),
        ],
      ),
      choices: [
        if (_messageModel.type?.isText == true)
          ChoiceDialogTypes.copy(
            context,
            content: _messageModel.message,
          ),
        ...choices,
        if (_messageModel.type?.isText == true)
          ChoiceDialogTypes.reply(
            context,
            chatInputBarKey: _chatInputBarKey,
            replyModel: ApiRelyMessageModel(
              senderId: _userInfoBloc.state.userInfo.id,
              senderName: _userInfoBloc.state.userInfo.name,
              message: _messageModel.message,
              createAt: _messageModel.createAt,
              messageId: _messageModel.messageId,
            ),
          ),
        if (_isSentByCurrentUser && _messageModel.type?.isEditable == true)
          ChoiceDialogTypes.edit(
            context,
            message: _messageModel,
            chatInputBarKey: _chatInputBarKey,
          ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;

  void _onSendMessageSuccessSetUserReadMessage() {
    // _computeIsLastMessage();

    // if (_isLastMessage) {
    //   _animationController.clearStatusListeners();
    //   _animationController.forward();
    // }

    // WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
    //   if (mounted) setState(() {});
    // });
  }
}

class _ReactionBar extends StatelessWidget {
  const _ReactionBar({
    Key? key,
    required this.emojies,
    this.onTapEmoji,
    this.remain = 0,
    this.remainIndex,
  }) : super(key: key);

  final ValueChanged<Emoji>? onTapEmoji;
  final List<Emotion> emojies;
  final int remain;
  final int? remainIndex;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ...emojies
            .map((e) => InkWell(
                  onTap: onTapEmoji != null ? () => onTapEmoji!(e.type) : null,
                  child: Container(
                    decoration: AppDecoration.emojiDecoration,
                    child: Row(
                      children: [
                        Image.asset(
                          e.type.assetPath,
                          width: AppConst.kEmotionSize,
                          height: AppConst.kEmotionSize,
                        ),
                        // const SizedBox(width: 5),
                        Text(
                          e.listUserId.length.toString(),
                          style: AppTextStyles.regularW400(
                            context,
                            size: 12,
                            color: AppColors.lightThemeTextColor,
                          ),
                        ),
                        const SizedBox(width: 10),
                      ],
                    ),
                  ),
                ))
            .toList(),
        if (remain != 0)
          InkWell(
            onTap: () =>
                onTapEmoji!(Emoji.fromId(remainIndex ?? emojies[0].type.id)),
            child: Container(
              margin: EdgeInsets.only(left: 20),
              height: AppConst.kEmotionSize,
              width: AppConst.kEmotionSize,
              alignment: Alignment.center,
              decoration: AppDecoration.emojiDecoration,
              child: Text(
                '+$remain',
                style: AppTextStyles.regularW400(
                  context,
                  size: 16,
                  color: AppColors.tundora,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _ShowEmotionButton extends StatelessWidget {
  const _ShowEmotionButton({
    Key? key,
    this.onSelected,
    required this.reactionCubit,
    required this.onTapLikeButton,
  }) : super(key: key);

  final ValueChanged<Emoji>? onSelected;
  final ReactionCubit reactionCubit;
  final VoidCallback onTapLikeButton;

  @override
  Widget build(BuildContext context) {
    final GlobalKey _key = GlobalKey();

    _showReactionBar(
      BuildContext buildContext,
      Map<Emoji, Emotion> emotion,
    ) {
      final Offset _pos = (_key.currentContext!.findRenderObject() as RenderBox)
          .localToGlobal(Offset.zero);
      customShowMenu(
        context: buildContext,
        position: RelativeRect.fromLTRB(_pos.dx, _pos.dy - 50, 0, 0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 8.0,
        items: [
          CustomPopupMenuItem(
            padding: EdgeInsets.zero,
            enabled: false,
            height: 50,
            child: EmojiBar(
              emotion: emotion,
              onSelected: onSelected,
            ),
          )
        ],
      );
    }

    _onLongPress() => _showReactionBar(
          context,
          reactionCubit.state.reactions,
        );

    var child = BlocListener<ReactionCubit, ReactionState>(
      bloc: reactionCubit,
      listener: (context, state) {
        if (state is ReactionStateChangeReactionError) {
          AppDialogs.toast(state.error.error);
        }
      },
      child: SvgPicture.asset(
        Images.ic_thumb_up,
        width: AppConst.kLikeIconSize,
        height: AppConst.kLikeIconSize,
        color: AppColors.dustyGray,
      ),
    );

    return MaterialButton(
      key: _key,
      shape: CircleBorder(
        side: BorderSide(
          color: AppColors.black.withOpacity(0.15),
          width: 0.5,
        ),
      ),
      color: AppColors.white,
      child: child,
      elevation: 4,
      onPressed: onTapLikeButton,
      height: AppConst.kLikeButtonSize,
      minWidth: AppConst.kLikeButtonSize,
      onLongPress: _onLongPress,
      onHighlightChanged: (_) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
    );
  }
}
