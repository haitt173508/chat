import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_365/common/blocs/user_info_bloc/bloc/user_info_bloc.dart';
import 'package:chat_365/common/blocs/user_info_bloc/bloc/user_info_state.dart';
import 'package:chat_365/core/interfaces/interface_user_info.dart';
import 'package:chat_365/core/theme/app_colors.dart';
import 'package:chat_365/core/theme/app_text_style.dart';
import 'package:chat_365/modules/auth/modules/login/models/result_login.dart';
import 'package:chat_365/modules/chat/blocs/chat_bloc/chat_bloc.dart';
import 'package:chat_365/utils/data/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DisplayContact extends StatelessWidget {
  const DisplayContact({
    Key? key,
    required this.contact,
    this.isSendByCurrentUser = true,
  }) : super(key: key);

  final IUserInfo contact;
  final bool isSendByCurrentUser;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserInfoBloc(
        UserInfo(
          id: contact.id,
          userName: contact.name,
          avatarUser: contact.avatar,
          active: contact.userStatus,
          // password: contact.password,
          // email: contact.email,
          // phone: contact.phone,
          // status: contact.status,
          // isOnline: contact.isOnline,
          // looker: contact.looker,
          // statusEmotion: contact.statusEmotion,
          // lastActive: contact.lastActive,
          // companyId: contact.companyId,
          // companyName: contact.companyName,
        ),
      ),
      child: Container(
        width: double.infinity.clamp(0, 200).toDouble(),
        decoration: BoxDecoration(
          color: isSendByCurrentUser ? null : context.theme.messageBoxColor,
          gradient: isSendByCurrentUser ? context.theme.gradient : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 30),
            BlocBuilder<UserInfoBloc, UserInfoState>(
              builder: (context, state) {
                return CircleAvatar(
                  backgroundImage: CachedNetworkImageProvider(
                    state.userInfo.avatar ?? '',
                  ),
                  radius: 30,
                );
              },
            ),
            const SizedBox(height: 15),
            BlocBuilder<UserInfoBloc, UserInfoState>(
              builder: (context, state) {
                return Text(
                  state.userInfo.name,
                  style: AppTextStyles.contactItem,
                );
              },
            ),
            Divider(
              color: AppColors.white,
              thickness: 2,
              endIndent: 10,
              indent: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20, top: 20 - 4),
              child: InkWell(
                onTap: () => context.read<ChatBloc>().tryToChatScreen(
                      chatInfo: contact,
                      isNeedToFetchChatInfo: true,
                    ),
                child: Text(
                  'Nhắn tin',
                  style: AppTextStyles.contactGroupName(context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
