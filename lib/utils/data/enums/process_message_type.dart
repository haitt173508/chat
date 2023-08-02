enum ProcessMessageType {
  sending,
  deleting,
}

extension ProcessMessageTypeExt on ProcessMessageType {
  String get processingName {
    if (this == ProcessMessageType.sending) return 'Đang gửi';
    return 'Đang xóa';
  }
}
