import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_365/common/components/display/display_avatar.dart';
import 'package:chat_365/common/images.dart';
import 'package:chat_365/core/constants/string_constants.dart';
import 'package:chat_365/core/theme/app_colors.dart';
import 'package:chat_365/core/theme/app_text_style.dart';
import 'package:chat_365/router/app_pages.dart';
import 'package:chat_365/router/app_router.dart';
import 'package:chat_365/utils/data/enums/themes.dart';
import 'package:chat_365/utils/data/extensions/context_extension.dart';
import 'package:chat_365/utils/ui/app_dialogs.dart';
import 'package:chat_365/utils/ui/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class MyQRCodeScreen extends StatefulWidget {
  const MyQRCodeScreen({Key? key}) : super(key: key);

  @override
  State<MyQRCodeScreen> createState() => _MyQRCodeScreenState();
}

class _MyQRCodeScreenState extends State<MyQRCodeScreen> {
  Barcode? result;
  late final MyTheme _myTheme;
  QRViewController? _controllerCameraQR;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  void initState() {
    _myTheme = context.theme;
    // TODO: implement initState

    super.initState();
  }

  @override
  void dispose() {
    _controllerCameraQR?.dispose();
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
    Widget _CustomColumn({
      required VoidCallback onTap,
      required String title,
      required String icon,
    }) {
      return InkWell(
        onTap: onTap,
        child: Column(
          children: [
            SvgPicture.asset(icon),
            SizedBoxExt.h10,
            Text(title,
                style: AppTextStyles.regularW400(
                  context,
                  size: 14,
                ),
                textAlign: TextAlign.center),
          ],
        ),
      );
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: context.theme.backgroundFormFieldColor,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () =>
                        AppRouter.backToPage(context, AppPages.Navigation),
                    icon: SvgPicture.asset(
                      Images.ic_x,
                      height: 20,
                      width: 20,
                    ),
                  ),
                ],
              ),
              Center(
                child: Container(
                  // padding: EdgeInsets.all(7),
                  height: 96,
                  width: 96,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 10,
                            color: AppColors.primary.withOpacity(0.1),
                            offset: const Offset(0, 2)),
                      ],
                      color: AppColors.white),
                  child: DisplayAvatar(
                    isGroup: false,
                    model: context.userInfo(),
                    size: 80,
                    enable: false,
                  ),
                ),
              ),
              SizedBoxExt.h10,
              Text(
                context.userInfo().name,
                style: AppTextStyles.regularW500(context, size: 16),
              ),
              SizedBoxExt.h16,
              Text(
                StringConst.shareQRCode,
                style: AppTextStyles.regularW400(context, size: 14),
              ),
              SizedBoxExt.h50,
              Container(
                  height: 253,
                  width: 253,
                  decoration: BoxDecoration(
                      // borderRadius: BorderRadius.circular(100),
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 10,
                            color: AppColors.primary.withOpacity(0.1),
                            offset: const Offset(0, 2)),
                      ], color: AppColors.white),
                  child: Image.asset(Images.img_logo_qr)

                  // ClipRRect(
                  //   // borderRadius: BorderRadius.circular(100),
                  //   child: CachedNetworkImage(
                  //     fit: BoxFit.cover,
                  //     imageUrl: 'https://mess.timviec365.vn/avatarUser/1408/637946154862167448_1408.jpg',
                  //     height: 253,
                  //     width: 253,
                  //     placeholder: (context, url) => const SizedBox(
                  //       child: CircularProgressIndicator(),
                  //       width: 23,
                  //       height: 23,
                  //     ),
                  //     errorWidget: (context, url, error) => const Icon(
                  //       Icons.error,
                  //     ),
                  //   ),
                  // ),
                  ),
              SizedBoxExt.h40,
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceAround,
              //   children: [
              //     _CustomColumn(
              //       onTap: () {
              //         AppDialogs.toast('Chức năng đang phát triển');
              //       },
              //       title: StringConst.share,
              //       icon: Images.ic_share_qr,
              //     ),
              //     _CustomColumn(
              //       onTap: () {
              //         AppDialogs.toast('Chức năng đang phát triển');
              //       },
              //       title: StringConst.download,
              //       icon: Images.ic_download,
              //     ),
              //   ],
              // )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQRView(BuildContext context) {
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 250.0
        : 300.0;
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
    try {
      // setState(() {
      _controllerCameraQR = controller..resumeCamera();
      // });
      _controllerCameraQR!.scannedDataStream.listen((scanData) async {
        final currentScan = DateTime.now();

        if (lastScan == null ||
            currentScan.difference(lastScan!) > const Duration(seconds: 1)) {
          lastScan = currentScan;
          result = scanData;
          if (result != null) {
            // print('Ma quet : ${result!}');
            // await _scanQrAttendanceBloc.DecodeQR(
            //     result!.code!.split('?').last.toString());
            // log(result!.code!.split('?').last.toString());
          }
        }
      });
    } catch (e) {
      print(e);
    }
  }
}

///Nhan quyen truy cap camera
void _onPermissionSet(
    BuildContext context, QRViewController ctrl, bool p) async {
  if (!p) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Không có quyền truy cập')),
    );
  }
}
