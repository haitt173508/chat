import 'package:chat_365/common/images.dart';
import 'package:chat_365/core/constants/asset_path.dart';
import 'package:chat_365/core/constants/string_constants.dart';
import 'package:chat_365/core/theme/app_colors.dart';
import 'package:chat_365/modules/auth/modules/signup/screens/confirm_id_company.dart';
import 'package:chat_365/modules/auth/modules/signup/screens/set_up_account_information_screen.dart';
import 'package:chat_365/modules/auth/repo/auth_repo.dart';
import 'package:chat_365/modules/auth/widgets/auth_option_item.dart';
import 'package:chat_365/modules/auth/widgets/custom_auth_scaffold.dart';
import 'package:chat_365/router/app_pages.dart';
import 'package:chat_365/router/app_router.dart';
import 'package:chat_365/router/app_router_helper.dart';
import 'package:chat_365/utils/data/enums/auth_mode.dart';
import 'package:chat_365/utils/data/enums/user_type.dart';
import 'package:chat_365/utils/data/extensions/context_extension.dart';
import 'package:chat_365/utils/ui/app_border_and_radius.dart';
import 'package:chat_365/utils/ui/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class AuthOptionScreen extends StatefulWidget {
  final AuthMode mode;

  const AuthOptionScreen({Key? key, required this.mode}) : super(key: key);

  static const authModeArg = 'authModeArg';

  @override
  State<AuthOptionScreen> createState() => _AuthOptionScreenState();
}

class _AuthOptionScreenState extends State<AuthOptionScreen> {
  late bool showAll;

  @override
  void initState() {
    showAll = widget.mode == AuthMode.LOGIN ? false : true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomAuthScaffold(
      title: ' ',
      extendBodyBehindAppBar: true,
      showBottomBackgroundImage: true,
      useAppBar: true,
      child: Padding(
        padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
        child: Column(
          children: [
            Image.asset(
              Images.img_logo_non_text,
              width: 100,
            ),
            SizedBoxExt.h30,
            Text(
              '${StringConst.pleaseSelectAnAccount} ${widget.mode == AuthMode.LOGIN ? 'đăng nhập' : 'đăng ký'}!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                color: AppColors.text,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBoxExt.h40,
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: AuthOptionItem(
                      title: UserType.customer.authName,
                      icon: AssetPath.roundAccountBox,
                      onTap: () {
                        context.read<AuthRepo>().userType = UserType.customer;
                        if (widget.mode == AuthMode.LOGIN) {
                          AppRouterHelper.toLoginPage(
                            context,
                            userType: UserType.customer,
                          );
                        } else {
                          // AppRouter.toPage(context, AppPages.Auth_Register);
                          AppRouter.toPage(
                              context, AppPages.Auth_SetUpAccount_CreatCubit,
                              arguments: {
                                SetUpAccountInformationScreen.authModeArg:
                                    widget.mode
                              });
                        }
                      },
                    ),
                  ),
                  if (widget.mode == AuthMode.LOGIN)
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          showAll = !showAll;
                        });
                      },
                      child: Container(
                        child: SvgPicture.asset(
                          showAll ? Images.ic_collapse : Images.ic_expand,
                          color: context.theme.primaryColor,
                        ),
                        width: 75,
                        alignment: Alignment.center,
                        // padding: EdgeInsets.all(15),
                        margin: EdgeInsets.only(left: 20),
                        decoration: BoxDecoration(
                            color: context.theme.backgroundColor,
                            borderRadius:
                                AppBorderAndRadius.defaultBorderRadius,
                            border: AppBorderAndRadius.buttonBorder,
                            shape: BoxShape.rectangle,
                            boxShadow: [
                              BoxShadow(
                                color:
                                    context.theme.primaryColor.withOpacity(0.1),
                                spreadRadius: 0,
                                blurRadius: 8,
                                offset:
                                    Offset(0, 6), // changes position of shadow
                              ),
                            ]),
                      ),
                    ),
                ],
              ),
            ),
            SizedBoxExt.h30,
            Visibility(
              visible: showAll,
              child: Column(
                children: [
                  // SizedBoxExt.h30,
                  AuthOptionItem(
                      title: UserType.staff.authName,
                      icon: AssetPath.switch_account,
                      onTap: () {
                        context.read<AuthRepo>().userType = UserType.staff;
                        if (widget.mode == AuthMode.LOGIN) {
                          AppRouterHelper.toLoginPage(
                            context,
                            userType: UserType.staff,
                          );
                        } else {
                          AppRouter.toPage(
                              context, AppPages.Auth_ConfirmIdCompany,
                              arguments: {
                                ConfirmIdCompanyScreen.formLogin: widget.mode
                              });
                        }
                      }),
                  SizedBoxExt.h30,
                  AuthOptionItem(
                      title: UserType.company.authName,
                      icon: AssetPath.company,
                      onTap: () {
                        context.read<AuthRepo>().userType = UserType.company;
                        if (widget.mode == AuthMode.LOGIN) {
                          AppRouterHelper.toLoginPage(
                            context,
                            userType: UserType.company,
                          );
                        } else {
                          // AppRouterHelper.toRegisterPage(
                          //   context,
                          //   userType: UserType.company,
                          // );
                          AppRouter.toPage(
                              context, AppPages.Auth_SetUpAccount_CreatCubit,
                              arguments: {
                                SetUpAccountInformationScreen.authModeArg:
                                    widget.mode
                              });
                        }
                      }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
