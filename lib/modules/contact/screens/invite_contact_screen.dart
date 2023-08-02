import 'package:chat_365/common/images.dart';
import 'package:chat_365/common/widgets/form/search_field.dart';
import 'package:chat_365/core/interfaces/interface_user_info.dart';
import 'package:chat_365/core/theme/app_colors.dart';
import 'package:chat_365/core/theme/app_text_style.dart';
import 'package:chat_365/utils/data/extensions/context_extension.dart';
import 'package:chat_365/utils/helpers/system_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class InviteContactScreen extends StatelessWidget {
  const InviteContactScreen({
    Key? key,
    required this.userInfo,
  }) : super(key: key);

  static const userInfoArg = 'userInfoArg';

  final IUserInfo userInfo;

  @override
  Widget build(BuildContext context) {
    var link = 'https://join.chat365.vn/code';
    return Scaffold(
      appBar: AppBar(
        title: Text('Thêm liên hệ mới'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SearchField(),
              const SizedBox(height: 5),
              Text(
                'Tìm mọi người bằng tên Chat365, email hoặc tên đầy đủ',
                style: AppTextStyles.regularW400(
                  context,
                  size: 12,
                  lineHeight: 15,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Chia sẻ và kết nối',
                style: AppTextStyles.regularW700(
                  context,
                  size: 16,
                  lineHeight: 18.75,
                ),
              ),
              const SizedBox(height: 15),
              Text(
                'Kết nối với mọi người bằng cách chia sẻ liên kết đến hồ sơ của bạn với họ - cho dù hiện họ không có mặt trên Chat365.',
                style: AppTextStyles.regularW400(
                  context,
                  size: 14,
                  lineHeight: 20,
                ),
              ),
              const SizedBox(height: 20),
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Column(
                  children: [
                    Image.asset(
                      Images.img_share_contact_background,
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.all(15),
                      color: AppColors.grayC4C4C4,
                      child: Text(
                        userInfo.name,
                        style: AppTextStyles.regularW700(
                          context,
                          size: 16,
                          color: AppColors.lightThemeTextColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  InkWell(
                    onTap: () => SystemUtils.copyToClipboard(link),
                    child: SvgPicture.asset(
                      Images.ic_copy,
                      color: context.theme.iconColor,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Sao chép liên kết',
                          style: AppTextStyles.regularW700(
                            context,
                            size: 16,
                          ),
                        ),
                        const SizedBox(height: 1),
                        Text(
                          link,
                          style: AppTextStyles.regularW400(
                            context,
                            size: 14,
                            lineHeight: 16,
                            color: AppColors.doveGray,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
