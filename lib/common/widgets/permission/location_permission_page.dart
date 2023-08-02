import 'package:app_settings/app_settings.dart';
import 'package:chat_365/common/images.dart';
import 'package:chat_365/common/widgets/permission/permission_page_layout.dart';
import 'package:chat_365/core/constants/string_constants.dart';
import 'package:chat_365/core/theme/app_colors.dart';
import 'package:chat_365/core/theme/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationPermissionPage extends StatelessWidget {
  const LocationPermissionPage({
    Key? key,
    this.callBack,
  }) : super(key: key);

  static const String callBackArg = 'callBackArg';

  final VoidCallback? callBack;

  @override
  Widget build(BuildContext context) {
    return PermissionPageLayout(
      callBackOnAcceptPermission: callBack,
      permissionAppSettings: AppSettings.openLocationSettings,
      text: Column(
        children: [
          Text(
            'Chia sẻ Vị trí trực tiếp với bạn bè?',
            textAlign: TextAlign.center,
            style: AppTextStyles.regularW500(
              context,
              size: 20,
              lineHeight: 23,
            ),
          ),
          const SizedBox(height: 24),
          _Row(
            colors: [
              Color(0xFF7D79D9),
              Color(0xFFAA82C1),
              Color(0xFFDD8CA2),
            ],
            assetPath: Images.ic_like,
            title: 'Bảo mật vị trí của bạn',
            subtitle: 'Chia sẻ bản đồ riêng với bạn bè',
          ),
          _Row(
            colors: [
              Color(0xFFFFA800),
            ],
            assetPath: Images.ic_sun,
            title: 'Chọn người mà bạn chia sẻ',
            subtitle:
                'Kiểm soát những ai nhìn thấy vị trí của bạn và thời điểm bạn chia sẻ thông tin này tới họ',
          ),
          _Row(
            colors: [
              AppColors.primary,
            ],
            assetPath: Images.ic_security,
            title: 'Bất cứ lúc nào',
            subtitle:
                'Bật/Tắt vị trí cho ứng dụng trong phần cài đặt của thiết bị',
          ),
        ],
      ),
      title: StringConst.location,
      permission: Permission.location,
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({
    Key? key,
    required this.colors,
    required this.title,
    required this.subtitle,
    required this.assetPath,
  }) : super(key: key);

  final List<Color> colors;
  final String title;
  final String subtitle;
  final String assetPath;

  @override
  Widget build(BuildContext context) {
    var linearGradient = LinearGradient(
      colors: colors.length <= 1
          ? [
              colors.single,
              colors.single,
            ]
          : colors,
    );
    return ListTile(
      contentPadding: EdgeInsets.all(8),
      leading: ShaderMask(
        child: SvgPicture.asset(
          assetPath,
          fit: BoxFit.contain,
          height: 25,
          width: 25,
        ),
        shaderCallback: (Rect bounds) {
          return linearGradient.createShader(bounds);
        },
      ),
      horizontalTitleGap: 16,
      title: GradientText(
        title,
        gradient: linearGradient,
        style: AppTextStyles.regularW500(
          context,
          size: 14,
          lineHeight: 16,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: AppTextStyles.regular(
          context,
          fontWeight: FontWeight.w300,
          size: 12,
          lineHeight: 16.8,
        ),
      ),
    );
  }
}

class GradientText extends StatelessWidget {
  const GradientText(
    this.text, {
    required this.gradient,
    this.style,
  });

  final String text;
  final TextStyle? style;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => gradient.createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: Text(text, style: style),
    );
  }
}
