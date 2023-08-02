import 'package:chat_365/core/theme/app_colors.dart';
import 'package:chat_365/data/services/hive_service/hive_type_id.dart';
import 'package:chat_365/utils/helpers/logger.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
part 'user_status.g.dart';

/// Tình trạng online hiện tại
///
/// 1: Đang hoạt động, 2: Vắng mặt, 3: Đừng làm phiền, 4: Ẩn
@HiveType(typeId: HiveTypeId.userStatusHiveTypeId)
class UserStatus extends Equatable {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String status;

  const UserStatus(this.id, this.status);

  static const kMinId = 1;

  /// Nhóm không cần hiển thị trạng thái online hiện tại
  static const none = UserStatus(kMinId - 1, 'Không xác định');

  static const online = UserStatus(kMinId, 'Đang hoạt động');
  static const offline = UserStatus(kMinId + 1, 'Vắng mặt');
  static const notDisturb = UserStatus(kMinId + 2, 'Đừng làm phiền');
  static const hide = UserStatus(kMinId + 3, 'Ẩn');

  static const values = [
    online,
    offline,
    notDisturb,
    hide,
  ];

  static fromId(int id) => values.singleWhere((e) => e.id == id, orElse: () {
        logger.logError('Không tìm thấy UserStatus.id == $id');
        return offline;
      });

  @override
  String toString() => status;

  @override
  List<Object?> get props => [id];

  toJson() => {
        'id': id,
        'status': status,
      };
}

extension UserStatusExt on UserStatus {
  Widget getStatusBadge(
    BuildContext context, {
    double badgeSize = 12,
  }) {
    var color;
    if (this == UserStatus.online)
      color = AppColors.online;
    else if (this == UserStatus.offline)
      color = AppColors.offline;
    else if (this == UserStatus.notDisturb)
      color = AppColors.red;
    else
      color = AppColors.white;
    return Container(
      height: badgeSize + 2,
      width: badgeSize + 2,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(
          color:
              this == UserStatus.hide ? AppColors.mineShaft : AppColors.white,
          width: this == UserStatus.hide ? 3 : 1.2,
        ),
      ),
      alignment: Alignment.center,
      child: this == UserStatus.notDisturb
          ? Card(
              color: AppColors.white,
              margin: EdgeInsets.symmetric(horizontal: 2.5, vertical: 5),
              child: SizedBox.expand(),
            )
          : null,
    );
  }
}
