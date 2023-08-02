import 'dart:io';

import 'package:chat_365/common/images.dart';
import 'package:chat_365/core/constants/string_constants.dart';
import 'package:chat_365/core/theme/app_colors.dart';
import 'package:chat_365/core/theme/app_text_style.dart';
import 'package:chat_365/utils/data/extensions/context_extension.dart';
import 'package:chat_365/utils/ui/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class TimekeepingCompanyScreen extends StatefulWidget {
  const TimekeepingCompanyScreen({Key? key}) : super(key: key);

  @override
  State<TimekeepingCompanyScreen> createState() =>
      _TimekeepingCompanyScreenState();
}

class _TimekeepingCompanyScreenState extends State<TimekeepingCompanyScreen> {
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
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Image.asset(
                    Images.img_logo_chat365,
                    height: 100,
                    width: 100,
                  ),
                ),
                SizedBoxExt.h50,
                InkWell(
                  onTap: () {
                    _launchURL(Platform.isAndroid
                        ? 'https://play.google.com/store/apps/details?id=com.timviec365.pc365company'
                        : 'https://apps.apple.com/vn/app/pc365-c%C3%B4ng-ty/id1599246163?l=vi');
                  },
                  borderRadius: BorderRadius.circular(50),
                  child: Ink(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: context.theme.primaryColor,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                      child:
                          Text('Công ty tải App để cài đặt dữ liệu chấm công',
                              style: AppTextStyles.regularW400(
                                context,
                                size: 15,
                                color: context.theme.backgroundFormFieldColor,
                              )),
                    ),
                    height: 48,
                  ),
                ),
                SizedBoxExt.h20,
                Center(
                  child: Text(
                    'Hoặc',
                    style: AppTextStyles.regularW400(
                      context,
                      size: 16,
                    ),
                  ),
                ),
                SizedBoxExt.h20,
                InkWell(
                  onTap: () {
                    _launchURL(
                        'https://chamcong.timviec365.vn/thong-bao.html?s=f30f0b61e761b8926941f232ea7cccb9.${context.userInfo().companyId}.${context.userInfo().password}&link=https://chamcong.timviec365.vn/quan-ly-cong-ty/cau-hinh-cham-cong.html');
                  },
                  borderRadius: BorderRadius.circular(50),
                  child: Ink(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.5,
                    ),
                    decoration: BoxDecoration(
                        color: context.theme.backgroundFormFieldColor,
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(color: AppColors.primary, width: 1)),
                    height: 48,
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                      child: RichText(
                        text: TextSpan(
                          text: 'Công ty cài đặt dữ liệu chấm công ',
                          style: AppTextStyles.regularW400(
                            context,
                            size: 16,
                            color: AppColors.tundora,
                          ),
                          children: [
                            TextSpan(
                              text: 'tại đây',
                              style: AppTextStyles.regularW500(
                                context,
                                size: 16,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBoxExt.h89,
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
        ));
  }
}

_launchURL(url) async {
  await launch(url);
}
