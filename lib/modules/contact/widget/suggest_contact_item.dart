import 'package:chat_365/common/blocs/friend_cubit/cubit/friend_cubit.dart';
import 'package:chat_365/common/components/display/display_avatar.dart';
import 'package:chat_365/common/widgets/button/gradient_button.dart';
import 'package:chat_365/common/widgets/user_list_tile.dart';
import 'package:chat_365/core/constants/string_constants.dart';
import 'package:chat_365/core/interfaces/interface_user_info.dart';
import 'package:chat_365/core/theme/app_colors.dart';
import 'package:chat_365/core/theme/app_text_style.dart';
import 'package:chat_365/modules/chat/blocs/chat_bloc/chat_bloc.dart';
import 'package:chat_365/modules/contact/model/api_contact.dart';
import 'package:chat_365/utils/data/enums/contact_source.dart';
import 'package:chat_365/utils/data/enums/friend_status.dart';
import 'package:chat_365/utils/data/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// [style1]:
/// - Dùng gradient
/// - Người đang chờ kết bạn: nút "Nhắn tin"
///
/// [style2]:
/// - Không dùng gradient
/// - Đã là bạn bè hoặc đang chờ người kia đồng ý: nút "Hủy kết bạn"
class SuggestContactItem extends StatelessWidget {
  const SuggestContactItem({
    Key? key,
    required this.contact,
    this.style2 = false,
    this.trailing,
    this.subtitle,
    this.bottom,
  }) : super(key: key);

  final ApiContact contact;
  final bool style2;
  final Widget? trailing;
  final Widget? subtitle;
  final Widget? bottom;

  @override
  Widget build(BuildContext context) {
    final FriendCubit friendCubit = context.read<FriendCubit>();
    final Color? color =
        style2 ? context.theme.primaryColor.withOpacity(0.3) : null;
    var button = BlocBuilder<FriendCubit, FriendState>(
      buildWhen: (prev, current) =>
          current is FriendStateLoadSuccess ||
          (current is FriendStateResponseAddFriendSuccess &&
              current.requestId == contact.id) ||
          (current is FriendStateStatusChanged &&
              current.contactId == contact.id) ||
          (current is FriendStateAddFriendSuccess &&
              current.chatId == contact.id) ||
          (current is FriendStateDeleteContact &&
              [current.chatId, current.userId].contains(contact.id)),
      builder: (context, state) {
        bool isFriend = false;
        bool isWaittingOtherResponse = false;
        if (friendCubit.listFriends?.map((e) => e.id).contains(contact.id) ??
            false) isFriend = true;

        SuggestContactStatus buttonStatus;

        if (isFriend)
          buttonStatus = SuggestContactStatus.friend;
        else if (state is FriendStateDeleteContact) {
          isFriend = false;
          buttonStatus = SuggestContactStatus.unknown;
        } else if (friendCubit.friendsRequest?[contact.id]?.status ==
            FriendStatus.send) {
          buttonStatus = SuggestContactStatus.waittingOtherResponse;
          isWaittingOtherResponse = true;
        } else if ((contact.contactSource == ContactSource.friendRequest &&
                friendCubit.friendsRequest?[contact.id]?.status ==
                    FriendStatus.decline) ||
            contact.contactSource != ContactSource.friendRequest) {
          buttonStatus = SuggestContactStatus.unknown;
        } else {
          buttonStatus = SuggestContactStatus.otherSendRequest;
        }

        return GradientButton(
          onPressed: () {
            if (buttonStatus == SuggestContactStatus.otherSendRequest) {
              friendCubit.responseAddFriend(
                context.userInfo().id,
                contact,
                FriendStatus.accept,
              );
              return;
            }

            if (buttonStatus == SuggestContactStatus.friend) {
              // _toChatWithContact(context);
              if (style2) {
                friendCubit.deleteContact(contact.id);
                return;
              } else
                return null;
            }

            if (buttonStatus == SuggestContactStatus.waittingOtherResponse) {
              if (style2) {
                friendCubit.deleteRequestAddFriend(
                  context.userInfo().id,
                  contact.id,
                );
                return;
              }
              _toChatWithContact(context);
              return;
            }

            if (buttonStatus == SuggestContactStatus.unknown) {
              friendCubit.addFriend(contact);
              context.read<ChatBloc>().tryToChatScreen(
                    chatInfo: contact,
                    isNeedToFetchChatInfo: true,
                  );
            }
          },
          gradientColor: isFriend || style2 ? null : context.theme.gradient,
          color: color != null && isWaittingOtherResponse ? null : color,
          border: isWaittingOtherResponse && style2
              ? Border.all(
                  color: context.theme.primaryColor,
                )
              : null,
          child: Text(
            style2 && buttonStatus.canCancel
                ? buttonStatus == SuggestContactStatus.friend
                    ? StringConst.cancelFriend
                    : StringConst.cancelAddFriend
                : buttonStatus.name,
            style: AppTextStyles.regularW500(
              context,
              size: 14,
              lineHeight: 16,
              color: isFriend
                  ? style2
                      ? context.theme.primaryColor
                      : null
                  : style2
                      ? context.theme.primaryColor
                      : AppColors.white,
            ),
          ),
        );
      },
    );
    return SuggestContactItemLayout(
      userInfo: contact,
      button: button,
      subtitle: subtitle,
      bottom: bottom,
      trailing: trailing,
      // children: [
      //   const SizedBox(height: 10),
      //   Row(
      //     children: [
      //       Expanded(
      //         child: UserListTile(
      //           avatar: DisplayAvatar(
      //             isGroup: false,
      //             model: contact,
      //             size: 50,
      //           ),
      //           userName: contact.name,
      //           bottom: subtitle,
      //         ),
      //       ),
      //       button,
      //       if (trailing != null) trailing!,
      //     ],
      //   ),
      //   if (bottom != null) bottom!,
      // ],
    );
  }

  void _toChatWithContact(BuildContext context) {
    context.read<ChatBloc>().tryToChatScreen(
          chatInfo: contact,
          isGroup: false,
          isNeedToFetchChatInfo: true,
        );
  }
}

enum SuggestContactStatus {
  /// Đã là bạn bè
  friend,

  /// Chờ currentUser đồng ý
  otherSendRequest,

  /// currentUser đã gửi lời mời kết bạn
  waittingOtherResponse,

  /// Khác
  unknown
}

extension SuggestContactStatusExt on SuggestContactStatus {
  String get name {
    switch (this) {
      case SuggestContactStatus.otherSendRequest:
        return StringConst.agree;
      case SuggestContactStatus.friend:
        return StringConst.hasBeenFriend;
      case SuggestContactStatus.unknown:
        return StringConst.addFriend;
      case SuggestContactStatus.waittingOtherResponse:
        return StringConst.chat;
    }
  }

  bool get canCancel =>
      this == SuggestContactStatus.friend ||
      this == SuggestContactStatus.waittingOtherResponse;
}

class SuggestContactItemLayout extends StatelessWidget {
  const SuggestContactItemLayout({
    Key? key,
    required this.userInfo,
    required this.button,
    this.subtitle,
    this.trailing,
    this.bottom,
  }) : super(key: key);

  final IUserInfo userInfo;
  final Widget? subtitle;
  final Widget button;
  final Widget? trailing;
  final Widget? bottom;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: UserListTile(
                avatar: DisplayAvatar(
                  isGroup: false,
                  model: userInfo,
                  size: 50,
                ),
                userName: userInfo.name,
                bottom: subtitle,
              ),
            ),
            DefaultTextStyle(
              style: AppTextStyles.regularW500(
                context,
                size: 14,
                lineHeight: 16,
              ),
              child: button,
            ),
            if (trailing != null) trailing!,
          ],
        ),
        if (bottom != null) bottom!,
      ],
    );
  }
}
