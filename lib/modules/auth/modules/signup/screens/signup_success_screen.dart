import 'package:chat_365/common/images.dart';
import 'package:chat_365/common/widgets/button/fill_button.dart';
import 'package:chat_365/core/theme/app_text_style.dart';
import 'package:chat_365/modules/auth/modules/login/cubit/login_cubit.dart';
import 'package:chat_365/modules/auth/modules/login/models/login_model.dart';
import 'package:chat_365/modules/auth/widgets/custom_auth_scaffold.dart';
import 'package:chat_365/router/app_pages.dart';
import 'package:chat_365/router/app_router.dart';
import 'package:chat_365/utils/data/enums/user_type.dart';
import 'package:chat_365/utils/data/extensions/context_extension.dart';
import 'package:chat_365/utils/ui/app_dialogs.dart';
import 'package:chat_365/utils/ui/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SignUpSuccessScreen extends StatefulWidget {
  const SignUpSuccessScreen(
      {Key? key,
      required this.phoneNumber,
      required this.password,
      required this.userType})
      : super(key: key);

  final String phoneNumber;
  final String password;
  final UserType userType;
  @override
  _SignUpSuccessScreenState createState() => _SignUpSuccessScreenState();
}

class _SignUpSuccessScreenState extends State<SignUpSuccessScreen> {
  _btnGoToChat(BuildContext context) async {
    // Tai khoan cong ty va nhan vien dang ky xong phai dang nhap 1 roi moi dang nhap duoc trong chat
    // if (widget.userType != UserType.customer) {
    //   await context.read<LoginCubit>().loginAccountCompany(
    //       widget.userType, LoginModel(widget.phoneNumber, widget.password));
    // }

    context.read<LoginCubit>().login(
        widget.userType, LoginModel(widget.phoneNumber, widget.password));
  }

  @override
  Widget build(BuildContext context) {
    return CustomAuthScaffold(
      useAppBar: true,
      child: WillPopScope(
        onWillPop: () async => false,
        child: BlocListener<LoginCubit, LoginState>(
          listener: (context, state) {
            //!Phai dat o day moi hien len duoc
            if (state is LoginStateUnBrowser) {
              // AppDialogs.hideLoadingCircle(context);
              AppDialogs.showMessConfirm(context, state.nameCompany);
            }
          },
          child: Container(
            padding: EdgeInsets.all(20),
            child: SingleChildScrollView(
              physics: ScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBoxExt.h70,
                  SvgPicture.asset(
                    Images.ic_checked,
                    width: 150,
                  ),
                  SizedBoxExt.h50,
                  Text(
                    'Chúc mừng bạn đã đăng ký tài khoản thành công!',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.regularW700(context, size: 18),
                  ),
                  // if (widget.userType == UserType.staff) SizedBoxExt.h20,
                  // if (widget.userType == UserType.staff) Text(
                  //   'Tai',
                  //   textAlign: TextAlign.center,
                  //   style: AppTextStyles.regularW700(context, size: 18),
                  // ),
                  SizedBoxExt.h70,
                  SizedBoxExt.h10,
                  FillButton(
                    width: double.infinity,
                    title: 'Bắt đầu cuộc trò chuyện',
                    onPressed: () => _btnGoToChat(context),
                  ),
                  // if(MediaQuery.of(context).size.height < 200)
                  SizedBoxExt.h20,

                  FillButton(
                    width: double.infinity,
                    backgroundColor: context.theme.backgroundColor,
                    title: 'Trang chủ',
                    style: AppTextStyles.button(context)
                        .copyWith(color: context.theme.primaryColor),
                    onPressed: () =>
                        AppRouter.backToPage(context, AppPages.Intro),
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
