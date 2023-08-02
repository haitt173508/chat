import 'package:badges/badges.dart';
import 'package:chat_365/common/blocs/friend_cubit/cubit/friend_cubit.dart';
import 'package:chat_365/common/blocs/network_cubit/network_cubit.dart';
import 'package:chat_365/common/blocs/suggest_contact_cubit/cubit/suggest_contact_cubit.dart';
import 'package:chat_365/common/blocs/user_info_bloc/bloc/user_info_bloc.dart';
import 'package:chat_365/common/images.dart';
import 'package:chat_365/core/constants/app_constants.dart';
import 'package:chat_365/core/constants/asset_path.dart';
import 'package:chat_365/core/constants/string_constants.dart';
import 'package:chat_365/core/theme/app_colors.dart';
import 'package:chat_365/core/theme/app_text_style.dart';
import 'package:chat_365/main.dart';
import 'package:chat_365/modules/auth/bloc/auth_bloc.dart';
import 'package:chat_365/modules/auth/repo/auth_repo.dart';
import 'package:chat_365/modules/chat/blocs/chat_bloc/chat_bloc.dart';
import 'package:chat_365/modules/chat/repo/chat_repo.dart';
import 'package:chat_365/modules/chat_conversations/bloc/chat_conversation_bloc.dart';
import 'package:chat_365/modules/chat_conversations/repo/chat_conversations_repo.dart';
import 'package:chat_365/modules/chat_conversations/screens/chat_conversation_screen.dart';
import 'package:chat_365/modules/contact/screens/contact_screen.dart';
import 'package:chat_365/modules/get_token/repos/get_token_repo.dart';
import 'package:chat_365/modules/navigation/screen/features_screen.dart';
import 'package:chat_365/modules/notification/notification_bloc/notification_bloc.dart';
import 'package:chat_365/modules/notification/repo/notification_repo.dart';
import 'package:chat_365/modules/notification/screens/notification_screen.dart';
import 'package:chat_365/modules/profile/screens/profile_screen.dart';
import 'package:chat_365/modules/timekeeping/bloc/timekeeping_bloc.dart';
import 'package:chat_365/modules/timekeeping/bloc/timekeeping_state.dart';
import 'package:chat_365/modules/timekeeping/repo/timekeeping_repo.dart';
import 'package:chat_365/router/app_router.dart';
import 'package:chat_365/router/app_router_helper.dart';
import 'package:chat_365/service/app_service.dart';
import 'package:chat_365/service/injection.dart';
import 'package:chat_365/service/local_message_notification_service.dart';
import 'package:chat_365/utils/data/enums/bottom_bar_item_type.dart';
import 'package:chat_365/utils/data/enums/themes.dart';
import 'package:chat_365/utils/data/enums/user_type.dart';
import 'package:chat_365/utils/data/extensions/context_extension.dart';
import 'package:chat_365/utils/data/extensions/list_extension.dart';
import 'package:chat_365/utils/helpers/logger.dart';
import 'package:chat_365/utils/ui/app_dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({Key? key}) : super(key: key);

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  late int _screenIndex;
  late final ChatConversationBloc _chatConversationBloc;
  late final ChatRepo _chatRepo;
  late final ChatBloc _chatBloc;
  late final AuthRepo _authRepo;
  late final UserInfoBloc _userInfoBloc;
  late final MyTheme _myTheme;
  late List<BottomNavigationBarItem> _items;
  late final NotificationBloc _notificationBloc;
  late final SuggestContactCubit _suggestContactCubit;
  late final TimekeepingBloc? timeKeepingBloc;
  late final _unreadConversationStream;
  late final AppService _appService;

  // late final FavoriteConversationCubit _favoriteConversationCubit;

  changeScreen(int index) => setState(() {
        _screenIndex = index;
      });

  bool get hasTimeKeepingTab => context.userType() == UserType.staff;

  @override
  void initState() {
    super.initState();
    //Khơi tạo token

    _appService = getIt.get<AppService>();
    _unreadConversationStream = _appService.unreadConversationStream;

    _myTheme = context.theme;

    _screenIndex = 0;
    _authRepo = context.read<AuthRepo>();
    _chatRepo = context.read<ChatRepo>();
    _chatBloc = context.read<ChatBloc>();
    context.read<ChatConversationsRepo>().userId = _authRepo.userId!;
    _chatConversationBloc = context.read<ChatConversationBloc>();
    _suggestContactCubit = SuggestContactCubit(
      userInfo: context.userInfo(),
      friendCubit: context.read<FriendCubit>(),
    )..getAllSuggestContact(checkUserDenied: true);
    if (hasTimeKeepingTab) {
      final TimekeepingRepo timekeepingRepo =
          TimekeepingRepo(context.userInfo().companyId ?? 0);

      timeKeepingBloc = TimekeepingBloc(
        TimekeepingLoadingState(),
        timekeepingRepo,
        context.read<GetTokenRepo>(),
      );
      // ..getUserLocation()
      // ..getInfoWifi();
      // ..getTimekeepingConfiguration();
    } else
      timeKeepingBloc = null;
    if (_chatConversationBloc.state is ChatConversationStateError)
      _chatConversationBloc.loadData(countLoaded: 0);

    _userInfoBloc = UserInfoBloc(
      _authRepo.userInfo!,
    );
    _notificationBloc = NotificationBloc(
      NotificationRepo(_authRepo.userInfo!.id),
    );

    // _chatConversationBloc.stream.listen((state) {
    //   if (state is ChatConversationEventAddFavoriteConversation) {
    //     var item = (state as ChatConversationEventAddFavoriteConversation).item;
    //     _favoriteConversationCubit.add([
    //       FavoriteConversationModel(
    //         item.conversationBasicInfo.id,
    //         item.isGroup,
    //       )
    //     ]);
    //   } else if (state is ChatConversationRemoveFavoriteSuccessState) {
    //     var item =
    //         (state as ChatConversationEventRemoveFavoriteConversation).item;
    //     _favoriteConversationCubit.remove(
    //       FavoriteConversationModel(
    //         item.conversationBasicInfo.id,
    //         item.isGroup,
    //       ),
    //     );
    //   } else if (state is ChatConversationStateLoadDone) {}
    // });
  }

  @override
  void dispose() {
    _userInfoBloc.close();
    _suggestContactCubit.close();

    super.dispose();
  }

  _bottomNavigationBarItemIcon(
    String iconAsset, {
    required Color color,
    bool isActivated = false,
    required BottomBarItemType type,
  }) {
    final Widget itemWidget = SizedBox.fromSize(
      size: const Size.square(AppConst.kBottomNavigationBarItemIconSize),
      child: isActivated
          ? ShaderMask(
              child: SvgPicture.asset(
                iconAsset,
                fit: BoxFit.contain,
                height: AppConst.kBottomNavigationBarItemIconSize,
                width: AppConst.kBottomNavigationBarItemIconSize,
              ),
              shaderCallback: (Rect bounds) =>
                  _myTheme.gradient.createShader(bounds),
            )
          : SvgPicture.asset(
              iconAsset,
              fit: BoxFit.contain,
              color: _myTheme.unSelectedIconColor,
              height: AppConst.kBottomNavigationBarItemIconSize,
              width: AppConst.kBottomNavigationBarItemIconSize,
            ),
    );
    final Widget res;
    if (type == BottomBarItemType.message)
      res = StreamBuilder<Set<int>>(
          stream: _unreadConversationStream,
          initialData: _appService.unreadConversationIds,
          builder: (context, sns) {
            var isShow = !sns.data.isBlank;
            var length = sns.data?.length;
            return Badge(
              showBadge: isShow,
              shape: BadgeShape.square,
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
              borderRadius: BorderRadius.circular(100),
              badgeContent: !isShow
                  ? const SizedBox()
                  : Text(
                      length! > 99 ? '99+' : length.toString(),
                      style: AppTextStyles.regularW400(
                        context,
                        size: 10,
                        color: AppColors.white,
                      ),
                      textHeightBehavior: TextHeightBehavior(
                        leadingDistribution: TextLeadingDistribution.even,
                      ),
                    ),
              child: itemWidget,
            );
          });
    else
      res = itemWidget;
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: res,
    );
  }

  _bottomNavigationBarItem(
    String iconAsset,
    String label,
    String selectedIconAsset,
    BottomBarItemType type,
  ) {
    return BottomNavigationBarItem(
      icon: _bottomNavigationBarItemIcon(
        iconAsset,
        color: _myTheme.unSelectedIconColor,
        type: type,
      ),
      label: label,
      activeIcon: _bottomNavigationBarItemIcon(
        selectedIconAsset,
        color: context.theme.primaryColor,
        isActivated: true,
        type: type,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _items = [
      _bottomNavigationBarItem(
        AssetPath.chat,
        StringConst.conversation,
        AssetPath.chat_filled,
        BottomBarItemType.message,
      ),
      _bottomNavigationBarItem(
        AssetPath.contact,
        StringConst.contact,
        AssetPath.phone_filled,
        BottomBarItemType.contact,
      ),
      // if (hasTimeKeepingTab)
      _bottomNavigationBarItem(
        AssetPath.ic_utilities_outline,
        StringConst.utilities,
        AssetPath.ic_utilities,
        BottomBarItemType.feature,
      ),
      _bottomNavigationBarItem(
        AssetPath.bell,
        StringConst.notification,
        AssetPath.bell_filled,
        BottomBarItemType.noti,
      ),
      _bottomNavigationBarItem(
        Images.ic_person,
        StringConst.profile,
        AssetPath.contact_filled,
        BottomBarItemType.profile,
      ),
    ];
    // final IUserInfo userInfo = context.userInfo();
    // var _screens = _items
    //     .map((e) => StreamBuilder(
    //           stream: TestRepo().stream,
    //           builder: (_, sns) => Text(
    //             sns.data.toString(),
    //             style: TextStyle(
    //               color: Colors.primaries[DateTime.now().second % 12],
    //             ),
    //           ),
    //         ))
    //     .toList();
    var _screens = [
      ChatConversationScreen(),
      ContactScreen(),
      // if (context.userType() == UserType.staff)
      //   ChooseATimekeepingScreen()
      // else if (context.userType() == UserType.company)
      //   TimekeepingCompanyScreen()
      // else
      //   TimekeepingPersonallyScreen(),
      FeatureScreen(),
      NotificationScreen(),
      ProfileScreen(
        userInfo: _userInfoBloc.userInfo,
        isGroup: false,
      ),
    ];

    final Widget current = Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: () {
        LocalMessageNotificationService.localNotification.cancelAll();
      }),
      body: BlocListener<NetworkCubit, NetworkState>(
        listenWhen: (previous, current) =>
            !previous.hasInternet && current.hasInternet,
        listener: (context, networkState) {
          if (networkState.hasInternet) searchContactCubits.loadContact();
        },
        child: BlocListener<ChatBloc, ChatState>(
          listenWhen: (_, current) =>
              mounted && current is ChatStateLogUotAllDevice,
          listener: (context, state) {
            AppRouter.removeAllDialog(context);
            if (state is ChatStateLogUotAllDevice) {
              var id = context.userInfo().id;
              context.read<ChatRepo>().logout(id);
              context.read<ChatConversationBloc>().clear();
              context.read<AuthBloc>().add(AuthLogoutRequest());
              AppDialogs.toast(
                  'Tài khoản của bạn đã bị đăng xuất khỏi thiết bị \n Vui lòng đăng nhập lại.');
            }
            if (state is ChatStateGettingConversationId)
              AppDialogs.showLoadingCircle(context);
            else if (state is ChatStateGetConversationIdError)
              AppDialogs.toast(state.error.toString());
            else if (state is ChatStateGetConversationIdSuccess)
              AppRouterHelper.toChatPage(
                context,
                userInfoBloc: UserInfoBloc(
                  state.chatInfo,
                ),
                isGroup: state.isGroup,
                senderId: context.userInfo().id,
                conversationId: state.conversationId,
              );
          },
          child: BlocListener<NetworkCubit, NetworkState>(
            listener: (context, networkState) {
              try {
                scaffoldKey.currentState!.clearSnackBars();
                var child;
                var duration = Duration(days: 365);
                if (networkState.hasInternet) {
                  if (networkState.socketDisconnected) {
                    child = Container(
                      alignment: Alignment.center,
                      color: AppColors.orange,
                      width: double.infinity,
                      height: 1,
                    );
                  } else {
                    duration = Duration(seconds: 2);
                    child = Container(
                      alignment: Alignment.center,
                      color: AppColors.lima,
                      width: double.infinity,
                      height: 1,
                    );
                  }
                } else {
                  child = Container(
                    color: AppColors.red,
                    width: double.infinity,
                    height: 1,
                    key: ValueKey('internet-connect-error'),
                    alignment: Alignment.center,
                  );
                }
                scaffoldKey.currentState!.showSnackBar(
                  SnackBar(
                    content: child,
                    duration: duration,
                    animation: null,
                    padding: EdgeInsets.zero,
                  ),
                );
              } catch (e, s) {
                logger.logError(
                  e,
                  s,
                  'Show Snackbar Connection Error: ',
                );
              }
            },
            child: IndexedStack(
              children: _screens,
              index: _screenIndex,
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(15),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withOpacity(0.15),
                blurRadius: 4,
                offset: const Offset(0, -1),
              ),
            ],
          ),
          child: BottomNavigationBar(
            currentIndex: _screenIndex,
            items: _items,
            onTap: changeScreen,
            elevation: 4.0,
            selectedFontSize: 13,
            unselectedFontSize: 13,
          ),
        ),
      ),
    );

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: _chatRepo),
        // RepositoryProvider.value(value: _chatConversationsRepo),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider.value(value: _chatBloc),
          // BlocProvider.value(value: _chatConversationBloc),
          BlocProvider.value(value: _userInfoBloc),
          BlocProvider.value(value: _notificationBloc),
          BlocProvider.value(value: _suggestContactCubit),
          if (timeKeepingBloc != null)
            BlocProvider.value(value: timeKeepingBloc!),
        ],
        child: current,
      ),
    );

    // return WillUnfocusFormScope(
    //   child: BlocListener<ContactToChatCubit, ContactToChatState>(
    //     listenWhen: (_, current) => current is! ContactToChatInitialState,
    //     listener: (context, state) {
    //       if (state is ContactToChatInProgressState) {
    //         AppDialogs.showLoadingCircle(context);
    //       } else if (state is ContactToChatSuccessState) {
    //         AppDialogs.hideLoadingCircle(context);

    //         final chatItem = state.chatItem;

    //         AppRouter.toPage(
    //           context,
    //           AppPages.Chat_Detail,
    //           arguments: {
    //             'id': chatItem.conversationId,
    //             'model': chatItem.conversationBasicInfo,
    //             'members': chatItem.memberList,
    //             'totalNumberOfMessages': chatItem.totalNumberOfMessages,
    //           },
    //         );
    //       } else if (state is ContactToChatFailureState) {
    //         AppDialogs.resolveFailedState(context, state.error);
    //       }
    //     },
    //     child: current,
    //   ),
    // );
  }
}
