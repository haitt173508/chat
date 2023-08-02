import 'package:sp_util/sp_util.dart';

const _numberOfConversationsKey = 'number_of_conversation';

class LocalChatListService {
  /// If [LocalChatListService] did not
  /// store [numberOfConversations], the default value is [-1]
  static int get numberOfConversations =>
      SpUtil.getInt(_numberOfConversationsKey, defValue: 20)!;

  static void saveNumberOfConversations(int value) =>
      SpUtil.putInt(_numberOfConversationsKey, value);
}
