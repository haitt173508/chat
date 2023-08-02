import 'package:chat_365/core/constants/string_constants.dart';

class Validator {
  static final String normalTextVietName =
      '[a-zA-ZÀÁÂÃÈÉÊÌÍÒÓÔÕÙÚĂĐĨŨƠàáâãèéêìíòóôõùúăđĩũơƯĂẠẢẤẦẨẪẬẮẰẲẴẶẸẺẼỀỀỂẾưăạảấầẩẫậắằẳẵặẹẻẽềềểếỄỆỈỊỌỎỐỒỔỖỘỚỜỞỠỢỤỦỨỪễệỉịọỏốồổỗộớờởỡợụủứừỬỮỰỲỴÝỶỸửữựỳỵỷỹ]';
  static String? validateStringBlank(String? value, String msg,
          [bool autoToLowerCase = true]) =>
      (value == null || value.isEmpty || value.replaceAll(" ", '').isEmpty)
          ? "Vui lòng ${autoToLowerCase ? msg.toLowerCase() : msg}"
          : null;

  static String? validateStringBlocSpecialCharacters(String? value, String msg,
          [bool autoToLowerCase = true]) =>
      (value == null || value.isEmpty || value.replaceAll(" ", '').isEmpty)
          ? "Vui lòng ${autoToLowerCase ? msg.toLowerCase() : msg}"
          : RegExp(r'[@#_&-+()"*:;!,.?~`|•√π÷×¶∆£€$¢₫^°={}\%©®™✓[\]<>]')
                  .hasMatch(value)
              ? 'Vui lòng không dùng dấu câu hoặc ký tự đặc biệt'
              : null;

  static String? validateStringName(String? value, String msg,
          [bool autoToLowerCase = true]) =>
      (value == null || value.isEmpty || value.replaceAll(" ", '').isEmpty)
          ? "Vui lòng ${autoToLowerCase ? msg.toLowerCase() : msg}"
          : RegExp(r'[@#_&-+()"*:;!,.?~`|•√π÷×¶∆£€$¢₫^°={}\%©®™✓[\]<>]')
                  .hasMatch(value)
              ? 'Vui lòng không dùng dấu câu hoặc ký tự đặc biệt'
              : null;

  static String? validateStringAddess(String? value,
          [bool autoToLowerCase = true]) =>
      (value == null || value.isEmpty || value.replaceAll(" ", '').isEmpty)
          ? "Vui lòng nhập địa chỉ"
          : RegExp(r'[@#_&-+()"*:;!?~`|•√π÷×¶∆£€$¢₫^°={}\%©®™✓[\]<>]')
                  .hasMatch(value)
              ? 'Vui lòng không dùng ký tự đặc biệt'
              : null;

  // static String? validatePassword(String? value) {
  //   if (value == null || value.isEmpty) {
  //     return 'Vui lòng nhập mật khẩu';
  //   }

  //   var pattern = r'^(?=.*[a-zA-Z])(?=.*\d).{6,}$';
  //   var regExp = RegExp(pattern);
  //   if (!regExp.hasMatch(value)) {
  //     return 'Mật khẩu phải từ 6 ký tự gồm ít nhất một chữ và một số';
  //   }
  //   return null;
  // }

  static String? validateLoginPassword(String? value) {
    return Validator.validateStringBlank(
      value,
      StringConst.inputPassword,
    );
  }

  static String? validateSelectNone(String? value, String msg,
          [bool autoToLowerCase = true]) =>
      (value == null || value.isEmpty)
          ? "Vui lòng chọn ${autoToLowerCase ? msg.toLowerCase() : msg}"
          : null;

  static String? validateStringMinimumLength(String value, int minimumLength) =>
      value.length < minimumLength
          ? "Bạn phải nhập ít nhất $minimumLength từ (đã nhập ${value.length}/$minimumLength từ)"
          : null;

  static String? validateNumber(int? value, String msg) =>
      (value == null || value == 0 || value.isNegative) ? msg : null;

  static String? inputContactFullNameValidator(String? value) =>
      validateStringBlank(value, 'tên người liên hệ');

  static String? inputContactAddressValidator(String? value) =>
      validateStringBlank(value, 'địa chỉ liên hệ');

  static String? requiredInputPhoneValidator(String? value) {
    if (value == null || value.isEmpty) return 'Vui lòng nhập số điện thoại';

    if (value.startsWith('84') && value.length != 10)
      return 'Bạn nhập sai số điện thoại';

    if ((value.contains('.') && value.contains('-')) ||
        !RegExp(r'^[\d\.-]+$').hasMatch(value))
      return 'Số điện thoại không chứa ký tự đặc biệt';

    if (!RegExp(
            r'^(0|84)?((3[2-9])|(5[689])|(7[06-9])|(8[1-689])|(9[0-46-9]))(\d)(\d{3})(\d{3})$')
        .hasMatch(value)) return 'Số điện thoại không đúng định dạng';

    return null;
  }

  // static String? requiredInputLandlinePhoneValidator(String? value) {
  //   if (value == null || value.isEmpty) return 'Vui lòng nhập số điện thoại';

  //   if (value.startsWith('84')) return 'Bạn nhập sai số điện thoại';

  //   if ((value.contains('.') && value.contains('-')) ||
  //       !RegExp(r'^[\d\.-]+$').hasMatch(value))
  //     return 'Số điện thoại không chứa ký tự đặc biệt';

  //   bool soban = RegExp(
  //           r'^(0|84)?((20[3-9])|(21[[0-9]])|(22[[0-2]])|(22[5-9])|(28)|(24)|(23[2-9])|(23[2-9])|(25[1-2])|(25[2-9])|(26[1-3])|(269)|(27[0-7])|(29[0-7])|(299))(\d)(\d{7})$')
  //       .hasMatch(value);
  //   bool sodd = RegExp(
  //           r'^(0|84)?((3[2-9])|(5[689])|(7[06-9])|(8[1-689])|(9[0-46-9]))(\d)(\d{3})(\d{3})$')
  //       .hasMatch(value);

  //   if (soban || sodd) {
  //     if (soban && value.length != 11) {
  //       return 'Số điện thoại không đúng định dạng';
  //     } else if (sodd && value.length != 10) {
  //       return 'Số điện thoại không đúng định dạng';
  //     }
  //   } else {
  //     return 'Số điện thoại không đúng định dạng';
  //   }
  //   // if (RegExp(
  //   //         r'^(0|84)?((3[2-9])|(5[689])|(7[06-9])|(8[1-689])|(9[0-46-9]))(\d)?(\d{3})?(\d{3})$')
  //   //     .hasMatch(value)) {
  //   //   if (value.length != 10) {
  //   //     return 'Số điện thoại không đúng định dạng';
  //   //   }
  //   // } else {
  //   //   return 'Số điện thoại không đúng định dạng';
  //   // }

  //   // if (RegExp(
  //   //         r'^(0|84)?((20[3-9])|(21[[0-9]])|(22[[0-2]])|(22[5-9])|(28)|(24)|(23[2-9])|(23[2-9])|(25[1-2])|(25[2-9])|(26[1-3])|(269)|(27[0-7])|(29[0-7])|(299))(\d)(\d{7})$')
  //   //     .hasMatch(value)) {
  //   //   if (value.length != 11) {
  //   //     return 'Số điện thoại không đúng định dạng';
  //   //   }
  //   // } else {
  //   //   return 'Số điện thoại không đúng định dạng';
  //   // }

  //   return null;
  // }
  static String? requiredInputLandlinePhoneValidator(String? value) {
    if (value == null || value.isEmpty) return 'Vui lòng nhập số điện thoại';

    if (value.startsWith('84')) return 'Bạn nhập sai số điện thoại';

    if (RegExp(r'[.-]+').hasMatch(value)) {
      return 'Số điện thoại không chứa ký tự đặc biệt';
    }
    if (RegExp(r'[ ]+').hasMatch(value)) {
      return 'Số điện thoại không chứa khoảng trắng';
    }
    bool soban = RegExp(
            r'^(0|84)?((20[3-9])|(21[0-9])|(22[0-2])|(22[5-9])|(23[2-9])|(23[2-9])|(25[1-2])|(25[2-9])|(26[1-3])|(269)|(27[0-7])|(29[0-7])|(299))(\d{7})$')
        .hasMatch(value);
    if (!soban) {
      soban = RegExp(r'^(0|84)?((28)|(24))(\d{8})$').hasMatch(value);
    }
    if (!soban) {
      soban = RegExp(r'^(0|84)?((28)|(24))(\d{8})$').hasMatch(value);
    }
    bool sodd = RegExp(
            r'^(0|84)?((3[2-9])|(5[689])|(7[06-9])|(8[1-689])|(9[0-46-9]))(\d)(\d{3})(\d{3})$')
        .hasMatch(value);

    if (soban || sodd) {
      if (soban && value.length != 11) {
        return 'Số điện thoại không đúng định dạng';
      } else if (sodd && value.length != 10) {
        return 'Số điện thoại không đúng định dạng';
      }
    } else {
      return 'Số điện thoại không đúng định dạng';
    }

    return null;
  }

  static String? requiredInputPhoneOrEmailValidator(String? value) {
    if (value == null || value.isEmpty)
      return 'Vui lòng nhập số điện thoại hoặc địa chỉ email';
    if (value.contains(' ')) {
      return 'Vui lòng không nhập khoảng trắng';
    }
    if (!(double.tryParse(value) != null)) {
      if (!RegExp(
              r'^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$')
          .hasMatch(value)) return 'Địa chỉ email không đúng định dạng.';
    } else {
      if (value.startsWith('84') && value.length != 11)
        return 'Bạn nhập sai số điện thoại';

      if ((value.contains('.') && value.contains('-')) ||
          !RegExp(r'^[\d\.-]+$').hasMatch(value))
        return 'Số điện thoại không chứa ký tự đặc biệt';

      if (!RegExp(
              r'^(0|84)?((3[2-9])|(5[689])|(7[06-9])|(8[1-689])|(9[0-46-9]))(\d)(\d{3})(\d{3})$')
          .hasMatch(value)) return 'Số điện thoại không đúng định dạng';
    }

    return null;
  }

  static bool _isValidEmail(String email) =>
      RegExp(r'^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$')
          .hasMatch(email);

  static String? inputEmailValidator(String? value) {
    if (value == null || value.isEmpty) return 'Vui lòng nhập email';

    if (!_isValidEmail(value)) return 'Địa chỉ email không đúng định dạng.';

    return null;
  }

  static String? requiredInputEmailValidator(String? value) {
    if (value == null || value.isEmpty) return 'Vui lòng nhập địa chỉ email.';

    if (!_isValidEmail(value)) return 'Địa chỉ email không đúng định dạng.';

    return null;
  }

  static String? requiredNoBlankEmptyPasswordValidator(
    String? value,
  ) {
    if (value == null || value.isEmpty) return 'Vui lòng nhập mật khẩu';
    if (value.contains(' ')) return 'Vui lòng không nhập khoảng trắng';
    // if (!_isValidEmail(value)) return 'Địa chỉ email không đúng định dạng.';

    return null;
  }

  static String? _isValidPassword(String password) {
    var pattern = r'^(?=.*[a-zA-Z])(?=.*\d).{6,}$';
    var regExp = RegExp(pattern);
    // if (!regExp.hasMatch(value)) {
    //   return 'Mật khẩu phải từ 6 ký tự gồm ít nhất một chữ và một số';
    // }
    return password.contains(' ')
        ? 'Mật khẩu không được chứa khoảng trắng'
        : !regExp.hasMatch(password)
            ? 'Mật khẩu phải từ 6 ký tự gồm ít nhất một chữ và một số'

            // : password.length < 6
            //     ? 'Mật khẩu phải tối thiểu 6 ký tự'
            : null;
  }

  static String? inputPasswordValidator(String? value) {
    if (value == null || value.isEmpty) return 'Vui lòng nhập mật khẩu';

    // if (value.contains(' '))
    //   return 'Mật khẩu không được chứa khoảng trắng';
    // if (RegExp(r'^$').hasMatch(value))
    //   return 'Bạn chưa nhập đúng đúng định dạng mật khẩu';

    return _isValidPassword(value);
  }

  static String? reInputPasswordValidator(
      String? value, String password, bool isChanging) {
    if (value == null || value.isEmpty) return 'Vui lòng nhập lại mật khẩu';
    if (value.contains(' '))
      return 'Mật khẩu không được chứa khoảng trắng';
    if (password != value && !isChanging)
      return 'Xác nhận lại mật khẩu mới không trùng khớp.';

    return null;
  }

  static String? requiredInputDeadlineForSubmissionValidator(
      DateTime? selectedValue) {
    if (selectedValue == null) return 'Bạn chưa nhập hạn nộp hồ sơ';

    return null;
  }
}
