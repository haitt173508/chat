import 'dart:async';

import 'package:chat_365/common/blocs/user_info_bloc/bloc/user_info_event.dart';
import 'package:chat_365/common/blocs/user_info_bloc/bloc/user_info_state.dart';
import 'package:chat_365/common/blocs/user_info_bloc/repo/user_info_repo.dart';
import 'package:chat_365/core/interfaces/interface_user_info.dart';
import 'package:chat_365/data/services/hive_service/hive_type_id.dart';
import 'package:chat_365/main.dart';
import 'package:chat_365/modules/auth/bloc/auth_bloc.dart';
import 'package:chat_365/modules/auth/modules/login/models/result_login.dart';
import 'package:chat_365/modules/chat_conversations/models/conversation_basic_info.dart';
import 'package:chat_365/utils/data/enums/auth_status.dart';
import 'package:chat_365/utils/data/enums/user_status.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'user_info_bloc.g.dart';

@HiveType(typeId: HiveTypeId.userInfoBlocHiveTypeId)
class UserInfoBloc extends Bloc<UserInfoEvent, UserInfoState> {
  UserInfoBloc(
    this.userInfo, {
    // required this.userInfoRepo,
    this.conversationoId,
  }) : super(UserInfoState(userInfo)) {
    on<UserInfoEventAvatarChanged>(
      (event, emit) => emit(
        UserInfoState(state.userInfo..avatar = event.avatar),
      ),
    );

    on<UserInfoEventUserNameChanged>(
      (event, emit) => emit(
        UserInfoState(state.userInfo..name = event.name),
      ),
    );

    on<UserInfoEventUserStatusChanged>(
      (event, emit) =>
          emit(UserInfoState(state.userInfo..userStatus = event.userStatus)),
    );

    on<UserInfoEventStatusChanged>(
      (event, emit) => emit(
        UserInfoState(state.userInfo..status = event.status),
      ),
    );

    on<UserInfoEventActiveTimeChanged>((event, emit) {
      var lastActive;
      switch (event.status) {
        case AuthStatus.authenticated:
          lastActive = null;
          break;
        case AuthStatus.unauthenticated:
          lastActive = event.lastActive;
          break;
        default:
          lastActive = null;
      }
      emit(
        UserInfoStateActiveTimeChanged(
          lastActive,
          state.userInfo..lastActive = lastActive,
        ),
      );
    });

    _subscription = _userInfoRepo.stream.listen((event) {
      if (event.userId == userInfo.id) add(event);
      if (event is UserInfoEventNicknameChanged &&
          event.conversationId == this.conversationoId)
        add(
          UserInfoEventUserNameChanged(
            userId: userInfo.id,
            name: event.newNickname,
          ),
        );
    });

    _unAuthSubscription =
        navigatorKey.currentContext!.read<AuthBloc>().stream.listen((status) {
      if (status is UnAuthenticatedState) close();
    });

    // logger.log(
    //   '${this.hashCode}_${this.userInfo.id} created',
    //   name: 'UserInfoBloc_${hashCode} created',
    // );
  }

  factory UserInfoBloc.unknown(int userId) {
    var repo = userInfoRepo;
    var userInfoBloc = UserInfoBloc(
      UserInfo(
        id: userId,
        userName: 'Người dùng $userId',
        avatarUser: '',
        active: UserStatus.offline,
      ),
    );
    try {
      repo.getChatInfo(userId, false);
    } catch (e) {}
    return userInfoBloc;
  }

  factory UserInfoBloc.fromConversation(
    ConversationBasicInfo info, {
    String? status,
  }) =>
      UserInfoBloc(
        info..status = status,
        conversationoId: info.conversationId,
      );

  @HiveField(0)
  final IUserInfo userInfo;
  @HiveField(1)
  final int? conversationoId;
  final UserInfoRepo _userInfoRepo = userInfoRepo;
  late final StreamSubscription _subscription;
  late final StreamSubscription _unAuthSubscription;

  // @override
  // void onEvent(UserInfoEvent event) {
  //   super.onEvent(event);
  //   if (event.userId == userInfo.id)
  //     logger.log(event, name: 'UserInfoBloc_${this.hashCode}');
  // }

  @override
  Future<void> close() {
    _subscription.cancel();
    _unAuthSubscription.cancel();
    // logger.log(
    //   'UserInfoBloc_${hashCode}_${userInfo.id} closed',
    //   color: StrColor.magenta,
    // );
    return super.close();
  }

  // @override
  // int get hashCode => identityHashCode(userInfo.id);

  // @override
  // @override
  // bool operator ==(Object other) =>
  //     other is UserInfoBloc &&
  //     other.runtimeType == runtimeType &&
  //     other.userInfo.id == userInfo.id;
}
