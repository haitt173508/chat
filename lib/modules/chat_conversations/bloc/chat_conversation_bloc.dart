import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:isolate';

import 'package:bloc/bloc.dart';
import 'package:chat_365/common/blocs/typing_detector_bloc/typing_detector_bloc.dart';
import 'package:chat_365/common/blocs/unread_message_counter_cubit/unread_message_counter_cubit.dart';
import 'package:chat_365/core/error_handling/exceptions.dart';
import 'package:chat_365/core/interfaces/interface_user_info.dart';
import 'package:chat_365/data/services/hive_service/hive_box_names.dart';
import 'package:chat_365/data/services/hive_service/hive_service.dart';
import 'package:chat_365/main.dart';
import 'package:chat_365/modules/chat/model/result_socket_chat.dart';
import 'package:chat_365/modules/chat/repo/chat_detail_repo.dart';
import 'package:chat_365/modules/chat/repo/chat_repo.dart';
import 'package:chat_365/modules/chat_conversations/models/draft_model.dart';
import 'package:chat_365/modules/chat_conversations/models/result_chat_conversation.dart';
import 'package:chat_365/modules/chat_conversations/repo/chat_conversations_repo.dart';
import 'package:chat_365/service/app_service.dart';
import 'package:chat_365/service/injection.dart';
import 'package:chat_365/utils/data/enums/user_type.dart';
import 'package:chat_365/utils/data/extensions/bool_extension.dart';
import 'package:chat_365/utils/data/extensions/context_extension.dart';
import 'package:chat_365/utils/data/extensions/list_extension.dart';
import 'package:chat_365/utils/data/extensions/map_extension.dart';
import 'package:chat_365/utils/data/models/exception_error.dart';
import 'package:chat_365/utils/data/models/request_response.dart';
import 'package:chat_365/utils/helpers/logger.dart';
import 'package:chat_365/utils/helpers/system_utils.dart';
import 'package:chat_365/utils/ui/app_dialogs.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'chat_conversation_event.dart';
part 'chat_conversation_state.dart';

class ChatConversationBloc
    extends Bloc<ChatConversationEvent, ChatConversationState> {
  ChatConversationBloc(
    this._chatConversationsRepo,
  ) : super(ChatConversationInitial()) {
    on<ChatConversationEventAddData>(
      (event, emit) async {
        // compute(_getListLastMessages, event.list);

        for (var item in event.list) {
          addConversationToChatsMap(item);
          typingBlocs.putIfAbsent(
            item.conversationId,
            () => TypingDetectorBloc(item.conversationId),
          );
          unreadMessageCounteCubits.update(
            item.conversationId,
            (cubit) => cubit
              ..emit(
                UnreadMessageCounterState(
                  item.numberOfUnreadMessage,
                ),
              ),
            ifAbsent: () => UnreadMessageCounterCubit(
              conversationId: item.conversationId,
              countUnreadMessage: item.numberOfUnreadMessage,
            ),
          );
          if (item.isFavorite)
            favoriteConversations[item.conversationId] = item;
          else
            favoriteConversations.remove(item.conversationId);
        }

        _getListLastMessages([...event.list]).then((_) {
          if (event.saveToLocal) _saveChatItemModelToLocal(chatsMap.values);
        });

        try {
          var appService = getIt.get<AppService>();
          if (appService.countUnreadConversation == 0)
            appService.updateUnreadConversation(
              unreadMessageCounteCubits.values
                  .where((e) =>
                      e.hasUnreadMessage &&
                      chatsMap[e.conversationId]?.isHidden != true)
                  .map((e) => e.conversationId),
            );
        } catch (e) {}

        var conversations = [...chats];
        if (event.insertAtTop && event.list.length == 1) {
          var topElement = event.list.single;
          conversations
            ..removeWhere((e) => e.conversationId == topElement.conversationId)
            ..insert(0, event.list.single);
        }

        emit(ChatConversationStateLoadDone(conversations));
      },
    );

    on<ChatConversationEventRaiseError>(
      (event, emit) => emit(
        ChatConversationStateError(
          event.error,
          markNeedBuild: chatsMap.isNotEmpty &&
              (event.error.isServerError ||
                  event.error.isUnknowError ||
                  !_didFetchListMessageFirstTime),
        ),
      ),
    );

    on<ChatConversationEventAddLoadingState>((event, emit) =>
        emit(ChatConversationStateLoading(
          markNeedBuild: event.markNeedBuild ?? !_didFetchListMessageFirstTime,
        )));

    on<ChatConversationEventAddFavoriteConversation>((event, emit) {
      chatsMap[event.item.conversationId]?.isFavorite = true;
      favoriteConversations = favoriteConversations.insertAtTop(
        event.item.conversationId,
        event.item,
      );
      emit(ChatConversationAddFavoriteSuccessState(chats, event.item));
    });

    on<ChatConversationEventRemoveFavoriteConversation>((event, emit) {
      chatsMap[event.item.conversationId]?.isFavorite = false;
      favoriteConversations.remove(event.item.conversationId);
      // emit(ChatConversationStateLoadDone(chats));
      emit(ChatConversationRemoveFavoriteSuccessState(chats, event.item));
    });

    // loadData();
    try {
      chatItemModelBox = HiveService().chatItemModelBox;
    } catch (e, s) {
      logger.logError(e, s, 'Open chatItemModelBox Error');
    }
  }

  /// Check đã có dữ liệu để hiển thị trên UI
  ///
  /// Nếu true, các lần sau fetch ds conversation không cần hiển thị loading nữa
  bool _didFetchListMessageFirstTime = false;

  /// Check đã fetch hết ds cuộc trò chuyện
  bool didExceedList = false;

  /// Check ds cuộc trò chuyện hiện tại đang show là từ Hive
  bool _isShowOfflineData = false;

  final ChatConversationsRepo _chatConversationsRepo;

  /// Check sử dụng api GetConversationList
  bool useFastApi = true;

  int page = 0;

  Map<int, ChatItemModel> chatsMap = HashMap();

  bool _sortWithUnreadMessageCompare = true;

  /// [chatId] và [ChatItemModel] tương ứng của ds yêu thích
  Map<int, ChatItemModel> favoriteConversations = {};

  Box<ChatItemModel>? chatItemModelBox;

  int get currentUserId => _chatConversationsRepo.userId;

  int get _countLoaded => chatsMap.length;

  bool get isShowOfflineData => _isShowOfflineData;

  Map<int, DraftModel> drafts = {};

  bool loadingLocalMessages = false;

  addConversationToChatsMap(ChatItemModel item) => chatsMap.update(
        item.conversationId,
        (value) {
          // Nếu số lượng tin nhắn của item mới > số lượng tin nhắn của item cũ
          // thì gán tin nhắn cũ vào item mới
          if (!value.lastMessages.isBlank &&
              item.totalNumberOfMessages > value.lastMessages!.length)
            item.lastMessages = value.lastMessages;
          return item;
        },
        ifAbsent: () => item,
      );

  List<ChatItemModel> get chats =>
      !_sortWithUnreadMessageCompare ? sort() : sortWithUnreadMessageCompare();
  // ..sort(
  //   (a, b) {
  //     if (page != 0) return b.createAt.compareTo(a.createAt);
  //     final bool aCheck =
  //         unreadMessageCounteCubits[a.conversationId]!.hasUnreadMessage;
  //     final bool bCheck =
  //         unreadMessageCounteCubits[b.conversationId]!.hasUnreadMessage;
  //     return (b.createAt.compareTo(a.createAt) + bCheck.compareTo(aCheck))
  //         .clamp(-1, 1);
  //   },
  // );

  List<ChatItemModel> sortWithUnreadMessageCompare() {
    _sortWithUnreadMessageCompare = false;
    return chatsMap.values.toList()
      ..sort(
        (a, b) {
          final bool aCheck =
              unreadMessageCounteCubits[a.conversationId]!.hasUnreadMessage;
          final bool bCheck =
              unreadMessageCounteCubits[b.conversationId]!.hasUnreadMessage;
          return (b.createAt.compareTo(a.createAt) + bCheck.compareTo(aCheck))
              .clamp(-1, 1);
        },
      );
  }

  List<ChatItemModel> sort() => chatsMap.values.toList()
    ..sort(
      (a, b) => b.createAt.compareTo(a.createAt),
    );

  Future refresh({bool buildOnLoad = false}) async {
    // chats.clear();
    _sortWithUnreadMessageCompare = true;
    page = 0;
    didExceedList = false;
    useFastApi = true;
    return await loadData(countLoaded: 0);
  }

  clear() {
    // chatsMap.forEach((_, v) => v.numberOfUnreadMessage.close());
    chatsMap.clear();
    page = 0;
    favoriteConversations.clear();
  }

  resetToLogout() {
    clear();
    _localMessages = null;
    typingBlocs
      ..values.forEach((e) => e.close())
      ..clear();
    unreadMessageCounteCubits
      ..values.forEach((e) => e.close())
      ..clear();
    drafts.clear();
    didExceedList = false;
  }

  Map<int, List<SocketSentMessageModel>>? _localMessages;

  FutureOr<Map<int, List<SocketSentMessageModel>>?> get localMessages async {
    loadingLocalMessages = true;
    final stopwatch = Stopwatch()..start();
    _localMessages ??= await HiveService().messages;
    loadingLocalMessages = false;
    final elapsed = stopwatch.elapsed;
    if (kDebugMode) {
      logger.log(
        'Get ${_localMessages?.values.map((e) => e.length).reduce((a, b) => a + b)} messages in $elapsed',
        name: 'Elap FetchAllLocalMessagesTime',
      );
    }

    return _localMessages;
  }

  Future<List<ChatItemModel>> get offlineData async {
    chatItemModelBox ??= HiveService().chatItemModelBox;
    var chatItemModels = (chatItemModelBox?.values ?? []).toList();
    if (chatItemModels.isNotEmpty) {
      try {
        final localMsgs = await localMessages;
        for (var item in chatItemModels) {
          if (item.lastMessages.isBlank)
            item.lastMessages = localMsgs?[item.conversationId];
          // item.lastMessages = await HiveService()
          //     .getConversationOfflineMessages(item.conversationId);
        }
      } catch (e) {
        print(e);
      }
    }

    return chatItemModels;
  }

  /// [ConversationId] và [TypingDetectorBloc] tương ứng
  Map<int, TypingDetectorBloc> typingBlocs = {};
  Map<int, UnreadMessageCounterCubit> unreadMessageCounteCubits = {};

  Future<List<ChatItemModel>> getListChatCoversasion(
    int countLoaded, {
    bool useFastApi = false,
  }) async {
    var res = await _chatConversationsRepo.loadListConversation(
      countLoaded: countLoaded,
      // useFastApi: countLoaded == 0 ? true : false,
    );

    IUserInfo? currentUserInfo;
    UserType? currentUserType;

    try {
      final BuildContext context = navigatorKey.currentContext!;
      currentUserInfo = context.userInfo();
      currentUserType = context.userType();
    } catch (e) {
      currentUserInfo = userInfo;
      currentUserType = userType;
    }

    return await res.onCallBack(
      (response) => compute(
        _computeGetListChatConversation,
        [
          response,
          currentUserId,
          currentUserInfo,
          currentUserType,
        ],
      ),
    );

    // return
  }

  static List<ChatItemModel> _computeGetListChatConversation(List params) {
    final RequestResponse res = params[0];
    final int currentUserId = params[1];
    return List.from(
      (json.decode(res.data)['data']['listCoversation'] as List).map(
        (e) => ChatItemModel.fromConversationInfoJsonOfUser(
          currentUserId,
          conversationInfoJson: e,
          currentUserInfo: params[2],
          currentUserType: params[3],
        ),
      ),
    );
  }

  Future<ChatItemModel?> fetchSingleChatConversation(int conversationId) async {
    var res = await ChatDetailRepo(_chatConversationsRepo.userId)
        .loadConversationDetail(conversationId);
    try {
      return await res.onCallBack(
        (_) async {
          final ReceivePort receivePort = ReceivePort();

          final CurrentUserInfoModel currentUserInfoModel =
              SystemUtils.getCurrrentUserInfoAndUserType();

          await Isolate.spawn(_computeGetChatConversation, [
            res,
            receivePort.sendPort,
            currentUserId,
            currentUserInfoModel.userInfo,
            currentUserInfoModel.userType,
          ]);

          return (await receivePort.first) as ChatItemModel;
        },
      );
    } catch (e) {}
    return null;
  }

  static _computeGetChatConversation(List params) {
    Isolate.exit(
      (params[1] as SendPort),
      ChatItemModel.fromConversationInfoJsonOfUser(
        params[2],
        conversationInfoJson: json.decode(params[0].data)["data"]
            ["conversation_info"],
      ),
    );
  }

  Future loadData({int? countLoaded}) async {
    final List<ChatItemModel> _offlineData = [];

    if (!_isShowOfflineData && chatsMap.isEmpty) {
      _offlineData.addAll(await offlineData);
      if (_offlineData.isNotEmpty) {
        _isShowOfflineData = true;
        _didFetchListMessageFirstTime = true;
        _sortWithUnreadMessageCompare = true;
        add(ChatConversationEventAddData(
          _offlineData,
          saveToLocal: false,
        ));

        /// Delay 5000 vì màn Ds cuộc trò chuyện chưa build lần đầu mà bloc đã là
        /// ChatConversationErrorState do load từ ngoài và không có mạng
        // await Future.delayed(const Duration(milliseconds: 200));
        // AppDialogs.toast('Đang cập nhật danh sách ...');
        // return;
      }
    }

    // if (chats.isEmpty)
    add(ChatConversationEventAddLoadingState(markNeedBuild: chatsMap.isEmpty));

    // await Future.delayed(const Duration(seconds: 5));

    try {
      var count = countLoaded ?? _countLoaded;
      final value = await getListChatCoversasion(
        count,
        useFastApi: useFastApi,
      );

      _didFetchListMessageFirstTime = true;

      if (_isShowOfflineData) {
        _isShowOfflineData = false;
      }

      if (value.isNotEmpty) page++;

      if (count == 0) {
        _sortWithUnreadMessageCompare = true;
      }

      useFastApi = false;

      add(ChatConversationEventAddData(value, saveToLocal: true));
    } on CustomException catch (e) {
      if (e.error.isExceedListConversation) {
        didExceedList = true;
      } else if (!_isShowOfflineData &&
          e.error.isNetworkException &&
          _offlineData.isNotEmpty &&
          chatsMap.isEmpty) {
        AppDialogs.toast('Bạn đang hiển thị dữ liệu offline');
        _isShowOfflineData = true;
        _didFetchListMessageFirstTime = true;
        if (!chatItemModelBox!.isOpen)
          await Hive.openBox(HiveBoxNames.chatItemModelBox);
        return add(ChatConversationEventAddData(
          _offlineData,
          saveToLocal: false,
        ));
      }
      // if (!_isShowOfflineData)

      add(ChatConversationEventRaiseError(e.error));
    }
  }

  Future _getListLastMessages(List<ChatItemModel> conversations) async {
    conversations
        .removeWhere((e) => !chatsMap[e.conversationId]!.lastMessages.isBlank);

    // Do api chậm nên fetch 10 cuộc trò chuyện mỗi lần
    var countTime = (conversations.length / 10).ceil();

    final List<List<ChatItemModel>> truncs = List.from(
      List.generate(
        countTime,
        (index) => conversations.slice(
          start: index * 10,
          end: index * 10 + 10,
        ),
      ),
    );

    return Future.wait(
      truncs.map(
        (e) => _fetchListLastMessage(e),
      ),
    );
  }

  Future _fetchListLastMessage(
    List<ChatItemModel> value,
  ) async {
    try {
      final Map<int, List<SocketSentMessageModel>> lastMessages =
          await _chatConversationsRepo.getListLastMessagesOfListConversations(
        value.map((e) => e.conversationId).toList(),
        value.map((e) => e.messageDisplay).toList(),
      );

      lastMessages.forEach(
        (conversationId, listMessages) {
          logger.log(
            'Set $conversationId ${listMessages.length} messages',
            name: 'SetOfflineMessage',
          );
          chatsMap[conversationId]?.lastMessages = listMessages;
        },
      );

      compute(_encodeListMessage, lastMessages).then(
        HiveService().saveMapConversationIdAndEncodedMessage,
      );
    } catch (e, s) {
      logger.logError(e, s);
    }
    return null;
  }

  static Map<int, String> _encodeListMessage(
    Map<int, List<SocketSentMessageModel>> lastMessages,
  ) =>
      lastMessages.map(
        (k, listMessages) => MapEntry(
          k,
          json.encode(
            listMessages
                .map((e) => sockeSentMessageModelToHiveObjectJson(e))
                .toList(),
          ),
        ),
      );

  _saveChatItemModelToLocal(Iterable<ChatItemModel> value) async {
    if (chatItemModelBox !=
        null /* && chatItemModelBox!.values.length < 100 */) {
      try {
        if (!chatItemModelBox!.isOpen)
          await Hive.openBox(HiveBoxNames.chatItemModelBox);
        // chatItemModelBox!.clear();
        chatItemModelBox!.putAll(
          Map.fromIterable(
            value,
            key: (e) => (e as ChatItemModel).conversationId,
          ),
        );
      } catch (e, s) {
        logger.logError(e, s);
      }
    }
  }

  Future<ExceptionError?> deleteConversation(int conversationId) async {
    var res = await _chatConversationsRepo.deleteConversation(conversationId);
    try {
      var hasError = await res.onCallBack((_) => res.hasError);
      if (!hasError) {
        _chatConversationsRepo.totalRecords -= 1;
        chatsMap.remove(conversationId);
        loadData();
        try {
          HiveService().listMessagesBox?.delete(conversationId);
        } catch (e, s) {
          logger.logError(e, s, 'RemoveDeletedConversationFromBoxError');
        }
        return null;
      }
      return res.error;
    } on CustomException catch (e) {
      return e.error;
    }
  }

  Future<ExceptionError?> changeFavoriteConversation(
    int conversationId, {
    required int favorite,
  }) async {
    var res = await _chatConversationsRepo.changeFavoriteConversationStatus(
      conversationId,
      favorite: favorite,
    );

    try {
      var hasError = await res.onCallBack((_) => res.hasError);

      onChangeFavorite(conversationId, favorite);

      if (!hasError) {
        chatRepo.emitChangeFavoriteconversationStatus(
          currentUserId,
          conversationId,
          favorite,
        );

        return null;
      }
      return res.error;
    } on CustomException catch (e) {
      return e.error;
    }
  }

  FutureOr onChangeFavorite(int conversationId, int favorite) async {
    final ChatItemModel detail;
    if (favoriteConversations[conversationId] != null) {
      detail = favoriteConversations[conversationId]!;
    } else {
      detail = (await fetchSingleChatConversation(conversationId))!;
    }

    if (favorite == 0)
      add(ChatConversationEventRemoveFavoriteConversation(detail));
    else
      add((ChatConversationEventAddFavoriteConversation(detail)));
  }

  /// Xử lý danh sách conversation khi có sự kiện [ChatStateOnOutGroup]
  onOutGroup(int conversationId, int deletedMember) {
    var favoriteItem = favoriteConversations[conversationId];

    if (deletedMember == currentUserId) {
      /// Xóa khỏi cuộc trò chuyện yêu thích
      if (favoriteItem != null)
        add(ChatConversationEventRemoveFavoriteConversation(favoriteItem));

      /// Xóa cuộc trò chuyện đó nếu xuất hiện trên UI
      var item = chatsMap.remove(conversationId);
      if (item != null) add(ChatConversationEventAddData([]));
    } else {
      var item = chatsMap[conversationId];
      if (item != null)
        item.memberList = [
          ...item.memberList..removeWhere((e) => e.id == deletedMember)
        ];
      if (favoriteItem != null)
        favoriteItem.memberList = [
          ...favoriteItem.memberList..removeWhere((e) => e.id == deletedMember)
        ];
    }
  }
}
