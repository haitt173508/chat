import 'package:chat_365/common/components/display/display_avatar.dart';
import 'package:chat_365/common/components/display/time_badge.dart';
import 'package:chat_365/core/interfaces/interface_user_info.dart';
import 'package:chat_365/utils/data/enums/user_status.dart';
import 'package:flutter/material.dart';

class DisplayImageWithStatusBadge extends StatelessWidget {
  const DisplayImageWithStatusBadge({
    Key? key,
    required this.isGroup,
    required this.model,
    required this.userStatus,
    this.size,
    this.enable = true,
    this.badge,
    this.badgeSize,
    this.tapCallBack,
  }) : super(key: key);

  final bool isGroup;
  final IUserInfo model;
  final UserStatus userStatus;
  final double? size;
  final bool enable;
  final Widget? badge;
  final double? badgeSize;
  final VoidCallback? tapCallBack;

  @override
  Widget build(BuildContext context) {
    final double _badgeSize = badgeSize ?? (size != null ? size! / 3 - 10 : 12);
    return Stack(
      alignment: Alignment.bottomRight,
      clipBehavior: Clip.none,
      children: [
        DisplayAvatar(
          isGroup: isGroup,
          model: model,
          size: size ?? 36,
          enable: enable,
          enabledTapCallback: tapCallBack,
        ),
        if (badge != null)
          badge!
        else if (model.lastActive == null)
          userStatus.getStatusBadge(
            context,
            badgeSize: _badgeSize - 2,
          ),
      ],
    );
  }
}
