

import 'package:chat_365/core/constants/api_path.dart';
import 'package:chat_365/core/constants/app_constants.dart';
import 'package:chat_365/core/constants/local_storage_key.dart';
import 'package:chat_365/core/error_handling/exceptions.dart';
import 'package:chat_365/core/interfaces/interface_user_info.dart';
import 'package:chat_365/data/services/sp_utils_service/sp_utils_services.dart';
import 'package:chat_365/modules/auth/repo/auth_repo.dart';
import 'package:chat_365/modules/get_token/model/result_login_get_token_model.dart';
import 'package:chat_365/utils/data/clients/api_client.dart';
import 'package:chat_365/utils/data/extensions/string_extension.dart';
import 'package:chat_365/utils/data/models/request_method.dart';
import 'package:chat_365/utils/data/models/request_response.dart';
import 'package:chat_365/utils/helpers/system_utils.dart';
import 'package:sp_util/sp_util.dart';

class GetTokenRepo {
   final ApiClient _apiClient;
   final AuthRepo authRepo;
   GetTokenRepo(this.authRepo) : _apiClient = ApiClient();

   // IUserInfo get userInfo => authRepo.userInfo!;

   Future<RequestResponse> _getToken(String? pass, int? idUser, int? idCom) async {
     var res = await  _apiClient.fetch(
     ApiPath.get_token,
     data: {
       'pass': pass,
       'ep_id': idUser,
       'com_id': idCom,
     },
     method: RequestMethod.post,
   );
     // var  model = resultGetTokensModelFromJson(res.data);
     //   if (res.error == null) {
     //     SpUtil.putString(LocalStorageKey.token, model.data?.accessToken ?? '');
     //     print('token: ${model.data?.accessToken}');
     //   }
       return res;
   }

   IUserInfo get userInfo => authRepo.userInfo!;

   String? get _token => spService.token;

   // getConfig() async {
   //   if (token == null) {
   //     var error = await getToken();
   //     if (error != null)
   //     return emit(GetTokenStateLoadError(error));
   //   }
   //   _getConfig();
   // }



   Future<String> getToken() async {
     ///Check token null || ""
     // if (!token.isBlank) return token!;
     final RequestResponse res = await _getToken(
       userInfo.password,
       userInfo.id365,
       userInfo.companyId,
     );
     var model = resultGetTokensModelFromJson(res.data);
     if (res.error == null) {
       await SpUtil.putString(LocalStorageKey.token, model.data?.accessToken ?? '');
       await SpUtil.putString(LocalStorageKey.refresh_token, model.data?.refreshToken ?? '');
       print('token: ${model.data?.accessToken}');
       print('token: ${model.data?.refreshToken}');
       return _token!;
     } else {
       throw CustomException(res.error!);
     }
   }

}

