import 'package:chat_365/common/images.dart';
import 'package:chat_365/core/constants/string_constants.dart';
import 'package:chat_365/core/theme/app_colors.dart';
import 'package:chat_365/core/theme/app_text_style.dart';
import 'package:chat_365/utils/data/extensions/context_extension.dart';
import 'package:chat_365/utils/ui/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class TimekeepingPersonallyScreen extends StatefulWidget {
  const TimekeepingPersonallyScreen({Key? key}) : super(key: key);

  @override
  State<TimekeepingPersonallyScreen> createState() => _TimekeepingPersonallyScreenState();
}

class _TimekeepingPersonallyScreenState extends State<TimekeepingPersonallyScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.backgroundFormFieldColor,
      appBar: AppBar(
        title: Text(
          StringConst.timekeeping,
        ),
        elevation: 1,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Image.asset(
                Images.img_icon_no,
                height: 226,
                width: 226,
              ),
            ),
            SizedBoxExt.h10,
            Center(
              child: Text(
                'Bạn cần tạo tài khoản công ty và cài đặt tài khoản nhân viên theo hướng dẫn bên dưới để thực hiện chức năng này!',
                style: AppTextStyles.regularW400(
                  context,
                  size: 16,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBoxExt.h96,
            SizedBoxExt.h20,
            TextButton(
              onPressed: () {
                _launchURL(StringConst.tutorialLink);
              },
              child: Text(
                'Hướng dẫn chấm công',
                style: TextStyle(
                  fontSize: 16,
                  decoration: TextDecoration.underline,
                  color: AppColors.primary,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

_launchURL(url) async {
  await launch(url);
}
