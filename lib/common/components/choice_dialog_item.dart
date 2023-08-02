import 'package:chat_365/core/theme/app_text_style.dart';
import 'package:chat_365/utils/data/extensions/context_extension.dart';
import 'package:chat_365/utils/helpers/logger.dart';
import 'package:flutter/material.dart';

class ChoiceDialogItem<T> extends StatelessWidget {
  const ChoiceDialogItem({
    Key? key,
    required this.value,
    required this.onTap,
  }) : super(key: key);

  final T value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        try {
          Navigator.of(context).pop();
        } catch (e, s) {
          logger.logError(e, s);
        }
        onTap();
      },
      child: Ink(
        height: 40,
        padding: EdgeInsets.symmetric(horizontal: 25),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            value.toString(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.regularW400(
              context,
              size: 14,
              lineHeight: 16,
              color: context.theme.textColor,
            ),
          ),
        ),
      ),
    );
  }
}
