import 'dart:async';

import 'package:chat_365/common/images.dart';
import 'package:chat_365/common/widgets/button/fill_button.dart';
import 'package:chat_365/core/debouncer.dart';
import 'package:chat_365/core/theme/app_colors.dart';
import 'package:chat_365/core/theme/app_text_style.dart';
import 'package:chat_365/modules/auth/modules/forgot_password/screens/update_password_screen.dart';
import 'package:chat_365/modules/auth/modules/signup/cubit/signup_cubit.dart';
import 'package:chat_365/modules/auth/repo/auth_repo.dart';
import 'package:chat_365/modules/auth/widgets/custom_auth_scaffold.dart';
import 'package:chat_365/router/app_pages.dart';
import 'package:chat_365/router/app_router.dart';
import 'package:chat_365/utils/data/enums/type_screen_to_otp.dart';
import 'package:chat_365/utils/data/enums/user_type.dart';
import 'package:chat_365/utils/data/extensions/context_extension.dart';
import 'package:chat_365/utils/ui/app_dialogs.dart';
import 'package:chat_365/utils/ui/app_padding.dart';
import 'package:chat_365/utils/ui/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class ConfirmOTPScreen extends StatefulWidget {
  const ConfirmOTPScreen(
      {Key? key,
      required this.isPhoneNumber,
      required this.typeScreenToOtp,
      this.email})
      : super(key: key);
  final bool isPhoneNumber;
  final TypeScreenToOtp typeScreenToOtp;
  final String? email;

  static const isPhoneNumberKey = 'isPhoneNumber';
  static const idTypeScreenToOtp = 'typeScreenToOtp';
  static const idEmail = 'email';

  @override
  _ConfirmOTPScreenState createState() => _ConfirmOTPScreenState();
}

class _ConfirmOTPScreenState extends State<ConfirmOTPScreen> {
  late GlobalKey _form;
  late TextEditingController _textOTPEditingController;
  FocusNode _focusNode = FocusNode();
  DateTime timeSend = DateTime.now();
  // Do dai cua ma otp
  final int longOtp = 6;

  //Dung cho viec dem nguoc
  late Timer _timer;
  final int timeWait = 90;
  int _counter = 90;

  //Dung khi dem nguoc lan dau tien vao man
  bool firstLoad = true;

  //Dung de validator cho otp
  bool isEqual = true;
  //Ham dem nguoc
  void _startTimer() {
    _counter = timeWait;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_counter > 0) {
        setState(() {
          _counter--;
        });
      } else {
        _timer.cancel();
      }
    });
  }

  _btnCompareOTP(BuildContext context) {
    SignUpCubit signUpCubit = context.read<SignUpCubit>();
    signUpCubit.compareOTP(
        _textOTPEditingController.text, widget.typeScreenToOtp);
  }

  _btnReSendToEmailPressedHandler(
    BuildContext context,
  ) {
    SignUpCubit signUpCubit = context.read<SignUpCubit>();
    // Chi co 2 chuc nang dung otp
    // Quen mat khau va xac thuc tai khoang cong ty
    if (widget.typeScreenToOtp == TypeScreenToOtp.FORGOTPASSWORD) {
      signUpCubit.sendOTPForgetPassword(
          signUpCubit.contactSignUp, context.read<AuthRepo>().userType, true);
    } else {
      signUpCubit.sendOTPCompanyAccount(
          signUpCubit.contactSignUp, context.read<AuthRepo>().userType, true);
    }
  }

  @override
  void initState() {
    _textOTPEditingController = TextEditingController();
    _form = GlobalKey<FormState>();
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    //! Khong dispose vi widget PinCodeTextField van se dung khi thoat man
    //! _textOTPEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final SignUpCubit signUpCubit = context.read<SignUpCubit>();
    if (firstLoad) {
      // _startTimer();
      Debouncer(delay: Duration(milliseconds: 100)).call(() {
        //* Gui ma otp lan dau tien
        if (widget.typeScreenToOtp != TypeScreenToOtp.FORGOTPASSWORD) {
          context.read<SignUpCubit>().sendOTPCompanyAccount(
              widget.email ?? context.read<SignUpCubit>().contactSignUp,
              context.read<AuthRepo>().userType,
              false);
        } else {
          _startTimer();
        }
      });
      firstLoad = false;
    }
    return BlocListener<SignUpCubit, SignUpState>(
      listener: (context, state) {
        //* Phan trang thai cua gui ma otp
        if (state is SendOtpStateLoad || state is ReSendOtpStateLoad) {
          AppDialogs.showLoadingCircle(context);
        } else if (state is SendOtpStateSuccess ||
            state is ReSendOtpStateSuccess) {
          AppDialogs.hideLoadingCircle(context);
          _textOTPEditingController.clear();
          AppDialogs.toast('Mã xác thực đang được gửi');
          timeSend = DateTime.now();
          setState(() {
            isEqual = true;
          });
          _startTimer();
        } else if (state is ReSendOtpStateError) {
          AppDialogs.hideLoadingCircle(context);

          AppDialogs.toast(state.error);
          setState(() {
            _counter = 0;
          });
        } else if (state is SendOtpStateError) {
          AppDialogs.hideLoadingCircle(context);

          AppDialogs.toast(state.error);
          setState(() {
            _counter = 0;
          });
        }

        //* Phan trang thai cua xac thuc OTP
        else if (state is CompareOTPStateLoad) {
          AppDialogs.showLoadingCircle(context);
        } else if (state is CompareOTPStateSuccess) {
          AppDialogs.hideLoadingCircle(context);
          if (widget.typeScreenToOtp == TypeScreenToOtp.FORGOTPASSWORD) {
            AppRouter.toPage(context, AppPages.Auth_UpdatePass,
                blocValue: context.read<SignUpCubit>(),
                arguments: {
                  UpdatePasswordScreen.userTypeArg:
                      context.read<AuthRepo>().userType
                });
          } else {
            if (context.read<AuthRepo>().userType == UserType.company) {
              AppRouter.toPage(context, AppPages.Auth_AddFirstEmployee,
                  blocValue: context.read<SignUpCubit>());
            } else
              AppRouter.toPage(context, AppPages.Auth_SignUpSuccess,
                  arguments: {
                    'phone': signUpCubit.contactSignUp,
                    'password': signUpCubit.password,
                    'userType': context.read<AuthRepo>().userType,
                  });
          }
        } else if (state is CompareOTPStateError) {
          AppDialogs.hideLoadingCircle(context);

          setState(() {
            isEqual = false;
          });
        }
      },
      child: CustomAuthScaffold(
        title: 'Mã xác thực',
        extendBodyBehindAppBar: false,
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
                    'Nhập mã xác thực',
                    style: AppTextStyles.regularW700(context, size: 18),
                  ),
                  SizedBoxExt.h20,
                  Text(
                    'Mã xác thực bao gồm $longOtp chữ số sẽ gửi tới ${widget.isPhoneNumber ? 'Số điện thoại' : 'Địa chỉ email'} của bạn trong vòng $timeWait giây. Nếu chưa nhận được mã vui lòng ấn nút “Gửi lại mã”!',
                    // : 'Mã xác thực bao gồm $longOtp chữ số được gửi đến Email của bạn trong vòng $timeWait giây. Nếu chưa nhận được mã vui lòng ấn nút “Gửi lại mã”!',
                    textAlign: TextAlign.center,
                  ),
                  SizedBoxExt.h50,
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      PinCodeTextField(
                        appContext: context,
                        // enablePinAutofill: widget.isPhoneNumber,
                        length: longOtp,
                        textStyle: context.theme.inputStyle,
                        // backgroundColor: context.theme.backgroundColor,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],

                        pinTheme: PinTheme(
                            shape: PinCodeFieldShape.box,
                            borderWidth: 1,
                            borderRadius: BorderRadius.circular(10),
                            fieldHeight: 40,
                            fieldWidth: 40,
                            disabledColor: context.theme.primaryColor,
                            activeColor: !isEqual &&
                                    _textOTPEditingController.text.length ==
                                        longOtp
                                ? AppColors.red
                                : context.theme.primaryColor,
                            activeFillColor: context.theme.backgroundColor,
                            inactiveColor: context.theme.primaryColor,
                            inactiveFillColor: context.theme.backgroundColor,
                            selectedColor: !isEqual
                                ? AppColors.red
                                : context.theme.primaryColor,
                            selectedFillColor: context.theme.backgroundColor,
                            errorBorderColor: AppColors.red),
                        blinkWhenObscuring: true,
                        enableActiveFill: true,
                        animationType: AnimationType.fade,
                        controller: _textOTPEditingController,
                        keyboardType: TextInputType.number,
                        errorTextSpace: 10,

                        boxShadows: const [
                          BoxShadow(
                            offset: Offset(0, 1),
                            color: Colors.black12,
                            blurRadius: 10,
                          )
                        ],
                        onChanged: (value) {
                          if (!isEqual)
                            setState(() {
                              isEqual = true;
                            });
                          setState(() {});
                        },
                        beforeTextPaste: (text) {
                          //tra ve true se co dialog xac nhan paste gia tri
                          return false;
                        },
                      ),
                      if (!isEqual)
                        Text(
                          'Mã xác thực không đúng, mời bạn nhập lại mã',
                          style: AppTextStyles.regularW400(context,
                              size: 13, color: AppColors.red),
                        ),
                    ],
                  ),
                  if (_counter == 0) SizedBoxExt.h20,
                  if (_counter == 0)
                    GestureDetector(
                      onTap: () {
                        _btnReSendToEmailPressedHandler(context);
                      },
                      child: Padding(
                        padding: AppPadding.paddingAll16,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              Images.ic_resend,
                              color: context.theme.primaryColor,
                            ),
                            SizedBoxExt.w10,
                            Text(
                              'Gửi lại mã',
                              style: AppTextStyles.regularW400(context,
                                  size: 16, color: context.theme.primaryColor),
                            ),
                          ],
                        ),
                      ),
                    ),
                  SizedBoxExt.h40,

                  //Nut xac thuc otp
                  FillButton(
                    width: double.infinity,
                    title: 'Xác thực (${_counter}s)',
                    backgroundColor:
                        _textOTPEditingController.text.length < longOtp
                            ? context.theme.primaryColor.withOpacity(0.6)
                            : null,
                    onPressed: () => _textOTPEditingController.text.length <
                            longOtp
                        ? AppDialogs.toast('Vui lòng nhập đầy đủ mã xác thực')
                        : _btnCompareOTP(context),
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
