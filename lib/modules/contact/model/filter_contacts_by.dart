import 'package:chat_365/core/constants/string_constants.dart';

enum FilterContactsBy {
  myContacts,
  allInCompany,
  conversations,
  none,
}

extension FilterContactsByExt on FilterContactsBy {
  String get displayName {
    switch (this) {
      case FilterContactsBy.myContacts:
        return 'Các liên hệ của tôi';
      case FilterContactsBy.allInCompany:
        return 'Liên hệ trong công ty';
      case FilterContactsBy.conversations:
        return 'Trò chuyện';
      case FilterContactsBy.none:
        return 'Gợi ý';
    }
  }

  String get searchContactHeaderDisplayName {
    switch (this) {
      case FilterContactsBy.myContacts:
        return StringConst.peoples;
      case FilterContactsBy.allInCompany:
        return StringConst.company;
      case FilterContactsBy.conversations:
        return StringConst.group;
      case FilterContactsBy.none:
        return StringConst.all;
    }
  }
}
