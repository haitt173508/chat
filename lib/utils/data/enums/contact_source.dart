enum ContactSource {
  company,
  phone,
  friendRequest,
}

extension ContactSourceExt on ContactSource {
  String get source {
    switch (this) {
      case ContactSource.company:
        return '';
      case ContactSource.phone:
        return 'Tìm kiếm số điện thoại';
      case ContactSource.friendRequest:
        return 'Yêu cầu kết bạn';
    }
  }
}
