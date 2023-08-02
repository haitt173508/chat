import 'package:chat_365/common/images.dart';
import 'package:chat_365/core/theme/app_text_style.dart';
import 'package:flutter/material.dart';

class SuccessContent extends StatelessWidget {
  const SuccessContent({
    Key? key,
    required this.message,
  }) : super(key: key);

  final String message;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(Images.img_success),
        const SizedBox(height: 26),
        Text(
          message,
          textAlign: TextAlign.center,
          style: AppTextStyles.regularW400(context, size: 14),
        ),
      ],
    );
  }
}
