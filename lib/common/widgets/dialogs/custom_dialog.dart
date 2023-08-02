import 'package:chat_365/common/widgets/button/fill_button.dart';
import 'package:chat_365/core/constants/string_constants.dart';
import 'package:chat_365/core/theme/app_text_style.dart';
import 'package:chat_365/utils/ui/app_border_and_radius.dart';
import 'package:chat_365/utils/ui/widget_utils.dart';
import 'package:flutter/material.dart';

class CustomDialog extends StatelessWidget {
  final bool isMessageDialog;
  final bool switchButtonsPositionAndStyle;
  final Widget icon;
  final String affirmativeText;
  final String description;
  final void Function() onAffirmativeBtnPressed;
  final void Function() onCancel;

  const CustomDialog({
    Key? key,
    this.isMessageDialog = false,
    this.switchButtonsPositionAndStyle = false,
    required this.icon,
    this.affirmativeText = 'Đóng',
    required this.description,
    required this.onAffirmativeBtnPressed,
    required this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final EdgeInsets containerPadding = isMessageDialog
        ? const EdgeInsets.symmetric(horizontal: 22, vertical: 20)
        : const EdgeInsets.symmetric(horizontal: 22, vertical: 40);
    final SizedBox spacingBetweenDescription =
        isMessageDialog ? SizedBoxExt.h20 : SizedBoxExt.h30;
    return Dialog(
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: AppBorderAndRadius.defaultBorderRadius,
      ),
      backgroundColor: Colors.transparent,
      child: SingleChildScrollView(
        child: Container(
          padding: containerPadding,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: AppBorderAndRadius.defaultBorderRadius,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              icon,
              //
              spacingBetweenDescription,
              Text(
                description,
                style: AppTextStyles.dialogDescription,
                textAlign: TextAlign.center,
                maxLines: 3,
              ),
              spacingBetweenDescription,
              //
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: isMessageDialog
                      ? [
                          FillButton(
                            title: affirmativeText,
                            width: null,
                            onPressed: onAffirmativeBtnPressed,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 30,
                              vertical: 10,
                            ),
                          ),
                        ]
                      : switchButtonsPositionAndStyle == false
                          ? WidgetUtils.uniformWidth([
                              FillButton(
                                title: affirmativeText,
                                width: null,
                                onPressed: onAffirmativeBtnPressed,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 30,
                                  vertical: 10,
                                ),
                              ),
                              SizedBoxExt.w20,
                              FillButton(
                                title: StringConst.cancel,
                                onPressed: onCancel,
                              ),
                            ])
                          : WidgetUtils.uniformWidth([
                              FillButton(
                                title: StringConst.cancel,
                                onPressed: onCancel,
                              ),
                              SizedBoxExt.w20,
                              FillButton(
                                title: affirmativeText,
                                onPressed: onAffirmativeBtnPressed,
                              ),
                            ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
