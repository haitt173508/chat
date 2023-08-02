import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';

class DeviceInfoService {
  static DeviceInfoService? _instance;

  factory DeviceInfoService() => _instance ??= DeviceInfoService._();

  DeviceInfoService._() {}

  late final BaseDeviceInfo baseDeviceInfo;

  bool isIosOrLowerAndroid11 = true;

  int? androidSdkInt;

  init() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      baseDeviceInfo = await deviceInfo.androidInfo;
      androidSdkInt = (baseDeviceInfo as AndroidDeviceInfo).version.sdkInt;
      if (androidSdkInt != null) isIosOrLowerAndroid11 = androidSdkInt! <= 29;

      // logger.log(baseDeviceInfo.toMap(), name: 'baseDeviceInfo');
    } else if (Platform.isIOS) {
      isIosOrLowerAndroid11 = true;
      baseDeviceInfo = await deviceInfo.iosInfo;
      // logger.log(baseDeviceInfo.toMap(), name: 'baseDeviceInfo');
    } else
      baseDeviceInfo = await deviceInfo.deviceInfo;
  }
}
