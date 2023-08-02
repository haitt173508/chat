import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:camera/camera.dart';
import 'package:chat_365/common/images.dart';
import 'package:chat_365/common/widgets/button/custom_button.dart';
import 'package:chat_365/core/constants/string_constants.dart';
import 'package:chat_365/core/theme/app_colors.dart';
import 'package:chat_365/core/theme/app_dimens.dart';
import 'package:chat_365/core/theme/app_text_style.dart';
import 'package:chat_365/modules/timekeeping/bloc/timekeeping_bloc.dart';
import 'package:chat_365/modules/timekeeping/modules/scan_face_timekeeping/animation_scan.dart';
import 'package:chat_365/modules/timekeeping/modules/scan_face_timekeeping/bloc/scan_face_bloc.dart';
import 'package:chat_365/modules/timekeeping/modules/scan_face_timekeeping/bloc/scan_face_state.dart';
import 'package:chat_365/modules/timekeeping/widgets/custom_icon.dart';
import 'package:chat_365/modules/timekeeping/widgets/item_list_shift.dart';
import 'package:chat_365/router/app_pages.dart';
import 'package:chat_365/router/app_router.dart';
import 'package:chat_365/utils/data/extensions/context_extension.dart';
import 'package:chat_365/utils/data/extensions/date_time_extension.dart';
import 'package:chat_365/utils/helpers/camera_utils.dart';
import 'package:chat_365/utils/ui/app_dialogs.dart';
import 'package:chat_365/utils/ui/widget_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image/image.dart' as image;

String encodeImageAndroid(CameraImage imageData) {
  return base64Encode(imageData.planes[0].bytes);
}

String encodeImageIos(CameraImage imageData) {
  var temp = DateTimeExt.convertImagetoPng(imageData);
  var listIntImage = Uint8List.fromList(temp);
  return base64Encode(listIntImage);
}

class FaceTimekeepingScreen extends StatefulWidget {
  const FaceTimekeepingScreen({Key? key}) : super(key: key);

  @override
  State<FaceTimekeepingScreen> createState() => _FaceTimekeepingScreenState();
}

class _FaceTimekeepingScreenState extends State<FaceTimekeepingScreen>
    with TickerProviderStateMixin {
  // List<CameraDescription>? cameras;
  // late final ScanFaceCubit bloc;
  final CameraUtils cameraUtils = new CameraUtils();
  CameraController? controller;
  late final AnimationController _animationController;
  late final CameraDescription description;
  late final TimekeepingBloc _timekeepingBloc;

  // bool error = false;
  // bool valueDelayFirst = false;
  Timer? _timer;
  Timer? _takeTimeKeepingAgainThrotterTimer;
  late final Future _initCamera;
  final ScanFaceBloc _scanFaceBloc = ScanFaceBloc();
  late final theme;

  @override
  void initState() {
    theme = context.theme;
    _animationController = new AnimationController(
      duration: new Duration(milliseconds: 800),
      vsync: this,
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          animateScanAnimation(true);
        } else if (status == AnimationStatus.dismissed) {
          animateScanAnimation(false);
        }
      });
    _initCamera = createCameraController(CameraDescription(
      name: 'name',
      lensDirection: CameraLensDirection.front,
      sensorOrientation: 0,
    )).then((_) {
      if (controller != null) {
        _animationController.forward();
        _startCounting();
      }
    });
    _scanFaceBloc.getListShift(
        context.userInfo().id365, context.userInfo().companyId);
    _timekeepingBloc = context.read<TimekeepingBloc>();
    super.initState();
  }

  static const int counterTimeKeeping = 3;
  static const int counterTimeKeepingAgain = 2;
  ValueNotifier<int> _currentTick = ValueNotifier(counterTimeKeeping);

  // int miliSecondToSend = DateTime?.now().millisecondsSinceEpoch;

  // stopScanAnimation() {
  // setState(() {
  // _animationStopped = true;
  // scanning = false;
  // scanText = "Scan";
  // });
  // }

  // startScanAnimation() {
  //   animateScanAnimation(true);
  // setState(() {
  // _animationStopped = false;
  // scanning = true;
  // scanText = "Stop";
  // });
  // }

  _resetCurrentTick() => _currentTick.value = counterTimeKeeping;

  _startCounting() {
    if (!mounted) return;
    _animationController.forward(from: _animationController.value);
    _resetCurrentTick();
    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      if (_currentTick.value == 1) {
        _timer?.cancel();
        _callTimeKeeping();
      } else if (_currentTick.value == 0) {
        _timer?.cancel();
        return;
      }
      _currentTick.value--;
    });
  }

  _callTimeKeeping() => toTakePhoto();

  Uint8List? notImage;

  Future<Uint8List> _createFileFromString(String encodedStr) async {
    Uint8List bytes = base64.decode(encodedStr);
    return bytes;
  }

  void animateScanAnimation(bool reverse) {
    if (reverse) {
      _animationController.reverse(from: 1.0);
    } else {
      _animationController.forward(from: 0.0);
    }
  }

  @override
  void didChangeDependencies() {
    try {} catch (e) {
      print('Error: ${e.toString()}');
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    controller?.dispose();
    // _iconsAnimationController!.dispose();
    // _previewAnimationController!.dispose();
    _animationController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _scanFaceBloc,
      child: BlocListener<ScanFaceBloc, ScanFaceState>(
        listenWhen: (_, __) => mounted,
        listener: (_, state) async {
          AppRouter.removeAllDialog(context);
          if (state is ApiCameraAttendanceSuccess) {
            _showScanFaceSuccessBottomSheet(
              await _createFileFromString(state.base64ImageString),
            );
          } else if (state is ScanFaceError) {
            AppDialogs.toast(state.error);
            _timeKeepingAgain();
          } else if (state is ApiCameraAttendanceLoading) {
            _animationController.stop();
            AppDialogs.showLoadingCircle(context);
          }
        },
        child: Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            actions: [
              if (kDebugMode)
                ValueListenableBuilder<Uint8List?>(
                    valueListenable: _cameraImage,
                    builder: (_, image, __) {
                      return SizedBox.square(
                        dimension: 56,
                        child: image != null
                            ? Image.memory(image)
                            : Container(
                                color: Colors.red,
                              ),
                      );
                    })
            ],
            leading: BackButton(
              color: AppColors.black,
              onPressed: () => AppRouter.back(context),
            ),
          ),
          body: FutureBuilder(
            future: _initCamera,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (controller != null) {
                  return Stack(
                    children: [
                      SizedBox.expand(child: CameraPreview(controller!)),
                      buildAlignScaffoldScan(),
                      countTimeKeeping()
                    ],
                  );
                } else {
                  AppDialogs.toast('Không thể khởi tạo camera');
                  return const SizedBox();
                }
              }
              return WidgetUtils.centerLoadingCircle;
            },
          ),
        ),
      ),
    );
  }

  //khởi tạo camera
  Future createCameraController(CameraDescription cameraDescription) async {
    // await Future.delayed(Duration(milliseconds: 200));
    // print('createCameraController');
    // controller = CameraController(cameraDescription, Platform.isAndroid ? ResolutionPreset.high : ResolutionPreset.medium);
    final ResolutionPreset resolutionPreset =
        Platform.isAndroid ? ResolutionPreset.high : ResolutionPreset.medium;
    final CameraLensDirection cameraLensDirection = CameraLensDirection.front;
    try {
      controller = await cameraUtils.getCameraController(
          resolutionPreset, cameraLensDirection);
      // Future.delayed(Duration(seconds: 6));
      await controller!.initialize();
    } catch (e) {
      // logger.logError(e, s, 'CreateCameraControllerError: ');
      // AppDialogs.toast('Không thể khởi tạo camera !');
    }
  }

  ValueNotifier<Uint8List?> _cameraImage = ValueNotifier(null);

  //hàm khởi tạo chụp ảnh
  // void toTakePhoto() async {
  //   // controller!.initialize().then((_) async{
  //   //   if (!mounted) {
  //   //     return;
  //   //   }
  //   // controller!.value = controller!.value.copyWith(
  //   //   isStreamingImages: false,
  //   // );
  //
  //   await controller!.startImageStream((image) async {
  //     _cameraImage.value = image;
  //     // int newSecond = DateTime?.now().second;
  //     // if (newSecond == secondToSend) return;
  //     // secondToSend = newSecond;
  //     // if (counterTimeKeeping == 0) {
  //     // int newMilliSecond = DateTime?.now().millisecondsSinceEpoch;
  //     // if ((newMilliSecond - miliSecondToSend) < 400) return;
  //     // miliSecondToSend = newMilliSecond;
  //     // print(image);
  //     // print('123: ${image}');
  //     // await Future.delayed(const Duration(milliseconds: 500));
  //
  //     emitImageToApi(image);
  //     controller!.stopImageStream();
  //     // _cameraImage.value = image;
  //     // }
  //   });
  //   // setState(() {});
  //   // });
  // }

  toTakePhoto() async {
    final image = await controller!.takePicture();
    var imageData = await image.readAsBytes();
    if (Platform.isIOS)
      imageData = _iosRotateImage(imageData);
    else
      imageData = await _androidRotateImage(imageData);

    _scanFaceBloc.ScanFaceTimekeeping(
      context.userInfo().companyId,
      context.userInfo().id365,
      base64Encode(imageData),
    );
  }

  _androidRotateImage(List<int> imageBytes) =>
      FlutterImageCompress.compressWithList(
        Uint8List.fromList(imageBytes),
        quality: 100,
        rotate: 0,
      );

  _iosRotateImage(List<int> imageBytes) {
    final originalImage = image.decodeImage(imageBytes)!;
    final orientedImage = image.copyRotate(originalImage, pi / 2);
    return Uint8List.fromList(image.encodeJpg(orientedImage));
  }

  // APi
  void emitImageToApi(CameraImage imageData) async {
    var base64Request = Platform.isAndroid
        ? encodeImageAndroid(imageData)
        : encodeImageIos(imageData);
    _scanFaceBloc.ScanFaceTimekeeping(
      context.userInfo().companyId,
      context.userInfo().id365,
      base64Request,
    );
  }

  _showScanFaceSuccessBottomSheet(dynamic faceImageData) {
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
        builder: (context) => buildSheetAttendance(context, faceImageData));
  }

  _showAttendanceStatus() {
    showModalBottomSheet(
      enableDrag: false,
      isDismissible: false,
      isScrollControlled: true,
      constraints: BoxConstraints(
        minWidth: MediaQuery.of(context).size.width - 20 * 2,
        maxWidth: MediaQuery.of(context).size.width - 20 * 2,
        maxHeight: MediaQuery.of(context).size.height,
      ),
      builder: (context) => buildSheetSuccessful(context),
      context: context,
    );
  }

  _timeKeepingAgain() {
    if (!mounted) {
      Fluttertoast.cancel();
      _takeTimeKeepingAgainThrotterTimer!.cancel();
      _takeTimeKeepingAgainThrotterTimer = null;
      return;
    }

    int count = counterTimeKeepingAgain;
    _takeTimeKeepingAgainThrotterTimer = Timer.periodic(
      Duration(seconds: 1),
      (_) {
        if (count == 0) {
          Fluttertoast.cancel();
          _takeTimeKeepingAgainThrotterTimer?.cancel();
          _takeTimeKeepingAgainThrotterTimer = null;
          _startCounting();
          return;
        } else {
          AppDialogs.toast(
            'Chấm công lại trong $count giây nữa',
            color: theme.primaryColor,
            textColor: AppColors.white,
          );
          count--;
        }
      },
    );
  }

  Align buildAlignScaffoldScan() {
    return Align(
      alignment: Alignment.center,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: 300 - 16,
            width: 300 + 16,
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Image.asset(
              Images.img_scan_camera,
              height: double.infinity,
              width: double.infinity,
            ),
          ),
          // counterTimeKeeping == 0
          //     ?
          buildAlignImageScannerAnimation(context),
          // : SizedBox.shrink(),
          //icon back
        ],
      ),
    );
  }

  //Timekeeping count start
  Align countTimeKeeping() => Align(
        alignment: Alignment.center,
        child: ValueListenableBuilder<int>(
            valueListenable: _currentTick,
            builder: (context, tick, _) {
              if (tick == 0)
                return const SizedBox(
                  key: ValueKey(
                    'hided-counter',
                  ),
                );
              return Container(
                width: MediaQuery.of(context).size.width * 0.55,
                height: 44,
                padding:
                    EdgeInsets.only(top: 8, bottom: 8, right: 24, left: 24),
                decoration: BoxDecoration(
                  color: AppColors.red,
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: Text(
                  'Nhận diện trong $tick',
                  style: AppTextStyles.regularW700(context,
                      size: 17, color: AppColors.white),
                  textAlign: TextAlign.justify,
                ),
              );
            }),
      );

  ImageScannerAnimation buildAlignImageScannerAnimation(BuildContext context) {
    return ImageScannerAnimation(
      // _animationStopped,
      MediaQuery.of(context).size.width,
      animation: _animationController,
    );
    //   (MediaQuery.of(context).size.width < 400 || MediaQuery.of(context).size.height < 400)
    //       ? Platform.isIOS
    //           ? 235.0
    //           : 220
    //       : Platform.isIOS
    //           ? 305.0
    //           : 300,
    //   animation: _animationController!,
    // );
  }

  Widget buildSheetAttendance(BuildContext context, dynamic imageData) =>
      WillPopScope(
        onWillPop: () async => false,
        child: StatefulBuilder(builder: (context, setState) {
          return SingleChildScrollView(
            child: BlocProvider.value(
              value: _timekeepingBloc,
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 31, right: 11, left: 11, bottom: 17),
                child: Column(
                  children: [
                    ContainerCustom(
                      icon: CustomIcon(onRefresh: () async {
                        await _timekeepingBloc.getUserLocation();
                        if (_timekeepingBloc.currentLocation != null)
                          setState(() {});
                      }),
                      titleIcon: Images.ic_info_location,
                      title: 'Thông tin vị trí',
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 10),
                          _iconText(Images.ic_lat_long,
                              '№${_timekeepingBloc.currentLocation?.latitude ?? '0.0'} x ${_timekeepingBloc.currentLocation?.longitude ?? '0.0'}'),
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
                            _timekeepingBloc.totalDistance.toString(),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 47),
                    ContainerCustom(
                      icon: CustomIcon(onRefresh: () async {
                        await _timekeepingBloc.getInfoWifi();
                        // print('naem: ${_timekeepingBloc.nameWifi?.replaceAll('"', '') ?? 'Chưa xác định'}');
                        setState(() {});
                      }),
                      titleIcon: Images.ic_wifi,
                      title: 'Kết nối Wifi',
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 10),
                          _iconText(
                              Images.ic_name_wifi,
                              'Tên Wifi: ',
                              _timekeepingBloc.nameWifi?.replaceAll('"', '') ??
                                  'Chưa xác định'),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Divider(
                              color: AppColors.greyCACA,
                            ),
                          ),
                          _iconText(Images.ic_coordinates, 'ID wifi: ',
                              _timekeepingBloc.wifiID),
                        ],
                      ),
                    ),
                    SizedBox(height: 47),
                    ContainerCustom(
                        icon: CustomIcon(onRefresh: () async {
                          await _scanFaceBloc.getListShift(
                              context.userInfo().id365,
                              context.userInfo().companyId);
                          setState(() {});
                        }),
                        titleIcon: Images.ic_choose_shift,
                        title: 'Chọn ca làm việc',
                        child: SizedBox(
                          height: 40 *
                              double.parse(
                                  _scanFaceBloc.listShift.length.toString()),
                          child: StatefulBuilder(builder: (context, setState) {
                            return ListView.builder(
                              padding: EdgeInsets.only(bottom: 20),
                              itemCount: _scanFaceBloc.listShift.length,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) => ListShiftItem(
                                title: _scanFaceBloc.listShift[index].shiftName,
                                startTime: _scanFaceBloc
                                    .listShift[index].startTime
                                    .substring(0, 5),
                                endTime: _scanFaceBloc.listShift[index].endTime
                                    .substring(0, 5),
                                id: _scanFaceBloc.idShift,
                                idList: _scanFaceBloc.listShift[index].shiftId,
                                onPress: () {
                                  setState(() {
                                    _scanFaceBloc.idShift =
                                        _scanFaceBloc.listShift[index].shiftId;
                                    _scanFaceBloc.nameShift = _scanFaceBloc
                                        .listShift[index].shiftName;
                                  });
                                },
                              ),
                            );
                          }),
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
                        // print('Đã bấm');
                        // _animationStopped = true;
                        Navigator.of(context).pop();
                        await _scanFaceBloc
                            .timekeeping(
                              _timekeepingBloc.device,
                              _timekeepingBloc.currentLocation?.latitude,
                              _timekeepingBloc.currentLocation?.longitude,
                              _timekeepingBloc.address,
                              _timekeepingBloc.nameWifi?.replaceAll('"', ''),
                              _timekeepingBloc.wifiIp,
                              _timekeepingBloc.wifiID,
                              _scanFaceBloc.idShift,
                              '',
                              _timekeepingBloc.configWifi!.isEmpty
                                  ? '1'
                                  : _timekeepingBloc.checkWifi(),
                              _timekeepingBloc.checkCoordinate(),
                              imageData,
                            )
                            .then((value) => _showAttendanceStatus());
                      },
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppColors.primary,
                      ),
                      width: MediaQuery.of(context).size.width,
                    ),
                    SizedBox(height: 28),
                    CustomButton(
                        onTap: () {
                          AppRouter.backToPage(
                              context, AppPages.Choose_A_Timekeeping);
                        },
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(10),
                          border:
                              Border.all(color: AppColors.primary, width: 1),
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
                ),
              ),
            ),
          );
        }),
      );

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
              '${text2} m',
              style: AppTextStyles.regularW400(context,
                  size: 16, color: AppColors.orange),
            ),
          ],
        )
      ],
    );
  }

  Widget ContainerCustom({
    required String titleIcon,
    required String title,
    required Widget child,
    required Widget icon,
  }) {
    return Stack(
        alignment: Alignment.topCenter,
        clipBehavior: Clip.none,
        children: [
          Container(
              decoration: BoxDecoration(
                  color: context.theme.backgroundFormFieldColor,
                  border: Border.all(color: AppColors.primary, width: 1),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: AppDimens.shadow),
              padding:
                  EdgeInsets.only(top: 24, bottom: 18, right: 18, left: 18),
              child: child),
          Positioned(
            top: -24,
            left: 29,
            right: 21,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
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
                  Spacer(),
                  icon
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

  Widget buildSheetSuccessful(BuildContext context) => WillPopScope(
      onWillPop: () async => false,
      child: ValueListenableBuilder<bool>(
          valueListenable: _scanFaceBloc.attendanceResults,
          builder: (context, value, __) {
            return Stack(
              alignment: Alignment.topCenter,
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  top: -70,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        padding: EdgeInsets.all(7),
                        height: 140,
                        width: 140,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: 10,
                                  color: AppColors.primary.withOpacity(0.1),
                                  offset: const Offset(0, 2)),
                            ],
                            color: AppColors.white),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: CachedNetworkImage(
                            fit: BoxFit.cover,
                            imageUrl:
                                '${StringConst.path_image_timekeeping}${_scanFaceBloc.logo}',
                            height: 140,
                            width: 140,
                            placeholder: (context, url) => const SizedBox(
                              child: CircularProgressIndicator(),
                              width: 23,
                              height: 23,
                            ),
                            errorWidget: (context, url, error) => const Icon(
                              Icons.error,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        child: SvgPicture.asset(
                            value ? Images.ic_successful : Images.ic_failure),
                        bottom: 0,
                        right: 0,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20).copyWith(bottom: 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 90),
                      value
                          ? Text(
                              'CHẤM CÔNG THÀNH CÔNG',
                              style: AppTextStyles.regularW500(
                                context,
                                size: 20,
                                color: AppColors.primary,
                              ),
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'CHẤM CÔNG THẤT BẠI',
                                  style: AppTextStyles.regularW500(
                                    context,
                                    size: 20,
                                    color: AppColors.red,
                                  ),
                                ),
                                SizedBox(height: 6),
                                Text(
                                  _scanFaceBloc.error ?? "",
                                  style: AppTextStyles.regularW500(
                                    context,
                                    size: 16,
                                    color: AppColors.red,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                      SizedBox(height: 11),
                      Text(
                        _scanFaceBloc.time ?? '',
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
                                      'Tháng ${_scanFaceBloc.month}',
                                      style: AppTextStyles.regularW500(
                                        context,
                                        size: 16,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                    SizedBox(height: 3),
                                    Text(
                                      _scanFaceBloc.day ?? '',
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
                                    _scanFaceBloc.nameShift ?? "",
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
                                    _scanFaceBloc.noteTimekeeping ?? "",
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
                      if (_scanFaceBloc.attendanceResults.value)
                        CustomButton(
                            onTap: () => AppRouter.backToPage(
                                  context,
                                  AppPages.Choose_A_Timekeeping,
                                ),
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
                                  AppRouter.backToPage(
                                    context,
                                    AppPages.Face_Timekeeping,
                                  );
                                  await Future.delayed(
                                      const Duration(seconds: 1));
                                  _timeKeepingAgain();
                                },
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    borderRadius: BorderRadius.circular(5)),
                                child: Text(
                                  'Chấm công lại',
                                  style: AppTextStyles.regularW700(
                                    context,
                                    size: 18,
                                    color: AppColors.white,
                                  ),
                                )),
                            SizedBox(height: 28),
                            CustomButton(
                                onTap: () {
                                  AppRouter.backToPage(
                                    context,
                                    AppPages.Choose_A_Timekeeping,
                                  );
                                },
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
          }));
}
