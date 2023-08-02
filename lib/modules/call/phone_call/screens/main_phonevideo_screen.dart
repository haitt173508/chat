import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:animated_widgets/animated_widgets.dart';
import 'package:blur/blur.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:camera/camera.dart';
import 'package:chat_365/common/images.dart';
import 'package:chat_365/core/interfaces/interface_user_info.dart';
import 'package:chat_365/core/theme/app_colors.dart';
import 'package:chat_365/core/theme/app_text_style.dart';
import 'package:chat_365/modules/auth/repo/auth_repo.dart';
import 'package:chat_365/modules/call/phone_call/screens/fly.dart';
import 'package:chat_365/modules/call/phone_call/widgets/button_border_index.dart';
import 'package:chat_365/modules/call/phone_call/widgets/circle_button.dart';
import 'package:chat_365/modules/call/phone_call/widgets/cus_pop_item.dart';
import 'package:chat_365/modules/call/phone_call/widgets/small_noti.dart';
import 'package:chat_365/router/app_router.dart';
import 'package:chat_365/utils/data/clients/interceptors/call_client.dart';
import 'package:chat_365/utils/data/extensions/context_extension.dart';
import 'package:chat_365/utils/ui/app_padding.dart';
import 'package:chat_365/utils/ui/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';

import '../../../../data/services/signaling_service/signaling_service.dart';

class MainPhoneVideoScreen extends StatefulWidget {
  MainPhoneVideoScreen({
    Key? key,
    required this.userInfo,
    required this.idCaller,
    required this.idCallee,
    required this.idConversation,
    required this.idRoom,
    this.checkCallee = false,
  }) : super(key: key);

  @override
  State<MainPhoneVideoScreen> createState() => _MainPhoneVideoScreenState();
  final IUserInfo userInfo;
  final String idCaller;
  final List<int> idCallee;
  final String idConversation;
  final String idRoom;

  //check ai là người nhận cuộc gọi
  final bool checkCallee;

  static final String arugUserInfo = 'userInfo';
}

class _MainPhoneVideoScreenState extends State<MainPhoneVideoScreen>
    with SingleTickerProviderStateMixin {
  // Signaling? signaling;
  RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
  bool _inCalling = false;
  bool _checkCallee = false;

  bool _waitAccept = false;

  // ignore: unused_element
  _CallSampleState() {
    // TODO: implement _CallSampleState
    throw UnimplementedError();
  }

  @override
  initState() {
    super.initState();
    initRenderers();
    _countDisapear();
    _connect();
    onTurnCamMic();
    _checkCallee = widget.checkCallee;
    //
    if (widget.checkCallee == true) {
      // try {
      //   signaling.joinRoom(widget.idRoom);
      // } catch (e, s) {
      //   print(s);
      // }
      setState(() {
        cusUseCam = false;
      });
    }
  }

  initRenderers() async {
    await _localRenderer.initialize();
    await _remoteRenderer.initialize();
  }

  void _connect() async {
    if (widget.checkCallee == false)
      signaling
        ..connect(widget.idCallee, widget.idCaller, widget.idConversation);

    signaling.onSignalingStateChange = (SignalingState state) {
      switch (state) {
        case SignalingState.ConnectionClosed:
        case SignalingState.ConnectionError:
        case SignalingState.ConnectionOpen:
          break;
      }
    };
    signaling.onCallStateChange = (CallState state) async {
      switch (state) {
        case CallState.CallStateNew:
          setState(() {});
          break;
        case CallState.CallStateRinging:
          setState(() {
            _inCalling = true;
          });
          break;
        case CallState.CallStateBye:
          if (_waitAccept) {
            print('peer reject');
            _waitAccept = false;
            Navigator.of(context).pop(false);
          }
          setState(() {
            _localRenderer.srcObject = null;
            _remoteRenderer.srcObject = null;
            _inCalling = false;
          });
          break;
        case CallState.CallStateInvite:
          _waitAccept = true;
          // _showInvateDialog();
          break;
        case CallState.CallStateConnected:
          if (_waitAccept) {
            _waitAccept = false;
            Navigator.of(context).pop(false);
          }
          setState(() {
            _inCalling = true;
          });

          break;
        case CallState.CallStateRinging:
      }
    };

    signaling.onLocalStream = ((stream) {
      _localRenderer.srcObject = stream;
      setState(() {
        cusUseCam = true;
      });
    });

    signaling.onAddRemoteStream = ((stream) {
      print('streammmmmm $stream');
      _remoteRenderer.srcObject = stream;
      // _remoteRenderer.addListener(() { })
      setState(() {
        checkRemotenable = true;
      });
      if (_remoteRenderer.srcObject != null) _hadConnect();
    });

    signaling.onRemoveRemoteStream = ((stream) {
      _remoteRenderer.srcObject = null;
    });
  }

  //
  _invitePeer(BuildContext context, String peerId, bool useScreen) async {
    signaling.invite();
  }

  //các hàm chức năng
  _accept() {
    signaling.accept(widget.idRoom);
  }

  _reject() {
    signaling.reject(widget.idCaller);
  }

  _hangUp() {
    signaling.bye(widget.idCaller);
  }

  _switchCamera() {
    signaling.switchCamera();
  }

  _muteMic() {
    signaling.turnCamAudio(widget.idRoom, false);
  }

  //check lắng nghe bên kia từ chối hoặc kết thúc cuộc gọi
  // _checkReject(BuildContext context) {}

  @override
  deactivate() {
    super.deactivate();
    signaling.close();
    _localRenderer.dispose();
    _remoteRenderer.dispose();
  }

  //*Của giao diện và chức năng người dùng
  bool useSpeakerphone = false;
  bool denidedCall = false;
  bool onConnect = true;
  // bool turnCamCall = true;
  bool checkRemotenable = false;

  //*Của giao diện và chức năng người liên hệ
  bool cusUseMic = true;
  bool cusUseCam = true;

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
  bool onChangingMic = false;

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

  bool showFunction = true;

  //*Phần camera
  late List<CameraDescription> cameras;
  CameraController? camcontroller;

  //
  onTurnCamMic() {
    callClient.on('notificationCamMic', (response) {
      var socketId = response['socket'];
      checkRemotenable = response['cam'];
      if (response['cam'] == false)
        setState(() {
          checkRemotenable = false;
        });
      cusUseMic = response['userId'];
    });
  }

  _countDisapear([int? seconds]) {
    timerHideButton?.cancel();
    showFunction = true;
    timerHideButton = Timer(Duration(seconds: seconds ?? 5), () {
      setState(() {
        showFunction = false;
      });
    });
  }

  //*Bật tắt loa ngoài
  _turnSpeakerphone() {
    _countDisapear();
    useSpeakerphone = !useSpeakerphone;
    setState(() {});
  }

  //*Khi cả 2 đã liên kết
  _hadConnect() {
    _startTimer();
    setState(() {});
  }

  //*Kết thúc cuộc gọi
  _endCall() {
    AppRouter.back(context);
  }

  //*Chia màn hiển thị cả 2
  _splitScreen() {
    _countDisapear();
    splitScreen = !splitScreen;
    setState(() {});
  }

  //*Hiện phần chọn emo hay sticker
  _exandedEmoButton() {
    _countDisapear();
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
        // if(_counter)
      });
      if (secon == 60) {
        minute++;
        setState(() {
          secon = 0;
        });
      }
      _timer.cancel();
    });
  }

  void _screenShot() async {
    _countDisapear();
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

  Timer? timerHideButton;

  @override
  void dispose() {
    camcontroller?.dispose();
    _timer.cancel();
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
              child: Column(
                children: [
                  if (splitScreen)
                    Expanded(
                      child: ClipRect(
                        child: Align(
                          heightFactor: 1 / 2,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              //phần camera của mình
                              _camera(),
                              Positioned(
                                  bottom: 40,
                                  child: Padding(
                                      padding: AppPadding.paddingHor15,
                                      child: _smallNotisUser())),
                            ],
                          ),
                        ),
                      ),
                    ),
                  //cam của đối phương
                  Expanded(
                    child: checkRemotenable == false
                        ? Blur(
                            blur: cusUseCam ? 0 : 5.5,
                            child: Container(
                              width: context.mediaQuerySize.width,
                              height: splitScreen
                                  ? context.mediaQuerySize.height / 2
                                  : context.mediaQuerySize.height,
                              child: widget.userInfo.avatar is String
                                  ? CachedNetworkImage(
                                      imageUrl: widget.userInfo.avatar,
                                      fit: BoxFit.cover,
                                    )
                                  : widget.userInfo.avatar is List<int>
                                      ? Image.memory(
                                          widget.userInfo.avatar,
                                          fit: BoxFit.cover,
                                        )
                                      : Image.asset(
                                          Images.img_non_avatar,
                                          fit: BoxFit.cover,
                                        ),
                            ),
                          )
                        : Container(
                            width: double.infinity,
                            height: splitScreen
                                ? context.mediaQuerySize.height / 2
                                : double.infinity,
                            child: Transform.scale(
                              scale: 1,
                              child: Center(
                                child: RTCVideoView(
                                  _remoteRenderer,
                                  objectFit: RTCVideoViewObjectFit
                                      .RTCVideoViewObjectFitCover,
                                  mirror: true,
                                  filterQuality: FilterQuality.medium,
                                ),
                              ),
                            )),
                  ),
                ],
              ),
            ),

            //*Opacity tối khi không còn liên lạc được
            if (!onConnect || !cusUseCam)
              Container(
                height: context.mediaQuerySize.height,
                width: context.mediaQuerySize.width,
                decoration:
                    BoxDecoration(color: AppColors.black.withOpacity(0.2)),
              ),

            //*Phần hiện icon
            Positioned(
              bottom: _y != null
                  ? MediaQuery.of(context).size.height - _y! - 120
                  : MediaQuery.of(context).size.height,
              right: 0,
              left: 0,
              // right: _x,
              child: _buildFlyIcon(),
            ),

            //*Phần hiện sticker
            Positioned(
              right: 0,
              left: 0,
              top: 0,
              bottom: 0,
              child: _buildShowStiker(),
            ),

            //*Phần hiện camera
            if (cusUseCam)
              Positioned(
                top: 0,
                right: 0,
                left: 0,
                child: Padding(
                  padding: AppPadding.paddingHor15,
                  child: Column(children: [
                    SizedBox(
                      height: context.mediaQueryPadding.top + kToolbarHeight,
                    ),
                    _centerContact(),
                  ]),
                ),
              ),
            // if (showFunction == false)
            GestureDetector(
              onTap: () {
                timerHideButton?.cancel();
                setState(() {
                  if (showFunction == false) {
                    showFunction = true;
                    timerHideButton = Timer(Duration(seconds: 3), () {
                      setState(() {
                        showFunction = false;
                      });
                    });
                  } else {
                    showFunction = false;
                  }
                });
              },
              child: Container(
                color: Colors.transparent,
                width: context.mediaQuerySize.width,
                height: context.mediaQuerySize.height,
              ),
            ),
            if (expandEmo)
              GestureDetector(
                onTap: () {
                  timerHideButton?.cancel();
                  setState(() {
                    expandEmo = false;
                    showListEmo = false;
                    timerHideButton?.cancel();
                    showFunction = true;
                    timerHideButton = Timer(Duration(seconds: 3), () {
                      setState(() {
                        showFunction = false;
                      });
                    });
                  });
                },
                child: Container(
                  color: Colors.transparent,
                  width: context.mediaQuerySize.width,
                  height: context.mediaQuerySize.height,
                ),
              ),
            //*Phần app bar
            _buildAppBar(),

            //*Phần nút các chức năng
            Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              child: Padding(
                padding: AppPadding.paddingHor15,
                child: Column(children: [
                  _buildButtonEmoji(),
                  SizedBoxExt.h10,
                  _smallNotis(),
                  SizedBoxExt.h16,
                  showListEmo ? _buildListSticker() : _buildCall(),
                  SizedBoxExt.h40,
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return //*Phần app bar
        Positioned(
      top: 0,
      right: 0,
      left: 0,
      child: TranslationAnimatedWidget.tween(
        enabled: showFunction,
        duration: Duration(milliseconds: 400),
        translationDisabled: Offset(0, -200),
        translationEnabled: Offset(0, 0),
        child: OpacityAnimatedWidget.tween(
          enabled: showFunction,
          duration: Duration(milliseconds: 600),
          opacityDisabled: 0,
          opacityEnabled: 1,
          child: Padding(
            padding: AppPadding.paddingHor15Vert10
                .copyWith(top: context.mediaQueryPadding.top + 10),
            child: Row(
              children: [
                CircleButton(
                  onTap: () {
                    AppRouter.back(context);
                  },
                  assestIcon: Images.ic_small_back,
                  widthIcon: 18,
                  padding: AppPadding.paddingAll8,
                  enable: onConnect,
                  enableBorder: false,
                ),
                Expanded(
                  child: Text(
                    'Chat365',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.regularW700(context,
                        size: 18, color: AppColors.white),
                  ),
                ),
                CircleButton(
                  onTap: () {
                    _switchCamera();
                  },
                  assestIcon: Images.ic_rol,
                  widthIcon: 18,
                  padding: AppPadding.paddingAll8,
                  enable: onConnect,
                  enableBorder: false,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ///Phần icon bay
  Widget _buildFlyIcon() {
    return Container(
      width: MediaQuery.of(context).size.width / 1.5,
      height: _y != null ? _y! : MediaQuery.of(context).size.height,
      child: flyingcart == null ? Container() : flyingcart,
    );
  }

  //Phần hiện sticker
  Widget _buildShowStiker() {
    return AnimatedOpacity(
      opacity: !showSticKer ? 0 : 1,
      curve: Curves.easeInOut,
      duration: Duration(milliseconds: 500),
      child: Align(
        child: SizedBox(
          width: 200,
          height: 200,
          child: assStic.isNotEmpty ? Image.asset(assStic) : SizedBox(),
        ),
      ),
    );
  }

  ///Phần camera người dùng caller
  Widget _camera() {
    double scaleValue = 1;
    if (_localRenderer.value.renderVideo == true) {
      scaleValue = _localRenderer.value.aspectRatio /
          (context.mediaQuerySize.width / context.mediaQuerySize.height * 2);
    }
    return Stack(
      children: [
        // *Phần avatar
        if (checkRemotenable == false)
          Blur(
            blur: cusUseMic ? 5.5 : 0,
            child: Container(
              width: double.infinity,
              height: splitScreen
                  ? context.mediaQuerySize.height / 2
                  : double.infinity,
              child: CachedNetworkImage(
                imageUrl: context.read<AuthRepo>().userInfo!.avatar,
                fit: BoxFit.cover,
              ),
            ),
          ),

        //*Phần cam
        if (onConnect == true)
          Container(
              width: double.infinity,
              height: splitScreen
                  ? context.mediaQuerySize.height / 2
                  : double.infinity,
              child: Transform.scale(
                scale: 1,
                child: Center(
                  child: RTCVideoView(
                    _localRenderer,
                    objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                    mirror: true,
                    filterQuality: FilterQuality.medium,
                  ),
                ),
              ))
      ],
    );
  }

  ///Những phần chức năng hiện thị chính giữa
  Widget _centerContact() {
    return Stack(
      children: [
        //*Phần hiện camera người dùng
        if (!splitScreen)
          Positioned(
            right: 0,
            child: Container(
              width: context.mediaQuerySize.width / 3,
              height: context.mediaQuerySize.width / 2,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.dustyGray,
                  width: 1,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Stack(
                  children: [
                    _camera(),
                    Positioned(
                      bottom: 8,
                      right: 0,
                      left: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        // mainAxisSize: MainAxisSize.max,
                        children: [
                          if (!cusUseCam)
                            SvgPicture.asset(
                              Images.ic_video_off,
                              width: 16,
                              color: AppColors.white,
                            ),
                          if (!cusUseMic)
                            Padding(
                              padding: const EdgeInsets.only(left: 4),
                              child: SvgPicture.asset(
                                Images.ic_mic_off,
                                width: 16,
                                color: AppColors.white,
                              ),
                            )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),

        //*Phần tính giờ
        if (onConnect)
          Container(
            // width: context.mediaQuerySize.width / 3,
            height: context.mediaQuerySize.width / 2,
            child: Align(
              alignment: Alignment.topCenter,
              child: Text(
                '${NumberFormat('00').format(minute)}:${NumberFormat('00').format(secon)}',
                style: AppTextStyles.regularW400(context,
                    size: 14, color: AppColors.lawnGreen),
              ),
            ),
          ),
      ],
    );
  }

  ///Các phần nút emoji
  Widget _buildButtonEmoji() {
    return Align(
      alignment: Alignment.bottomRight,
      child: !expandEmo
          ? CircleButton(
              onTap: () {
                _exandedEmoButton();
              },
              assestIcon: Images.ic_star,
              iconColor: AppColors.white,
              enable: true,
              widthIcon: 16,
              padding: AppPadding.paddingAll8,
            )
          : Column(children: [
              CircleButton(
                onTap: () {
                  _screenShot();
                },
                assestIcon: Images.ic_camera_small,
                iconColor: AppColors.white,
                enable: true,
                widthIcon: 16,
                padding: AppPadding.paddingAll8,
              ),
              SizedBoxExt.h12,
              GestureDetector(
                key: _key,
                onTap: () {
                  _showListEmo();
                },
                child: Container(
                  padding: AppPadding.paddingAll8,
                  decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(color: AppColors.dustyGray, width: 1)),
                  child: SvgPicture.asset(
                    Images.ic_smile,
                    width: 16,
                  ),
                ),
              ),
              SizedBoxExt.h12,
              GestureDetector(
                onTap: () {
                  setState(() {
                    _getOffset(_key);
                  });
                  setState(() {
                    if (flyingcart != null) itNew = true;
                    flyingcart = Flyingcart();
                    if (!itNew)
                      Future.delayed(Duration(seconds: 1), () {
                        setState(() {
                          flyingcart = null;
                          //hide flycart and add number
                          itNew = false;
                        });
                      });
                    //wait 2 second
                  });
                },
                child: Container(
                  padding: AppPadding.paddingAll8,
                  decoration: BoxDecoration(
                      color: AppColors.buttonCallScreenColor,
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(color: AppColors.dustyGray, width: 1)),
                  child: SvgPicture.asset(
                    Images.ic_heart,
                    width: 16,
                  ),
                ),
              ),
            ]),
    );
  }

  ///Những phần thông báo nhỏ
  Widget _smallNotis() {
    if (cusUseCam == false && cusUseMic == false) {
      return TranslationAnimatedWidget.tween(
          enabled: showFunction,
          duration: Duration(milliseconds: 400),
          translationDisabled: Offset(0, 100),
          translationEnabled: Offset(0, 0),
          child: SmallNoti(
            assestIcon: Images.ics_off_video_mic,
            widthIcon: null,
            title: '${widget.userInfo.name} đang tắt camera và tắt mic',
          ));
    }
    if (cusUseCam == false) {
      return TranslationAnimatedWidget.tween(
        enabled: showFunction,
        duration: Duration(milliseconds: 400),
        translationDisabled: Offset(0, 100),
        translationEnabled: Offset(0, 0),
        child: SmallNoti(
          assestIcon: Images.ic_video_off,
          title: '${widget.userInfo.name} đang tắt cam',
        ),
      );
    }
    if (cusUseCam == false) {
      return TranslationAnimatedWidget.tween(
        enabled: showFunction,
        duration: Duration(milliseconds: 400),
        translationDisabled: Offset(0, 100),
        translationEnabled: Offset(0, 0),
        child: SmallNoti(
          assestIcon: Images.ic_mic_off,
          title: '${widget.userInfo.name} đang tắt mic',
        ),
      );
    }

    return SizedBox();
  }

  ///Những phần thông báo nhỏ
  Widget _smallNotisUser() {
    if (cusUseCam == false && cusUseMic == false) {
      return SmallNoti(
        assestIcon: Images.ics_off_video_mic,
        widthIcon: null,
        title:
            '${context.read<AuthRepo>().userName} đang tắt camera và tắt mic',
      );
    }
    if (cusUseCam == false)
      return SmallNoti(
        assestIcon: Images.ic_video_off,
        title: '${context.read<AuthRepo>().userName} đang tắt cam',
      );
    if (cusUseMic == false)
      return SmallNoti(
        assestIcon: Images.ic_mic_off,
        title: '${context.read<AuthRepo>().userName} đang tắt mic',
      );

    return SizedBox();
  }

  ///Các chức năng còn lại(các chức năng liên quan đến từ chối gọi,bật tắt stream)
  Widget _buildCall() {
    return TranslationAnimatedWidget.tween(
      enabled: showFunction,
      duration: Duration(milliseconds: 400),
      translationDisabled: Offset(0, 200),
      translationEnabled: Offset(0, 0),
      child: OpacityAnimatedWidget.tween(
        enabled: showFunction,
        duration: Duration(milliseconds: 400),
        opacityDisabled: 0,
        opacityEnabled: 1,
        child: _checkCallee
            ? Padding(
                padding: const EdgeInsets.only(left: 30, right: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //*Từ chối cuộc gọi
                    CircleButton(
                      onTap: () {
                        _reject();
                        AppRouter.back(context);
                      },
                      name: 'Không',
                      assestIcon: Images.ic_hang_up,
                      enable: true,
                      backgroundColor: AppColors.red,
                    ),
                    //*Chấp nhận cuộc gọi
                    CircleButton(
                      onTap: () {
                        _accept();
                        setState(() {
                          //set lại biến check trạng thái để chuyển thành các nút chức năng
                          _checkCallee = false;
                          cusUseCam = true;
                        });
                      },
                      name: 'Đồng ý',
                      assestIcon: Images.ic_hang_up,
                      enable: true,
                      backgroundColor: AppColors.active,
                    ),
                  ],
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                // mainAxisSize: MainAxisSize.min,
                children: [
                  //*Tắt bật cam
                  CircleButton(
                    onTap: () {
                      // _turnCam();
                      signaling.turnCamAudio(widget.idRoom, true);
                      setState(() {
                        cusUseCam = !cusUseCam;
                      });
                    },
                    name: 'Camera',
                    assestIcon:
                        cusUseCam ? Images.ic_video : Images.ic_video_off,
                    enable: true,
                    backgroundColor: cusUseCam ? null : AppColors.white,
                    iconColor: cusUseCam ? null : AppColors.text,
                  ),

                  //*Tắt bật mic
                  CircleButton(
                    onTap: () {
                      // if (!onConnect)
                      // _turnMic();
                      _muteMic();
                      setState(() {
                        cusUseMic = !cusUseMic;
                      });
                    },
                    name: 'Mic',
                    assestIcon:
                        cusUseMic == true ? Images.ic_mic : Images.ic_mic_off,
                    enable: true,
                    backgroundColor: cusUseMic == true ? null : AppColors.white,
                    iconColor: cusUseMic == true ? null : AppColors.text,
                  ),
                  //*Kết thúc cuộc gọi
                  CircleButton(
                    onTap: () {
                      signaling.bye(widget.idRoom);
                      AppRouter.back(context);
                      setState(() {
                        _timer.cancel();
                      });
                    },
                    name: 'Kết thúc',
                    assestIcon: Images.ic_hang_up,
                    enable: true,
                    backgroundColor: AppColors.red,
                  ),
                  //*Thêm chức năng
                  Stack(
                    children: [
                      CircleButton(
                        onTap: () {
                          // setState(() {
                          //   showMore = !showMore;
                          // });
                        },
                        name: 'Thêm',
                        assestIcon: Images.ic_more_hoz,
                        enable: true,
                      ),
                      PopupMenuButton(
                        offset: Offset(0, -100),
                        color: AppColors.white.withOpacity(0.86),
                        padding: EdgeInsets.zero,
                        onCanceled: () {
                          _countDisapear();
                        },
                        onSelected: (value) async {
                          if (value == 0) {
                            _splitScreen();
                            _countDisapear();
                          }

                          if (value == 1) {
                            _turnSpeakerphone();
                            _countDisapear();
                          }
                        },
                        itemBuilder: (BuildContext context) {
                          _countDisapear(999999999999999999);
                          return <PopupMenuEntry>[
                            CusPopItem.getPopupMenuItem(
                                value: 0,
                                iconAsset: splitScreen
                                    ? Images.ic_full_screen
                                    : Images.ic_split_screen,
                                title: splitScreen ? 'Toàn cảnh' : 'Chia đôi'),
                            CusPopItem.getPopupMenuItem(
                                value: 1,
                                iconAsset: useSpeakerphone
                                    ? Images.ic_speakerphone
                                    : Images.ic_speaker_off,
                                title: 'Loa',
                                underLine: false),
                          ];
                        },
                        child: Align(
                          child: Container(
                            width: 60,
                            height: 60,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }

  ///Phần danh sách sticker
  Widget _buildListSticker() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Image.asset(Imges.qr)
            for (String item in listListSticker[indexListSticker])
              GestureDetector(
                onTap: () {
                  _selectSticker(item);
                },
                child: Image.asset(
                  item,
                  width: context.mediaQuerySize.width /
                          Images.listStickerCheer.length -
                      20,
                ),
              )
          ],
        ),
        SizedBoxExt.h18,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ButtonBorderIndex(
              onPressed: () {
                _changeShowListSticker(0);
              },
              enable: indexListSticker == 0,
              width: context.mediaQuerySize.width / 3 - 25,
              title: 'Cổ vũ',
            ),
            ButtonBorderIndex(
              onPressed: () {
                _changeShowListSticker(1);
              },
              enable: indexListSticker == 1,
              width: context.mediaQuerySize.width / 3 - 25,
              title: 'Yêu',
            ),
            ButtonBorderIndex(
              onPressed: () {
                _changeShowListSticker(2);
              },
              enable: indexListSticker == 2,
              width: context.mediaQuerySize.width / 3 - 25,
              title: 'Vui',
            )
          ],
        ),
      ],
    );
  }
}
