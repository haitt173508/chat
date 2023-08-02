import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:chat_365/common/blocs/network_cubit/network_cubit.dart';
import 'package:chat_365/common/blocs/suggest_contact_cubit/cubit/suggest_contact_cubit.dart';
import 'package:chat_365/common/blocs/theme_cubit/theme_cubit.dart';
import 'package:chat_365/common/blocs/user_info_bloc/bloc/user_info_bloc.dart';
import 'package:chat_365/common/blocs/user_info_bloc/bloc/user_info_event.dart';
import 'package:chat_365/common/components/modal_bottom_sheet_item.dart';
import 'package:chat_365/common/images.dart';
import 'package:chat_365/common/widgets/conversation_item.dart';
import 'package:chat_365/common/widgets/custom_refresh_indicator.dart';
import 'package:chat_365/common/widgets/navigator_search_field.dart';
import 'package:chat_365/common/widgets/user_list_tile_appbar.dart';
import 'package:chat_365/core/constants/app_constants.dart';
import 'package:chat_365/core/constants/string_constants.dart';
import 'package:chat_365/main.dart';
import 'package:chat_365/modules/chat/blocs/chat_bloc/chat_bloc.dart';
import 'package:chat_365/modules/chat/blocs/chat_detail_bloc/chat_detail_bloc.dart';
import 'package:chat_365/modules/chat/model/chat_member_model.dart';
import 'package:chat_365/modules/chat/model/result_socket_chat.dart';
import 'package:chat_365/modules/chat_conversations/bloc/chat_conversation_bloc.dart';
import 'package:chat_365/modules/chat_conversations/models/result_chat_conversation.dart';
import 'package:chat_365/modules/chat_conversations/widget/chat_conversation_body.dart';
import 'package:chat_365/modules/contact/widget/suggest_contact_widget.dart';
import 'package:chat_365/modules/new_conversation/conversation_creation_repo.dart';
import 'package:chat_365/modules/new_conversation/create_conversation_cubit/create_conversation_cubit.dart';
import 'package:chat_365/modules/new_conversation/models/group_conversation_creation_kind.dart';
import 'package:chat_365/router/app_pages.dart';
import 'package:chat_365/router/app_router.dart';
import 'package:chat_365/router/app_router_helper.dart';
import 'package:chat_365/service/app_service.dart';
import 'package:chat_365/service/firebase_service.dart';
import 'package:chat_365/service/injection.dart';
import 'package:chat_365/service/local_message_notification_service.dart';
import 'package:chat_365/utils/data/enums/auth_status.dart';
import 'package:chat_365/utils/data/enums/fileter_conversation_by.dart';
import 'package:chat_365/utils/data/enums/message_type.dart';
import 'package:chat_365/utils/data/extensions/context_extension.dart';
import 'package:chat_365/utils/data/extensions/date_time_extension.dart';
import 'package:chat_365/utils/helpers/logger.dart';
import 'package:chat_365/utils/ui/app_dialogs.dart';
import 'package:chat_365/utils/ui/app_padding.dart';
import 'package:chat_365/utils/ui/widget_utils.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:visibility_detector/visibility_detector.dart';

class ChatConversationScreen extends StatefulWidget {
  const ChatConversationScreen({Key? key}) : super(key: key);

  @override
  State<ChatConversationScreen> createState() => _ChatConversationScreenState();
}

class _ChatConversationScreenState extends State<ChatConversationScreen>
    with WidgetsBindingObserver {
  late final ChatConversationBloc _chatConversationBloc;

  late final NetworkCubit _networkCubit;

  late final SuggestContactCubit _suggestContactCubit;

  late final List<MbsOption> newChatItems;

  late final UserInfoBloc _userInfoBloc;

  final ScrollController _scrollController = ScrollController();

  late final Widget _favoriteHeader, _nearestHeader, _suggestAddFriendHeader;
  bool didNavigateToAppSettings = false;

  DateTime _lastTimeFetchSuccess = AppConst.defaultFirstTimeFetchSuccess;

  @override
  void initState() {
    super.initState();
    _chatConversationBloc = context.read<ChatConversationBloc>();
    _networkCubit = context.read<NetworkCubit>();
    _suggestContactCubit = context.read<SuggestContactCubit>();
    _scrollController.addListener(_scrollListener);
    _userInfoBloc = context.read<UserInfoBloc>()
      ..add(UserInfoEventActiveTimeChanged(
        context.userInfo().id,
        AuthStatus.authenticated,
        lastActive: null,
      ));

    _favoriteHeader = SmallHeader(
      text: FilterConversationBy.favorite.name,
    );
    _nearestHeader = SmallHeader(
      text: FilterConversationBy.nearest.name,
    );
    _suggestAddFriendHeader = SmallHeader(
      text: 'Gợi ý kết bạn',
    );

    newChatItems = [
      // MbsOption(
      //   title: StringConst.addFriend1,
      //   pathToSvgIcon: Images.ic_fluent_people_add,
      // ),
      MbsOption(
        pathToSvgIcon: Images.ic_message_group_new,
        title: StringConst.createNewGroupConversation,
        onTap: (context) {
          var cubit = CreateConversationCubit(
            repo: ConversationCreationRepo(),
          );
          AppRouter.toPage(
            context,
            AppPages.NewConversation_CreateGroup,
            blocValue: cubit,
            arguments: {
              'type': GroupConversationCreationKind.public,
              // 'chatMessagesRepo': context.read<ChatMessagesRepo>(),
              // 'userNameRepo': context.read<UserNameRepo>(),
            },
          );
        },
      ),
      // MbsOption(
      //   title: StringConst.createNewBrowseGroup,
      //   pathToSvgIcon: Images.ic_censor_group,
      //   // onTap: (context) => AppRouter.toPage(
      //   //   context,
      //   //   AppPages.NewConversation_CreateGroup,
      //   // arguments: {
      //   //   'type': GroupConversationCreationKind.needModeration,
      //   //   'chatMessagesRepo': context.read<ChatMessagesRepo>(),
      //   //   'userNameRepo': context.read<UserNameRepo>(),
      //   // },
      //   // ),
      // ),
      // MbsOption(
      //   title: StringConst.createNewConversation,
      //   pathToSvgIcon: Images.ic_add_message,
      //   // onTap: (context) => AppRouter.toPage(
      //   //   context,
      //   //   AppPages.NewConversation_Create,
      //   // arguments: {
      //   //   'type': ConversationCreationKind.normal,
      //   // },
      //   // ),
      // ),
      // MbsOption(
      //   title: StringConst.createNewPrivateConversation,
      //   pathToSvgIcon: Images.ic_secret_chat,
      // ),
      MbsOption(
          title: StringConst.loginHistory,
          pathToSvgIcon: Images.ic_login_history,
          onTap: (context) {
            var cubit = CreateConversationCubit(
              repo: ConversationCreationRepo(),
            );
            AppRouter.toPage(
              context,
              AppPages.Login_History_Screen,
              blocValue: cubit,
            );
          }),
    ];
    WidgetsBinding.instance?.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      // didNavigateToAppSettings = false;
      FirebaseService.requestNotiPermisson();
    }
    super.didChangeAppLifecycleState(state);
  }

  _onInsertNewConversation(ChatItemModel? newChatItem) {
    if (newChatItem != null) {
      var conversationId = newChatItem.conversationId;
      if (newChatItem.isFavorite)
        _chatConversationBloc
          ..favoriteConversations.update(
            conversationId,
            (_) => newChatItem,
            ifAbsent: () => newChatItem,
          );
      _chatConversationBloc.add(ChatConversationEventAddData(
        [newChatItem],
        insertAtTop: true,
      ));
    }
    // var conversations = _chatConversationBloc.chats;
    // var isNewItemDifferenceWithFirstConversationItem = true;
    // try {
    //   isNewItemDifferenceWithFirstConversationItem =
    //       conversations.first != newChatItem;
    // } catch (e) {}
    // if (newChatItem != null && isNewItemDifferenceWithFirstConversationItem) {
    //   conversations.insert(
    //     0,
    //     newChatItem,
    //   );
    //   _chatConversationBloc.chats.clear();
    //   _chatConversationBloc
    //       .add(ChatConversationEventAddData([...conversations]));
    // }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    WidgetsBinding.instance?.removeObserver(this);

    super.dispose();
  }

  _scrollListener() {
    if (_scrollController.hasClients) {
      var maxScrollExtent = _scrollController.position.maxScrollExtent;
      var axisDirection = _scrollController.position.userScrollDirection;
      if (maxScrollExtent > 0 &&
          axisDirection == ScrollDirection.reverse &&
          _chatConversationBloc.state is! ChatConversationStateLoading &&
          !_chatConversationBloc.didExceedList &&
          _networkCubit.state.hasInternet &&
          _scrollController.offset + 500 >= maxScrollExtent) {
        _chatConversationBloc.loadData();
      }
    }
  }

  FutureOr<ChatItemModel?> _newChatItem(SocketSentMessageModel msg) async {
    var conversationId = msg.conversationId;
    var newConversation = _chatConversationBloc.chatsMap[conversationId];
    ChatItemModel? newItem;
    if (newConversation != null) {
      newItem = ChatItemModel(
        conversationId: newConversation.conversationId,
        numberOfUnReadMessgae: _chatConversationBloc
            .unreadMessageCounteCubits[newConversation.conversationId]!
            .countUnreadMessage,
        isGroup: newConversation.isGroup,
        senderId: msg.senderId,
        message: msg.message!,
        messageType: msg.type!,
        totalNumberOfMessages: ++newConversation.totalNumberOfMessages,
        messageDisplay: newConversation.messageDisplay,
        typeGroup: newConversation.typeGroup,
        adminId: newConversation.adminId,
        memberList: newConversation.memberList,
        isFavorite: newConversation.isFavorite,
        isHidden: newConversation.isHidden,
        createAt: DateTimeExt.timeZoneParse(
          msg.createAt.toTimezoneFormatString(),
        ),
        conversationBasicInfo: newConversation.conversationBasicInfo,
        lastMessages: newConversation.lastMessages,
      );
      _chatConversationBloc.addConversationToChatsMap(newItem);
    } else
      newItem = await _chatConversationBloc
          .fetchSingleChatConversation(conversationId);

    newItem
      ?..conversationBasicInfo.groupLastSenderId = msg.senderId
      ..conversationBasicInfo.lastMessasgeId = msg.messageId;

    if (newItem != null && _userInfoBloc.userInfo.id != newItem.senderId) {
      ChatMemberModel? senderInfo;
      try {
        senderInfo = newItem.memberList.singleWhere(
          (e) => e.id == msg.senderId,
        );
      } catch (_) {}
      LocalMessageNotificationService.showNotification(
        newItem.conversationBasicInfo.name,
        '<b>${senderInfo?.name}:</b> ${msg.message ?? msg.type?.displayMessageType(msg.message)}',
        json.encode({
          'converstation_id': msg.conversationId,
          'not_type': 'Chat',
          'from_source': 'chat365',
          'sender_id': msg.senderId,
          'sender_name': newItem.conversationBasicInfo.name,
          'sender_avatar': newItem.conversationBasicInfo.avatar,
          'message_id': msg.messageId,
          'message_type': msg.type?.index,
          'message': msg.message,
          'member_ids': newItem.memberList.map((e) => e.id).toList(),
        }),
      );
    }
    return newItem;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UserListTileAppBar(
        userInfoBloc: _userInfoBloc,
        elevation: 0,
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () =>
                AppRouter.toPage(context, AppPages.Navigation_QR_Code),
            icon: SvgPicture.asset(
              Images.ic_qr_login,
              color: context.theme.iconColor,
            ),
          ),
          // IconButton(
          //   onPressed: () => AppDialogs.showChoicesDialog(context, choices: [
          //     ChoiceDialogItem(
          //       value: 'Tạo cuộc họp mới',
          //       onTap: () => AppRouter.toPage(context, AppPages.MeetingSchedule_Create),
          //     ),
          //     ChoiceDialogItem(value: 'Tham gia cuộc họp', onTap: () {}),
          //     ChoiceDialogItem(
          //       value: 'Cuộc họp của tôi',
          //       onTap: () => AppRouter.toPage(context, AppPages.MyMeeting),
          //     ),
          //   ]),
          //   icon: SvgPicture.asset(
          //     Images.ic_video_call,
          //     color: context.theme.iconColor,
          //   ),
          // ),
          IconButton(
            icon: SvgPicture.asset(
              Images.ic_add_home,
              color: context.theme.iconColor,
            ),
            onPressed: () {
              AppDialogs.showAppModalBottomSheet(
                context,
                title: StringConst.newConversation,
                child: Column(
                  children: newChatItems
                      .map((e) => ModalBottomSheetItem(option: e))
                      .toList(),
                ),
              );
            },
          ),
        ],
      ),
      body: CustomRefreshIndicator(
        onRefresh: () => Future.wait([
          _chatConversationBloc.refresh(),
          _suggestContactCubit.getAllSuggestContact(
            checkUserDenied: true,
          ),
          getIt.get<AppService>().setupUnreadConversationId(),
        ]),
        child: SingleChildScrollView(
          controller: _scrollController,
          physics: const ClampingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              NavigatorSearchField(
                onNavigate: () => AppRouterHelper.toSearchContactPage(
                  context,
                  contactListCubit: searchContactCubits
                    // ..emit(LoadSuccessState(null))
                    ..loadContact(),
                ),
              ),
              BlocListener<NetworkCubit, NetworkState>(
                listener: (context, networkState) {
                  if (networkState.hasInternet &&
                      DateTime.now()
                              .difference(_lastTimeFetchSuccess)
                              .inMinutes >=
                          5) {
                    _chatConversationBloc.loadData(countLoaded: 0);
                    _suggestContactCubit.getAllSuggestContact(
                      checkUserDenied: true,
                    );
                    getIt.get<AppService>().setupUnreadConversationId();
                    _lastTimeFetchSuccess = DateTime.now();
                  }
                },
                child: BlocListener<ChatBloc, ChatState>(
                  listener: (context, chatState) async {
                    if (chatState is ChatStateRecieveMessage &&
                        _chatConversationBloc.state
                            is! ChatDetailStateLoading) {
                      var msg = chatState.msg;
                      _onInsertNewConversation(await _newChatItem(msg));
                    } else if (chatState
                        is ChatStateFavoriteConversationStatusChanged) {
                      try {
                        _chatConversationBloc.onChangeFavorite(
                          chatState.conversationId,
                          chatState.isChangeToFavorite ? 1 : 0,
                        );
                      } catch (e, s) {
                        logger.logError(e, s);
                      }
                    } else if (chatState is ChatStateOutGroup) {
                      _chatConversationBloc.onOutGroup(
                        chatState.conversationId,
                        chatState.deletedId,
                      );
                      if (chatState.deletedId == context.userInfo().id)
                        AppRouter.backToPage(context, AppPages.Navigation);
                    } else if (chatState is ChatStateNewMemberAddedToGroup)
                      _chatConversationBloc
                          .chatsMap[chatState.conversationId]?.memberList
                          .addAll(
                        chatState.members.map(
                          (e) => ChatMemberModel(
                            avatar: e.avatar,
                            id: e.id,
                            name: e.name,
                            unReader: -1,
                            companyId: e.companyId,
                            lastActive: e.lastActive,
                            status: e.status,
                            userStatus: e.userStatus,
                          ),
                        ),
                      );
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      StreamBuilder<bool>(
                          builder: ((context, snapshot) {
                            if (!snapshot.hasData || snapshot.data!)
                              return SizedBox();
                            return Container(
                              padding: AppPadding.paddingHor12Vert5,
                              color: context
                                  .theme.themeData.scaffoldBackgroundColor,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Thông báo tin nhắn của bạn đang tắt. "),
                                  GestureDetector(
                                    onTap: () async {
                                      var status = await FirebaseService
                                          .requestNotiPermisson();
                                      if (Platform.isAndroid &&
                                          (status.authorizationStatus ==
                                                  AuthorizationStatus.denied ||
                                              status.authorizationStatus ==
                                                  AuthorizationStatus
                                                      .notDetermined)) {
                                        didNavigateToAppSettings = true;
                                        AppSettings.openNotificationSettings();
                                      }
                                    },
                                    child: Text(
                                      "Bật lên ngay",
                                      style: TextStyle(
                                          color: context.theme.primaryColor),
                                    ),
                                  )
                                ],
                              ),
                            );
                          }),
                          stream: getIt
                              .get<FirebaseService>()
                              .notiPermissionStream),
                      const SizedBox(height: 10),
                      BlocBuilder<ChatConversationBloc, ChatConversationState>(
                        bloc: _chatConversationBloc,
                        buildWhen: (_, current) =>
                            current is ChatConversationStateLoadDone,
                        builder: (context, state) {
                          var sortedList = _chatConversationBloc
                              .favoriteConversations.values
                              .toList()
                            ..sort((a, b) => b.createAt.compareTo(a.createAt));

                          var favoriteConversation = sortedList.map(
                            (chatItem) {
                              var totalMessageListenable =
                                  ValueNotifier(chatItem.totalNumberOfMessages);
                              totalMessageListenable.addListener(
                                () => chatItem.totalNumberOfMessages =
                                    totalMessageListenable.value,
                              );
                              return ConversationItem(
                                key: ValueKey(
                                  _chatConversationBloc.isShowOfflineData
                                      ? '${chatItem.conversationId}_offline'
                                      : chatItem.conversationId,
                                ),
                                conversationBasicInfo:
                                    chatItem.conversationBasicInfo,
                                message: chatItem.message,
                                createdAt: chatItem.createAt,
                                isFavorited: true,
                                isGroup: chatItem.isGroup,
                                unreadMessageCubit: _chatConversationBloc
                                        .unreadMessageCounteCubits[
                                    chatItem.conversationId]!,
                                userInfoBloc: UserInfoBloc.fromConversation(
                                  chatItem.conversationBasicInfo,
                                  status: chatItem.status,
                                ),
                                users: chatItem.memberList,
                                lastMessageId: chatItem
                                    .conversationBasicInfo.lastMessasgeId,
                                messageType: chatItem.messageType,
                                messageDisplay: chatItem.messageDisplay,
                                chatItemModel: chatItem,
                                totalMessage: totalMessageListenable,
                              );
                            },
                          );
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (_chatConversationBloc
                                  .favoriteConversations.isNotEmpty)
                                _favoriteHeader,
                              ...favoriteConversation,
                              if (_chatConversationBloc
                                  .favoriteConversations.isNotEmpty)
                                _nearestHeader,
                            ],
                          );
                        },
                      ),
                      ChatConversationBody(),
                      const SizedBox(height: 8),
                      _suggestAddFriendHeader,
                      SuggestContactWidget(),
                      _LoadBuilder(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SmallHeader extends StatelessWidget {
  const SmallHeader({
    Key? key,
    required this.text,
    this.padding = const EdgeInsets.symmetric(vertical: 4, horizontal: 15),
  }) : super(key: key);

  final String text;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          return Text(
            text,
            style: state.theme.chatConversationDropdownTextStyle,
          );
        },
      ),
    );
  }
}

class _LoadBuilder extends StatefulWidget {
  const _LoadBuilder({
    Key? key,
  }) : super(key: key);

  @override
  State<_LoadBuilder> createState() => _LoadBuilderState();
}

class _LoadBuilderState extends State<_LoadBuilder> {
  bool _didLoadingVisible = false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatConversationBloc, ChatConversationState>(
      listener: (context, state) {
        if (state is ChatConversationStateError && _didLoadingVisible) {
          AppDialogs.toast(state.error.error);
          _didLoadingVisible = false;
        }
      },
      buildWhen: (previous, current) {
        return current is ChatConversationStateLoading ||
            current is ChatConversationStateLoadDone ||
            current is ChatConversationStateError;
      },
      builder: (context, state) {
        if (state is ChatConversationStateLoading) {
          return VisibilityDetector(
            onVisibilityChanged: (info) {
              if (info.visibleFraction > 0.5) _didLoadingVisible = true;
            },
            key: ValueKey('Loading'),
            child: Container(
              height: 70,
              width: double.infinity,
              alignment: Alignment.center,
              child: WidgetUtils.loadingCircle(context),
            ),
          );
        }

        return const SizedBox(
          height: 70,
          key: ValueKey('Non_loading'),
        );
      },
    );
  }
}
