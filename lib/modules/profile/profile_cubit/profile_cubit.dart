import 'dart:convert';
import 'dart:io';

import 'package:chat_365/core/constants/api_path.dart';
import 'package:chat_365/core/error_handling/exceptions.dart';
import 'package:chat_365/core/interfaces/interface_user_info.dart';
import 'package:chat_365/main.dart';
import 'package:chat_365/modules/chat/repo/chat_detail_repo.dart';
import 'package:chat_365/modules/chat/repo/chat_repo.dart';
import 'package:chat_365/modules/chat_conversations/models/result_chat_conversation.dart';
import 'package:chat_365/modules/profile/profile_cubit/profile_state.dart';
import 'package:chat_365/modules/profile/repos/group_profile_repo.dart';
import 'package:chat_365/utils/data/clients/api_client.dart';
import 'package:chat_365/utils/data/enums/user_status.dart';
import 'package:chat_365/utils/data/extensions/context_extension.dart';
import 'package:chat_365/utils/data/models/exception_error.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart' as path;

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit(
    this.chatId, {
    required this.isGroup,
  })  : profileRepo = GroupProfileRepo(
          chatId,
          isGroup,
        ),
        detailRepo = ChatDetailRepo(
          senderId,
        ),
        super(ChangePasswordStateLoading()) {
    loadProfile();
  }

  final ChatDetailRepo detailRepo;
  static int senderId = navigatorKey.currentContext!.userInfo().id;
  final GroupProfileRepo profileRepo;
  final int chatId;
  final bool isGroup;
  final ChatRepo chatRepo = navigatorKey.currentContext!.read<ChatRepo>();

  loadProfile() async {
    if (!isGroup) return;
    emit(ChangePasswordStateLoading());
    var res = await detailRepo.loadConversationDetail(chatId);
    try {
      res.onCallBack(
        (_) => emit(
            ProfileStateLoadDone(ChatItemModel.fromConversationInfoJsonOfUser(
          detailRepo.userId,
          conversationInfoJson: json.decode(res.data)["data"]
              ["conversation_info"],
        ))),
      );
    } on CustomException catch (e) {
      emit(ProfileStateLoadError(e.error));
    }
  }

  void changeStatus(String text) async {
    await profileRepo.changeStatus(text);
  }

  void changeUserStatus(UserStatus status) async {
    await profileRepo.changeUserStatus(status);
  }

  changePassword(
      {required String newPassword, required String oldPassword}) async {
    // if (!isGroup) return;
    emit(ChangePasswordStateLoading());
    var res = await detailRepo.changePassword(
        email: navigatorKey.currentContext!.userInfo().email!,
        type365: navigatorKey.currentContext!.userType().id,
        newPassword: newPassword,
        oldPassword: oldPassword);
    try {
      res.onCallBack(
        (_) => emit(ChangePasswordStateDone()),
      );
    } on CustomException catch (e) {
      emit(ChangePasswordStateError(e.error));
    }
  }

  addToFavorList(
      {required String newPassword, required String oldPassword}) async {
    // if (!isGroup) return;
    emit(ChangePasswordStateLoading());
    var res = await detailRepo.changePassword(
        email: navigatorKey.currentContext!.userInfo().email!,
        type365: navigatorKey.currentContext!.userType().id,
        newPassword: newPassword,
        oldPassword: oldPassword);
    try {
      res.onCallBack(
        (_) => emit(ChangePasswordStateDone()),
      );
    } on CustomException catch (e) {
      emit(ChangePasswordStateError(e.error));
    }
  }

  Future<int> getConversationId(int senderId, int chatId) async {
    var res = await chatRepo.getConversationId(chatId);
    return res.onCallBack(
      (_) =>
          int.parse(json.decode(res.data)['data']['conversationId'].toString()),
    );
  }

  //Thay doi ca biet danh va ten cua nguoi dung
  changeNickName(
    String newNickName,
    IUserInfo userInfo,
    bool isGroup,
    int userMainId,
    int userMainType,
    List<int> members,
  ) async {
    emit(ChangeNameStateLoading());
    try {
      int conversationId = userInfo.id;
      if (userInfo.id != userMainId)
        conversationId = await getConversationId(
          userInfo.id,
          chatId,
        );
      if (newNickName.replaceAll(' ', '') == '') {
        newNickName = '';
      }
      if (newNickName != '') {
        var id = isGroup ? chatId : conversationId;
        var res = await ApiClient().fetch(
          isGroup
              ? ApiPath.changeNickNameGroup
              : userInfo.id != userMainId
                  ? ApiPath.changeNickName
                  : ApiPath.changeUserName,
          data: userInfo.id != userMainId
              ? {
                  'conversationId': isGroup ? chatId : conversationId,
                  'conversationName': newNickName,
                  if (!isGroup)
                    'adminId': navigatorKey.currentContext!.userInfo().id,
                }
              : {
                  'ID': userMainId,
                  'UserName': newNickName,
                  'Type365': userMainType,
                },
        );
        if (!res.hasError) {
          if (userInfo.id == userMainId) {
            chatRepo.emitChangeUserName(userMainId, newNickName);
          } else
            chatRepo.emitNameChanged(
              id,
              newNickName,
              isGroup,
              members,
            );
          emit(ChangeNameStateDone());
        }
      } else
        emit(ChangeNameStateError(ExceptionError('')));
    } on CustomException catch (e) {
      emit(ChangeNameStateError(e.error));
    }
  }

  Future<ExceptionError?> deleteMember(
    IUserInfo userInfo,
    List<int> members, {
    int? newAdminId,
  }) async {
    emit(RemoveMemberStateLoading());
    // int conversationId = await _getConversationId(
    //   userInfo.id,
    //   chatId,
    // );
    try {
      var adminId = navigatorKey.currentContext!.userInfo().id;
      var deleteMemberId = userInfo.id;
      var res = await ApiClient().fetch(
        ApiPath.deleteMemberFromGroup,
        data: {
          'conversationId': chatId,
          'senderId': deleteMemberId,
          'adminId': newAdminId,
        },
      );
      print(res);
      if (!res.hasError) {
        emit(RemoveMemberStateDone());
        // WIO.EmitAsync("OutGroup", conversationId, userId, adminId, listMember);
        chatRepo.emitDeleteMember(
          chatId,
          deleteMemberId,
          adminId,
          members,
        );
      }
    } on CustomException catch (e) {
      emit(RemoveMemberStateError(e.error));
      return e.error;
    }

    return null;
  }

  //Doi avatar nguoi dung va group
  changeAvatar({
    required File fileAvatar,
    //Neu la nhom
    int? idConversation,
    required List<int> members,
  }) async {
    emit(ChangeAvatarStateLoading());
    try {
      late File newAvatar;

      /// Doi ten file va duoi anh
      // Doi mac dinh la jpg vi api doi anh nhom chi nhan jpg con anh nguoi dung gioi han 1 so dinh dang.
      if (isGroup && idConversation != null) {
        String dir = path.dirname(fileAvatar.path);
        String newPath = path.join(dir,
            '${DateTime.now().microsecondsSinceEpoch}_${idConversation}.${'jpg'}');
        newAvatar = await File(fileAvatar.path).copy(newPath);
      } else {
        String dir = path.dirname(fileAvatar.path);
        String newPath = path.join(dir,
            '${DateTime.now().microsecondsSinceEpoch}_${navigatorKey.currentContext!.userInfo().id}.${'jpg'}');
        newAvatar = await File(fileAvatar.path).copy(newPath);
      }

      var res = await ApiClient()
          .fetch(isGroup ? ApiPath.changeAvatarGroup : ApiPath.changeAvatarUser,
              data: {
                '': isGroup && idConversation != null
                    ? await MultipartFile.fromFile(
                        newAvatar.path,
                      )
                    : await MultipartFile.fromFile(newAvatar.path),
                if (!isGroup) 'ID': navigatorKey.currentContext!.userInfo().id,
              },
              options: Options(
                receiveTimeout: 30000,
                sendTimeout: 30000,
              ));
      print(res);
      if (!res.hasError) {
        if (isGroup && idConversation != null) {
          /// Thay anh nhom
          chatRepo.emitChangeAvatarGroup(
              idConversation, newAvatar.path.split('/').last, members);
        } else {
          /// Thay anh nguoi dung
          chatRepo.emitChangeAvatarUser(
            navigatorKey.currentContext!.userInfo().id,
            json.decode(res.data)["data"]["message"],
          );
        }

        emit(ChangeAvatarStateDone());
      } else {
        emit(ChangeAvatarStateError(ExceptionError('')));
      }
    } on CustomException catch (e) {
      emit(ChangeAvatarStateError(e.error));
    }
  }
}
