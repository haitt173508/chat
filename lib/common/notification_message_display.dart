import 'dart:async';

import 'package:chat_365/common/blocs/user_info_bloc/bloc/user_info_bloc.dart';
import 'package:chat_365/core/theme/app_text_style.dart';
import 'package:chat_365/utils/data/extensions/string_extension.dart';
import 'package:flutter/material.dart';

class NotificationMessageDisplay extends StatefulWidget {
  const NotificationMessageDisplay({
    Key? key,
    this.listUserInfos,
    required String? message,
    required this.conversationId,
    this.onGetUnknownUserIdsFound,
    this.textBuilder,
  })  : this._message = message ?? '',
        super(key: key);

  final Map<int, UserInfoBloc>? listUserInfos;
  final String _message;
  final int conversationId;
  final ValueChanged<List<UserInfoBloc>>? onGetUnknownUserIdsFound;
  final Widget Function(BuildContext, String)? textBuilder;

  @override
  State<NotificationMessageDisplay> createState() =>
      _NotificationMessageDisplayState();
}

class _NotificationMessageDisplayState
    extends State<NotificationMessageDisplay> {
  late Map<int, UserInfoBloc> _userInfoBlocs;
  final List<ValueNotifier<String>> _userListeners = [];
  final List<StreamSubscription> _subscriptions = [];
  final List<UserInfoBloc> _unknownUserInfoBlocs = [];

  @override
  void initState() {
    super.initState();
    _userInfoBlocs = widget.listUserInfos ?? {};

    Set<int> userIdsInMessage = widget._message.getListIntFromThis().toSet();

    Map<int, UserInfoBloc> users = {};

    for (var userId in userIdsInMessage) {
      if (_userInfoBlocs[userId] != null) {
        users[userId] = _userInfoBlocs[userId]!;
      } else {
        var unknowUserInfoBloc = UserInfoBloc.unknown(userId);
        _unknownUserInfoBlocs.add(unknowUserInfoBloc);
        users[userId] = unknowUserInfoBloc;
      }

      var valueNotifier = ValueNotifier(users[userId]!.state.userInfo.name);
      _subscriptions.add(users[userId]!.stream.listen((state) {
        valueNotifier.value = state.userInfo.name;
      }));
      _userListeners.add(valueNotifier);
    }

    if (_unknownUserInfoBlocs.isNotEmpty)
      widget.onGetUnknownUserIdsFound?.call(_unknownUserInfoBlocs);

    // _setMessage(users);

    // Set<int> conversationUserIds = users.keys.toSet();

    // if (!conversationUserIds.containsAll(userIdsInMessage)) {
    //   var missingIds = userIdsInMessage.difference(conversationUserIds);
    //   Future.wait(missingIds.map((e) => _chatRepo.getUserInfo(e)))
    //       .then((value) {
    //     ChatDetailBloc? chatDetailBloc;
    //     try {
    //       chatDetailBloc = context.read<ChatDetailBloc>();
    //     } catch (e) {
    //       logger.logError('Not found ChatDetailBloc');
    //     }
    //     value.removeWhere((e) => e == null);
    //     value.forEach((e) {
    //       var userInfoBloc =
    //           UserInfoBloc(e!, userInfoRepo: context.read<UserInfoRepo>());
    //       users[e.id] = userInfoBloc;
    //       chatDetailBloc?.tempListUserInfoBlocs
    //           .putIfAbsent(e.id, () => userInfoBloc);
    //     });
    //     if (mounted)
    //       setState(() {
    //         _setMessage(users);
    //       });
    //   });
    // }
  }

  // _setMessage(Map<int, UserInfoBloc> users) {
  //   message = StringExt.getDisplayMessageFromApiMessage(
  //     widget._message,
  //     users.values.map((e) => e.userInfo.name).toList(),
  //   );
  // }

  @override
  void dispose() {
    _userListeners.forEach((e) => e.dispose());
    _subscriptions.forEach((e) => e.cancel());
    _unknownUserInfoBlocs.forEach((e) => e.close());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // if (widget.listUserInfos == null)
    //   return Text(
    //     widget._message,
    //     style: AppTextStyles.textMessageDisplayStyle(context),
    //   );

    return AnimatedBuilder(
        animation: Listenable.merge(_userListeners),
        builder: (context, _) {
          var text = StringExt.getDisplayMessageFromApiMessage(
            widget._message,
            _userListeners.map((e) => e.value).toList(),
          );
          if (widget.textBuilder != null)
            return widget.textBuilder!(context, text);
          return Text(
            text,
            textAlign: TextAlign.center,
            style: AppTextStyles.textMessageDisplayStyle(context),
          );
        });
  }
}
