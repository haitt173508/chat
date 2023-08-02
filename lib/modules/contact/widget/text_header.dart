import 'package:chat_365/core/theme/app_text_style.dart';
import 'package:flutter/material.dart';

class TextHeader extends StatelessWidget {
  const TextHeader({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTextStyles.regularW700(
        context,
        size: 16,
        lineHeight: 19.2,
      ),
    );
  }
}
