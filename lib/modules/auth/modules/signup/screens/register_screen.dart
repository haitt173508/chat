import 'package:chat_365/common/widgets/button/fill_button.dart';
import 'package:chat_365/common/widgets/form/outline_text_form_field.dart';
import 'package:chat_365/core/constants/asset_path.dart';
import 'package:chat_365/core/constants/string_constants.dart';
import 'package:chat_365/core/theme/app_colors.dart';
import 'package:chat_365/core/theme/app_text_style.dart';
import 'package:chat_365/modules/auth/modules/signup/cubit/signup_cubit.dart';
import 'package:chat_365/modules/auth/modules/signup/screens/confirm_otp_screen.dart';
import 'package:chat_365/modules/auth/repo/auth_repo.dart';
import 'package:chat_365/modules/auth/widgets/custom_auth_scaffold.dart';
import 'package:chat_365/router/app_pages.dart';
import 'package:chat_365/router/app_router.dart';
import 'package:chat_365/router/app_router_helper.dart';
import 'package:chat_365/utils/data/enums/auth_mode.dart';
import 'package:chat_365/utils/data/enums/type_screen_to_otp.dart';
import 'package:chat_365/utils/data/extensions/context_extension.dart';
import 'package:chat_365/utils/helpers/validators.dart';
import 'package:chat_365/utils/ui/app_dialogs.dart';
import 'package:chat_365/utils/ui/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);
  static const userTypeArg = 'userTypeArg';

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _form = GlobalKey<FormState>();
  TextEditingController _textEditingController = TextEditingController();
  String? Function(String?)? _validator;
  FocusNode _focusNode = FocusNode();
  _btnSendToEmailPressedHandler(BuildContext context, String email) {
    SignUpCubit signUpCubit = context.read<SignUpCubit>();

    if (_form.currentState!.validate()) {
      // signUpCubit.getOTP(email);
    } else {
      // _form.currentState!.validate();
    }
  }

  _btnLoginPressHandler(BuildContext context) => AppRouterHelper.toLoginPage(
        context,
        userType: context.read<AuthRepo>().userType,
        authMode: AuthMode.REGISTER,
      );

  @override
  void initState() {
    _validator = Validator.inputEmailValidator;
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
        if (state is ReSendOtpStateLoad) {
          AppDialogs.showLoadingCircle(context);
        } else if (state is SendOtpStateSuccess) {
          AppDialogs.hideLoadingCircle(context);
          AppRouter.toPage(context, AppPages.Auth_ConfirmOTP,
              blocValue: bloc,
              arguments: {
                ConfirmOTPScreen.idTypeScreenToOtp:
                    TypeScreenToOtp.CONFIRMACCOUNT,
                ConfirmOTPScreen.isPhoneNumberKey: false,
              });
        } else if (state is SendOtpExistEmailStateError) {
          AppDialogs.hideLoadingCircle(context);
          AppDialogs.showLoginDialog(context);
          setState(() {
            _validator = (p0) => state.error;
          });
        } else if (state is SendOtpStateError) {
          AppDialogs.hideLoadingCircle(context);
          AppDialogs.toast(state.error);
        }
      },
      child: CustomAuthScaffold(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Form(
            key: _form,
            child: Column(
              children: [
                SizedBoxExt.h50,
                Image.asset(
                  AssetPath.logo,
                  height: 100,
                ),
                SizedBoxExt.h30,
                Text(
                  StringConst.signUp,
                  style: AppTextStyles.title.copyWith(
                    color: AppColors.primary,
                  ),
                ),
                SizedBoxExt.h50,
                OutlineTextFormField(
                  controller: _textEditingController,
                  focusNode: _focusNode,
                  style: context.theme.inputStyle,
                  validator: _validator,
                  onChanged: (value) {
                    //Doi vaidator ve xac nhan dinh dang email neu validator xac nhan loi(email trung);
                    if (_validator != Validator.inputEmailValidator)
                      setState(() {
                        _validator = Validator.inputEmailValidator;
                      });
                  },
                  decoration: context.theme.inputDecoration.copyWith(
                    hintText: StringConst.inputEmail,
                    prefixIcon: WidgetUtils.getFormFieldColorPrefixIcon(
                      AssetPath.email,
                      color: context.theme.iconColor,
                    ),
                    hintStyle: context.theme.hintStyle,
                  ),
                ),
                SizedBoxExt.h40,
                FillButton(
                  width: double.infinity,
                  title: StringConst.getVerificationCode,
                  onPressed: () => _btnSendToEmailPressedHandler(
                      context, _textEditingController.text),
                ),
                SizedBoxExt.h30,
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      StringConst.doHaveAnAccount,
                      style: TextStyle(
                        fontSize: 16,
                        color: context.theme.textColor,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    InkWell(
                      onTap: () => _btnLoginPressHandler(context),
                      child: Text(
                        StringConst.login,
                        style: TextStyle(
                          fontSize: 18,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
