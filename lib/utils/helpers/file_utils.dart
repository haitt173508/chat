import 'dart:io';

import 'package:chat_365/core/constants/app_constants.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class FileUtils {
  static Future<File> compressFile(
    File file, [
    String? newName,
    double? compressImgWhenBiggerThanMb = AppConst.maxImageSizeInMb,
  ]) async {
    if (compressImgWhenBiggerThanMb == null) return file;

    if (isImageFileSizeSmallerOrEqualThanMb(file, compressImgWhenBiggerThanMb))
      return file;

    // we do not need package `path_provider` 'cause `image_picker` read file to cache
    final String tempDir = file.pathOnly;
    final String filename = newName ?? file.name;
    final String fileExt = getFileExtensionFromFileName(filename);
    final String targetPath = tempDir +
        filename.substring(0, filename.lastIndexOf('.')) +
        '_compressed' +
        fileExt;
    File? result;

    result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 88,
      format: CompressFormat.values.firstWhere(
        (e) => e.toString().contains(fileExt),
        orElse: () => CompressFormat.jpeg,
      ),
    );

    return result!;
  }

  static bool _isFileSizeGreaterThanMb(File file, double megabyte) =>
      file.sizeInMb > megabyte;

  static bool isImageFileSizeGreaterThanMb(
    File file, [
    double megabyte = AppConst.maxImageSizeInMb,
  ]) =>
      _isFileSizeGreaterThanMb(file, megabyte);

  static bool isImageFileSizeSmallerOrEqualThanMb(
    File file, [
    double megabyte = AppConst.maxImageSizeInMb,
  ]) =>
      _isFileSizeGreaterThanMb(file, megabyte) == false;

  static bool isFileSizeGreaterThanMb(
    File file, [
    double megabyte = AppConst.maxFileSizeInMb,
  ]) =>
      _isFileSizeGreaterThanMb(file, megabyte);

  static String getFileExtensionFromFileName(String filename) =>
      filename.substring(filename.lastIndexOf('.'));

  static String getFileExtensionFromFile(File file) => file.ext;

  /*
  static File renameFileFollowApiFormat(File file, [String? fileName]) {
    return file.renameSync(
        "${file.pathOnly}${TimeUtils.currentTicks}-${fileName ?? file.name}");
  }
  */
}

extension FileExt on File {
  String get name => absolute.path.split(Platform.pathSeparator).last;

  String get nameOnly {
    final nameWithExt = name;

    return nameWithExt.substring(0, nameWithExt.lastIndexOf('.'));
  }

  /// file extension
  String get ext => FileUtils.getFileExtensionFromFileName(name);

  String get pathOnly =>
      absolute.path.substring(0, absolute.path.lastIndexOf('/') + 1);

  int get lengthInBytes => readAsBytesSync().lengthInBytes;

  /// size in megabyte
  double get sizeInMb => lengthInBytes / 1024 / 1024;

  // File addCurrentTicksToFileName(String suffixNameWithoutExt) {
  //   // we do not need package `path_provider` 'cause `image_picker` read file to cache
  //   final String filename =
  //       TimeUtils.currentTicks.toString() + suffixNameWithoutExt + ext;

  //   return copySync("$pathOnly$filename");
  // }
}
