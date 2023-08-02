import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';

import 'package:chat_365/core/interfaces/interface_user_info.dart';
import 'package:chat_365/main.dart';
import 'package:chat_365/utils/data/enums/user_type.dart';
import 'package:chat_365/utils/data/extensions/context_extension.dart';
import 'package:chat_365/utils/data/extensions/date_time_extension.dart';
import 'package:chat_365/utils/data/extensions/string_extension.dart';
import 'package:chat_365/utils/helpers/logger.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GeneratorService {
  static String generateMessageId(int userId, [int? tick]) =>
      (tick ?? DateTimeExt.currentServerTicks).toString() + '_$userId';

  static String generateFileName(String fileName) =>
      DateTimeExt.currentServerTicks.toString() + '-$fileName';

  /// Thay đổi tick trong messageId [number] đơn vị, giữ nguyên [senderId]
  static String addToMessageId(String genereatedId, int number) {
    var splitted = genereatedId.split('_');
    var ticks = int.parse(splitted[0]);
    var newTicks = ticks + number;
    var userId = splitted[1];
    return newTicks.toString() + '_$userId';
  }

  static String generateDialogRouteName() =>
      'DIALOG_${DateTime.now().microsecondsSinceEpoch}';

  static String generatePreviewLink(String path) {
    var genLink =
        'https://timviec365.vn/api_app/preview_file.php?url_file=${path}';

    logger.log(genLink, name: 'Generated_Preview_Link', color: StrColor.green);

    return genLink;
  }

  static Future<Uint8List> getBytesFromAsset(String path, int? width) async {
    ByteData data = await rootBundle.load(path);
    Codec codec = await instantiateImageCodec(
      data.buffer.asUint8List(),
      targetWidth: width,
    );
    FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  static Marker createMarker(
    LatLng position,
    String markerId, {
    Uint8List? icon,
    InfoWindow infoWindow = InfoWindow.noText,
  }) =>
      Marker(
        markerId: MarkerId(markerId),
        icon: icon != null
            ? BitmapDescriptor.fromBytes(icon)
            : BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        position: position,
        infoWindow: infoWindow,
      );

  static generate365Link(
    String link, {
    IUserInfo? currentUserInfo,
    UserType? currentUserType,
  }) {
    UserType? _currentUserType;
    IUserInfo? _currentUserInfo;
    try {
      if (currentUserInfo != null && currentUserType != null) {
        _currentUserInfo = currentUserInfo;
        _currentUserType = currentUserType;
      } else {
        // _currentUserInfo = userInfo;
        // _currentUserType = userType;
        // if (_currentUserInfo == null) {
        var context = navigatorKey.currentContext!;
        _currentUserType = context.userType();
        _currentUserInfo = context.userInfo();
        // }
      }
      if (_currentUserType.id == 2) {
        return "https://chamcong.timviec365.vn/thong-bao.html?s=81b016d57ec189daa8e04dd2d59a22c3." +
            _currentUserInfo.id365!.toString() +
            "." +
            _currentUserInfo.password! +
            "&link=" +
            link;
      } else if (_currentUserType.id == 1) {
        return "https://chamcong.timviec365.vn/thong-bao.html?s=f30f0b61e761b8926941f232ea7cccb9." +
            _currentUserInfo.id365!.toString() +
            "." +
            _currentUserInfo.password! +
            "&link=" +
            link;
      }
    } catch (e, s) {
      logger.logError(e, s);
    }
    return link;
  }
}
