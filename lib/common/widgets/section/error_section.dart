import 'package:chat_365/core/theme/app_text_style.dart';
import 'package:chat_365/utils/ui/icon_utils.dart';
import 'package:chat_365/utils/ui/widget_utils.dart';
import 'package:flutter/material.dart';

class ErrorSection extends StatelessWidget {
  const ErrorSection({
    Key? key,
    required this.icon,
    required this.title,
    required this.subtitle,
  }) : super(key: key);

  factory ErrorSection.noInternetConnectionSection() => const ErrorSection(
        icon: IconUtils.no_internet_icon,
        title: 'Không có kết nối mạng',
        subtitle: 'Đảm bảo Wi-Fi hoặc dữ liệu di động được bật rồi thử lại',
      );

  factory ErrorSection.errorHappenedSection() => const ErrorSection(
        icon: IconUtils.warning_icon,
        title: 'Đã có lỗi xảy ra',
        subtitle: 'Đảm bảo Wi-Fi hoặc dữ liệu di động được bật rồi thử lại',
      );

  final Widget icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: WidgetUtils.addSizedBoxAsSeparator(SizedBoxExt.h20, [
        icon,
        Text(title, style: AppTextStyles.title),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 42),
          child: Text(
            subtitle,
            style: AppTextStyles.dialogDescription,
            textAlign: TextAlign.center,
            maxLines: 2,
          ),
        ),
      ]),
    );
  }
}
