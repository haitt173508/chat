import 'package:chat_365/common/images.dart';
import 'package:chat_365/common/widgets/button/fill_button.dart';
import 'package:chat_365/common/widgets/form/outline_text_form_field.dart';
import 'package:chat_365/common/widgets/label_form_field.dart';
import 'package:chat_365/core/constants/string_constants.dart';
import 'package:chat_365/core/theme/app_text_style.dart';
import 'package:chat_365/modules/auth/modules/signup/cubit/signup_cubit.dart';
import 'package:chat_365/modules/auth/modules/signup/screens/confirm_id_company.dart';
import 'package:chat_365/modules/auth/modules/signup/screens/confirm_otp_screen.dart';
import 'package:chat_365/modules/auth/modules/signup/screens/set_up_account_information_screen.dart';
import 'package:chat_365/modules/auth/repo/auth_repo.dart';
import 'package:chat_365/modules/auth/widgets/custom_auth_scaffold.dart';
import 'package:chat_365/router/app_pages.dart';
import 'package:chat_365/router/app_router.dart';
import 'package:chat_365/utils/data/enums/auth_mode.dart';
import 'package:chat_365/utils/data/enums/type_screen_to_otp.dart';
import 'package:chat_365/utils/data/enums/user_type.dart';
import 'package:chat_365/utils/data/extensions/context_extension.dart';
import 'package:chat_365/utils/helpers/validators.dart';
import 'package:chat_365/utils/ui/app_dialogs.dart';
import 'package:chat_365/utils/ui/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({
    Key? key,
    required this.userType,
  }) : super(key: key);
  final UserType userType;

  static const userTypeArg = 'userTypeArg';

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _form = GlobalKey<FormState>();
  // Phan nhap
  TextEditingController _textEditingController = TextEditingController();
  FocusNode _focusNode = FocusNode();
  // Ho tro phan validator
  String? Function(String?)? _validator;
  bool isChanging = false;

  _btnSendOTPPressedHandler(BuildContext context, String valueSendOtpTo) {
    SignUpCubit signUpCubit = context.read<SignUpCubit>();

    if (_form.currentState!.validate()) {
      signUpCubit.sendOTPForgetPassword(valueSendOtpTo, widget.userType, false);
    } else {
      // _form.currentState!.validate();
    }
  }

  _btnChangeScreenHandler(BuildContext context) {
    context.read<AuthRepo>().userType = widget.userType;
    if (widget.userType == UserType.customer) {
      AppRouter.replaceWithPage(context, AppPages.Auth_SetUpAccount_CreatCubit,
          arguments: {
            SetUpAccountInformationScreen.authModeArg: AuthMode.LOGIN
          });
    } else if (widget.userType == UserType.staff) {
      AppRouter.replaceWithPage(context, AppPages.Auth_ConfirmIdCompany,
          arguments: {ConfirmIdCompanyScreen.formLogin: AuthMode.LOGIN});
    } else if (widget.userType == UserType.company) {
      AppRouter.replaceWithPage(context, AppPages.Auth_SetUpAccount_CreatCubit,
          arguments: {
            SetUpAccountInformationScreen.authModeArg: AuthMode.LOGIN
          });
    }
  }

  // Check type value input
  // bool isPhoneNumber = true;

  @override
  void initState() {
    _validator = (value) => Validator.requiredInputPhoneOrEmailValidator(
        _textEditingController.text);

    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<SignUpCubit>();
    return BlocListener<SignUpCubit, SignUpState>(
      listener: (context, state) {
        if (state is SendOtpStateLoad) {
          AppDialogs.showLoadingCircle(context);
          isChanging = false;
        } else if (state is SendOtpStateSuccess) {
          AppDialogs.hideLoadingCircle(context);
          AppRouter.toPage(context, AppPages.Auth_ConfirmOTP,
              blocValue: bloc,
              arguments: {
                ConfirmOTPScreen.isPhoneNumberKey:
                    !_textEditingController.text.contains('@'),
                ConfirmOTPScreen.idTypeScreenToOtp:
                    TypeScreenToOtp.FORGOTPASSWORD
              });
        } else if (state is SendOtpStateError) {
          AppDialogs.hideLoadingCircle(context);
          // widget.userType == UserType.customer
          //     ? AppDialogs.toast(state.error)
          //     : AppDialogs.toast(state.error);
          // if (context.read<SignUpCubit>().error != null) {
          //   // AppDialogs.toast(context.read<SignUpCubit>().error!.error);
          // } else {}
          if (context.read<SignUpCubit>().error != null) {
            if (context.read<SignUpCubit>().error!.code == 200) {
              setState(() {
                _validator = (value) =>
                    context.read<SignUpCubit>().contactSignUp.contains('@')
                        ? 'Email không tồn tại'
                        : 'Số điện thoại không tồn tại';
              });
            }
          } else {
            AppDialogs.toast('Đã xảy ra lỗi vui lòng thử lại sau');
          }
        }
      },
      child: CustomAuthScaffold(
        title: StringConst.forgotPasswordNoQuestionMark,
        extendBodyBehindAppBar: false,
        useAppBar: true,
        child: Container(
          padding: EdgeInsets.all(20),
          child: Form(
            key: _form,
            child: Column(
              children: [
                SizedBoxExt.h40,
                SizedBoxExt.h40,
                Text(
                  StringConst.forgotYourPassword,
                  style: AppTextStyles.regularW700(context,
                      size: 18, color: context.theme.textColor),
                ),
                SizedBoxExt.h20,
                Text(
                  StringConst.contentForgotPasswordEmployee,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.regularW400(context,
                      size: 14, color: context.theme.textColor),
                ),
                SizedBoxExt.h40,
                // widget.userType == UserType.customer ||
                //         widget.userType == UserType.staff
                //     ?
                LabelFormField(title: 'Tài khoản đăng nhập', isRequired: true),
                OutlineTextFormField(
                  key: ValueKey(_textEditingController),
                  controller: _textEditingController,
                  focusNode: _focusNode,
                  style: context.theme.inputStyle,
                  // keyboardType: TextInputType.,
                  validator: _validator,
                  onChanged: (value) {
                    isChanging = true;
                    if (isChanging)
                      setState(() {
                        _validator = (value) =>
                            Validator.requiredInputPhoneOrEmailValidator(
                                _textEditingController.text);
                        // Validator.requiredInputPhoneOrEmailValidator(
                        //     _textEditingController.text,
                        //     StringConst.inputPhoneNumberOrEmail);
                      });
                  },
                  decoration: context.theme.inputDecoration.copyWith(
                    hintText: StringConst.inputPhoneOrEmail,
                    prefixIcon: WidgetUtils.getFormFieldColorPrefixIcon(
                      Images.ic_person,
                      color: context.theme.iconColor,
                    ),
                    hintStyle: context.theme.hintStyle,
                  ),
                ),
                // : OutlineTextFormField(
                //     controller: _textEditingController,
                //     focusNode: _focusNode,
                //     style: context.theme.inputStyle,
                //     validator: _validator,
                //     onChanged: (value) {
                //       //Doi vaidator ve xac nhan dinh dang email neu validator xac nhan loi(email trung);
                //       if (_validator !=
                //           (value) => Validator.inputEmailValidator(
                //               _textEditingController.text))
                //         setState(() {
                //           _validator = (value) =>
                //               Validator.inputEmailValidator(
                //                   _textEditingController.text);
                //         });
                //     },
                //     decoration: context.theme.inputDecoration.copyWith(
                //           hintText: StringConst.inputEmail,
                //           prefixIcon:
                //               WidgetUtils.getFormFieldColorPrefixIcon(
                //             // AssetPath.phone,
                //             AssetPath.email,
                //             color: context.theme.iconColor,
                //           ),
                //           hintStyle: context.theme.hintStyle,
                //         ),
                //   ),
                SizedBoxExt.h40,
                FillButton(
                  width: double.infinity,
                  title: StringConst.getVerificationCode,
                  onPressed: () => _btnSendOTPPressedHandler(
                      context, _textEditingController.text),
                  // _btnSendToEmailPressedHandler(
                  //     context, _textEditingController.text),
                ),
                SizedBoxExt.h30,
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      StringConst.doNotHaveAnAccount,
                      style: TextStyle(
                        fontSize: 16,
                        color: context.theme.textColor,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    InkWell(
                      onTap: () => _btnChangeScreenHandler(context),
                      child: Text(
                        StringConst.signUp,
                        style: TextStyle(
                          fontSize: 18,
                          color: context.theme.primaryColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    )
                  ],
                ),
                // MediaQuery.of(context).viewInsets.bottom >
                //         MediaQuery.of(context).size.width * 0.30133333333333334
                //     ? SizedBox(
                //         height: MediaQuery.of(context).viewInsets.bottom -
                //             MediaQuery.of(context).size.width *
                //                 0.30133333333333334,
                //       )
                //     : SizedBox(
                //         height: MediaQuery.of(context).viewInsets.bottom,
                //       ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
