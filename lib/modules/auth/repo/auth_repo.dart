import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:chat_365/core/constants/api_path.dart';
import 'package:chat_365/core/constants/app_constants.dart';
import 'package:chat_365/core/constants/local_storage_key.dart';
import 'package:chat_365/core/error_handling/exceptions.dart';
import 'package:chat_365/core/interfaces/interface_user_info.dart';
import 'package:chat_365/data/services/sp_utils_service/sp_utils_services.dart';
import 'package:chat_365/modules/auth/modules/login/models/login_model.dart';
import 'package:chat_365/modules/auth/modules/login/models/result_login.dart';
import 'package:chat_365/utils/data/clients/api_client.dart';
import 'package:chat_365/utils/data/enums/auth_status.dart';
import 'package:chat_365/utils/data/enums/type_screen_to_otp.dart';
import 'package:chat_365/utils/data/enums/user_type.dart';
import 'package:chat_365/utils/data/extensions/string_extension.dart';
import 'package:chat_365/utils/data/models/exception_error.dart';
import 'package:chat_365/utils/data/models/request_method.dart';
import 'package:chat_365/utils/data/models/request_response.dart';
import 'package:chat_365/utils/helpers/logger.dart';
import 'package:chat_365/utils/helpers/system_utils.dart';
import 'package:dio/dio.dart';
import 'package:sp_util/sp_util.dart';

class AuthRepo {
  /// [UserType] hiện tại
  UserType _userType = UserType.unAuth;

  UserType get userType => _userType;

  set userType(UserType value) => _userType = value;

  /// Thông tin người dùng hiện tại
  IUserInfo? _userInfo;

  IUserInfo? get userInfo => _userInfo;

  set userInfo(IUserInfo? info) => _userInfo = info;

  String get userName => _userInfo?.name ?? '';

  int? get userId => _userInfo?.id;

  List<int>? get userAvatar => _userInfo?.avatar;

  //
  static String? get idUser => SpUtil.getString('id_user', defValue: null);

  static String? get nameUser => SpUtil.getString('name_user', defValue: null);

  static String? get deviceID =>
      SpUtil.getString(AppConst.DEVICE_ID, defValue: null);

  final _controller = StreamController<AuthStatus>.broadcast();

  Stream<AuthStatus> get status async* {
    bool hasInfoInLocalStorage = checkInfoInLocalStorage();
    if (hasInfoInLocalStorage) {
      try {
        _userType = UserType.fromJson(json.decode(spService.userType!));
        _userInfo = IUserInfo.fromLocalStorageJson(
          json.decode(spService.userInfo!),
          userType: _userType,
        );

        await tryFetchNewUserInfo();
      } catch (e, s) {
        logger.logError(e, s);
        // spService.clearToLogout();
        if (e is CustomException && !e.error.isNetworkException)
          yield AuthStatus.unauthenticated;
      }
      yield AuthStatus.authenticated;
    } else {
      yield AuthStatus.unauthenticated;
    }
    yield* _controller.stream;
  }

  static bool checkInfoInLocalStorage() =>
      !spService.userInfo.isBlank && !spService.userType.isBlank;

  void saveNewestUserInfo(
    IUserInfo newUserInfo,
    int newCountConversation,
  ) async {
    _userInfo = newUserInfo;
    await spService.saveUserInfo(_userInfo!);
    if (newCountConversation != 0)
      await spService.saveTotalConversation(newCountConversation);
  }

  tryFetchNewUserInfo() async {
    /// Fetch thông tin mới nhất của người dùng
    var fetchNewestUserInfoResult = await getUserInfo(
      _userInfo!.id,
      retryTime: 1,
    );
    if (!fetchNewestUserInfoResult.hasError) {
      var resultLoginData =
          resultLoginFromJson(fetchNewestUserInfoResult.data).data!;
      var userInfo = resultLoginData.userInfo;
      saveNewestUserInfo(
        userInfo,
        resultLoginData.countConversation,
      );
    } else
      throw fetchNewestUserInfoResult.error?.messages ?? '';
  }

  Future<RequestResponse> login(UserType userType, LoginModel loginModel,
      {bool isMD5Pass = false}) {
    return ApiClient().fetch(
      ApiPath.login,
      // 'http://43.239.223.142:9000/api/conv/auth/login',
      // isFormData: false,
      data: loginModel.toMap(
        userType.id.toString(),
        isMD5Pass: isMD5Pass,
      ),
      options: Options(
        receiveTimeout: 5000,
      ),
    );
  }

  ///QR Login
  Future<RequestResponse> getInfoQR(String? idUser) {
    return ApiClient().fetch(
      ApiPath.get_info_login,
      data: {
        'id': idUser,
      },
      options: Options(
        receiveTimeout: 5000,
      ),
    );
  }

  Future<RequestResponse> getListContact(int? idUser) {
    return ApiClient().fetch(
      ApiPath.get_list_contact + '${idUser}',
      options: Options(
        receiveTimeout: 5000,
      ),
      method: RequestMethod.get,
    );
  }

  Future<RequestResponse> confirmLogin(String listContact) {
    return ApiClient().fetch(
      ApiPath.confirm_login,
      data: {
        'myId': SpUtil.getInt(LocalStorageKey.userId2),
        'IdDevice': SpUtil.getString(LocalStorageKey.idDevice),
        'NameDevice':
            '${SpUtil.getString(LocalStorageKey.nameDevice)} - ${Platform.isAndroid ? 'Android' : 'Ios'}',
        'listUserId': listContact,
      },
      options: Options(
        receiveTimeout: 5000,
      ),
      method: RequestMethod.post,
    );
  }

  // /// Chi dung de dang nhap tai khoan Cong ty va Nhan vien
  // Future<RequestResponse> loginAccountCompany(
  //     UserType userType, LoginModel loginModel) {
  //   return ApiClient().fetch(
  //     userType == UserType.company
  //         ? ApiPath.loginCompany
  //         : ApiPath.loginEmployee,
  //     data: loginModel.toMapAccountCompnay(),
  //     options: Options(
  //       receiveTimeout: 3000,
  //     ),
  //   );
  // }

  Future<RequestResponse> getUserInfo(
    int id, {
    int retryTime = AppConst.refecthApiThreshold,
  }) =>
      ApiClient().fetch(
        ApiPath.getUserInfo,
        data: {'ID': id},
        options: Options(
          receiveTimeout: 1000,
        ),
        retryTime: retryTime,
      );

  Future<RequestResponse> compareId(String idCompany) {
    return ApiClient().fetch(
      ApiPath.detailCompany,
      method: RequestMethod.get,
      searchParams: {'id_com': idCompany},
      options: Options(
        receiveTimeout: 10000,
      ),
    );
  }

  Future<RequestResponse> getOTPForgotPassword(String email, int idUserType) {
    return ApiClient().fetch(
      ApiPath.sendOtp,
      data: {
        'email': email,
        'type_user': idUserType == 1 ? '2' : '1',
        'type_otp': 1
      },
      options: Options(
        receiveTimeout: 10000,
      ),
    );
  }

  // /// Chi dung cho dang ky tai khoan khach
  // Future<RequestResponse> getOTPSignUp(String email) {
  //   return ApiClient().fetch(
  //     ApiPath.register,
  //     data: {'Email': email},
  //     options: Options(
  //       receiveTimeout: 10000,
  //     ),
  //   );
  // }

  /// Dung cho gui otp cong ty
  Future<RequestResponse> sendOtpCompany({required String email}) {
    return ApiClient().fetch(
      ApiPath.sendOtp,
      // method: RequestMethod.get,
      data: {
        'email': email,
        'type_user': userType == UserType.company ? '2' : '1',
        'type_otp': 0,
      },
      options: Options(
        receiveTimeout: 10000,
      ),
    );
  }

  /// Dung de xac thuc otp tai khoan cong ty
  Future<RequestResponse> compareOTP(
      {required String email,
      required String otp,
      required TypeScreenToOtp typeOtp}) {
    return ApiClient().fetch(
      ApiPath.verifyOtp,
      // method: RequestMethod.get,
      data: {
        'email': email,
        'type_user': userType == UserType.company ? '2' : '1',
        'otp_code': otp,
        'type_otp': typeOtp == TypeScreenToOtp.CONFIRMACCOUNT ? '0' : '1'
      },
      options: Options(
        receiveTimeout: 10000,
      ),
    );
  }

  Future<RequestResponse> signUp(
      {required String account,
      required String userName,
      required String password}) {
    return ApiClient().fetch(
      ApiPath.signUp,
      data: {
        'Email': account,
        'Password': password.trim(),
        'UserName': userName.trim(),
      },
      options: Options(
        receiveTimeout: 10000,
      ),
    );
  }

  Future<RequestResponse> signUpEmployee(
      {required String email,
      required String userName,
      required String password,
      required String phoneNumber,
      required String address,
      required String gender,
      required String dateOfBirth,
      required String idAcademicLevel,
      required String idMaritalStatus,
      required String idWorkExperience,
      required String? idNest,
      required String? idGroup,
      required String idCompany,
      required String idDepartment,
      required String idPosition}) {
    return ApiClient().fetch(
      ApiPath.signUpEmployee,
      data: {
        'email': email,
        'password': password,
        'ep_name': userName.trim(),
        'ep_phone': phoneNumber,
        'role': 4,
        'com_id': idCompany,
        'dep_id': idDepartment,
        'position': idPosition,
        'ep_address': address.trim(),
        'gioi_tinh': gender,
        'user_birthday': dateOfBirth,
        'hoc_van': idAcademicLevel,
        'start_time': '',
        'hon_nhan': idMaritalStatus,
        'n_kinh_nghiem': idWorkExperience,
        'id_to': idNest,
        'id_nhom': idGroup,
        //!Phan de tu kich hoat tai khoan api chamcong
        'from': 'chat365',
      },
      options: Options(
        receiveTimeout: 10000,
      ),
    );
  }

  Future<RequestResponse> signUpCompany({
    required String email,
    required String userName,
    required String password,
    required String phoneNumber,
    required String address,
  }) {
    return ApiClient().fetch(
      ApiPath.signUpCompany,
      data: {
        'email': email,
        'password': password,
        'company_name': userName.trim(),
        'company_phone': phoneNumber,
        'company_address': address.trim(),
        //!Phan de tu kich hoat tai khoan api chamcong
        // 'from': 'chat365',
      },
      options: Options(
        receiveTimeout: 10000,
      ),
    );
  }

  Future<RequestResponse> addEmployee({
    required String idCompany,
    required String email,
    required String userName,
    required String password,
    required String phoneNumber,
    required String address,
    required String idPosition,
    required String idPermision,
  }) {
    return ApiClient().fetch(
      ApiPath.addFirstEmployee,
      data: {
        'email': email,
        'password': password,
        'ep_name': userName.trim(),
        'ep_phone': phoneNumber,
        'role': idPermision,
        'com_id': idCompany,
        'ep_address': address.trim(),
        'position_id': idPosition,
        'from': 'chat365',
      },
      options: Options(
        receiveTimeout: 10000,
      ),
    );
  }

  Future<RequestResponse> checkIdCompany({required String id_com}) {
    return ApiClient().fetch(
      ApiPath.detailCompany,
      method: RequestMethod.get,
      searchParams: {
        'id_com': id_com,
      },
      options: Options(
        receiveTimeout: 10000,
      ),
    );
  }

  Future<RequestResponse> getNests(
      {required String idCom, required String idDepartment}) {
    return ApiClient().fetch(
      ApiPath.getListNest,
      method: RequestMethod.get,
      searchParams: {
        'id_nest': idDepartment,
        'cp': idCom,
      },
      options: Options(
        receiveTimeout: 10000,
      ),
    );
  }

  Future<RequestResponse> getGroups(
      {required String idCom, required String idNest}) {
    return ApiClient().fetch(
      ApiPath.getListGroup,
      method: RequestMethod.get,
      searchParams: {
        'id_nhom': idNest,
        'cp': idCom,
      },
      options: Options(
        receiveTimeout: 10000,
      ),
    );
  }

  Future<RequestResponse> checkNameCompany({required String nameCompany}) {
    return ApiClient().fetch(
      ApiPath.checkNameCompany,
      data: {'username': nameCompany.trim()},
      options: Options(
        receiveTimeout: 10000,
      ),
    );
  }

  ///Ham kiem tra account bi trung hay khong
  ///Khong nhat thiet truyen id nguoi dung vi com id moi la bien phan biet
  Future<RequestResponse> checkAccount(
      {required String contactSignUp,
      required UserType userType,
      required String? idCompany}) {
    return ApiClient().fetch(
      ApiPath.checkAccount,
      data: {
        'email': contactSignUp,
        'type_user': userType == UserType.company ? 2 : 1,
        if (idCompany != null) 'com_id': idCompany
      },
      options: Options(
        receiveTimeout: 10000,
      ),
    );
  }

  Future<RequestResponse> updatePassword(
      {required String contactSignUp,
      required String password,
      required int idType}) {
    return ApiClient().fetch(
      ApiPath.updatePassword,
      data: {
        'Email': contactSignUp,
        'Password': password,
        'Type365': idType,
      },
      options: Options(
        receiveTimeout: 10000,
      ),
    );
  }

  Future<RequestResponse> changePassword(
      {required String contactSignUp,
      required String newPassword,
      required String oldPassword,
      required int idType,
      required int idUser}) {
    return ApiClient().fetch(
      ApiPath.changePassword,
      data: {
        'Email': contactSignUp,
        'newPassword': newPassword,
        'oldPassword': oldPassword,
        'Type365': idType,
        'ID': idUser,
      },
      options: Options(
        receiveTimeout: 10000,
      ),
    );
  }

  Future<RequestResponse> getDepartment({required String id_com}) {
    return ApiClient().fetch(
      ApiPath.detailCompany,
      data: {
        'id_com': id_com,
      },
      options: Options(
        receiveTimeout: 10000,
      ),
    );
  }

  Future<ExceptionError?> deleteAccount() async {
    var res = await ApiClient().fetch(
      ApiPath.deleteAccount,
      data: {
        'email': userInfo?.email,
        'id': userInfo?.id,
        'id365': userInfo?.id365,
      },
    );

    try {
      return res.onCallBack((_) => null, predicate: () => res.result == true);
    } on CustomException catch (e, s) {
      logger.logError(e, s);
      return ExceptionError('Xóa tài khoản thất bại');
    }
  }

  Future<bool> updateFirebaseToken(
      String userId, String firebaseToken, UserType userType) async {
    try {
      var _deviceID = deviceID;
      if (_deviceID == null) {
        String? deviceId = await SystemUtils.getIDDevice();
        SpUtil.putString(AppConst.DEVICE_ID, deviceId!);
        _deviceID = deviceId;
      }
      var _typeUser = userType.id;
      print("userId: ${userId}, deviceID: ${deviceID}");

      Map<String, dynamic> body = {
        'user_id': userId,
        'type_user': _typeUser,
        'firebase_token': firebaseToken,
        'device_id': _deviceID,
        'from': 'chat365',
      };

      RequestResponse res = await ApiClient().fetch(
        ApiPath.UPDATE_FIREBASE_TOKEN,
        method: RequestMethod.post,
        data: body,
      );

      if (res.result!) {
        return true;
      } else {
        print("${res.error!.messages}");
        return false;
      }
    } catch (e) {
      // rethrow;
      print("${e}");
      return false;
    }
  }

  logout() async {
    await SPService().clearToLogout();
    // chatClient.emit(
    //   ChatSocketEvent.logout,
    //   userId,
    // );
    userInfo = null;
  }

  void dispose() {
    _controller.close();
  }
}
