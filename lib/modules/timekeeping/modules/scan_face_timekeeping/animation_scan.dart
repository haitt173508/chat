import 'package:chat_365/core/theme/app_colors.dart';
import 'package:flutter/cupertino.dart';

class ImageScannerAnimation extends AnimatedWidget {
  // final bool stopped;
  final double width;

  ImageScannerAnimation(this.width,
      {Key? key, required Animation<double> animation})
      : super(
          key: key,
          listenable: animation,
        );

  Widget build(BuildContext context) {
    final Animation<double> animation = listenable as Animation<double>;
    final y = -16 * 4;
    final scorePosition = (animation.value * 300) + y;

    Color color1 = Color(0x59ffffff);
    Color color2 = Color(0x00ffffff);

    if (animation.status == AnimationStatus.reverse) {
      color1 = Color(0x00ffffff);
      color2 = Color(0x59ffffff);
    }

    return new Positioned(
        width: 300 - 32,
        bottom: scorePosition,
        // left:  16.0,
        // left: 30.0,
        // right: 16.0,
        // top: 16.0,
        child: new Opacity(
            opacity: 1.0,
            child: Container(
              // margin: EdgeInsets.all(16).copyWith(
              //   top: 16,
              // ),
              // padding: EdgeInsets.only(top: 50),
              // alignment: Alignment.center,
              height: 68,
              width: width,
              decoration: new BoxDecoration(
                  gradient: new LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.1, 0.9],
                colors: [color1, color2],
              )),
            )));
  }
}
