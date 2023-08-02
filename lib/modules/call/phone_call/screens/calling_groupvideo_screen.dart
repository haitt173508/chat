// import 'package:flutter/material.dart';

// import '../../../../common/images.dart';

// class CallingGroupVideo extends StatefulWidget {
//   const CallingGroupVideo({Key? key}) : super(key: key);

//   @override
//   State<CallingGroupVideo> createState() => _CallingGroupVideoState();
// }

// class _CallingGroupVideoState extends State<CallingGroupVideo> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: BoxDecoration(
//             image: DecorationImage(
//                 image: AssetImage(Images.background_calling_test),
//                 fit: BoxFit.cover)),
//         child: Stack(children: []),
//       ),
//     );
//   }
// }
import 'dart:async';
import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:chat_365/common/images.dart';
import 'package:chat_365/core/theme/app_colors.dart';
import 'package:chat_365/core/theme/app_text_style.dart';
import 'package:chat_365/modules/call/phone_call/widgets/circle_button.dart';
import 'package:chat_365/router/app_router.dart';
import 'package:chat_365/utils/data/extensions/context_extension.dart';
import 'package:chat_365/utils/ui/app_padding.dart';
import 'package:chat_365/utils/ui/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../common/widgets/form/search_field.dart';
import '../../../../core/constants/string_constants.dart';
import '../widgets/cus_pop_item.dart';
import '../widgets/join_viedeocall_items.dart';

class CallingGroupVideo extends StatefulWidget {
  const CallingGroupVideo({Key? key}) : super(key: key);

  @override
  State<CallingGroupVideo> createState() => _CallingGroupVideoState();
}

class _CallingGroupVideoState extends State<CallingGroupVideo> {
  bool useMic = true;
  bool useSpeakerphone = false;
  bool useCam = false;

  bool cusUseMic = false;
  // da vao cuoc goi
  bool connected = true;
  bool denidedCall = false;
  String timeCall = '';
  int minute = 0;
  int secon = 0;
  double left = 34;
  bool splitScreen = false;
  bool viewOnly = false; // == false => xem nhieu nguoi , true xem 1 nguoi
  final TextEditingController _controller = TextEditingController();

  List<String> listAVT = [
    Images.img_profile_test_1,
    Images.img_profile_test_1,
    Images.img_profile_test_1,
    Images.img_profile_test_1,
    Images.img_profile_test_1,
    Images.img_profile_test_1,
    Images.img_profile_test_1
  ];
  List<int> statusList = [1, 0, 2, 0, 1, 0, 0, 2, 0, 2];
  late List<CameraDescription> cameras;
  CameraController? camcontroller;

  void startCamera() async {
    cameras = await availableCameras();
    camcontroller = CameraController(cameras[1], ResolutionPreset.medium,
        enableAudio: true);
    await camcontroller!.initialize().then((value) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((e) {
      print(e);
    });
  }

  _turnMic() {
    useMic = !useMic;
    setState(() {});
  }

  _turnSpeakerphone() {
    useSpeakerphone = !useSpeakerphone;
    setState(() {});
  }

  _turnCam() {
    useCam = !useCam;
    setState(() {});
  }

  _endCall() {
    AppRouter.back(context);
  }

  _splitScreen() {
    splitScreen = !splitScreen;
    setState(() {});
  }

  // int _counter = 0;
  late Timer _timer;
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

  addMem() async {
    await showModalBottomSheet(
        context: context,
        // useRootNavigator: false,
        isDismissible: true,
        // barrierColor: Colors.transparent,

        backgroundColor: AppColors.black.withOpacity(0.2),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (context) {
          return SingleChildScrollView(
            child: Stack(
              // alignment: Alg,
              children: [
                Container(
                  width: context.mediaQuerySize.width,
                  color: Colors.transparent,
                  padding: AppPadding.paddingAll20,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.5,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: AppPadding.paddingHor15Vert10,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextField(
                                      controller: _controller,
                                      decoration: InputDecoration(
                                        hintText: StringConst.searchName,
                                        prefixIconConstraints: BoxConstraints(
                                          maxHeight: 32,
                                          maxWidth: 32,
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          borderSide: BorderSide(
                                            color: context.theme.textColor,
                                          ),
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          borderSide: BorderSide(
                                            color: context.theme.textColor,
                                          ),
                                        ),
                                        prefixIcon: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
                                          child: InkWell(
                                            onTap: () {},
                                            child: const CustomPaint(
                                              size: Size.square(28),
                                              painter: SearchIconPainter(),
                                            ),
                                          ),
                                        ),
                                        fillColor: Colors.white,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Text(
                                      "Danh sách: 6",
                                      style: AppTextStyles.regularW400(context,
                                          size: 14, color: AppColors.gray),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Expanded(
                                flex: 8,
                                // physics: ScrollPhysics,
                                child: ListView.separated(
                                  // physics: BouncingScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return JoinVideoCallItems(
                                      status: statusList[index],
                                      isCheckBox: false,
                                    );
                                  },
                                  separatorBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          60, 10, 0, 10),
                                      child: Container(
                                        height: 1,
                                        color: AppColors.gray,
                                      ),
                                    );
                                  },
                                  itemCount: statusList.length,
                                ),
                              )
                            ]),
                      ),
                      SizedBoxExt.h30,
                      SizedBoxExt.h20,
                    ],
                  ),
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: GestureDetector(
                    onTap: () {
                      AppRouter.back(context);
                    },
                    child: Container(
                      padding: AppPadding.paddingAll15,
                      color: Colors.transparent,
                      child: SvgPicture.asset(Images.ic_x,
                          width: 16, color: AppColors.white),
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }

  @override
  void initState() {
    // camcontroller = CameraController(description, resolutionPreset);
    startCamera();
    // addMem();
    super.initState();
  }

  @override
  void dispose() {
    camcontroller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Row(
          children: [
            SizedBoxExt.w15,
            Align(
              child: GestureDetector(
                onTap: () {
                  AppRouter.back(context);
                },
                child: Container(
                  padding: AppPadding.paddingAll8,
                  decoration: BoxDecoration(
                      color: !connected
                          ? AppColors.buttonDisableCallScreenColor
                          : AppColors.buttonCallScreenColor,
                      borderRadius: BorderRadius.circular(50)),
                  child: SvgPicture.asset(
                    Images.ic_small_back,
                    color: !connected
                        ? AppColors.iconDisableCallScreenColor
                        : AppColors.iconCallScreenColor,
                  ),
                ),
              ),
            ),
          ],
        ),
        actions: [
          CircleButton(
            onTap: () {
              _rolCam();
              // addMem();
            },
            assestIcon: Images.ic_rol,
            widthIcon: 18,
            padding: AppPadding.paddingAll8,
            enable: true,
            enableBorder: false,
          ),
          SizedBoxExt.w15,
        ],
      ),
      body: Stack(
        children: [
          viewOnly || !connected
              ? Container(
                  height: context.mediaQuerySize.height,
                  width: context.mediaQuerySize.width,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                    image: AssetImage(Images.background_calling_test),
                    fit: BoxFit.cover,

                    // filterQuality: FilterQuality.high,
                  )),
                  child: !connected
                      ? BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.tundora.withOpacity(0.68),
                            ),
                          ),
                        )
                      : null,
                )
              : Container(
                  height: context.mediaQuerySize.height,
                  width: context.mediaQuerySize.width,
                  // color: Colors.amber,
                  child:
                      // StaggeredGridView.countBuilder(
                      //   crossAxisCount: 2,
                      //   mainAxisSpacing: 8,

                      //   reverse: false,
                      //   // physics: NeverScrollableScrollPhysics(),
                      //   // shrinkWrap: true,
                      //   staggeredTileBuilder: (index) =>
                      //       index % 2 == 0 && index == 6
                      //           ? StaggeredTile.count(2, 2)
                      //           : StaggeredTile.count(1, 2),
                      //   itemCount: 7,
                      //   itemBuilder: (context, builder) => Container(
                      //     alignment: Alignment.center,
                      //     decoration: BoxDecoration(
                      //         image: DecorationImage(
                      //       image: AssetImage(Images.background_calling_test),
                      //       fit: BoxFit.fitHeight,
                      //       // filterQuality: FilterQuality.high,
                      //     )),
                      //   ),
                      // )

                      Column(
                    children: [
                      Expanded(
                        child: Container(
                          child: Row(children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                  image: AssetImage(
                                      Images.background_calling_test),
                                  fit: BoxFit.fitHeight,

                                  // filterQuality: FilterQuality.high,
                                )),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                  image: AssetImage(
                                      Images.background_calling_test),
                                  fit: BoxFit.fitHeight,

                                  // filterQuality: FilterQuality.high,
                                )),
                              ),
                            )
                          ]),
                        ),
                      ),
                      Expanded(
                        child: SizedBox(
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  clipBehavior: Clip.hardEdge,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                    image: AssetImage(
                                        Images.background_calling_test),
                                    fit: BoxFit.fitHeight,

                                    // filterQuality: FilterQuality.high,
                                  )),
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(
                                        sigmaX: 10.0, sigmaY: 10.0),
                                    child: Container(
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color:
                                            AppColors.tundora.withOpacity(0.68),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  clipBehavior: Clip.hardEdge,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                    image: AssetImage(
                                        Images.background_calling_test),
                                    fit: BoxFit.fitHeight,

                                    // filterQuality: FilterQuality.high,
                                  )),
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(
                                        sigmaX: 10.0, sigmaY: 10.0),
                                    child: Container(
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color:
                                            AppColors.tundora.withOpacity(0.68),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
          // chua connect thi set backgroud mo di

          // Container(
          //   height: context.mediaQuerySize.height,
          //   width: context.mediaQuerySize.width,
          //   decoration: !connected
          //       ? BoxDecoration(color: AppColors.black.withOpacity(0.2))
          //       : null,
          // ),
          //*Phần chức năng
          //*Phần hiện camera người dùng
          viewOnly
              ? Positioned(
                  top: context.mediaQuerySize.height / 2,
                  right: 0,
                  child: Container(
                    width: context.mediaQuerySize.width / 3,
                    height: context.mediaQuerySize.width / 2,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.dustyGray,
                        width: 1,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: connected &&
                              camcontroller != null &&
                              camcontroller!.value.isInitialized
                          ? CameraPreview(
                              camcontroller!,
                            )
                          : SizedBox(),
                    ),
                  ),
                )
              : Container(),
          viewOnly
              ? Positioned(
                  right: 0,
                  top: context.mediaQuerySize.height * 0.17,
                  child: Container(
                      width: context.mediaQuerySize.width * 0.4,
                      padding: AppPadding.paddingAll8,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundImage:
                                  AssetImage(Images.img_profile_test_1),
                              radius: 25,
                            ),
                            SizedBox(width: 9),
                            CircleAvatar(
                              backgroundImage:
                                  AssetImage(Images.img_profile_test_1),
                              radius: 25,
                            ),
                            SizedBox(width: 9),
                            CircleAvatar(
                              backgroundImage:
                                  AssetImage(Images.img_profile_test_1),
                              radius: 25,
                            ),
                            SizedBox(width: 9),
                            CircleAvatar(
                              backgroundImage:
                                  AssetImage(Images.img_profile_test_1),
                              radius: 25,
                            ),
                            SizedBox(width: 9),
                            CircleAvatar(
                              backgroundImage:
                                  AssetImage(Images.img_profile_test_1),
                              radius: 25,
                            ),
                            SizedBox(width: 9),
                            CircleAvatar(
                              backgroundImage:
                                  AssetImage(Images.img_profile_test_1),
                              radius: 25,
                            ),
                            SizedBox(width: 9),
                          ],
                        ),
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.tundora.withOpacity(0.68),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(100),
                            bottomLeft: Radius.circular(100)),
                      )),
                )
              : Container(),
          Container(
            height: context.mediaQuerySize.height,
            width: context.mediaQuerySize.width,
            padding: AppPadding.paddingHor15,
            // decoration: BoxDecoration(color: Colors.transparent),
            child: Column(
              children: [
                SizedBoxExt.h70,
                SizedBoxExt.h70,
                Container(
                  height: context.mediaQuerySize.height * 0.1,
                  width: 60.0 +
                      34.0 * (listAVT.length > 4 ? 4.0 : (listAVT.length)),
                  child: Stack(
                      alignment: AlignmentDirectional.topCenter,
                      children: !connected
                          ? (listAVT.length < 5
                              ? List.generate(
                                  listAVT.length,
                                  (index) => _avatarJoining(
                                      imgLink: listAVT[index],
                                      postionLeft: 34.0 * index),
                                )
                              : List.generate(
                                  4,
                                  (index) => _avatarJoining(
                                      imgLink: listAVT[index],
                                      postionLeft: 34.0 * index),
                                )
                            ..add(Positioned(
                              left: 4 * 34.0,
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 30,
                                child: Text(
                                  "3+",
                                  style: AppTextStyles.regularW400(context,
                                      size: 14, color: AppColors.tundora),
                                ),
                              ),
                            )))
                          : []

                      // if (!connected)
                      //   Container(
                      //     // width: context.mediaQuerySize.width / 3,
                      //     height: context.mediaQuerySize.width / 2,
                      //     child: Align(
                      //       alignment: Alignment.topCenter,
                      //       child: Text(
                      //         '${NumberFormat('00').format(minute)}:${NumberFormat('00').format(secon)}',
                      //         style: AppTextStyles.regularW400(context,
                      //             size: 14, color: AppColors.lawnGreen),
                      //       ),
                      //     ),
                      //   ),
                      ),
                ),
                !connected
                    ? Container(
                        child: Column(
                          children: [
                            Text(
                              "HHP Member",
                              style: AppTextStyles.regularW700(context,
                                  size: 15, color: AppColors.white),
                            ),
                            Text(
                              "\nĐang đổ chuông",
                              style: AppTextStyles.regularW400(context,
                                  size: 14, color: AppColors.white),
                            ),
                          ],
                        ),
                      )
                    : Container(),
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
    );
  }

  Widget _avatarJoining(
      {required double postionLeft, required String imgLink}) {
    return Positioned(
      left: postionLeft,
      child: CircleAvatar(
        radius: 30,
        backgroundImage: AssetImage(
          imgLink,
        ),
      ),
    );
  }

  Widget _smallNotis() {
    if (!useCam)
      return Container(
        padding: AppPadding.paddingHor12Vert5,
        margin: EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
            color: AppColors.buttonCallScreenColor,
            borderRadius: BorderRadius.circular(100)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              Images.ic_mic_off,
              width: 16,
              color: AppColors.iconCallScreenColor,
            ),
            SizedBoxExt.w5,
            Text(
              'Bạn đang tắt mic',
              style: AppTextStyles.regularW400(context,
                  size: 14, color: AppColors.white),
            ),
          ],
        ),
      );
    return SizedBox();
  }

  Widget _buildCall() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      // mainAxisSize: MainAxisSize.min,
      children: [
        //*Tắt bật cam
        CircleButton(
          onTap: () {
            _turnCam();
          },
          name: 'Camera',
          assestIcon: useCam ? Images.ic_video : Images.ic_video_off,
          enable: true,
          backgroundColor: useCam ? null : AppColors.white,
          iconColor: useCam ? null : AppColors.text,
        ),

        //*Tắt bật mic
        CircleButton(
          onTap: () {
            // if (connected)
            _turnMic();
          },
          name: 'Mic',
          assestIcon: useMic ? Images.ic_mic : Images.ic_mic_off,
          enable: true,
          backgroundColor: useMic ? null : AppColors.white,
          iconColor: useMic ? null : AppColors.text,
        ),
        //*Kết thúc cuộc gọi
        CircleButton(
          onTap: () {
            AppRouter.back(context);
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
              offset: Offset(0, -150),
              color: AppColors.white.withOpacity(0.86),
              padding: EdgeInsets.all(10),
              onSelected: (value) async {
                if (value == 0) {
                  // _splitScreen();
                  addMem();
                }
                if (value == 1) {}
                if (value == 2) {
                  setState(() {
                    viewOnly = !viewOnly;
                  });
                }
                if (value == 3) {
                  _turnSpeakerphone();
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                CusPopItem.getPopupMenuItem(
                  value: 0,
                  iconAsset: Images.ic_additionalMember,
                  title: 'Mời thêm',
                ),
                CusPopItem.getPopupMenuItem(
                    value: 1,
                    iconAsset: Images.ic_share_screen,
                    title: 'Chia sẻ màn hình'),
                CusPopItem.getPopupMenuItem(
                    value: 2,
                    iconAsset: Images.ic_view_one,
                    title: 'Xem một người'),
                CusPopItem.getPopupMenuItem(
                    value: 3,
                    iconAsset: useSpeakerphone
                        ? Images.ic_speakerphone
                        : Images.ic_speaker_off,
                    title: 'Loa',
                    underLine: false),
              ],
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
    );
  }
}
