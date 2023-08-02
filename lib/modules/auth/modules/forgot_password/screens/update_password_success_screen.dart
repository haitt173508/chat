import 'package:chat_365/common/images.dart';
import 'package:chat_365/common/widgets/button/fill_button.dart';
import 'package:chat_365/core/theme/app_text_style.dart';
import 'package:chat_365/modules/auth/modules/login/cubit/login_cubit.dart';
import 'package:chat_365/modules/auth/modules/login/models/login_model.dart';
import 'package:chat_365/modules/auth/widgets/custom_auth_scaffold.dart';
import 'package:chat_365/utils/data/enums/user_type.dart';
import 'package:chat_365/utils/ui/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class UpdateSuccessScreen extends StatefulWidget {
  const UpdateSuccessScreen(
      {Key? key,
      required this.phoneNumber,
      required this.password,
      required this.userType})
      : super(key: key);

  final String phoneNumber;
  final String password;
  final UserType userType;
  @override
  _UpdateSuccessScreenState createState() => _UpdateSuccessScreenState();
}

class _UpdateSuccessScreenState extends State<UpdateSuccessScreen> {
  _btnGoToChat(BuildContext context) {
    context.read<LoginCubit>().login(
        widget.userType, LoginModel(widget.phoneNumber, widget.password));
  }

  @override
  Widget build(BuildContext context) {
    return CustomAuthScaffold(
      useAppBar: true,
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
              SizedBoxExt.h70,
              SizedBoxExt.h10,
              FillButton(
                width: double.infinity,
                title: 'Đi đến Chat365',
                onPressed: () => _btnGoToChat(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
