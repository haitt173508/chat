import 'dart:io';
import 'dart:math';

import 'package:chat_365/core/constants/local_storage_key.dart';
import 'package:equatable/equatable.dart';
import 'package:sp_util/sp_util.dart';

class LoginModel extends Equatable {
  final String email;
  final String password;

  LoginModel(
    this.email,
    this.password,
  );

  factory LoginModel.empty() => LoginModel(
        '',
        '',
      );

  @override
  List<Object?> get props => [email, password];

  Map<String, dynamic> toMap(
    String type, {
    bool isMD5Pass = false,
  }) {
    return {
      'Email': this.email,
      'Password': this.password,
      'Type365': type,
      'Type_Pass': isMD5Pass ? 1 : 0,
      'IdDevice': SpUtil.getString(LocalStorageKey.idDevice),
      // 'NameDevice':
      // '${SpUtil.getString(LocalStorageKey.nameDevice)} - ${Platform.isAndroid ? 'Android' : 'Ios'}'
      'NameDevice':
          'Phone_${Random().nextInt(1000)} - ${Platform.isAndroid ? 'Android' : 'Ios'}'
    };
  }

  Map<String, dynamic> toMapAccountCompnay() {
    return {
      'email': this.email,
      'pass': this.password,
    };
  }
}
