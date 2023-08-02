part of 'notification_bloc.dart';

abstract class NotificationState {
  NotificationState();
}

class NotificationStateGetListNotification extends NotificationState {}

class NotificationStateGetListNotifsLoading extends NotificationStateGetListNotification {
}

class NotificationStateGetListNotificationSuccess
    extends NotificationStateGetListNotification {}

class NotificationStateGetListNotificationError
    extends NotificationStateGetListNotification {
  final ExceptionError error;

  NotificationStateGetListNotificationError(this.error);
}
