import 'package:chat_365/common/blocs/settings_cubit/cubit/settings_cubit.dart';
import 'package:chat_365/common/blocs/settings_cubit/cubit/settings_state.dart';
import 'package:chat_365/common/blocs/theme_cubit/theme_cubit.dart';
import 'package:chat_365/common/images.dart';
import 'package:chat_365/common/models/message_setting_model.dart';
import 'package:chat_365/common/models/message_setting_model_item.dart';
import 'package:chat_365/common/widgets/button/switch_button.dart';
import 'package:chat_365/core/theme/app_colors.dart';
import 'package:chat_365/core/theme/app_text_style.dart';
import 'package:chat_365/utils/data/enums/message_setting_type.dart';
import 'package:chat_365/utils/data/enums/message_text_size.dart';
import 'package:chat_365/utils/data/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

TextStyle _style(BuildContext context) => AppTextStyles.regularW500(
      context,
      size: 16,
      lineHeight: 22,
    );

class MessageSettingScreen extends StatefulWidget {
  const MessageSettingScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<MessageSettingScreen> createState() => _MessageSettingScreenState();
}

class _MessageSettingScreenState extends State<MessageSettingScreen> {
  late final ThemeCubit _themeCubit;
  late final SettingsCubit _settingsCubit;

  _changeFontSize(MessageSettingModelItem setting) {
    _themeCubit.changeThemeMessageTextSize(
      (setting.selectedValue as MessageTextSize).fontSize,
    );
  }

  @override
  void initState() {
    super.initState();
    _themeCubit = context.read<ThemeCubit>();
    _settingsCubit = context.read<SettingsCubit>();
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
          title: Text('Nhắn tin'),
          elevation: 1,
        ),
        body: Padding(
          padding: EdgeInsets.all(15).copyWith(top: 0),
          child: SingleChildScrollView(
            physics: ScrollPhysics(),
            child: BlocBuilder<SettingsCubit, SettingState>(
              builder: (context, state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (var setting in state.settingsModel.settings.values)
                      _buildItem(
                        context,
                        setting: setting,
                      ),
                  ],
                  // children: [
                  //   for (int index = 0; index < listMessSetting.length; index++)
                  //     UnderlineWidget(
                  //       child: Padding(
                  //         padding: EdgeInsets.symmetric(vertical: 18),
                  //         child: Column(
                  //             crossAxisAlignment: CrossAxisAlignment.start,
                  //             children: [
                  //               Row(
                  //                 children: [
                  //                   Expanded(
                  //                     flex: 2,
                  //                     child: Text(
                  //                       '${listMessSetting[index].title}',
                  //                       style: _style(context),
                  //                     ),
                  //                   ),
                  //                   listMessSetting[index].content == null &&
                  //                           listMessSetting[index].valueSelect ==
                  //                               null
                  //                       ? SwitchButton(
                  //                           initValue:
                  //                               listMessSetting[index].isSelect,
                  //                           onChanged: (_) async {
                  //                             setState(() {
                  //                               listMessSetting[index].isSelect =
                  //                                   !listMessSetting[index]
                  //                                       .isSelect;
                  //                             });
                  //                             return '';
                  //                           })
                  //                       : listMessSetting[index].valueSelect != null
                  //                           ? Expanded(
                  //                               flex: 1,
                  //                               child: GestureDetector(
                  //                                   onTap: () =>
                  //                                       AppDialogs.showListDialog(
                  //                                           context: context,
                  //                                           list: FontSized
                  //                                               .selectableItemList,
                  //                                           value: FontSized
                  //                                               .selectableItemList
                  //                                               .firstWhere((element) =>
                  //                                                   element.id ==
                  //                                                   listMessSetting[
                  //                                                           index]
                  //                                                       .valueSelect)).then(
                  //                                           (value) {
                  //                                         if (value != null)
                  //                                           listMessSetting[index]
                  //                                                   .valueSelect =
                  //                                               value;
                  //                                       }),
                  //                                   child: Row(
                  //                                     children: [
                  //                                       Text(
                  //                                           '${FontSized.selectableItemList.firstWhere((element) => element.id == listMessSetting[index].valueSelect).name}'),
                  //                                       SizedBoxExt.w10,
                  //                                       SvgPicture.asset(
                  //                                           Images.ic_arrow_down)
                  //                                     ],
                  //                                   )),
                  //                             )
                  //                           : SizedBox(),
                  //                 ],
                  //               ),
                  //               SizedBoxExt.h5,
                  //               listMessSetting[index].content != null
                  //                   ? Row(
                  //                       mainAxisAlignment:
                  //                           MainAxisAlignment.spaceBetween,
                  //                       children: [
                  //                         Expanded(
                  //                           child: Text(
                  //                             listMessSetting[index].content!,
                  //                             style: AppTextStyles.hintText,
                  //                           ),
                  //                         ),
                  //                         SwitchButton(
                  //                             initValue:
                  //                                 listMessSetting[index].isSelect,
                  //                             onChanged: (_) async {
                  //                               setState(() {
                  //                                 listMessSetting[index].isSelect =
                  //                                     !listMessSetting[index]
                  //                                         .isSelect;
                  //                               });
                  //                               return '';
                  //                             }),
                  //                       ],
                  //                     )
                  //                   : SizedBox(),
                  //             ]),
                  //       ),
                  //     ),
                  // ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  UnderlineWidget _buildItem(
    BuildContext context, {
    required MessageSettingModelItem setting,
  }) {
    var content = MessageSettingModel.content(setting.messageSettingType);
    return UnderlineWidget(
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 8),
        title: Text(
          MessageSettingModel.title(setting.messageSettingType),
          style: _style(context),
        ),
        subtitle: content != null
            ? Text(
                content,
                style: AppTextStyles.hintText,
              )
            : null,
        trailing: setting.values.length < 3
            ? SwitchButton(
                initValue: setting.selectedValue,
                onChanged: (value) async {
                  setting.selectedValue = value;
                  return null;
                })
            : StatefulBuilder(
                builder: (context, setState) {
                  // var setting = setting;
                  return PopupMenuButton(
                    color: context.theme.messageBoxColor,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        BlocBuilder<ThemeCubit, ThemeState>(
                          builder: (context, themeState) {
                            return Text(
                              setting.valueDisplay(
                                setting.selectedValue,
                              ),
                              style: AppTextStyles.regularW400(
                                context,
                                size: themeState.theme.messageTextSize,
                              ),
                            );
                          },
                        ),
                        const SizedBox(width: 4),
                        SvgPicture.asset(Images.ic_arrow_down),
                      ],
                    ),
                    initialValue: setting.selectedValue,
                    onSelected: (value) {
                      if (value != setting.selectedValue) {
                        setState(
                          () => _settingsCubit.updateMessageSetting(
                            setting..selectedValue = value,
                          ),
                        );
                        if (setting.messageSettingType ==
                            MessageSettingType.messageFontSize)
                          _changeFontSize(setting);
                      }
                    },
                    itemBuilder: (_) => setting.values
                        .map(
                          (e) => PopupMenuItem(
                            value: e,
                            child: Text(
                              setting.valueDisplay(e),
                              style: _style(context),
                            ),
                          ),
                        )
                        .toList(),
                  );
                },
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
