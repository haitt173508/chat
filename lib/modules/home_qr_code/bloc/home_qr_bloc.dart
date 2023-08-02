import 'dart:async';
import 'dart:convert';

import 'package:chat_365/common/blocs/friend_cubit/cubit/friend_cubit.dart';
import 'package:chat_365/core/constants/chat_socket_event.dart';
import 'package:chat_365/data/services/generator_service.dart';
import 'package:chat_365/main.dart';
import 'package:chat_365/modules/chat/blocs/chat_bloc/chat_bloc.dart';
import 'package:chat_365/modules/chat/model/api_message_model.dart';
import 'package:chat_365/modules/chat/repo/chat_repo.dart';
import 'package:chat_365/modules/chat_conversations/models/result_chat_conversation.dart';
import 'package:chat_365/modules/home_qr_code/model/add_group_model.dart';
import 'package:chat_365/modules/home_qr_code/repo/home_qr_code_repo.dart';
import 'package:chat_365/utils/data/clients/chat_client.dart';
import 'package:chat_365/utils/data/enums/message_type.dart';
import 'package:chat_365/utils/data/extensions/context_extension.dart';
import 'package:chat_365/utils/helpers/logger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'home_qr_state.dart';

class HomeQRCodeBloc extends Cubit<HomeQRCodeState> {
  HomeQRCodeRepo _homeQRCodeRepo = HomeQRCodeRepo();

  HomeQRCodeBloc() : super(HomeQRCodeInitial());

  Future allowLoginQR(
    String? idQR,
    String? email,
    String? password,
  ) async {
    var res = await _homeQRCodeRepo.appLoginPC(
      idQR,
      email,
      password,
    );
    emit(HomeQRCodeLoadingState());
    try {
      if (res.error == null) {
        emit(HomeQRCodeLoadedState());
      } else {
        emit(HomeQRCodeError(res.error));
        print('Error: ${res.error}');
      }
    } catch (e, s) {
      logger.logError(e, s);
      // emit(LoginErrorQR(e.toString()));
    }
  }

  AddGroupModel? model;
  String? error;

  Future addGroupMessage(
    int? idUser,
    String? data,
  ) async {
    var res = await _homeQRCodeRepo.addGroup(
      idUser,
      data,
    );
    emit(AddGroupLoadingState());
    try {
      if (res.error == null) {
        var currentUserId = navigatorKey.currentContext!.userInfo().id;
        final model = ChatItemModel.fromConversationInfoJsonOfUser(
          currentUserId,
          conversationInfoJson: jsonDecode(res.data)['data']
              ['conversationInfo'],
        );

        chatRepo.sendMessage(
          ApiMessageModel(
            conversationId: model.conversationId,
            messageId: GeneratorService.generateMessageId(currentUserId),
            senderId: currentUserId,
            createdAt: DateTime.now(),
            message: '$currentUserId joined this conversation',
            type: MessageType.notification,
          ),
          recieveIds: model.memberList.map((e) => e.id).toList(),
          conversationBasicInfo: model.conversationBasicInfo,
        );
        navigatorKey.currentContext!.read<ChatBloc>().tryToChatScreen(
              chatInfo: model,
            );
        chatClient.emit(ChatSocketEvent.newMemberAddedToGroup, [
          model.conversationId,
          [currentUserId],
          model.memberList.map((e) => e.id).toList(),
        ]);
      } else {
        error = res.error?.messages;
        emit(HomeQRCodeError(res.error));
        print('Error: ${res.error}');
      }
    } catch (e, s) {
      logger.logError(e, s);
      // emit(LoginErrorQR(e.toString()));
    }
  }

  Future addFriendQR(
    int? idUser,
    String? data,
  ) async {
    emit(AddGroupLoadingState());
    var res = await _homeQRCodeRepo.addGroup(
      idUser,
      data,
    );
    try {
      if (res.error == null) {
        var currentUserId = navigatorKey.currentContext!.userInfo().id;
        final model = ChatItemModel.fromConversationInfoJsonOfUser(
          currentUserId,
          conversationInfoJson: jsonDecode(res.data)['data']
              ['conversationInfo'],
        );
        final checkFriend = addGroupModelFromJson(res.data);
        if (checkFriend.data?.result == true)
          navigatorKey.currentContext!
              .read<FriendCubit>()
              .addFriend(model.firstOtherMember(currentUserId));
        navigatorKey.currentContext!.read<ChatBloc>().tryToChatScreen(
              chatInfo: model,
            );
      } else {
        emit(HomeQRCodeError(res.error));
        print('Error: ${res.error}');
      }
    } catch (e, s) {
      logger.logError(e, s);
      // emit(LoginErrorQR(e.toString()));
    }
  }
}
