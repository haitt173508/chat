import 'package:chat_365/common/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:math' as math;

class Flyingcart extends StatefulWidget {
  @override
  _FlyingcartState createState() => _FlyingcartState();
}

class _FlyingcartState extends State<Flyingcart> with TickerProviderStateMixin {
  AnimationController? _controller;
  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(duration: Duration(seconds: 1), vsync: this)
          ..forward();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Transform(
      //Wrap your widget with the Transform widget
      alignment: Alignment.center, //Default is left
      transform: Matrix4.rotationY(math.pi), //Mirror Widget

      child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        //code here
        final Size biggest = constraints.biggest;
        return Stack(
          children: [
            PositionedTransition(
                rect: RelativeRectTween(
                  begin:
                      //flying cart fly from bottom to top
                      RelativeRect.fromSize(
                          Rect.fromLTRB(biggest.width / 2, biggest.height - 20,
                              biggest.width / 2, biggest.height),
                          biggest),
                  end: RelativeRect.fromSize(
                      Rect.fromLTRB(biggest.width / 2, -20, biggest.width,
                          biggest.width / 2),
                      biggest),
                ).animate(
                  CurvedAnimation(
                    parent: _controller!,
                    curve: Curves.linear.flipped,
                  ),
                ),
                child: SvgPicture.asset(
                  Images.ic_heart,
                  width: 40,
                ))
          ],
        );
      }),
    );
  }
}

class SpringCurve extends Curve {
  const SpringCurve({
    this.a = 0.15,
    this.w = 19.4,
  });
  final double a;
  final double w;

  @override
  double transformInternal(double t) {
    return -(math.pow(math.e, -t / a) * math.cos(t * w)) + 1;
  }
}
