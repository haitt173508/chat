import 'package:chat_365/common/widgets/button/fill_button.dart';
import 'package:chat_365/core/constants/asset_path.dart';
import 'package:chat_365/core/constants/string_constants.dart';
import 'package:chat_365/core/theme/app_colors.dart';
import 'package:chat_365/core/theme/app_dimens.dart';
import 'package:chat_365/core/theme/app_text_style.dart';
import 'package:chat_365/router/app_router_helper.dart';
import 'package:chat_365/utils/data/enums/auth_mode.dart';
import 'package:chat_365/utils/data/extensions/context_extension.dart';
import 'package:chat_365/utils/ui/widget_utils.dart';
import 'package:flutter/material.dart';

import '../widgets/on_boarding_item.dart';
import '../widgets/page_indicator/src/container.dart';

const List<OnBoardingItem> boardingItems = [
  OnBoardingItem(
    description:
        'Chat365 là ứng dụng nhắn tin nhanh và đa chức năng. Gửi tin nhắn, ảnh, video và tin nhắn thoại của bạn miễn phí.',
    image: AssetPath.intro_1st,
  ),
  OnBoardingItem(
    description:
        'Trò chuyện với số lượng bạn bè không giới hạn, tiện lợi và là nơi bạn có thể thực hiện mọi thứ.',
    image: AssetPath.intro_2nd,
  ),
  OnBoardingItem(
    description: 'Họp bàn với quy mô lớn ở bất kỳ đâu với cuộc gọi video nhóm',
    image: AssetPath.intro_3rd,
  ),
];

class IntroScreen extends StatefulWidget {
  IntroScreen({Key? key}) : super(key: key);

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  int currentIndex = 0;

  pageChangeHandler(int index) => setState(() => currentIndex = index);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBoxExt.h55,
          Expanded(
            child: PageIndicatorContainer(
              length: 3,
              align: IndicatorAlign.bottom,
              indicatorSelectorColor: context.theme.primaryColor,
              indicatorColor: AppColors.borderColor.withOpacity(0.1),
              child: PageView.builder(
                onPageChanged: pageChangeHandler,
                itemCount: boardingItems.length,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      Expanded(
                        child: Image.asset(
                          boardingItems[index].image,
                        ),
                      ),
                      Text(
                        boardingItems[index].description,
                        style: AppTextStyles.introDescription,
                        textAlign: TextAlign.center,
                      ),
                      SizedBoxExt.h40,
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBoxExt.h40,
          Padding(
            padding: AppDimens.paddingHorizontal20,
            child: FillButton(
              width: double.infinity,
              title: StringConst.login,
              onPressed: () => AppRouterHelper.toAuthOptionPage(
                context,
                authMode: AuthMode.LOGIN,
              ),
              style: AppTextStyles.button(context).copyWith(
                color: AppColors.white,
              ),
            ),
          ),
          SizedBoxExt.h20,
          Padding(
            padding: AppDimens.paddingHorizontal20,
            child: FillButton(
              width: double.infinity,
              title: StringConst.signUp,
              onPressed: () =>
                  // AppRouter.toPage(
                  //     context, AppPages.Auth_Customer_SetUpAccount),
                  AppRouterHelper.toAuthOptionPage(
                context,
                authMode: AuthMode.REGISTER,
              ),
              style: AppTextStyles.button(context).copyWith(
                color: AppColors.white,
              ),
            ),
          ),
          SizedBoxExt.h55,
        ],
      ),
    );
  }
}
