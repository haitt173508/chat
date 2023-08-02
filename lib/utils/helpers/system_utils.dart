import 'dart:async';
import 'dart:collection';
import 'dart:developer' show log;
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:android_path_provider/android_path_provider.dart';
import 'package:chat_365/common/blocs/downloader/cubit/downloader_cubit.dart';
import 'package:chat_365/common/blocs/downloader/model/downloader_model.dart';
import 'package:chat_365/core/constants/local_storage_key.dart';
import 'package:chat_365/core/interfaces/interface_user_info.dart';
import 'package:chat_365/data/services/device_info_service/device_info_services.dart';
import 'package:chat_365/data/services/generator_service.dart';
import 'package:chat_365/main.dart';
import 'package:chat_365/modules/auth/bloc/auth_bloc.dart';
import 'package:chat_365/modules/chat/blocs/chat_bloc/chat_bloc.dart';
import 'package:chat_365/modules/chat/model/api_message_model.dart';
import 'package:chat_365/modules/chat/model/result_socket_chat.dart';
import 'package:chat_365/modules/chat/repo/chat_repo.dart';
import 'package:chat_365/modules/chat_conversations/bloc/chat_conversation_bloc.dart';
import 'package:chat_365/utils/data/enums/download_status.dart';
import 'package:chat_365/utils/data/enums/message_type.dart';
import 'package:chat_365/utils/data/enums/user_type.dart';
import 'package:chat_365/utils/data/extensions/context_extension.dart';
import 'package:chat_365/utils/data/extensions/string_extension.dart';
import 'package:chat_365/utils/helpers/file_utils.dart';
import 'package:chat_365/utils/helpers/logger.dart';
import 'package:chat_365/utils/ui/app_dialogs.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sp_util/sp_util.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class SystemUtils {
  static Future<void> _launchUrl(String url) async {
    if (await canLaunch(url)) await launch(url);
  }

  static Future<void> openUrlInBrowser(String url) => _launchUrl(url);

  /*
  static Future<void> openUri({
    required AppStoreUri appStoreUri,
    String? url,
  }) async {
    if (Platform.isAndroid && appStoreUri.androidId != null) {
      if (await canLaunch(appStoreUri.nativeAndroid!))
        await launch(appStoreUri.nativeAndroid!);
      else
        openUrlInBrowser(appStoreUri.androidWeb!);
    } else if (Platform.isIOS && appStoreUri.iosId != null) {
      if (await canLaunch(appStoreUri.nativeIos!))
        await launch(appStoreUri.nativeIos!);
      else
        openUrlInBrowser(appStoreUri.iosWeb!);
    } else if (url != null) await SystemUtils.openUrlInBrowser(url);
  }

  static Future<void> openFile(FutureOr<String> filePath) async {
    final OpenResult result = await OpenFile.open(await filePath);

    switch (result.type) {
      case ResultType.noAppToOpen:
        // throw UnsupportedError('Không có ứng dụng khả dụng để mở file này!');
        throw 'Không có ứng dụng khả dụng để mở file này!';
      case ResultType.fileNotFound:
        // throw FileSystemException(
        //     'Đã có lỗi xảy ra, không tìm thấy file được yêu cầu!');
        // throw 'Đã có lỗi xảy ra, không tìm thấy file được yêu cầu!';
        // throw 'Không tìm thấy file!';
        throw FileNotFound();
      case ResultType.permissionDenied:
        throw PermissionDenied('Vui lòng cấp quyền truy cập!');
      default:
        break;
    }
  }

  static Future<void> launchPhoneUrlScheme(String url) => _launchUrl(url);
  */

  static Future<Uint8List?> getCachedImageAsByte(String url) async {
    var cached = await DefaultCacheManager().getFileFromCache(url);
    if (cached == null) return null;

    return await cached.file.readAsBytes();
  }

  static Future<String> getAppDirectory() async {
    if (Platform.isAndroid)
      return (await getExternalStorageDirectory() ??
              await getApplicationSupportDirectory())
          .path;
    else
      return (await getApplicationSupportDirectory()).path;
  }

  static Future<String> getDeviceTemporaryDirectory() async {
    return (await getTemporaryDirectory()).path;
  }

  static Future<String> getPathToDownloadFolder() async =>
      await getAppDirectory();

  static Future<String> getPathToDownloadedCvFolder(String folder) async =>
      await getPathToDownloadFolder() + "/downloaded_cv/$folder";

  static Future<String> getChatFilePath(String fileName) async =>
      await getPathToDownloadFolder() + "/chat/$fileName";

  static debugLog(String source, String message) {
    if (kDebugMode) log(message, name: source);
  }

  static copyToClipboard(String text) async {
    await Clipboard.setData(
      ClipboardData(
        text: text,
      ),
    );
    AppDialogs.toast(
      'Sao chép thành công',
      toast: Toast.LENGTH_SHORT,
    );
  }

  // requests storage permission
  // static Future<bool> _requestWritePermission() async {
  //   var isGranted = Permission.storage.request().isGranted;
  //   if (!(await isGranted)) {
  //     var res = await Permission.storage.request();
  //     return res.isGranted;
  //   } else
  //     return true;
  //   // return await Permission.manageExternalStorage.request().isGranted;
  // }

  // static Future<ExceptionError?> saveImage(
  //   ApiFileModel file, {
  //   VoidCallback? onDownloadingFile,
  //   VoidCallback? onDownloadFileError,
  //   VoidCallback? onDownloadFileSuccess,
  //   VoidCallback? onSavingFile,
  //   VoidCallback? onSaveFileError,
  //   ValueChanged<String>? onSaveFileSuccess,
  // }) async {
  //   // requests permission for downloading the file
  //   bool hasPermission = await _requestWritePermission();
  //   if (!hasPermission) return ExceptionError.notAllowWriteFile();

  //   var response = await ApiClient().downloadImage(
  //     file.fullFilePath,
  //   );

  //   if (response.isNotEmpty) {
  //     onDownloadFileSuccess?.call();
  //     final result = await ImageGallerySaver.saveImage(
  //       Uint8List.fromList(response),
  //       quality: 60,
  //       name: file.fileName,
  //     );

  //     logger.log(Map<String, dynamic>.from(result));

  //     if (result['errorMessage'] == null) {
  //       try {
  //         var filePath = (result['filePath'] as String)
  //             .replaceAll(RegExp(r'\w+\:\/\/'), '');
  //         onSaveFileSuccess?.call(filePath);
  //         return null;
  //       } catch (e, s) {
  //         logger.logError(e, s);
  //         ExceptionError.openFileError();
  //       }
  //     }
  //   }
  //   return ExceptionError.downloadFileError();
  // }

  static Iterable<T> searchFunction<T>(
    String text,
    Iterable<T> list, {
    bool toEng = true,
    String Function(T value)? delegate,
  }) {
    String Function(T value) _delegate = delegate ?? (T e) => e.toString();

    if (text.isNotEmpty) {
      Iterable<String> searchList;

      if (toEng) {
        text = text.toEngAlphabetString();
        searchList = list.map((e) => _delegate(e).toEngAlphabetString());
      } else
        searchList = list.map((e) => _delegate(e));

      List<String> spl = text.split(RegExp(r'[ _]'));
      // var reg = RegExp(
      //     '(?:^|(?<= ))(${spl.map((e) => '\\w*$e\\w*').join('|')})(?:(?= )|\$)');
      var reg = RegExp('(${spl.join('|')})');

      var map = Map.fromIterables(
          list,
          searchList.map(
            (e) => reg.allMatches(e).toList(),
          ));

      map.removeWhere((k, v) => v.isEmpty);

      var sortedKeys = map.keys.toList(growable: false)
        ..sort((k1, k2) => map[k1]!.length.compareTo(map[k2]!.length));

      LinkedHashMap sortedMap = LinkedHashMap.fromIterable(sortedKeys,
          key: (k) => k, value: (k) => map[k]);

      return sortedMap.keys.cast();
    }

    return list;
  }

  /// Truyền vào [text] và danh sách các [File], [Image], [Contact], [InfoLink] đính kèm nếu infoLinkMessageType == [MessageType.document] cần gửi,
  ///
  /// Trả về danh sách các [ApiMessageModel] gồm:
  /// - 1 model gửi [text] (+ [ApiRelyMessageModel] nếu có)
  /// - 1+ model gửi các [File]
  /// - 1 model gửi các [Image]
  /// - 1 model gửi [Contact]
  /// - 1 model gửi message kèm [InfoLink]
  ///
  /// Các type không phải text cần 1 đơn vị để không bị trùng messageId vs text khi truyền file cùng
  /// text
  /// - 1: ứng với Ảnh
  /// - 2: ứng với Link
  /// - 3: ứng với Contact
  /// - 4: ứng với File
  static List<ApiMessageModel> getListApiMessageModels({
    required IUserInfo senderInfo,
    required int conversationId,
    String? text,
    List<File> files = const [],
    InfoLink? infoLink,
    MessageType? infoLinkMessageType,

    /// Các file đã upload lên server
    List<ApiFileModel> uploadedFiles = const [],
    ApiRelyMessageModel? replyModel,
    IUserInfo? contact,
    String? messageId,

    /// [createdAt] Thời gian tạo tin nhắn
    /// - Ví dụ chỉnh sửa tin nhắn: createdAt là thời gian tạo của tin nhắn gốc
    DateTime? createdAt,
  }) {
    ApiMessageModel? textMsg;
    ApiMessageModel? imageMsg;
    List<ApiMessageModel>? fileMsg;
    ApiMessageModel? contactMsg;
    ApiMessageModel? linkMsg;
    ApiMessageModel? documentMsg;

    messageId ??= GeneratorService.generateMessageId(senderInfo.id);

    final senderId = senderInfo.id;

    /// Text
    if (infoLinkMessageType == null && !text.isBlank || replyModel != null) {
      textMsg = ApiMessageModel(
        createdAt: createdAt,
        messageId: messageId,
        conversationId: conversationId,
        senderId: senderId,
        type: MessageType.text,
        message: text,
        relyMessage: replyModel,
      );
    }

    /// File
    if (files.isNotEmpty || uploadedFiles.isNotEmpty) {
      final List<ApiFileModel> pickedFiles = [
        ...uploadedFiles,
        ...List<ApiFileModel>.from(
          files.map(
            (e) => ApiFileModel(
              fileName: e.name,
              fileType:
                  MessageTypeExt.fromFileExtension(e.path.split('.').last),
              fileSize: e.lengthSync(),
              filePath: e.path,
            ),
          ),
        )
      ];

      final List<ApiFileModel> apiImages =
          pickedFiles.where((e) => e.fileType == MessageType.image).toList();

      if (apiImages.isNotEmpty)
        imageMsg = ApiMessageModel(
          createdAt: createdAt,
          messageId: GeneratorService.addToMessageId(messageId, 1),
          conversationId: conversationId,
          senderId: senderId,
          files: apiImages,
          type: MessageType.image,
        );

      List<ApiFileModel> apiFiles =
          pickedFiles.where((e) => e.fileType == MessageType.file).toList();

      if (apiFiles.isNotEmpty) {
        var ticks = messageId.tickFromMessageId + 4;
        fileMsg = apiFiles
            .asMap()
            .keys
            .map((index) => ApiMessageModel(
                  createdAt: createdAt,
                  messageId: GeneratorService.generateMessageId(
                    senderId,
                    ticks + index,
                  ),
                  conversationId: conversationId,
                  senderId: senderId,
                  files: [apiFiles[index]],
                  type: MessageType.file,
                ))
            .toList();
      }
    }

    /// Tin nhắn có InfoLink đính kèm
    if (infoLink != null) {
      if (infoLinkMessageType == MessageType.document)
        documentMsg = ApiMessageModel(
          conversationId: conversationId,
          messageId: GeneratorService.addToMessageId(messageId, 2),
          senderId: senderId,
          type: infoLinkMessageType!,
          message: text,
          infoLink: infoLink,
        );

      /// Link
      else
        linkMsg = ApiMessageModel(
          createdAt: createdAt,
          messageId: GeneratorService.addToMessageId(messageId, 2),
          conversationId: conversationId,
          senderId: senderId,
          type: infoLinkMessageType ?? MessageType.link,
          message: infoLink.link ?? infoLink.linkHome,
          infoLink: infoLink,
        );
    }

    /// Contact
    if (contact != null)
      contactMsg = ApiMessageModel(
        createdAt: createdAt,
        messageId: GeneratorService.addToMessageId(messageId, 3),
        conversationId: conversationId,
        senderId: senderId,
        type: MessageType.contact,
        contact: contact,
      );

    List<ApiMessageModel> messages = ([
      textMsg,
      imageMsg,
      if (fileMsg != null) ...fileMsg,
      contactMsg,
      linkMsg,
      documentMsg,
    ]..removeWhere((e) => e == null))
        .cast();

    return messages;
  }

  static Future<String?> _findLocalPath() async {
    String? externalStorageDirPath;
    if (Platform.isAndroid) {
      try {
        externalStorageDirPath = await AndroidPathProvider.downloadsPath;
      } catch (e) {
        final directory = await getApplicationDocumentsDirectory();
        externalStorageDirPath = directory.path;
      }
    } else if (Platform.isIOS) {
      externalStorageDirPath =
          (await getApplicationDocumentsDirectory()).absolute.path;
    }
    return externalStorageDirPath;
  }

  static Future<String?> prepareSaveDir() async {
    try {
      var _localPath = (await _findLocalPath())!;
      final savedDir = Directory(_localPath);
      final hasExisted = savedDir.existsSync();
      if (!hasExisted) {
        await savedDir.create();
      }

      return _localPath;
    } catch (e, s) {
      logger.logError(e, s, 'PrepareSaveDirErro');
    }
    return null;
  }

  static Future<String?> _enqueueDownloader(
    String filePath,
    String savePath, {
    String? fileName,
  }) =>
      FlutterDownloader.enqueue(
        url: Uri.parse(filePath).toString(),
        savedDir: savePath,
        fileName: fileName,
        showNotification:
            true, // show download progress in status bar (for Android)
        openFileFromNotification:
            true, // click on notification to open downloaded file (for Android)
        saveInPublicStorage: true,
      );

  static Future<String?> downloadFile(
    String filePath,
    String savePath, {
    String? fileName,
    String? messageId,
  }) async {
    // if (Platform.isIOS) {
    //   AppDialogs.toast('Chức năng chưa được hỗ trợ !');
    //   return null;
    // }

    await prepareSaveDir();
    var taskId = await _enqueueDownloader(
      filePath,
      savePath,
      fileName: fileName,
    );

    if (messageId != null && fileName != null && taskId != null)
      try {
        var downloaderCubit =
            navigatorKey.currentContext!.read<DownloaderCubit>();
        downloaderCubit.updateTask(DownloaderModel(
          messageId,
          fileName: fileName,
          saveDir: savePath + '/' + fileName,
          status: DownloadStatus.progress,
          progress: 0,
          taskId: taskId,
        ));
        print('a');
      } catch (e) {
        print(e);
      }

    return taskId;
  }

  static Future<String?> launchUrlInAppWebView(String path) async {
    var uri = GeneratorService.generatePreviewLink(path);
    // : path;

    logger.log(uri, name: 'PreviewUri');

    bool openRes;

    try {
      openRes = await launchUrl(
        Uri.parse(uri),
        // mode: LaunchMode.platformDefault,
        webViewConfiguration: WebViewConfiguration(),
      );
    } catch (e) {
      openRes = false;
    }
    if (!openRes) return 'Xem trước file thất bại';

    logger.log(openRes, name: 'FilePreview');

    return null;
  }

  @pragma('vm:entry-point')
  static void downloadCallback(
    String id,
    DownloadTaskStatus status,
    int progress,
  ) =>
      IsolateNameServer.lookupPortByName('downloader_send_port')
          ?.send([id, status, progress]);

  /// [onRequest] cần bao gồm cả [callBack] trong đó vì trong này không gọi lại [callBack] khi
  /// chưa có [permission]
  ///
  /// [onPermissionDisabled]:
  /// - gọi khi không thể request permission:
  /// - mặc đinh gọi đến [openAppSettings()]
  static Future<void> permissionCallback(
    Permission permission,
    VoidCallback callback, {
    Future Function()? onRequest,
    Function()? onPermissionDisabled,
    ValueChanged<bool>? onPermissionStatusGrandted,
  }) async {
    final Function() onDisabled = onPermissionDisabled ?? openAppSettings;
    if (await permission.isPermanentlyDenied || await permission.isRestricted) {
      onPermissionDisabled?.call() ?? openAppSettings();
      onPermissionStatusGrandted?.call(false);
    } else if (await permission.isDenied) {
      if (onRequest != null) {
        await onRequest();
        onPermissionStatusGrandted?.call(false);
      } else {
        var status = await permission.request();
        if (status.isGranted) {
          callback();
          onPermissionStatusGrandted?.call(true);
        } else if (status == PermissionStatus.permanentlyDenied) {
          onDisabled();
          onPermissionStatusGrandted?.call(false);
        }
      }
    } else {
      callback();
      onPermissionStatusGrandted?.call(true);
    }
  }

  static sendSms(
    String phoneNumber, {
    required String message,
  }) async {
    var symbol = Platform.isAndroid ? '?' : '&';

    /// https://github.com/flutter/flutter/issues/51352
    var androidExternalSymbol =
        DeviceInfoService().isIosOrLowerAndroid11 ? '' : '//';

    // if (Platform.isIOS) {
    var res = await launchUrlString(
      'sms:$androidExternalSymbol$phoneNumber${symbol}body=${Uri.encodeFull(message)}',
    );
    if (!res) AppDialogs.toast('Không thể gửi tin nhắn !');
    // } else
    //   _sendSmsAndroid(phoneNumber, message);
  }

  // static String? encodeQueryParameters(Map<String, String> params) {
  //   return params.entries
  //       .map((e) =>
  //           '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
  //       .join('&');
  // }

  // static _sendSmsAndroid(String phoneNumber, String message) async {
  //   Uri smsUri = Uri(
  //     scheme: 'sms',
  //     path: '$phoneNumber',
  //     query: encodeQueryParameters(<String, String>{'body': message}),
  //   );

  //   try {
  //     if (await canLaunchUrlString(smsUri.toString())) {
  //       await launchUrlString(smsUri.toString());
  //     }
  //   } catch (e) {
  //     AppDialogs.toast('Không thể gửi tin nhắn !');
  //   }
  // }

  static logout(BuildContext context) async {
    var id = context.userInfo().id;
    context.read<ChatRepo>().logout(id);
    context.read<ChatConversationBloc>().clear();
    context.read<ChatBloc>().emit(ChatStateGettingConversationId());
    await Future.delayed(const Duration(milliseconds: 300));
    var authBloc = context.read<AuthBloc>();
    authBloc.add(AuthLogoutRequest());
  }

  // static void updateListMessageUnreadWithBadge(List<dynamic> data) {
  //   //update
  //   SpUtil.putString(
  //       AppConst.LIST_MESSAGE_UNREAD, data.map((e) => e.id).toList().join(','));
  //   FlutterAppBadger.updateBadgeCount(data.length);
  // }

  static bool checkRoomIsUnReadByUser(String roomID) {
    // LIST_MESSAGE_UNREAD chứa danh sách những message chưa đọc kèm room_id
    List listRoomIDUnRead =
        SpUtil.getString(LocalStorageKey.unreadConversations, defValue: "")!
            .split(',');
    return listRoomIDUnRead.contains(roomID);
  }

  static Future<void> increaseListMessageUnreadWithBadge() async {
    // tang so luong thong bao tren app icon
    List listRoomIDUnRead =
        SpUtil.getString(LocalStorageKey.unreadConversations, defValue: "")!
            .split(',');
    FlutterAppBadger.updateBadgeCount(listRoomIDUnRead.length + 1);
  }

  // static void decreaseListMessageUnreadWithBadge() {
  //   // giam so luong thong bao tren app icon
  //   List listRoomIDUnRead =
  //       SpUtil.getString(LocalStorageKey.unreadConversations, defValue: "")!
  //           .split(',');
  //   FlutterAppBadger.updateBadgeCount(
  //       listRoomIDUnRead.length > 0 ? listRoomIDUnRead.length - 1 : 0);
  // }

  //getInfo devices
  static Future<String?> getIDDevice() async {
    final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();

    if (Platform.isAndroid) {
      var build = await deviceInfoPlugin.androidInfo;
      // print(jsonEncode(build.toMap()));
      // deviceName = "${build.brand}: ${build.model}";
      // deviceVersion = build.version.toString();
      return build.androidId; //UUID for Android
    } else if (Platform.isIOS) {
      var data = await deviceInfoPlugin.iosInfo;
      // deviceName = "${data.model}: ${data.name}";
      // deviceVersion = data.systemVersion;
      return data.identifierForVendor; //UUID for iOS
    }
    return null;
  }

  static CurrentUserInfoModel getCurrrentUserInfoAndUserType() {
    IUserInfo? currentUserInfo;
    UserType? currentUserType;

    try {
      final BuildContext context = navigatorKey.currentContext!;
      currentUserInfo = context.userInfo();
      currentUserType = context.userType();
    } catch (e) {
      currentUserInfo = userInfo;
      currentUserType = userType;
    }

    return CurrentUserInfoModel(
      userInfo: currentUserInfo,
      userType: currentUserType,
    );
  }
}

class CurrentUserInfoModel {
  final IUserInfo? userInfo;
  final UserType? userType;

  CurrentUserInfoModel({
    this.userInfo,
    this.userType,
  });
}
