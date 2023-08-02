import 'package:chat_365/common/images.dart';
import 'package:chat_365/common/widgets/button/fill_button.dart';
import 'package:chat_365/common/widgets/form/outline_text_form_field.dart';
import 'package:chat_365/core/constants/string_constants.dart';
import 'package:chat_365/core/theme/app_colors.dart';
import 'package:chat_365/core/theme/app_text_style.dart';
import 'package:chat_365/modules/auth/modules/signup/cubit/signup_cubit.dart';
import 'package:chat_365/modules/auth/modules/signup/screens/set_up_account_information_screen.dart';
import 'package:chat_365/modules/auth/repo/auth_repo.dart';
import 'package:chat_365/modules/auth/widgets/custom_auth_scaffold.dart';
import 'package:chat_365/router/app_pages.dart';
import 'package:chat_365/router/app_router.dart';
import 'package:chat_365/router/app_router_helper.dart';
import 'package:chat_365/utils/data/enums/auth_mode.dart';
import 'package:chat_365/utils/data/extensions/context_extension.dart';
import 'package:chat_365/utils/helpers/validators.dart';
import 'package:chat_365/utils/ui/app_border_and_radius.dart';
import 'package:chat_365/utils/ui/app_dialogs.dart';
import 'package:chat_365/utils/ui/app_padding.dart';
import 'package:chat_365/utils/ui/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Dung cho radio button
enum SelectInputID { qr, input }

class ConfirmIdCompanyScreen extends StatefulWidget {
  const ConfirmIdCompanyScreen({Key? key, required this.isFormLoginScreen})
      : super(key: key);

  final bool isFormLoginScreen;
  static const formLogin = 'formLogin';
  @override
  _ConfirmIdCompanyScreenState createState() => _ConfirmIdCompanyScreenState();
}

class _ConfirmIdCompanyScreenState extends State<ConfirmIdCompanyScreen> {
  TextEditingController _textEditingController = TextEditingController();
  FocusNode _focusNode = FocusNode();

  final _form = GlobalKey<FormState>();
  // Gan loi thanh validator
  String? Function(String?)? _validator;

  // Lay do dai cua widget
  final _radioKey = GlobalKey();

  /// De chon cach nhap id cong ty;
  SelectInputID _valueSelect = SelectInputID.qr;

  // Dung cho auto cuon
  ScrollController _listScrollController = ScrollController();

  _btnCompareIdCompanyPressedHandler(BuildContext context, String idCompany) {
    SignUpCubit signUpCubit = context.read<SignUpCubit>();
    if (_form.currentState!.validate()) {
      signUpCubit.checkIdCompany(idCompany);
    } else {
      _form.currentState!.validate();
    }
  }

  _scrollToBottom() {
    if (_listScrollController.hasClients) {
      final position = _listScrollController.position.maxScrollExtent;
      _listScrollController.jumpTo(position);
    }
  }

  @override
  void initState() {
    _focusNode.addListener(() {
      Future.delayed(
        const Duration(milliseconds: 200),
        _scrollToBottom,
      );
    });
    _validator = (p0) => Validator.validateStringBlocSpecialCharacters(
        _textEditingController.text, StringConst.inputIdCompany);
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _focusNode.dispose();
    _listScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<SignUpCubit>();

    return BlocListener<SignUpCubit, SignUpState>(
      listener: (context, state) {
        if (state is CompareIdCompanyStateLoad) {
          AppDialogs.showLoadingCircle(context);
        }
        if (state is CompareIdCompanyStateSuccess &&
            _valueSelect == SelectInputID.input) {
          AppDialogs.hideLoadingCircle(context);
          AppRouter.toPage(context, AppPages.Auth_SetUpAccount,
              blocValue: bloc,
              arguments: {
                SetUpAccountInformationScreen.authModeArg:
                    widget.isFormLoginScreen
                        ? AuthMode.LOGIN
                        : AuthMode.REGISTER
              });
        }
        if (state is CompareIdCompanyStateError) {
          AppDialogs.hideLoadingCircle(context);
          AppDialogs.toast(state.error);
          setState(() {
            if (bloc.error != null) {
              if (bloc.error!.code == 200) {
                _validator = (p0) => bloc.error!.messages;
              }
            }
          });
        }
      },
      child: CustomAuthScaffold(
        useAppBar: true,
        extendBodyBehindAppBar: true,
        scrollAble: false,
        child: Container(
          padding: EdgeInsets.all(20).copyWith(top: 0, bottom: 0),
          child: Form(
            key: _form,
            child: Column(
              children: [
                Image.asset(
                  Images.img_logo_non_text,
                  width: 100,
                ),
                SizedBoxExt.h30,
                Text(
                  StringConst.signUpEmployee,
                  style: TextStyle(
                    fontSize: 24,
                    color: context.theme.primaryColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBoxExt.h40,
                Container(
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 2 / 3,
                  ),

                  // Phan hien chuc nang cua man
                  child: ScrollConfiguration(
                    behavior: ScrollBehavior(),
                    child: MediaQuery.removePadding(
                      context: context,
                      removeTop: true,
                      child: ListView(
                        padding: AppPadding.paddingAll4,
                        shrinkWrap: true,
                        physics: ScrollPhysics(),
                        controller: _listScrollController,
                        children: [
                          Container(
                            padding: AppPadding.paddingAll20,
                            decoration: BoxDecoration(
                                color: context.theme.backgroundColor,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                      color: AppColors.black99,
                                      spreadRadius: 0,
                                      blurRadius: 4)
                                ]),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // Phan chuc nang quet qr code
                                Row(
                                  children: [
                                    Radio(
                                      value: SelectInputID.qr,
                                      groupValue: _valueSelect,
                                      onChanged: (SelectInputID? value) {
                                        setState(() {
                                          _valueSelect = value!;
                                        });
                                      },
                                    ),
                                    Expanded(
                                      child: Text(
                                        '${StringConst.tapQRToScan}:',
                                        style: AppTextStyles.regularW500(
                                            context,
                                            size: 16,
                                            lineHeight: 18.75,
                                            color:
                                                _valueSelect == SelectInputID.qr
                                                    ? context.theme.primaryColor
                                                    : context.theme.textColor),
                                      ),
                                    ),
                                  ],
                                ),
                                InkWell(
                                  onTap: () {
                                    if (_valueSelect == SelectInputID.qr)
                                      AppRouter.toPage(
                                          context, AppPages.Auth_ScanQR,
                                          blocValue: bloc);
                                  },
                                  child: Image.asset(
                                    Images.img_qr,
                                    width: 90,
                                    color:
                                        // _valueSelect == SelectInputID.input
                                        //     ? context
                                        //         .theme
                                        //         .backgroundColor
                                        //         .withOpacity(1)
                                        //     :
                                        Colors.transparent,
                                    colorBlendMode: BlendMode.hardLight,
                                  ),
                                ),
                                SizedBoxExt.h15,
                                // Phan chuc nang nhap id cong ty
                                Row(
                                  children: [
                                    Radio(
                                      key: _radioKey,
                                      groupValue: _valueSelect,
                                      onChanged: (SelectInputID? value) {
                                        setState(() {
                                          _valueSelect = value!;
                                        });
                                      },
                                      value: SelectInputID.input,
                                    ),
                                    Expanded(
                                      child: Text(
                                        '${StringConst.inputIdCompanyProvideByHR}:',
                                        style: AppTextStyles.regularW500(
                                            context,
                                            size: 16,
                                            lineHeight: 18.75,
                                            color: _valueSelect ==
                                                    SelectInputID.input
                                                ? context.theme.primaryColor
                                                : context.theme.textColor),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 50.0),
                                  child: OutlineTextFormField(
                                    enable: _valueSelect == SelectInputID.input,
                                    keyboardType: TextInputType.number,
                                    controller: _textEditingController,
                                    focusNode: _focusNode,
                                    style: context.theme.inputStyle,
                                    onChanged: (value) {
                                      if (_validator !=
                                          (p0) => Validator
                                              .validateStringBlocSpecialCharacters(
                                                  _textEditingController.text,
                                                  StringConst.inputIdCompany)) {
                                        setState(() {
                                          _validator = (p0) => Validator
                                              .validateStringBlocSpecialCharacters(
                                                  _textEditingController.text,
                                                  StringConst.inputIdCompany);
                                        });
                                      }
                                    },
                                    validator: _validator,
                                    decoration: context.theme.inputDecoration
                                        .copyWith(
                                            hintText:
                                                StringConst.inputIdCompany,
                                            hintStyle: context.theme.hintStyle,
                                            errorBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: _valueSelect ==
                                                          SelectInputID.input
                                                      ? Colors.red
                                                      : AppColors
                                                          .lightThemeDisableColor),
                                              borderRadius: AppBorderAndRadius
                                                  .formBorderRadius,
                                            ),
                                            fillColor: _valueSelect ==
                                                    SelectInputID.input
                                                ? context.theme.backgroundColor
                                                : context.theme.disableColor),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (_valueSelect == SelectInputID.input)
                            SizedBoxExt.h30,

                          // Nut xac thuc ma cong ty
                          if (_valueSelect == SelectInputID.input)
                            FillButton(
                              width: double.infinity,
                              title: 'Xác thực mã công ty',
                              onPressed: () =>
                                  _btnCompareIdCompanyPressedHandler(
                                      context, _textEditingController.text),
                            ),
                          SizedBoxExt.h30,
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                StringConst.doHaveAnAccount,
                                style: TextStyle(
                                  fontSize: 16,
                                  shadows: <Shadow>[
                                    Shadow(
                                      offset: Offset(0, 0),
                                      blurRadius: 4.0,
                                      color: context.theme.backgroundColor,
                                    ),
                                  ],
                                  color: context.theme.textColor,
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              InkWell(
                                onTap: () {
                                  if (widget.isFormLoginScreen) {
                                    AppRouter.back(context);
                                  } else
                                    AppRouterHelper.toLoginPage(context,
                                        userType:
                                            context.read<AuthRepo>().userType,
                                        authMode: AuthMode.REGISTER);
                                },
                                child: Text(
                                  StringConst.login,
                                  style: TextStyle(
                                    fontSize: 18,
                                    shadows: <Shadow>[
                                      Shadow(
                                        offset: Offset(0, 0),
                                        blurRadius: 4.0,
                                        color: context.theme.backgroundColor,
                                      ),
                                    ],
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              )
                            ],
                          ),
                          // Tao khoang cach cho phep cuon len de toi uu hien thi truong nhap

                          MediaQuery.of(context).viewInsets.bottom >
                                  MediaQuery.of(context).size.width *
                                      0.30133333333333334
                              ? SizedBox(
                                  height:
                                      MediaQuery.of(context).viewInsets.bottom -
                                          MediaQuery.of(context).size.width *
                                              0.30133333333333334,
                                )
                              : SizedBox(
                                  height:
                                      MediaQuery.of(context).viewInsets.bottom,
                                ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
