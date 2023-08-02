import 'package:chat_365/common/blocs/network_cubit/network_cubit.dart';
import 'package:chat_365/common/blocs/user_info_bloc/bloc/user_info_bloc.dart';
import 'package:chat_365/common/blocs/user_info_bloc/repo/user_info_repo.dart';
import 'package:chat_365/common/widgets/app_error_widget.dart';
import 'package:chat_365/common/widgets/conversation_item.dart';
import 'package:chat_365/modules/chat_conversations/bloc/chat_conversation_bloc.dart';
import 'package:chat_365/modules/chat_conversations/models/result_chat_conversation.dart';
import 'package:chat_365/modules/chat_conversations/repo/chat_conversations_repo.dart';
import 'package:chat_365/router/app_pages.dart';
import 'package:chat_365/router/app_route_observer.dart';
import 'package:chat_365/utils/helpers/logger.dart';
import 'package:chat_365/utils/ui/app_dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ChatConversationBody extends StatefulWidget {
  const ChatConversationBody({Key? key}) : super(key: key);

  @override
  State<ChatConversationBody> createState() => _ChatConversationBodyState();
}

class _ChatConversationBodyState extends State<ChatConversationBody>
    with AutomaticKeepAliveClientMixin<ChatConversationBody> {
  List<ChatItemModel> conversations = [];
  late final ChatConversationBloc _chatConversationBloc;
  late final UserInfoRepo userInfoRepo;
  late final NetworkCubit _networkCubit;
  bool _canStopFetchToFillViewPort = false;
  late final ChatConversationsRepo _chatConversationRepo;

  @override
  void initState() {
    _chatConversationBloc = context.read<ChatConversationBloc>();
    _chatConversationRepo = context.read<ChatConversationsRepo>();
    userInfoRepo = context.read<UserInfoRepo>();
    _networkCubit = context.read<NetworkCubit>();
    if (_chatConversationBloc.isShowOfflineData &&
        _chatConversationBloc.state is! ChatConversationStateLoadDone)
      _chatConversationBloc.offlineData.then(
        (value) {
          if (_chatConversationBloc.isShowOfflineData &&
              _chatConversationBloc.state is! ChatConversationStateLoadDone)
            _chatConversationBloc.emit(
              ChatConversationStateLoadDone(value),
            );
        },
      );
    super.initState();
  }

  ScrollableState get _scrollState => Scrollable.of(context)!;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocConsumer<ChatConversationBloc, ChatConversationState>(
      bloc: _chatConversationBloc,
      listenWhen: (_, __) =>
          routeObserver.currentPageRoute!.settings.name ==
          AppPages.Navigation.name,
      listener: (context, state) {
        if (!_chatConversationBloc.isShowOfflineData) Fluttertoast.cancel();
        if (state is ChatConversationStateError) {
          if (!state.markNeedBuild) {
            if (_canStopFetchToFillViewPort &&
                state.error.toString() != 'User không có cuộc trò chuyện nào')
              AppDialogs.toast(state.error.toString());
            else if (state.error.toString() ==
                'User không có cuộc trò chuyện nào')
              _canStopFetchToFillViewPort = true;
          }
          if (state.error.isNetworkException)
            try {
              AppDialogs.openWifiDialog(context);
            } catch (e, s) {
              logger.logError(e, s);
            }
        } else if (state is ChatConversationStateLoadDone) {
          var length = _chatConversationBloc.chatsMap.length;
          if (length > _chatConversationRepo.totalRecords) {
            _canStopFetchToFillViewPort = true;
            _chatConversationRepo.totalRecords = length;
          }
        }
      },
      buildWhen: (prev, current) =>
          current is ChatConversationStateLoadDone ||
          (current is ChatConversationStateLoading && current.markNeedBuild) ||
          (current is ChatConversationStateError && current.markNeedBuild),
      builder: (context, state) {
        if (state is ChatConversationStateLoadDone) {
          // logger.log(
          //   _chatConversationBloc.chats.length,
          //   name: 'ChatConversationStateLoadDone',
          // );
          conversations = state.chatItems;
          return LayoutBuilder(builder: (context, c) {
            WidgetsBinding.instance?.addPostFrameCallback((timeStamp) async {
              await Future.delayed(const Duration(milliseconds: 300));
              var isScrollable = _scrollState.position.maxScrollExtent > 0;
              if (!isScrollable &&
                  !_canStopFetchToFillViewPort &&
                  _networkCubit.state.hasInternet &&
                  _chatConversationBloc.state
                      is ChatConversationStateLoadDone) {
                _chatConversationBloc.loadData();
              }
            });

            return ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              addRepaintBoundaries: true,
              addAutomaticKeepAlives: true,
              itemBuilder: (context, index) {
                var conversation = conversations[index];

                if (conversation.isHidden || conversation.isFavorite)
                  return const SizedBox(
                    key: ValueKey('favorite-conversation'),
                  );

                var userInfoBloc = UserInfoBloc.fromConversation(
                  conversation.conversationBasicInfo,
                  status: conversation.status,
                );

                var totalMessageListener =
                    ValueNotifier(conversation.totalNumberOfMessages);

                totalMessageListener.addListener(
                  () => conversation.totalNumberOfMessages =
                      totalMessageListener.value,
                );

                return Padding(
                  padding: const EdgeInsets.only(bottom: 2.0),
                  child: ConversationItem(
                    key: ValueKey(
                      _chatConversationBloc.isShowOfflineData
                          ? '${conversation.conversationId}_offline'
                          : conversation.conversationId,
                    ),
                    userInfoBloc: userInfoBloc,
                    unreadMessageCubit:
                        _chatConversationBloc.unreadMessageCounteCubits[
                            conversation.conversationId]!,
                    conversationBasicInfo: conversation.conversationBasicInfo,
                    message: conversation.message,
                    isGroup: conversation.isGroup,
                    createdAt: conversation.createAt,
                    users: conversation.memberList,
                    lastMessageId:
                        conversation.conversationBasicInfo.lastMessasgeId,
                    messageType: conversation.messageType,
                    messageDisplay: conversation.messageDisplay,
                    chatItemModel: conversation,
                    totalMessage: totalMessageListener,
                  ),
                );
              },
              itemCount: conversations.length,
            );
          });
        }
        if (state is ChatConversationStateError)
          return AppErrorWidget(
            error: state.error.toString(),
            showErrorButton: state.error.code != 200,
            onTap: () => _chatConversationBloc.refresh(),
          );

        return const SizedBox();
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
