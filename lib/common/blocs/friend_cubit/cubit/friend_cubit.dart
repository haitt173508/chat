import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:chat_365/common/blocs/friend_cubit/model/result_friend_model.dart';
import 'package:chat_365/common/blocs/friend_cubit/repo/friend_repo.dart';
import 'package:chat_365/core/error_handling/exceptions.dart';
import 'package:chat_365/core/interfaces/interface_user_info.dart';
import 'package:chat_365/main.dart';
import 'package:chat_365/modules/auth/modules/login/models/result_login.dart';
import 'package:chat_365/modules/auth/repo/auth_repo.dart';
import 'package:chat_365/modules/chat/blocs/chat_bloc/chat_bloc.dart';
import 'package:chat_365/modules/chat/repo/chat_repo.dart';
import 'package:chat_365/modules/contact/model/api_contact.dart';
import 'package:chat_365/modules/contact/repos/contact_list_repo.dart';
import 'package:chat_365/utils/data/enums/friend_status.dart';
import 'package:chat_365/utils/data/extensions/context_extension.dart';
import 'package:chat_365/utils/data/models/exception_error.dart';
import 'package:chat_365/utils/helpers/logger.dart';
import 'package:equatable/equatable.dart';

part 'friend_state.dart';

class FriendCubit extends Cubit<FriendState> {
  FriendCubit({
    required this.chatRepo,
    // required this.contactListRepo,
  }) : super(FriendStateLoading()) {
    _subscription = chatRepo.stream.listen((event) async {
      if (event is ChatEventOnFriendStatusChanged) {
        await fetchFriendData();
        // if (friendsRequest == null) return;
        var status = event.status;
        var senderId = event.requestUserId;
        var recieveId = event.responseUserId;
        // try {
        //   var res = await AuthRepo().getUserInfo(recieveId);
        //   var resultLoginData = resultLoginFromJson(res.data).data!;
        //   listFriends?.add(resultLoginData.userInfo);
        // } catch (e, s) {
        //   logger.logError(e, s);
        // }
        changeStatus(senderId, recieveId, status);
      } else if (event is ChatEventOnDeleteContact) {
        var otherId;
        if (userId == event.userId)
          otherId = event.chatId;
        else
          otherId = event.userId;
        friendsRequest?.remove(otherId);
        listFriends?.removeWhere(
          (element) => element.id == otherId,
        );
        emit(FriendStateDeleteContact(event.userId, event.chatId));
        // emit(FriendStateLoadSuccess());
      }
    });
  }

  int get userId => navigatorKey.currentContext!.userInfo().id;
  int? get companyId => navigatorKey.currentContext!.userInfo().companyId;

  final FriendRepo _friendRepo = FriendRepo();
  final ChatRepo chatRepo;
  late final StreamSubscription _subscription;
  Map<int, FriendModel>? friendsRequest;
  Set<IUserInfo>? listFriends;

  changeStatus(int senderId, int responseId, FriendStatus status) async {
    if (status == FriendStatus.accept) {
      friendsRequest!.remove(responseId);
    } else {
      friendsRequest![responseId] = FriendModel(
        userId: userId,
        contactId: responseId,
        status: status,
      );
    }
    emit(
      FriendStateLoadSuccess(),
    );
  }

  tryToFetchListFriendRequest() {
    if (friendsRequest == null || listFriends == null) fetchFriendData();
  }

  Future fetchListFriend() async {
    var contactListRepo = ContactListRepo(
      userId,
      companyId: companyId ?? 0,
    );
    try {
      listFriends = <IUserInfo>{...(await contactListRepo.getMyContact())};
    } catch (e, s) {
      logger.logError(e, s, 'FetchListFriendError');
    }
  }

  Future<void> fetchFriendData() async {
    try {
      await Future.wait([
        getListFriendRequest(),
        fetchListFriend(),
      ]);
      if (friendsRequest == null)
        throw CustomException(
          ExceptionError(
            'Lấy danh sách lời mời kết bạn thất bại, vui lòng thử lại !',
          ),
        );
      else if (listFriends == null)
        throw CustomException(
          ExceptionError(
            'Lấy danh sách bạn bè thất bại, vui lòng thử lại !',
          ),
        );
      emit(FriendStateLoadSuccess());
    } on CustomException catch (e) {
      if (e.error.error == 'User không có lời mời nào') {
        friendsRequest = {};
        return emit(FriendStateLoadSuccess());
      }

      emit(FriendStateLoadError(e.error, markNeedBuild: true));
    }
  }

  Future getListFriendRequest() async {
    var res = await _friendRepo.getListRequest(userId);
    try {
      res.onCallBack((_) {
        var models = [
          ...resultFriendModelFromJson(res.data).data!.listRequestContact
        ];
        friendsRequest = Map<int, FriendModel>.fromIterable(
          models,
          key: (item) => (item as FriendModel).contactId,
        );
      });
    } on CustomException catch (_) {
      rethrow;
    }
  }

  Future<List<ApiContact>> getListNewsFriends() async {
    var res = await _friendRepo.getListNewFriends(userId);
    try {
      return res.onCallBack((_) {
        return List<ApiContact>.from(
            jsonDecode(res.data)['data']['listAccount'].map((e) => ApiContact(
                  avatar: e['avatarUser'],
                  name: e['userName'],
                  id: e['_id'],
                  companyId: null,
                  lastActive: DateTime.tryParse(e['lastActive']),
                )));
      });
    } on CustomException catch (_) {
      return [];
    }
  }

  Future<bool> _deleteRequestAddFriend(int senderId, int recieveId) async {
    var deleteRequest =
        await _friendRepo.deleteRequestAddFriend(senderId, recieveId);
    try {
      return deleteRequest.onCallBack(
        (_) {
          var decode = json.decode(deleteRequest.data)['data'];
          var isExist = false;
          try {
            if (json.decode(deleteRequest.data)['error']['message'] ==
                "Lời mời không tồn tại") {
              isExist = true;
            }
          } catch (_) {}
          return isExist || decode['result'];
        },
      );
    } on CustomException catch (e) {
      if (e.error.error == "Lời mời không tồn tại") return true;
      return false;
    } catch (e, s) {
      logger.logError(e, s);
      return false;
    }
  }

  Future<bool> deleteRequestAddFriend(int senderId, int recieveId) async {
    var res = await _deleteRequestAddFriend(senderId, recieveId);
    if (res) {
      friendsRequest?.remove(recieveId);
      emit(FriendStateLoadSuccess());
    }
    return res;
  }

  Future<ExceptionError?> addFriend(IUserInfo recieve) async {
    var senderId = navigatorKey.currentContext!.userInfo().id;
    var recieveId = recieve.id;
    emit(FriendStateAddFriendLoading(chatId: recieveId));
    try {
      if (friendsRequest?[recieveId]?.status == FriendStatus.decline) {
        var isDdeleteSuccess =
            await deleteRequestAddFriend(senderId, recieveId);
        if (isDdeleteSuccess) {
          return _addFriend(senderId, recieve);
        } else
          throw CustomException(
            ExceptionError('Kết bạn thất bại, vui lòng thử lại'),
          );
      } else
        return _addFriend(senderId, recieve);
    } on CustomException catch (e) {
      emit(FriendStateAddFriendError(recieveId, e.error));
      return e.error;
    }
  }

  Future<ExceptionError?> _addFriend(int senderId, IUserInfo reciever) async {
    try {
      var res = await _friendRepo.addFriend(senderId, reciever.id);
      res.onCallBack((_) => res.result);
      friendsRequest?[reciever.id]?.changeStatus(FriendStatus.send);
      emit(FriendStateAddFriendSuccess(reciever));
      chatRepo.emitAddFriend(senderId, reciever.id);
      return null;
    } on CustomException catch (e) {
      if (e.error.error == 'User đã tồn tại lời mời') {
        emit(FriendStateAddFriendSuccess(reciever));
        chatRepo.emitAddFriend(senderId, reciever.id);
        return null;
      }
      emit(FriendStateAddFriendError(reciever.id, e.error));
      return e.error;
    }
  }

  responseAddFriend(
    int responseId,
    IUserInfo requestUser,
    FriendStatus status,
  ) async {
    var requestId = requestUser.id;
    emit(FriendStateResponseAddFriendLoading(requestId));

    try {
      var res = await chatRepo.responseAddFriend(
        responseId,
        requestId,
        status,
      );

      if (res) {
        if (status == FriendStatus.accept)
          listFriends?.add(requestUser);
        else
          listFriends?.removeWhere((e) => e.id == responseId);
        emit(FriendStateResponseAddFriendSuccess(
          requestId,
          status,
          requestInfo: requestUser,
        ));
      }
    } on CustomException catch (e) {
      emit(FriendStateResponseAddFriendError(e.error, requestId));
    } catch (e, s) {
      logger.logError(e, s);
      emit(FriendStateResponseAddFriendError(
          ExceptionError.unknown(), requestId));
    }
  }

  Future<ExceptionError?> deleteContact(int contact) async {
    var res = await _friendRepo.deleteContact(userId, contact);
    try {
      res.onCallBack((_) {
        if (res.result == true) {
          chatRepo.emitDeleteContact(userId, contact);
          emit(FriendStateDeleteContact(userId, contact));
        }
      });
    } on CustomException catch (e) {
      return e.error;
    }
    return null;
  }

  @override
  void onChange(Change<FriendState> change) async {
    if (change.nextState is FriendStateAddFriendSuccess) {
      var chatId = (change.nextState as FriendStateAddFriendSuccess).chatId;
      friendsRequest?[chatId] = FriendModel(
        userId: userId,
        contactId: chatId,
        status: FriendStatus.send,
      );
    } else if (change.nextState is FriendStateResponseAddFriendSuccess) {
      var nextState = (change.nextState as FriendStateResponseAddFriendSuccess);
      var chatId = nextState.requestId;
      var senderId = navigatorKey.currentContext!.userInfo().id;

      try {
        var userInfo;
        if (nextState.requestInfo == null) {
          var res = await AuthRepo().getUserInfo(chatId);
          var resultLoginData = resultLoginFromJson(res.data).data!;
          userInfo = resultLoginData.userInfo;
        } else
          userInfo = nextState.requestInfo!;

        if (nextState.status == FriendStatus.accept) listFriends?.add(userInfo);

        changeStatus(
          senderId,
          chatId,
          (change.nextState as FriendStateResponseAddFriendSuccess).status,
        );
      } catch (e, s) {
        logger.logError(e, s);
      }
    }
    super.onChange(change);
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}
