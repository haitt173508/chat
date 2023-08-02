import 'package:chat_365/common/blocs/user_info_bloc/bloc/user_info_bloc.dart';
import 'package:chat_365/common/blocs/user_info_bloc/bloc/user_info_state.dart';
import 'package:chat_365/common/components/display_image_with_status_badge.dart';
import 'package:chat_365/common/widgets/user_list_tile.dart';
import 'package:chat_365/core/interfaces/interface_user_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RecentOnlineFriendTab extends StatefulWidget {
  const RecentOnlineFriendTab({
    Key? key,
    this.countOnlines,
    required this.userInfos,
  }) : super(key: key);

  final ValueChanged<int>? countOnlines;
  final List<IUserInfo> userInfos;

  @override
  State<RecentOnlineFriendTab> createState() => _RecentOnlineFriendTabState();
}

class _RecentOnlineFriendTabState extends State<RecentOnlineFriendTab>
    with AutomaticKeepAliveClientMixin {
  // late final FriendCubit _friendCubit;
  List<IUserInfo> friends = [];

  @override
  void initState() {
    super.initState();
    // _friendCubit = context.read<FriendCubit>();
    // _friendCubit.stream.listen(_listener);
    // if (_friendCubit.listFriends != null)
    friends = [...widget.userInfos];
  }

  _listener() {
    if ((widget.userInfos.map((e) => e.id).toList()..sort()) !=
        (friends.map((e) => e.id).toList()..sort())) {
      // if (mounted)
      //   setState(() {
      friends = [...widget.userInfos];
      // });
    }
  }

  @override
  void didUpdateWidget(covariant RecentOnlineFriendTab oldWidget) {
    _listener();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    WidgetsBinding.instance
        ?.addPostFrameCallback((_) => widget.countOnlines?.call(
              friends.where((e) => e.lastActive == null).length,
            ));

    return ListView.builder(
      itemCount: friends.length,
      padding: EdgeInsets.symmetric(horizontal: 15),
      physics: const AlwaysScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        var item = friends[index];
        return BlocProvider(
          key: ValueKey(item.id),
          create: (context) => UserInfoBloc(item),
          child: BlocConsumer<UserInfoBloc, UserInfoState>(
            listener: (_, userState) {
              if (userState is UserInfoStateActiveTimeChanged) {
                item.lastActive = userState.lastActive;
                // widget.countOnlines?.call(++count);
                if (userState.lastActive == null) {
                  var index = friends.indexWhere((e) => e.id == item.id);
                  if (index != -1 && index != 0) {
                    friends.removeAt(index);
                    friends.insert(0, item);
                  }
                }
                if (mounted) setState(() {});
              }
            },
            builder: (context, userState) {
              var userInfo = userState.userInfo;
              if (userInfo.lastActive != null) return const SizedBox();
              // widget.countOnlines?.call(count);
              return Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: UserListTile(
                  userName: userInfo.name,
                  avatar: DisplayImageWithStatusBadge(
                    isGroup: false,
                    userStatus: userInfo.userStatus,
                    model: userInfo,
                    size: 50,
                    badgeSize: 15,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
