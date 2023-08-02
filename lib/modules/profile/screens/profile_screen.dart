import 'dart:io';

import 'package:chat_365/common/blocs/user_info_bloc/bloc/user_info_bloc.dart';
import 'package:chat_365/common/blocs/user_info_bloc/bloc/user_info_state.dart';
import 'package:chat_365/common/components/display/display_avatar.dart';
import 'package:chat_365/common/images.dart';
import 'package:chat_365/common/widgets/custom_expandsion_tile.dart';
import 'package:chat_365/common/widgets/user_list_tile.dart';
import 'package:chat_365/core/constants/string_constants.dart';
import 'package:chat_365/core/interfaces/interface_user_info.dart';
import 'package:chat_365/core/theme/app_colors.dart';
import 'package:chat_365/core/theme/app_text_style.dart';
import 'package:chat_365/modules/chat/widgets/chat_input_bar.dart';
import 'package:chat_365/modules/contact/widget/text_header.dart';
import 'package:chat_365/modules/profile/profile_cubit/profile_cubit.dart';
import 'package:chat_365/modules/profile/profile_cubit/profile_state.dart';
import 'package:chat_365/modules/profile/screens/_confirm_delete_account_screen.dart';
import 'package:chat_365/router/app_pages.dart';
import 'package:chat_365/router/app_router.dart';
import 'package:chat_365/router/app_router_helper.dart';
import 'package:chat_365/utils/data/enums/themes.dart';
import 'package:chat_365/utils/data/enums/user_status.dart';
import 'package:chat_365/utils/data/extensions/context_extension.dart';
import 'package:chat_365/utils/data/extensions/permission_extension.dart';
import 'package:chat_365/utils/helpers/system_utils.dart';
import 'package:chat_365/utils/ui/app_dialogs.dart';
import 'package:chat_365/utils/ui/app_padding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

TextStyle _style(
  BuildContext context, {
  Color color = AppColors.black,
}) =>
    AppTextStyles.regularW400(
      context,
      size: 16,
      lineHeight: 22,
      color: color,
    );

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({
    Key? key,
    required this.userInfo,
    required this.isGroup,
  }) : super(key: key);

  static const userInfoArg = 'userInfoArg';
  static const isGroupArg = 'isGroupArg';

  final IUserInfo userInfo;
  final bool isGroup;

  @override
  Widget build(BuildContext context) {
    final MyTheme theme = context.theme;

    var _imagePicked;

    //Dung file picker de gioi han dinh dang file
    //Dung image picker de lay anh tu camera
    final _imagePicker = ImagePicker();

    File? fileAvatar;
    //Pick from Gallery

    _pickImageFromGallery() async {
      try {
        final List<AssetEntity>? result = await AssetPicker.pickAssets(
          context,
          pickerConfig: AssetPickerConfig(
            maxAssets: 1,
            requestType: RequestType.image,
            textDelegate: VietnameseAssetPickerTextDelegate(),
          ),
        );

        if (result != null) {
          _imagePicked = await result[0].file;
          if (_imagePicked != null) fileAvatar = _imagePicked;
        }
      } catch (e) {}
    }

    _imgFromGallery() => SystemUtils.permissionCallback(
          PermissionExt.libraryPermission,
          _pickImageFromGallery,
        );

    //Pick from Camera
    _imgFromCamera() async {
      final image = await _imagePicker.pickImage(source: ImageSource.camera);
      _imagePicked = image;
      if (_imagePicked != null) fileAvatar = File(_imagePicked.path);
    }

    var userInfoBloc = UserInfoBloc(
      userInfo,
    );

    final ValueNotifier<UserStatus> _status =
        ValueNotifier(userInfo.userStatus);
    final GlobalKey<CustomExpandsionTileState> _expKey =
        GlobalKey<CustomExpandsionTileState>();
    final ProfileCubit _profileCubit = ProfileCubit(
      userInfo.id,
      isGroup: false,
    );
    return Theme(
      data: theme.theme.copyWith(
        listTileTheme: ListTileThemeData(
          contentPadding: EdgeInsets.zero,
          dense: true,
          minLeadingWidth: 20,
          minVerticalPadding: 0,
          iconColor: theme.iconColor,
        ),
      ),
      child: BlocProvider.value(
        value: _profileCubit,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: Text(
              'Hồ sơ cá nhân',
              style: theme.theme.appBarTheme.titleTextStyle,
            ),
            // actions: [
            //   InkWell(
            //     onTap: () => AppDialogs.showLogoutDialog(context),
            //     child: Container(
            //       height: 30,
            //       width: 30,
            //       alignment: Alignment.center,
            //       decoration: BoxDecoration(
            //         gradient: theme.gradient,
            //         shape: BoxShape.circle,
            //       ),
            //       child: SvgPicture.asset(
            //         Images.ic_log_out,
            //         color: AppColors.white,
            //       ),
            //     ),
            //   ),
            //   const SizedBox(width: 20),
            // ],
            elevation: 1,
          ),
          body: BlocProvider.value(
            value: userInfoBloc,
            child: Padding(
              padding: EdgeInsets.all(15).copyWith(bottom: 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BlocBuilder<UserInfoBloc, UserInfoState>(
                    bloc: userInfoBloc,
                    builder: (context, state) {
                      return UserListTile(
                        avatar: PopupMenuButton(
                          offset: Offset(20, 20),
                          padding: EdgeInsets.zero,
                          color: AppColors.whiteLilac,
                          elevation: 8,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          onSelected: (value) async {
                            if (value == 1) {
                              await _imgFromCamera();
                            } else {
                              await _imgFromGallery();
                            }
                            if (fileAvatar != null) {
                              _profileCubit.changeAvatar(
                                  fileAvatar: fileAvatar!, members: []);
                            }
                          },
                          itemBuilder: (context) {
                            return [
                              PopupMenuItem(
                                  height: double.minPositive,
                                  // padding: EdgeInsets.all(6),
                                  // padding: EdgeInsets.zero,
                                  value: 1,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Text(
                                          'Chụp ảnh',
                                          // style:AppTextStyles.titleDropdownItem,
                                        ),
                                      ],
                                    ),
                                  )),
                              PopupMenuItem(
                                  height: double.minPositive,
                                  // padding: EdgeInsets.zero,
                                  value: 2,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Text(
                                          'Tải ảnh từ thư viện',
                                          // style:AppTextStyles.titleDropdownItem,
                                        ),
                                      ],
                                    ),
                                  )),
                            ];
                          },
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              BlocConsumer<ProfileCubit, ProfileState>(
                                listener: (context, state) {
                                  if (state is ChangeAvatarStateError) {
                                    AppDialogs.toast(
                                        'Thay đổi ảnh đại diện thất bại');
                                  }
                                },
                                builder: (context, state) {
                                  if (state is ChangeAvatarStateLoading) {
                                    return Stack(
                                      children: [
                                        DisplayAvatar(
                                          isGroup: isGroup,
                                          model: userInfo,
                                          size: 50,
                                          enable: false,
                                        ),
                                        CircleAvatar(
                                          radius: 50 / 2,
                                          backgroundColor: Colors.transparent,
                                          child: Padding(
                                            padding: AppPadding.paddingAll10,
                                            child: CircularProgressIndicator(
                                                color: theme.primaryColor),
                                          ),
                                        ),
                                      ],
                                    );
                                  } else
                                    return DisplayAvatar(
                                      isGroup: isGroup,
                                      model: userInfo,
                                      size: 50,
                                      enable: false,
                                    );
                                },
                              ),
                              Positioned(
                                bottom: -2,
                                right: -2,
                                child: SvgPicture.asset(
                                  Images.ic_camera,
                                  // color: AppC,
                                ),
                              ),
                            ],
                          ),
                        ),
                        userName: userInfo.name,
                        bottom: Text(
                          userInfo.email ?? '',
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  UnderlineWidget(
                    child: BlocListener<UserInfoBloc, UserInfoState>(
                        listener: (context, state) {
                          _status.value = state.userInfo.userStatus;
                        },
                        child: ValueListenableBuilder<UserStatus>(
                          valueListenable: _status,
                          builder: (_, status, __) => CustomExpandsionTile(
                            key: _expKey,
                            tilePadding: EdgeInsets.zero,
                            iconColor: theme.iconColor,
                            collapsedIconColor: theme.iconColor,
                            title: _UserStatusListTile(
                              status: status,
                            ),
                            children: ([...UserStatus.values]..remove(status))
                                .map(
                                  (e) => _UserStatusListTile(
                                    status: e,
                                    onTap: (status) {
                                      _status.value = status;
                                      _expKey.currentState!.handleTap();
                                      _profileCubit.changeUserStatus(status);
                                    },
                                  ),
                                )
                                .toList(),
                          ),
                        )),
                  ),
                  UnderlineWidget(
                    child: BlocBuilder<UserInfoBloc, UserInfoState>(
                      bloc: userInfoBloc,
                      builder: (context, state) {
                        return _ChangeStatusTextFieldListTile(
                          initStatus: state.userInfo.status ?? '',
                        );
                      },
                    ),
                  ),
                  ListTile(
                    leading: SvgPicture.asset(
                      Images.ic_people,
                      color: theme.unSelectedIconColor,
                    ),
                    title: Text(
                      'Mời bạn',
                      style: _style(
                        context,
                        color: context.theme.isDarkTheme
                            ? AppColors.white
                            : AppColors.tundora,
                      ),
                    ),
                    onTap: () {
                      AppRouterHelper.toInviteContactPage(
                        context,
                        userInfo: userInfo,
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: TextHeader(text: 'Quản lý'),
                  ),
                  UnderlineWidget(
                    child: ListTile(
                      leading: SvgPicture.asset(
                        Images.ic_user_remove,
                      ),
                      title: Text(
                        StringConst.deleteAccount,
                        style: _style(
                          context,
                          color: AppColors.red,
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => const ConfirmDeleteAccountScreen(),
                        ));
                      },
                    ),
                  ),
                  UnderlineWidget(
                    child: ListTile(
                      leading: SvgPicture.asset(
                        Images.ic_person,
                        color: theme.unSelectedIconColor,
                      ),
                      title: Text(
                        'Hồ sơ Chat365',
                        style: _style(
                          context,
                          color: context.theme.isDarkTheme
                              ? AppColors.white
                              : AppColors.black,
                        ),
                      ),
                      onTap: () {
                        AppRouter.toPage(
                          context,
                          AppPages.Profile_Chat,
                          arguments: {
                            ProfileScreen.userInfoArg: userInfo,
                            ProfileScreen.isGroupArg: isGroup,
                          },
                        );
                      },
                    ),
                  ),
                  UnderlineWidget(
                    child: ListTile(
                      onTap: () {
                        AppRouter.toPage(context, AppPages.Setting);
                      },
                      leading: SvgPicture.asset(
                        Images.ic_setting,
                        color: theme.unSelectedIconColor,
                      ),
                      title: Text(
                        'Cài đặt',
                        style: _style(
                          context,
                          color: context.theme.isDarkTheme
                              ? AppColors.white
                              : AppColors.black,
                        ),
                      ),
                    ),
                  ),
                  // ListTile(
                  //   onTap: () => AppDialogs.showLogoutDialog(context),
                  //   leading: SvgPicture.asset(
                  //     Images.ic_user_remove,
                  //     color: context.theme.primaryColor,
                  //   ),
                  //   title: Text(
                  //     StringConst.signOut,
                  //     style: _style(context, color: context.theme.primaryColor),
                  //   ),
                  // ),
                  Expanded(
                    child: Center(
                      child: ElevatedButton.icon(
                        label: Text(
                          StringConst.signOut,
                          style: AppTextStyles.regularW400(
                            context,
                            size: 16,
                            lineHeight: 22,
                            color: AppColors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        icon: SvgPicture.asset(
                          Images.ic_log_uot,
                          color: AppColors.white,
                        ),
                        onPressed: () => AppDialogs.showLogoutDialog(context),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _UserStatusListTile extends StatelessWidget {
  const _UserStatusListTile({
    Key? key,
    required this.status,
    this.onTap,
  }) : super(key: key);

  final UserStatus status;
  final ValueChanged<UserStatus>? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: status.getStatusBadge(context),
      onTap: onTap != null ? () => onTap!(status) : null,
      title: Text(
        status.toString(),
        style: _style(
          context,
        ).copyWith(color: context.theme.userStatusTextStyle.color),
      ),
    );
  }
}

class _ChangeStatusTextFieldListTile extends StatefulWidget {
  const _ChangeStatusTextFieldListTile({
    Key? key,
    required this.initStatus,
  }) : super(key: key);

  final String initStatus;

  @override
  State<_ChangeStatusTextFieldListTile> createState() =>
      __ChangeStatusTextFieldListTileState();
}

class __ChangeStatusTextFieldListTileState
    extends State<_ChangeStatusTextFieldListTile> {
  late final ProfileCubit _profileCubit;
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  late final MyTheme theme;

  @override
  void initState() {
    super.initState();
    theme = context.theme;
    _profileCubit = context.read<ProfileCubit>();
    _controller.text = widget.initStatus;
  }

  bool _isEdit = false;

  Widget _buildTrailing(
    BuildContext context,
  ) =>
      InkWell(
        child: SvgPicture.asset(
          _isEdit ? Images.ic_tick : Images.ic_pencil,
          color: theme.unSelectedIconColor,
        ),
        onTap: _changeMode,
      );

  _changeMode() {
    setState(() => _isEdit = !_isEdit);
    if (_isEdit)
      _focusNode.requestFocus();
    else
      _profileCubit.changeStatus(_controller.text);
  }

  @override
  void didUpdateWidget(covariant _ChangeStatusTextFieldListTile oldWidget) {
    if (widget.initStatus != _controller.text) {
      _controller.text = widget.initStatus;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: SvgPicture.asset(
        Images.ic_emoji,
        color: theme.unSelectedIconColor,
      ),
      dense: true,
      trailing: _buildTrailing(context),
      title: TextField(
        style: _style(
          context,
          color:
              context.theme.isDarkTheme ? AppColors.white : AppColors.doveGray,
        ),
        readOnly: !_isEdit,
        controller: _controller,
        focusNode: _focusNode,
        decoration: InputDecoration(
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 0),
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
