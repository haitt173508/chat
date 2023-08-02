import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:chat_365/core/constants/local_storage_key.dart';
import 'package:chat_365/core/constants/string_constants.dart';
import 'package:chat_365/core/interfaces/interface_user_info.dart';
import 'package:chat_365/modules/auth/modules/login/models/get_info_qr_model.dart';
import 'package:chat_365/modules/auth/modules/login/models/login_verification_model.dart';
import 'package:chat_365/modules/auth/modules/login/models/result_login.dart';
import 'package:chat_365/modules/auth/repo/auth_repo.dart';
import 'package:chat_365/service/firebase_service.dart';
import 'package:chat_365/service/injection.dart';
import 'package:chat_365/utils/data/clients/api_client.dart';
import 'package:chat_365/utils/data/enums/user_type.dart';
import 'package:chat_365/utils/data/models/error_response.dart';
import 'package:chat_365/utils/helpers/logger.dart';
import 'package:chat_365/utils/ui/app_dialogs.dart';
import 'package:equatable/equatable.dart';
import 'package:sp_util/sp_util.dart';

import '../models/login_model.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this._authRepo) : super(LoginStateInit());

  final AuthRepo _authRepo;

  void login(
    UserType userType,
    LoginModel loginModel, {
    bool rememberAccount = false,
    bool isMD5Pass = false,
  }) async {
    var res;
    emit(LoginStateLoad());
    try {
      // Dang nhap tai khoang cong ty
      // Can dang nhap ben cham cong truoc se xem xac thuc tai khoan
      // if (userType == UserType.company) {
      //   res = await _authRepo.loginAccountCompany(userType, loginModel);
      //   if (!res.hasError) {
      //     if (json.decode(res.data)['data']['user_info']['com_authentic'] !=
      //         '0') {
      //       res = await _authRepo.login(
      //         userType,
      //         loginModel,
      //       );
      //       if (!res.hasError) {
      //         var data = resultLoginFromJson(res.data).data!;
      //         var userInfo = data.userInfo;
      //         userInfo.avatar =
      //             await ApiClient().downloadImage(userInfo.avatarUser);

      //         /// Đăng nhập thành công
      //         emit(
      //           LoginStateSuccess(
      //             userInfo,
      //             message: 'Đăng nhập thành công',
      //             countConversation: data.countConversation,
      //           ),
      //         );
      //       } else {
      //         emit(LoginStateError(res.error!.messages!,
      //             ErrorResponse.fromJson(json.decode(res.data)['error'])));
      //       }
      //     } else {
      //       emit(LoginStateUnconfirmed('Tài khoản chưa được xác thực'));
      //     }
      //   } else {
      //     emit(LoginStateError(res.error!.messages!,
      //         ErrorResponse.fromJson(json.decode(res.data)['error'])));
      //   }
      // }

      // // Phan dang nhap cua cac tai khoan khac ngoai tai khoan cong ty
      // else {
      res = await _authRepo.login(
        userType,
        loginModel,
        isMD5Pass: isMD5Pass,
      );
      if (!res.hasError) {
        var data = resultLoginFromJson(res.data).data!;
        var userInfo = data.userInfo;
        // userInfo.avatar = await ApiClient().downloadImage(userInfo.avatarUser);
        SpUtil.putInt(LocalStorageKey.userId2, userInfo.id);
        if (data.warning == 1)
          return emit(LoginWaring(
            userInfo,
            countConversation: data.countConversation,
            userType: userType,
          ));

        /// Đăng nhập thành công
        emit(
          LoginStateSuccess(
            userInfo,
            message: 'Đăng nhập thành công',
            countConversation: data.countConversation,
            userType: userType,
          ),
        );
      } else {
        // Khi tai khoan nhan vien chua duoc duyet
        if ((json.decode(res.data)['error']['message'] as String)
            .contains('chưa được duyệt')) {
          emit(LoginStateUnBrowser(
              (json.decode(res.data)['error']['message'] as String)
                  .split('bởi')[1]
                  .trim()));
        }
        //Cac loi khac
        else {
          emit(LoginStateError(res.error!.messages!,
              ErrorResponse.fromJson(json.decode(res.data)['error'])));
        }
      }
      // }
      // print('Gia tri nhan duoc la : ${res.error}');
    } catch (e, s) {
      logger.logError(e, s);
      emit(LoginStateError(StringConst.errorHappenedTryAgain, null));
    }
  }

  // /// Dung de dang nhap lan dau sau khi dang ky de kich hoat tai khoan
  // loginAccountCompany(
  //   UserType userType,
  //   LoginModel loginModel, {
  //   bool rememberAccount = false,
  // }) async {
  //   emit(LoginStateLoad());
  //   var res = await _authRepo.loginAccountCompany(
  //     userType,
  //     loginModel,
  //   );
  //   print('Gia tri nhan duoc la : ${res.error}');
  //   if (!res.hasError) {
  //   } else {
  //     emit(LoginStateError(res.error!.messages!, null));
  //   }
  // }
  String? passQR;
  String? emailQR;
  String? error;
  int? type365;

  Future getInfoQR(
    String? idUser,
  ) async {
    var res = await _authRepo.getInfoQR(idUser);
    emit(LoginLoadingQR());
    try {
      if (res.error == null) {
        emit(LoginSuccessQR());
        var data = loginInfoQrModelFromJson(res.data);
        emailQR = data.data?.userInfo.email;
        passQR = data.data?.userInfo.password;
        type365 = data.data?.userInfo.type365;
        login(UserType.fromId(type365!), LoginModel(emailQR!, passQR!),
            isMD5Pass: true);
      } else {
        error = res.error?.messages;
        emit(LoginErrorQR(res.error?.messages ?? ""));
        // print('Error: ${res.error}');
      }
    } catch (e, s) {
      logger.logError(e, s);
      // emit(LoginErrorQR(e.toString()));
    }
  }

  // List<FriendList> listAccount;
  // List<String> listAccountId ;
  // List<String> listAccountName;

  Future listContact(
    int? idUser,
  ) async {
    var res = await _authRepo.getListContact(idUser);
    try {
      if (res.error == null) {
        final model = await loginVerificationModelFromJson(res.data);
        // listAccount = model.data!.listAccount;
        emit(ListContactSuccessState(model: model.data!));
      } else {
        print('lỗi rồi nhé!');
      }
    } catch (e, s) {
      logger.logError(e, s);
    }
  }

  Future confirmLogin(
    String listContact,
    // UserType userType,
    // IUserInfo iUserInfo,
  ) async {
    var res = await _authRepo.confirmLogin(listContact);
    try {
      if (res.error == null) {
        AppDialogs.toast('Bạn đã xác nhận tài khoản thành công');
        emit(LoginSuccessfulTestState());
      } else {
        AppDialogs.toast((json.decode(res.data)['error']['message']));
        // emit(LoginWrongFriendsListState());
      }
    } catch (e, s) {
      s;
    }
  }

  @override
  void onChange(Change<LoginState> change) {
    // TODO: implement onChange
    if (change.nextState is LoginStateSuccess) {
      var state = (change.nextState as LoginStateSuccess);
      var userInfo = state.userInfo;
      var userType = state.userType;
      getIt.get<FirebaseService>().setUpFirebaseToken(userInfo.id, userType);
    }

    //
    super.onChange(change);
  }
}
