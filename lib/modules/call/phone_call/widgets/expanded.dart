import 'package:chat_365/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class ExpandedSection extends StatefulWidget {
  final Widget child;
  final bool expand;
  final double width;
  ExpandedSection(
      {Key? key,
      this.expand = false,
      required this.child,
      required this.width});

  @override
  _ExpandedSectionState createState() => _ExpandedSectionState();
}

class _ExpandedSectionState extends State<ExpandedSection>
    with SingleTickerProviderStateMixin {
  AnimationController? expandController;
  Animation<double>? animation;

  @override
  void initState() {
    super.initState();
    prepareAnimations();
  }

  ///Setting up the animation
  void prepareAnimations() {
    expandController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    Animation<double> curve = CurvedAnimation(
      parent: expandController!,
      curve: Curves.fastOutSlowIn,
    );
    animation = Tween(begin: 0.0, end: 1.0).animate(curve)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  void didUpdateWidget(ExpandedSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.expand) {
      expandController!.forward();
    } else {
      expandController!.reverse();
    }
  }

  @override
  void dispose() {
    expandController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (() {
        setState(() {});
      }),
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: AppColors.black.withOpacity(0.4),
        child: SizeTransition(
            axisAlignment: 0.0,
            sizeFactor: animation!,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: AppColors.white.withOpacity(0.86),
              ),
              child: widget.child,
            )),
      ),
    );
  }
}
