import 'package:chat_365/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

/// Dấu [...] hiển thị kiểu: "Ông nào đó đang nhập [...]"
class WavyThreeDot extends StatefulWidget {
  const WavyThreeDot({
    Key? key,
  }) : super(key: key);

  @override
  State<WavyThreeDot> createState() => _WavyThreeDotState();

  static double get width => 4.2 * 3 + 2.5 * 2;
}

class _WavyThreeDotState extends State<WavyThreeDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final List<Animation> _animations;
  late final Widget dot;

  @override
  void initState() {
    super.initState();
    dot = Container(
      height: 4.2,
      width: 4.2,
      decoration: BoxDecoration(
        color: AppColors.dustyGray,
        shape: BoxShape.circle,
      ),
    );
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _animations = List.generate(
        3,
        (index) => Tween<double>(begin: 0, end: 1).animate(
              CurvedAnimation(
                parent: _animationController,
                curve: Interval(index * 0.2, (index + 1) * 0.2),
              ),
            ));

    _animationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 18,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: _animations
            .asMap()
            .keys
            .map(
              (e) => AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(e * 2.5, -8 * (1.0 - _animations[e].value)),
                    child: child!,
                  );
                },
                child: dot,
              ),
            )
            .toList(),
      ),
    );
  }
}
