import 'dart:async';
import 'dart:io';

import 'package:chat_365/common/blocs/friend_cubit/cubit/friend_cubit.dart';
import 'package:chat_365/common/blocs/suggest_contact_cubit/cubit/suggest_contact_cubit.dart';
import 'package:chat_365/common/blocs/user_info_bloc/bloc/user_info_bloc.dart';
import 'package:chat_365/common/blocs/user_info_bloc/bloc/user_info_state.dart';
import 'package:chat_365/common/components/display_image_with_status_badge.dart';
import 'package:chat_365/common/images.dart';
import 'package:chat_365/common/widgets/app_error_widget.dart';
import 'package:chat_365/common/widgets/chip_tab_bar.dart';
import 'package:chat_365/common/widgets/custom_refresh_indicator.dart';
import 'package:chat_365/common/widgets/user_list_tile.dart';
import 'package:chat_365/core/constants/app_constants.dart';
import 'package:chat_365/core/constants/string_constants.dart';
import 'package:chat_365/core/interfaces/interface_user_info.dart';
import 'package:chat_365/core/theme/app_colors.dart';
import 'package:chat_365/core/theme/app_text_style.dart';
import 'package:chat_365/modules/chat/blocs/chat_bloc/chat_bloc.dart';
import 'package:chat_365/modules/contact/cubits/contact_list_cubit/contact_list_cubit.dart';
import 'package:chat_365/modules/contact/cubits/contact_list_cubit/contact_list_state.dart';
import 'package:chat_365/modules/contact/model/api_contact.dart';
import 'package:chat_365/modules/contact/model/filter_contacts_by.dart';
import 'package:chat_365/modules/contact/repos/contact_list_repo.dart';
import 'package:chat_365/modules/contact/screens/_recent_online_friend_tab.dart';
import 'package:chat_365/modules/contact/widget/text_header.dart';
import 'package:chat_365/router/app_router_helper.dart';
import 'package:chat_365/utils/data/enums/choice_dialog_type.dart';
import 'package:chat_365/utils/data/extensions/context_extension.dart';
import 'package:chat_365/utils/data/extensions/string_extension.dart';
import 'package:chat_365/utils/ui/app_dialogs.dart';
import 'package:chat_365/utils/ui/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';

class FriendTab extends StatefulWidget {
  const FriendTab({
    Key? key,
    required this.scrollController,
    required this.subscription,
    required this.appBarHeight,
  }) : super(key: key);
  final ScrollController scrollController;
  final ValueChanged<bool> subscription;
  final ValueNotifier<double> appBarHeight;

  @override
  State<FriendTab> createState() => FriendTabState();
}

class FriendTabState extends State<FriendTab>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  static const double appBarMaxHeight = 250;
  static const double kTabBarHeight = 46;
  late final FriendCubit _friendCubit;
  late final IUserInfo userInfo;
  late final SuggestContactCubit _suggestContactCubit;
  late final ContactListCubit _contactListCubit;
  final StreamController<bool> _streamController = StreamController()
    ..add(false);
  late final StreamSubscription<bool> _subscription;
  late final TabController _tabController;
  final List<ValueNotifier<int>> _counts = List.generate(
    ChoiceChipType.values.length,
    (_) => ValueNotifier(0),
  );

  Timer? _timer;
  ValueNotifier<bool> checkReload = ValueNotifier(false);
  @override
  void initState() {
    super.initState();
    _suggestContactCubit = context.read<SuggestContactCubit>();
    _friendCubit = context.read<FriendCubit>();
    _tabController = TabController(
      length: ChoiceChipType.values.length,
      vsync: this,
    );
    userInfo = context.userInfo();
    _contactListCubit = ContactListCubit(
      ContactListRepo(
        userInfo.id,
        companyId: userInfo.companyId!,
      ),
      initFilter: FilterContactsBy.allInCompany,
    );
    _subscription = _streamController.stream.listen(widget.subscription);
    widget.scrollController.addListener(_listener);
  }

  _listener() {
    if (widget.scrollController.position.atEdge &&
        widget.scrollController.position.pixels == 0) {
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        _timer?.cancel();
      });
    }
  }

  _buildFriendAppBarButton(
    BuildContext context, {
    required String assetPath,
    required String title,
    String? subtitle,
    VoidCallback? onTap,
  }) =>
      ListTile(
        onTap: onTap,
        leading: Container(
          decoration: BoxDecoration(
            gradient: context.theme.gradient,
            shape: BoxShape.circle,
          ),
          padding: const EdgeInsets.symmetric(vertical: 8),
          height: 36,
          width: 36,
          alignment: Alignment.center,
          child: SvgPicture.asset(
            assetPath,
            color: AppColors.white,
          ),
        ),
        contentPadding: EdgeInsets.zero,
        horizontalTitleGap: 8,
        title: Text(
          title,
          style: AppTextStyles.regularW400(
            context,
            size: 18,
            lineHeight: 26,
          ),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle,
                style: AppTextStyles.regularW400(
                  context,
                  size: 14,
                  lineHeight: 16,
                  color: AppColors.black99,
                ),
              )
            : null,
      );

  @override
  void dispose() {
    _subscription.cancel();
    _streamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var allFriendTab = BlocBuilder<ContactListCubit, ContactListState>(
      buildWhen: (previous, current) => current is LoadSuccessState,
      builder: (context, contactState) {
        return BlocBuilder<FriendCubit, FriendState>(
          bloc: _friendCubit,
          builder: (context, state) {
            if (state is FriendStateLoadSuccess ||
                state is FriendStateDeleteContact ||
                state is FriendStateResponseAddFriendSuccess ||
                state is FriendStateAddFriendSuccess) {
              // var list = _friendCubit.listFriends!.toList();
              // var list = state.contactList;
              List<IUserInfo> list = [
                if (_friendCubit.listFriends != null)
                  ..._friendCubit.listFriends!,
                if (contactState is LoadSuccessState)
                  ...contactState.contactList,
              ];

              final Map<String, List<IUserInfo>> group = Map.fromIterable(
                AppConst.alphabet,
                value: (_) => <IUserInfo>[],
              );

              list.sort();

              var alphabet = list.map(
                  (e) => e.toString()[0].toEngAlphabetString().toLowerCase());

              for (int i = 0; i < list.length; i++) {
                group[alphabet.elementAt(i)]?.add(list[i]);
              }

              group.removeWhere((k, v) => v.isEmpty);

              var groupKey = group.keys.toList();

              WidgetsBinding.instance
                  ?.addPostFrameCallback((_) => _counts[0].value = list.length);

              return ListView.builder(
                itemCount: group.length,
                padding: const EdgeInsets.symmetric(horizontal: 15),
                shrinkWrap: true,
                // controller: _scrollController,
                addAutomaticKeepAlives: true,
                addRepaintBoundaries: true,
                itemBuilder: (context, index) => StickyHeaderBuilder(
                  key: ValueKey(groupKey[index]),
                  overlapHeaders: false,
                  // controller: _scrollController, // Optional
                  builder: (BuildContext context, double stuckAmount) {
                    // stuckAmount = 1.0 - stuckAmount.clamp(0.0, 1.0);
                    return Container(
                      color: context.theme.backgroundColor,
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 7.5),
                      child: TextHeader(
                        key: ValueKey(groupKey[index]),
                        text: groupKey[index].toUpperCase(),
                      ),
                    );
                  },
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: group[groupKey[index]]!
                        .map(
                          (e) => InkWell(
                            onLongPress: () => AppDialogs.showChoicesDialog(
                              context,
                              choices: [
                                ChoiceDialogTypes.deleteContact(
                                  context,
                                  e.id,
                                )
                              ],
                            ),
                            onTap: () =>
                                context.read<ChatBloc>().tryToChatScreen(
                                      chatInfo: e,
                                      isGroup: false,
                                      isNeedToFetchChatInfo: true,
                                    ),
                            child: Ink(
                              padding: const EdgeInsets.only(top: 15),
                              child: BlocProvider(
                                create: (context) => UserInfoBloc(e),
                                child: BlocBuilder<UserInfoBloc, UserInfoState>(
                                  builder: (context, userState) {
                                    var userInfo = userState.userInfo;
                                    return UserListTile(
                                      userName: userInfo.name,
                                      avatar: DisplayImageWithStatusBadge(
                                        isGroup: false,
                                        model: userInfo,
                                        userStatus: userInfo.userStatus,
                                        badgeSize: 15,
                                        enable: false,
                                        size: 50,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              );
            }
            if (state is FriendStateLoadError)
              return AppErrorWidget(
                error: state.error.error,
                onTap: () {
                  _suggestContactCubit.getAllSuggestContact();
                  _friendCubit.fetchFriendData();
                },
              );
            return WidgetUtils.loadingCircle(context);
          },
        );
      },
    );
    var recentOnlineTab = BlocBuilder<ContactListCubit, ContactListState>(
      buildWhen: (previous, current) => current is LoadSuccessState,
      builder: (context, contactState) {
        return BlocBuilder<FriendCubit, FriendState>(
          builder: (context, state) {
            final List<IUserInfo> list = [
              if (_friendCubit.listFriends != null)
                ..._friendCubit.listFriends!,
              if (contactState is LoadSuccessState) ...contactState.contactList,
            ];

            return RecentOnlineFriendTab(
              countOnlines: (value) => _counts[2].value = value,
              userInfos: list,
            );
          },
        );
      },
    );
    var newFriendTab = ValueListenableBuilder(
      valueListenable: checkReload,
      builder: (_, __, ___) {
        return FutureBuilder<List<ApiContact>>(
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return WidgetUtils.centerLoadingCircle;
            }
            if (snapshot.hasData) {
              List<IUserInfo> list = [...snapshot.data!];

              final Map<String, List<IUserInfo>> group = Map.fromIterable(
                AppConst.alphabet,
                value: (_) => <IUserInfo>[],
              );

              list.sort();

              var alphabet = list.map(
                  (e) => e.toString()[0].toEngAlphabetString().toLowerCase());

              for (int i = 0; i < list.length; i++) {
                group[alphabet.elementAt(i)]?.add(list[i]);
              }

              group.removeWhere((k, v) => v.isEmpty);

              var groupKey = group.keys.toList();

              WidgetsBinding.instance
                  ?.addPostFrameCallback((_) => _counts[1].value = list.length);
              return ListView.builder(
                itemCount: group.length,
                padding: const EdgeInsets.symmetric(horizontal: 15),
                shrinkWrap: true,
                // controller: _scrollController,
                addAutomaticKeepAlives: true,
                addRepaintBoundaries: true,
                itemBuilder: (context, index) => StickyHeaderBuilder(
                  key: ValueKey(groupKey[index]),
                  overlapHeaders: false,
                  // controller: _scrollController, // Optional
                  builder: (BuildContext context, double stuckAmount) {
                    // stuckAmount = 1.0 - stuckAmount.clamp(0.0, 1.0);
                    return Container(
                      color: context.theme.backgroundColor,
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 7.5),
                      child: TextHeader(
                        key: ValueKey(groupKey[index]),
                        text: groupKey[index].toUpperCase(),
                      ),
                    );
                  },
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: group[groupKey[index]]!
                        .map(
                          (e) => InkWell(
                            onLongPress: () => AppDialogs.showChoicesDialog(
                              context,
                              choices: [
                                ChoiceDialogTypes.deleteContact(
                                  context,
                                  e.id,
                                )
                              ],
                            ),
                            onTap: () =>
                                context.read<ChatBloc>().tryToChatScreen(
                                      chatInfo: e,
                                      isGroup: false,
                                      isNeedToFetchChatInfo: true,
                                    ),
                            child: Ink(
                              padding: const EdgeInsets.only(top: 15),
                              child: BlocProvider(
                                create: (context) => UserInfoBloc(e),
                                child: BlocBuilder<UserInfoBloc, UserInfoState>(
                                  builder: (context, userState) {
                                    var userInfo = userState.userInfo;
                                    return UserListTile(
                                      userName: userInfo.name,
                                      avatar: DisplayImageWithStatusBadge(
                                        isGroup: false,
                                        model: userInfo,
                                        userStatus: userInfo.userStatus,
                                        badgeSize: 15,
                                        enable: false,
                                        size: 50,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              );
            }
            return SizedBox();
          },
          future: _friendCubit.getListNewsFriends(),
        );
      },
    );

    return BlocProvider.value(
      value: _contactListCubit,
      child: CustomRefreshIndicator(
        onRefresh: () async {
          _friendCubit.fetchFriendData();
          _contactListCubit.loadContact();
          checkReload.value = !checkReload.value;
        },
        notificationPredicate: (notification) {
          bool depth;
          if (Platform.isIOS) {
            depth = notification.depth == 3;
          } else
            depth = notification.depth == 2;

          return depth && _timer?.isActive == false;
        },
        child: NestedScrollView(
          controller: widget.scrollController,
          headerSliverBuilder: (_, innerBoxIsScrolled) {
            _streamController.sink.add(innerBoxIsScrolled);
            return [
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                sliver: SliverAppBar(
                  expandedHeight: appBarMaxHeight,
                  collapsedHeight: 0,
                  toolbarHeight: 0,
                  floating: true,
                  pinned: true,
                  flexibleSpace: LayoutBuilder(builder: (context, c) {
                    widget.appBarHeight.value = c.maxHeight;
                    return FlexibleSpaceBar(
                      collapseMode: CollapseMode.pin,
                      background: Column(
                        children: [
                          const SizedBox(height: 56),
                          _buildFriendAppBarButton(
                            context,
                            assetPath: Images.ic_contacts_book,
                            title: 'Lời mời kết bạn',
                            onTap: () => AppRouterHelper.toFriendRequestPage(
                              context,
                              suggestContactCubit: _suggestContactCubit,
                              contactListCubit: _contactListCubit,
                            ),
                          ),
                          _buildFriendAppBarButton(
                            context,
                            assetPath: Images.ic_profile_2user,
                            title: 'Danh bạ máy',
                            subtitle: 'Các liên hệ có dùng Chat365',
                            onTap: () {
                              return AppRouterHelper.toPhoneContactPage(
                                context,
                                suggestContactCubit: _suggestContactCubit,
                              );
                            },
                          ),
                          Container(
                            height: 8,
                            color: context.theme.messageBoxColor,
                          ),
                          ChipTabBar<ChoiceChipType>(
                            tabs: ChoiceChipType.values,
                            name: (e) => e.name,
                            tabController: _tabController,
                            counts: _counts,
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ),
            ];
          },
          body: TabBarView(
            controller: _tabController,
            children: [
              allFriendTab,
              newFriendTab,
              recentOnlineTab,
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

enum ChoiceChipType {
  all,
  newFriend,
  recentAccess,
}

extension ChoiceChipTypeExt on ChoiceChipType {
  String get name {
    switch (this) {
      case ChoiceChipType.all:
        return StringConst.all;
      case ChoiceChipType.newFriend:
        return StringConst.newFriend;
      case ChoiceChipType.recentAccess:
        return StringConst.recentAccess;
    }
  }
}
