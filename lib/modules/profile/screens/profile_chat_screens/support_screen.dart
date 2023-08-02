import 'package:chat_365/common/widgets/button/border_button.dart';
import 'package:chat_365/core/constants/asset_path.dart';
import 'package:chat_365/core/theme/app_colors.dart';
import 'package:chat_365/core/theme/app_text_style.dart';
import 'package:chat_365/utils/ui/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:chat_365/utils/data/extensions/context_extension.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        listTileTheme: ListTileThemeData(
          contentPadding: EdgeInsets.zero,
          dense: true,
          minLeadingWidth: 20,
          minVerticalPadding: 0,
        ),
      ),
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: Text('Trợ giúp và phản hồi'),
            elevation: 1,
          ),
          body: Padding(
            padding: EdgeInsets.all(15).copyWith(bottom: 58),
            child: Stack(
              children: [
                Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Chat365.vn',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.boldTextProfile,
                      ),
                      SizedBoxExt.h15,
                      Container(
                        padding: EdgeInsets.fromLTRB(12, 15, 12, 50),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Đơn vị chủ quản:',
                              style: AppTextStyles.hintText,
                            ),
                            SizedBoxExt.h10,
                            GestureDetector(
                              onTap: () {
                                // launch('https://timviec365.vn',
                                //     forceWebView: false);
                              },
                              child: Text(
                                'Công ty cổ phần thanh toán Hưng Hà',
                                style: AppTextStyles.hintText
                                    .copyWith(color: AppColors.primary),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // RoundedButton(
                      //   label: '190063682 - Phím 1',
                      //   fillStyle: true,
                      //   labelStyle: AppTextStyles.button(context),
                      //   onPressed: () {
                      //     launch('tel:190063682');
                      //   },
                      //   icon: SvgPicture.asset(AssetPath.icon_phone_support),
                      // ),
                      // SizedBoxExt.h20,
                      RoundedButton(
                        label: '0982.079.209',
                        fillStyle: true,
                        icon: SvgPicture.asset(AssetPath.icon_phone_support),
                        onPressed: () {
                          launch('tel:84982079209');
                        },
                      ),
                    ]),
                // Positioned(
                //   bottom: 0,
                //   right: 0,
                //   left: 0,
                //   child: Row(
                //     mainAxisSize: MainAxisSize.max,
                //     mainAxisAlignment: MainAxisAlignment.spaceAround,
                //     children: [
                //       RoundedButton(
                //         label: 'Hãy chat với chúng tôi',
                //         fillStyle: true,
                //         labelStyle: AppTextStyles.button(context),
                //       ),
                //       RoundedButton(
                //         label: 'Skype',
                //         fillStyle: false,
                //       ),
                //     ],
                //   ),
                // )
              ],
            ),
          )),
    );
  }
}
