import 'package:chat_365/core/theme/app_colors.dart';
import 'package:chat_365/core/theme/app_text_style.dart';
import 'package:flutter/material.dart';

class LabelFormField extends StatelessWidget {
  const LabelFormField(
      {Key? key, required this.title, required this.isRequired})
      : super(key: key);
  final String title;
  final bool isRequired;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Text(
            title,
            style: AppTextStyles.regularW500(context, size: 16),
          ),
          isRequired
              ? Text(
                  ' *',
                  style: AppTextStyles.regularW500(context,
                      size: 16, color: AppColors.red),
                )
              : SizedBox()
        ],
      ),
    );
  }
}
