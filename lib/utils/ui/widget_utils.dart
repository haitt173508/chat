import 'package:chat_365/core/error_handling/app_error_state.dart';
import 'package:chat_365/utils/data/extensions/context_extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:system_shortcuts/system_shortcuts.dart' as system_shortcuts;

import '../../core/theme/app_colors.dart';
import 'app_dialogs.dart';
import 'app_padding.dart';

class WidgetUtils {
  static CupertinoActivityIndicator loadingCircle(BuildContext context) => CupertinoActivityIndicator(
        color: context.theme.primaryColor,
        radius: 30 / 2,
      );

  static const Center centerLoadingCircle = Center(
    child: CircularProgressIndicator(),
  );

  static Padding sectionLoading(BuildContext context) => Padding(
        padding: AppPadding.paddingAll20,
        child: Center(
          child: loadingCircle(context),
        ),
      );

  // static const SizedBox screenBodyLoading = SizedBox.expand(
  //   child: Center(
  //     child: loadingCircle,
  //   ),
  // );

  static Widget getAvatarFromName(String name) => Container(
        height: 36,
        width: 36,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.primary,
          shape: BoxShape.circle,
        ),
        child: Text(
          name[0],
          style: TextStyle(
            fontSize: 20,
            color: AppColors.white,
          ),
        ),
      );

  static Row getFormFieldPrefixIconPainter(CustomPaint icon) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(width: 18),
          icon,
        ],
      );

  static Row getFormFieldPrefixIconWidgets(IconData icon) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(width: 18),
          Icon(icon),
        ],
      );

  static Row getFormFieldPrefixIcon(BuildContext context, String assetPath) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(width: 18),
          SvgPicture.asset(
            assetPath,
            color: Theme.of(context).iconTheme.color,
          ),
        ],
      );

  static Row getFormFieldColorPrefixIcon(String assetPath, {Color? color, double? size}) => Row(
        mainAxisSize: MainAxisSize.min,
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(width: 18),
          SvgPicture.asset(
            assetPath,
            color: color,
            width: size,
          ),
        ],
      );

  static Row getFormFieldColorSuffixIcon(String assetPath, {Color? color}) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            assetPath,
            color: color,
          ),
          const SizedBox(width: 18),
        ],
      );

  static WillPopScope getWillPopScope(BuildContext context, Widget child) => WillPopScope(
        onWillPop: () async => await AppDialogs.toast('Ấn lần nữa để thoát').then<bool>((value) async {
          if (value == true) await system_shortcuts.home();
          // if (value == true) return true;

          return false;
        }),
        child: child,
      );

  static Widget getErrorSection(AppErrorState e) => Center(
        child: Text(e.friendlyMessage),
      );

  static List<Widget> uniformWidth(List<Widget> list) => list.map((e) => e is SizedBox ? e : Expanded(flex: 1, child: e)).toList();

  static List<Widget> addSizedBoxAsSeparator(SizedBox sizedBox, List<Widget> widgets) =>
      widgets.length == 0 ? widgets : widgets.expand((element) => [element, sizedBox]).toList()
        ..removeLast();
}

extension SizedBoxExt on SizedBox {
  static const shrink = SizedBox.shrink();

  static const h5 = SizedBox(height: 5);
  static const h8 = SizedBox(height: 8);
  static const h3 = SizedBox(height: 3);
  static const w5 = SizedBox(width: 5);
  static const w8 = SizedBox(width: 8);

  static const h10 = SizedBox(height: 10);
  static const h96 = SizedBox(height: 96.3);
  static const sh10 = SliverToBoxAdapter(child: SizedBox(height: 10));
  static const w10 = SizedBox(width: 10);

  static const h12 = SizedBox(height: 12);

  static const w16 = SizedBox(width: 16);

  static const h15 = SizedBox(height: 15);
  static const h16 = SizedBox(height: 16);
  static const w15 = SizedBox(width: 15);

  static const h18 = SizedBox(height: 18);

  static const h20 = SizedBox(height: 20);
  static const h22 = SizedBox(height: 22);
  static const h28 = SizedBox(height: 28);
  static const sh20 = SliverToBoxAdapter(child: SizedBox(height: 20));
  static const w20 = SizedBox(width: 20);
    static const w24 = SizedBox(width: 24);

  static const h30 = SizedBox(height: 30);
  static const h40 = SizedBox(height: 40);
  static const w40 = SizedBox(width: 40);
  static const h50 = SizedBox(height: 50);
  static const h55 = SizedBox(height: 55);
  static const h60 = SizedBox(height: 60);
  static const h70 = SizedBox(height: 70);
  static const h89 = SizedBox(height: 89);

  static const sliverH16 = SliverToBoxAdapter(child: SizedBox(height: 16));
}
