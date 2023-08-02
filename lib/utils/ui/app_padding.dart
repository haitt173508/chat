import 'package:flutter/cupertino.dart';

class AppPadding {
  static const double defaultAppBarHeight = 56;

  static const paddingAll4 = EdgeInsets.all(4);
  static const paddingAll8 = EdgeInsets.all(8);
  static const paddingAll10 = EdgeInsets.all(10);
  static const paddingAll15 = EdgeInsets.all(15);
  static const paddingAll16 = EdgeInsets.all(16);
  static const paddingAll20 = EdgeInsets.all(20);

  static const paddingHorizontal15 = EdgeInsets.symmetric(horizontal: 15);
  static const paddingHorizontal30 = EdgeInsets.symmetric(horizontal: 30);

  static const paddingVertical10 = EdgeInsets.symmetric(vertical: 10);
  static const paddingVertical8 = EdgeInsets.symmetric(vertical: 8);

  static const paddingVertical15 = EdgeInsets.symmetric(vertical: 15);
  static const paddingVertical18 = EdgeInsets.symmetric(vertical: 18);

  static const paddingVertical20 = EdgeInsets.symmetric(vertical: 20);
  static const paddingVertical30 = EdgeInsets.symmetric(vertical: 30);

  static const paddingHor20Vert5 =
      const EdgeInsets.symmetric(horizontal: 20, vertical: 5);
  static const paddingHor15Vert21 =
      const EdgeInsets.symmetric(horizontal: 15, vertical: 10);
  static const paddingHor20Vert10 =
      EdgeInsets.symmetric(horizontal: 20, vertical: 10);
  static const paddingHor15Vert10 =
      EdgeInsets.symmetric(horizontal: 15, vertical: 10);
  static const paddingHor12Vert5 =
      EdgeInsets.symmetric(horizontal: 12, vertical: 5);
  static const paddingHor15 =
      EdgeInsets.symmetric(horizontal: 15);
  static const messagePadding =
      EdgeInsets.only(top: 7, bottom: 7, right: 13, left: 13);

  static const scaffoldListViewPadding = EdgeInsets.only(
    top: 74, // 44 + 30
    right: 16,
    bottom: 16,
    left: 16,
  );

  static const formFieldContentPadding = const EdgeInsets.symmetric(
    horizontal: 10,
    vertical: 10,
  );
}
