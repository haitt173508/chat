import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_365/common/images.dart';
import 'package:chat_365/core/interfaces/interface_user_info.dart';
import 'package:chat_365/core/theme/app_colors.dart';
import 'package:chat_365/core/theme/app_text_style.dart';
import 'package:chat_365/modules/call/phone_call/screens/main_phonevideo_screen.dart';
import 'package:chat_365/modules/call/phone_call/widgets/circle_button.dart';
import 'package:chat_365/modules/call/phone_call/widgets/small_noti.dart';
import 'package:chat_365/router/app_pages.dart';
import 'package:chat_365/router/app_router.dart';
import 'package:chat_365/utils/data/extensions/context_extension.dart';
import 'package:chat_365/utils/ui/app_padding.dart';
import 'package:chat_365/utils/ui/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:simple_ripple_animation/simple_ripple_animation.dart';

class MainPhoneCallScreen extends StatefulWidget {
  const MainPhoneCallScreen({Key? key, required this.userInfo})
      : super(key: key);

  @override
  State<MainPhoneCallScreen> createState() => _MainPhoneCallScreenState();
  final IUserInfo userInfo;

  static final String arugUserInfo = 'userInfo';
}

class _MainPhoneCallScreenState extends State<MainPhoneCallScreen> {
  bool useMic = true;
  bool useSpeakerphone = false;
  bool isOnConnect = false;
  bool denidedCall = false;
  String timeCall = '';
  int minute = 0;
  int secon = 0;

  _turnMic() {
    useMic = !useMic;
    setState(() {});
  }

  _turnSpeakerphone() {
    useSpeakerphone = !useSpeakerphone;
    setState(() {});
  }

  _hadConnect() {
    isOnConnect = false;
    setState(() {});
  }

  _endCall() {
    AppRouter.back(context);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Chat365',
          style: AppTextStyles.regularW700(context,
              size: 18, color: AppColors.white),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 15.0),
          child: CircleButton(
            onTap: () {
              if (isOnConnect) AppRouter.back(context);
            },
            assestIcon: Images.ic_small_back,
            widthIcon: 18,
            padding: AppPadding.paddingAll8,
            enable: isOnConnect,
            enableBorder: false,
          ),
        ),
        actions: [
          CircleButton(
            onTap: () {
              // if (!isOnConnect) {
              showModalBottomSheet(
                  context: context,
                  // useRootNavigator: false,
                  isDismissible: false,
                  // barrierColor: Colors.transparent,

                  backgroundColor: context.theme.backgroundColor,
                  shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  builder: (context) {
                    return Stack(
                      // alignment: Alg,
                      children: [
                        Container(
                          width: context.mediaQuerySize.width,
                          color: Colors.transparent,
                          padding: AppPadding.paddingAll20,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(Images.img_change_call,
                                  width: context.mediaQuerySize.width / 2,
                                  height: context.mediaQuerySize.width / 2),
                              // SizedBoxExt.h20,
                              Text(
                                'Chuyển sang cuộc gọi video?',
                                style: AppTextStyles.regularW700(context,
                                    size: 16, color: context.theme.textColor),
                              ),
                              SizedBoxExt.h5,
                              Text(
                                'Lưu ý: Camera sẽ được bật',
                                style: AppTextStyles.regularW400(context,
                                    size: 14, color: context.theme.textColor),
                              ),
                              SizedBoxExt.h30,
                              Container(
                                width: context.mediaQuerySize.width / 1.5,
                                // height: 50.0,
                                padding: AppPadding.paddingAll10,
                                decoration: BoxDecoration(
                                    gradient: context.theme.gradientPhoneCall,
                                    borderRadius: BorderRadius.circular(100)),
                                child: InkWell(
                                    onTap: () {
                                      AppRouter.back(context);
                                      AppRouter.replaceWithPage(
                                          context, AppPages.Video_Call,
                                          arguments: {
                                            MainPhoneVideoScreen.arugUserInfo:
                                                widget.userInfo
                                          });
                                    },
                                    child: Center(
                                      child: Text(
                                        'Chuyển',
                                        style: AppTextStyles.regularW500(
                                            context,
                                            size: 16,
                                            color:
                                                context.theme.backgroundColor),
                                      ),
                                    )),
                              ),
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
                                  width: 16, color: context.theme.iconColor),
                            ),
                          ),
                        )
                      ],
                    );
                  });
              // }
            },
            assestIcon: Images.ic_small_video,
            widthIcon: 18,
            padding: AppPadding.paddingAll8,
            enable: isOnConnect,
            enableBorder: false,
          ),
          SizedBoxExt.w15,
        ],
      ),
      body: Stack(
        children: [
          Container(
            height: context.mediaQuerySize.height,
            width: context.mediaQuerySize.width,
            decoration:
                BoxDecoration(gradient: context.theme.gradientPhoneCall),
          ),
          if (isOnConnect)
            Container(
              height: context.mediaQuerySize.height,
              width: context.mediaQuerySize.width,
              decoration:
                  BoxDecoration(color: AppColors.black.withOpacity(0.2)),
            ),
          Container(
            height: context.mediaQuerySize.height,
            width: context.mediaQuerySize.width,
            decoration: BoxDecoration(color: Colors.transparent),
            child: Column(
              children: [
                SizedBoxExt.h70,
                SizedBoxExt.h70,
                Column(
                  children: [
                    SizedBox(
                      width: context.mediaQuerySize.width / 2.5,
                      height: context.mediaQuerySize.width / 2.5,
                      child: RippleAnimation(
                        repeat: !isOnConnect,
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
                SizedBoxExt.h20,
                Text(
                  widget.userInfo.name,
                  style: AppTextStyles.regularW700(context,
                      size: 16, color: AppColors.white),
                ),
                SizedBoxExt.h10,
                if (!isOnConnect)
                  Text(
                    denidedCall
                        ? 'Người nhận từ chối cuộc gọi'
                        : 'Đang đổ chuông',
                    style: AppTextStyles.regularW400(context,
                        size: 14, color: AppColors.white),
                  ),
                if (isOnConnect)
                  Text(
                    '${NumberFormat('00').format(minute)}:${NumberFormat('00').format(secon)}',
                    style: AppTextStyles.regularW400(context,
                        size: 14, color: AppColors.timeCallColor),
                  ),
                // SizedBoxExt.h10,
                if (useSpeakerphone)
                  SmallNoti(
                      assestIcon: Images.ic_speakerphone,
                      title: 'Bạn đang dùng loa ngoài'),

                if (!useMic)
                  SmallNoti(
                    assestIcon: Images.ic_mic_off,
                    title: 'Bạn đang tắt mic',
                  ),

                Spacer(),
                _buildCall(), SizedBoxExt.h40,
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCall() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      // mainAxisSize: MainAxisSize.min,
      children: [
        //*Tắt bật loa
        CircleButton(
          onTap: () {
            _turnSpeakerphone();
          },
          assestIcon: Images.ic_speakerphone,
          enable: useSpeakerphone,
          name: 'Loa',
          iconColor: AppColors.iconCallScreenColor,
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
        //*Tắt bật mic
        CircleButton(
          onTap: () {
            // if (!onConnect)
            _turnMic();
          },
          name: 'Mic',
          assestIcon: useMic ? Images.ic_mic : Images.ic_mic_off,
          enable: true,
          backgroundColor: useMic ? null : AppColors.white,
          iconColor: useMic ? null : AppColors.text,
        ),
      ],
    );
  }
}
