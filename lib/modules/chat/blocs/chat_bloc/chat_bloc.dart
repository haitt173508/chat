import 'dart:async';
import 'dart:convert';

import 'package:chat_365/core/error_handling/exceptions.dart';
import 'package:chat_365/core/interfaces/interface_user_info.dart';
import 'package:chat_365/data/services/generator_service.dart';
import 'package:chat_365/main.dart';
import 'package:chat_365/modules/auth/repo/auth_repo.dart';
import 'package:chat_365/modules/chat/model/api_message_model.dart';
import 'package:chat_365/modules/chat/model/result_socket_chat.dart';
import 'package:chat_365/modules/chat/repo/chat_repo.dart';
import 'package:chat_365/modules/chat_conversations/models/conversation_basic_info.dart';
import 'package:chat_365/modules/chat_conversations/models/result_chat_conversation.dart';
import 'package:chat_365/service/local_message_notification_service.dart';
import 'package:chat_365/utils/data/enums/auth_status.dart';
import 'package:chat_365/utils/data/enums/chat_feature_action.dart';
import 'package:chat_365/utils/data/enums/emoji.dart';
import 'package:chat_365/utils/data/enums/friend_status.dart';
import 'package:chat_365/utils/data/enums/message_type.dart';
import 'package:chat_365/utils/data/enums/process_message_type.dart';
import 'package:chat_365/utils/data/extensions/context_extension.dart';
import 'package:chat_365/utils/data/extensions/date_time_extension.dart';
import 'package:chat_365/utils/data/extensions/list_extension.dart';
import 'package:chat_365/utils/data/models/exception_error.dart';
import 'package:chat_365/utils/helpers/logger.dart';
import 'package:chat_365/utils/ui/app_dialogs.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc(this._chatRepo) : super(ChatInitial()) {
    on<ChatEventOnRecievedMessage>((event, emit) {
      // sendingMessage
      //     .removeWhere((key, value) => key.messageId == event.msg.messageId);
      // errorMessage.removeWhere(
      //     (element, _) => element.messageId == event.msg.messageId);
      var msg = event.msg;
      emit(ChatStateRecieveMessage(msg));
    });

    on<ChatEventEmitSendMessage>(_onSendMessageEvent);

    on<ChatEventEmitTypingChanged>((event, emit) {
      _chatRepo.changeCurrentUserTypingState(
        event.isTyping,
        conversationId: event.conversationId,
        listMemeber: event.listMembers,
        userId: event.userId,
      );
    });

    on<ChatEventRaiseSendMessageError>((event, emit) {
      // sendingMessage.removeMessage(event.message);
      // errorMessage.putIfAbsent(event.message, () => event.error);
      emit(ChatStateSendMessageError(
        event.error,
        message: event.message,
      ));
    });

    on<ChatEventToEmitDeleteMessageWithMessageIndexInConversation>((ev, em) {
      em(ChatStateDeleteMessageSuccess(
        ev.messageId,
        ev.conversationId,
        messageIndex: ev.messageIndex,
        messageAbove: ev.aboveMessage,
        messageBelow: ev.belowMessage,
      ));
    });

    on<ChatEventAddProcessingMessage>((event, emit) {
      // sendingMessage[event.message] = event.processingType;
      // errorMessage.removeMessage(event.message);
      emit(ChatStateInProcessingMessage(event.message));
    });

    on<ChatEventEmitEditMessage>(_onEditMessageEvent);

    on<ChatEventOnMessageEditted>(
      (event, emit) => emit(
        ChatStateEditMessageSuccess(
          event.conversationId,
          event.messageId,
          event.newMessage,
        ),
      ),
    );

    on<ChatEventEmitDeleteMessage>(_onDeleteMessageEvent);

    on<ChatEventLogUotAllDevice>(_onLogUotAllDevice);

    on<ChatEventOnNewMemberAddedToGroup>((event, emit) => emit(
        ChatStateNewMemberAddedToGroup(event.conversationId, event.members)));

    on<ChatEventGetConversationId>((event, emit) async {
      IUserInfo newChatInfo;
      int conversationId;
      bool isGroup;
      ChatItemModel? chatItemModel;
      try {
        // truyền vào ChatItemModel
        if (event.chatInfo is ChatItemModel) {
          ChatItemModel model = event.chatInfo;
          conversationId = model.conversationId;
          newChatInfo = model.conversationBasicInfo;
          chatItemModel = model;
          isGroup = model.isGroup;
        }
        // truyền vào id của người chat
        else if (event.userId != null) {
          emit(ChatStateGettingConversationId());
          conversationId = await getConversationId(
            event.senderId,
            event.userId!,
          );
          newChatInfo = (await chatRepo.getConversationInfo(conversationId))!;
          isGroup = (newChatInfo as ConversationBasicInfo).isGroup;
        }
        // truyền vào conversationId
        else if (event.conversationId != null) {
          emit(ChatStateGettingConversationId());
          conversationId = event.conversationId!;
          newChatInfo = (await chatRepo.getConversationInfo(conversationId))!;
          isGroup = (newChatInfo as ConversationBasicInfo).isGroup;
        }
        // truyền vào ConversationBasicInfo
        else if (event.chatInfo is ConversationBasicInfo) {
          ConversationBasicInfo model = event.chatInfo;
          conversationId = model.conversationId;
          newChatInfo = model;
          isGroup = model.isGroup;

          if (conversationId == -1) {
            emit(ChatStateGettingConversationId());
            conversationId =
                (await getConversationId(event.senderId, model.userId));
          }

          if (event.isNeedToFetchChatInfo == true) {
            emit(ChatStateGettingConversationId());
            var resNewChatInfo = await (isGroup
                ? chatRepo.getConversationInfo(conversationId)
                : chatRepo.getUserInfo(model.userId));
            if (resNewChatInfo != null) newChatInfo = resNewChatInfo;
          }
        }
        // truyền vào IUserInfo, bắt buộc isGroup != null
        else if (event.chatInfo is IUserInfo && event.isGroup != null) {
          emit(ChatStateGettingConversationId());
          IUserInfo model = event.chatInfo;
          isGroup = event.isGroup!;
          conversationId = (await getConversationId(event.senderId, model.id));
          newChatInfo = (await (isGroup
                  ? chatRepo.getConversationInfo(model.id)
                  : chatRepo.getUserInfo(model.id))) ??
              model;
        } else
          throw CustomException(ExceptionError('Kiểu dữ liệu không hợp lệ'));

        emit(ChatStateGetConversationIdSuccess(
          conversationId,
          newChatInfo,
          isGroup,
          action: event.action,
          chatItemModel: chatItemModel,
        ));
      } catch (e, s) {
        logger.logError(e, s);
        emit(ChatStateGetConversationIdError(
          e is CustomException ? e.error : ExceptionError.unknown(),
          event.chatInfo,
        ));
      }
    });

    on<ChatEventOnDeleteMessage>(_onEventOnDeleteMessage);

    on<ChatEventResendMessage>(_onEventResendMessage);

    on<ChatEventOnChangeFavoriteStatus>(
        (event, emit) => emit(ChatStateFavoriteConversationStatusChanged(
              event.conversationId,
              event.isChangeToFavorite,
            )));
    on<ChatEventOnOutGroup>((event, emit) => emit(ChatStateOutGroup(
          event.conversationId,
          event.deletedMemberId,
          event.newAdminId,
        )));

    _chatRepo.stream.listen(add);
  }

  final ChatRepo _chatRepo;

  // Map<ApiMessageModel, ProcessMessageType> sendingMessage = {};
  // Map<ApiMessageModel, ExceptionError> errorMessage = {};
  Map<String, ValueNotifier<double>> fileProgressListener = {};

  /// [messageId] và [ApiFileModel] đã chọn tương ứng khi vừa chọn file, thay thế placeholder
  Map<String, List<ApiFileModel>?> cachedMessageImageFile = {};

  FutureOr<void> _onEditMessageEvent(
      ChatEventEmitEditMessage event, emit) async {
    var message = event.message;
    add(ChatEventAddProcessingMessage(message));
    // await Future.delayed(const Duration(seconds: 2));
    try {
      await _chatRepo.editMessage(
        message.conversationId,
        message.messageId,
        message.message ?? '',
        members: event.memebers,
      );

      emit(
        ChatStateEditMessageSuccess(
          message.conversationId,
          message.messageId,
          message.message ?? '',
        ),
      );
    } on CustomException catch (e) {
      emit(ChatStateWarningMessageError(message.messageId, e.error));
    } finally {
      // sendingMessage.removeMessage(message);
    }
  }

  _onSendMessageEvent(
    ChatEventEmitSendMessage event,
    Emitter<ChatState> emit,
  ) async {
    logger.log(event.message.messageId, name: 'Sending messageID: ');
    add(ChatEventAddProcessingMessage(event.message));
    // return add(
    //   ChatEventRaiseSendMessageError(
    //     ExceptionError.unknown(),
    //     messageId: event.message.messageId,
    //   ),
    // );
    try {
      await _sendMessage(
        event.message,
        recieveIds: event.recieveIds,
        conversationBasicInfo: event.conversationBasicInfo,
        onlineUsers: event.onlineUsers,
      );
      // sendingMessage.removeMessage(event.message);
      // errorMessage.removeMessage(event.message);
      emit(ChatStateSendMessageSuccess(event.message.messageId));
      // FilePicker.platform.clearTemporaryFiles();
    } on CustomException catch (e) {
      // errorMessage.add(event.message);
      add(
        ChatEventRaiseSendMessageError(
          e.error,
          message: event.message,
        ),
      );
    }
  }

  Future _sendMessage(
    ApiMessageModel message, {
    required List<int> recieveIds,
    ConversationBasicInfo? conversationBasicInfo,
    List<int>? onlineUsers,
  }) async {
    var res = await _chatRepo.sendMessage(
      message,
      recieveIds: recieveIds,
      conversationBasicInfo: conversationBasicInfo,
      onlineUsers: onlineUsers,
      progress: fileProgressListener[message.messageId],
    );

    if (res.hasError) throw CustomException(res.error);
    fileProgressListener.remove(message.messageId);
    return true;
  }

  _onDeleteMessageEvent(ChatEventEmitDeleteMessage event, Emitter emit) async {
    try {
      add(
        ChatEventAddProcessingMessage(
          event.message,
          processingType: ProcessMessageType.deleting,
        ),
      );
      await _deleteMessage(event.message, members: event.members);
      emit(ChatStateDeleteMessageSuccess(
        event.message.messageId,
        event.message.conversationId,
      ));
    } on CustomException catch (e) {
      emit(ChatStateWarningMessageError(event.message.messageId, e.error));
    } finally {
      // sendingMessage.removeMessage(event.message);
    }
  }

  Future<void> _onLogUotAllDevice(
      ChatEventLogUotAllDevice, Emitter emit) async {
    try {
      emit(ChatStateLogUotAllDevice());
      // print('Đăng xuất xong 123');
    } catch (e) {
      print('Error: ${e.toString()}');
    }
  }

  _deleteMessage(
    ApiMessageModel message, {
    required List<int> members,
  }) {
    return _chatRepo.deleteMessage(
      message,
      members: members,
    );
  }

  /// [generateMessageId] = null => markRead tất cả tên nhắn
  markReadMessages({
    List<int>? messageIds,
    required int senderId,
    required int conversationId,
    required List<int> memebers,
  }) {
    _chatRepo.markReadMessage(
      conversationId: conversationId,
      senderId: senderId,
      memebers: memebers,
      messageIds: messageIds,
    );
  }

  sendMessage(
    ApiMessageModel message, {
    required List<int> memberIds,
    int? conversationId,
    ConversationBasicInfo? conversationBasicInfo,
    List<int>? onlineUsers,
  }) {
    if (!message.files.isBlank)
      fileProgressListener[message.messageId] = ValueNotifier<double>(0);
    cachedMessageImageFile[message.messageId] = message.files;
    this
      ..add(
        ChatEventEmitSendMessage(
          message,
          recieveIds: memberIds,
          conversationBasicInfo: conversationBasicInfo,
          onlineUsers: onlineUsers,
        ),
      );
    if (conversationId != null)
      this.add(
        ChatEventEmitTypingChanged(
          false,
          userId: navigatorKey.currentContext!.userInfo().id,
          conversationId: conversationId,
          listMembers: memberIds,
        ),
      );
  }

  tryToChatScreen({
    dynamic chatInfo,
    int? userId,
    int? conversationId,
    bool? isGroup = false,
    bool? isNeedToFetchChatInfo = false,
    ChatFeatureAction? action,
  }) {
    try {
      add(
        ChatEventGetConversationId(
          navigatorKey.currentContext?.userInfo().id ?? userInfo!.id,
          chatInfo: chatInfo,
          userId: userId,
          conversationId: conversationId,
          isGroup: isGroup,
          isNeedToFetchChatInfo: isNeedToFetchChatInfo,
          action: action,
        ),
      );
    } catch (e, s) {
      AppDialogs.toast(
        'Đã có lỗi xảy ra khi chuyển đến chi tiết cuộc trò chuyện',
      );
      logger.logError(e, s);
    }
  }

  /// return [chatId]
  ///
  /// Nếu chưa có cuộc trò chuyện [chatId] được tạo mới
  ///
  /// Nếu không trả về [chatId] cuộc trò chuyện đó
  Future<int> getConversationId(int senderId, int chatId) async {
    var res = await _chatRepo.getConversationId(chatId);
    return res.onCallBack(
      (_) =>
          int.parse(json.decode(res.data)['data']['conversationId'].toString()),
    );
  }

  // @override
  // void onEvent(ChatEvent event) {
  //   super.onEvent(event);
  //   if (event is ChatEventOnRecievedMessage) {
  //     // AppDialogs.toast('ChatBloc:RecievedMessage: ${event.msg.message}');
  //     logger.log(event.msg, name: 'ChatBloc:RecievedMessage');
  //   }
  // }

  FutureOr<void> _onEventOnDeleteMessage(
      ChatEventOnDeleteMessage event, Emitter<ChatState> emit) {
    emit(ChatStateDeleteMessageSuccess(event.messageId, event.conversationId));
  }

  FutureOr<void> _onEventResendMessage(
      ChatEventResendMessage event, Emitter<ChatState> emit) async {
    var currentTick = DateTimeExt.currentTicks;

    for (var i = 0; i < event.messages.length; i++) {
      await Future.delayed(const Duration(milliseconds: 100));
      var message = event.messages.elementAt(i);

      emit(ChatStateDeleteMessageSuccess(
        message.messageId,
        event.conversationId,
      ));

      await Future.delayed(const Duration(milliseconds: 100));

      var newMessage = message.copyWith(
        messageId: GeneratorService.generateMessageId(
          message.senderId,
          currentTick + i,
        ),
        message: message.message,
      );

      event.onResend?.call(newMessage);

      sendMessage(
        newMessage,
        memberIds: event.members,
      );
    }
  }
}
