import 'package:chat_365/common/widgets/button/fill_button.dart';
import 'package:chat_365/common/widgets/label_form_field.dart';
import 'package:chat_365/core/constants/string_constants.dart';
import 'package:chat_365/core/theme/app_text_style.dart';
import 'package:chat_365/modules/auth/modules/signup/cubit/signup_cubit.dart';
import 'package:chat_365/modules/auth/widgets/custom_auth_scaffold.dart';
import 'package:chat_365/modules/auth/widgets/password_field.dart';
import 'package:chat_365/utils/data/enums/user_type.dart';
import 'package:chat_365/utils/helpers/validators.dart';
import 'package:chat_365/utils/ui/app_dialogs.dart';
import 'package:chat_365/utils/ui/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UpdatePasswordScreen extends StatefulWidget {
  const UpdatePasswordScreen({
    Key? key,
    required this.userType,
  }) : super(key: key);
  final UserType userType;
  static const userTypeArg = 'userTypeArg';

  @override
  _UpdatePasswordScreenState createState() => _UpdatePasswordScreenState();
}

class _UpdatePasswordScreenState extends State<UpdatePasswordScreen> {
  final _form = GlobalKey<FormState>();
  TextEditingController _textEditingPass1Controller = TextEditingController();
  TextEditingController _textEditingPass2Controller = TextEditingController();
  //Dung cho validator cua nhap lai mat khau
  bool isChanging = false;

  //*Dung cho viec unfocus se validate phan nhap lai mat khau
  final FocusNode _focusRepeatPassword = FocusNode();
  final _rePasswordKey = GlobalKey<FormFieldState>();

  _btnUpdatePassword(BuildContext context) {
    SignUpCubit signUpCubit = context.read<SignUpCubit>();
    setState(() {
      isChanging = false;
    });
    if (_form.currentState!.validate() == true) {
      signUpCubit.updatePassword(
          _textEditingPass1Controller.text, widget.userType.id);
    } else {
      AppDialogs.toast(StringConst.recheckInfoInput);
    }
  }

  @override
  void initState() {
    //* Kiem tra nhap lai mat khau co dung khong
    _focusRepeatPassword.addListener(() {
      if (!_focusRepeatPassword.hasFocus) {
        setState(() {
          isChanging = false;
        });
        if (_rePasswordKey.currentState != null)
          _rePasswordKey.currentState!.validate();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _textEditingPass1Controller.dispose();
    _textEditingPass2Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    late List<Widget> childrenCustomer = [
      LabelFormField(title: StringConst.inputPassword, isRequired: true),
      PasswordField(
        hintText: StringConst.inputPassword,
        controller: _textEditingPass1Controller,
        validator: (value) => Validator.inputPasswordValidator(value),
      ),
      SizedBoxExt.h20,
      LabelFormField(title: StringConst.reInputPassword, isRequired: true),
      PasswordField(
        key: _rePasswordKey,
        focusNode: _focusRepeatPassword,
        hintText: StringConst.reInputPassword,
        controller: _textEditingPass2Controller,
        onChanged: (value) {
          setState(() {
            isChanging = true;
          });
        },
        validator: (value) => Validator.reInputPasswordValidator(
            value, _textEditingPass1Controller.text, isChanging),
      ),
      SizedBoxExt.h20,
      FillButton(
        width: double.infinity,
        title: StringConst.update,
        onPressed: () => _btnUpdatePassword(context),
      ),
      // SizedBoxExt.h30,
      // Row(
      //   mainAxisSize: MainAxisSize.min,
      //   children: [
      //     Text(
      //       StringConst.doNotHaveAnAccount,
      //       style: TextStyle(
      //         fontSize: 16,
      //         color: context.theme.textColor,
      //       ),
      //     ),
      //     SizedBox(
      //       width: 10,
      //     ),
      //     InkWell(
      //       onTap: () => widget.userType == UserType.customer
      //           ? _btnCreateAccountPressedHandler(context)
      //           : AppDialogs.toast('Tính năng đang phát triển.'),
      //       child: Text(
      //         StringConst.signUp,
      //         style: TextStyle(
      //           fontSize: 18,
      //           color: AppColors.primary,
      //           fontWeight: FontWeight.w700,
      //         ),
      //       ),
      //     )
      //   ],
      // )
    ];

    return BlocListener<SignUpCubit, SignUpState>(
      listener: (context, state) {
        if (state is UpdatePassStateLoad) {
          AppDialogs.showLoadingCircle(context);
        } else if (state is UpdatePassStateSuccess) {
          AppDialogs.hideLoadingCircle(context);
          // AppDialogs.toast(state.message);
          AppDialogs.showUpdatePasswordSuccessDialog(context);
        } else if (state is UpdatePassStateError) {
          AppDialogs.hideLoadingCircle(context);
          AppDialogs.toast(state.error);
        }
      },
      child: CustomAuthScaffold(
        title: StringConst.updatePassword,
        extendBodyBehindAppBar: false,
        useAppBar: true,
        child: Container(
          padding: EdgeInsets.all(20),
          child: Form(
            key: _form,
            child: SingleChildScrollView(
              physics: ScrollPhysics(),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBoxExt.h40,
                    SizedBoxExt.h40,
                    Text(
                      StringConst.confirmOtpSuccess,
                      style: AppTextStyles.regularW700(context, size: 18),
                    ),
                    SizedBoxExt.h20,
                    Text(
                      StringConst.contentCongratulations,
                      textAlign: TextAlign.center,
                    ),
                    SizedBoxExt.h30,
                    Column(
                      children:
                          // context.read<AuthRepo>().userType ==
                          //         UserType.customer
                          //     ?
                          childrenCustomer,
                      // : context.read<AuthRepo>().userType == UserType.staff
                      //     ? childrenEmployee
                      //     : [],
                    ),
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}
