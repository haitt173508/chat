import 'package:chat_365/common/blocs/network_cubit/network_cubit.dart';
import 'package:chat_365/common/blocs/user_info_bloc/bloc/user_info_bloc.dart';
import 'package:chat_365/common/blocs/user_info_bloc/bloc/user_info_state.dart';
import 'package:chat_365/common/blocs/user_info_bloc/repo/user_info_repo.dart';
import 'package:chat_365/common/components/display/display_avatar.dart';
import 'package:chat_365/common/components/display/time_badge.dart';
import 'package:chat_365/common/components/display_image_with_status_badge.dart';
import 'package:chat_365/common/widgets/user_list_tile.dart';
import 'package:chat_365/core/constants/app_constants.dart';
import 'package:chat_365/core/constants/string_constants.dart';
import 'package:chat_365/modules/chat/blocs/chat_detail_bloc/chat_detail_bloc.dart';
import 'package:chat_365/router/app_router_helper.dart';
import 'package:chat_365/utils/data/extensions/context_extension.dart';
import 'package:chat_365/utils/helpers/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserListTileAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const UserListTileAppBar({
    Key? key,
    this.elevation = 0.0,
    this.actions,
    required this.userInfoBloc,
    this.isGroup = false,
    this.chatDetailBloc,
    this.centerTitle = false,
    this.bottom,
    this.countConversationMember,
    this.height = 56,
  }) : super(key: key);

  final double elevation;
  final List<Widget>? actions;
  final UserInfoBloc userInfoBloc;
  final ChatDetailBloc? chatDetailBloc;
  final bool isGroup;
  final bool centerTitle;
  final PreferredSizeWidget? bottom;
  final double height;

  /// Hiển thị số lượng thành viên nhóm
  final ValueNotifier<int>? countConversationMember;

  @override
  Widget build(BuildContext context) {
    final userInfoRepo = context.read<UserInfoRepo>();
    final bottomDataTextStyle = context.theme.userStatusTextStyle;
    DateTime lastTimeFetchData = AppConst.defaultFirstTimeFetchSuccess;
    return BlocListener<NetworkCubit, NetworkState>(
      listener: (context, networkState) {
        try {
          if (networkState.hasInternet &&
              DateTime.now().difference(lastTimeFetchData).inMinutes >= 5) {
            userInfoRepo.getChatInfo(
              userInfoBloc.userInfo.id,
              isGroup,
            );
            lastTimeFetchData = DateTime.now();
          }
        } catch (e, s) {
          logger.logError(e, s);
        }
      },
      child: BlocProvider(
        create: (context) => UserInfoBloc(userInfoBloc.state.userInfo),
        child: AppBar(
          elevation: elevation,
          actions: [
            if (actions != null) ...actions!,
            const SizedBox(width: 15),
          ],
          leadingWidth: 40,
          titleSpacing: 15,
          centerTitle: centerTitle,
          title: centerTitle
              ? BlocBuilder<UserInfoBloc, UserInfoState>(
                  builder: (context, state) => DisplayImageWithStatusBadge(
                    isGroup: isGroup,
                    model: state.userInfo,
                    userStatus: state.userInfo.userStatus,
                    tapCallBack: () => AppRouterHelper.toProfilePage(
                      context,
                      userInfo: state.userInfo,
                      isGroup: isGroup,
                      bloc: chatDetailBloc,
                      conversationId: chatDetailBloc?.conversationId,
                      self: context.userInfo().id == state.userInfo.id,
                    ),
                  ),
                )
              : BlocBuilder<UserInfoBloc, UserInfoState>(
                  builder: (context, state) {
                  var userInfo = state.userInfo;
                  var bottomData;
                  if (isGroup)
                    bottomData = ValueListenableBuilder<int>(
                      key: ValueKey('count-group-members'),
                      valueListenable: countConversationMember!,
                      builder: (context, count, _) {
                        return Text(
                          '$count thành viên',
                          style: bottomDataTextStyle,
                        );
                      },
                    );
                  else if (state.userInfo.id == context.userInfo().id ||
                      state.userInfo.lastActive == null) {
                    bottomData = Text(
                      userInfo.status ?? userInfo.userStatus.toString(),
                      style: bottomDataTextStyle,
                    );
                  } else {
                    bottomData = TimeBadge(
                      key: ValueKey('diff-online'),
                      lastOnlineTime: userInfo.lastActive,
                      isShowJustOnline: true,
                      builder: (str) => Text(
                        str != StringConst.recentAccess
                            ? '${StringConst.access} $str trước'
                            : str,
                        key: ValueKey(str),
                        style: bottomDataTextStyle,
                      ),
                    );
                    // final Timer timer = Timer.periodic(
                    //     const Duration(
                    //       minutes: 1,
                    //     ),
                    //     (tick) {});
                  }
                  return GestureDetector(
                    onTap: () => context.userInfo().id ==
                            userInfoBloc.userInfo.id
                        ? null
                        : AppRouterHelper.toProfilePage(
                            context,
                            userInfo: state.userInfo,
                            isGroup: isGroup,
                            self: state.userInfo.id == context.userInfo().id,
                            bloc: chatDetailBloc,
                          ),
                    child: UserListTile(
                      userName: userInfo.name,
                      avatar: isGroup
                          ? DisplayAvatar(
                              model: userInfo,
                              isGroup: isGroup,
                              enable: false,
                            )
                          : DisplayImageWithStatusBadge(
                              model: userInfo,
                              isGroup: false,
                              userStatus: userInfo.userStatus,
                              enable: false,
                            ),
                      bottom: Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: bottomData,
                      ),
                    ),
                  );
                }),
          bottom: bottom,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
      height + (bottom != null ? bottom!.preferredSize.height : 0.0));
}
