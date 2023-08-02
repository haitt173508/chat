import 'dart:async';
import 'dart:convert';

import 'package:chat_365/common/blocs/downloader/model/downloader_model.dart';
import 'package:chat_365/common/blocs/settings_cubit/cubit/settings_state.dart';
import 'package:chat_365/common/blocs/user_info_bloc/bloc/user_info_bloc.dart';
import 'package:chat_365/common/models/auto_delete_message_time_model.dart';
import 'package:chat_365/common/models/message_setting_model.dart';
import 'package:chat_365/common/models/message_setting_model_item.dart';
import 'package:chat_365/data/services/hive_service/hive_box_names.dart';
import 'package:chat_365/data/services/hive_service/hive_type_id.dart';
import 'package:chat_365/modules/chat/model/chat_member_model.dart';
import 'package:chat_365/modules/chat/model/result_socket_chat.dart';
import 'package:chat_365/modules/chat_conversations/models/conversation_basic_info.dart';
import 'package:chat_365/modules/chat_conversations/models/result_chat_conversation.dart';
import 'package:chat_365/utils/data/enums/download_status.dart';
import 'package:chat_365/utils/data/enums/friend_status.dart';
import 'package:chat_365/utils/data/enums/message_setting_type.dart';
import 'package:chat_365/utils/data/enums/message_status.dart';
import 'package:chat_365/utils/data/enums/message_text_size.dart';
import 'package:chat_365/utils/data/enums/message_type.dart';
import 'package:chat_365/utils/data/enums/themes.dart';
import 'package:chat_365/utils/data/enums/user_status.dart';
import 'package:chat_365/utils/helpers/logger.dart';
import 'package:chat_365/utils/helpers/system_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/adapters.dart';

class HiveService {
  static HiveService? _instance;

  factory HiveService() => _instance ??= HiveService._();

  HiveService._() {}

  init() async {
    // throw Exception('Message Error');
    await Hive.initFlutter();
    try {
      registerAdapter();
      await _openBoxes();
    } catch (e, s) {
      logger.logError(e, s, 'RegisterAdapterError');
      // Hive.deleteFromDisk();
    }
  }

  Future<bool> initWithContext() async {
    if (!Hive.isAdapterRegistered(HiveTypeId.myThemeHiveTypeId)) {
      Hive.registerAdapter(MyThemeAdapter());
      themeBox = await openBox(HiveBoxNames.themeBox);
      return false;
    }
    return true;
  }

  Future<void> _openBoxes() async {
    try {
      await Future.wait([
        _opendownloaderBoxBox(),
        _openchatItemModelBoxBox(),
        _openchatConversationDetailBoxBox(),
        _opensettingsStateBoxBox(),
      ]);
      logger.log('Open boxes success');
    } catch (e, s) {
      logger.logError(e, s, 'OpenAndSettingBoxError');
    }
    // messageSettingModelBox = await openBox(HiveBoxNames.messageSettingModelBox);
    // messageSettingModelItemBox =
    //     await openBox(HiveBoxNames.messageSettingModelItemBox);
  }

  Future _opendownloaderBoxBox() async =>
      downloadBox ??= await openBox(HiveBoxNames.downloaderBox);
  Future _openchatItemModelBoxBox() async =>
      chatItemModelBox ??= await openBox(HiveBoxNames.chatItemModelBox);
  Future _openchatConversationDetailBoxBox() async =>
      listMessagesBox ??= await openBox(HiveBoxNames.listMessagesBox);
  Future _opensettingsStateBoxBox() async =>
      settingStateBox ??= await openBox(HiveBoxNames.settingsStateBox);

  saveListMessageToChatConversationBox(
    int conversationId,
    List<SocketSentMessageModel> msgs,
  ) async =>
      listMessagesBox?.put(
        conversationId,
        await compute(_encodeListMessages, msgs),
      );

  static String _encodeListMessages(List<SocketSentMessageModel> msgs) =>
      json.encode(
        msgs.map((e) => sockeSentMessageModelToHiveObjectJson(e)).toList(),
      );

  saveEncodedListMessageToChatConversationBox(
    int conversationId,
    String encodedMsgs,
  ) =>
      listMessagesBox?.put(
        conversationId,
        encodedMsgs,
      );

  saveMapConversationIdAndEncodedMessage(Map<int, String> map) =>
      listMessagesBox?.putAll(map);

  Future<Box<T>> openBox<T>(String name) {
    try {
      return _openBox(name);
    } catch (e) {
      Hive.deleteBoxFromDisk(name);
      return _openBox(name);
    }
  }

  Future<Box<T>> _openBox<T>(String name) => Hive.openBox<T>(name);

  Box<DownloaderModel>? downloadBox;
  Box<ChatItemModel>? chatItemModelBox;
  Box<String>? listMessagesBox;
  Box<MyTheme>? themeBox;
  Box<SettingState>? settingStateBox;
  // late final Box<MessageSettingModel> messageSettingModelBox;
  // late final Box<MessageSettingModelItem> messageSettingModelItemBox;

  clearBoxToLogout() async {
    try {
      Future.wait([
        if (chatItemModelBox != null) chatItemModelBox!.clear(),
        if (listMessagesBox != null) listMessagesBox!.clear(),
        if (themeBox != null) themeBox!.clear(),
        if (settingStateBox != null) settingStateBox!.clear(),
      ]);
      // await messageSettingModelBox.clear();
      // await messageSettingModelItemBox.clear();
    } catch (e) {}
  }

  registerAdapter() {
    Hive
      ..registerAdapter(DownloaderModelAdapter())
      ..registerAdapter(DownloadStatusAdapter())
      ..registerAdapter(MessageTypeAdapter())
      ..registerAdapter(UserStatusAdapter())
      // ..registerAdapter(UnreadMessageCounterCubitAdapter())
      ..registerAdapter(ChatMemberModelAdapter())
      ..registerAdapter(ConversationBasicInfoAdapter())
      ..registerAdapter(ChatItemModelAdapter())
      ..registerAdapter(UserInfoBlocAdapter())
      ..registerAdapter(FriendStatusAdapter())
      ..registerAdapter(MessageStatusAdapter())
      ..registerAdapter(AppThemeColorAdapter())
      ..registerAdapter(SettingStateAdapter())
      ..registerAdapter(MessageSettingModelAdapter())
      ..registerAdapter(MessageSettingModelItemAdapter())
      ..registerAdapter(MessageSettingTypeAdapter())
      ..registerAdapter(MessageTextSizeAdapter())
      ..registerAdapter(AutoDeleteMessageTimeModelAdapter());
    // ..registerAdapter(SocketSentMessageModelAdapter())
    // ..registerAdapter(EmojiAdapter())
    // ..registerAdapter(EmotionAdapter())
    // ..registerAdapter(ApiRelyMessageModelAdapter())
    // ..registerAdapter(ApiFileModelAdapter())
    // ..registerAdapter(InfoLinkAdapter())
    // ..registerAdapter(ContactAdapter());
  }

  FutureOr<Map<int, List<SocketSentMessageModel>>?> get messages async {
    if (listMessagesBox == null) return null;
    final currentInfo = SystemUtils.getCurrrentUserInfoAndUserType();
    return await compute(
      _decodeLocalMessage,
      [
        Map<int, String>.from(listMessagesBox!.toMap()),
        currentInfo,
      ],
    );
  }

  FutureOr<List<SocketSentMessageModel>?> getConversationOfflineMessages(
    int conversationId,
  ) async {
    if (listMessagesBox?.get(conversationId) == null) return null;
    final String encodedMsgs = listMessagesBox!.get(conversationId)!;
    final currentInfo = SystemUtils.getCurrrentUserInfoAndUserType();
    return (await compute(
      _decodeLocalMessage,
      [
        {conversationId: encodedMsgs},
        currentInfo,
      ],
    ))[conversationId];
  }

  static Map<int, List<SocketSentMessageModel>> _decodeLocalMessage(
    List params,
  ) =>
      Map<int, List<SocketSentMessageModel>>.from(
        params[0].map(
          (e, v) => MapEntry(
            e,
            (json.decode(v) as List)
                .map(
                  (e) => sockeSentMessageModelFromHiveObjectJson(
                    e,
                    currentInfo: params[1],
                  ),
                )
                .toList(),
          ),
        ),
      );

  clearBox(String box) => Hive.deleteBoxFromDisk(box);
}
