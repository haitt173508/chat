import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:chat_365/common/models/selectable_Item.dart';
import 'package:chat_365/core/error_handling/app_error_state.dart';
import 'package:chat_365/modules/auth/repo/auth_repo.dart';
import 'package:chat_365/utils/data/enums/type_screen_to_otp.dart';
import 'package:chat_365/utils/data/enums/user_type.dart';
import 'package:chat_365/utils/data/models/error_response.dart';
import 'package:equatable/equatable.dart';

part 'signup_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit(this._authRepo) : super(SignUpInitial());
  AuthRepo _authRepo;

  // String otp = '';
  String nameCompany = '';
  String password = '';
  String idCompany = '';
  late String contactSignUp;
  bool companyHasSignUp = false;

  /// Dung cho chuyen man xac thuc otp
  List<SelectableItem> listDepartment = [];

  List<SelectableItem> listNest = [];
  List<SelectableItem> listGroup = [];
  ErrorResponse? error;

  void compareIdCompany(
    String idCompany,
  ) async {
    emit(ReSendOtpStateLoad());
    try {
      error = null;
      var res = await _authRepo.compareId(idCompany);
      if (!res.hasError) {
        this.idCompany = idCompany;
        emit(
          SendOtpStateSuccess(),
        );
      } else {
        error = ErrorResponse.fromJson(json.decode(res.data)['error']);
        emit(SendOtpStateError(res.error!.messages!));
      }
    } catch (e) {
      emit(SendOtpStateError(AppErrorStateExt.getFriendlyErrorString(e)));
    }
  }

  // void getOTP(
  //   String email,
  // ) async {
  //   emit(GetOtpStateLoad());
  //   try {
  //     error = null;
  //     var res = await _authRepo.getOTPSignUpCustomer(email);
  //     if (!res.hasError) {
  //       otp = json.decode(res.data)['data']['otp'].toString();
  //       log(otp);
  //       this.contactSignUp = email;

  //       /// Yêu cầu gửi mã otp thành công
  //       emit(
  //         GetOtpStateSuccess(
  //           message: 'Gửi mã xác nhận thành công',
  //         ),
  //       );
  //     } else {
  //       error = ErrorResponse.fromJson(json.decode(res.data)['error']);
  //       emit(GetOtpStateError(res.error!.messages!));
  //     }
  //   } catch (e) {
  //     emit(GetOtpStateError(AppErrorStateExt.getFriendlyErrorString(e)));
  //   }
  // }

  /// Gui ma otp cho chuc nang quen mat khau.
  /// Chi dung khi quen mat khau
  void sendOTPForgetPassword(
    String contactSignUp,
    UserType userType,
    bool isReSend,
  ) async {
    isReSend ? emit(ReSendOtpStateLoad()) : emit(SendOtpStateLoad());
    try {
      error = null;
      this.contactSignUp = contactSignUp;
      var res =
          await _authRepo.getOTPForgotPassword(contactSignUp, userType.id);
      if (!res.hasError) {
        // otp = json.decode(res.data)['data']['otp'].toString();

        isReSend
            ? emit(ReSendOtpStateSuccess())
            : emit(
                SendOtpStateSuccess(),
              );
      } else {
        error = ErrorResponse.fromJson(json.decode(res.data)['error']);
        isReSend
            ? emit(ReSendOtpStateError(res.error!.messages!))
            : emit(SendOtpStateError(res.error!.messages!));
      }
    } catch (e) {
      isReSend
          ? emit(
              ReSendOtpStateError(AppErrorStateExt.getFriendlyErrorString(e)))
          : emit(SendOtpStateError(AppErrorStateExt.getFriendlyErrorString(e)));
    }
  }

  /// Gui ma otp de xac thuc tai khoan cong ty
  void sendOTPCompanyAccount(
    String contactSignUp,
    UserType userType,
    bool isReSend,
  ) async {
    isReSend ? emit(ReSendOtpStateLoad()) : emit(SendOtpStateLoad());

    try {
      error = null;
      this.contactSignUp = contactSignUp;
      var res = await _authRepo.sendOtpCompany(email: contactSignUp);
      if (!res.hasError) {
        // otp = json.decode(res.data)['data']['otp'].toString();
        isReSend
            ? emit(ReSendOtpStateSuccess())
            : emit(
                SendOtpStateSuccess(),
              );
      } else {
        error = ErrorResponse.fromJson(json.decode(res.data)['error']);
        isReSend
            ? emit(ReSendOtpStateError(res.error!.messages!))
            : emit(SendOtpStateError(res.error!.messages!));
      }
    } catch (e) {
      isReSend
          ? emit(
              ReSendOtpStateError(AppErrorStateExt.getFriendlyErrorString(e)))
          : emit(SendOtpStateError(AppErrorStateExt.getFriendlyErrorString(e)));
    }
  }

  void signUpCustomer(
      String accountSignUp, String userName, String password) async {
    emit(SignUpStateLoad());
    try {
      error = null;
      var res = await _authRepo.signUp(
          account: accountSignUp, password: password, userName: userName);
      if (!res.hasError) {
        emit(
          SignUpStateSuccess(
            message: json.decode(res.data)['data']['message'].toString(),
          ),
        );
      } else {
        error = ErrorResponse.fromJson(json.decode(res.data)['error']);
        emit(SignUpStateError(res.error!.messages!));
      }
    } catch (e) {
      emit(SendOtpStateError(AppErrorStateExt.getFriendlyErrorString(e)));
    }
  }

  void signUpEmployee(
      {required String contactSignUp,
      required String userName,
      required String password,
      required String phoneNumber,
      required String address,
      required SelectableItem gender,
      required String date,
      required SelectableItem? education,
      required SelectableItem marriage,
      required SelectableItem work,
      required SelectableItem department,
      required SelectableItem position,
      required SelectableItem? nest,
      required SelectableItem? group}) async {
    emit(SignUpStateLoad());
    try {
      error = null;
      var res = await _authRepo.signUpEmployee(
          address: address,
          dateOfBirth: date,
          gender: gender.id,
          idAcademicLevel: education!.id,
          idGroup: group != null ? group.id : null,
          idMaritalStatus: marriage.id,
          idNest: nest?.id,
          idWorkExperience: work.id,
          email: contactSignUp,
          password: password,
          userName: userName,
          idCompany: idCompany,
          idDepartment: department.id,
          idPosition: position.id,
          phoneNumber: phoneNumber);
      print(res);
      if (!res.hasError) {
        emit(
          SignUpStateSuccess(
            message: json.decode(res.data)['data']['message'].toString(),
          ),
        );
      } else {
        error = ErrorResponse.fromJson(json.decode(res.data)['error']);
        emit(SignUpStateError(res.error!.messages!));
      }
    } catch (e) {
      emit(SignUpStateError(AppErrorStateExt.getFriendlyErrorString(e)));
    }
  }

  void signUpCompany({
    required String nameCompany,
    required String contactSignUp,
    required String userName,
    required String password,
    required String phoneNumber,
    required String address,
  }) async {
    emit(SignUpStateLoad());
    try {
      error = null;

      var res = await _authRepo.checkNameCompany(nameCompany: nameCompany);
      print(res);
      if (json.decode(res.data)['data'] != null) {
        if (json.decode(res.data)['data']['result'] == true) {
          emit(SignUpStateError(''));
          emit(CheckNameCompanyStateError(
              '', ErrorResponse(message: 'Tên công ty đã tồn tại')));
        } else {
          //*Phan dang ky cong ty
          var res = await _authRepo.signUpCompany(
              address: address,
              email: contactSignUp,
              password: password,
              userName: userName,
              phoneNumber: contactSignUp);
          print(res);
          if (!res.hasError) {
            this.contactSignUp = contactSignUp;
            this.password = password;
            idCompany = json.decode(res.data)['data']['id'];
            emit(
              SignUpCompanyStateSuccess(
                message: json.decode(res.data)['data']['message'].toString(),
              ),
            );
          } else {
            error = ErrorResponse.fromJson(json.decode(res.data)['error']);
            emit(SignUpStateError(res.error!.messages!));
          }
        }
      } else {
        emit(SignUpStateError('Đã có lỗi xảy ra, vui lòng thử lại sau'));
      }
    } catch (e) {
      emit(SignUpStateError(AppErrorStateExt.getFriendlyErrorString(e)));
    }
  }

  void addFirstEmployee({
    required String contactSignUp,
    required String userName,
    required String password,
    required String phoneNumber,
    required String address,
    required SelectableItem position,
    required SelectableItem permision,
  }) async {
    emit(AddFirstEmployeeStateLoad());
    try {
      error = null;
      var res = await _authRepo.addEmployee(
        address: address,
        email: contactSignUp,
        password: password,
        userName: userName,
        phoneNumber: phoneNumber,
        idCompany: idCompany,
        idPermision: permision.id,
        idPosition: position.id,
      );
      print(res);
      if (!res.hasError) {
        emit(
          AddFirstEmployeeStateSuccess(
            message: json.decode(res.data)['data']['message'].toString(),
          ),
        );
      } else {
        error = ErrorResponse.fromJson(json.decode(res.data)['error']);
        emit(AddFirstEmployeeStateError(res.error!.messages!));
      }
    } catch (e) {
      emit(AddFirstEmployeeStateError(
          AppErrorStateExt.getFriendlyErrorString(e)));
    }
  }

  checkIdCompany(String idCompany) async {
    emit(CompareIdCompanyStateLoad());
    try {
      error = null;
      var res = await _authRepo.checkIdCompany(id_com: idCompany);
      if (!res.hasError) {
        this.idCompany = json
            .decode(res.data)['data']['detail_company']['com_id']
            .toString();

        //Ten cong ty
        nameCompany = json
            .decode(res.data)['data']['detail_company']['com_name']
            .toString();

        // Lay danh sach phong ban
        listDepartment.clear();
        listDepartment.add(SelectableItem(id: '0', name: 'Chọn phòng ban'));
        var _listDepartmentApi =
            (json.decode(res.data)['data']['list_department'] as List);
        for (int i = 0; i < _listDepartmentApi.length; i++) {
          listDepartment.add(SelectableItem(
              id: _listDepartmentApi[i]['dep_id'],
              name: _listDepartmentApi[i]['dep_name']));
        }

        emit(
          CompareIdCompanyStateSuccess(
            message: json.decode(res.data)['data']['message'].toString(),
          ),
        );
      } else {
        error = ErrorResponse.fromJson(json.decode(res.data)['error']);
        emit(CompareIdCompanyStateError(res.error!.messages!));
      }
    } catch (e) {
      emit(CompareIdCompanyStateError(
          AppErrorStateExt.getFriendlyErrorString(e)));
    }
  }

  ///Kiem tra ten cong ty bi trung
  checkNameCompany(String nameCompany) async {
    emit(CheckNameCompanyStateLoad());
    try {
      error = null;
      var res = await _authRepo.checkNameCompany(nameCompany: nameCompany);
      print(res);
      if (json.decode(res.data)['data'] != null) {
        if (json.decode(res.data)['data']['result'] == true) {
          emit(CheckNameCompanyStateError(
              '', ErrorResponse(message: 'Tên công ty đã tồn tại')));
        } else {
          emit(
            CheckNameCompanyStateSuccess(
              message: json.decode(res.data)['data']['message'],
            ),
          );
        }
      }
    } catch (e) {
      emit(CheckNameCompanyStateError(
          AppErrorStateExt.getFriendlyRequestResponseError(e), null));
    }
  }

  ///Kiem tra tai khoan bi trung
  checkAccountExist(
      {required String contactSignUp, required UserType userType}) async {
    emit(CheckAccountStateLoad());
    try {
      error = null;
      var res = await _authRepo.checkAccount(
          contactSignUp: contactSignUp,
          idCompany: this.idCompany,
          userType: userType);
      print(res);
      if (json.decode(res.data)['data'] != null) {
        if (json.decode(res.data)['data']['result'] == true) {
          emit(
            CheckAccountStateError(
                '', ErrorResponse(message: 'Tài khoản đăng ký đã tồn tại')),
          );
        } else {
          emit(
            CheckAccountStateSuccess(
              message: json.decode(res.data)['data']['message'],
            ),
          );
        }
      }
    } catch (e) {
      emit(CheckAccountStateError(
          AppErrorStateExt.getFriendlyErrorString(e), null));
    }
  }

  /// Cap nhat mat khau
  updatePassword(String password, int idType) async {
    emit(UpdatePassStateLoad());
    try {
      error = null;
      var res = await _authRepo.updatePassword(
          contactSignUp: contactSignUp, password: password, idType: idType);
      if (json.decode(res.data)['data'] != null) {
        emit(
          UpdatePassStateSuccess(
            message: json.decode(res.data)['data']['message'],
          ),
        );
      } else {
        emit(UpdatePassStateError(res.error!.messages!));
      }
    } catch (e) {
      emit(UpdatePassStateError(AppErrorStateExt.getFriendlyErrorString(e)));
    }
  }

  changePassword(
      {required String oldPassword,
      required String newPassword,
      required String email,
      required int idType,
      required int idUser}) async {
    emit(UpdatePassStateLoad());
    try {
      error = null;
      var res = await _authRepo.changePassword(
          contactSignUp: email,
          newPassword: newPassword,
          oldPassword: oldPassword,
          idType: idType,
          idUser: idUser);
      if (json.decode(res.data)['data'] != null) {
        emit(
          ChangePassStateSuccess(
            message: json.decode(res.data)['data']['message'],
          ),
        );
      } else {
        if (json.decode(res.data)['error']['code'] == 200 &&
            (json.decode(res.data)['error']['message'] as String)
                .contains('sai mật khẩu cũ')) {
          error =
              ErrorResponse(code: 200, message: 'Mật khẩu cũ không chính xác');
        }
        emit(ChangePassStateError(res.error!.messages!));
      }
    } catch (e) {
      emit(ChangePassStateError(AppErrorStateExt.getFriendlyErrorString(e)));
    }
  }

  /// Lay danh sach to
  getNest(String idDepartment) async {
    emit(GetNestStateLoad());
    try {
      error = null;
      listNest.clear();
      var res = await _authRepo.getNests(
          idCom: idCompany, idDepartment: idDepartment);
      if (json.decode(res.data)['data'] != null) {
        (json.decode(res.data)['data']['items'] as List).forEach((element) {
          listNest.add(
              SelectableItem(id: element['gr_id'], name: element['gr_name']));
        });
        emit(
          GetNestStateSuccess(
            message: 'Lấy danh sách tổ thành công',
          ),
        );
      } else {
        emit(GetNestStateError('Lấy danh sách tổ thất bại'));
      }
    } catch (e) {
      emit(GetNestStateError(AppErrorStateExt.getFriendlyErrorString(e)));
    }
  }

  /// Lay danh sach nhom
  getGroup(String idNest) async {
    emit(GetGroupStateLoad());
    try {
      error = null;
      listGroup.clear();
      var res = await _authRepo.getGroups(idCom: idCompany, idNest: idNest);
      if (json.decode(res.data)['data'] != null) {
        (json.decode(res.data)['data']['items'] as List).forEach((element) {
          listGroup.add(
              SelectableItem(id: element['gr_id'], name: element['gr_name']));
        });
        emit(
          GetGroupStateSuccess(
            message: 'Lấy danh sách nhóm thành công',
          ),
        );
      } else {
        emit(GetGroupStateError('Lấy danh sách nhóm thất bại'));
      }
    } catch (e) {
      emit(GetGroupStateError(AppErrorStateExt.getFriendlyErrorString(e)));
    }
  }

  /// Xac thuc otp
  void compareOTP(String otp, TypeScreenToOtp typeNeedCompare) async {
    emit(CompareOTPStateLoad());
    try {
      error = null;

      // Neu la quen mat khau check otp api tra ve

      // if (typeNeedCompare == TypeScreenToOtp.FORGOTPASSWORD) {
      //   Debouncer(delay: Duration(milliseconds: 300)).call(() {
      //     if (otp == this.otp) {
      //       emit(
      //         CompareOTPStateSuccess(
      //           message: 'Xác thực otp thành công',
      //         ),
      //       );
      //     } else {
      //       // Fake loi de dung code 200
      //       error = ErrorResponse(
      //         code: 200,
      //         message: 'Mã OTP nhập vào không đúng',
      //       );
      //       emit(CompareOTPStateError('Mã OTP nhập vào không đúng'));
      //     }
      //   });
      // }

      // // la dang ky check otp bang api
      // else {
      var res = await _authRepo.compareOTP(
          email: contactSignUp, otp: otp, typeOtp: typeNeedCompare);
      if (!res.hasError) {
        emit(
          CompareOTPStateSuccess(
            message: json.decode(res.data)['data']['message'],
          ),
        );
      } else {
        error = ErrorResponse.fromJson(json.decode(res.data)['error']);
        emit(CompareOTPStateError(res.error!.messages!));
      }
      // }
    } catch (e) {
      emit(CompareOTPStateError(AppErrorStateExt.getFriendlyErrorString(e)));
    }
  }
}
