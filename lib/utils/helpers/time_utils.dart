// import 'package:chat_365/core/constants/string_constants.dart';
// import 'package:chat_365/utils/data/extensions/date_time_extension.dart';
// import 'package:intl/intl.dart';

// const _epochTicks = 621355968000000000;

// late final _timeFormat = DateFormat('HH:mm');

// class TimeUtils {
//   static DateFormat serverDateFormat = DateFormat('MM/dd/yyyy HH:mm:ss.fff');

//   static int get currentTicks =>
//       DateTime.now().microsecondsSinceEpoch * 10 + _epochTicks + 251982339964;


//   static DateTime toUtc(DateTime dt) => DateTime.utc(
//         dt.year,
//         dt.month,
//         dt.day,
//         dt.hour,
//         dt.minute,
//         dt.second,
//         dt.millisecond,
//         dt.microsecond,
//       );

//   static String getGroupChatMessagesDateTimeRepresentation(DateTime dateTime) {
//     try {
//       final DateTime now = toUtc(DateTime.now());
//       final DateTime localDateTime = toUtc(dateTime);

//       final Duration difference = now.difference(localDateTime);

//       if (difference.inMinutes < 1) return 'Vừa xong';

//       // https://stackoverflow.com/a/62872997
//       final DateTime localDateTimeFirstDayOfWeek =
//           _findFirstDateOfTheWeek(localDateTime);
//       final DateTime firstDayOfWeek = _findFirstDateOfTheWeek(now);

//       final int differenceInDaysOfFirstDayOfWeek =
//           firstDayOfWeek.difference(localDateTimeFirstDayOfWeek).inDays;

//       final String roundTimeString = _timeFormat.format(dateTime);

//       if (differenceInDaysOfFirstDayOfWeek == 0) {
//         final int differenceInDays = difference.inDays;

//         if (differenceInDays == 0)
//           return roundTimeString;
//         else if (differenceInDays == 1)
//           return "Hôm qua, $roundTimeString";
//         else if (differenceInDays == 2)
//           return "Hôm kia, $roundTimeString";
//         else if (differenceInDays < 8) {
//           if (localDateTime.weekday == DateTime.sunday)
//             return "Chủ nhật, $roundTimeString";

//           return "${localDateTime.weekday.weekdayName}, $roundTimeString";
//         }
//       }

//       return "${DateFormat('yMd').format(localDateTime)}, $roundTimeString";
//     } catch (e) {
//       print("TimeUtils.getGroupChatMessagesDateTimeRepresentation: $e");
//       return StringConst.not_update;
//     }
//   }

//   static DateTime _findFirstDateOfTheWeek(DateTime dateTime) {
//     return dateTime.subtract(Duration(days: dateTime.weekday - 1));
//     // return dateTime
//     //     .subtract(Duration(days: dateTime.weekday))
//     //     .add(const Duration(days: 1));
//   }

//   static String getGroupMessagesDateTimeRepresentation(DateTime time) {
//     try {
//       final DateTime now = toUtc(DateTime.now());
//       final DateTime localDateTime = toUtc(time);

//       final Duration difference = now.difference(localDateTime);
//       if (difference.inMinutes < 1) return 'Vừa xong';

//       // https://stackoverflow.com/a/62872997
//       final DateTime localDateTimeFirstDayOfWeek =
//           _findFirstDateOfTheWeek(localDateTime);
//       final DateTime firstDayOfWeek = _findFirstDateOfTheWeek(now);

//       final int differenceInDaysOfFirstDayOfWeek =
//           firstDayOfWeek.difference(localDateTimeFirstDayOfWeek).inDays;

//       if (differenceInDaysOfFirstDayOfWeek < 8) {
//         final int differenceInDays = difference.inDays;
//         final bool isSameDay = now.day == localDateTime.day;
//         final int differenceInHours = difference.inHours;

//         print("$differenceInDays \ $differenceInHours");

//         if (isSameDay)
//           return 'Hôm nay';
//         // vì thời gian bị lệch nên phải cộng thêm 11
//         else if (differenceInDays <= 1 && differenceInHours <= 24 + 11)
//           return "Hôm qua";
//         else if (differenceInDays <= 2 && differenceInHours <= 48 + 11)
//           return "Hôm kia";
//         else if (differenceInDays < 8) {
//           return time.weekday.weekdayName;
//         }
//       }

//       return "${time.weekday.weekdayName}, ${time.day} Thg ${time.month}";
//     } catch (e) {
//       print("TimeUtils.getGroupMessagesDateTimeRepresentation: $e");
//       return StringConst.not_update;
//     }
//   }
// }

// extension DateTimeExt on DateTime {
//   DateTime get date => DateTime(year, month, day);
// }

// extension on int {
//   String get weekdayName {
//     switch (this) {
//       case 8:
//       case DateTime.sunday:
//         return 'Chủ nhật';
//       default:
//         if (this > 8) throw StateError('week day number > 8');

//         return "Thứ ${this + 1}";
//     }
//   }
// }
