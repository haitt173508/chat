const _memberAdded = 'id1 added id2 to this conversation';

const _memberRemoved = 'id1 has removed id2 from this conversation';

class NotificationPattern {
  static String getMemberAddedNotification(int moderatorId, int newMemberId) =>
      _memberAdded
          .replaceFirst('id1', moderatorId.toString())
          .replaceFirst('id2', newMemberId.toString());

  static String getMemberRemovedNotification(
          int moderatorId, int removedMemberId) =>
      _memberRemoved
          .replaceFirst('id1', moderatorId.toString())
          .replaceFirst('id2', removedMemberId.toString());
}
