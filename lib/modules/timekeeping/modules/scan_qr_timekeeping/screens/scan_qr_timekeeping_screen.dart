import 'dart:developer';

import 'package:chat_365/core/constants/local_storage_key.dart';
import 'package:chat_365/core/theme/app_colors.dart';
import 'package:chat_365/modules/timekeeping/bloc/timekeeping_bloc.dart';
import 'package:chat_365/utils/data/extensions/context_extension.dart';
import 'package:chat_365/utils/helpers/logger.dart';
import 'package:chat_365/utils/ui/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:sp_util/sp_util.dart';

import '../../../../../common/images.dart';
import '../../../../../common/widgets/button/custom_button.dart';
import '../../../../../core/theme/app_dimens.dart';
import '../../../../../core/theme/app_text_style.dart';
import '../../../../../router/app_pages.dart';
import '../../../../../router/app_router.dart';
import '../../../../../utils/ui/app_dialogs.dart';
import '../../../widgets/item_list_shift.dart';
import '../models/decode_qr_model.dart';
import '../scan_qr_attendance_bloc/scan_qr_attendance_bloc.dart';

class ScanQRTimekeepingScreen extends StatefulWidget {
  const ScanQRTimekeepingScreen({Key? key}) : super(key: key);

  @override
  State<ScanQRTimekeepingScreen> createState() =>
      _ScanQRTimekeepingScreenState();
}

class _ScanQRTimekeepingScreenState extends State<ScanQRTimekeepingScreen> {
  Barcode? result;
  QRViewController? _controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  late final ScanQrAttendanceBloc _scanQrAttendanceBloc;
  late final TimekeepingBloc _timekeepingBloc;
  late bool? colorBack;
  var address;
  // var latLong;
  var lat;
  var long;
  var distance;
  var wifiName;
  var wifiID;
  var wifiIP;
  var deviceInfo;
  var idDevice;
  String? deviceId;
  @override
  void initState() {
    colorBack = false;
    _scanQrAttendanceBloc = ScanQrAttendanceBloc();
    // TODO: implement initState
    _timekeepingBloc = context.read<TimekeepingBloc>();
    super.initState();
  }

  @override
  void dispose() {
    _controller!.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    try {
      address = _timekeepingBloc.address;
      // latLong = context.args['latLong'];
      lat = _timekeepingBloc.currentLocation!.latitude;
      long = _timekeepingBloc.currentLocation!.longitude;
      distance = _timekeepingBloc.totalDistance;
      wifiName = _timekeepingBloc.nameWifi;
      wifiID = _timekeepingBloc.wifiID;
      wifiIP = _timekeepingBloc.wifiIp;
      deviceInfo = _timekeepingBloc.deviceInfo;
      idDevice = _timekeepingBloc.idDevice;

      SpUtil.putString(LocalStorageKey.uuidDevice, _timekeepingBloc.idDevice);
      print(
          'Dữ Liệu: $address - $lat - $long - $distance - $wifiName - $wifiID');
    } catch (e) {
      print('Error: ${e.toString()}');
    }
    super.didChangeDependencies();
  }

  /// Dung cho chuc nang delay thoi gian scan qr code
  DateTime? lastScan;
  DecodeQrAttendanceModel? model;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _buildQRView(context),
          Positioned(
            top: 50,
            left: 0,
            child: BackButton(color: AppColors.white),
          )
        ],
      ),
    );
  }

  Widget _buildQRView(BuildContext context) {
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 250.0
        : 300.0;
    return BlocProvider.value(
      value: _scanQrAttendanceBloc,
      child: BlocListener<ScanQrAttendanceBloc, ScanQrAttendanceState>(
        listenWhen: (_, current) => current is ScanQrInfoState,
        listener: (context, state) {
          AppRouter.removeAllDialog(context);
          // TODO: implement listener
          if (state is ScanQrAttendanceLoadingState) {
            AppDialogs.showLoadingCircle(context);
            print(SpUtil.getString("uuid_device"));
          }
          if (state is ScanQRAttendanceChangeDeviceState) {
            try {
              log(SpUtil.getString("uuid_device")! + "day nekkkkssssssss");
              // SpUtil.putString(LocalStorageKey.uuidDevice, idDevice);
              // if (deviceId == null) {
              //   // deviceId = state.model!.device?.currentDevice;
              //   // if (deviceId == null)

              //   print(idDevice);
              // }
              _controller?.pauseCamera();
              // _showScanFaceSuccessBottomSheet();
            } catch (e, s) {
              print(
                  '+++++++++++++++++++++++++++++++++++\n+++++++++++++++++++++++++++');
              logger.logError(e, s);
            }
            AppDialogs.showAttendanceDialog(context,
                function: () async {
                  log(SpUtil.getString(LocalStorageKey.uuidDevice).toString() +
                      "xxxxxxxxxxxxxxx");
                  // ddang code do can than cho ==
                  await _scanQrAttendanceBloc
                      .timekeeping(
                        isLocationValid: "0",
                        shiftId: _scanQrAttendanceBloc.idShift,
                        uuid_device:
                            SpUtil.getString(LocalStorageKey.uuidDevice),
                        device: _timekeepingBloc.deviceqr,
                        tsLat: _timekeepingBloc.currentLocation?.latitude,
                        tsLong: _timekeepingBloc.currentLocation?.longitude,
                        tsLocationName: _timekeepingBloc.address,
                        phoneName: _timekeepingBloc.phoneNameQR,
                        from: "Chat365",
                      )
                      .then((value) => _showAttendanceStatus());
                  setState(() {});
                },
                cancelF: () =>
                    {Navigator.pop(context), _controller!.resumeCamera()},
                title:
                    "Bạn đang điểm danh trên thiết bị mới. Để chấm công hợp lệ, vui lòng liên hệ với quản lý công ty xác nhận. Bạn có muốn tiếp tục không ?");
            _controller?.pauseCamera();
          } else if (state is ScanQRAttendanceErrorState) {
            // controller?.resumeCamera();
            AppDialogs.toast(state.error!);
          } else if (state is ScanQRAttendanceSuccessState) {
            // log(_scanQrAttendanceBlocinfo.allShift[0].shiftName);
            // log(_scanQrAttendanceBlocinfo.detailCor.corLocationName);
            try {
              print(idDevice);
              if (deviceId == null) {
                deviceId = state.model.device?.currentDevice;
                if (deviceId == null)
                  SpUtil.putString(LocalStorageKey.uuidDevice, idDevice);
                print(idDevice);
              }
              _controller?.pauseCamera();
              _showScanFaceSuccessBottomSheet();
            } catch (e, s) {
              print(
                  '+++++++++++++++++++++++++++++++++++\n+++++++++++++++++++++++++++');
              logger.logError(e, s);
            }
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
      ),
    );
  }

  /// Ham xu ly khi quet duoc qr
  void _onQRViewCreated(QRViewController controller) {
    log("khoi tao cam ");
    try {
      // setState(() {
      _controller = controller..resumeCamera();
      // });
      _controller!.scannedDataStream.listen((scanData) async {
        final currentScan = DateTime.now();

        if (lastScan == null ||
            currentScan.difference(lastScan!) > const Duration(seconds: 1)) {
          lastScan = currentScan;
          result = scanData;
          if (result != null) {
            // print('Ma quet : ${result!}');
            await _scanQrAttendanceBloc.DecodeQR(
                result!.code!.split('?').last.toString());
            log(result!.code!.split('?').last.toString());
          }
        }
      });
    } catch (e) {
      print(e);
    }
  }

  _showScanFaceSuccessBottomSheet() {
    showModalBottomSheet(
            enableDrag: false,
            isDismissible: false,
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height -
                  context.mediaQueryPadding.top -
                  56,
            ),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
            ),
            isScrollControlled: true,
            context: context,
            builder: (context) => buildSheetAttendance(context))
        .then((value) => setState(() {
              colorBack = false;
            }));
  }

  Widget buildSheetAttendance(BuildContext context) => WillPopScope(
        onWillPop: () async => false,
        child: BlocProvider.value(
          value: _scanQrAttendanceBloc,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 31, right: 11, left: 11, bottom: 17),
              child: Column(
                children: [
                  ContainerCustom(
                    titleIcon: Images.ic_info_location,
                    title: 'Thông tin vị trí',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 10),
                        _iconText(Images.ic_lat_long, '№${lat} x $long'),
                        SizedBox(height: 16),
                        _iconText(Images.ic_location_timekeeping, 'Địa chỉ: ',
                            _timekeepingBloc.address),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Divider(
                            color: AppColors.greyCACA,
                          ),
                        ),
                        _iconText2(
                            Images.ic_coordinates,
                            'Cách tọa độ công ty: ',
                            _timekeepingBloc.totalDistance.toString() + " m"),
                      ],
                    ),
                  ),
                  // SizedBox(height: 47),
                  // ContainerCustom(
                  //   titleIcon: Images.ic_wifi,
                  //   title: 'Kết nối Wifi',
                  //   child: Column(
                  //     crossAxisAlignment: CrossAxisAlignment.center,
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     children: [
                  //       SizedBox(height: 10),
                  //       _iconText(Images.ic_name_wifi, 'Tên Wifi: ', wifiName),
                  //       Padding(
                  //         padding: const EdgeInsets.symmetric(vertical: 10),
                  //         child: Divider(
                  //           color: AppColors.greyCACA,
                  //         ),
                  //       ),
                  //       _iconText(Images.ic_coordinates, 'ID wifi: ', wifiID),
                  //     ],
                  //   ),
                  // ),
                  SizedBox(height: 31),
                  ContainerCustom(
                      titleIcon: Images.ic_choose_shift,
                      title: 'Chọn ca làm việc',
                      child: SizedBox(
                        // height: 200,
                        height: 200,
                        child: BlocBuilder<ScanQrAttendanceBloc,
                            ScanQrAttendanceState>(
                          buildWhen: (_, current) => current is ScanQrInfoState,
                          builder: (context, state) {
                            if (state is ScanQRAttendanceSuccessState) {
                              var info = state.model;
                              return StatefulBuilder(
                                  builder: (context, setState) {
                                return ListView.builder(
                                  padding: EdgeInsets.only(bottom: 20),
                                  itemCount: info.allShift.length,
                                  // physics: NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) =>
                                      ListShiftItem(
                                    title: info.allShift[index].shiftName,
                                    startTime: info.allShift[index].startTime
                                        .substring(0, 5),
                                    endTime: info.allShift[index].endTime
                                        .substring(0, 5),
                                    id: _scanQrAttendanceBloc.idShift,
                                    idList: info.allShift[index].shiftId,
                                    onPress: () {
                                      log(info.allShift[index].shiftId);
                                      // print(
                                      //     'Số: ${.listShift.length}');
                                      setState(() {
                                        _scanQrAttendanceBloc.idShift =
                                            info.allShift[index].shiftId;
                                        _scanQrAttendanceBloc.nameShift =
                                            info.allShift[index].shiftName;
                                      });
                                    },
                                  ),
                                );
                              });
                            }

                            return WidgetUtils.loadingCircle(context);
                          },
                        ),
                      )),
                  SizedBox(height: 30),
                  CustomButton(
                    child: Text(
                      'Chấm công',
                      style: AppTextStyles.regularW700(
                        context,
                        size: 16,
                        color: AppColors.white,
                      ),
                    ),
                    onTap: () async {
                      String str = distance.toString();
                      int len = str.length;
                      String r = str.substring(0, len - 1);
                      log(r);
                      print('Đã bấm');
                      Navigator.of(context).pop();
                      await _scanQrAttendanceBloc
                          .timekeeping(
                            isLocationValid:
                                (double.tryParse(r) ?? 0) < 50 ? "1" : "0",
                            shiftId: _scanQrAttendanceBloc.idShift,
                            uuid_device:
                                SpUtil.getString(LocalStorageKey.uuidDevice),
                            device: _timekeepingBloc.deviceqr,
                            tsLat: _timekeepingBloc.currentLocation!.latitude,
                            tsLong: _timekeepingBloc.currentLocation!.longitude,
                            tsLocationName: _timekeepingBloc.address,
                            phoneName: _timekeepingBloc.phoneNameQR,
                            from: "Chat365",
                          )
                          .then((value) => _showAttendanceStatus());
                      setState(() {});
                    },
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AppColors.primary,
                    ),
                    width: MediaQuery.of(context).size.width * 0.5,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
  Widget ContainerCustom(
      {required String titleIcon,
      required String title,
      required Widget child}) {
    return Stack(
        alignment: Alignment.topCenter,
        clipBehavior: Clip.none,
        children: [
          Container(
              decoration: BoxDecoration(
                  color: AppColors.white,
                  border: Border.all(color: AppColors.primary, width: 1),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: AppDimens.shadow),
              padding: EdgeInsets.all(18),
              child: child),
          Positioned(
            top: -14,
            left: 29,
            right: 21,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              alignment: Alignment.center,
              // height: 31,
              child: Row(
                children: [
                  SvgPicture.asset(titleIcon),
                  SizedBox(width: 12),
                  Text(
                    title,
                    style: AppTextStyles.regularW400(context,
                        size: 16, color: AppColors.white),
                  ),
                ],
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: AppColors.primary,
              ),
            ),
          ),
        ]);
  }

  Widget _iconText(String icon, String text, [String? text2]) {
    return Row(children: [
      SvgPicture.asset(icon),
      SizedBox(width: 13.5),
      Expanded(
        child: RichText(
          text: TextSpan(
            children: <TextSpan>[
              TextSpan(
                text: text,
                style: AppTextStyles.regularW400(context, size: 16),
              ),
              TextSpan(
                text: text2,
                style: AppTextStyles.regularW400(context, size: 16),
              )
            ],
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
        ),
      )
    ]);
  }

  Widget _iconText2(String icon, String text, String text2) {
    return Row(
      children: [
        SvgPicture.asset(icon),
        SizedBox(width: 13.5),
        Row(
          children: [
            Text(
              text,
              style: AppTextStyles.regularW400(context, size: 16),
            ),
            Text(
              text2,
              style: AppTextStyles.regularW400(context,
                  size: 16, color: AppColors.orange),
            ),
          ],
        )
      ],
    );
  }

  _showAttendanceStatus() async {
    await showModalBottomSheet(
      // enableDrag: false,
      isDismissible: false,
      isScrollControlled: true,
      constraints: BoxConstraints(
        minWidth: MediaQuery.of(context).size.width - 20 * 2,
        maxWidth: MediaQuery.of(context).size.width - 20 * 2,
        maxHeight: MediaQuery.of(context).size.height -
            context.mediaQueryPadding.top -
            220,
      ),
      builder: (context) => buildSheetSuccessful(context),
      context: context,
    ).then((value) => setState(() {
          colorBack = false;
          _scanQrAttendanceBloc.noteTimekeeping;
        }));
  }

  Widget buildSheetSuccessful(BuildContext context) => WillPopScope(
        onWillPop: () async => false,
        child: ValueListenableBuilder<bool>(
          valueListenable: _scanQrAttendanceBloc.attendanceResults,
          builder: (context, value, __) {
            return Stack(
              alignment: Alignment.topCenter,
              clipBehavior: Clip.none,
              children: [
                // Positioned(
                //   top: -70,
                //   child: Stack(
                //     clipBehavior: Clip.none,
                //     children: [
                //       Positioned(
                //         child: SvgPicture.asset(
                //             value ? Images.ic_successful : Images.ic_failure),
                //         bottom: 0,
                //         right: 0,
                //       ),
                //     ],
                //   ),
                // ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 30),
                      value
                          ? Text(
                              'ĐIỂM DANH THÀNH CÔNG',
                              style: AppTextStyles.regularW500(
                                context,
                                size: 20,
                                color: AppColors.primary,
                              ),
                            )
                          : Text(
                              'ĐIỂM DANH THẤT BẠI',
                              style: AppTextStyles.regularW500(
                                context,
                                size: 20,
                                color: AppColors.red,
                              ),
                            ),
                      SizedBox(height: 11),
                      Text(
                        _scanQrAttendanceBloc.time ?? '',
                        style: AppTextStyles.regularW700(
                          context,
                          size: 35,
                          color: AppColors.orange,
                        ),
                      ),
                      SizedBox(height: 16),
                      Container(
                        color: AppColors.blueD4E7F7,
                        padding:
                            EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      'Tháng ${_scanQrAttendanceBloc.month ?? ""}',
                                      style: AppTextStyles.regularW500(
                                        context,
                                        size: 16,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                    SizedBox(height: 3),
                                    Text(
                                      _scanQrAttendanceBloc.day ?? '',
                                      style: AppTextStyles.regularW500(
                                        context,
                                        size: 16,
                                        color: AppColors.orange,
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 11),
                                  child: const SizedBox(
                                    height: 48,
                                    width: 0,
                                    child: VerticalDivider(
                                        color: AppColors.tundora),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    _scanQrAttendanceBloc.nameShift ?? "",
                                    style: AppTextStyles.regularW500(
                                      context,
                                      size: 16,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: 7),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Ghi chú:      ',
                                  style: AppTextStyles.regularW500(
                                    context,
                                    size: 16,
                                    color: AppColors.primary,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    _scanQrAttendanceBloc.noteTimekeeping ?? "",
                                    style: AppTextStyles.regularW400(
                                      context,
                                      size: 14,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 30),
                      if (_scanQrAttendanceBloc.attendanceResults.value)
                        CustomButton(
                            onTap: () => AppRouter.backToPage(
                                context, AppPages.Navigation),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(5)),
                            child: Text(
                              'Trang Chủ',
                              style: AppTextStyles.regularW700(
                                context,
                                size: 18,
                                color: AppColors.white,
                              ),
                            ))
                      else
                        Column(
                          children: [
                            CustomButton(
                                onTap: () async {
                                  // Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                  _controller?.resumeCamera();
                                  AppRouter.removeAllDialog(context);
                                },
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    borderRadius: BorderRadius.circular(5)),
                                child: Text(
                                  'Điểm danh lại',
                                  style: AppTextStyles.regularW700(
                                    context,
                                    size: 18,
                                    color: AppColors.white,
                                  ),
                                )),
                            SizedBox(height: 28),
                            CustomButton(
                                onTap: () => AppRouter.backToPage(
                                    context, AppPages.Navigation),
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                      color: AppColors.primary, width: 1),
                                ),
                                child: Text(
                                  'Hủy',
                                  style: AppTextStyles.regularW700(
                                    context,
                                    size: 18,
                                    color: AppColors.primary,
                                  ),
                                ))
                          ],
                        )
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      );
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
