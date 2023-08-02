import 'dart:convert';
import 'dart:developer';
import 'package:chat_365/common/images.dart';
import 'package:chat_365/core/constants/chat_socket_event.dart';
import 'package:chat_365/core/theme/app_colors.dart';
import 'package:chat_365/core/theme/app_text_style.dart';
import 'package:chat_365/main.dart';
import 'package:chat_365/modules/chat/blocs/chat_bloc/chat_bloc.dart';
import 'package:chat_365/modules/home_qr_code/bloc/home_qr_bloc.dart';
import 'package:chat_365/router/app_pages.dart';
import 'package:chat_365/router/app_router.dart';
import 'package:chat_365/utils/data/clients/chat_client.dart';
import 'package:chat_365/utils/data/extensions/context_extension.dart';
import 'package:chat_365/utils/ui/app_dialogs.dart';
import 'package:chat_365/utils/ui/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class HomeQRCodeScreens extends StatefulWidget {
  const HomeQRCodeScreens({Key? key}) : super(key: key);

  @override
  State<HomeQRCodeScreens> createState() => _HomeQRCodeScreensState();
}

class _HomeQRCodeScreensState extends State<HomeQRCodeScreens> {
  Barcode? result;
  QRViewController? _controllerCameraQR;
  late final HomeQRCodeBloc _homeQRCodeBloc = HomeQRCodeBloc();
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  void dispose() {
    _controllerCameraQR!.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    try {} catch (e) {
      print('Error: ${e.toString()}');
    }
    super.didChangeDependencies();
  }

  /// Dung cho chuc nang delay thoi gian scan qr code
  DateTime? lastScan;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _homeQRCodeBloc,
      child: Scaffold(
        body: Stack(
          alignment: Alignment.topCenter,
          children: <Widget>[
            _buildQRView(context),
            Positioned(
                top: MediaQuery.of(context).size.height * 0.06,
                left: 0,
                child: IconButton(
                  onPressed: () => AppRouter.backToPage(context, AppPages.Navigation),
                  icon: SvgPicture.asset(
                    Images.ic_x,
                    color: AppColors.white,
                    height: 20,
                    width: 20,
                  ),
                )),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.15,
              child: Text(
                'Di chuyển camera đến mã QR để quét',
                style: AppTextStyles.regularW400(
                  context,
                  size: 16,
                  color: AppColors.white,
                ),
              ),
            ),
            // Positioned(
            //   bottom: MediaQuery.of(context).size.height * 0.1,
            //   child: _updateImage(),
            // ),
          ],
        ),
      ),
    );
  }

  Widget _updateImage() {
    return InkWell(
      onTap: () {
        AppRouter.toPage(context, AppPages.Add_Group_Screen);
      },
      child: SizedBox(
        width: 79,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(Images.ic_image),
            SizedBoxExt.h10,
            Text('Chọn QR từ thư viện',
                style: AppTextStyles.regularW400(
                  context,
                  size: 16,
                  color: AppColors.white,
                ),
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  Widget _buildQRView(BuildContext context) {
    var scanArea = MediaQuery.of(context).size.width - 20 * 2;
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
        borderColor: AppColors.white,
        borderRadius: 0,
        borderLength: 60,
        borderWidth: 10,
        cutOutSize: scanArea,
      ),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  /// Ham xu ly khi quet duoc qr
  void _onQRViewCreated(QRViewController controller) {
    log("khoi tao cam ");

    // setState(() {
    _controllerCameraQR = controller..resumeCamera();
    // });
    _controllerCameraQR!.scannedDataStream.listen((scanData) async {
      try {
        result = scanData;
        print(scanData);

        var encodedData = json.decode(result!.code!);
        var checkQR = encodedData["QRType"];
        if (result != null) {
          if (checkQR == 'QRJoinGroup') {
            String nameGroup = encodedData['conversationName'];
            String avatarGroup = encodedData['conversationAvatar'];
            String admin = encodedData['admin'];
            String data = encodedData['data'];
            _controllerCameraQR?.pauseCamera();
            AppRouter.toPage(context, AppPages.Add_Group_Screen, arguments: {
              'nameGroup': nameGroup,
              'avatarGroup': avatarGroup,
              'admin': admin,
              'data': data,
            });
          } else if (checkQR == 'QRAddFriend') {
            String data = encodedData['data'];
            _homeQRCodeBloc.addFriendQR(context.userInfo().id, data);
            // chatClient.emit(ChatSocketEvent.newMemberAddedToGroup, [
            // model.conversationId,
            // [currentUserId],
            // model.memberList.value.map((e) => e.id).toList(),
            // ]);

            _controllerCameraQR?.pauseCamera();
          }
          //Mã QR
          else if (checkQR == 'QRLoginPc') {
            var base64ID = '${encodedData['idQR'].replaceAll("+", "")}';
            var nameComputer = encodedData['NameComputer'];
            var longitude = encodedData['longitude'];
            var latitude = encodedData['latitude'];
            var timeComputer = encodedData['Time'];
            String idUser = utf8.decode(base64.decode(base64ID));
            _controllerCameraQR?.pauseCamera();
            AppRouter.toPage(context, AppPages.Accept_Login_QR, arguments: {
              'qrCodeID': idUser,
              'nameComputer': nameComputer,
              'timeComputer': timeComputer,
              'latitude': latitude,
              'longitude': longitude,
            });
          } else if (checkQR == 'QRChat11') {
            int userId = int.parse(encodedData['user_id']);
            _controllerCameraQR?.pauseCamera();
            navigatorKey.currentContext!.read<ChatBloc>().tryToChatScreen(
                  userId: userId,
                );
          }
        } else {
          AppDialogs.toast('Mã QR không hợp lệ');
        }
      } catch (e) {
        AppDialogs.toast('Mã QR không hợp lệ');
        print('Error: ${e.toString()}');
      }
    });
  }
}

///Nhan quyen truy cap camera
void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) async {
  if (!p) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Không có quyền truy cập')),
    );
  }
}
