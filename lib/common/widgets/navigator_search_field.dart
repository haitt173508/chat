import 'package:chat_365/common/images.dart';
import 'package:chat_365/core/constants/string_constants.dart';
import 'package:chat_365/core/theme/app_colors.dart';
import 'package:chat_365/core/theme/app_text_style.dart';
import 'package:chat_365/utils/data/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NavigatorSearchField extends StatelessWidget {
  const NavigatorSearchField({
    Key? key,
    required this.onNavigate,
    this.hintText = StringConst.search,
  }) : super(key: key);

  final VoidCallback onNavigate;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
      ),
      height: 36,
      color: Theme.of(context).backgroundColor,
      child: InkWell(
        onTap: onNavigate,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: context.theme.isDarkTheme
                  ? AppColors.white
                  : AppColors.greyCC,
            ),
          ),
          padding: EdgeInsets.symmetric(horizontal: 14),
          child: Row(
            children: [
              SvgPicture.asset(Images.ic_uil_search),
              const SizedBox(width: 10),
              Text(
                hintText,
                style: AppTextStyles.regularW400(
                  context,
                  size: 14,
                  lineHeight: 15,
                  color: context.theme.isDarkTheme
                      ? AppColors.white
                      : AppColors.greyCC,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
