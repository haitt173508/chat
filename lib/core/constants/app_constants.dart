import 'package:chat_365/utils/data/enums/emoji.dart';
import 'package:chat_365/utils/data/enums/message_text_size.dart';

class AppConst {
  static const String appName = 'Chat 365';

  static const String fontNunito = 'Nunito';

  static const String datePattern = 'd/M/y';
  static const String apiDatePattern = 'y-M-d';

  static const String timePattern = 'HH:mm';

  static const String hotline1 = '1900633682 - phím 1';
  static const String hotline2 = '0982.079.209';

  static const String supportSkype = 'skype:live:binhminhmta123?chat';

  static const int refecthApiThreshold = 3;

  static const Duration timesToFetchCommonDataAgain = Duration(days: 7);

  static const int limitOfListDataLengthForEachRequest = 20;

  static const int timeToAbleToSendOtpAgain = 60;

  static const int inputDebounceTimeInMilliseconds = 440;

  static const int nextPageThreshold = 3;

  static const int maxNumberOfMessagesFromRecruiterIfTheyActivelySendMessage =
      3;

  static const double kEmotionWithTextWidth = kEmotionSize + 12;

  static const double kEmotionSize = 30;

  static const double kEmotionPadding = 2;

  static const double kLikeButtonSize = 33;

  static const double kLikeIconSize = 22;

  static const double kBottomNavigationBarItemIconSize = 20;

  static final int count = AppConst.kEmotionCount;

  static late double maxMessageBoxWidth;

  static const double kDividerTextPadding = 40;

  static int kEmotionCount = Emoji.values.length;

  static double kCountDeleteRemainTimeWidgetMaxWidth = 80;

  static const double maxImageSizeInMb = 20;

  static const double maxFileSizeInMb = 300;

  static double kDefaultMessageFontSize = MessageTextSize.normal.fontSize;

  static DateTime defaultFirstTimeFetchSuccess = DateTime(2022, 10, 4);

  /// Số lượng tin nhắn lưu offline mỗi cuộc trò chuyện
  static const int countOfflineConversationMessages = 40;

  static const List<String> supportImageTypes = [
    'jpeg',
    'jpg',
    'png',
    'jfif',
    'gif',
  ];

  static const List<String> supportNonImageFileTypes = [
    'doc',
    'txt',
    'docx',
    'rar',
    'zip',
    'pptx',
    'pdf',
    'xls',
    'xlsx',
    'ppt',
    'gdoc',
    'gsheet',
    'json',
    'html',
    'apk',
    'gif',
    'exe',
    'svg',
    'mp3',
    'mp4',
    'avi',
    'ipa',
  ];

  static const List<String> supportAllFileTypes = [
    ...supportImageTypes,
    ...supportNonImageFileTypes,
  ];

  static const List<String> alphabet = [
    "a",
    "b",
    "c",
    "d",
    "e",
    "f",
    "g",
    "h",
    "i",
    "j",
    "k",
    "l",
    "m",
    "n",
    "o",
    "p",
    "q",
    "r",
    "s",
    "t",
    "u",
    "v",
    "w",
    "x",
    "y",
    "z"
  ];

  static const previewFileType = ['doc', 'docx', 'xls', 'xlsx'];

  static const String LIST_MESSAGE_UNREAD = "LIST_MESSAGE_UNREAD";
  static const String DEVICE_ID = "device_id";

  static const List<String> dayOfWeek = [
    'Thứ 2',
    'Thứ 3',
    'Thứ 4',
    'Thứ 5',
    'Thứ 6',
    'Thứ 7',
    'Chủ nhật',
  ];
}
