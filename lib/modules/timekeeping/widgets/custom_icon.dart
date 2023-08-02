import 'dart:math';

import 'package:chat_365/common/images.dart';
import 'package:chat_365/core/theme/app_colors.dart';
import 'package:chat_365/core/theme/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomIcon extends StatefulWidget {
  const CustomIcon({
    Key? key,
    // required this.icon,
    // required this.title,
    // required this.detail,
    // required this.onTap,
    required this.onRefresh,
  }) : super(key: key);
  // final String icon;
  // final String title;
  // final String detail;
  // final VoidCallback onTap;
  final Future Function() onRefresh;

  @override
  State<CustomIcon> createState() => _CustomIconState();
}

class _CustomIconState extends State<CustomIcon> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: new Duration(milliseconds: 800),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () async {
          _controller.repeat();
          await widget.onRefresh();
          _controller.stop();
          _controller.reset();
        },
        icon: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.rotate(
              angle: -_controller.value * 2 * pi,
              child: child!,
            );
          },
          child: SvgPicture.asset(
            Images.ic_refresh,
            color: AppColors.white,
          ),
        ));
  }
}