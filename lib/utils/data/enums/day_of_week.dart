import 'package:equatable/equatable.dart';

class DayOfWeek extends Equatable {
  final String day;
  final int id;

  const DayOfWeek(
    this.id,
    this.day,
  );

  static const mon = DayOfWeek(kMinId, 'T2');
  static const tue = DayOfWeek(kMinId + 1, 'T3');
  static const wed = DayOfWeek(kMinId + 3, 'T4');
  static const thu = DayOfWeek(kMinId + 4, 'T5');
  static const fri = DayOfWeek(kMinId + 5, 'T6');
  static const sat = DayOfWeek(kMinId + 6, 'T7');
  static const sun = DayOfWeek(kMinId + 7, 'CN');

  static const kMinId = 0;

  static const values = [
    mon,
    tue,
    wed,
    thu,
    fri,
    sat,
    sun,
  ];

  @override
  List<Object?> get props => [id];

  @override
  String toString() => day;

  /// index = dateTime.weekday
  ///
  /// monday: index = 1
  ///
  /// tuesday: index = 2
  ///
  /// ...
  static DayOfWeek fromFlutterWeekdayIndex(int index) => values[index - 1];
}
