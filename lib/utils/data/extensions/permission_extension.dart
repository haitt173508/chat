import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:chat_365/data/services/device_info_service/device_info_services.dart';
import 'package:chat_365/router/app_pages.dart';
import 'package:chat_365/utils/helpers/logger.dart';
import 'package:permission_handler/permission_handler.dart';

extension PermissionExt on Permission {
  String get name {
    var str = this.toString();
    if (this == Permission.camera)
      str = 'Máy ảnh';
    else if (this == Permission.mediaLibrary ||
        this == Permission.accessMediaLocation)
      str = 'Thư viện';
    else if (this == Permission.manageExternalStorage)
      str = 'Bộ nhớ ngoài';
    else if (this == Permission.contacts) str = 'Danh bạ';
    return str;
  }

  AppPages get page {
    if (this == Permission.contacts) return AppPages.Contact_Permission;

    throw Exception('Không tìm thấy PermissionPage ứng với $this permission');
  }

  static Permission get libraryPermission =>
      Platform.isIOS ? Permission.mediaLibrary : Permission.accessMediaLocation;

  static openLibraryPermissionSetting() => AppSettings.openAppSettings();

  static Permission get downloadPermission {
    var version = DeviceInfoService().androidSdkInt!;
    var permission =
        Platform.isIOS ? Permission.mediaLibrary : Permission.storage;
    // : version >= 29
    //     ? Permission.storage
    //     : Permission.storage;
    logger.log(
      'androidSdkInt: $version: $permission',
      name: 'DownloadPermission',
    );
    return permission;
  }

  static Permission get openFilePermission => Permission.storage;

  /// isPermanentlyDenied,
  ///
  /// isRestricted,
  ///
  /// isDenied,
  ///
  /// isGranted,
  ///
  /// isLimited,
  ///
  Future<List<bool>> get statuses => Future.wait([
        isPermanentlyDenied,
        isRestricted,
        isDenied,
        isGranted,
        isLimited,
      ]);

  Future<bool> get isAccepted async => await isGranted || await isLimited;

  Future<bool> get isDisabled async =>
      await isPermanentlyDenied || await isRestricted;
}

extension PermissionStatusExt on PermissionStatus {
  bool get isAccepted => isGranted || isLimited;

  bool get isDisabled => isPermanentlyDenied || isRestricted;
}
