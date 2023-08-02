import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_365/common/widgets/button/border_button.dart';
import 'package:chat_365/core/theme/app_colors.dart';
import 'package:chat_365/core/theme/app_text_style.dart';
import 'package:chat_365/utils/data/enums/user_status.dart';
import 'package:chat_365/utils/ui/app_dialogs.dart';
import 'package:chat_365/utils/ui/app_padding.dart';
import 'package:chat_365/utils/ui/widget_utils.dart';
import 'package:flutter/material.dart';

class ContactBlocKModel {
  final String id;
  final String avatar;
  final String name;
  UserStatus status;

  ContactBlocKModel({
    required this.id,
    required this.avatar,
    required this.name,
    required this.status,
  });
}

TextStyle _style(
  BuildContext context,
) =>
    AppTextStyles.regularW500(
      context,
      size: 14,
      lineHeight: 22,
    );

class ContactBlockScreen extends StatefulWidget {
  const ContactBlockScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<ContactBlockScreen> createState() => _ContactBlockScreenState();
}

class _ContactBlockScreenState extends State<ContactBlockScreen> {
  List<ContactBlocKModel> contactBlocList = [
    ContactBlocKModel(
        id: '', avatar: '', name: 'Bạn A', status: UserStatus.offline),
    ContactBlocKModel(
        id: '', avatar: '', name: 'Bạn B', status: UserStatus.offline),
    ContactBlocKModel(
        id: '', avatar: '', name: 'Bạn C', status: UserStatus.online),
  ];
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
        appBar: AppBar(
          title: Text('Danh bạ'),
          elevation: 1,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(15),
              child: Text(
                'Các liên hệ bị chặn',
                style: _style(context),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: ScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.all(15).copyWith(top: 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (int index = 0;
                          index < contactBlocList.length;
                          index++)
                        Padding(
                          padding: AppPadding.paddingVertical10,
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Stack(
                                children: [
                                  CircleAvatar(
                                    child: ClipRRect(
                                      child: CachedNetworkImage(
                                          imageUrl:
                                              contactBlocList[index].avatar,
                                          errorWidget: (context, url, error) =>
                                              CircleAvatar(
                                                backgroundColor:
                                                    AppColors.primary,
                                              )),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: CircleAvatar(
                                      radius: 6,
                                      backgroundColor: contactBlocList[index]
                                                  .status ==
                                              UserStatus.offline
                                          ? AppColors.offline
                                          : contactBlocList[index].status ==
                                                  UserStatus.online
                                              ? AppColors.online
                                              : contactBlocList[index].status ==
                                                      UserStatus.notDisturb
                                                  ? AppColors.red
                                                  : AppColors.white,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBoxExt.w15,
                              Expanded(
                                  flex: 3,
                                  child:
                                      Text('${contactBlocList[index].name}')),
                              Expanded(
                                flex: 2,
                                child: RoundedButton(
                                  label: 'Bỏ chặn',
                                  fillStyle: false,
                                  onPressed: () {
                                    setState(() {
                                      AppDialogs.showConfirmDialog(
                                        context,
                                        title: 'Bỏ chặn liên hệ',
                                        successMessage: 'Thành công',
                                        content: Padding(
                                          padding: AppPadding.paddingVertical30,
                                          child: Text(
                                            'Bạn có chắc chắn muốn bỏ chặn ${contactBlocList[index].name}?',
                                            textAlign: TextAlign.center,
                                            style: AppTextStyles.regularW400(
                                                context,
                                                size: 14),
                                          ),
                                        ),
                                        nameFunction: 'Bỏ chặn',
                                        onFunction: (value) {
                                          setState(() {
                                            contactBlocList.removeAt(index);
                                          });
                                          return null;
                                        },
                                      );
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UnderlineWidget extends StatelessWidget {
  const UnderlineWidget({
    Key? key,
    required this.child,
  }) : super(key: key);
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        child,
        Divider(
          thickness: 1,
          height: 1,
          color: AppColors.greyCC,
        ),
      ],
    );
  }
}
