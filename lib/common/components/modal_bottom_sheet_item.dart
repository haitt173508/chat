import 'package:chat_365/core/theme/app_text_style.dart';
import 'package:chat_365/utils/ui/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MbsOption {
  final String pathToSvgIcon;
  final String title;
  final void Function(BuildContext)? onTap;

  const MbsOption({
    required this.pathToSvgIcon,
    required this.title,
    this.onTap,
  });
}

class ModalBottomSheetItem extends StatelessWidget {
  const ModalBottomSheetItem({
    Key? key,
    required this.option,
  }) : super(key: key);

  final MbsOption option;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => option.onTap != null ? option.onTap!(context) : null,
      child: Ink(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
        child: Row(
          children: [
            SizedBox(
              height: 24,
              width: 24,
              child: SvgPicture.asset(
                option.pathToSvgIcon,
                color: Theme.of(context).primaryColor,
              ),
            ),
            SizedBoxExt.w10,
            Text(
              option.title,
              style: AppTextStyles.mbsItem(context),
            )
          ],
        ),
      ),
    );
  }
}
