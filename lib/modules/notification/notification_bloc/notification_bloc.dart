import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chat_365/core/error_handling/exceptions.dart';
import 'package:chat_365/modules/notification/model/result_notification_model.dart';
import 'package:chat_365/modules/notification/model/result_notify_model.dart';
import 'package:chat_365/modules/notification/repo/notification_repo.dart';
import 'package:chat_365/utils/data/models/exception_error.dart';
import 'package:equatable/equatable.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  NotificationBloc(this.notificationRepo)
      : super(NotificationStateGetListNotification()) {
    on<NotificationEventGetListNotification>(_onGetListNotification);
  }

  final NotificationRepo notificationRepo;

  List<NotificationModel> notifications = [];
  List<ListNotification> notificationsNew = [];
  List<Participant> participant = [];

  FutureOr<void> _onGetListNotification(event, emit) async {
    emit(NotificationStateGetListNotifsLoading());

    var res = await notificationRepo.getListNotification();

    try {
      res.onCallBack((_) {
        var list = resultNotifyModelFromJson(res.data).data?.listNotification;
        notificationsNew.addAll(list!);
        emit(NotificationStateGetListNotificationSuccess());
        // print('122222: ${notificationsNew.length}');
      });
    } on CustomException catch (e) {
      emit(NotificationStateGetListNotificationError(e.error));
    }
  }

  Future onRefresh() async {
    add(NotificationEventGetListNotification());
  }
}
