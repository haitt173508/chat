import 'package:chat_365/common/images.dart';
import 'package:chat_365/common/models/selectable_Item.dart';
import 'package:chat_365/common/widgets/button/fill_button.dart';
import 'package:chat_365/common/widgets/form/outline_text_form_field.dart';
import 'package:chat_365/common/widgets/label_form_field.dart';
import 'package:chat_365/core/constants/string_constants.dart';
import 'package:chat_365/core/theme/app_text_style.dart';
import 'package:chat_365/modules/auth/modules/signup/cubit/signup_cubit.dart';
import 'package:chat_365/modules/auth/repo/auth_repo.dart';
import 'package:chat_365/modules/auth/widgets/custom_auth_scaffold.dart';
import 'package:chat_365/modules/auth/widgets/password_field.dart';
import 'package:chat_365/router/app_pages.dart';
import 'package:chat_365/router/app_router.dart';
import 'package:chat_365/utils/data/enums/permission.dart';
import 'package:chat_365/utils/data/enums/position.dart';
import 'package:chat_365/utils/data/enums/user_type.dart';
import 'package:chat_365/utils/data/extensions/context_extension.dart';
import 'package:chat_365/utils/helpers/validators.dart';
import 'package:chat_365/utils/ui/app_border_and_radius.dart';
import 'package:chat_365/utils/ui/app_dialogs.dart';
import 'package:chat_365/utils/ui/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddFirstEmployeeScreen extends StatefulWidget {
  const AddFirstEmployeeScreen({
    Key? key,
  }) : super(key: key);

  @override
  _AddFirstEmployeeScreenState createState() => _AddFirstEmployeeScreenState();
}

class _AddFirstEmployeeScreenState extends State<AddFirstEmployeeScreen> {
  final _form = GlobalKey<FormState>();

  //*Dung de cuon trong -> ngoai
  final ScrollController _scrollController = ScrollController();

  //*Dung cho viec unfocus se validate phan nhap lai mat khau
  final FocusNode _focusRepeatPassword = FocusNode();
  final _rePasswordKey = GlobalKey<FormFieldState>();

  //*Dung cho validator trung tai khoan
  final FocusNode _focusAccount = FocusNode();
  String? Function(String?)? _validator;
  final _accountKey = GlobalKey<FormState>();
  //Dung cho man nhan vien
  late SelectableItem _department;
  TextEditingController _textDepartmentController = TextEditingController();
  late SelectableItem _position;
  TextEditingController _textPositionController = TextEditingController();

  late SelectableItem _permision;
  TextEditingController _textPermisionController = TextEditingController();
  //Dung chung cac man
  bool accept = false;
  TextEditingController _textAccountController = TextEditingController();
  TextEditingController _textPhoneNumberController = TextEditingController();
  TextEditingController _textNameController = TextEditingController();
  TextEditingController _textPass1Controller = TextEditingController();
  TextEditingController _textEditingPass2Controller = TextEditingController();
  TextEditingController _textAddressController = TextEditingController();

  //Dung cho validator cua nhap lai mat khau
  bool isChanging = false;

  /// La ham them nhan vien dau tien
  _btnAddFirstEmployee(BuildContext context) {
    SignUpCubit signUpCubit = context.read<SignUpCubit>();
    setState(() {
      isChanging = false;
    });
    if (_form.currentState!.validate() == true) {
      //* Them nhan vien dau tien
      signUpCubit.addFirstEmployee(
          contactSignUp: _textAccountController.text,
          userName: _textNameController.text,
          password: _textPass1Controller.text,
          phoneNumber: _textPhoneNumberController.text,
          address: _textAddressController.text,
          position: _position,
          permision: _permision);
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
    //* Kiem tra trung tai khoan nhan vien
    _focusAccount.addListener(() {
      if (!_focusAccount.hasFocus &&
          Validator.requiredInputPhoneOrEmailValidator(
                  _textAccountController.text) ==
              null) {
        context.read<SignUpCubit>().checkAccountExist(
            contactSignUp: _textAccountController.text,
            userType: UserType.staff);
      }
    });
    //* Gan cac gia tri mac dinh ban dau cho nhan vien
    _validator = (value) => Validator.requiredInputPhoneOrEmailValidator(value);
    _position =
        Position.selectableItemList.firstWhere((element) => element.id == '3');
    _textPositionController.text = _position.name;
    _permision = PermisionEmployee.selectableItemList.first;
    _textPermisionController.text = _permision.name;
    super.initState();
  }

  @override
  void dispose() {
    _textNameController.dispose();
    _textPhoneNumberController.dispose();
    _textAccountController.dispose();
    _textPass1Controller.dispose();
    _textEditingPass2Controller.dispose();
    _textPositionController.dispose();
    _textDepartmentController.dispose();
    _textAddressController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //* Phan tong tin nhap cho them nhan vien dau tien
    late List<Widget> childrenFirstEmployee = [
      // phone account
      // SizedBoxExt.h20,
      LabelFormField(title: 'Tài khoản đăng nhập', isRequired: true),
      OutlineTextFormField(
        key: _accountKey,
        controller: _textAccountController,
        focusNode: _focusAccount,
        style: context.theme.inputStyle,
        // keyboardType: TextInputType.number,
        decoration: context.theme.inputDecoration.copyWith(
          hintText: StringConst.inputPhoneOrEmail,
          prefixIcon: WidgetUtils.getFormFieldColorPrefixIcon(
              Images.ic_person_setup,
              color: context.theme.iconColor,
              size: 24),
          hintStyle: context.theme.hintStyle,
        ),
        onChanged: (value) {
          if (_validator !=
              (value) => Validator.requiredInputPhoneOrEmailValidator(value)) {
            setState(() {
              _validator = (value) =>
                  Validator.requiredInputPhoneOrEmailValidator(value);
            });
          }
        },
        validator: _validator,
      ),
      SizedBoxExt.h20,
      //Nhap ten nhan vien
      LabelFormField(title: StringConst.fullName, isRequired: true),
      OutlineTextFormField(
        controller: _textNameController,
        style: context.theme.inputStyle,
        textCapitalization: TextCapitalization.words,
        decoration: context.theme.inputDecoration.copyWith(
          hintText: StringConst.inputFullName,
          prefixIcon: WidgetUtils.getFormFieldColorPrefixIcon(
            Images.ic_edit_name,
            color: context.theme.iconColor,
          ),
          hintStyle: context.theme.hintStyle,
        ),
        validator: (value) => Validator.validateStringName(
          _textNameController.text,
          StringConst.inputFullName,
        ),
      ),
      // SizedBoxExt.h20,

      // //email
      // SizedBoxExt.h20,
      // OutlineTextFormField(
      //   controller: _textEmailController,
      //   style: context.theme.inputStyle,
      //   decoration: context.theme.inputDecoration.copyWith(
      //         hintText: StringConst.inputEmail,
      //         prefixIcon: WidgetUtils.getFormFieldColorPrefixIcon(
      //             Images.ic_email,
      //             color: context.theme.iconColor,
      //             size: 24),
      //         hintStyle: context.theme.hintStyle,
      //       ),
      //   onChanged: (value) {
      //     if (_validator !=
      //         (value) => Validator.requiredInputEmailValidator(value)) {
      //       setState(() {
      //         setState(() {
      //           _validator =
      //               (value) => Validator.requiredInputEmailValidator(value);
      //         });
      //       });
      //     }
      //     ;
      //   },
      //   validator: _validator,
      // ),

      //Nhap mat khau
      SizedBoxExt.h20,
      LabelFormField(title: StringConst.inputPassword, isRequired: true),

      PasswordField(
        hintText: StringConst.inputPassword,
        controller: _textPass1Controller,
        validator: (value) => Validator.inputPasswordValidator(value),
      ),
      //Nhap lai mat khau
      SizedBoxExt.h20,
      LabelFormField(title: StringConst.reInputPassword, isRequired: true),

      PasswordField(
        key: _rePasswordKey,
        focusNode: _focusRepeatPassword,
        hintText: StringConst.reInputNewPassword,
        controller: _textEditingPass2Controller,
        // autovalidateMode: AutovalidateMode.disabled,
        onChanged: (value) {
          setState(() {
            isChanging = true;

            // _form.currentState.
          });
        },
        validator: (value) => Validator.reInputPasswordValidator(
            value, _textPass1Controller.text, isChanging),
      ),
      //So dien thoai
      SizedBoxExt.h20,
      LabelFormField(title: 'Số điện thoại liên hệ', isRequired: true),

      OutlineTextFormField(
        controller: _textPhoneNumberController,
        style: context.theme.inputStyle,
        keyboardType: TextInputType.number,
        decoration: context.theme.inputDecoration.copyWith(
          hintText: StringConst.phoneNumber,
          prefixIcon: WidgetUtils.getFormFieldColorPrefixIcon(Images.ic_phone,
              color: context.theme.iconColor, size: 24),
          hintStyle: context.theme.hintStyle,
        ),
        validator: (value) => Validator.requiredInputPhoneValidator(
          value,
        ),
      ),

      SizedBoxExt.h20,
      // Chuc vu
      LabelFormField(title: 'Chức vụ', isRequired: true),

      GestureDetector(
        onTap: () => AppDialogs.showListDialog(
                context: context,
                list: Position.selectableItemList,
                value: _position)
            .then((value) {
          if (value != null) _position = value;
          _textPositionController.text = _position.name;
        }),
        child: OutlineTextFormField(
          controller: _textPositionController,
          enable: false,
          style: context.theme.inputStyle
              .copyWith(overflow: TextOverflow.ellipsis),
          textCapitalization: TextCapitalization.words,
          maxLine: 1,
          decoration: context.theme.inputDecoration.copyWith(
            hintText: StringConst.selectPosition,
            disabledBorder: AppBorderAndRadius.outlineInputBorder,
            prefixIcon: WidgetUtils.getFormFieldColorPrefixIcon(
              Images.ic_position,
              color: context.theme.iconColor,
            ),
            suffixIcon: Padding(
              padding: EdgeInsets.only(
                right: 16,
              ),
              child: WidgetUtils.getFormFieldColorPrefixIcon(
                Images.ic_dropdownArrow,
                color: context.theme.iconColor,
              ),
            ),
            hintStyle: context.theme.hintStyle,
          ),
        ),
      ),
      SizedBoxExt.h20,
      // Phan quyen
      LabelFormField(title: 'Quyền truy cập', isRequired: true),
      GestureDetector(
        onTap: () => AppDialogs.showListDialog(
                context: context,
                list: PermisionEmployee.selectableItemList,
                value: _permision)
            .then((value) {
          if (value != null) _permision = value;
          _textPermisionController.text = _permision.name;
        }),
        child: OutlineTextFormField(
          controller: _textPermisionController,
          enable: false,
          style: context.theme.inputStyle
              .copyWith(overflow: TextOverflow.ellipsis),
          textCapitalization: TextCapitalization.words,
          decoration: context.theme.inputDecoration.copyWith(
            hintText: StringConst.selectPermision,
            disabledBorder: AppBorderAndRadius.outlineInputBorder,
            prefixIcon: WidgetUtils.getFormFieldColorPrefixIcon(
              Images.ic_permision,
              color: context.theme.iconColor,
            ),
            suffixIcon: Padding(
              padding: EdgeInsets.only(right: 16),
              child: WidgetUtils.getFormFieldColorPrefixIcon(
                Images.ic_dropdownArrow,
                color: context.theme.iconColor,
              ),
            ),
            hintStyle: context.theme.hintStyle,
          ),
        ),
      ),
      // SizedBoxExt.h20,
      //Dia chi
      SizedBoxExt.h20,
      LabelFormField(title: StringConst.address, isRequired: true),
      OutlineTextFormField(
        controller: _textAddressController,
        style: context.theme.inputStyle,
        minLine: 3,
        maxLine: 3,
        keyboardType: TextInputType.streetAddress,
        textCapitalization: TextCapitalization.words,
        decoration: context.theme.inputDecoration.copyWith(
          hintText: StringConst.inputAddress,
          prefixIcon: Padding(
            padding: EdgeInsets.only(bottom: 18 * 2),
            child: WidgetUtils.getFormFieldColorPrefixIcon(Images.ic_location,
                color: context.theme.iconColor, size: 24),
          ),
          hintStyle: context.theme.hintStyle,
        ),
        validator: (value) =>
            Validator.validateStringAddess(_textAddressController.text),
      ),
    ];

    return BlocListener<SignUpCubit, SignUpState>(
      bloc: context.read<SignUpCubit>(),
      listener: (context, state) {
        //*Kiem tra trung tai khoan
        if (state is CheckAccountStateLoad) {
        } else if (state is CheckAccountStateSuccess) {
        } else if (state is CheckAccountStateError) {
          if (state.errorRes != null) {
            setState(() {
              _validator = (value) => state.errorRes!.messages;
            });
          }
        } else if (state is AddFirstEmployeeStateLoad) {
          AppDialogs.showLoadingCircle(context);
        } else if (state is AddFirstEmployeeStateSuccess) {
          AppDialogs.hideLoadingCircle(context);
          AppRouter.toPage(context, AppPages.Auth_SignUpSuccess, arguments: {
            'phone': context.read<SignUpCubit>().contactSignUp,
            'password': context.read<SignUpCubit>().password,
            'userType': UserType.company,
          });
        } else if (state is AddFirstEmployeeStateError) {
          AppDialogs.hideLoadingCircle(context);
          AppDialogs.toast(state.error);
          if (context.read<SignUpCubit>().error != null) {
            if (context.read<SignUpCubit>().error!.code == 200) {
              setState(() {
                _validator =
                    (value) => context.read<SignUpCubit>().error!.messages;
              });
            }
          }
        }
      },
      child: CustomAuthScaffold(
        // title: 'Thiết lập thông tin tài khoản',
        extendBodyBehindAppBar: true,
        scrollAble: false,
        useAppBar: true,
        child: Container(
          padding: EdgeInsets.all(20).copyWith(top: 0),
          child: Form(
            key: _form,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // SizedBoxExt.h10,
                  Image.asset(
                    Images.img_logo_non_text,
                    width: 100,
                  ),
                  SizedBoxExt.h30,
                  Text(
                    'Thêm nhân viên đầu tiên',
                    style: TextStyle(
                      fontSize: 24,
                      color: context.theme.primaryColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBoxExt.h40,
                  Column(
                    children: [
                      Column(
                        children: childrenFirstEmployee,
                      ),
                      SizedBoxExt.h20,

                      // Dong y quy dinh
                      // Row(
                      //   children: [
                      //     Checkbox(
                      //       value: accept,
                      //       materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      //       onChanged: (value) {
                      //         setState(() {
                      //           accept = !accept;
                      //         });
                      //       },
                      //       shape: RoundedRectangleBorder(
                      //           borderRadius: BorderRadius.circular(5)),
                      //     ),
                      //     RichText(
                      //       text: TextSpan(
                      //         text: 'Tôi đồng ý với ',
                      //         style: AppTextStyles.regularW400(context, size: 16),
                      //         children: <TextSpan>[
                      //           TextSpan(
                      //             text: 'Quy định và Điều khoản',
                      //             style: AppTextStyles.regularW500(context,
                      //                 size: 16, color: AppColors.primary),
                      //             recognizer: TapGestureRecognizer()..onTap = () {},
                      //           ),
                      //         ],
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      // SizedBoxExt.h20,

                      // Nut chuc nang
                      FillButton(
                        width: double.infinity,
                        title: 'Tiếp tục',
                        onPressed: () => _btnAddFirstEmployee(context),
                      ),
                      SizedBoxExt.h20,
                      // Nut bo qua
                      // GestureDetector(
                      //   onTap: () => AppRouter.toPage(
                      //       context, AppPages.Auth_SignUpSuccess,
                      //       arguments: {
                      //         'phone': context
                      //             .read<SignUpCubit>()
                      //             .contactSignUp,
                      //         'password':
                      //             context.read<SignUpCubit>().password,
                      //         'userType':
                      //             context.read<AuthRepo>().userType,
                      //       }),
                      //   child: Padding(
                      //     padding: AppPadding.paddingAll10,
                      //     child: Text(
                      //       StringConst.skip,
                      //       style:
                      //           AppTextStyles.button(context).copyWith(
                      //         // color: context.theme.backgroundColor
                      //         color: context.theme.primaryColor,
                      //         shadows: <Shadow>[
                      //           Shadow(
                      //             offset: Offset(0, 0),
                      //             blurRadius: 4.0,
                      //             color:
                      //                 context.theme.backgroundColor,
                      //           ),
                      //         ],
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: FillButton(
                          width: double.infinity,
                          title: StringConst.skip,
                          // elevation: 10,
                          backgroundColor: context.theme.backgroundColor,
                          style: AppTextStyles.button(context)
                              .copyWith(color: context.theme.primaryColor),
                          onPressed: () => AppRouter.toPage(
                              context, AppPages.Auth_SignUpSuccess,
                              arguments: {
                                'phone':
                                    context.read<SignUpCubit>().contactSignUp,
                                'password':
                                    context.read<SignUpCubit>().password,
                                'userType': context.read<AuthRepo>().userType,
                              }),
                        ),
                      ),
                      if (context.read<AuthRepo>().userType != UserType.staff)
                        SizedBoxExt.h10,
                      MediaQuery.of(context).viewInsets.bottom >
                              MediaQuery.of(context).size.width *
                                  0.30133333333333334
                          ? SizedBox(
                              height: MediaQuery.of(context).viewInsets.bottom -
                                  MediaQuery.of(context).size.width *
                                      0.30133333333333334,
                            )
                          : SizedBox(
                              height: MediaQuery.of(context).viewInsets.bottom,
                            ),
                    ],
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}
