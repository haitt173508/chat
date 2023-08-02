import 'dart:async';
import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:animated_widgets/animated_widgets.dart';
import 'package:blur/blur.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:camera/camera.dart';
import 'package:chat_365/common/images.dart';
import 'package:chat_365/core/debouncer.dart';
import 'package:chat_365/core/interfaces/interface_user_info.dart';
import 'package:chat_365/core/theme/app_colors.dart';
import 'package:chat_365/core/theme/app_text_style.dart';
import 'package:chat_365/modules/call/phone_call/screens/main_phonevideo_screen.dart';
import 'package:chat_365/modules/call/phone_call/widgets/circle_button.dart';
import 'package:chat_365/modules/call/phone_call/widgets/small_noti.dart';
import 'package:chat_365/router/app_pages.dart';
import 'package:chat_365/router/app_router.dart';
import 'package:chat_365/utils/data/enums/position.dart';
import 'package:chat_365/utils/data/extensions/context_extension.dart';
import 'package:chat_365/utils/ui/app_padding.dart';
import 'package:chat_365/utils/ui/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';
import 'package:simple_ripple_animation/simple_ripple_animation.dart';

class PhoneVideoCome extends StatefulWidget {
  const PhoneVideoCome({
    Key? key,
    required this.userInfo,
  }) : super(key: key);

  @override
  State<PhoneVideoCome> createState() => _PhoneVideoComeState();
  final IUserInfo userInfo;

  static final String arugUserInfo = 'userInfo';
}

class _PhoneVideoComeState extends State<PhoneVideoCome>
    with SingleTickerProviderStateMixin {
  //*Của giao diện và chức năng người dùng
  bool useMic = true;
  bool useSpeakerphone = false;
  bool useCam = true;
  bool denidedCall = false;
  bool onConnect = true;

  //*Của giao diện và chức năng người liên hệ
  bool cusUseMic = false;
  bool cusUseCam = false;

  //*Của phần giao diện
  //Phần timer dùng trong đếm thời gian
  late Timer _timer;
  bool itNew = false;
  String timeCall = '';
  int minute = 0;
  int secon = 0;

  //*Của phần chức năng thêm
  bool showMore = false;
  bool splitScreen = false;
  int _counter = 0;
  late Uint8List _imageFile;

  // //Create an instance of ScreenshotController
  ScreenshotController screenshotController = ScreenshotController();

  //*Emoji và sticker
  bool expandEmo = false;
  bool showListEmo = false;
  int indexListSticker = 0;
  List<List<String>> listListSticker = [
    Images.listStickerCheer,
    Images.listStickerLove,
    Images.listStickerHappy
  ];
  bool showSticKer = false;
  String assStic = '';
  Timer? tShowSticker;
  Widget? flyingcart;
  final GlobalKey _key = GlobalKey();

  //*Phần camera
  late List<CameraDescription> cameras;
  CameraController? camcontroller;

  //*Khởi tạo cam
  void startCamera() async {
    cameras = await availableCameras();
    camcontroller = CameraController(cameras[1], ResolutionPreset.medium,
        enableAudio: useMic);
    await camcontroller!.initialize().then((value) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((e) {
      print(e);
    });
  }

  //*Bật tắt mic
  _turnMic() async {
    useMic = !useMic;
    final CameraController cameraController = CameraController(
        camcontroller!.description, ResolutionPreset.medium,
        enableAudio: useMic);
    camcontroller = cameraController;
    await camcontroller!.initialize().then((value) {
      if (!mounted) {
        return;
      }
      if (camcontroller != null) {
        if (!useCam) {
          camcontroller!.pausePreview();
        } else {
          camcontroller!.resumePreview();
        }
      }
      setState(() {});
    }).catchError((e) {
      print(e);
    });
  }

  //*Lật cam
  _rolCam() async {
    var newCam;
    if (camcontroller!.description == cameras[1])
      newCam = cameras[0];
    else {
      newCam = cameras[1];
    }
    final CameraController cameraController =
        CameraController(newCam, ResolutionPreset.medium, enableAudio: useMic);
    camcontroller = cameraController;
    await camcontroller!.initialize().then((value) {
      if (!mounted) {
        return;
      }
      if (camcontroller != null) {
        if (!useCam) {
          camcontroller!.pausePreview();
        } else {
          camcontroller!.resumePreview();
        }
      }
      setState(() {});
    }).catchError((e) {
      print(e);
    });
  }

  //*Bật tắt loa ngoài
  _turnSpeakerphone() {
    useSpeakerphone = !useSpeakerphone;
    setState(() {});
  }

  //*Bật tắt cam (dừng preview)
  _turnCam() {
    useCam = !useCam;
    if (camcontroller != null) {
      if (!useCam) {
        camcontroller!.pausePreview();
      } else {
        camcontroller!.resumePreview();
      }
    }
    //!Delay để không bị lỗi giao diện không nhận kịp
    //*Đã để tgian nhỏ tối đa.
    Debouncer(delay: Duration(milliseconds: 190)).call(() {
      setState(() {});
    });
  }

  //*Khi cả 2 đã liên kết
  _hadConnect() {
    onConnect = false;
    setState(() {});
  }

  //*Kết thúc cuộc gọi
  _endCall() {
    AppRouter.back(context);
  }

  //*Chia màn hiển thị cả 2
  _splitScreen() {
    splitScreen = !splitScreen;
    setState(() {});
  }

  //*Hiện phần chọn emo hay sticker
  _exandedEmoButton() {
    expandEmo = !expandEmo;
    showListEmo = !showListEmo;
    setState(() {});
  }

  //*Hiện danh sách sticker
  _showListEmo() {
    showListEmo = !showListEmo;
    setState(() {});
  }

  //*Khi thay đổi danh sách mới
  _changeShowListSticker(int index) {
    if (index > listListSticker.length - 1 || index < 0) index = 0;
    indexListSticker = index;
    setState(() {});
  }

  //*Chọn sticker
  _selectSticker(String assest) {
    if (tShowSticker != null) tShowSticker!.cancel();
    setState(() {
      showSticKer = true;
      assStic = assest;
    });
    tShowSticker = Timer(Duration(seconds: 4), () {
      setState(() {
        showSticKer = false;
      });
    });
  }

  //*Phần lấy vị trí cử nút trái tim (hoạt động không tốt)
  double? _x, _y;
  void _getOffset(GlobalKey key) {
    RenderBox? box = key.currentContext?.findRenderObject() as RenderBox?;
    Offset? position = box?.localToGlobal(Offset.zero);
    if (position != null) {
      setState(() {
        _x = position.dx;
        _y = position.dy;
      });
    }
  }

  //*Đếm thời gian cuộc gọi
  void _startTimer() {
    secon = 0;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        secon++;
        if (secon == 60) {
          minute++;
          secon = 0;
        }
        // if(_counter)
      });
    });
  }

  void _screenShot() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
      //add more permission to request here.
    ].request();
    if (statuses[Permission.storage]!.isGranted) {
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        await Permission.storage.request();
      }
    }
    var status = await Permission.storage.status;

    if (status.isGranted) {
      await screenshotController
          .capture(delay: const Duration(milliseconds: 10))
          .then((image) async {
        camcontroller!.pausePreview();
        if (image != null) {
          // final directory = await getApplicationDocumentsDirectory();
          final imagePath = File('/storage/emulated/0/Download/12.png');
          await imagePath.writeAsBytes(image, flush: true);
          final String fileName = '12.png';
          camcontroller!.resumePreview();

          await ImageGallerySaver.saveFile(
              '/storage/emulated/0/Download/12.png',
              name: fileName);
        }
      });
    }
  }

  @override
  void initState() {
    startCamera();
    super.initState();
  }

  OverlayEntry? entry;
  Offset offset = Offset(0 - 20, 60);
  @override
  void dispose() {
    camcontroller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Screenshot(
      controller: screenshotController,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        body: Stack(
          children: [
            //*Phần nền có avtar người dùng và phần hiển thị camera khi chia đôi
            Container(
              width: context.mediaQuerySize.width,
              height: context.mediaQuerySize.height,
              decoration: BoxDecoration(gradient: AppColors.blueGradients),
            ),

            Container(
              height: context.mediaQuerySize.height,
              width: context.mediaQuerySize.width,
              decoration:
                  BoxDecoration(color: AppColors.black.withOpacity(0.2)),
            ),

            //*Phần chức chức năng
            Container(
              height: context.mediaQuerySize.height,
              width: context.mediaQuerySize.width,
              padding: AppPadding.paddingHor15,
              decoration: BoxDecoration(color: Colors.transparent),
              child: Column(
                children: [
                  //Cho sát dưới app bar
                  SizedBox(
                    height: context.mediaQueryPadding.top + kToolbarHeight,
                  ),
                  Column(
                    children: [
                      SizedBox(
                        width: context.mediaQuerySize.width / 2.5,
                        height: context.mediaQuerySize.width / 2.5,
                        child: RippleAnimation(
                          repeat: true,
                          color: context.theme.backgroundColor,
                          minRadius: context.mediaQuerySize.width / 5,
                          ripplesCount: 6,
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(400),
                              child: CachedNetworkImage(
                                  fit: BoxFit.cover,
                                  imageUrl: widget.userInfo.avatar)),
                        ),
                      ),
                    ],
                  ),
                  Spacer(),

                  _smallNotis(),
                  SizedBoxExt.h16,
                  _buildCall(),
                  SizedBoxExt.h40,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  ///Những phần thông báo nhỏ
  Widget _smallNotis() {
    if (!(cusUseCam && cusUseCam))
      return SmallNoti(
        assestIcon: Images.ics_off_video_mic,
        widthIcon: null,
        title: '${widget.userInfo.name} đang tắt camera và tắt mic',
      );
    if (!cusUseCam)
      return SmallNoti(
        assestIcon: Images.ic_video_off,
        title: '${widget.userInfo.name} đang tắt cam',
      );
    if (!cusUseCam)
      return SmallNoti(
        assestIcon: Images.ic_mic_off,
        title: '${widget.userInfo.name} đang tắt mic',
      );

    return SizedBox();
  }

  ///Các chức năng còn lại
  Widget _buildCall() {
    return TranslationAnimatedWidget.tween(
        enabled: true,
        translationDisabled: Offset(0, 200),
        translationEnabled: Offset(0, 0),
        child: OpacityAnimatedWidget.tween(
          enabled: true,
          opacityDisabled: 0,
          opacityEnabled: 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            // mainAxisSize: MainAxisSize.min,
            children: [
              //*Từ chối
              CircleButton(
                onTap: () {
                  hidOverlay();
                  AppRouter.back(context);
                },
                name: 'Không',
                assestIcon: Images.ic_x,
                iconColor: AppColors.white,
                enable: false,
                enableBorder: false,
              ),

              //*Đồng ý mở camera
              CircleButton(
                onTap: () {
                  AppRouter.toPage(context, AppPages.Video_Call, arguments: {
                    MainPhoneVideoScreen.arugUserInfo: widget.userInfo
                  });
                  // showOverlay();
                },
                name: 'Đồng ý',
                assestIcon: Images.ic_video,
                enable: true,
                backgroundColor: AppColors.lima,
                enableBorder: false,
                enableShake: true,
              ),
            ],
          ),
        ));
  }

  showOverlay() {
    if (entry == null)
      entry = OverlayEntry(
        builder: (context) => Positioned(
          right: offset.dx,
          top: offset.dy,
          child: GestureDetector(
            onPanEnd: (details) {
              //Check cho chắc không có vẫn chạy được
              if (_key.currentContext != null &&
                  _key.currentContext!.size != null) {
                //*Bỏ tay khi đang di chuyển
                final double centerScreen = context.mediaQuerySize.width / 2 -
                    _key.currentContext!.size!.width / 2;

                //*Quá bên phải gán bên phải
                // if (offset.dx >= centerScreen) {
                // offset += Offset(
                //     context.mediaQuerySize.width -
                //         offset.dx -
                //         _key.currentContext!.size!.width +
                //         20,
                //     0);
                // }
                //*Quá bên trái gán bên trái
                // else if (offset.dx < centerScreen) {
                offset -= Offset(offset.dx + 20, 0);
                // }
                entry!.markNeedsBuild();
              }
            },
            onPanUpdate: (details) {
              //*Bắt đầu di chuyển
              offset += Offset(-details.delta.dx, details.delta.dy);

              entry!.markNeedsBuild();
            },
            child: Container(
              key: _key,
              width: 40 + 5 + 8 + 62 + 20,
              padding: AppPadding.paddingAll4,
              decoration: BoxDecoration(
                  gradient: context.theme.gradient,
                  borderRadius: BorderRadius.circular(100)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 40,
                    height: 40,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: CachedNetworkImage(
                        imageUrl: widget.userInfo.avatar,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBoxExt.w5,
                  Flexible(
                    child: Column(
                      children: [
                        Text(
                          widget.userInfo.name,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.regularW400(context,
                              size: 10, color: AppColors.white),
                        ),
                        Text(
                          '00:00',
                          style: AppTextStyles.regularW400(context,
                              size: 10, color: AppColors.white),
                        ),
                      ],
                    ),
                  ),
                  SizedBoxExt.w20,
                ],
              ),
            ),
          ),
        ),
      );
    final overlay = Overlay.of(context);
    overlay?.insert(entry!);
  }

  showOverlayCam() {
    if (entry == null)
      entry = OverlayEntry(
        builder: (context) => Positioned(
          right: offset.dx,
          top: offset.dy,
          child: GestureDetector(
            onPanEnd: (details) {
              //Check cho chắc không có vẫn chạy được
              if (_key.currentContext != null &&
                  _key.currentContext!.size != null) {
                //*Bỏ tay khi đang di chuyển
                final double centerScreen = context.mediaQuerySize.width / 2 -
                    _key.currentContext!.size!.width / 2;

                //*Quá bên phải gán bên phải
                // if (offset.dx >= centerScreen) {
                // offset += Offset(
                //     context.mediaQuerySize.width -
                //         offset.dx -
                //         _key.currentContext!.size!.width +
                //         20,
                //     0);
                // }
                //*Quá bên trái gán bên trái
                // else if (offset.dx < centerScreen) {
                offset -= Offset(offset.dx + 20, 0);
                // }
                entry!.markNeedsBuild();
              }
            },
            onPanUpdate: (details) {
              //*Bắt đầu di chuyển
              offset += Offset(-details.delta.dx, details.delta.dy);

              entry!.markNeedsBuild();
            },
            child: Container(
              width: context.mediaQuerySize.width / 3,
              height: context.mediaQuerySize.width / 2 + 20,
              child: Stack(children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Container(
                    width: context.mediaQuerySize.width / 2.5,
                    height: context.mediaQuerySize.width / 2,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  child: Container(
                    width: context.mediaQuerySize.width / 5,
                    height: context.mediaQuerySize.width / 4,
                    decoration: BoxDecoration(
                      color: AppColors.red,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ]),
            ),
          ),
        ),
      );
    final overlay = Overlay.of(context);
    overlay?.insert(entry!);
  }

  hidOverlay() {
    entry?.remove();
    entry = null;
  }
}
