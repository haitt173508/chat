import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:chat_365/core/constants/local_storage_key.dart';
import 'package:chat_365/modules/auth/repo/auth_repo.dart';
import 'package:chat_365/service/local_message_notification_service.dart';
import 'package:chat_365/utils/data/enums/user_type.dart';
import 'package:chat_365/utils/helpers/system_utils.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:sp_util/sp_util.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  try {
    await Firebase.initializeApp();
    var notificationPayloadData = message.data;
    String notType = notificationPayloadData["not_type"];
    if (notType == NOTIFICATION_TYPE.Chat.toShortString()) {
      // check with count message unread, update count notification in icon app
      bool isUnRead = SystemUtils.checkRoomIsUnReadByUser(
          notificationPayloadData["converstation_id"]);
      if (!isUnRead) {
        SystemUtils.increaseListMessageUnreadWithBadge();
      }
    }
  } catch (e) {
    print(
        'Exception - firebase_ios.dart - _firebaseMessagingBackgroundHandler(): ' +
            e.toString());
  }
}

class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();

  factory FirebaseService() => _instance;

  FirebaseService._internal() {
    initNotification();
    _repository = new AuthRepo();
  }

  late AuthRepo _repository;

  static final FirebaseMessaging messaging = FirebaseMessaging.instance;

  static final StreamController<bool> _notiPermissionStream =
      StreamController.broadcast();
  Stream<bool> get notiPermissionStream => _notiPermissionStream.stream;
  static Future<NotificationSettings> requestNotiPermisson() async {
    var response = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    if (response.authorizationStatus == AuthorizationStatus.authorized) {
      _notiPermissionStream.sink.add(true);
      print('Người dùng đã cấp quyền');
    } else if (response.authorizationStatus ==
        AuthorizationStatus.provisional) {
      _notiPermissionStream.sink.add(true);
      print('Người dùng đã cấp quyền tạm thời');
    } else {
      _notiPermissionStream.sink.add(false);
      print('Người dùng đã từ chối');
    }
    return response;
  }

  // config, get token, send token to sever
  static Future<void> initNotification() async {
    var response = await requestNotiPermisson();
    messaging.setAutoInitEnabled(true);
    messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    if (response.authorizationStatus == AuthorizationStatus.authorized) {
      print('Authenticate');
    } else if (response.authorizationStatus == AuthorizationStatus.denied) {
      print('Notification has denied');
    }

    // LocalNotificationService.showMessageNotification();

    if (!Platform.isIOS)
      FirebaseMessaging.onMessage.listen((event) {
        // if (event.notification != null) {
        //   showNotification(event.notification!.title!,
        //       event.notification!.body!, jsonEncode(event.data));
        // }
      });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // FirebaseMessaging.onMessageOpenedApp.listen((event) {
    //   print("onMessageOpenedApp: " + event.toString());
    //   if (event.notification != null) {
    //     log("selectNotification ==> ${event.data}");
    //     LocalMessageNotificationService.onSelectNotification(event.data);
    //     print('show thông báo onMessageOpenedApp');
    //   } else {
    //     print('Lỗi');
    //   }
    // });
  }

  void initMessage() {
    FirebaseMessaging.instance.getInitialMessage().then((event) {
      if (event != null) {
        log("selectNotification ==> ${event.data}");
        LocalMessageNotificationService.onSelectNotification(event.data);
      }
    });
  }

  void fcmUnSubscribe() {
    messaging.unsubscribeFromTopic('all');
  }

  setUpFirebaseToken(int id, UserType userType) {
    String? accessToken = SpUtil.getString(LocalStorageKey.token);
    String? firebaseToken = SpUtil.getString(LocalStorageKey.firebase_token);
    if (accessToken != null) {
      if (firebaseToken == null) {
        addFCMTokenForUser(id, userType);
      } else {
        updateFCMTokenForUser(id, userType);
      }
    } else {
      print("setUpFirebaseToken : Not login");
    }
  }

  void addFCMTokenForUser(int id, UserType userType) {
    FirebaseMessaging.instance.getToken().then((firebaseToken) {
      if (firebaseToken != "" && firebaseToken != null) {
        _repository
            .updateFirebaseToken(id.toString(), firebaseToken, userType)
            .then((value) {
          if (value) {
            SpUtil.putString(LocalStorageKey.firebase_token, firebaseToken);
          }
        });
      }
    });
  }

  void updateFCMTokenForUser(int id, UserType userType) async {
    FirebaseMessaging.instance.getToken().then((firebaseToken) {
      if (firebaseToken != "" && firebaseToken != null) {
        String? storeFirebaseToken =
            SpUtil.getString(LocalStorageKey.firebase_token);
        if (storeFirebaseToken != null) {
          _repository
              .updateFirebaseToken(id.toString(), firebaseToken, userType)
              .then((value) {
            if (value) {
              SpUtil.putString(LocalStorageKey.firebase_token, firebaseToken);
            }
          });
        }
      }
    });
  }

  logoutFirebase() {
    // messaging.unsubscribeFromTopic("all");
    FirebaseMessaging.instance.deleteToken();
    LocalMessageNotificationService.localNotification.cancelAll();
    //call to API delete columns ft_token with id and device if need
  }

  // show notification
  static void showNotification(
      String title, String body, String payload) async {
    LocalMessageNotificationService.showNotification(title, body, payload);
  }

  static void _changePage(String payload) {
    if (payload.isNotEmpty) {
      // TODO: change to detail page here
    }
  }
}

enum NOTIFICATION_TYPE { Chat, Job }

extension ParseToString on NOTIFICATION_TYPE {
  String toShortString() {
    return this.toString().split('.').last;
  }
}
