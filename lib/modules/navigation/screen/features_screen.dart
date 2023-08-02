import 'package:chat_365/common/images.dart';
import 'package:chat_365/core/constants/string_constants.dart';
import 'package:chat_365/core/theme/app_colors.dart';
import 'package:chat_365/modules/chat/blocs/chat_bloc/chat_bloc.dart';
import 'package:chat_365/modules/chat/widgets/feature_item.dart';
import 'package:chat_365/modules/search/screens/select_user_checkbox_v2_screen.dart';
import 'package:chat_365/modules/timekeeping/bloc/timekeeping_bloc.dart';
import 'package:chat_365/router/app_pages.dart';
import 'package:chat_365/router/app_router.dart';
import 'package:chat_365/utils/data/enums/chat_feature_action.dart';
import 'package:chat_365/utils/data/enums/user_type.dart';
import 'package:chat_365/utils/data/extensions/context_extension.dart';
import 'package:chat_365/utils/ui/app_padding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FeatureScreen extends StatelessWidget {
  const FeatureScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _utilsGroupItem({
      required String groupTitle,
      required List<Widget> items,
    }) {
      return Container(
        width: double.infinity,
        padding: AppPadding.paddingAll16,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              groupTitle,
              style: context.theme.searchBigTextStyle.copyWith(
                fontSize: 16,
                color: context.theme.isDarkTheme ? AppColors.white : AppColors.tundora,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: items,
            ),
          ],
        ),
      );
    }

    var sendLocation = FeatureItem(
      label: StringConst.location,
      assetPath: Images.ic_location,
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => SelectUserCheckboxV2Screen(
              onSelected: (value) {
                context.read<ChatBloc>().tryToChatScreen(
                      chatInfo: value,
                      isNeedToFetchChatInfo: true,
                      action: ChatFeatureAction.sendLocation,
                    );
              },
            ),
          ),
        );
      },
      gradient: LinearGradient(
        colors: [
          Color(0xFF70CAFF),
          Color(0xFFB0E2FD),
        ],
      ),
    );
    var timeKeeping = FeatureItem(
      label: StringConst.timekeeping,
      assetPath: Images.ic_cham_cong,
      onTap: () {
        if (context.userType() == UserType.staff) {
          AppRouter.toPage(
            context,
            AppPages.Choose_A_Timekeeping,
            blocValue: context.read<TimekeepingBloc>(),
          );
        } else if (context.userType() == UserType.company) {
          AppRouter.toPage(
            context,
            AppPages.Timekeeping_Company_Screen,
          );
        } else if (context.userType() == UserType.customer) {
          AppRouter.toPage(
            context,
            AppPages.Timekeeping_Personally_Screen,
          );
        }
      },
      gradient: LinearGradient(
        colors: [
          Color(0xFF0086DA),
          Color(0xFF00A9E9),
          Color(0xFF00A9E9),
        ],
      ),
    );

    // var test123 = FeatureItem(
    //   label: 'Test123',
    //   assetPath: Images.ic_cham_cong,
    //   onTap: () {
    //     AppRouter.toPage(
    //       context,
    //       AppPages.Test_123,
    //     );
    //   },
    //   gradient: LinearGradient(
    //     colors: [
    //       Color(0xFF0086DA),
    //       Color(0xFF00A9E9),
    //       Color(0xFF00A9E9),
    //     ],
    //   ),
    // );
    return Scaffold(
      appBar: AppBar(
        title: Text('Tiện ích'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            _utilsGroupItem(
              groupTitle: 'Công cụ',
              items: [
                timeKeeping,
                sendLocation,
              ],
            ),
          ],
        ),
      ),
    );
  }
}
