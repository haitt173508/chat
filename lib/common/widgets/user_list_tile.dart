import 'package:chat_365/utils/data/extensions/context_extension.dart';
import 'package:flutter/material.dart';

class UserListTile extends StatefulWidget {
  const UserListTile({
    Key? key,
    required this.avatar,
    required this.userName,
    this.bottom,
    this.onTapUserName,
  }) : super(key: key);

  final Widget avatar;
  final String userName;
  final Widget? bottom;
  final VoidCallback? onTapUserName;

  @override
  State<UserListTile> createState() => _UserListTileState();
}

class _UserListTileState extends State<UserListTile> {
  late Widget _avatar;
  late String _userName;

  @override
  void initState() {
    super.initState();
    _avatar = widget.avatar;
    _userName = widget.userName;
  }

  @override
  void didUpdateWidget(covariant UserListTile oldWidget) {
    if (_avatar != widget.avatar || _userName != widget.userName) {
      _avatar = widget.avatar;
      _userName = widget.userName;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _avatar,
        const SizedBox(width: 8),
        Flexible(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: widget.onTapUserName,
                child: Text(
                  _userName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.theme.userListTileTextTheme,
                ),
              ),
              if (widget.bottom != null) widget.bottom!,
            ],
          ),
        ),
      ],
    );
  }
}
