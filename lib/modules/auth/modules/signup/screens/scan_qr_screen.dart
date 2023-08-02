import 'package:chat_365/common/images.dart';
import 'package:chat_365/core/theme/app_colors.dart';
import 'package:chat_365/modules/auth/modules/signup/cubit/signup_cubit.dart';
import 'package:chat_365/modules/auth/modules/signup/screens/set_up_account_information_screen.dart';
import 'package:chat_365/router/app_pages.dart';
import 'package:chat_365/router/app_router.dart';
import 'package:chat_365/utils/data/enums/auth_mode.dart';
import 'package:chat_365/utils/data/extensions/context_extension.dart';
import 'package:chat_365/utils/ui/app_dialogs.dart';
import 'package:chat_365/utils/ui/app_padding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ScanQRScreen extends StatefulWidget {
  const ScanQRScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ScanQRScreenState();
}

class _ScanQRScreenState extends State<ScanQRScreen> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  late SignUpCubit _signUpCubit;

  /// Dung cho chuc nang delay thoi gian scan qr code
  DateTime? lastScan;
  @override
  void initState() {
    _signUpCubit = context.read<SignUpCubit>();
    reassemble();
    super.initState();
  }

  // @override
  // void reassemble() {
  //   super.reassemble();
  //   if (Platform.isAndroid) {
  //     controller!.pauseCamera();
  //   } else if (Platform.isIOS) {
  //     controller!.resumeCamera();
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: AppColors.primary,
          ),
          onPressed: () => AppRouter.back(context),
        ),
      ),
      body: Stack(
        children: <Widget>[
          _buildQrView(context),

          // Nut bat tat den flash
          Positioned(
            bottom: 90,
            right: 0,
            left: 0,
            child: SizedBox(
              height: 60, //height of button
              width: 60,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: CircleBorder(side: BorderSide.none),
                      padding: AppPadding.paddingAll16),
                  onPressed: () async {
                    await controller?.toggleFlash();
                    setState(() {});
                  },
                  child: FutureBuilder(
                    future: controller?.getFlashStatus(),
                    builder: (context, snapshot) {
                      return SvgPicture.asset(
                        snapshot.data == true
                            ? Images.ic_lighting_splash
                            : Images.ic_lighting,
                        color: context.theme.backgroundColor,
                        width: 40,
                      );
                    },
                  )),
            ),
          ),
        ],
      ),
    );
  }

  /// Ham tao widget
  Widget _buildQrView(BuildContext context) {
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 250.0
        : 300.0;
    return BlocListener<SignUpCubit, SignUpState>(
      listener: (context, state) {
        /// Cac hieu ung khong duoc listen o mam truoc
        if (state is CompareIdCompanyStateLoad) {
          controller?.pauseCamera();
        } else if (state is CompareIdCompanyStateError) {
          controller?.resumeCamera();
        } else if (state is CompareIdCompanyStateSuccess) {
          AppDialogs.hideLoadingCircle(context);

          AppRouter.replaceWithPage(context, AppPages.Auth_SetUpAccount,
              blocValue: context.read<SignUpCubit>(),
              arguments: {
                SetUpAccountInformationScreen.authModeArg: AuthMode.REGISTER
              });
        }
      },
      child: QRView(
        key: qrKey,
        onQRViewCreated: _onQRViewCreated,
        overlay: QrScannerOverlayShape(
            borderColor: AppColors.primary,
            borderRadius: 10,
            borderLength: 30,
            borderWidth: 10,
            cutOutSize: scanArea),
        onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
      ),
    );
  }

  /// Ham xu ly khi quet duoc qr
  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });

    controller.scannedDataStream.listen((scanData) async {
      final currentScan = DateTime.now();

      if (lastScan == null ||
          currentScan.difference(lastScan!) > const Duration(seconds: 1)) {
        lastScan = currentScan;
        result = scanData;
        if (result != null) {
          // print('Ma quet : ${result!}');
          await _signUpCubit.checkIdCompany(result!.code!);
        }
      }
      ;
    });
  }

  /// Ham xac nhan quyen truy cap camera
  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không có quyền truy cập')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
