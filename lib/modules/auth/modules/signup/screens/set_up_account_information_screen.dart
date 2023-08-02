import 'package:chat_365/common/images.dart';
import 'package:chat_365/common/models/selectable_Item.dart';
import 'package:chat_365/common/widgets/button/fill_button.dart';
import 'package:chat_365/common/widgets/form/outline_text_form_field.dart';
import 'package:chat_365/common/widgets/label_form_field.dart';
import 'package:chat_365/core/constants/string_constants.dart';
import 'package:chat_365/core/theme/app_colors.dart';
import 'package:chat_365/core/theme/app_text_style.dart';
import 'package:chat_365/modules/auth/modules/signup/cubit/signup_cubit.dart';
import 'package:chat_365/modules/auth/modules/signup/screens/confirm_otp_screen.dart';
import 'package:chat_365/modules/auth/repo/auth_repo.dart';
import 'package:chat_365/modules/auth/widgets/custom_auth_scaffold.dart';
import 'package:chat_365/modules/auth/widgets/password_field.dart';
import 'package:chat_365/router/app_pages.dart';
import 'package:chat_365/router/app_router.dart';
import 'package:chat_365/router/app_router_helper.dart';
import 'package:chat_365/utils/data/enums/academic_level.dart';
import 'package:chat_365/utils/data/enums/auth_mode.dart';
import 'package:chat_365/utils/data/enums/gender.dart';
import 'package:chat_365/utils/data/enums/marital_status.dart';
import 'package:chat_365/utils/data/enums/permission.dart';
import 'package:chat_365/utils/data/enums/position.dart';
import 'package:chat_365/utils/data/enums/type_screen_to_otp.dart';
import 'package:chat_365/utils/data/enums/user_type.dart';
import 'package:chat_365/utils/data/enums/work_experience.dart';
import 'package:chat_365/utils/data/extensions/context_extension.dart';
import 'package:chat_365/utils/helpers/open_url.dart';
import 'package:chat_365/utils/helpers/validators.dart';
import 'package:chat_365/utils/ui/app_border_and_radius.dart';
import 'package:chat_365/utils/ui/app_dialogs.dart';
import 'package:chat_365/utils/ui/app_padding.dart';
import 'package:chat_365/utils/ui/widget_utils.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class SetUpAccountInformationScreen extends StatefulWidget {
  final AuthMode mode;
  const SetUpAccountInformationScreen({Key? key, required this.mode})
      : super(key: key);

  static const authModeArg = 'authModeArg';
  @override
  _SetUpAccountInformationScreenState createState() =>
      _SetUpAccountInformationScreenState();
}

class _SetUpAccountInformationScreenState
    extends State<SetUpAccountInformationScreen> {
  final _form = GlobalKey<FormState>();
  //*Dung de cuon trong -> ngoai
  final ScrollController _scrollController = ScrollController();
  //*Dung cho man nhan vien
  TextEditingController _textNameCompanyController = TextEditingController();
  TextEditingController _textDateController = TextEditingController();
  late SelectableItem _department;
  TextEditingController _textDepartmentController = TextEditingController();
  late SelectableItem _position;
  TextEditingController _textPositionController = TextEditingController();
  late SelectableItem _gender;
  TextEditingController _textGenderController = TextEditingController();
  late SelectableItem _marriage;
  TextEditingController _textMarriageController = TextEditingController();
  late SelectableItem _education;
  TextEditingController _textEducationController = TextEditingController();
  SelectableItem? _group;
  TextEditingController _textGroupController = TextEditingController();
  SelectableItem? _nest;
  TextEditingController _textNestController = TextEditingController();
  late SelectableItem _work;
  TextEditingController _textWorkController = TextEditingController();
  late SelectableItem _permision;
  TextEditingController _textPermisionController = TextEditingController();

  //*Dung chung cac man
  bool accept = false;
  TextEditingController _textAccountController = TextEditingController();
  TextEditingController _textPhoneNumberController = TextEditingController();
  TextEditingController _textNameController = TextEditingController();
  TextEditingController _textPass1Controller = TextEditingController();
  TextEditingController _textEditingPass2Controller = TextEditingController();
  TextEditingController _textAddressController = TextEditingController();

  //*Dung cho validator cua nhap lai mat khau
  bool isChanging = false;

  //*Dung cho viec unfocus se validate phan nhap lai mat khau
  final FocusNode _focusRepeatPassword = FocusNode();
  final _rePasswordKey = GlobalKey<FormFieldState>();

  //*Dung cho validator trung ten cong ty
  final FocusNode _focusNameCompany = FocusNode();
  String? Function(String?)? _validatorNameCompany;
  final _companyKey = GlobalKey<FormState>();

  //*Dung cho validator trung tai khoan
  final FocusNode _focusAccount = FocusNode();
  String? Function(String?)? _validator;
  final _accountKey = GlobalKey<FormState>();

  //* Dung de luu lại gia tri cu cua ten cong ty
  TextEditingController _textOldCompnayNameController = TextEditingController();

  ///La ham dang ky tai khoan
  _btnSetUpAccount(BuildContext context) {
    SignUpCubit signUpCubit = context.read<SignUpCubit>();
    setState(() {
      isChanging = false;
    });

    if (_form.currentState!.validate() == true) {
      //* Dang ky tai khoan khach
      if (context.read<AuthRepo>().userType == UserType.customer)
        signUpCubit.signUpCustomer(_textAccountController.text,
            _textNameController.text, _textPass1Controller.text);

      //* Dang ky tai khoan nhan vien
      if (context.read<AuthRepo>().userType == UserType.staff)
        signUpCubit.signUpEmployee(
            userName: _textNameController.text,
            contactSignUp: _textAccountController.text,
            password: _textPass1Controller.text,
            gender: _gender,
            address: _textAddressController.text,
            date: _textDateController.text,
            department: _department,
            education: _education,
            group: _group,
            marriage: _marriage,
            nest: _nest,
            phoneNumber: _textPhoneNumberController.text,
            position: _position,
            work: _work);

      //* Dang ky tai khoan cong ty
      // if (context.read<AuthRepo>().userType == UserType.company)
      //   AppRouter.toPage(context, AppPages.Auth_ConfirmOTP,
      //       blocValue: context.read<SignUpCubit>(),
      //       arguments: {
      //         ConfirmOTPScreen.isPhoneNumberKey: false,
      //         ConfirmOTPScreen.idTypeScreenToOtp: TypeScreenToOtp.CONFIRMACCOUNT
      //       });
      if (context.read<AuthRepo>().userType == UserType.company)
        signUpCubit.signUpCompany(
          nameCompany: _textNameCompanyController.text,
          userName: _textNameCompanyController.text,
          contactSignUp: _textAccountController.text,
          password: _textPass1Controller.text,
          address: _textAddressController.text,
          phoneNumber: _textPhoneNumberController.text,
        );
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
    //* Kiem tra trung ten cong ty
    _focusNameCompany.addListener(() {
      if (!_focusNameCompany.hasFocus &&
          Validator.validateStringName(_textNameCompanyController.text, '') ==
              null &&
          context.read<AuthRepo>().userType == UserType.company) {
        _textOldCompnayNameController.text = _textNameCompanyController.text;
        context
            .read<SignUpCubit>()
            .checkNameCompany(_textNameCompanyController.text);
      }
    });
    //* Kiem tra trung tai khoan cong ty
    _focusAccount.addListener(() {
      if (!_focusAccount.hasFocus &&
          Validator.requiredInputPhoneOrEmailValidator(
                  _textAccountController.text) ==
              null) {
        context.read<SignUpCubit>().checkAccountExist(
            contactSignUp: _textAccountController.text,
            userType: context.read<AuthRepo>().userType);
      }
    });

    //*
    _validator = (value) => Validator.requiredInputPhoneOrEmailValidator(value);

    //* Gan gia tri mac dinh ban dau cho khach
    // if (context.read<AuthRepo>().userType == UserType.customer) {
    //   _validator = (value) => Validator.requiredInputPhoneValidator(value);
    // }

    //* Gan cac gia tri mac dinh ban dau cho nhan vien
    if (context.read<AuthRepo>().userType == UserType.staff) {
      // _validator = (value) => Validator.requiredInputPhoneValidator(value);
      _textNameCompanyController.text = context.read<SignUpCubit>().nameCompany;
      _position = Position.selectableItemList
          .firstWhere((element) => element.id == '3');
      _textPositionController.text = _position.name;
      _department = context.read<SignUpCubit>().listDepartment.first;
      _textDepartmentController.text = _department.name;
      _gender = Gender.selectableItemList.first;
      _textGenderController.text = _gender.name;
      _marriage = MaritalStatus.selectableItemList.first;
      _textMarriageController.text = _marriage.name;
      _work = WorkExperience.selectableItemList[1];
      _textWorkController.text = _work.name;
      _education = AcademicLevel.selectableItemList.first;
      _textEducationController.text = '';
    }
    //* Gan cac gia tri mac dinh ban dau cho cong ty
    else if (context.read<AuthRepo>().userType == UserType.company) {
      // _validator = (value) => Validator.requiredInputPhoneValidator(value);
      _validatorNameCompany = (value) =>
          Validator.validateStringName(value, StringConst.inputCompanyName);
      _permision = PermisionEmployee.selectableItemList.first;
      _textPermisionController.text = _permision.name;
    }
    super.initState();
  }

  @override
  void dispose() {
    _focusRepeatPassword.dispose();
    _focusNameCompany.dispose();
    _focusAccount.dispose();
    _textNameCompanyController.dispose();
    _textOldCompnayNameController.dispose();
    _textNameController.dispose();
    _textPhoneNumberController.dispose();
    _textDateController.dispose();
    _textAccountController.dispose();
    _textPass1Controller.dispose();
    _textEditingPass2Controller.dispose();
    _textPositionController.dispose();
    _textDepartmentController.dispose();
    _textAddressController.dispose();
    _textGenderController.dispose();
    _textNestController.dispose();
    _textGroupController.dispose();
    _textEducationController.dispose();
    _textMarriageController.dispose();
    _textWorkController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authRepo = context.read<AuthRepo>();
    //* Phan tong tin nhap cho dang ky tai khoan
    final List<Widget> children = [
      //Phan nhap tai khoan
      LabelFormField(title: 'Tài khoản đăng nhập', isRequired: true),
      OutlineTextFormField(
        key: _accountKey,
        controller: _textAccountController,
        style: context.theme.inputStyle,
        focusNode: _focusAccount,
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
      //Ten cong ty
      if (authRepo.userType != UserType.customer) SizedBoxExt.h20,
      if (authRepo.userType != UserType.customer)
        LabelFormField(title: 'Tên công ty', isRequired: true),
      if (authRepo.userType != UserType.customer)
        OutlineTextFormField(
          key: _companyKey,
          controller: _textNameCompanyController,
          readOnly: authRepo.userType == UserType.staff,
          style: context.theme.inputStyle,
          focusNode: _focusNameCompany,
          decoration: context.theme.inputDecoration.copyWith(
            hintText: StringConst.inputNameCompany,
            focusedBorder: authRepo.userType == UserType.company
                ? AppBorderAndRadius.outlineInputFocusedBorder
                : AppBorderAndRadius.outlineInputBorder,
            // disabledBorder: AppBorderAndRadius.outlineInputBorder,
            fillColor: authRepo.userType == UserType.company
                ? context.theme.backgroundColor
                : context.theme.disableColor,
            prefixIcon: WidgetUtils.getFormFieldColorPrefixIcon(
              Images.ic_building,
              color: context.theme.iconColor,
            ),
            hintStyle: context.theme.hintStyle,
          ),
          onChanged: (value) {
            setState(() {
              if (_textOldCompnayNameController.text !=
                  _textNameCompanyController.text)
                _validatorNameCompany = (value) => Validator.validateStringName(
                    _textNameCompanyController.text,
                    StringConst.inputCompanyName);
            });
          },
          validator: _validatorNameCompany,
        ),

      //Nhap ho va ten
      if (authRepo.userType != UserType.company) SizedBoxExt.h20,
      if (authRepo.userType != UserType.company)
        LabelFormField(title: 'Tên người dùng', isRequired: true),
      if (authRepo.userType != UserType.company)
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
            value,
            StringConst.inputFullName,
          ),
        ),

      //So dien thoai
      if (authRepo.userType != UserType.customer) SizedBoxExt.h20,
      if (authRepo.userType != UserType.customer)
        LabelFormField(title: 'Số điện thoại liên hệ', isRequired: true),
      if (authRepo.userType != UserType.customer)
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
          validator: (value) => Validator.requiredInputLandlinePhoneValidator(
            value,
          ),
        ),
      // phone account
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

      //Dia chi
      if (authRepo.userType != UserType.customer) SizedBoxExt.h20,
      if (authRepo.userType != UserType.customer)
        LabelFormField(title: 'Nhập địa chỉ', isRequired: true),

      if (authRepo.userType != UserType.customer)
        OutlineTextFormField(
          controller: _textAddressController,
          style: context.theme.inputStyle,
          keyboardType: TextInputType.streetAddress,
          maxLine: authRepo.userType == UserType.staff ? 1 : 3,
          minLine: authRepo.userType == UserType.staff ? 1 : 3,
          textCapitalization: TextCapitalization.words,
          decoration: context.theme.inputDecoration.copyWith(
            hintText: StringConst.inputDetailAddress,
            contentPadding: AppPadding.formFieldContentPadding,
            prefixIcon: Padding(
              padding: authRepo.userType == UserType.staff
                  ? EdgeInsets.zero
                  : EdgeInsets.only(bottom: 18 * 2),
              child: WidgetUtils.getFormFieldColorPrefixIcon(Images.ic_location,
                  color: context.theme.iconColor, size: 24),
            ),
            hintStyle: context.theme.hintStyle,
          ),
          validator: (value) =>
              Validator.validateStringAddess(_textAddressController.text),
        ),

      if (authRepo.userType == UserType.staff)
        Column(
          children: [
            //Gioi tinh
            SizedBoxExt.h20,
            LabelFormField(title: 'Giới tính', isRequired: true),

            GestureDetector(
              onTap: () => AppDialogs.showListDialog(
                      context: context,
                      list: Gender.selectableItemList,
                      value: _gender)
                  .then((value) {
                if (value != null) _gender = value;
                _textGenderController.text = _gender.name;
              }),
              child: OutlineTextFormField(
                controller: _textGenderController,
                enable: false,
                style: context.theme.inputStyle,
                textCapitalization: TextCapitalization.words,
                decoration: context.theme.inputDecoration.copyWith(
                  hintText: StringConst.selectGender,
                  disabledBorder: AppBorderAndRadius.outlineInputBorder,
                  prefixIcon: WidgetUtils.getFormFieldColorPrefixIcon(
                    Images.ic_gender,
                    color: context.theme.iconColor,
                  ),
                  suffixIcon: WidgetUtils.getFormFieldColorSuffixIcon(
                    Images.ic_dropdownArrow,
                    color: context.theme.iconColor,
                  ),
                  hintStyle: context.theme.hintStyle,
                ),
              ),
            ),

            SizedBoxExt.h20,
            //Chon ngay sinh
            LabelFormField(title: 'Ngày sinh', isRequired: true),
            GestureDetector(
              onTap: () async {
                DateTime? datePick;
                datePick = await showDatePicker(
                  context: context,
                  confirmText: 'XÁC NHẬN',
                  initialDate: _textDateController.text != ''
                      ? DateFormat('dd-MM-yyyy').parse(_textDateController.text)
                      : DateTime.now(),
                  firstDate: DateTime(1925),
                  lastDate: DateTime.now(),
                );
                _textDateController.text = datePick != null
                    ? DateFormat("dd-MM-yyyy").format(datePick).toString()
                    : '';
                setState(() {});
              },
              child: TextFormField(
                key: ValueKey(_textDateController.text),
                enabled: false,
                controller: _textDateController,
                style: context.theme.inputStyle,
                decoration: context.theme.inputDecoration.copyWith(
                    disabledBorder: AppBorderAndRadius.outlineInputBorder,
                    hintText: StringConst.selectDateOfBirth,
                    hintStyle: context.theme.hintStyle,
                    prefixIcon: WidgetUtils.getFormFieldColorPrefixIcon(
                      Images.ic_date_birth,
                      color: context.theme.iconColor,
                    ),
                    errorStyle: TextStyle(color: AppColors.red)),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) => Validator.validateStringBlank(
                    _textDateController.text, StringConst.selectDateOfBirth),
              ),
            ),

            SizedBoxExt.h20,
            // Trinh do hoc van
            LabelFormField(title: 'Trình độ học vấn', isRequired: true),
            GestureDetector(
              onTap: () => AppDialogs.showListDialog(
                      context: context,
                      list: AcademicLevel.selectableItemList,
                      value: _education)
                  .then((value) {
                if (value != null) _education = value;
                if (_education.id == '0') {
                  _textEducationController.text = '';
                } else {
                  _textEducationController.text = _education.name;
                }
                setState(() {});
              }),
              child: OutlineTextFormField(
                key: ValueKey(_textEducationController.text),
                controller: _textEducationController,
                enable: false,
                style: context.theme.inputStyle,
                textCapitalization: TextCapitalization.words,
                decoration: context.theme.inputDecoration.copyWith(
                  hintText: StringConst.selectAcademicLevel,
                  disabledBorder: AppBorderAndRadius.outlineInputBorder,
                  prefixIcon: WidgetUtils.getFormFieldColorPrefixIcon(
                    Images.ic_education,
                    color: context.theme.iconColor,
                  ),
                  suffixIcon: WidgetUtils.getFormFieldColorSuffixIcon(
                    Images.ic_dropdownArrow,
                    color: context.theme.iconColor,
                  ),
                  errorStyle: TextStyle(color: AppColors.red),
                  hintStyle: context.theme.hintStyle,
                ),
                validator: (value) => Validator.validateStringBlank(
                    _textEducationController.text,
                    StringConst.selectAcademicLevel),
              ),
            ),
            SizedBoxExt.h20,
            // Tinh trang hon nhan
            LabelFormField(title: 'Tình trạng hôn nhân', isRequired: false),

            GestureDetector(
              onTap: () => AppDialogs.showListDialog(
                      context: context,
                      list: MaritalStatus.selectableItemList,
                      value: _marriage)
                  .then((value) {
                if (value != null) _marriage = value;
                _textMarriageController.text = _marriage.name;
              }),
              child: OutlineTextFormField(
                enable: false,
                controller: _textMarriageController,
                style: context.theme.inputStyle,
                textCapitalization: TextCapitalization.words,
                decoration: context.theme.inputDecoration.copyWith(
                  hintText: StringConst.selectMaritalStatus,
                  disabledBorder: AppBorderAndRadius.outlineInputBorder,
                  prefixIcon: WidgetUtils.getFormFieldColorPrefixIcon(
                    Images.ic_marriage,
                    color: context.theme.iconColor,
                  ),
                  suffixIcon: WidgetUtils.getFormFieldColorSuffixIcon(
                    Images.ic_dropdownArrow,
                    color: context.theme.iconColor,
                  ),
                  hintStyle: context.theme.hintStyle,
                ),
              ),
            ),
            SizedBoxExt.h20,
            // Kinh nghiem lam viec
            LabelFormField(title: 'Kinh nghiệm làm việc', isRequired: true),

            GestureDetector(
              onTap: () => AppDialogs.showListDialog(
                      context: context,
                      list: WorkExperience.selectableItemList,
                      value: _work)
                  .then((value) {
                if (value != null) _work = value;
                _textWorkController.text = _work.name;
              }),
              child: OutlineTextFormField(
                enable: false,
                controller: _textWorkController,
                style: context.theme.inputStyle,
                textCapitalization: TextCapitalization.words,
                decoration: context.theme.inputDecoration.copyWith(
                  hintText: StringConst.selectMaritalStatus,
                  disabledBorder: AppBorderAndRadius.outlineInputBorder,
                  prefixIcon: WidgetUtils.getFormFieldColorPrefixIcon(
                    Images.ic_work,
                    color: context.theme.iconColor,
                  ),
                  suffixIcon: WidgetUtils.getFormFieldColorSuffixIcon(
                    Images.ic_dropdownArrow,
                    color: context.theme.iconColor,
                  ),
                  hintStyle: context.theme.hintStyle,
                ),
              ),
            ),
            SizedBoxExt.h20,

            // Chuc vu
            LabelFormField(title: 'Chức vụ', isRequired: false),

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
                style: context.theme.inputStyle,
                textCapitalization: TextCapitalization.words,
                decoration: context.theme.inputDecoration.copyWith(
                  hintText: StringConst.selectPosition,
                  disabledBorder: AppBorderAndRadius.outlineInputBorder,
                  prefixIcon: WidgetUtils.getFormFieldColorPrefixIcon(
                    Images.ic_position,
                    color: context.theme.iconColor,
                  ),
                  suffixIcon: WidgetUtils.getFormFieldColorSuffixIcon(
                    Images.ic_dropdownArrow,
                    color: context.theme.iconColor,
                  ),
                  hintStyle: context.theme.hintStyle,
                ),
              ),
            ),
            SizedBoxExt.h20,
            // Phong ban
            LabelFormField(title: 'Phòng ban', isRequired: false),
            GestureDetector(
              onTap: () => AppDialogs.showListDialog(
                      context: context,
                      list: context.read<SignUpCubit>().listDepartment,
                      value: _department)
                  .then((value) {
                setState(() {
                  if (value != null) {
                    //*Kiem tra gia tri chon cu co giong moi khong
                    if (value != _department) {
                      _department = value;
                      _textDepartmentController.text = _department.name;

                      //*Xoa gia tri cu
                      context.read<SignUpCubit>().listNest.clear();
                      context.read<SignUpCubit>().listGroup.clear();
                      _nest = null;
                      _group = null;
                      _textNestController.text = '';
                      _textGroupController.text = '';

                      //*Lay gia tri moi
                      //id = '0' la Chon phong ban
                      if (_department.id != '0')
                        context.read<SignUpCubit>().getNest(_department.id);
                    }
                  }
                });
              }),
              child: OutlineTextFormField(
                controller: _textDepartmentController,
                enable: false,
                style: _department.id == '0'
                    ? context.theme.hintStyle
                    : context.theme.inputStyle,
                textCapitalization: TextCapitalization.words,
                decoration: context.theme.inputDecoration.copyWith(
                  hintText: StringConst.selectDepartment,
                  disabledBorder: AppBorderAndRadius.outlineInputBorder,
                  prefixIcon: WidgetUtils.getFormFieldColorPrefixIcon(
                    Images.ic_department,
                    color: context.theme.iconColor,
                  ),
                  suffixIcon: WidgetUtils.getFormFieldColorSuffixIcon(
                    Images.ic_dropdownArrow,
                    color: context.theme.iconColor,
                  ),
                  hintStyle: context.theme.hintStyle,
                ),
              ),
            ),
            SizedBoxExt.h20,
            // To
            LabelFormField(title: 'Tổ', isRequired: false),
            BlocConsumer<SignUpCubit, SignUpState>(
              listener: (context, state) {
                if (state is GetNestStateError) {
                  AppDialogs.toast('Lấy danh sách tổ thất bại');
                }
              },
              buildWhen: (previous, current) =>
                  current is GetNestStateLoad ||
                  current is GetNestStateSuccess ||
                  current is GetNestStateError,
              builder: (context, state) {
                if (state is GetNestStateLoad) {
                  return OutlineTextFormField(
                    controller: _textNestController,
                    enable: false,
                    style: context.theme.inputStyle,
                    textCapitalization: TextCapitalization.words,
                    decoration: context.theme.inputDecoration.copyWith(
                      hintText: StringConst.selectNest,
                      // disabledBorder: AppBorderAndRadius.outlineInputBorder,
                      prefixIcon: WidgetUtils.getFormFieldColorPrefixIcon(
                        Images.ic_nest,
                        color: context.theme.iconColor.withOpacity(0.8),
                      ),
                      suffixIcon: Padding(
                        padding: EdgeInsets.only(right: 18),
                        child: SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                              color: context.theme.iconColor.withOpacity(0.8)),
                        ),
                      ),
                      hintStyle: context.theme.hintStyle,
                    ),
                  );
                } else if (state is GetNestStateSuccess &&
                    context.read<SignUpCubit>().listNest.isNotEmpty) {
                  return GestureDetector(
                    onTap: () => AppDialogs.showListDialog(
                            context: context,
                            list: context.read<SignUpCubit>().listNest,
                            value: _nest)
                        .then((value) {
                      setState(() {
                        if (value != null) {
                          if (_nest != value) {
                            _nest = value;
                            _textNestController.text = _nest!.name;
                            _group = null;
                            _textGroupController.text = '';
                            context.read<SignUpCubit>().getGroup(_nest!.id);
                          }
                        }
                      });
                    }),
                    child: OutlineTextFormField(
                      controller: _textNestController,
                      enable: false,
                      style: context.theme.inputStyle,
                      textCapitalization: TextCapitalization.words,
                      decoration: context.theme.inputDecoration.copyWith(
                        hintText: StringConst.selectNest,
                        disabledBorder: AppBorderAndRadius.outlineInputBorder,
                        prefixIcon: WidgetUtils.getFormFieldColorPrefixIcon(
                          Images.ic_nest,
                          color: context.theme.iconColor,
                        ),
                        suffixIcon: WidgetUtils.getFormFieldColorSuffixIcon(
                          Images.ic_dropdownArrow,
                          color: context.theme.iconColor,
                        ),
                        hintStyle: context.theme.hintStyle,
                      ),
                    ),
                  );
                }
                return GestureDetector(
                  onTap: () {
                    if (_department.id == '0') {
                      AppDialogs.toast('Vui lòng chọn phòng ban');
                    }
                    if (_department.id != '0') {
                      AppDialogs.toast('Phòng ban không có tổ');
                    }
                  },
                  child: OutlineTextFormField(
                    controller: _textNestController,
                    enable: false,
                    style: context.theme.inputStyle,
                    textCapitalization: TextCapitalization.words,
                    decoration: context.theme.inputDecoration.copyWith(
                      hintText: StringConst.selectNest,
                      // disabledBorder: AppBorderAndRadius.outlineInputBorder,
                      prefixIcon: WidgetUtils.getFormFieldColorPrefixIcon(
                        Images.ic_nest,
                        color: context.theme.iconColor.withOpacity(0.6),
                      ),
                      suffixIcon: WidgetUtils.getFormFieldColorSuffixIcon(
                        Images.ic_dropdownArrow,
                        color: context.theme.iconColor.withOpacity(0.6),
                      ),
                      hintStyle: context.theme.hintStyle,
                    ),
                  ),
                );
              },
            ),
            SizedBoxExt.h20,
            // nhom
            LabelFormField(title: 'Nhóm', isRequired: false),

            BlocConsumer<SignUpCubit, SignUpState>(
                listener: (context, state) {
                  if (state is GetNestStateError) {
                    AppDialogs.toast('Lấy danh sách tổ thất bại');
                  }
                },
                buildWhen: (previous, current) =>
                    current is GetGroupStateLoad ||
                    current is GetGroupStateSuccess ||
                    current is GetGroupStateError,
                builder: (context, state) {
                  if (state is GetGroupStateLoad) {
                    return OutlineTextFormField(
                      controller: _textGroupController,
                      enable: false,
                      style: context.theme.inputStyle,
                      textCapitalization: TextCapitalization.words,
                      decoration: context.theme.inputDecoration.copyWith(
                        hintText: StringConst.selectGroup,
                        // disabledBorder:
                        //     AppBorderAndRadius.outlineInputBorder,
                        prefixIcon: WidgetUtils.getFormFieldColorPrefixIcon(
                          Images.ic_group,
                          color: context.theme.iconColor.withOpacity(0.6),
                        ),
                        suffixIcon: Padding(
                          padding: EdgeInsets.only(right: 18),
                          child: SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                                color:
                                    context.theme.iconColor.withOpacity(0.8)),
                          ),
                        ),
                        hintStyle: context.theme.hintStyle,
                      ),
                    );
                  } else if (state is GetGroupStateSuccess &&
                      context.read<SignUpCubit>().listGroup.isNotEmpty) {
                    return GestureDetector(
                      onTap: () => AppDialogs.showListDialog(
                              context: context,
                              list: context.read<SignUpCubit>().listGroup,
                              value: _position)
                          .then((value) {
                        if (value != null) _group = value;
                        if (_group != null)
                          _textGroupController.text = _group!.name;
                      }),
                      child: OutlineTextFormField(
                        controller: _textGroupController,
                        enable: false,
                        style: context.theme.inputStyle,
                        textCapitalization: TextCapitalization.words,
                        decoration: context.theme.inputDecoration.copyWith(
                          hintText: StringConst.selectGroup,
                          disabledBorder: AppBorderAndRadius.outlineInputBorder,
                          prefixIcon: WidgetUtils.getFormFieldColorPrefixIcon(
                            Images.ic_group,
                            color: context.theme.iconColor,
                          ),
                          suffixIcon: WidgetUtils.getFormFieldColorSuffixIcon(
                            Images.ic_dropdownArrow,
                            color: context.theme.iconColor,
                          ),
                          hintStyle: context.theme.hintStyle,
                        ),
                      ),
                    );
                  }
                  return GestureDetector(
                    onTap: () {
                      if (_nest == null) {
                        AppDialogs.toast('Vui lòng chọn tổ');
                      }
                      if (_nest != null) {
                        AppDialogs.toast('Tổ không có nhóm');
                      }
                    },
                    child: OutlineTextFormField(
                      controller: _textGroupController,
                      enable: false,
                      style: context.theme.inputStyle,
                      textCapitalization: TextCapitalization.words,
                      decoration: context.theme.inputDecoration.copyWith(
                        hintText: StringConst.selectGroup,
                        // disabledBorder:
                        //     AppBorderAndRadius.outlineInputBorder,
                        prefixIcon: WidgetUtils.getFormFieldColorPrefixIcon(
                          Images.ic_group,
                          color: context.theme.iconColor.withOpacity(0.6),
                        ),
                        suffixIcon: WidgetUtils.getFormFieldColorSuffixIcon(
                          Images.ic_dropdownArrow,
                          color: context.theme.iconColor.withOpacity(0.6),
                        ),
                        hintStyle: context.theme.hintStyle,
                      ),
                    ),
                  );
                }),
            // SizedBoxExt.h20,
            // FillButton(
            //   width: double.infinity,
            //   title: 'Thiết lập',
            //   onPressed: () => _btnSetUpAccount(context),
            // ),
          ],
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
          }
          //*Kiem tra trung ten cong ty
          if (state is CheckNameCompanyStateLoad) {
          } else if (state is CheckNameCompanyStateSuccess) {
          } else if (state is CheckNameCompanyStateError) {
            if (state.errorRes != null) {
              setState(() {
                _validatorNameCompany = (value) => state.errorRes!.messages;
              });
            }
          }
          //*Phan dang ky
          else if (state is SignUpStateLoad) {
            AppDialogs.showLoadingCircle(context);
          } else if (state is SignUpStateSuccess) {
            AppDialogs.hideLoadingCircle(context);
            AppRouter.toPage(context, AppPages.Auth_SignUpSuccess, arguments: {
              'phone': _textAccountController.text,
              'password': _textPass1Controller.text,
              'userType': context.read<AuthRepo>().userType,
            });
          } else if (state is SignUpCompanyStateSuccess) {
            AppDialogs.hideLoadingCircle(context);
            AppRouter.toPage(context, AppPages.Auth_ConfirmOTP,
                blocValue: context.read<SignUpCubit>(),
                arguments: {
                  ConfirmOTPScreen.isPhoneNumberKey:
                      !_textAccountController.text.contains('@'),
                  ConfirmOTPScreen.idTypeScreenToOtp:
                      TypeScreenToOtp.CONFIRMACCOUNT
                });
          } else if (state is SignUpStateError) {
            AppDialogs.hideLoadingCircle(context);
            if (context.read<SignUpCubit>().error != null) {
              if (context.read<SignUpCubit>().error!.code == 200) {
                setState(() {
                  if (_textAccountController.text.contains('@'))
                    _validator = (value) => 'Địa chỉ email đăng ký đã tồn tại';
                  if (!_textAccountController.text.contains('@'))
                    _validator = (value) => 'Số điện thoại đăng ký đã tồn tại';
                });
              }
            }
            AppDialogs.toast(state.error);
          }
        },
        child: CustomAuthScaffold(
          // title: 'Thiết lập thông tin tài khoản',
          extendBodyBehindAppBar: true,
          scrollAble: true,
          useAppBar: true,
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Container(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Form(
                key: _form,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        Images.img_logo_non_text,
                        width: 100,
                      ),
                      SizedBoxExt.h30,
                      Text(
                        context.read<AuthRepo>().userType == UserType.customer
                            ? StringConst.signUpCustomer
                            : context.read<AuthRepo>().userType ==
                                    UserType.staff
                                ? StringConst.fillInfoAccount
                                : StringConst.signUpCompany,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          color: context.theme.primaryColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBoxExt.h40,
                      Container(
                        // constraints: BoxConstraints(
                        //     maxHeight:
                        //         MediaQuery.of(context).size.height /
                        //             2.5
                        // ),
                        child: Column(
                          children: children,
                        ),
                      ),
                      SizedBoxExt.h20,
                      //*Phần quyền thoả thuận người dùng
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: AppTextStyles.regularW400(
                              context,
                              size: 16,
                            ),
                            children: [
                              TextSpan(
                                  text: 'Bằng cách nhấn vào ',
                                  style: AppTextStyles.regularW400(
                                    context,
                                    size: 16,
                                  )),
                              TextSpan(
                                  text: 'tiếp tục',
                                  style: AppTextStyles.regularW400(context,
                                      size: 16, color: AppColors.orange)),
                              TextSpan(
                                  text: ', đã bạn đồng ý với ',
                                  style: AppTextStyles.regularW400(
                                    context,
                                    size: 16,
                                  )),
                              TextSpan(
                                  text: 'Thoả thuận sử dụng ',
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      openUrl(StringConst.urlRules);
                                    },
                                  style: AppTextStyles.regularW400(context,
                                      size: 16, color: AppColors.primary)),
                              TextSpan(
                                  text: 'Chat365.',
                                  style: AppTextStyles.regularW400(
                                    context,
                                    size: 16,
                                    lineHeight: 22,
                                  )),
                            ],
                          ),
                        ),
                      ),
                      SizedBoxExt.h20,

                      // Nut chuc nang
                      FillButton(
                        width: double.infinity,
                        title: 'Tiếp tục',
                        onPressed: () => _btnSetUpAccount(context),
                      ),

                      SizedBoxExt.h30,
                      if (context.read<AuthRepo>().userType != UserType.staff)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              StringConst.doHaveAnAccount,
                              style: TextStyle(
                                shadows: <Shadow>[
                                  Shadow(
                                    offset: Offset(0, 0),
                                    blurRadius: 4.0,
                                    color: context.theme.backgroundColor,
                                  ),
                                ],
                                fontSize: 16,
                                color: context.theme.textColor,
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            InkWell(
                              onTap: () {
                                if (widget.mode == AuthMode.LOGIN) {
                                  AppRouter.back(context);
                                } else
                                  AppRouterHelper.toLoginPage(context,
                                      userType:
                                          context.read<AuthRepo>().userType,
                                      authMode: AuthMode.REGISTER);
                              },
                              child: Text(
                                StringConst.login,
                                style: AppTextStyles.regularW700(context,
                                    size: 18, color: AppColors.primary),
                              ),
                            ),
                          ],
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
                    ]),
              ),
            ),
          ),
        ));
  }
}
