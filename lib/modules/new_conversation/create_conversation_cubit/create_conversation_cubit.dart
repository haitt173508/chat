import 'package:chat_365/core/constants/chat_socket_event.dart';
import 'package:chat_365/core/error_handling/app_error_state.dart';
import 'package:chat_365/core/error_handling/exceptions.dart';
import 'package:chat_365/core/interfaces/interface_user_info.dart';
import 'package:chat_365/main.dart';
import 'package:chat_365/modules/chat/model/chat_member_model.dart';
import 'package:chat_365/modules/chat/repo/chat_repo.dart';
import 'package:chat_365/modules/chat_conversations/models/conversation_basic_info.dart';
import 'package:chat_365/modules/chat_conversations/models/result_chat_conversation.dart';
import 'package:chat_365/modules/contact/model/api_contact.dart';
import 'package:chat_365/modules/new_conversation/conversation_creation_repo.dart';
import 'package:chat_365/modules/new_conversation/models/group_conversation_creation_kind.dart';
import 'package:chat_365/modules/new_conversation/models/list_login_history_model.dart';
import 'package:chat_365/modules/new_conversation/new_group_conversation_model.dart';
import 'package:chat_365/utils/data/clients/chat_client.dart';
import 'package:chat_365/utils/data/enums/message_type.dart';
import 'package:chat_365/utils/data/extensions/context_extension.dart';
import 'package:chat_365/utils/helpers/logger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'create_conversation_state.dart';

class CreateConversationCubit extends Cubit<CreateConversationState> {
  CreateConversationCubit({
    required ConversationCreationRepo repo,
  })  : model = NewGroupConversationModel(),
        _repo = repo,
        super(CreateConversationInitial());

  final NewGroupConversationModel model;

  final ConversationCreationRepo _repo;

  List<IUserInfo> selectedContacts = [];

  create(ApiContact contact) {
    emit(ConversationCreationInProgress());
  }

  createGroup(GroupConversationCreationKind conversationType) async {
    emit(ConversationCreationInProgress());

    try {
      final int conversationId = await _repo.createGroup(
        groupKind: conversationType,
        name: model.name.value,
        memberIds: selectedContacts.map((e) => e.id).toList(),
      );

      var userId = navigatorKey.currentContext!.userInfo().id;

      var chatItemModel = await chatRepo.getChatItemModel(conversationId);

      var lastMessage =
          '$userId added ${selectedContacts.last.id} to this consersation';

      emit(
        ConversationCreationSuccess(
          chatItemModel ??
              ChatItemModel(
                conversationId: conversationId,
                numberOfUnReadMessgae: 0,
                isGroup: true,
                senderId: userId,
                message: lastMessage,
                messageType: MessageType.notification,
                totalNumberOfMessages: 1,
                messageDisplay: 0,
                typeGroup: conversationType.serverName,
                adminId: conversationId,
                memberList: selectedContacts
                    .map(
                      (e) => ChatMemberModel(
                        id: e.id,
                        name: e.name,
                        avatar: e.avatar,
                        userStatus: e.userStatus,
                        companyId: e.companyId,
                        lastActive: e.lastActive,
                        status: e.status,
                        unReader: e.id == userId ? 0 : -1,
                      ),
                    )
                    .toList(),
                isFavorite: false,
                isHidden: false,
                createAt: DateTime.now(),
                conversationBasicInfo: ConversationBasicInfo(
                  userId: userId,
                  avatar: '',
                  name: model.name.value.isNotEmpty
                      ? model.name.value
                      : selectedContacts.map((e) => e.name).join(', '),
                  conversationId: conversationId,
                  isGroup: true,
                  countUnreadMessage: 0,
                  groupLastSenderId: userId,
                  lastConversationMessage: lastMessage,
                  lastConversationMessageTime: DateTime.now(),
                  totalGroupMemebers: selectedContacts.length,
                ),
              ),
        ),
      );
      chatClient.emit(
        ChatSocketEvent.createGroup,
        [conversationId, selectedContacts.map((e) => e.id).toList()],
      );
    } catch (e, s) {
      logger.logError(e, s);
      emit(ConversationCreationFailure(
          AppErrorStateExt.getFriendlyErrorString(e)));
    }
  }

  ListLoginHistoryModel? listLoginHistoryModel;
  List<LatestDevice> loginHistoryData = [];
  LatestDevice? latestDevice;

  //
  // String? nameDevice;
  // String? address;
  // String? time;
  // String? nameDeviceNew;
  // String? addressNew;
  String? timeNew;

  listLoginHistory(int? idUser) async {
    emit(LoginHistoryLoading());
    var res = await _repo.listLoginHistory(
      idUser,
    );
    try {
      if (res.error == null) {
        listLoginHistoryModel = await listLoginHistoryModelFromJson(res.data);
        loginHistoryData = listLoginHistoryModel!.data!.historyAccess;
        latestDevice = listLoginHistoryModel?.data?.latestDevice;
        timeNew = DateFormat('dd.MM.yyyy').format(latestDevice!.time);
        emit(LoginHistoryLoad());
      } else {
        throw CustomException(res.error);
      }
    } catch (e, s) {}
  }
}
