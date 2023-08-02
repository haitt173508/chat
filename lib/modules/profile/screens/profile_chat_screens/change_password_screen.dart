import 'package:chat_365/common/widgets/button/fill_button.dart';
import 'package:chat_365/common/widgets/label_form_field.dart';
import 'package:chat_365/core/constants/chat_socket_event.dart';
import 'package:chat_365/core/constants/string_constants.dart';
import 'package:chat_365/core/interfaces/interface_user_info.dart';
import 'package:chat_365/modules/auth/modules/signup/cubit/signup_cubit.dart';
import 'package:chat_365/modules/auth/repo/auth_repo.dart';
import 'package:chat_365/modules/auth/widgets/password_field.dart';
import 'package:chat_365/utils/data/clients/chat_client.dart';
import 'package:chat_365/utils/data/extensions/context_extension.dart';
import 'package:chat_365/utils/helpers/validators.dart';
import 'package:chat_365/utils/ui/app_dialogs.dart';
import 'package:chat_365/utils/ui/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({
    Key? key,
    required this.userInfo,
    required this.isGroup,
  }) : super(key: key);

  static const userInfoArg = 'userInfoArg';
  static const isGroupArg = 'isGroupArg';

  final IUserInfo userInfo;
  final bool isGroup;

  @override
  _UpdatePasswordScreenState createState() => _UpdatePasswordScreenState();
}

class _UpdatePasswordScreenState extends State<ChangePasswordScreen> {
  final _form = GlobalKey<FormState>();
  TextEditingController _textEditingOldPassController = TextEditingController();
  TextEditingController _textEditingPass1Controller = TextEditingController();
  TextEditingController _textEditingPass2Controller = TextEditingController();

  //Dung cho validator cua nhap lai mat khau
  bool isChanging = false;
  String? Function(String?)? _oldValidator;

  //*Dung cho viec unfocus se validate phan nhap lai mat khau
  final FocusNode _focusRepeatPassword = FocusNode();
  final _rePasswordKey = GlobalKey<FormFieldState>();

  _btnChangePassword(BuildContext context) {
    SignUpCubit signUpCubit = context.read<SignUpCubit>();
    setState(() {
      isChanging = false;
    });
    if (_form.currentState!.validate() == true) {
      signUpCubit.changePassword(
          email: widget.userInfo.email!,
          oldPassword: _textEditingOldPassController.text,
          newPassword: _textEditingPass1Controller.text,
          idType: context.read<AuthRepo>().userType.id,
          idUser: widget.userInfo.id);
    } else {
      AppDialogs.toast(StringConst.recheckInfoInput);
    }
  }

  @override
  void initState() {
    //* Kiem tra nhap lai mat khau co dung khong
    _oldValidator = (value) =>
        Validator.validateStringBlank(value, StringConst.inputOldPassword);
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
    _textEditingOldPassController.dispose();
    _textEditingPass2Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    late List<Widget> childrenCustomer = [
      LabelFormField(title: StringConst.inputOldPassword, isRequired: true),
      PasswordField(
        hintText: StringConst.inputOldPassword,
        controller: _textEditingOldPassController,
        validator: _oldValidator,
        onChanged: (value) {
          if (_oldValidator !=
              (value) => Validator.validateStringBlank(
                  value, StringConst.inputOldPassword)) {
            setState(() {
              _oldValidator = (value) => Validator.validateStringBlank(
                  value, StringConst.inputOldPassword);
            });
          }
          ;
        },
      ),
      SizedBoxExt.h20,

      LabelFormField(title: StringConst.inputNewPassword, isRequired: true),
      PasswordField(
        hintText: StringConst.inputNewPassword,
        controller: _textEditingPass1Controller,
        validator: (value) => Validator.inputPasswordValidator(value),
      ),
      SizedBoxExt.h20,
      LabelFormField(title: StringConst.reInputNewPassword, isRequired: true),
      PasswordField(
        key: _rePasswordKey,
        focusNode: _focusRepeatPassword,
        hintText: StringConst.reInputNewPassword,
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
        } else if (state is ChangePassStateSuccess) {
          AppDialogs.hideLoadingCircle(context);
          // _textEditingOldPassController.text = '';
          // _textEditingPass1Controller.text = '';
          // _textEditingPass2Controller.text = '';
          // AppDialogs.toast(state.message);
          AppDialogs.showChangePasswordSuccessDialog(
            context,
            () {
              chatClient.emit(ChatSocketEvent.logoutAllDevice,
                  [context.userInfo().id, "chat365"]);
            },
          );
        } else if (state is ChangePassStateError) {
          AppDialogs.hideLoadingCircle(context);
          //*Gan vaildate sai mat khau cu
          if (context.read<SignUpCubit>().error != null) {
            setState(() {
              _oldValidator =
                  (value) => context.read<SignUpCubit>().error!.messages;
            });
          } else
            AppDialogs.toast(state.error);
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text('Đổi mật khẩu'),
          elevation: 1,
        ),
        body: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              padding: EdgeInsets.all(20),
              child: Form(
                key: _form,
                child: Container(
                  child: SingleChildScrollView(
                    physics: ScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: childrenCustomer,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 58,
              child: Container(
                // width: MediaQuery.of(context).size
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: FillButton(
                    width: MediaQuery.of(context).size.width / 3,
                    title: StringConst.save,
                    onPressed: () => _btnChangePassword(context),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
