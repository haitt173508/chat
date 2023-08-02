import 'package:chat_365/common/blocs/friend_cubit/cubit/friend_cubit.dart';
import 'package:chat_365/common/blocs/suggest_contact_cubit/cubit/suggest_contact_cubit.dart';
import 'package:chat_365/common/components/display/display_avatar.dart';
import 'package:chat_365/common/widgets/custom_refresh_indicator.dart';
import 'package:chat_365/common/widgets/user_list_tile.dart';
import 'package:chat_365/core/constants/string_constants.dart';
import 'package:chat_365/core/interfaces/interface_user_info.dart';
import 'package:chat_365/core/theme/app_colors.dart';
import 'package:chat_365/core/theme/app_text_style.dart';
import 'package:chat_365/modules/contact/cubits/contact_list_cubit/contact_list_cubit.dart';
import 'package:chat_365/modules/contact/cubits/contact_list_cubit/contact_list_state.dart';
import 'package:chat_365/modules/contact/model/api_contact.dart';
import 'package:chat_365/modules/contact/widget/suggest_contact_item.dart';
import 'package:chat_365/utils/data/enums/contact_source.dart';
import 'package:chat_365/utils/data/enums/friend_status.dart';
import 'package:chat_365/utils/data/enums/user_type.dart';
import 'package:chat_365/utils/data/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RecievedFriendRequest extends StatelessWidget {
  const RecievedFriendRequest({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final FriendCubit friendCubit = context.read<FriendCubit>();
    // var userInfo = context.userInfo();
    final ContactListCubit contactListCubit = context.read<ContactListCubit>();

    var friendPart = Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: TabBar(
            tabs: TabBarType.values
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
            indicatorColor: context.theme.primaryColor,
          ),
        ),
        Flexible(
          child: TabBarView(
            children: [
              _FriendTabView(
                tabBarType: TabBarType.recieved,
              ),
              _FriendTabView(
                tabBarType: TabBarType.send,
              ),
            ],
          ),
        ),
      ],
    );
    var companyContactPart = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 15.0,
            vertical: 8,
          ),
          child: Text(
            'Liên hệ trong công ty',
            style: AppTextStyles.regularW400(
              context,
              size: 14,
              lineHeight: 20,
              color: context.theme.userStatusTextStyle.color,
            ),
          ),
        ),
        Expanded(
          child: BlocProvider.value(
            value: contactListCubit,
            child: BlocBuilder<ContactListCubit, ContactListState>(
              builder: (context, state) {
                if (state is LoadSuccessState) {
                  var data = state.contactList;
                  return ListView.separated(
                    itemCount: data.length,
                    separatorBuilder: (_, __) => Divider(
                      thickness: 1,
                    ),
                    itemBuilder: (context, index) {
                      var item = data[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15.0,
                          vertical: 7.5,
                        ),
                        child: SuggestContactItem(
                          contact: ApiContact(
                            avatar: item.avatar,
                            lastActive: item.lastActive,
                            companyId: item.companyId,
                            name: item.name,
                            id: item.id,
                            contactSource: ContactSource.company,
                          ),
                          style2: true,
                        ),
                      );
                    },
                  );
                }
                return const SizedBox();
              },
            ),
          ),
        ),
      ],
    );
    var divider = Divider(
      thickness: 8,
      color: context.theme.messageBoxColor,
    );
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Lời mời kết bạn'),
          elevation: 1,
        ),
        body: Container(
          color: context.theme.backgroundColor,
          child: context.userType() == UserType.customer
              ? friendPart
              : NestedScrollView(
                  headerSliverBuilder: (context, innerBoxIsScrolled) => [
                    SliverAppBar(
                      expandedHeight: context.mediaQuerySize.height / 2 - 46,
                      collapsedHeight: 0,
                      toolbarHeight: 0,
                      pinned: true,
                      floating: true,
                      backgroundColor: Colors.transparent,
                      flexibleSpace: FlexibleSpaceBar(
                        background: Column(
                          children: [
                            Expanded(child: friendPart),
                            divider,
                          ],
                        ),
                      ),
                    ),
                  ],
                  body: companyContactPart,
                ),
        ),
      ),
    );
  }
}

enum TabBarType {
  recieved,
  send,
}

extension TabBarTypeExt on TabBarType {
  String get name {
    switch (this) {
      case TabBarType.recieved:
        return 'Đã nhận';
      case TabBarType.send:
        return 'Đã gửi';
    }
  }
}

class _FriendTabView extends StatelessWidget {
  const _FriendTabView({
    Key? key,
    required this.tabBarType,
  }) : super(key: key);

  final TabBarType tabBarType;

  @override
  Widget build(BuildContext context) {
    final SuggestContactCubit suggestContactCubit =
        context.read<SuggestContactCubit>();

    final FriendCubit friendCubit = context.read<FriendCubit>();

    return ElevatedButtonTheme(
      data: Theme.of(context).elevatedButtonTheme
        ..style!.copyWith(
          maximumSize: MaterialStateProperty.all(Size.fromHeight(36)),
          minimumSize: MaterialStateProperty.all(Size.fromHeight(36)),
          fixedSize: MaterialStateProperty.all(Size.fromHeight(36)),
        ),
      child: BlocBuilder<SuggestContactCubit, SuggestContactState>(
        builder: (context, state) {
          if (state is SuggestContactSuccess) {
            final List<IUserInfo> data;

            if (tabBarType == TabBarType.recieved)
              data = suggestContactCubit.requestAddFriend;
            else
              data = suggestContactCubit.sendRequest;

            return CustomRefreshIndicator(
              onRefresh: suggestContactCubit.getAddFriendRequest,
              child: ListView.builder(
                itemCount: data.length,
                shrinkWrap: true,
                itemBuilder: (_, index) {
                  var item = data[index];
                  return BlocBuilder<FriendCubit, FriendState>(
                    buildWhen: (previous, current) =>
                        current is FriendStateLoadSuccess ||
                        (current is FriendStateResponseAddFriendSuccess &&
                            current.requestId == item.id) ||
                        (current is FriendStateStatusChanged &&
                            current.contactId == item.id) ||
                        (current is FriendStateAddFriendSuccess &&
                            current.chatId == item.id) ||
                        (current is FriendStateDeleteContact &&
                            [current.chatId, current.userId].contains(item.id)),
                    builder: (context, state) {
                      bool isFriend = false;
                      if (friendCubit.listFriends
                              ?.map((e) => e.id)
                              .contains(item.id) ??
                          false) isFriend = true;

                      if (!isFriend) {
                        // Nếu đã xóa liên hệ: không hiển thị trong view này
                        if (state is FriendStateDeleteContact) {
                          return const SizedBox();
                        }
                        // Nếu thằng kia từ chối: không hiển thị trong view này
                        // hoặc sau này cho hiển thị 'Đã từ chối'
                        else {
                          var status =
                              friendCubit.friendsRequest?[item.id]?.status;

                          if (status == FriendStatus.decline) {
                            return const SizedBox();
                          }
                          // Thu hồi lời mời kết bạn từ currentUser
                          else if (status == null) return const SizedBox();
                        }
                      }
                      // Nếu là bạn bè: không hiển thị trong view này
                      if (isFriend) return const SizedBox();

                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                UserListTile(
                                  userName: item.name,
                                  avatar: DisplayAvatar(
                                    isGroup: false,
                                    model: item,
                                    size: 50,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: tabBarType == TabBarType.recieved
                                      ? [
                                          ElevatedButton(
                                            child: Text(
                                              StringConst.decline,
                                              style: _buttonTextStyle(
                                                  AppColors.tundora),
                                            ),
                                            onPressed: () {
                                              friendCubit.responseAddFriend(
                                                context.userInfo().id,
                                                item,
                                                FriendStatus.decline,
                                              );
                                            },
                                            style: ElevatedButton.styleFrom(
                                              primary: AppColors.whiteLilac,
                                            ),
                                          ),
                                          const SizedBox(width: 16),
                                          ElevatedButton(
                                            child: Text(
                                              StringConst.agree,
                                              style: _buttonTextStyle(
                                                  AppColors.white),
                                            ),
                                            onPressed: () {
                                              friendCubit.responseAddFriend(
                                                context.userInfo().id,
                                                item,
                                                FriendStatus.accept,
                                              );
                                            },
                                          ),
                                        ]
                                      : [
                                          ElevatedButton(
                                            child: Text(
                                              StringConst.evic,
                                              style: _buttonTextStyle(
                                                  AppColors.tundora),
                                            ),
                                            onPressed: () {
                                              friendCubit
                                                  .deleteRequestAddFriend(
                                                context.userInfo().id,
                                                item.id,
                                              );
                                            },
                                            style: ElevatedButton.styleFrom(
                                              primary: AppColors.whiteLilac,
                                            ),
                                          ),
                                        ],
                                ),
                              ],
                            ),
                          ),
                          Divider(
                            color: context.theme.textColor,
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}

_buttonTextStyle(Color color) => TextStyle(
      fontSize: 14,
      height: 20 / 14,
      color: color,
    );
