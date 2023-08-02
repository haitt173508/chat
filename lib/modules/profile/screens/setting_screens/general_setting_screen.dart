import 'package:chat_365/common/blocs/theme_cubit/theme_cubit.dart';
import 'package:chat_365/common/images.dart';
import 'package:chat_365/core/theme/app_colors.dart';
import 'package:chat_365/core/theme/app_text_style.dart';
import 'package:chat_365/utils/data/enums/themes.dart';
import 'package:chat_365/utils/data/extensions/context_extension.dart';
import 'package:chat_365/utils/ui/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

List<ThemeMode> listMode = [
  ThemeMode.dark,
  ThemeMode.light,
];

extension ThemeModeExt on ThemeMode {
  String get modeName => this == ThemeMode.dark ? 'Tối' : 'Sáng';

  static ThemeMode fromIndex(int id) => ThemeMode.values[id];
}

TextStyle _style(
  BuildContext context,
) =>
    AppTextStyles.regularW500(
      context,
      size: 16,
      lineHeight: 22,
    );

class GeneralSettingScreen extends StatefulWidget {
  const GeneralSettingScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<GeneralSettingScreen> createState() => _GeneralSettingScreenState();
}

class _GeneralSettingScreenState extends State<GeneralSettingScreen> {
  late ThemeMode _themeMode;
  late AppThemeColor _themeColor;
  late final MyTheme _theme;
  late final ThemeCubit _themeCubit;

  @override
  void initState() {
    super.initState();
    _theme = context.theme;
    _themeCubit = context.read<ThemeCubit>();
    _themeMode = _theme.themeMode;
    _themeColor = _theme.appTheme;
  }

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
          title: Text('Cài đặt chung'),
          elevation: 1,
        ),
        body: Padding(
          padding: EdgeInsets.all(15).copyWith(top: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UnderlineWidget(
                child: ListTile(
                  onTap: () {},
                  contentPadding: EdgeInsets.symmetric(vertical: 18),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Ngôn ngữ:',
                        style: _style(context),
                      ),
                      Text(
                        'Tiếng Việt -Vietnamese',
                        style: AppTextStyles.regularW400(
                          context,
                          size: 16,
                          lineHeight: 19.01,
                        ),
                      ),
                      // CustomDropdownButton<SeleAble>(
                      //     items: CustomDropdownMenuItem(
                      //         child: Text('Tiếng Việt - Vietnamese')),
                      //     onChanged: (value) {}),
                    ],
                  ),
                ),
              ),
              //Giao diện thay đổi màu
              UnderlineWidget(
                child: ListTile(
                  onTap: () {},
                  contentPadding: EdgeInsets.symmetric(vertical: 18),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Giao diện:',
                        style: _style(context),
                      ),
                      SizedBoxExt.h15,
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        // mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          for (var item in AppThemeColor.values)
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      //Thay đổi màu được chọn
                                      _themeColor = item;
                                      _themeCubit.changeThemeColor(_themeColor);
                                    });
                                  },
                                  child: Stack(
                                    children: [
                                      Container(
                                        width: 50.0,
                                        height: 50.0,
                                        decoration: BoxDecoration(
                                          // color: Colors.blue,
                                          shape: BoxShape.circle,
                                          gradient: item.gradient,
                                        ),
                                      ),
                                      if (_themeColor == item)
                                        Positioned(
                                          bottom: 0,
                                          right: 0,
                                          child: CircleAvatar(
                                            radius: 10,
                                            backgroundColor: AppColors.white,
                                            child: Container(
                                              height: 18,
                                              width: 18,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                gradient: item.gradient,
                                                border: Border.all(
                                                  color: AppColors.white,
                                                ),
                                              ),
                                              alignment: Alignment.center,
                                              child: Icon(
                                                Icons.done,
                                                size: 15,
                                                color: AppColors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                SizedBoxExt.w20,
                              ],
                            )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              //Thay đổi chế độ sáng tối.
              Padding(
                padding: EdgeInsets.symmetric(vertical: 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Chế độ:',
                      style: _style(context),
                    ),
                    for (var item in listMode)
                      Column(
                        children: [
                          SizedBoxExt.h15,
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _themeMode = item;
                                    _themeCubit.changeThemeMode(item);
                                  });
                                },
                                child: CircleAvatar(
                                  radius: 12,
                                  backgroundColor: context.theme.primaryColor,
                                  child: CircleAvatar(
                                    radius: 11,
                                    backgroundColor: item == _themeMode
                                        ? context.theme.primaryColor
                                        : context.theme.backgroundColor,
                                    child: item == _themeMode
                                        ? SvgPicture.asset(Images.ic_tick_bold)
                                        : SizedBox(),
                                  ),
                                ),
                              ),
                              SizedBoxExt.w15,
                              Text(
                                item.modeName,
                                style: AppTextStyles.contactItem,
                              ),
                            ],
                          ),
                        ],
                      )
                  ],
                ),
              ),
            ],
          ),
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
