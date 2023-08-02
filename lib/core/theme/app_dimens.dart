import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppDimens {
  // Space
  static const space2 = 2.0;
  static const space4 = 4.0;
  static const space5 = 5.0;
  static const space6 = 6.0;
  static const space8 = 8.0;
  static const space10 = 10.0;
  static const space11 = 10.0;
  static const space12 = 12.0;
  static const space13 = 12.0;
  static const space14 = 14.0;
  static const space15 = 15.0;
  static const space16 = 16.0;
  static const space17 = 16.0;
  static const space18 = 18.0;
  static const space19 = 19.0;
  static const space20 = 20.0;
  static const space22 = 22.0;
  static const space24 = 24.0;
  static const space25 = 25.0;
  static const space28 = 28.0;
  static const space30 = 30.0;
  static const space32 = 32.0;
  static const space36 = 36.0;
  static const space40 = 40.0;
  static const space46 = 46.0;
  static const space48 = 48.0;
  static const space50 = 50.0;
  static const space58 = 58.0;
  static const space80 = 80.0;
  static const space90 = 90.0;
  static const space100 = 100.0;

  // Text space30
  static const textSize10 = 10.0;
  static const textSize12 = 12.0;
  static const textSize13 = 13.0;
  static const textSize14 = 14.0;
  static const textSize15 = 15.0;
  static const textSize16 = 16.0;
  static const textSize18 = 18.0;
  static const textSize20 = 20.0;
  static const textSize22 = 22.0;
  static const textSize24 = 24.0;
  static const textSize28 = 28.0;
  static const textSize30 = 30.0;

  // Line height
  static const lineHeightXSmall = 16.0;
  static const lineHeightSmall = 20.0;
  static const lineHeightMedium = 24.0;
  static const lineHeightXLarge = 28.0;
  static const lineHeightLarge = 32.0;

  // Buttom size
  static const buttonSizeXSmall = 24.0;
  static const buttonSizeCompact = 32.0;
  static const buttonSizeSmall = 42.0;
  static const buttonSizeNormal = 48.0;
  static const buttonSizeMeium = 54.0;

  // Stepper size
  static const stepperSizeSmall = 24.0;
  static const stepperSizeMedium = 32.0;
  static const stepperSizeLarge = 40.0;

  static const radiusXSmall = 6.0;
  static const radiusSmall = 8.0;
  static const radiusMedium = 10.0;
  static const radiusLarge = 15.0;

  // Height Components
  static const heightTextField = 28.0;
  static const heightTextView = 86.0;
  static const heightIconSize = 22.0;
  static const heightIconSmall = 16.0;
  static const heightLogoItem = 54.0;
  static const minHeightDialog = 220.0;
  static const minHeightContainerDialog = 150.0;

  static const double padding = 16.0;
  static const double padding4 = 4.0;
  static const double padding5 = 5.0;
  static const double padding8 = 8.0;
  static const double padding12 = 12.0;
  static const double padding14 = 14.0;
  static const double padding16 = 16.0;
  static const double padding18 = 18.0;
  static const double padding20 = 20.0;
  static const double padding30 = 30.0;
  static const double padding60 = 60.0;
  static const double smallPadding10 = 10.0;

  //bottom navigation bar
  static const bottomNavIcSize = 32.0;
  static const bottomNavIcSize2 = 40.0;
  static const bottomNavLabelSize = 12.0;

  //Curved Border
  static const curvedLargeBorderRadius = 15.0;
  static const curvedSmallBorderRadius = 5.0;

  static const paddingALl20 = EdgeInsets.all(20);
  static const paddingALl16 = EdgeInsets.all(16);
  static const paddingALl15 = EdgeInsets.all(15);
  static const paddingALl24 = EdgeInsets.all(24);
  static const paddingHorizontal16 = EdgeInsets.symmetric(horizontal: 16);
  static const paddingHorizontal10 = EdgeInsets.symmetric(horizontal: 10);
  static const paddingHorizontal20 = EdgeInsets.symmetric(horizontal: 20);
  static const paddingVertical16 = EdgeInsets.symmetric(vertical: 16);
  static const paddingVertical15 = EdgeInsets.symmetric(vertical: 15);
  static const paddingVertical10 = EdgeInsets.symmetric(vertical: 10);
  static const paddingHorizontal8 = EdgeInsets.symmetric(horizontal: 8);
  static const formFieldContentPadding = const EdgeInsets.symmetric(
    horizontal: 20,
    vertical: 10,
  );
  static const paddingButton =
      EdgeInsets.symmetric(horizontal: 10, vertical: 10);

  static final defaultShadow = [
    BoxShadow(
      offset: Offset(-4, -1),
      blurRadius: 8,
      spreadRadius: 1,
      color: AppColors.black.withOpacity(0.25),
    ),
  ];
  static final shadow = [
    BoxShadow(
      color: AppColors.black.withOpacity(0.25),
      offset: Offset(0, 4),
      blurRadius: 4,
      spreadRadius: 0,
    ),
  ];
  static final shadow_1 = [
    BoxShadow(
      color: AppColors.black.withOpacity(0.05),
      offset: Offset(1, 3),
      blurRadius: 10,
      spreadRadius: 0,
    ),
  ];
}
