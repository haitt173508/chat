import 'package:chat_365/common/images.dart';
import 'package:chat_365/core/theme/app_colors.dart';
import 'package:chat_365/core/theme/app_dimens.dart';
import 'package:chat_365/router/app_pages.dart';
import 'package:chat_365/router/app_router.dart';
import 'package:chat_365/utils/ui/app_padding.dart';
import 'package:flutter/material.dart';
import 'package:chat_365/utils/data/extensions/context_extension.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AcceptOrDenyAccessScreen extends StatefulWidget {
  const AcceptOrDenyAccessScreen({Key? key}) : super(key: key);

  @override
  State<AcceptOrDenyAccessScreen> createState() =>
      _AcceptOrDenyAccessScreenState();
}

class _AcceptOrDenyAccessScreenState extends State<AcceptOrDenyAccessScreen> {
  List choice = [
    true,
    false,
    false,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Phê duyệt hoặc chặn quyền truy cập của người dùng từ các quốc gia/khu vực',
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: AppPadding.paddingAll16,
          shrinkWrap: true,
          children: [
            Container(
              margin: AppDimens.paddingVertical16,
              height: 120,
              color: context.theme.backgroundColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          choice = List.filled(choice.length, false);
                          choice[0] = true;
                        });
                      },
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Không có',
                              style: context
                                  .theme.chatConversationDropdownTextStyle,
                            ),
                          ),
                          choice[0]
                              ? SvgPicture.asset(
                                  Images.ic_tick,
                                  color: AppColors.lawnGreen,
                                )
                              : Container(),
                        ],
                      ),
                    ),
                  ),
                  const Divider(),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          choice = List.filled(choice.length, false);
                          choice[1] = true;
                        });
                      },
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Chỉ cho phép người dùng từ các quốc gia/khu vực đã chọn',
                              style: context
                                  .theme.chatConversationDropdownTextStyle,
                            ),
                          ),
                          choice[1]
                              ? SvgPicture.asset(
                                  Images.ic_tick,
                                  color: AppColors.lawnGreen,
                                )
                              : Container(),
                        ],
                      ),
                    ),
                  ),
                  const Divider(),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          choice = List.filled(choice.length, false);
                          choice[2] = true;
                        });
                      },
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Chặn người dùng từ các quốc gia/khu vực đã chọn',
                              style: context
                                  .theme.chatConversationDropdownTextStyle,
                            ),
                          ),
                          choice[2]
                              ? SvgPicture.asset(
                                  Images.ic_tick,
                                  color: AppColors.lawnGreen,
                                )
                              : Container(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (choice[1] || choice[2])
              Container(
                margin: AppDimens.paddingVertical16,
                height: 80,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'QUỐC GIA / KHU VỰC ĐÃ CHỌN',
                      style: context.theme.chatConversationDropdownTextStyle,
                    ),
                    TextButton(
                      onPressed: () =>
                          AppRouter.toPage(context, AppPages.EditRegion),
                      child: Text('Chỉnh sửa quốc gia, khu vực'),
                    ),
                  ],
                ),
              )
          ],
        ),
      ),
    );
  }
}
