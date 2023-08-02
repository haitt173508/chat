import 'package:chat_365/common/widgets/button/gradient_button.dart';
import 'package:chat_365/core/theme/app_colors.dart';
import 'package:chat_365/core/theme/app_text_style.dart';
import 'package:chat_365/router/app_router.dart';
import 'package:chat_365/utils/data/extensions/context_extension.dart';
import 'package:flutter/material.dart';

class ForwardMessageDoneButton extends StatelessWidget {
  const ForwardMessageDoneButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GradientButton(
      onPressed: () => AppRouter.back(context),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      gradientColor: context.theme.gradient,
      child: Text(
        'Xong',
        style: AppTextStyles.regularW700(
          context,
          size: 16,
          lineHeight: 19,
          color: AppColors.white,
        ),
      ),
    );
  }
}
