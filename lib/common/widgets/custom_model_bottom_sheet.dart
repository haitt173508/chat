import 'package:chat_365/core/theme/app_text_style.dart';
import 'package:chat_365/router/app_router.dart';
import 'package:chat_365/utils/ui/app_padding.dart';
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

class CustomModelBottomSheet extends StatelessWidget {
  const CustomModelBottomSheet({
    Key? key,
    required this.title,
    required this.options,
  }) : super(key: key);

  final String title;
  final List<MbsOption> options;

  @override
  Widget build(BuildContext context) {
    return Ink(
      padding: AppPadding.paddingVertical15,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(20),
          topLeft: Radius.circular(20),
        ),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: AppTextStyles.mbsTitle(context),
              ),
            ),
            SizedBoxExt.h10,
            ...options.map(
              (e) => InkWell(
                onTap: () {
                  AppRouter.back(context);
                  e.onTap?.call(context);
                },
                child: Ink(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                  child: Row(
                    children: [
                      SizedBox(
                        height: 24,
                        width: 24,
                        child: SvgPicture.asset(
                          e.pathToSvgIcon,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      SizedBoxExt.w10,
                      Text(
                        e.title,
                        style: AppTextStyles.mbsItem(context),
                      )
                    ],
                  ),
                ),
              ),
            ),
            SizedBoxExt.h10,
          ],
        ),
      ),
    );
  }
}
