class AutoDeleteTime {
  final int id;
  final String name;
  final int inSeconds;

  const AutoDeleteTime(
    this.id,
    this.name,
    this.inSeconds,
  );

  static const never = AutoDeleteTime(
    0,
    'Không bao giờ',
    0,
  );
  static const one_day = AutoDeleteTime(
    1,
    '1 Ngày',
    86400,
  );
  static const seven_day = AutoDeleteTime(
    2,
    '7 Ngày',
    604800,
  );
  static const thirty_day = AutoDeleteTime(
    3,
    '30 Ngày',
    2592000,
  );

  static const values = [
    never,
    one_day,
    seven_day,
    thirty_day,
  ];

  @override
  String toString() => name;
}
