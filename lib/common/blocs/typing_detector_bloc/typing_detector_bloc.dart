import 'dart:async';

import 'package:chat_365/common/blocs/user_info_bloc/bloc/user_info_event.dart';
import 'package:chat_365/common/blocs/user_info_bloc/repo/user_info_repo.dart';
import 'package:chat_365/main.dart';
import 'package:chat_365/modules/chat/blocs/chat_bloc/chat_bloc.dart';
import 'package:chat_365/modules/chat/repo/chat_repo.dart';
import 'package:chat_365/utils/data/enums/auth_status.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'typing_detector_event.dart';
part 'typing_detector_state.dart';

class TypingDetectorBloc
    extends Bloc<TypingDetectorEvent, TypingDetectorState> {
  TypingDetectorBloc(this.conversationId) : super(TypingDetectorState({})) {
    on<TypingDectorEventAddUser>((event, emit) {
      return emit(state.add(event.userId));
    });

    on<TypingDetectorEventRemoveUser>((event, emit) {
      return emit(state.remove(event.userId));
    });

    on<TypingDetectorEventRemoveAllUser>((event, emit) {
      return emit(TypingDetectorState({}));
    });

    _subscription = _chatRepo.stream.listen((event) {
      if (event is ChatEventOnTyping && event.conversationId == conversationId)
        add(TypingDectorEventAddUser(event.senderId));
      else if (event is ChatEventOnStopTyping &&
          event.conversationId == conversationId)
        add(TypingDetectorEventRemoveUser(event.senderId));
      else if (event is ChatEventOnOutGroup &&
          event.conversationId == conversationId &&
          state.typingUserIds.contains(event.deletedMemberId)) {
        add(TypingDetectorEventRemoveUser(event.deletedMemberId));
      }
    });

    _networkSubscription = networkCubit.networkStream.listen((state) {
      if (!state.hasInternet) add(TypingDetectorEventRemoveAllUser());
    });

    _offlineSubscription = userInfoRepo.stream.listen((event) {
      if (event is UserInfoEventActiveTimeChanged &&
          event.status != AuthStatus.authenticated &&
          state.typingUserIds.contains(event.userId))
        add(TypingDetectorEventRemoveUser(event.userId));
    });
  }

  final ChatRepo _chatRepo = chatRepo;
  final int conversationId;
  late final StreamSubscription _subscription;
  late final StreamSubscription _networkSubscription;
  late final StreamSubscription _offlineSubscription;

  @override
  Future<void> close() {
    _subscription.cancel();
    _networkSubscription.cancel();
    _offlineSubscription.cancel();
    return super.close();
  }
}
