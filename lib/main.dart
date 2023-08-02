import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:math';
import 'dart:ui';

import 'package:chat_365/common/blocs/downloader/cubit/downloader_cubit.dart';
import 'package:chat_365/common/blocs/friend_cubit/cubit/friend_cubit.dart';
import 'package:chat_365/common/blocs/network_cubit/network_cubit.dart';
import 'package:chat_365/common/blocs/settings_cubit/cubit/settings_cubit.dart';
import 'package:chat_365/common/blocs/theme_cubit/theme_cubit.dart';
import 'package:chat_365/common/blocs/user_info_bloc/bloc/user_info_bloc.dart';
import 'package:chat_365/common/blocs/user_info_bloc/repo/user_info_repo.dart';
import 'package:chat_365/core/constants/chat_socket_event.dart';
import 'package:chat_365/core/constants/local_storage_key.dart';
import 'package:chat_365/core/constants/string_constants.dart';
import 'package:chat_365/core/interfaces/interface_user_info.dart';
import 'package:chat_365/data/services/device_info_service/device_info_services.dart';
import 'package:chat_365/data/services/generator_service.dart';
import 'package:chat_365/data/services/hive_service/hive_service.dart';
import 'package:chat_365/data/services/map_service/map_service.dart';
import 'package:chat_365/data/services/network_service/network_service.dart';
import 'package:chat_365/data/services/signaling_service/signaling_service.dart';
import 'package:chat_365/data/services/sp_utils_service/sp_utils_services.dart';
import 'package:chat_365/modules/auth/bloc/auth_bloc.dart';
import 'package:chat_365/modules/auth/modules/login/cubit/login_cubit.dart';
import 'package:chat_365/modules/auth/modules/login/models/result_login.dart';
import 'package:chat_365/modules/auth/repo/auth_repo.dart';
import 'package:chat_365/modules/chat/blocs/chat_bloc/chat_bloc.dart';
import 'package:chat_365/modules/chat/model/api_message_model.dart';
import 'package:chat_365/modules/chat/repo/chat_repo.dart';
import 'package:chat_365/modules/chat_conversations/bloc/chat_conversation_bloc.dart';
import 'package:chat_365/modules/chat_conversations/models/conversation_basic_info.dart';
import 'package:chat_365/modules/chat_conversations/repo/chat_conversations_repo.dart';
import 'package:chat_365/modules/contact/cubits/contact_list_cubit/contact_list_cubit.dart';
import 'package:chat_365/modules/contact/model/filter_contacts_by.dart';
import 'package:chat_365/modules/contact/repos/contact_list_repo.dart';
import 'package:chat_365/modules/get_token/repos/get_token_repo.dart';
import 'package:chat_365/router/app_pages.dart';
import 'package:chat_365/router/app_route_observer.dart';
import 'package:chat_365/router/app_router.dart';
import 'package:chat_365/router/app_router_helper.dart';
import 'package:chat_365/service/app_service.dart';
import 'package:chat_365/service/injection.dart';
import 'package:chat_365/service/local_message_notification_service.dart';
import 'package:chat_365/utils/data/clients/chat_client.dart';
import 'package:chat_365/utils/data/clients/interceptors/call_client.dart';
import 'package:chat_365/utils/data/enums/auth_status.dart';
import 'package:chat_365/utils/data/enums/download_status.dart';
import 'package:chat_365/utils/data/enums/themes.dart';
import 'package:chat_365/utils/data/enums/user_type.dart';
import 'package:chat_365/utils/data/extensions/context_extension.dart';
import 'package:chat_365/utils/data/extensions/string_extension.dart';
import 'package:chat_365/utils/helpers/logger.dart';
import 'package:chat_365/utils/helpers/system_utils.dart';
import 'package:chat_365/utils/ui/app_dialogs.dart';
import 'package:event_bus/event_bus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:sp_util/sp_util.dart';

// import 'package:';

import 'common/models/recvice_list_member_call_group_ps_data_model.dart';
import 'core/constants/app_constants.dart';
import 'modules/splash_screen.dart';

// late final Timer timer;

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)..badCertificateCallback = _cert;
  }

  bool _cert(X509Certificate cert, String host, int port) => true;
}

late final ChatConversationsRepo chatConversationsRepo;
late final ChatConversationBloc chatConversationBloc;
late ContactListCubit searchContactCubits;

List<ConversationBasicInfo>? conversations;
IUserInfo? userInfo;
UserType? userType;

/// Dữ liệu sẵn có trong màn tìm kiếm
Map<FilterContactsBy, List<ConversationBasicInfo>>? searchAllPreSearchData;

/// Dữ liệu sẵn có trong màn gửi [Contact]
///
/// Hiện tại: ds người trong Công ty
List<ConversationBasicInfo> sendMessagePreSearchData = [];

void main() async {
  HttpOverrides.global = MyHttpOverrides();

  // ErrorWidget.builder = (FlutterErrorDetails details) {
  //   var e = details.exception.toString();
  //   var s = details.stack.toString();
  //   logger.logError(e, s, 'RedErrorScreen');
  //   // if (kDebugMode) {
  //   //   return ErrorWidget(details);
  //   // }

  //   return Material(
  //     color: AppColors.primary,
  //     child: DefaultTextStyle(
  //       style: TextStyle(
  //         color: AppColors.white,
  //         fontSize: 16,
  //         height: 18 / 16,
  //       ),
  //       child: Center(
  //         child: InkWell(
  //           onTap: () {
  //             Clipboard.setData(
  //               ClipboardData(
  //                 text: 'Error:\s$e\nStackTrace:\s$s',
  //               ),
  //             );
  //           },
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               Image.asset(
  //                 Images.img_thinkingFace,
  //               ),
  //               Text('Đã có lỗi xảy ra'),
  //               BackButton(
  //                 color: AppColors.white,
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // };

  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  try {
    await SPService().getInstance();
  } catch (e) {
    print(e);
  }

  await Firebase.initializeApp();
  await configureDependencies();

  try {
    //
    await HiveService().init();
  } catch (e, s) {
    logger.logError(e, s, 'HiveServiceInitError');
  }
  // await ContactService().init();

  try {
    MapService().init();
    DeviceInfoService().init();
  } catch (e) {}

  // timer = Timer.periodic(const Duration(milliseconds: 180), (_) {
  //   if (timer.isActive) {
  //     FlutterNativeSplash.remove();
  //     timer.cancel();
  //   }
  // });

  var check = AuthRepo.checkInfoInLocalStorage();

  if (check) {
    try {
      userType = UserType.fromJson(json.decode(spService.userType!));
      userInfo = IUserInfo.fromLocalStorageJson(
        json.decode(spService.userInfo!),
        userType: userType!,
      );
      getIt.get<AppService>().setupUnreadConversationId();
    } catch (e, s) {
      logger.logError(e, s);
    }
  }

  chatConversationsRepo = ChatConversationsRepo(
    userInfo != null ? userInfo!.id : 0,
    total: spService.totalConversation ?? 0,
  );

  chatConversationBloc = ChatConversationBloc(chatConversationsRepo);

  if (userInfo != null)
    chatConversationBloc
      ..loadData(countLoaded: 0)
      ..localMessages;

  await FlutterDownloader.initialize(
      debug: true,
      // optional: set to false to disable printing logs to console (default: true)
      ignoreSsl:
          true // option: set to false to disable working with http links (default: false)
      );

  FlutterDownloader.registerCallback(SystemUtils.downloadCallback);

  var windowWidth =
      MediaQueryData.fromWindow(WidgetsBinding.instance!.window).size.width;
  var maxMessageBoxWidthByScrSize = windowWidth -
      30 // - 30: = 15 * 2: padding 2 bên
      -
      40 // - 44 = 36(avatar size) + 4(padding giữa avatar và tin nhắn)
      -
      30;

  AppConst.maxMessageBoxWidth =
      max(maxMessageBoxWidthByScrSize, windowWidth / 1.5);

  await LocalMessageNotificationService().initService();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

final navigatorKey = getIt.get<AppService>().navigatorKey;
final scaffoldKey = getIt.get<AppService>().scaffoldKey;
final NetworkCubit networkCubit = NetworkCubit();

class _MyAppState extends State<MyApp> {
  NavigatorState get navigator => navigatorKey.currentState!;

  BuildContext get navigatorContext => navigator.context;
  final ReceivePort _port = ReceivePort();
  final ReceivePort _notiActionPort = ReceivePort();
  late final DownloaderCubit _downloaderCubit;

  final AuthRepo authRepo = AuthRepo();

  late EventBus eventBus;

  static Signaling signaling = new Signaling();
  MyTheme? _initTheme;

  late final AppService _appService;

  @override
  void initState() {
    super.initState();
    _downloaderCubit = DownloaderCubit();
    _appService = getIt.get<AppService>();
    chatClient.socket.onDisconnect((value) => _onSocketDisconnected());
    callClient.socket.onDisconnect((value) => _onCallSocketDisconnected());

    logger.log(_notiActionPort.sendPort.hashCode, name: 'PORT LOG');

    _bindBackgroundIsolate();
    _bindingNotiBackgroundActionResponse();
  }

  void _bindingNotiBackgroundActionResponse() {
    IsolateNameServer.removePortNameMapping(
      LocalMessageNotificationService.PORT_SERVER_NAME,
    );
    final isSuccess = IsolateNameServer.registerPortWithName(
      _notiActionPort.sendPort,
      LocalMessageNotificationService.PORT_SERVER_NAME,
    );

    if (isSuccess) {
      logger.log('PORT_SERVER_NAME sucess');
      _notiActionPort.listen(
        (data) {
          logger.log(data);
          replyMessage(data);
        },
        onError: (e, s) {
          logger.log('Error', name: 'PORT LOG');
        },
      );
    }
  }

  replyMessage(NotificationResponse noti) async {
    try {
      // if (noti.notificationResponseType ==
      //         NotificationResponseType.selectedNotificationAction &&
      //     noti.actionId == LocalMessageNotificationService.ANSWER_ACTION_ID) {
      var data = json.decode(noti.payload!);
      var convId = data['converstation_id'];
      var text = noti.input!;
      var context = navigatorKey.currentContext!;
      var senderId = context.read<AuthRepo>().userId!;
      await chatRepo.sendMessage(
        ApiMessageModel(
          messageId: GeneratorService.generateMessageId(senderId),
          conversationId: convId,
          senderId: senderId,
          message: text,
        ),
        recieveIds: List<int>.from(data['member_ids']),
        // conversationId: convId,
      );
      LocalMessageNotificationService.mapConvIdAndListNotiId.remove(convId);
      LocalMessageNotificationService.localNotification.cancel(convId);
      LocalMessageNotificationService.localNotification.cancelAll();
      // }
    } catch (e, s) {
      logger.logError(e, s);
    }
  }

  void _bindBackgroundIsolate() {
    final isSuccess = IsolateNameServer.registerPortWithName(
      _port.sendPort,
      'downloader_send_port',
    );
    if (!isSuccess) {
      _unbindBackgroundIsolate();
      _bindBackgroundIsolate();
      return;
    }
    _port.listen((dynamic data) {
      final taskId = (data as List<dynamic>)[0] as String;
      final status = data[1] as DownloadTaskStatus;
      final progress = data[2] as int;

      logger.log(
        'Callback on UI isolate: '
        'task ($taskId) is in status ($status) and process ($progress)',
        name: 'FlutterDownloaderLog',
      );

      var model;
      try {
        model = (_downloaderCubit.tasks)
            .values
            .firstWhere((e) => e.taskId == taskId, orElse: () {
          throw Exception(
              ('Not found taskId: $taskId in ${_downloaderCubit.tasks.values.join('\n')}'));
        });
      } catch (e) {
        logger.logError(e, null, 'FindTaskError');
        return;
      }

      model.progress.value = progress;

      if (status.value == 3 && progress == 100) {
        _downloaderCubit
            .updateTask(model.copyWith(status: DownloadStatus.downloaded));
      } else if (status.value == 4 || progress == -1) {
        _downloaderCubit
            .updateTask(model.copyWith(status: DownloadStatus.none));
        AppDialogs.toast('Lỗi khi tải file [${status.value}/$progress]');
      }
    });
  }

  void _unbindBackgroundIsolate() =>
      IsolateNameServer.removePortNameMapping('downloader_send_port');

  _onSocketDisconnected() async {
    logger.logError('****** Socket disconnected *******');
    while (chatClient.socket.disconnected) {
      await Future.delayed(const Duration(seconds: 1));
      if ((await networkCubit.check) == DataConnectionStatus.connected) {
        await Future.delayed(const Duration(seconds: 1));
        if (chatClient.socket.disconnected) {
          // print('Has Internet: Reconnected failure');
          networkCubit.emit(NetworkState(
            true,
            socketDisconnected: true,
          ));
        } else {
          networkCubit.emit(NetworkState(true));
          if (authRepo.userInfo != null) {
            logger.log('LoggedIn', name: 'Login Message Log');
            chatClient.emit(ChatSocketEvent.login, [
              authRepo.userInfo!.id,
              "chat365",
            ]);
          }
        }
      } else {
        // print('Internet failure: Reconnected failure');
        networkCubit.emit(NetworkState(
          false,
          socketDisconnected: true,
        ));
      }
    }
  }

  _onCallSocketDisconnected() async {
    logger.logError('****** Call disconnected *******');
    while (callClient.socket.disconnected) {
      await Future.delayed(const Duration(seconds: 1));
      if ((await networkCubit.check) == DataConnectionStatus.connected) {
        callClient.reconnect();
        await Future.delayed(const Duration(seconds: 1));
        if (callClient.socket.disconnected) {
          // print('Has Internet: Reconnected failure');
          networkCubit.emit(NetworkState(
            true,
            socketDisconnected: true,
          ));
        } else {
          networkCubit.emit(NetworkState(true));
          if (authRepo.userInfo != null) {
            logger.log('LoggedIn', name: 'Login Message Log');
            callClient.socket.auth = {
              'userId': 'chat_${authRepo.userInfo!.id}'
            };
            callClient.emit('addUser', {
              'userId': 'chat_${authRepo.userInfo!.id}',
              'name': authRepo.userInfo!.name
            });
          }
        }
      } else {
        // print('Internet failure: Reconnected failure');
        networkCubit.emit(NetworkState(
          false,
          socketDisconnected: true,
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Fluttertoast.cancel();
        return Future.value(true);
      },
      child: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
          Fluttertoast.cancel();
        },
        child: MultiRepositoryProvider(
          providers: [
            RepositoryProvider.value(
              value: authRepo,
            ),
            RepositoryProvider.value(
              value: userInfoRepo,
            ),
            RepositoryProvider.value(
              value: chatRepo,
            ),
            RepositoryProvider.value(
              value: chatConversationsRepo,
            ),
            RepositoryProvider(create: (_) => GetTokenRepo(authRepo)),
          ],
          child: MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => AuthBloc(context.read<AuthRepo>()),
              ),
              BlocProvider(
                create: (context) => LoginCubit(context.read<AuthRepo>()),
              ),
              BlocProvider(
                create: (context) => ChatBloc(context.read<ChatRepo>()),
              ),
              BlocProvider.value(value: networkCubit),
              BlocProvider(create: (context) => ThemeCubit(context)),
              BlocProvider(
                  create: (context) =>
                      FriendCubit(chatRepo: context.read<ChatRepo>())),
              BlocProvider.value(
                value: chatConversationBloc,
              ),
              BlocProvider.value(value: _downloaderCubit),
              BlocProvider(create: (_) => SettingsCubit()),
            ],
            child: BlocListener<ChatBloc, ChatState>(
              listenWhen: (_, current) =>
                  mounted && current is ChatStateGetConversationId,
              listener: (context, state) {
                AppRouter.removeAllDialog(navigatorContext);
                if (state is ChatStateGettingConversationId)
                  AppDialogs.showLoadingCircle(navigatorContext);
                else if (state is ChatStateGetConversationIdError)
                  AppDialogs.toast(state.error.toString());
                else if (state is ChatStateGetConversationIdSuccess) {
                  final IUserInfo chatInfo = state.chatInfo;
                  AppRouterHelper.toChatPage(
                    navigatorContext,
                    userInfoBloc: UserInfoBloc(
                      chatInfo,
                    ),
                    chatItemModel: state.chatItemModel,
                    isGroup: state.isGroup,
                    senderId: navigatorContext.userInfo().id,
                    conversationId: state.conversationId,
                    unreadMessageCounterCubit: chatConversationBloc
                        .unreadMessageCounteCubits[state.conversationId],
                    action: state.action,
                  );
                }
              },
              child: BlocBuilder<ThemeCubit, ThemeState>(
                builder: (context, themeState) {
                  return MaterialApp(
                    debugShowCheckedModeBanner: false,
                    navigatorKey: navigatorKey,
                    scaffoldMessengerKey: scaffoldKey,
                    title: AppConst.appName,
                    theme: themeState.theme.theme,
                    localizationsDelegates: [
                      GlobalWidgetsLocalizations.delegate,
                      GlobalCupertinoLocalizations.delegate,
                      GlobalMaterialLocalizations.delegate,
                    ],
                    supportedLocales: const [
                      Locale('vi', 'VN'),
                      Locale('en', 'US')
                    ],
                    themeMode: ThemeMode.light,
                    navigatorObservers: [routeObserver],
                    builder: (context, child) {
                      if (_initTheme == null)
                        try {
                          HiveService().initWithContext().then((isRegister) {
                            if (!isRegister) {
                              final _themeCubit = context.read<ThemeCubit>();
                              final themeBox = HiveService().themeBox;
                              if (themeBox != null)
                                _themeCubit.setThemeBox(themeBox);
                              _initTheme = themeBox?.get(ThemeCubit.themeKey);
                              if (_initTheme != null)
                                _themeCubit.emit(ThemeState(_initTheme!));
                            }
                          });
                        } catch (e, s) {
                          logger.logError(e, s);
                        } finally {
                          _initTheme = context.theme;
                        }

                      var authRepo = context.read<AuthRepo>();
                      var authBloc = context.read<AuthBloc>();

                      return MediaQuery(
                        data: MediaQuery.of(context).copyWith(
                          textScaleFactor: 1.0,
                        ),
                        child: BlocListener<AuthBloc, AuthState>(
                          listener: (context, state) async {
                            AppRouter.removeAllDialog(navigatorContext);
                            if (state is AuthenticatedState) {
                              var totalConversation =
                                  spService.totalConversation;
                              if (totalConversation == null) {
                                AppDialogs.toast(
                                  'Đã có sự cố xảy ra, vui lòng đăng nhập lại',
                                );
                                logger.logError(
                                  'Lỗi: totalConversation is null',
                                );
                                return authBloc.add(AuthStatusChanged(
                                  AuthStatus.unauthenticated,
                                ));
                              }

                              final ContactListRepo contactListRepo =
                                  ContactListRepo(
                                authRepo.userId!,
                                companyId: authRepo.userInfo!.companyId ?? 0,
                              );

                              searchContactCubits = ContactListCubit(
                                contactListRepo,
                                initFilter: null,
                              );

                              searchAllPreSearchData = null;
                              sendMessagePreSearchData.clear();

                              context.read<FriendCubit>().fetchFriendData();

                              context
                                  .read<ChatConversationsRepo>()
                                  .totalRecords = totalConversation;

                              var userId = authRepo.userInfo!.id;

                              SpUtil.putInt(LocalStorageKey.userId, userId);

                              chatClient.emit(ChatSocketEvent.login, [
                                userId,
                                "chat365",
                              ]);
                              //check nếu đăng nhập có dữ liệu thì add vào
                              Signaling().userInfo = authRepo.userInfo;
                              logger.log(
                                'Chat soket logged in ${authRepo.userInfo!.id}',
                                color: StrColor.magenta,
                              );
                              try {
                                callClient.socket.auth = {
                                  'userId': 'chat_${authRepo.userInfo!.id}'
                                };

                                callClient.emit('addUser', {
                                  'userId': 'chat_${authRepo.userInfo!.id}',
                                  'name': authRepo.userInfo!.name
                                });
                              } catch (e, s) {
                                logger.logError(e, s);
                              }
                              //lắng nghe
                              callClient.on('recviceListMemberCallGroupPS',
                                  (data) {
                                print(data);

                                // tgeo huong dan
                                final RecviceListMemberCallGroupPSDataModel
                                    model =
                                    RecviceListMemberCallGroupPSDataModel
                                        .fromMap(data);
                                if (authRepo.userInfo?.id != null)
                                  try {
                                    List<int> idListCallee = [];
                                    model.idListCallee.map((e) {
                                      var id = int.tryParse(e);
                                      idListCallee.add(id!);
                                    });
                                    AppRouter.toPage(
                                        navigatorKey.currentContext!,
                                        AppPages.Video_Call,
                                        arguments: {
                                          'userInfor': authRepo.userInfo,
                                          'idRoom':
                                              model.linkGroup.split('/').last,
                                          'idCaller': model.idCaller,
                                          'idCallee': idListCallee,
                                          'idConversation': '',
                                          'checkCallee': true,
                                        });
                                  } catch (e, s) {
                                    print(s);
                                  }
                              });
                              //
                              callClient.on(
                                  'decline_currnent_meeting_invite_from_receiver',
                                  (response) {
                                //userId của người từ chối
                                var caller = response['caller'];
                                // tên của người từ chối
                                var username = response['username'];
                                //socketId của người từ chối
                                var socketId = response['socketId'];
                                if (caller != null)
                                  AppRouter.back(navigatorKey.currentContext!);
                              });
                              // lắng nghe kết thúc cuộc gọi
                              callClient.on('endCallAllFromHost', (response) {
                                //id của người kết thúcthúc
                                var hostId = response['hostId'];
                                if (hostId != null)
                                  AppRouter.back(navigatorKey.currentContext!);
                              });

                              if (authRepo.userInfo is UserInfo &&
                                  (authRepo.userInfo as UserInfo).fromWeb ==
                                      StringConst.timviec365)
                                chatClient.emit(ChatSocketEvent.login, [
                                  userId,
                                  StringConst.timviec365,
                                ]);

                              chatConversationBloc.useFastApi = true;
                              if (!chatConversationBloc.loadingLocalMessages)
                                chatConversationBloc.localMessages;
                              if (_appService.countUnreadConversation == 0)
                                _appService.setupUnreadConversationId();
                              AppRouterHelper.toNavigationPage(
                                navigatorContext,
                              );
                            } else if (state is UnAuthenticatedState) {
                              try {
                                getIt.get<AppService>().reset();
                              } catch (e) {}
                              userInfo = null;
                              userType = null;
                              sendMessagePreSearchData.clear();
                              searchAllPreSearchData = null;
                              conversations = null;
                              chatConversationBloc.resetToLogout();
                              try {
                                await HiveService().clearBoxToLogout();
                              } catch (e) {}
                              AppRouter.replaceAllWithPage(
                                navigatorContext,
                                AppPages.Intro,
                              );
                            }
                          },
                          child: BlocListener<LoginCubit, LoginState>(
                            listener: (context, state) async {
                              AppRouter.removeAllDialog(navigatorContext);
                              if (state is LoginStateLoad) {
                                AppDialogs.showLoadingCircle(
                                  navigatorContext,
                                  barrierDismissible: false,
                                  routeSettings: RouteSettings(
                                    name: StringConst.loggingInDialog,
                                  ),
                                );
                              } else if (state is LoginWaring) {
                                AppDialogs.toast(
                                    'Warning strange device login!');
                                AppRouter.toPage(
                                  navigatorKey.currentContext!,
                                  AppPages.Test_123,
                                  arguments: {
                                    'userInfor': state.userInfo,
                                    'countConversation':
                                        state.countConversation,
                                    'userType': state.userType,
                                  },
                                );
                              } else if (state is LoginStateSuccess) {
                                var loggedInUserInfo = state.userInfo;
                                chatConversationsRepo
                                  ..userId = loggedInUserInfo.id
                                  ..totalRecords = state.countConversation;
                                chatConversationBloc.loadData();
                                authRepo
                                  ..userInfo = loggedInUserInfo
                                  ..userType = state.userType;
                                await spService.saveTotalConversation(
                                  state.countConversation,
                                );
                                if (!loggedInUserInfo.email.isBlank)
                                  await spService.saveLoggedInEmail(
                                    loggedInUserInfo.email!,
                                  );
                                try {
                                  await spService.saveLoggedInInfo(
                                    info: authRepo.userInfo!,
                                    userType: authRepo.userType,
                                  );
                                } catch (e, s) {
                                  return logger.logError(e, s);
                                }
                                authBloc.add(
                                  AuthStatusChanged(
                                    AuthStatus.authenticated,
                                  ),
                                );
                              } else if (state is LoginStateError) {
                                //*Loi lien quan sai mat khau dat o man login screen
                                AppDialogs.toast(state.error);
                                if (state.errorRes != null) {
                                  //Kiem tra khong la code 200
                                  //va sai ko phai lien quan xac thuc cong ty thi hien toast
                                  if (state.errorRes!.code != 200 &&
                                      state.errorRes!.messages != null &&
                                      !state.errorRes!.messages!
                                          .contains('chưa xác thực')) {
                                    AppDialogs.toast(state.error);
                                  }
                                  // else if (state.errorRes!.code == 200 &&
                                  //     state.errorRes!.messages != null &&
                                  //     !state.errorRes!.messages!.contains(
                                  //         'mật khẩu không chính xác')) {
                                  //   AppDialogs.toast(
                                  //       'Kết nối không ổn định');
                                  // }
                                  // else {
                                  //   AppDialogs.toast('');
                                  // }
                                }
                              }
                            },
                            child: child!,
                          ),
                        ),
                      );
                    },
                    home: const SplashScreen(
                      key: ValueKey('SplashScreen'),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
