import 'package:camera/camera.dart';
import 'package:chat_365/utils/data/enums/day_of_week.dart';
import 'package:intl/intl.dart';
import 'package:image/image.dart' as imglib;

const _epochTicks = 621355968000000000;

int serverTicks = 0;

int serverDifferenceTickWithClient = 0;

extension DateTimeExt on DateTime {
  /// - [showTimeStamp]: Hiển thị HH:MM nếu difference.inHours < 24h
  /// - [showSpecialTime]: Hiển thị "Hôm qua" và "Hôm nay" thay vì thời gian
  /// - [showYesterdayImediately]: Hiển thị "Hôm qua" luôn, bỏ qua [showTimeStamp]
  String diffWith({
    DateTime? dateTime,
    bool showTimeStamp = true,
    bool showSpecialTime = false,
    bool showYesterdayImediately = false,
  }) {
    var diffDateTime = dateTime ?? DateTime.now();

    // if (diff.inSeconds < 60) {
    //   return 'Vừa xong';
    // }
    // if (diff.inMinutes < 60) {
    //   return '${diff.inMinutes} phút trước';
    // }

    var diffWithHM = diffDateTime.difference(this);

    var diffWithDM = diffDateTime.difference(toDmY());

    if (showYesterdayImediately && diffWithDM.inDays == 1) return 'Hôm qua';

    if (showTimeStamp && diffWithHM.inHours < 24) {
      return toHmString();
    }

    if (showSpecialTime) {
      if (diffWithDM.inDays == 1) return 'Hôm qua';
      if (diffWithHM.inHours < 24) return 'Hôm nay';
    }

    if (diffWithDM.inDays <= 7) {
      var dayOfWeek = DayOfWeek.fromFlutterWeekdayIndex(this.weekday);
      var todayDayOfWeek =
          DayOfWeek.fromFlutterWeekdayIndex(DateTime.now().toDmY().weekday);

      /// Chỉ hiện thị [dayOfWeek.toString()] với ngày trong tuần của tuần hiện tại
      if (dayOfWeek.id >= todayDayOfWeek.id) return toDmYString();
      return dayOfWeek.toString();
    }
    return toDmYString();
  }

  String diffOnlineTime() {
    var diff = DateTime.now().difference(this);
    if (diff.inSeconds < 60) return 'Vừa xong';
    if (diff.inMinutes < 60) return '${diff.inMinutes} phút trước';
    if (diff.inHours < 24) return '${diff.inHours} giờ trước';
    if (diff.inDays < 30) return '${diff.inDays} ngày trước';
    return '${diff.inDays ~/ 30} tháng trước';
  }

  DateTime toDmY() => DateTime(year, month, day);

  String toDmYString({String sep = '/'}) =>
      [day, month, year].map((e) => e.toString().padLeft(2, '0')).join(sep);

  String toHmString() =>
      [hour, minute].map((e) => e.toString().padLeft(2, '0')).join(':');

  static DateFormat serverDateFormat = DateFormat('MM/dd/yyyy HH:mm:ss.fff');

  static DateFormat lastActiveServerDateFormat =
      DateFormat('MM/dd/yyyy HH:mm:ss a');

  static int get currentTicks =>
      DateTime.now().microsecondsSinceEpoch * 10 + _epochTicks + 251982339964;

  static int computeTick(DateTime dateTime) =>
      dateTime.microsecondsSinceEpoch * 10 + _epochTicks + 251982339964;

  int get ticks => microsecondsSinceEpoch * 10 + _epochTicks + 251982339964;

  DateTime get parseFromSocketServerTime {
    var clientTicks = ticks + serverDifferenceTickWithClient;
    return DateTime.fromMicrosecondsSinceEpoch(
      (clientTicks - (_epochTicks + 251982339964)) ~/ 10,
    );
  }

  static int get currentServerTicks =>
      currentTicks - serverDifferenceTickWithClient;

  static DateTime timzoneParse(String dateTime) =>
      timezoneDateFormat.parseUTC(dateTime);

  static DateFormat get timezoneDateFormat =>
      DateFormat('yyyy-MM-ddTHH:mm:ssZ');

  String toTimezoneFormatString() =>
      DateFormat("yyyy-MM-dd'T'HH:mm:ss'+07:00'").format(this);

  static DateTime timeZoneParse(String dateTime) => timzoneParse(dateTime);

  static DateTime? tryTimeZoneParse(String? dateTime) {
    if (dateTime == null) return null;
    try {
      return timeZoneParse(dateTime);
    } catch (e) {
      return null;
    }
  }

  static List<int> convertImagetoPng(CameraImage image) {
    print('th1 ${DateTime?.now()}');
    try {
      imglib.Image? img;
      print('image.type: ${image.format.group}');
      if (image.format.group == ImageFormatGroup.yuv420) {
        print('th2 ${DateTime?.now()}');

        print('convertYUV420toImageColor');
        img = convertYUV420toImageColor(image);
      } else if (image.format.group == ImageFormatGroup.bgra8888) {
        print('_convertBGRA8888');
        img = convertBGRA8888(image);
      }
      print('th3 ${DateTime?.now()}');

      imglib.JpegEncoder jpegEncoder = new imglib.JpegEncoder();
      print('th4 ${DateTime?.now()}');

      // Convert to png
      var jpeg = jpegEncoder.encodeImage(img!);
      print('th5 ${DateTime?.now()}');

      return jpeg;
    } catch (e) {
      print(">>>>>>>>>>>> ERROR:" + e.toString());
    }
    return [];
  }

  /// CameraImage BGRA8888 -> PNG
// Color
  static imglib.Image convertBGRA8888(CameraImage image) {
    // print('imageplanes: ${image.planes[0].bytes.length.toString()}');
    return imglib.Image.fromBytes(
      image.width,
      image.height,
      image.planes[0].bytes,
      format: imglib.Format.bgra,
    );
  }

  /// CameraImage YUV420_888 -> PNG -> Image (compresion:0, filter: none)
// Black
//   imglib.Image _convertYUV420(CameraImage image) {
  static imglib.Image convertYUV420toImageColor(CameraImage image) {
    final int width = image.width;
    final int height = image.height;
    final int uvRowStride = image.planes[1].bytesPerRow;
    final int? uvPixelStride = image.planes[1].bytesPerPixel;

    print('image.width:${image.width}');
    print('image.height:${image.height}');
    const alpha255 = (0xFF << 24);

    // imgLib -> Image package from https://pub.dartlang.org/packages/image
    final img = imglib.Image(width, height); // Create Image buffer

    // Fill image buffer with plane[0] from YUV420_888
    for (int x = 0; x < width; x++) {
      for (int y = 0; y < height; y++) {
        final int uvIndex =
            uvPixelStride! * (x / 2).floor() + uvRowStride * (y / 2).floor();
        final int index = y * width + x;

        final yp = image.planes[0].bytes[index];
        final up = image.planes[1].bytes[uvIndex];
        final vp = image.planes[2].bytes[uvIndex];
        // Calculate pixel color
        int r = (yp + vp * 1436 / 1024 - 179).round().clamp(0, 255);
        int g = (yp - up * 46549 / 131072 + 44 - vp * 93604 / 131072 + 91)
            .round()
            .clamp(0, 255);
        int b = (yp + up * 1814 / 1024 - 227).round().clamp(0, 255);
        // color: 0x FF  FF  FF  FF
        //           A   B   G   R
        img.data[index] = alpha255 | (b << 16) | (g << 8) | r;
      }
    }
    return img;
  }

  //black
  static imglib.Image convertYUV420(CameraImage image) {
    var img = imglib.Image(image.width, image.height); // Create Image buffer

    Plane plane = image.planes[0];
    const int shift = (0xFF << 24);

    // Fill image buffer with plane[0] from YUV420_888
    for (int x = 0; x < image.width; x++) {
      for (int planeOffset = 0;
          planeOffset < image.height * image.width;
          planeOffset += image.width) {
        final pixelColor = plane.bytes[planeOffset + x];
        // color: 0x FF  FF  FF  FF
        //           A   B   G   R
        // Calculate pixel color
        var newVal =
            shift | (pixelColor << 16) | (pixelColor << 8) | pixelColor;

        img.data[planeOffset + x] = newVal;
      }
    }

    return img;
  }
}

extension NullableDateTimeExt on DateTime? {
  static DateTime? fromLastActive(String? str) {
    if (str != null)
      try {
        if (RegExp(r' 12\:\d\d\:\d\d PM').hasMatch(str))
          str = str.replaceFirst('PM', 'AM');
        return DateTimeExt.lastActiveServerDateFormat.parse(str);
      } catch (e) {
        return DateTime.tryParse(str!);
      }
    return null;
  }

  static DateTime? fromIsOnlineAndLastActive(
    bool isOnline,
    String? lastActiveTime,
  ) =>
      isOnline ? null : fromLastActive(lastActiveTime);

  static DateTime? lastActiveFromJson(Map<String, dynamic> json) =>
      json["isOnline"] == 1 ? null : fromLastActive(json["lastActive"]);
}
