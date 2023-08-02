import 'package:chat_365/common/components/display/display_avatar.dart';
import 'package:chat_365/common/components/display_image_with_status_badge.dart';
import 'package:chat_365/common/widgets/user_list_tile.dart';
import 'package:chat_365/modules/chat_conversations/models/conversation_basic_info.dart';
import 'package:flutter/material.dart';

class ListContactView extends StatefulWidget {
  const ListContactView({
    Key? key,
    required this.itemBuilder,
    required this.userInfos,
    this.userBloc = false,
    this.padding = const EdgeInsets.symmetric(horizontal: 20),
    this.loadMore,
  }) : super(key: key);

  final Widget Function(BuildContext, int, Widget) itemBuilder;
  final Iterable<ConversationBasicInfo> userInfos;
  final bool userBloc;
  final EdgeInsets padding;
  final VoidCallback? loadMore;

  @override
  State<ListContactView> createState() => _ListContactViewState();
}

class _ListContactViewState extends State<ListContactView> {
  final ScrollController _scrollController = ScrollController();
  late Iterable<ConversationBasicInfo> _userInfos;

  @override
  void initState() {
    super.initState();
    _userInfos = [...widget.userInfos];
  }

  @override
  void didUpdateWidget(covariant ListContactView oldWidget) {
    // var set1 = widget.userInfos.map((e) => e.id).toSet();
    // var set2 = _userInfos.map((e) => e.id).toSet();
    // var maxSet;
    // var minSet;
    // if (set1.length > set2.length) {
    //   maxSet = set1;
    //   minSet = set2;
    // } else {
    //   maxSet = set2;
    //   minSet = set1;
    // }
    // if (maxSet.difference(minSet).isNotEmpty) {
    _userInfos = [...widget.userInfos];
    // }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      isAlwaysShown: true,
      radius: Radius.circular(15),
      controller: _scrollController,
      thickness: 8,
      child: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification is ScrollEndNotification) {
            if (_scrollController.position.extentAfter == 0) {
              widget.loadMore?.call();
            }
          }
          return false;
        },
        child: ListView.builder(
          itemCount: _userInfos.length,
          // separatorBuilder: (_, __) => DashedLinePainter.customPaint,
          padding: widget.padding,
          controller: _scrollController,
          addAutomaticKeepAlives: true,
          addRepaintBoundaries: true,
          itemBuilder: (context, index) {
            var userInfo = _userInfos.elementAt(index);
            return Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 12.0,
              ),
              child: widget.itemBuilder(
                context,
                index,
                UserListTile(
                  avatar: widget.userBloc
                      ? DisplayImageWithStatusBadge(
                          isGroup: userInfo.isGroup,
                          model: userInfo,
                          userStatus: userInfo.userStatus,
                          size: 40,
                          badgeSize: 12,
                        )
                      : DisplayAvatar(
                          isGroup: false,
                          model: userInfo,
                          size: 40,
                        ),
                  userName: userInfo.name,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
