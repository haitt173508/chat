import 'constants/api_path.dart';

class ImageUrlResolver {
  /// return empty string if [remoteFileName] is a empty string
  static String avatar(int conversationId, String remoteFileName) =>
      remoteFileName.isEmpty
          ? ''
          : "${ApiPath.avatarUserDomain}$conversationId/$remoteFileName";

  static String chatUploadedFile(String fileName) =>
      "${ApiPath.imageDomain}$fileName";

  static String chatDownloadFile(String fileName) =>
      "${ApiPath.downloadFile}$fileName";

  static String chatUploadedImage(String fileName) =>
      chatUploadedFile(fileName);
}
