import 'dart:async';
import 'dart:convert';

import 'package:chat_365/common/blocs/chat_library_cubit/repo/chat_library_repo.dart';
import 'package:chat_365/common/blocs/network_cubit/network_cubit.dart';
import 'package:chat_365/core/error_handling/exceptions.dart';
import 'package:chat_365/main.dart';
import 'package:chat_365/modules/chat/blocs/chat_detail_bloc/chat_detail_bloc.dart';
import 'package:chat_365/modules/chat/model/result_socket_chat.dart';
import 'package:chat_365/modules/chat/repo/chat_detail_repo.dart';
import 'package:chat_365/modules/chat_conversations/models/result_chat_conversation.dart';
import 'package:chat_365/utils/data/enums/message_type.dart';
import 'package:chat_365/utils/data/extensions/context_extension.dart';
import 'package:chat_365/utils/data/models/exception_error.dart';
import 'package:chat_365/utils/helpers/logger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'chat_library_state.dart';

class ChatLibraryCubit extends Cubit<ChatLibraryState> {
  ChatLibraryCubit(
    this.conversationId, {
    ChatDetailBloc? chatDetailBloc,
  })  : libraryRepo = ChatLibraryRepo(conversationId),
        super(ChatLibraryStateLoadSuccess()) {
    loadedMessages = 0;
    if (chatDetailBloc != null) {
      conversationDetail = chatDetailBloc.detail!;
      totalMessages = chatDetailBloc.detail!.totalNumberOfMessages;
      // loadedMessages = chatDetailBloc.loadedMessages;
      // for (var msg in chatDetailBloc.msgs) {
      //   if (msg.type?.isImage == true ||
      //       msg.type?.isFile == true ||
      //       msg.type?.isLink == true) files[msg.type]!.add(msg);
      // }
      // if (files.isEmpty) {
      loadLibrary(null);
      // }
    } else {
      _init();
    }

    _networkSubscription = navigatorKey.currentContext!
        .read<NetworkCubit>()
        .stream
        .listen(_listener);
  }

  _listener(NetworkState networkState) {
    if (state is ChatLibraryLoadConversationDetailError &&
        networkState.hasInternet) {
      _init();
    } else if (state is ChatLibraryStateError &&
        (state as ChatLibraryStateError).error.isNetworkException) {
      loadLibrary(null);
    }
  }

  _init() async {
    try {
      var res = await chatDetailRepo.loadConversationDetail(conversationId);
      conversationDetail = await res
          .onCallBack((_) => ChatItemModel.fromConversationInfoJsonOfUser(
                chatDetailRepo.userId,
                conversationInfoJson: json.decode(res.data)["data"]
                    ["conversation_info"],
              ));
      totalMessages = conversationDetail.totalNumberOfMessages;
      loadLibrary(null);
    } on CustomException catch (e) {
      emit(ChatLibraryLoadConversationDetailError(e.error));
    }
  }

  loadLibrary(MessageType? messageType) async {
    try {
      var res = await libraryRepo.getLibrary(
        listMess: loadedMessages,
        countMessage: totalMessages,
        messageDisplay: conversationDetail.messageDisplay,
      );

      await res.onCallBack((_) {
        var listMessages = List<SocketSentMessageModel>.from(
            (json.decode(res.data)['data']['listMessages'] as List).map(
          (e) => SocketSentMessageModel.fromMap(e),
        )).reversed;

        for (var mess in listMessages) {
          if (mess.type?.isImage == true || mess.type?.isFile == true) {
            files[mess.type]!.addAll(
              mess.files!.map((e) {
                var newMess = mess.copyWith(files: [e]);
                if (first4Files.length < 4) first4Files.add(newMess);
                return newMess;
              }),
            );
          } else {
            files[mess.type]!.add(mess);
            if (first4Files.length < 4) first4Files.add(mess);
          }
        }
      });

      emit(ChatLibraryStateLoadSuccess());
    } on CustomException catch (e, s) {
      logger.logError(e, s);
      if (e.error.error == 'Cuộc trò chuyện không có ảnh, file, link nào')
        return emit(ChatLibraryStateLoadSuccess());
      emit(ChatLibraryStateError(e.error));
    }
  }

  final int conversationId;
  late ChatItemModel conversationDetail;
  late final StreamSubscription<NetworkState> _networkSubscription;
  late final ChatLibraryRepo libraryRepo;
  final ChatDetailRepo chatDetailRepo = ChatDetailRepo(
    navigatorKey.currentContext!.userInfo().id,
  );
  late int totalMessages;
  late int loadedMessages;

  Map<MessageType, List<SocketSentMessageModel>> files = {
    MessageType.image: [],
    MessageType.file: [],
    MessageType.link: [],
  };

  List<SocketSentMessageModel> first4Files = [];

  @override
  Future<void> close() {
    _networkSubscription.cancel();
    return super.close();
  }
}
