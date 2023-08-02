import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:chat_365/common/images.dart';
import 'package:chat_365/common/widgets/button/fill_button.dart';
import 'package:chat_365/core/constants/local_storage_key.dart';
import 'package:chat_365/core/constants/status_code.dart';
import 'package:chat_365/core/constants/string_constants.dart';
import 'package:chat_365/core/theme/app_colors.dart';
import 'package:chat_365/core/theme/app_text_style.dart';
import 'package:chat_365/modules/auth/modules/forgot_password/screens/forgot_password_screen.dart';
import 'package:chat_365/modules/auth/modules/login/cubit/login_cubit.dart';
import 'package:chat_365/modules/auth/modules/signup/cubit/signup_cubit.dart';
import 'package:chat_365/modules/auth/modules/signup/screens/confirm_id_company.dart';
import 'package:chat_365/modules/auth/modules/signup/screens/confirm_otp_screen.dart';
import 'package:chat_365/modules/auth/modules/signup/screens/set_up_account_information_screen.dart';
import 'package:chat_365/modules/auth/repo/auth_repo.dart';
import 'package:chat_365/modules/auth/widgets/email_field.dart';
import 'package:chat_365/modules/auth/widgets/password_field.dart';
import 'package:chat_365/router/app_pages.dart';
import 'package:chat_365/router/app_router.dart';
import 'package:chat_365/utils/data/enums/auth_mode.dart';
import 'package:chat_365/utils/data/enums/type_screen_to_otp.dart';
import 'package:chat_365/utils/data/enums/user_type.dart';
import 'package:chat_365/utils/data/extensions/context_extension.dart';
import 'package:chat_365/utils/helpers/logger.dart';
import 'package:chat_365/utils/helpers/open_url.dart';
import 'package:chat_365/utils/helpers/validators.dart';
import 'package:chat_365/utils/ui/app_dialogs.dart';
import 'package:chat_365/utils/ui/widget_utils.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:sp_util/sp_util.dart';
import '../../../widgets/custom_auth_scaffold.dart';
import '../models/login_model.dart';
import 'custom_qr_screen.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({
    Key? key,
    this.onSuccess,
    required this.userType,
    this.mode,
  }) : super(key: key);

  final VoidCallback? onSuccess;
  final UserType userType;
  final AuthMode? mode;

  static const userTypeArg = 'userTypeArg';
  static const authMode = 'authMode';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  late final GlobalKey<FormState> _formKey;

  late final ValueNotifier<String> email;
  late final TextEditingController contactLoginTEC;
  late final TextEditingController pass;

  late final LoginCubit _loginCubit;
  late final AuthRepo _authRepo;

  late final List<Widget> _bottomListWidget;

  String? Function(String?)? _validatorPassword;
  String? Function(String?)? _validatorAccount;
  final FocusNode _emailNode = FocusNode(), _passNode = FocusNode();
  late TabController _controller;
  QRViewController? controllerQRCode;
  Barcode? result;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  getDeviceInfo() async {
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      // phoneName = androidInfo.model;
      // idDevice = androidInfo.androidId;
      // brand = androidInfo.brand;
      SpUtil.putString(LocalStorageKey.nameDevice, androidInfo.model);
      SpUtil.putString(LocalStorageKey.idDevice, androidInfo.androidId);
      SpUtil.putString(LocalStorageKey.brand, androidInfo.brand);
      print(
          'Thông tin thiết bị: ${androidInfo.model} - ${androidInfo.androidId} - ${androidInfo.brand}');
    } else {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      // phoneName = iosInfo.utsname.machine;
      // brand = iosInfo.model;
      // idDevice = iosInfo.identifierForVendor;
      SpUtil.putString(LocalStorageKey.nameDevice, iosInfo.utsname.machine);
      SpUtil.putString(LocalStorageKey.idDevice, iosInfo.identifierForVendor);
      SpUtil.putString(LocalStorageKey.brand, iosInfo.model);
      print(
          'Thông tin thiết bị: ${iosInfo.utsname.machine} - ${iosInfo.identifierForVendor} - ${iosInfo.model}');
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = TabController(vsync: this, length: 2);
    _loginCubit = context.read<LoginCubit>();
    _authRepo = context.read<AuthRepo>();
    _formKey = GlobalKey<FormState>();
    email = ValueNotifier('');
    // _validatorEmail =
    //     (value) => Validator.requiredInputEmailValidator(contactLoginTEC.text);
    _validatorAccount = (value) =>
        Validator.requiredInputPhoneOrEmailValidator(contactLoginTEC.text);
    _validatorPassword =
        (value) => Validator.requiredNoBlankEmptyPasswordValidator(
              pass.text,
            );
    contactLoginTEC = TextEditingController();
    pass = TextEditingController();

    _emailNode.addListener(_listener);
    _passNode.addListener(_listener);
    getDeviceInfo();
  }

  bool get _hasFocus => _emailNode.hasFocus || _passNode.hasFocus;

  @override
  void dispose() {
    _emailNode.dispose();
    _passNode.dispose();
    pass
      ..removeListener(_listener)
      ..dispose();
    contactLoginTEC
      ..removeListener(_listener)
      ..dispose();
    email.dispose();
    super.dispose();
  }

  _listener() {
    if (_hasFocus && mounted) {
      setState(() {
        _validatorAccount = null;
        _validatorPassword = Validator.validateLoginPassword;
      });
    }
  }

  // _onLoginSuccess(BuildContext context) {
  //   AppDialogs.hideLoadingCircle(context);

  //   if (widget.onSuccess != null)
  //     widget.onSuccess!();
  //   else
  //     AppRouter.replaceAllWithPage(context, AppPages.Navigation);
  // }

  _btnForgotPassPressedHandler(BuildContext context) =>
      // widget.userType == UserType.customer
      //     ?
      AppRouter.toPage(
        context,
        AppPages.Auth_ForgotPass,
        // blocValue: _authBloc,
        arguments: {
          ForgotPasswordScreen.userTypeArg: widget.userType,
        },
      );

  // : AppDialogs.toast(StringConst.areImproving);

  _btnCreateAccountPressedHandler(BuildContext context) {
    if (widget.mode == AuthMode.REGISTER) {
      _authRepo.userType = widget.userType;
      AppRouter.back(context);
    } else {
      if (widget.userType == UserType.customer) {
        AppRouter.toPage(context, AppPages.Auth_SetUpAccount_CreatCubit,
            arguments: {
              SetUpAccountInformationScreen.authModeArg: AuthMode.LOGIN
            });
      } else if (widget.userType == UserType.staff) {
        AppRouter.toPage(context, AppPages.Auth_ConfirmIdCompany,
            arguments: {ConfirmIdCompanyScreen.formLogin: AuthMode.LOGIN});
      } else if (widget.userType == UserType.company) {
        AppRouter.toPage(context, AppPages.Auth_SetUpAccount_CreatCubit,
            arguments: {
              SetUpAccountInformationScreen.authModeArg: AuthMode.LOGIN
            });
      }
    }
  }

  _btnLoginPressedHandler(BuildContext context) {
    var emailText = contactLoginTEC.text;
    var passText = pass.text;
    FocusManager.instance.primaryFocus?.unfocus();
    if (_formKey.currentState?.validate() == true) {
      _loginCubit.login(
        widget.userType,
        LoginModel(
          emailText,
          passText,
        ),
        rememberAccount: _rememberAccount,
      );
    }
  }

  _showUserManual() {
    showModalBottomSheet(
      isScrollControlled: true,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height,
      ),
      builder: (context) => buildSheetSuccessful(context),
      context: context,
    );
  }

  Widget buildSheetSuccessful(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _iconText('1', StringConst.user_manual1),
            SizedBoxExt.h15,
            _iconText('2', StringConst.user_manual2),
            SizedBoxExt.h15,
            _iconText('3', StringConst.user_manual3),
          ],
        ),
      );

  Widget _iconText(
    String number,
    String text,
  ) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
        alignment: Alignment.center,
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: AppColors.primary,
        ),
        child: Text(
          number,
          style: AppTextStyles.regularW500(
            context,
            size: 14,
            color: AppColors.white,
          ),
        ),
      ),
      SizedBox(width: 8),
      Expanded(
        child: Text(
          text,
          style: AppTextStyles.regularW400(
            context,
            size: 16,
          ),
        ),
      )
    ]);
  }

  get loginModel => LoginModel(
        contactLoginTEC.text,
        pass.text,
      );

  bool _rememberAccount = true;
  bool _checkLogin = true;

  _handleChangeRememberAccountState(bool? value) => _rememberAccount = value!;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    try {
      _bottomListWidget = [
        Row(
          children: [
            Expanded(
              child: _RememberAccountCheckBox(
                onChanged: _handleChangeRememberAccountState,
              ),
            ),
            InkWell(
              onTap: () => _btnForgotPassPressedHandler(context),
              child: Text(
                StringConst.forgotPassword,
                style: TextStyle(
                  fontSize: 16,
                  color: context.theme.textColor,
                ),
              ),
            )
          ],
        ),
        SizedBoxExt.h40,
        FillButton(
          title: StringConst.login,
          elevation: 1,
          style: AppTextStyles.button(context).copyWith(
            color: AppColors.white,
          ),
          width: double.infinity,
          onPressed: () => _btnLoginPressedHandler(context),
        ),
        SizedBoxExt.h20,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: AppTextStyles.regularW400(context,
                  size: 14, fontStyle: FontStyle.italic),
              children: [
                TextSpan(
                    text:
                        '${widget.userType == UserType.customer ? 'Ứng viên/Timviec365 chi tiết' : widget.userType == UserType.company ? 'NTD chi tiết ' : 'Xem hướng dẫn'} ',
                    style: AppTextStyles.regularW400(
                      context,
                      size: 16,
                    )),
                TextSpan(
                  text: 'tại đây',
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      openUrl(widget.userType == UserType.customer
                          ? StringConst.urlDetailAcountPersone
                          : widget.userType == UserType.company
                              ? StringConst.urlDetailAcountCom
                              : StringConst.urlDetailAcountStaff);
                    },
                  style: AppTextStyles.regularW400(
                    context,
                    size: 16,
                    color: AppColors.primary,
                    fontStyle: FontStyle.italic,
                  ).copyWith(
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBoxExt.h55,
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
              onTap: () => _btnCreateAccountPressedHandler(context),
              child: Text(
                StringConst.signUp,
                style: TextStyle(
                  fontSize: 18,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            )
          ],
        ),
        // if (context.read<AuthRepo>().userType != UserType.staff) SizedBoxExt.h10,
        // MediaQuery.of(context).viewInsets.bottom >
        //         MediaQuery.of(context).size.width * 0.30133333333333334
        //     ? SizedBox(
        //         height: MediaQuery.of(context).viewInsets.bottom -
        //             MediaQuery.of(context).size.width * 0.30133333333333334,
        //       )
        //     : SizedBox(
        //         height: MediaQuery.of(context).viewInsets.bottom,
        //       ),
      ];
    } catch (e) {}
  }

  void _enterToLogin(key) {
    if (key.isKeyPressed(LogicalKeyboardKey.enter) && mounted)
      _btnLoginPressedHandler(context);
  }

  @override
  Widget build(BuildContext context) {
    Widget _loginInput = Column(
      children: [
        SizedBoxExt.h22,
        // LabelFormField(title: 'Tài khoản đăng nhập', isRequired: true),
        RawKeyboardListener(
          focusNode: FocusNode(),
          onKey: _enterToLogin,
          child: EmailField(
            controller: contactLoginTEC,
            focusNode: _emailNode,
            validator: _validatorAccount,
          ),
        ),
        SizedBoxExt.h16,
        // LabelFormField(title: StringConst.password, isRequired: true),
        RawKeyboardListener(
          focusNode: FocusNode(),
          onKey: _enterToLogin,
          child: PasswordField(
            controller: pass,
            hintText: StringConst.inputPassword,
            validator: _validatorPassword,
            focusNode: _passNode,
          ),
        ),
        SizedBoxExt.h16,
        ..._bottomListWidget,
      ],
    );

    Widget _loginQR = BlocProvider.value(
        value: _loginCubit,
        child: BlocListener<LoginCubit, LoginState>(
            listener: (context, state) {
              // AppRouter.removeAllDialog(context);
              if (state is LoginLoadingQR) {
                // controllerQRCode?.pauseCamera();
                AppDialogs.showLoadingCircle(context);
              } else if (state is LoginSuccessQR) {
              } else if (state is LoginErrorQR) {
                Future.delayed(Duration(seconds: 1), () {
                  controllerQRCode?.resumeCamera();
                });
                AppDialogs.toast(_loginCubit.error!);
              }
            },
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 50),
                  height: 250,
                  width: 250,
                  child: CustomPaint(
                    foregroundPainter: BorderPainter(),
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: QRView(
                        key: qrKey,
                        onQRViewCreated: _onQRViewCreated,
                        overlay: QrScannerOverlayShape(
                          borderColor: Colors.transparent,
                        ),
                        onPermissionSet: (ctrl, p) =>
                            _onPermissionSet(context, ctrl, p),
                      ),
                    ),
                  ),
                ),
                SizedBoxExt.h60,
                TextButton(
                    onPressed: () {
                      _showUserManual();
                    },
                    child: Text(
                      "Hướng dẫn quét",
                      style: AppTextStyles.regularW400(
                        context,
                        size: 16,
                        color: AppColors.primary,
                      ),
                    ))
              ],
            )));

    final Widget child = Column(
      children: [
        // SizedBoxExt.h55,
        SizedBox(
          height: 100,
          child: Image.asset(Images.img_logo_non_text),
        ),
        SizedBoxExt.h30,
        Text(
          '${StringConst.login} ${widget.userType == UserType.customer ? 'tài khoản Cá nhân' : widget.userType == UserType.company ? 'tài khoản Công ty' : 'tài khoản Nhân viên'}',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBoxExt.h28,
        // TabBar(
        //     controller: _controller,
        //     indicatorColor: AppColors.primary.withOpacity(0.99),
        //     onTap: (int) {
        //       switch (int) {
        //         case 0:
        //           setState(() {
        //             _checkLogin = true;
        //           });
        //
        //           break;
        //         case 1:
        //           setState(() {
        //             _checkLogin = false;
        //           });
        //           break;
        //       }
        //     },
        //     tabs: [
        //       Tab(
        //         child: Text(
        //           'SỐ ĐIỆN THOẠI',
        //           style: AppTextStyles.regularW600(context, size: 18, color: _checkLogin ? AppColors.primary : null),
        //         ),
        //       ),
        //       Tab(
        //         child: Text(
        //           'QUÉT MÃ QR',
        //           style: AppTextStyles.regularW600(
        //             context,
        //             size: 18,
        //             color: _checkLogin ? null : AppColors.primary,
        //           ),
        //         ),
        //       ),
        //     ]),
        // SizedBoxExt.h50,
        // SizedBox(
        //   height: context.mediaQuerySize.height * 2 / 3,
        //   child: TabBarView(
        //     controller: _controller,
        //     children: [
        //       _loginInput,
        //       _loginQR,
        //     ],
        //   ),
        // )
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 28),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    _checkLogin = true;
                  });
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Email/Số ĐT',
                      style: AppTextStyles.regularW600(context,
                          size: 18,
                          color: _checkLogin ? AppColors.primary : null),
                    ),
                    SizedBox(height: 7),
                    _checkLogin
                        ? Container(
                            height: 2,
                            width: MediaQuery.of(context).size.width * 0.36,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(15),
                            ),
                          )
                        : SizedBox(
                            width: MediaQuery.of(context).size.width * 0.36,
                          ),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    _checkLogin = false;
                  });
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'QUÉT MÃ QR',
                      style: AppTextStyles.regularW600(context,
                          size: 18,
                          color: _checkLogin ? null : AppColors.primary),
                    ),
                    SizedBox(height: 7),
                    _checkLogin
                        ? SizedBox(
                            width: MediaQuery.of(context).size.width * 0.36,
                          )
                        : Container(
                            height: 2,
                            width: MediaQuery.of(context).size.width * 0.36,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
        _checkLogin ? _loginInput : _loginQR
      ],
    );

    Widget current = CustomAuthScaffold(
      title: '',
      showBottomBackgroundImage: true,
      resizeToAvoidBottomInset: false,
      useAppBar: true,
      child: BlocListener<LoginCubit, LoginState>(
        bloc: _loginCubit,
        listener: (context, state) async {
          await SpUtil.putString(LocalStorageKey.passwordClass, pass.text);
          if (state is LoginStateError) {
            //Sai tai khoan mat khau

            if (state.errorRes!.messages != null &&
                state.errorRes!.messages!.contains('không chính xác')) {
              final String? loginError = state.errorRes!.messages;
              setState(() {
                // if (state.errorRes!.messages != null &&
                //     state.errorRes!.messages!.contains('mật khẩu')) {
                _validatorAccount = (value) => loginError;
                _validatorPassword = (value) => loginError;
                // } else {
                //   AppDialogs.toast('Đã có lỗi xảy ra vui lòng thử lại sau');
                // }
              });
            }

            //*Tai khoan cong ty chua xac thuc
            else if (state.errorRes!.messages != null &&
                state.errorRes!.messages!.contains('chưa xác thực')) {
              AppRouter.toPage(context, AppPages.Auth_ConfirmOTP,
                  blocValue: SignUpCubit(_authRepo),
                  arguments: {
                    ConfirmOTPScreen.isPhoneNumberKey:
                        !contactLoginTEC.text.contains('@'),
                    ConfirmOTPScreen.idTypeScreenToOtp:
                        TypeScreenToOtp.CONFIRMACCOUNT,
                    ConfirmOTPScreen.idEmail: contactLoginTEC.text
                  });
            }

            // Sai loại tài khoản
            else if (StatusCode.wrongAuthStatusCodes
                .contains(state.errorRes?.code)) {
              try {
                var rightUserType =
                    UserType.authUserTypeFromStatusCode[state.errorRes!.code]!;

                var confirm = await AppDialogs.showWrongUserTypeAuthDialog(
                  context,
                  rightUserType: rightUserType,
                ) as bool?;
                if (confirm == true)
                  _loginCubit.login(
                    rightUserType,
                    loginModel,
                    rememberAccount: _rememberAccount,
                  );
              } catch (e, s) {
                logger.logError(e, s);
              }
            }
          }

          //Tai khoan nhan vien chua duoc cong ty duyet
          else if (state is LoginStateUnBrowser) {
            // AppDialogs.hideLoadingCircle(context);
            AppDialogs.showMessConfirm(context, state.nameCompany);
          }
        },
        child: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: child,
          ),
        ),
      ),
    );

    return current;
  }

  /// Ham xu ly khi quet duoc qr
  void _onQRViewCreated(QRViewController controller) {
    log("khoi tao cam ");

    // setState(() {
    controller.resumeCamera();
    this.controllerQRCode = controller;
    // });

    controllerQRCode!.scannedDataStream.listen((scanData) async {
      try {
        result = scanData;
        var base64ID = '${scanData.code?.replaceAll('+', '')}';
        String idUser = utf8.decode(base64.decode(base64ID));
        if (result != null) {
          // print('Ma quet : ${result!}');
          controllerQRCode?.pauseCamera();
          await _loginCubit.getInfoQR(idUser);
          // AppDialogs.toast(idUser);
          // if (_loginCubit.state is LoginErrorQR){
          //   controllerQRCode?.resumeCamera();
          // }
        } else {
          AppDialogs.toast('Mã QR không hợp lệ');
        }
      } catch (e) {
        AppDialogs.toast('Mã QR không hợp lệ');
        // print('Error: ${e.toString()}');
      }
    });
  }
}

class _RememberAccountCheckBox extends StatefulWidget {
  const _RememberAccountCheckBox({
    Key? key,
    required this.onChanged,
  }) : super(key: key);

  final void Function(bool?) onChanged;

  @override
  State<_RememberAccountCheckBox> createState() =>
      _RememberAccountCheckBoxState();
}

class _RememberAccountCheckBoxState extends State<_RememberAccountCheckBox> {
  bool _value = true;

  _changeValue() {
    setState(() {
      _value = !_value;
      widget.onChanged(_value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: _value,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          onChanged: (_) => _changeValue(),
        ),
        GestureDetector(
          onTap: _changeValue,
          child: Text(
            StringConst.rememberAccount,
            style: TextStyle(
              fontSize: 16,
              color: context.theme.textColor,
            ),
          ),
        )
      ],
    );
  }
}

///Nhan quyen truy cap camera

void _onPermissionSet(
    BuildContext context, QRViewController ctrl, bool p) async {
  if (!p) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Không có quyền truy cập')),
    );
  }
}

class MyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double w = size.width;
    double h = size.height;
    double r = 15; //<-- corner radius

    Paint blackPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5;

    Paint redPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5;

    RRect fullRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(w / 2, h / 2), width: w, height: h),
      Radius.circular(r),
    );

    Path topRightArc = Path()
      ..moveTo(w - r, 0)
      ..arcToPoint(Offset(w, r), radius: Radius.circular(r));

    Path bottomLeftArc = Path()
      ..moveTo(r, h)
      ..arcToPoint(Offset(0, h - r), radius: Radius.circular(r));

    canvas.drawRRect(fullRect, blackPaint);
    canvas.drawPath(topRightArc, redPaint);
    canvas.drawPath(bottomLeftArc, redPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
