import 'dart:convert';
import 'dart:ui';

import 'package:chat_365/core/constants/local_storage_key.dart';
import 'package:chat_365/core/interfaces/interface_user_info.dart';
import 'package:chat_365/data/services/generator_service.dart';
import 'package:chat_365/main.dart';
import 'package:chat_365/modules/auth/repo/auth_repo.dart';
import 'package:chat_365/modules/chat/blocs/chat_bloc/chat_bloc.dart';
import 'package:chat_365/modules/chat/model/api_message_model.dart';
import 'package:chat_365/modules/chat/repo/chat_repo.dart';
import 'package:chat_365/modules/chat_conversations/bloc/chat_conversation_bloc.dart';
import 'package:chat_365/modules/chat_conversations/models/conversation_basic_info.dart';
import 'package:chat_365/modules/chat_conversations/models/result_chat_conversation.dart';
import 'package:chat_365/router/app_route_observer.dart';
import 'package:chat_365/service/firebase_service.dart';
import 'package:chat_365/utils/data/enums/emoji.dart';
import 'package:chat_365/utils/data/enums/message_type.dart';
import 'package:chat_365/utils/helpers/logger.dart';
import 'package:chat_365/utils/helpers/system_utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:sp_util/sp_util.dart';

import 'app_service.dart';

class LocalMessageNotificationService {
  static LocalMessageNotificationService? _instance;

  static const PORT_SERVER_NAME = 'port_server_name';

  factory LocalMessageNotificationService() =>
      _instance ??= LocalMessageNotificationService._();
  static const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('ic_launcher');
  static const DarwinInitializationSettings initializationSettingsIOS =
      DarwinInitializationSettings();
  static final localNotification = FlutterLocalNotificationsPlugin();

  static const LIKE_MESSAGE_ACTION_ID = 'LikeMessageActionId';
  static const MARK_READ_MESSAGE_ACTION_ID = 'MarkReadMessageActionId';
  static const ANSWER_ACTION_ID = 'AnswerActionId';

  static AndroidNotificationChannel channel = const AndroidNotificationChannel(
    'Chat Messsage',
    'Conversation messsage notification',
    importance: Importance.high,
    playSound: true,
    groupId: 'Chat Messsage',
    enableVibration: true,
    showBadge: true,
    description: 'Thông báo tin nhắn cuộc trò chuyện',
  );
  // when click notification
  static onSelectNotification(Map payloadData) {
    try {
      var notificationPayloadData = payloadData;
      int conversationId =
          int.parse(notificationPayloadData['converstation_id'].toString());
      String? notType = notificationPayloadData["not_type"];
      if (notType == NOTIFICATION_TYPE.Chat.toShortString()) {
        String? fromSource = notificationPayloadData["from_source"];
        String? urlLauncher = notificationPayloadData["url_launcher"];
        if (fromSource == 'chat365') {
          if (SpUtil.getString(LocalStorageKey.token) != null) {
            var context = AppService().navigatorKey.currentContext!;
            logger.log(routeObserver.navigator?.widget, name: 'CheckWidget');
            ChatItemModel? chatItemModel;
            IUserInfo? chatInfo;
            try {
              var chatConversationBloc = context.read<ChatConversationBloc>();
              chatItemModel = chatConversationBloc.chatsMap[conversationId];
            } catch (e) {}
            if (chatItemModel == null &&
                notificationPayloadData["isGroup"] != null) {
              final bool isGroup =
                  notificationPayloadData["isGroup"] == 0 ? false : true;
              try {
                chatInfo = ConversationBasicInfo(
                  name: notificationPayloadData["sender_name"],
                  conversationId: conversationId,
                  isGroup: isGroup,
                  userId: notificationPayloadData["sender_id"],
                  avatar: notificationPayloadData["sender_avatar"],
                );
              } catch (e, s) {
                logger.logError(
                    e, s, 'CreateConversationBasicInfo From Noti Error');
              }
            }
            try {
              context.read<ChatBloc>().tryToChatScreen(
                    conversationId:
                        chatItemModel == null ? conversationId : null,
                    chatInfo: chatItemModel ?? chatInfo,
                    isNeedToFetchChatInfo: chatInfo != null ? false : true,
                  );
            } catch (e, s) {
              logger.logError(e, s, 'NotificationNavError');
            }
          }
        } else {}

        //
        bool isUnRead = SystemUtils.checkRoomIsUnReadByUser(
            notificationPayloadData["converstation_id"].toString());
        if (isUnRead) {
          SystemUtils.increaseListMessageUnreadWithBadge();
        }
      } else {}
    } catch (error, s) {
      print("Error opening Notification ==> $error");
      logger.logError(error, s, 'NotificationNavError');
    }
  }

  LocalMessageNotificationService._() {}

  Future initService() async {
    await localNotification.initialize(
      InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
      ),
      onDidReceiveNotificationResponse: _onResponseNoti,
      onDidReceiveBackgroundNotificationResponse: _onBackgroundResponseNoti,
    );
  }

  // chạy hàm khi click vào thông báo
  _onResponseNoti(NotificationResponse noti) async {
    if (noti.notificationResponseType ==
        NotificationResponseType.selectedNotification) {
      var payload = noti.payload;
      if (payload != null) {
        var decodedPayload = jsonDecode(payload);
        logger.log("selectNotification ==> $decodedPayload");
        onSelectNotification(decodedPayload);
        // _changePage(payload);
      }
    } else {
      try {
        var data = json.decode(noti.payload!);
        var senderId = navigatorKey.currentContext!.read<AuthRepo>().userId!;
        var convId = data['converstation_id'];
        var context = navigatorKey.currentContext!;
        if (noti.actionId == LIKE_MESSAGE_ACTION_ID) {
          context.read<ChatRepo>().changeReaction(
                ChatEventEmitChangeReationMessage(
                  senderId,
                  data['message_id'],
                  convId,
                  Emoji.like,
                  false,
                  MessageType.values[data['message_type']],
                  data['message'],
                  List<int>.from(data['member_ids']),
                  [],
                ),
              );
        } else if (noti.actionId == MARK_READ_MESSAGE_ACTION_ID)
          context.read<ChatRepo>().markReadAllMessage(
                senderId,
                convId,
              );
        else if (noti.actionId == ANSWER_ACTION_ID) {
          var context = navigatorKey.currentContext!;
          var text = noti.input!;
          var data = json.decode(noti.payload!);
          var senderId = context.read<AuthRepo>().userId!;
          var convId = data['converstation_id'];
          await context.read<ChatRepo>().sendMessage(
                ApiMessageModel(
                  messageId: GeneratorService.generateMessageId(senderId),
                  conversationId: convId,
                  senderId: senderId,
                  message: text,
                ),
                recieveIds: List<int>.from(data['member_ids']),
                // conversationId: convId,
              );
          mapConvIdAndListNotiId.remove(convId);
        }
      } catch (e, s) {
        logger.logError(e, s);
      }
    }
  }

  @pragma('vm:entry-points')
  static _onBackgroundResponseNoti(
    NotificationResponse noti,
  ) async {
    print(noti.notificationResponseType);
    if (noti.notificationResponseType ==
            NotificationResponseType.selectedNotificationAction &&
        noti.actionId == ANSWER_ACTION_ID) {
      var port = IsolateNameServer.lookupPortByName(PORT_SERVER_NAME);
      logger.log('${port.hashCode}', name: 'PORT LOG');
      port?.send(noti);
    }
  }

  static Map<int, List<ActiveNotification>> mapConvIdAndListNotiId = {};

  static void showNotification(
    String title,
    String body,
    String payload,
  ) async {
    var data = jsonDecode(payload);
    final int convId = int.parse(data['converstation_id'].toString());
    final String groupKeyId = convId.toString();
    List<ActiveNotification>? activeNotifications = await localNotification
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.getActiveNotifications();

    if (activeNotifications != null &&
        !activeNotifications.map((e) => e.id).contains(convId))
      mapConvIdAndListNotiId[convId]?.clear();

    // var iOSPlatformChannelSpecifics = DarwinNotificationDetails();

    var activeNotification = ActiveNotification(
      id: convId,
      channelId: channel.id,
      title: title,
      body: body,
      payload: payload,
    );

    // if (mapConvIdAndListNotiId[convId].isBlank) {
    //   localNotification.show(
    //     convId,
    //     title,
    //     body,
    //     NotificationDetails(
    //       android: AndroidNotificationDetails(
    //         channel.id,
    //         channel.name,
    //         styleInformation: BigTextStyleInformation(body),
    //       ),
    //     ),
    //     payload: payload,
    //   );
    //   mapConvIdAndListNotiId.update(
    //     convId,
    //     (current) {
    //       return current..add(activeNotification);
    //     },
    //     ifAbsent: () => [activeNotification],
    //   );
    //   return;
    // }

    mapConvIdAndListNotiId.update(
      convId,
      (current) => current..add(activeNotification),
      ifAbsent: () => [activeNotification],
    );

    // var list = mapConvIdAndListNotiId[convId]!.map((e) => e.body!).toList();

    // localNotification.show(
    //   convId,
    //   title,
    //   body,
    //   NotificationDetails(
    //     android: AndroidNotificationDetails(
    //       channel.id,
    //       channel.name,
    //       groupKey: groupKeyId,
    //       setAsGroupSummary: true,
    //       styleInformation: InboxStyleInformation(
    //         list,
    //         summaryText: '${list.length} messages',
    //       ),
    //     ),
    //   ),
    //   payload: payload,
    // );

    // int notiId = 0;
    var activeNotiIds;
    if (activeNotifications != null)
      activeNotiIds = activeNotifications.map((e) => e.id);

    if (activeNotiIds != null)
      mapConvIdAndListNotiId.removeWhere(
        (key, value) =>
            value.length > 1 &&
            ([...value]..removeWhere(
                    (e) => !activeNotiIds.contains(e.id),
                  ))
                .isEmpty,
      );

    for (var noti in mapConvIdAndListNotiId.values) {
      await localNotification.show(
        convId,
        '<b>$title</b>',
        body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            fullScreenIntent: true,
            styleInformation: InboxStyleInformation(
              noti.map((e) => e.body ?? '').toList(),
              summaryText:
                  noti.isNotEmpty ? '<b>${noti.length} messages</b>' : '',
              htmlFormatSummaryText: true,
              htmlFormatLines: true,
              htmlFormatContent: true,
              htmlFormatContentTitle: true,
              htmlFormatTitle: true,
            ),
            // styleInformation: BigTextStyleInformation(
            //   body,
            //   htmlFormatBigText: true,
            //   htmlFormatContent: true,
            //   htmlFormatContentTitle: true,
            //   htmlFormatTitle: true,
            //   htmlFormatSummaryText: true,
            // ),
            groupKey: channel.groupId,
            actions: [
              AndroidNotificationAction(
                LIKE_MESSAGE_ACTION_ID,
                'Thích',
                showsUserInterface: true,
              ),
              AndroidNotificationAction(
                MARK_READ_MESSAGE_ACTION_ID,
                'Đánh dấu đã đọc',
                showsUserInterface: true,
              ),
              AndroidNotificationAction(
                ANSWER_ACTION_ID,
                'Trả lời',
                allowGeneratedReplies: false,
                inputs: [
                  AndroidNotificationActionInput(
                    label: 'Gửi',
                  ),
                ],
              ),
            ],
          ),
        ),
        payload: payload,
      );
    }

    // mapConvIdAndListNotiId.removeWhere((key, value) => value.length - 1 <= 0);

    // if (mapConvIdAndListNotiId.isNotEmpty)
    // localNotification.show(
    //   999,
    //   '',
    //   body,
    //   NotificationDetails(
    //     android: AndroidNotificationDetails(
    //       channel.id,
    //       channel.name,
    //       styleInformation: InboxStyleInformation(
    //         mapConvIdAndListNotiId.entries.map((entry) {
    //           return '${entry.value.last.body} (+${entry.value.length - 1})';
    //         }).toList(),
    //         summaryText: '${mapConvIdAndListNotiId.length} conversations',
    //         htmlFormatLines: true,
    //         htmlFormatContent: true,
    //         htmlFormatContentTitle: true,
    //         htmlFormatSummaryText: true,
    //         htmlFormatTitle: true,
    //       ),
    //       groupKey: channel.groupId,
    //       setAsGroupSummary: true,
    //     ),
    //   ),
    //   payload: payload,
    // );

    // await localNotification.show(
    //   mapConvIdAndNotiId.putIfAbsent(convId, () => notiId),
    //   title,
    //   body,
    //   NotificationDetails(
    //     android: AndroidNotificationDetails(
    //       channel.id,
    //       channel.name,
    //       styleInformation: BigTextStyleInformation(
    //         body,
    //       ),
    //     ),
    //   ),
    //   payload: payload,
    // );

    // var groupedPlatformChannelSpecifics = NotificationDetails(
    //   android: groupedAndroidPlatformChannelSpecifics,
    //   iOS: iOSPlatformChannelSpecifics,
    // );
    // await localNotification.show(
    //   0,
    //   title,
    //   body,
    //   groupedPlatformChannelSpecifics,
    // );
    // if (activeNotifications != null) {
    //   List<ActiveNotification> groupedList =
    //       _groupActiveNotification(activeNotifications);
    //   for (int i = 0; i < groupedList.length; i++) {
    //     var noti = groupedList[i];
    //     await localNotification.show(
    //       i + 1,
    //       noti.title,
    //       noti.body,
    //       NotificationDetails(
    //         android: AndroidNotificationDetails(
    //           channel.id,
    //           channel.name,
    //           channelDescription: channel.description,
    //           groupKey: groupKeyId,
    //           icon: 'ic_launcher',
    //           styleInformation: BigTextStyleInformation(noti.body!),
    //           playSound: true,
    //           setAsGroupSummary: false,
    //         ),
    //         iOS: iOSPlatformChannelSpecifics,
    //       ),
    //     );
    //   }
    // }
  }

  // static List<ActiveNotification> _groupActiveNotification(
  //   List<ActiveNotification> activeNotifications,
  // ) {
  //   Map<String, String> res = {};
  //   for (var entry in activeNotifications) {
  //     var body = entry.body!;
  //     res.update(
  //       entry.title!,
  //       (current) => '$current\n$body',
  //       ifAbsent: () => body,
  //     );
  //   }
  //   return res.entries
  //       .map((e) => ActiveNotification(
  //             0,
  //             channel.id,
  //             e.key,
  //             e.value,
  //           ))
  //       .toList();
  // }
}
