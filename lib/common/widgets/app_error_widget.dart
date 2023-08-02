import 'package:chat_365/core/theme/app_colors.dart';
import 'package:chat_365/core/theme/app_text_style.dart';
import 'package:flutter/material.dart';

class AppErrorWidget extends StatelessWidget {
  const AppErrorWidget({
    Key? key,
    required this.error,
    this.onTap,
    this.buttonLabel = 'Tải lại',
    this.showErrorButton = true,
  }) : super(key: key);

  final String error;
  final VoidCallback? onTap;
  final String buttonLabel;
  final bool showErrorButton;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            error,
            maxLines: 2,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          if (showErrorButton)
            ElevatedButton(
              onPressed: onTap,
              child: Text(
                buttonLabel,
                style: AppTextStyles.regularW500(
                  context,
                  size: 16,
                  color: AppColors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
