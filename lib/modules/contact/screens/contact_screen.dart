import 'package:chat_365/common/blocs/user_info_bloc/bloc/user_info_bloc.dart';
import 'package:chat_365/common/images.dart';
import 'package:chat_365/common/widgets/user_list_tile_appbar.dart';
import 'package:chat_365/core/constants/string_constants.dart';
import 'package:chat_365/core/interfaces/interface_user_info.dart';
import 'package:chat_365/core/theme/app_colors.dart';
import 'package:chat_365/core/theme/app_text_style.dart';
import 'package:chat_365/main.dart';
import 'package:chat_365/modules/contact/screens/_group_tab.dart';
import 'package:chat_365/modules/contact/widget/text_header.dart';
import 'package:chat_365/router/app_router_helper.dart';
import 'package:chat_365/utils/data/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '_friend_tab.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({Key? key}) : super(key: key);

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen>
    with TickerProviderStateMixin {
  // late final ContactListCubit contactListCubit;
  // late final SuggestContactCubit _suggestContactCubit;
  late final IUserInfo userInfo;
  late final TabController _tabController;
  final ScrollController _scrollController = ScrollController();
  late final AnimationController _tabBarAnimController;
  final GlobalKey<FriendTabState> _friendTabKey = GlobalKey<FriendTabState>();
  final ValueNotifier<bool> _isShow = ValueNotifier(false);
  final ValueNotifier<double> _appBarHeight =
      ValueNotifier(FriendTabState.appBarMaxHeight);

  @override
  void initState() {
    super.initState();
    userInfo = context.userInfo();
    _tabController = TabController(
      length: TabType.values.length,
      vsync: this,
    );
    _tabBarAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      value: 1.0,
    );
    // _suggestContactCubit = context.read<SuggestContactCubit>();
    // contactListCubit = ContactListCubit(
    //   ContactListRepo(
    //     userInfo.id,
    //     companyId: userInfo.companyId!,
    //   ),
    //   initFilter: FilterContactsBy.allInCompany,
    // );
    _scrollController.addListener(_tabBarListener);
    // context.read<ChatConversationBloc>().stream.listen((state) {
    //   if (state is ChatConversationAddFavoriteSuccessState) {
    //     var item = state.item;
    //     contactListCubit.emit(
    //       // LoadSuccessState()
    //       LoadSuccessState(
    //         contactListCubit.filterContactsBy.value,
    //         [
    //           ConversationBasicInfo(
    //             conversationId: item.conversationId,
    //             isGroup: false,
    //             userId: item.conversationBasicInfo.userId,
    //             name: item.conversationBasicInfo.name,
    //           ),
    //           // ... state.chatItems,
    //         ],
    //       ),
    //     );
    //   }
    // });
  }

  _tabBarListener() {
    if (_scrollController.position.userScrollDirection ==
            ScrollDirection.reverse &&
        _scrollController.position.pixels >= 50 &&
        _tabBarAnimController.value == 1)
      _tabBarAnimController.reverse(from: 1);
    else if (_scrollController.position.userScrollDirection ==
            ScrollDirection.forward &&
        _tabBarAnimController.value != 1)
      _tabBarAnimController.forward(from: _tabBarAnimController.value);
  }

  @override
  void dispose() {
    _tabBarAnimController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var animtedTabBar = AnimatedBuilder(
      animation: _tabBarAnimController,
      builder: (context, child) {
        return ClipRRect(
          child: Align(
            heightFactor: _tabBarAnimController.value,
            child: child!,
          ),
        );
      },
      child: Container(
        color: context.theme.backgroundColor,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: TabBar(
          indicatorColor: context.theme.primaryColor,
          controller: _tabController,
          tabs: TabType.values
              .map(
                (e) => Tab(
                  child: Text(
                    e.name,
                    style: AppTextStyles.regularW500(
                      context,
                      size: 16,
                      lineHeight: 17.85,
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
    return Scaffold(
      appBar: UserListTileAppBar(
        userInfoBloc: context.read<UserInfoBloc>(),
        elevation: 1,
        actions: [
          InkWell(
            child: SvgPicture.asset(Images.ic_uil_search),
            onTap: () {
              AppRouterHelper.toSearchContactPage(
                context,
                contactListCubit: searchContactCubits,
                showSearchCompany: false,
              );
            },
          ),
        ],
        centerTitle: true,
      ),
      body: Stack(
        children: [
          TabBarView(
            controller: _tabController,
            children: [
              AnimatedBuilder(
                animation: Listenable.merge([
                  _tabBarAnimController,
                  _isShow,
                ]),
                builder: (_, child) {
                  var visible =
                      _tabBarAnimController.value == 1 && !_isShow.value;
                  return Column(
                    children: [
                      SizedBox(
                        height: visible
                            ? (46 - _appBarHeight.value)
                                .clamp(0, double.infinity)
                            : 0,
                      ),
                      Expanded(child: child!),
                    ],
                  );
                  // return Transform.translate(
                  //   offset: Offset(0, visible ? 46 - _appBarHeight.value : 0),
                  //   child: child!,
                  // );
                },
                child: FriendTab(
                  key: _friendTabKey,
                  scrollController: _scrollController,
                  subscription: (value) => _isShow.value = !value,
                  appBarHeight: _appBarHeight,
                ),
              ),
              GroupTab(),
              // Container(),
            ],
          ),
          animtedTabBar,
          // ValueListenableBuilder<double>(
          //   valueListenable: _appBarHeight,
          //   child: const _Bottom(),
          //   builder: (_, height, child) {
          //     return Transform.translate(
          //       offset: Offset(0, height),
          //       child: child!,
          //     );
          //   },
          // ),
        ],
      ),
      // body: Padding(
      //   padding: EdgeInsets.all(15),
      //   child: Column(
      //     crossAxisAlignment: CrossAxisAlignment.start,
      //     children: [
      //       // SizedBox(
      //       //   width: double.infinity,
      //       //   child: OutlinedButton.icon(
      //       //     onPressed: () {},
      //       //     icon: SvgPicture.asset(
      //       //       Images.ic_fluent_people_add,
      //       //       color: context.theme.primaryColor,
      //       //     ),
      //       //     label: Text(
      //       //       'Thêm liên hệ mới',
      //       //       style: AppTextStyles.regular(
      //       //         context,
      //       //         size: 14,
      //       //         lineHeight: 16,
      //       //         color: context.theme.primaryColor,
      //       //       ),
      //       //     ),
      //       //     style: OutlinedButton.styleFrom(
      //       //       shape: RoundedRectangleBorder(
      //       //         borderRadius: BorderRadius.circular(15),
      //       //       ),
      //       //       side: BorderSide(color: context.theme.primaryColor),
      //       //       primary: context.theme.primaryColor,
      //       //     ),
      //       //   ),
      //       // ),
      //       const SizedBox(height: 15),
      //       ValueListenableBuilder<FilterContactsBy?>(
      //         valueListenable: contactListCubit.filterContactsBy,
      //         builder: (_, value, __) => DropdownButton<FilterContactsBy>(
      //           value: contactListCubit.filterContactsBy.value,
      //           onChanged: (value) =>
      //               contactListCubit.filterContactsBy.value = value!,
      //           borderRadius: BorderRadius.circular(15),
      //           dropdownColor: context.theme.dropdownColor,
      //           underline: const SizedBox(
      //             key: ValueKey('nil'),
      //           ),
      //           icon: SvgPicture.asset(
      //             Images.ic_arrow_down,
      //             color: context.theme.iconColor,
      //           ),
      //           items: [
      //             FilterContactsBy.allInCompany,
      //             FilterContactsBy.myContacts,
      //           ]
      //               .map(
      //                 (e) => DropdownMenuItem<FilterContactsBy>(
      //                   value: e,
      //                   child: Text(
      //                     e.displayName,
      //                     style: AppTextStyles.regularW700(
      //                       context,
      //                       size: 16,
      //                       lineHeight: 19.1,
      //                     ),
      //                   ),
      //                 ),
      //               )
      //               .toList(),
      //         ),
      //       ),
      //       const SizedBox(height: 10),
      //       Expanded(
      //         child: BlocListener<FriendCubit, FriendState>(
      //           bloc: _friendCubit,
      //           listenWhen: (_, current) {
      //             return current is FriendStateResponseAddFriendSuccess ||
      //                 current is FriendStateDeleteContact;
      //           },
      //           listener: (context, friendState) {
      //             if (friendState is FriendStateResponseAddFriendSuccess) {
      //               if (contactListCubit.state is LoadSuccessState) {
      //                 var listContact =
      //                     (contactListCubit.state as LoadSuccessState)
      //                         .contactList;
      //                 var index = listContact
      //                     .indexWhere((e) => e.id == friendState.requestId);
      //                 if (index == -1) {
      //                   contactListCubit.addUserById(
      //                     friendState.requestId,
      //                     FilterContactsBy.myContacts,
      //                   );
      //                 }
      //               }
      //             } else if (friendState is FriendStateDeleteContact) {
      //               int? chatId;
      //               if (userInfo.id == friendState.userId)
      //                 chatId = friendState.chatId;
      //               else if (userInfo.id == friendState.chatId)
      //                 chatId = friendState.userId;
      //               if (chatId != null) contactListCubit.removeContact(chatId);
      //             }
      //           },
      //           child: BlocBuilder<ContactListCubit, ContactListState>(
      //             bloc: contactListCubit,
      //             builder: (_, state) {
      //               if (state is LoadSuccessState) {
      //                 var list = state.contactList;
      //                 final Map<String, List<ConversationBasicInfo>> group =
      //                     Map.fromIterable(
      //                   AppConst.alphabet,
      //                   value: (_) => <ConversationBasicInfo>[],
      //                 );

      //                 list.sort();

      //                 var alphabet = list.map((e) =>
      //                     e.toString()[0].toEngAlphabetString().toLowerCase());

      //                 for (int i = 0; i < list.length; i++) {
      //                   group[alphabet.elementAt(i)]?.add(list[i]);
      //                 }

      //                 group.removeWhere((k, v) => v.isEmpty);

      //                 return GrouppedList(
      //                   group: group,
      //                   groupItemBuilder:
      //                       (_, __, ConversationBasicInfo contact) {
      //                     return GestureDetector(
      //                       onTap: () => context
      //                           .read<ChatBloc>()
      //                           .tryToChatScreen(contact),
      //                       onLongPress: () {
      //                         if (contactListCubit.filterContactsBy.value ==
      //                             FilterContactsBy.myContacts) {
      //                           AppDialogs.showChoicesDialog(
      //                             context,
      //                             choices: [
      //                               ChoiceDialogTypes.deleteContact(
      //                                 context,
      //                                 contact.id,
      //                               ),
      //                             ],
      //                           );
      //                         }
      //                       },
      //                       child: Padding(
      //                         padding: const EdgeInsets.only(bottom: 24.0),
      //                         child: UserListTile(
      //                           avatar: DisplayImageWithStatusBadge(
      //                             isGroup: contact.isGroup,
      //                             userStatus: contact.userStatus,
      //                             model: contact,
      //                             enable: false,
      //                           ),
      //                           userName: contact.name,
      //                           bottom: Text(
      //                             contact.status ?? '',
      //                             style: context.theme.userStatusTextStyle,
      //                           ),
      //                           onTapUserName: () => context
      //                               .read<ChatBloc>()
      //                               .tryToChatScreen(contact),
      //                         ),
      //                       ),
      //                     );
      //                   },
      //                 );
      //               }
      //               if (state is LoadFailedState) {
      //                 return AppErrorWidget(
      //                   error: state.message,
      //                   onTap: () {
      //                     contactListCubit.loadContact();
      //                   },
      //                 );
      //               }
      //               return WidgetUtils.centerLoadingCircle;
      //             },
      //           ),
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}

class GrouppedList<T> extends StatelessWidget {
  const GrouppedList({
    Key? key,
    required this.groupItemBuilder,
    required this.group,
    this.subGroupBuilder,
  }) : super(key: key);

  final Widget Function(BuildContext, String, T) groupItemBuilder;

  final Map<String, List<T>> group;

  final Widget Function(BuildContext, String, Iterable<Widget>)?
      subGroupBuilder;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              var k = group.keys.elementAt(index);
              var v = group.values.elementAt(index);
              var itemBuilders = v.map(
                (e) => groupItemBuilder(context, k, e),
              );
              return subGroupBuilder != null
                  ? subGroupBuilder!(context, k, itemBuilders)
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextHeader(text: k.toUpperCase()),
                        const SizedBox(height: 15),
                        ...itemBuilders,
                      ],
                    );
            },
            childCount: group.length,
          ),
        ),
      ],
    );
  }
}

class _Bottom extends StatefulWidget with PreferredSizeWidget {
  const _Bottom({Key? key}) : super(key: key);

  @override
  State<_Bottom> createState() => _BottomState();

  @override
  Size get preferredSize => const Size.fromHeight(30);
}

class _BottomState extends State<_Bottom> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.preferredSize.height,
      color: AppColors.red,
    );
  }
}

enum TabType {
  friend,
  group,
  // OA,
}

extension TabTypeExt on TabType {
  String get name {
    switch (this) {
      case TabType.friend:
        return StringConst.friend;
      case TabType.group:
        return StringConst.group;
      // case TabType.OA:
      //   return 'OA';
    }
  }
}
