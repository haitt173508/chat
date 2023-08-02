import 'package:chat_365/core/constants/status_code.dart';
import 'package:chat_365/core/constants/string_constants.dart';
import 'package:equatable/equatable.dart';

/// 1: 'Công ty', 2: 'Nhân viên', 0: 'Khách hàng cá nhân', -1: 'Không xác định'
class UserType extends Equatable {
  final int id;
  final String type;

  const UserType(this.id, this.type);

  /// Người dùng chưa đăng nhập
  static const unAuth = UserType(-1, 'Không xác định');

  static const customer = UserType(0, 'Khách hàng cá nhân');

  static const company = UserType(1, 'Công ty');

  static const staff = UserType(2, 'Nhân viên');

  static const authTypes = [customer, company, staff];

  @override
  String toString() => type;

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type,
      };

  factory UserType.fromJson(Map<String, dynamic> json) => UserType(
        json['id'],
        json['type'],
      );

  static UserType fromId(int id) =>
      authTypes.singleWhere((element) => element.id == id);

  @override
  List<Object?> get props => [id];

  static Map<int, UserType> authUserTypeFromStatusCode = {
    StatusCode.wrongCustomerAuthStatusCode: UserType.customer,
    StatusCode.wrongStaffAuthStatusCode: UserType.staff,
    StatusCode.wrongCompanyAuthStatusCode: UserType.company,
  };

  String get authName {
    if (this == UserType.company) return StringConst.company;
    if (this == UserType.staff) return StringConst.employee;
    if (this == UserType.customer) return StringConst.personal;
    return '';
  }
}
