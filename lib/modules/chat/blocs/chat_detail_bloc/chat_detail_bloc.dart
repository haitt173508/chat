import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:chat_365/common/blocs/unread_message_counter_cubit/unread_message_counter_cubit.dart';
import 'package:chat_365/common/blocs/user_info_bloc/bloc/user_info_bloc.dart';
import 'package:chat_365/common/blocs/user_info_bloc/repo/user_info_repo.dart';
import 'package:chat_365/core/constants/app_constants.dart';
import 'package:chat_365/core/error_handling/exceptions.dart';
import 'package:chat_365/core/interfaces/interface_user_info.dart';
import 'package:chat_365/data/services/hive_service/hive_service.dart';
import 'package:chat_365/main.dart';
import 'package:chat_365/modules/chat/blocs/chat_bloc/chat_bloc.dart';
import 'package:chat_365/modules/chat/model/chat_member_model.dart';
import 'package:chat_365/modules/chat/model/result_socket_chat.dart';
import 'package:chat_365/modules/chat/repo/chat_detail_repo.dart';
import 'package:chat_365/modules/chat/repo/chat_repo.dart';
import 'package:chat_365/modules/chat_conversations/models/conversation_basic_info.dart';
import 'package:chat_365/modules/chat_conversations/models/result_chat_conversation.dart';
import 'package:chat_365/modules/home_qr_code/model/detail_company_model.dart';
import 'package:chat_365/utils/data/enums/auto_delete_time.dart';
import 'package:chat_365/utils/data/enums/message_type.dart';
import 'package:chat_365/utils/data/extensions/context_extension.dart';
import 'package:chat_365/utils/data/extensions/list_extension.dart';
import 'package:chat_365/utils/data/extensions/string_extension.dart';
import 'package:chat_365/utils/data/models/exception_error.dart';
import 'package:chat_365/utils/data/models/request_response.dart';
import 'package:chat_365/utils/helpers/logger.dart';
import 'package:chat_365/utils/helpers/system_utils.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'chat_detail_event.dart';
part 'chat_detail_state.dart';

class ChatDetailBloc extends Bloc<ChatDetailEvent, ChatDetailState> {
  ChatDetailBloc({
    required this.senderId,
    required this.conversationId,
    required this.userInfoRepo,
    required this.chatRepo,
    required this.isGroup,
    required this.unreadMessageCounterCubit,
    this.initMemberHasNickname = const [],
    this.messageDisplay,
    this.chatItemModel,
  })  : this._chatDetailRepo = ChatDetailRepo(senderId),
        super(ChatDetailInitial()) {
    on<ChatDetailEvent>((event, emit) {});

    on<ChatDetailEventLoadConversationDetail>(loadConversationDetail);

    on<ChatDetailEventFetchListMessges>(loadListMessages);

    on<ChatDetailEventAddNewListMessages>((event, emit) {
      msgs.addAll(event.listMsgs);
      var lastMessage = event.listMsgs.last;
      var lastMessageId = lastMessage.messageId;
      if (loadedMessages != 0) {
        /// Set unreadMessageId của những người đã đọc thành lastMessageId
        var idSet = listUserInfoBlocs.keys.toSet();
        if (lastMessage.senderId == _currentUserId &&
            unreadMessageUserAndMessageId[_currentUserId] != null) {
          idSet.remove(_currentUserId);
          unreadMessageUserAndMessageId.remove(_currentUserId);
        }
        for (var user
            in idSet.difference(unreadMessageUserAndMessageId.keys.toSet())) {
          unreadMessageUserAndMessageId[user] = lastMessageId;
        }
        unreadMessageUserAndMessageIndex.forEach((userId, messageIndex) {
          /// Chỉ quan tâm đến các tin nhắn chưa đọc nhưng index của nó trong
          /// DS tin nhắn đã load vẫn chưa xác định (nên chưa xác định được [messageId] chưa đọc)
          /// Nên phải đẩy index theo độ dài DS tin nhắn vừa thêm
          if (unreadMessageUserAndMessageId[userId] ==
                  unknowUnreadMessageIdPlaceholder &&
              messageIndex != -1)
            unreadMessageUserAndMessageIndex[userId] =
                unreadMessageUserAndMessageIndex[userId]! +
                    event.listMsgs.length;
        });
      } else {
        unreadMessageUserAndMessageId = Map<int, String>.fromIterable(
          listUserInfoBlocs.keys,
          value: (_) => lastMessageId,
        );
      }
      if (!event.isTempMessage) {
        loadedMessages += event.listMsgs.length;
        totalMessages += event.listMsgs.length;
        // listImageFiles.addAll(getImageFilesFromListMessages(event.listMsgs));
      }
      emit(ChatDetailStateLoadDoneListMessages(msgs));
    });

    on<ChatDetailEventInsertNewListMessages>((event, emit) async {
      msgs.insertAll(0, event.listMsgs);
      var length = msgs.length;
      unreadMessageUserAndMessageIndex.forEach((userId, messageIndex) {
        if (unreadMessageUserAndMessageId[userId] ==
                unknowUnreadMessageIdPlaceholder &&
            messageIndex > 0 &&
            messageIndex - 2 <= length - 1)
          unreadMessageUserAndMessageId[userId] =
              msgs[(length - 1 - (messageIndex - 1)).clamp(0, length - 1)]
                  .messageId;
      });
      loadedMessages += event.listMsgs.length;
      listImageFiles.insertAll(
        0,
        getImageFilesFromListMessages(event.listMsgs),
      );
      emit(ChatDetailStateLoadDoneListMessages([...msgs]));
    });

    on<ChatDetailEventRaiseError>((event, emit) {
      emit(ChatDetailStateError(event.error));
    });

    on<ChatDetailEventMarkReadMessage>((event, emit) {
      var reader = event.senderId;
      unreadMessageUserAndMessageId.remove(reader);
      unreadMessageUserAndMessageIndex.remove(reader);
      readMessageTime[reader] = DateTime.now();

      emit(ChatDetailStateMarkReadMessage(conversationId, event.senderId));
    });

    pinnedMessageId.addListener(_loadPinnedMessageInfo);

    _currentUserId = navigatorKey.currentContext!.userInfo().id;

    _streamSubscription = chatRepo.stream.listen((event) {
      if (event is ChatEventOnMarkReadAllMessage &&
          (event).conversationId == conversationId) {
        add(
          ChatDetailEventMarkReadMessage(event.conversationId, event.senderId),
        );
      } else if (event is ChatEventOnPinMessage &&
          event.conversationId == conversationId) {
        pinnedMessageId.value = event.messageId;
      } else if (event is ChatEventOnUnPinMessage &&
          event.conversationId == conversationId) {
        pinnedMessageId.value = null;
      }
    });
    try {
      messagesBox = HiveService().listMessagesBox;
    } catch (e) {}
  }

  final int senderId;
  final int conversationId;
  final ChatDetailRepo _chatDetailRepo;
  final UserInfoRepo userInfoRepo;
  final ChatRepo chatRepo;
  final List<SocketSentMessageModel> msgs = [];
  final bool isGroup;
  final int? messageDisplay;
  final ChatItemModel? chatItemModel;
  late final int _currentUserId;
  late Box<String>? messagesBox;
  bool _isShowOfflineMessage = true;
  ChatItemModel? detail;
  final UnreadMessageCounterCubit unreadMessageCounterCubit;
  ValueNotifier<DetailModel?> detailModel = ValueNotifier(null);

  bool _hasDetailInfo = true;

  /// Nếu [AutoDeleteTime.never] là tin nhắn thường
  int autoDeleteTimeMessage = 0;

  bool get isShowOfflineMessage => _isShowOfflineMessage;

  Future<List<SocketSentMessageModel>?> get localMessages async {
    try {
      var str = messagesBox?.get(conversationId);
      if (str != null) return await compute(_decodeLocalMessage, str);
      return null;
    } catch (e, s) {
      logger.logError(e, s, 'Get List<SocketSentMessageModel> Error:');
      try {
        messagesBox?.delete(conversationId);
      } catch (e) {}
      return null;
    }
  }

  static List<SocketSentMessageModel> _decodeLocalMessage(String str) =>
      (json.decode(str) as List)
          .map((e) => sockeSentMessageModelFromHiveObjectJson(e))
          .toList();

  bool fetchListMessasgeSuccessFirstTime = false;

  /// Danh sách những thành viên có nickname, do API sau này không trả về nickname
  final List<IUserInfo> initMemberHasNickname;

  late final StreamSubscription _streamSubscription;

  /// Danh sách [senderId] và index của [message] chưa đọc khi:
  /// - fetch [loadConversationDetail]
  ///
  /// Khi [message] trong [unreadMessageUserAndMessageId] ứng với [senderId]
  /// đã xác định (khác [unknowUnreadMessageIdPlaceholder]), key [senderId] trong
  /// map này không cần quan tâm nữa
  Map<int, int> unreadMessageUserAndMessageIndex = {};

  /// Danh sách [senderId] và [message] tương ứng chưa đọc
  Map<int, String> unreadMessageUserAndMessageId = {};

  /// Danh sách người dùng và thời gian xem tin nhắn tương ứng
  Map<int, DateTime?> readMessageTime = {};

  final List<SocketSentMessageModel> listImageFiles = [];

  int loadedMessages = 0;

  int totalMessages = 0;

  final ValueNotifier<SocketSentMessageModel?> pinnedMessage =
      ValueNotifier(null);

  ValueNotifier<String?> pinnedMessageId = ValueNotifier(null);

  // Set<String> deletedMessageIds = {};

  /// String để nhận biết message chưa đọc này chưa load được messageId
  static const unknowUnreadMessageIdPlaceholder = '';

  Map<int, UserInfoBloc> listUserInfoBlocs = {};

  late final ValueNotifier<int> countConversationMember = ValueNotifier(0);

  /// Những [user] không thuộc thành viên cuộc trò chuyện, nhưng cần có thông
  /// tin
  ///
  /// VD: [user] đã bị xóa khỏi cuộc trò chuyện, nhưng message xuất hiện
  Map<int, UserInfoBloc> tempListUserInfoBlocs = {};

  Iterable<SocketSentMessageModel> getImageFilesFromListMessages(
      List<SocketSentMessageModel> listMsgs) {
    var res = <SocketSentMessageModel>[];
    for (var msg in listMsgs) {
      if ((msg.type?.isImage ?? false) && msg.files != null) {
        res.addAll(msg.files!.map((e) => msg.copyWith(files: [e])));
      }
    }
    return res;
  }

  Map<int, UserInfoBloc> get allUserInfoBlocsAppearInConversation => {
        ...tempListUserInfoBlocs,
        ...listUserInfoBlocs,
      };

  addMember(ChatMemberModel member) {
    var name = member.name;
    var id = member.id;

    var index = initMemberHasNickname.indexWhere((e) => e.id == id);
    if (index != -1) {
      name = initMemberHasNickname[index].name;
    }

    listUserInfoBlocs[member.id] = !isGroup
        ? UserInfoBloc.fromConversation(
            ConversationBasicInfo(
              conversationId: conversationId,
              name: name,
              userId: id,
              avatar: member.avatar,
              isGroup: false,
              userStatus: member.userStatus,
              lastActive: member.lastActive,
            ),
            status: member.status,
          )
        : UserInfoBloc(member);
  }

  _loadPinnedMessageInfo() async {
    if (!pinnedMessageId.value.isBlank) {
      var res = await _chatDetailRepo.getMessage(pinnedMessageId.value!);
      res.onCallBack((_) {
        pinnedMessage.value = SocketSentMessageModel.fromMap(
            json.decode(res.data)['data']['message_info']);
      });
    } else {
      pinnedMessage.value = null;
    }
  }

  isThisMessageUnderOther(String thisMessageId, String other) =>
      thisMessageId.tickFromMessageId >= other.tickFromMessageId;

  Set<int> listUserIdUnreadMessageId(String messageId) {
    /// Danh sách những [userId] chưa đọc [messageId]
    Set<int> listUserIds = {};
    for (var entry in unreadMessageUserAndMessageId.entries) {
      var userId = entry.key;
      var unreadMessageId = entry.value;
      if (unreadMessageId == unknowUnreadMessageIdPlaceholder ||

          /// Check xem [messageId] hiện tại có nằm dưới [unreadMessageId]
          /// Nếu có nằm dưới, [userId] đang xét chưa đọc [messageId] hiện tại
          /// Vì tin [unreadMessageId] ở trên chưa đọc
          isThisMessageUnderOther(messageId, unreadMessageId)) {
        listUserIds.add(userId);
      }
    }

    return listUserIds;
  }

  reset() {
    msgs.clear();
    unreadMessageUserAndMessageIndex = {};
    unreadMessageUserAndMessageId = {};
    readMessageTime = {};
    listImageFiles.clear();
    loadedMessages = 0;
  }

  loadConversationDetail(event, emit) async {
    Timer? _timer;
    try {
      if (detail == null && chatItemModel != null) {
        logger.log(
          chatItemModel!.lastMessages?.length,
          name: 'BeforeGetConversationDetail',
        );
        detail = chatItemModel;
        autoDeleteTimeMessage = detail!.autoDeleteMessageTimeModel.deleteTime;
        // logger.log(
        //   chatItemModel!.lastMessages?.length,
        //   name: 'AfterGetConversationDetail',
        // );
        detail!.memberList.forEach((e) {
          addMember(e);
          unreadMessageUserAndMessageId[e.id] =
              unknowUnreadMessageIdPlaceholder;
        });
        emit(ChatDetailStateLoadDetailDone(
          detail!,
          isBroadcastUpdate: false,
        ));
      }

      if (!fetchListMessasgeSuccessFirstTime) {
        final localMsgs = detail?.lastMessages ?? (await localMessages);
        if (!fetchListMessasgeSuccessFirstTime && !localMsgs.isBlank) {
          _timer = Timer.periodic(const Duration(milliseconds: 1800), (timer) {
            try {
              /// Sau 1.8s, ko có dữ liệu online về và state hiện tại ko phải state lỗi,
              /// hiển thị đang cập nhật cuộc hội thoại
              if (_isShowOfflineMessage && state is! ChatDetailStateError) {
                emit(ChatDetailStateLoading(false));
                timer.cancel();
              }
            } catch (e) {}
          });
          final List<SocketSentMessageModel> preloadMsgs = localMsgs!;
          // final List<SocketSentMessageModel> lastMessages =
          //     chatItemModel?.lastMessages ?? [];
          // if (localMsgs.isBlank == false && lastMessages.isBlank == false)
          //   preloadMsgs = lastMessages.last.createAt
          //               .compareTo(localMsgs!.last.createAt) ==
          //           1
          //       ? localMsgs
          //       : lastMessages;
          // else
          // preloadMsgs = localMsgs ?? chatItemModel!.lastMessages!;
          // preloadMsgs = localMsgs!;
          msgs.addAll(preloadMsgs);
          emit(ChatDetailStateLoadDoneListMessages(
            preloadMsgs,
          ));
          fetchListMessasgeSuccessFirstTime = true;
          await Future.delayed(const Duration(milliseconds: 200));
        }
      } else
        emit(ChatDetailStateLoading(!fetchListMessasgeSuccessFirstTime));

      // var detail = await _fetchConversationDetail();

      // else
      detail = await _fetchConversationDetail();
      autoDeleteTimeMessage = detail!.autoDeleteMessageTimeModel.deleteTime;
      _timer?.cancel();

      reset();

      detail!.memberList.forEach(addMember);
      pinnedMessageId.value = detail!.conversationBasicInfo.pinMessageId;
      totalMessages = detail!.totalNumberOfMessages;
      await _setUnreadMessageIdAndIndex();

      /// For test
      // var error = ExceptionError('Cuộc trò chuyện không tồn tại');
      // return add(ChatDetailEventRaiseError(error));

      emit(ChatDetailStateLoadDetailDone(detail!));
      add(ChatDetailEventFetchListMessges());
    } on CustomException catch (e) {
      add(ChatDetailEventRaiseError(e.error));
    }
  }

  _setUnreadMessageIdAndIndex() async {
    final List res = await compute(_computeSetUnreadMessageIdAndIndex, [
      detail!.memberList,
      unreadMessageUserAndMessageId,
      unreadMessageUserAndMessageIndex,
      readMessageTime,
      unreadMessageCounterCubit.countUnreadMessage,
      _currentUserId,
    ]);

    detail!.memberList = res[0];
    unreadMessageUserAndMessageId = res[1];
    unreadMessageUserAndMessageIndex = res[2];
    readMessageTime = res[3];
  }

  static List _computeSetUnreadMessageIdAndIndex(List params) {
    final List<ChatMemberModel> memberList = params[0];
    final Map<int, String> unreadMessageUserAndMessageId = params[1];
    final Map<int, int> unreadMessageUserAndMessageIndex = params[2];
    final Map<int, DateTime?> readMessageTime = params[3];
    final int countUnreadMessage = params[4];
    final int _currentUserId = params[5];
    for (var member in memberList) {
      var id = member.id;
      readMessageTime[id] = member.readMessageTime;
      int messageIndex;
      if (member.unreadMessageId != null) {
        unreadMessageUserAndMessageId[id] = member.unreadMessageId!;
      } else if (member.id == _currentUserId) {
        unreadMessageUserAndMessageIndex[id] = countUnreadMessage;
        unreadMessageUserAndMessageId[id] = unknowUnreadMessageIdPlaceholder;
      } else {
        messageIndex = member.unReader;

        if (member.unReader == 0) {
          unreadMessageUserAndMessageId.remove(id);
        } else if (messageIndex > 0) {
          unreadMessageUserAndMessageId[id] = unknowUnreadMessageIdPlaceholder;
          unreadMessageUserAndMessageIndex[id] = messageIndex;
        }
      }
    }

    return [
      memberList,
      unreadMessageUserAndMessageId,
      unreadMessageUserAndMessageIndex,
      readMessageTime,
      countUnreadMessage,
      _currentUserId,
    ];
  }

  loadListMessages(event, emit) async {
    try {
      // var listMsgs = <SocketSentMessageModel>[];
      var listMsgs = await _fetchListMessages();
      // var listMsgs = localMessages ?? [];
      add(ChatDetailEventInsertNewListMessages(listMsgs));
      // add(ChatDetailEventInsertNewListMessages([]));
      fetchListMessasgeSuccessFirstTime = true;
      _isShowOfflineMessage = false;
      // if (loadedMessages <= 20) {
      //   HiveService().saveListMessageToChatItemModelBox(
      //     conversationId,
      //     [
      //       ...msgs,
      //       ...listMsgs,
      //     ],
      //   );
      // }
    } on CustomException catch (e) {
      if (loadedMessages == 0 && e.error.isNetworkException) {
        final localMsgs = await localMessages;
        if (!localMsgs.isBlank)
          return add(ChatDetailEventInsertNewListMessages(localMsgs!));
      }
      add(ChatDetailEventRaiseError(e.error));
    }
  }

  Future<ChatItemModel> _fetchConversationDetail() async {
    var res = await _chatDetailRepo.loadConversationDetail(conversationId);
    return res.onCallBack(
      _computeFetchConversationDetail,
      // multiThread: true,
    );
  }

  ChatItemModel _computeFetchConversationDetail(RequestResponse res) {
    try {
      return ChatItemModel.fromConversationInfoJsonOfUser(
        navigatorKey.currentContext?.userInfo().id ?? userInfo!.id,
        conversationInfoJson: json.decode(res.data)["data"]
            ["conversation_info"],
      );
    } catch (e, s) {
      logger.logError(e, s);
      rethrow;
    }
  }

  Future<List<SocketSentMessageModel>> _fetchListMessages() async {
    var res = await _chatDetailRepo.loadListMessage(
      conversationId,
      loadedMessages: loadedMessages,
      totalMessages: totalMessages,
      messageDisplay: messageDisplay,
    );

    return res.onCallBack<List<SocketSentMessageModel>>(
      (_) => compute(_computeListSocketSentMessageModel, [
        res,
        SystemUtils.getCurrrentUserInfoAndUserType(),
      ]),
    );
  }

  static List<SocketSentMessageModel> _computeListSocketSentMessageModel(
    List params,
  ) {
    final RequestResponse res = params[0];
    final CurrentUserInfoModel infoModel = params[1];
    return (json.decode(res.data)["data"]["listMessages"] as List)
        .map((e) => SocketSentMessageModel.fromMap(
              e,
              userInfo: infoModel.userInfo,
              userType: infoModel.userType,
            ))
        .toList();
  }

  pinMessage(String messageId, String messageContent) {
    chatRepo.pinMessasge(
      conversationId,
      messageContent,
      messageId,
      listUserInfoBlocs.keys.toList(),
    );
  }

  unPinMessage(String messageContent) => chatRepo.unPinMessage(
        conversationId,
        messageContent,
        listUserInfoBlocs.keys.toList(),
      );

  Future _getDetailInfo(int idChat, int type) async {
    var res = await _chatDetailRepo.getDetailInfo(idChat, type);
    try {
      await res.onCallBack((_) {
        var data = detailCompanyModelFromJson(res.data);
        detailModel.value = data.data!.item;
      });
    } catch (e) {
      if (e is CustomException && (e).error.code == 404) _hasDetailInfo = false;
    }
  }

  Future<DetailModel?> getDetailInfo() async {
    if (detailModel.value != null) return detailModel.value!;
    var conversationInfo = detail!.conversationBasicInfo;
    var chatId = detail!.firstOtherMember(_currentUserId).id;
    await _getDetailInfo(chatId, conversationInfo.userType!.id);
    return detailModel.value;
  }

  @override
  void onChange(Change<ChatDetailState> change) {
    if (change.nextState is ChatDetailStateLoadDetailDone) {
      countConversationMember.value = listUserInfoBlocs.length;
      var userType = detail!.conversationBasicInfo.userType;
      if (_hasDetailInfo && userType != null && detailModel.value == null)
        getDetailInfo();
    }
    super.onChange(change);
  }

  static List<ChatMemberModel> _updateChatItemModelOnClose(List params) {
    final List<ChatMemberModel> members = params[0];
    final Map<int, String> unreadMessageUserAndMessageId = params[1];
    final Map<int, DateTime?> readMessageTime = params[2];
    for (var member in members) {
      var unreadMessageId = unreadMessageUserAndMessageId.remove(member.id);
      member.unreadMessageId = unreadMessageId;
      if (unreadMessageId == null)
        member.readMessageTime = readMessageTime[member.id];
      // if (unreadMessageUserAndMessageId.isEmpty) break;
    }
    return members;
  }

  List<SocketSentMessageModel> get currentLastMessages => msgs.slice(
        start: (msgs.length - AppConst.countOfflineConversationMessages)
            .clamp(0, msgs.length),
      );

  @override
  Future<void> close() async {
    listUserInfoBlocs.values.forEach((e) => e.close());
    tempListUserInfoBlocs.values.forEach((e) => e.close());
    _streamSubscription.cancel();
    var lastMessage = currentLastMessages;
    // if (chatItemModel != null) {
    //   chatItemModel!
    //     .memberList = await compute(
    //       _updateChatItemModelOnClose,
    //       [
    //         chatItemModel!.memberList,
    //         unreadMessageUserAndMessageId,
    //         readMessageTime,
    //       ],
    //     );
    // }
    // if (kDebugMode)
    //   logger.log(
    //     'ChatItemModel ${chatItemModel?.conversationId} LastMessages: ${chatItemModel?.lastMessages?.length}',
    //   );
    if (!_isShowOfflineMessage) {
      chatItemModel?.lastMessages ??= lastMessage;
      // logger.log(
      //   'ChatItemModel ${chatItemModel?.conversationId} AfterSetLastMessages: ${chatItemModel?.lastMessages?.length}',
      // );
      try {
        HiveService().saveListMessageToChatConversationBox(
          conversationId,
          lastMessage,
        );
      } catch (e) {}
    }
    return super.close();
  }
}
