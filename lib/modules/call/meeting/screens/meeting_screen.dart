
import 'package:chat_365/common/images.dart';
import 'package:chat_365/common/widgets/form/outline_text_form_field.dart';
import 'package:chat_365/core/theme/app_colors.dart';
import 'package:chat_365/core/theme/app_dimens.dart';
import 'package:chat_365/modules/call/meeting/widgets/more_bottom_sheet.dart';
import 'package:chat_365/modules/call/meeting/widgets/share_screen.dart';
import 'package:chat_365/modules/call/meeting/widgets/white_board.dart';
import 'package:chat_365/router/app_pages.dart';
import 'package:chat_365/router/app_router.dart';
import 'package:chat_365/utils/ui/app_border_and_radius.dart';
import 'package:chat_365/utils/ui/app_padding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:chat_365/utils/data/extensions/context_extension.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';

bool isFullScreen = false;
bool isShowWhiteBoard = false;
class MeetingScreen extends StatefulWidget {
  const MeetingScreen({Key? key}) : super(key: key);

  @override
  State<MeetingScreen> createState() => _MeetingScreenState();
}

class _MeetingScreenState extends State<MeetingScreen> {
  bool isShowBottomSheet = false;
  bool isAudioConnected = false;
  bool isTurnOnMic = false;
  bool isTurnOnCamera = false;
  bool isSharing = false;
  bool isEditIconTap = false;
  late double _width = MediaQuery.of(context).size.width;
  late double _height = MediaQuery.of(context).size.height;

  @override
  initState() {
    super.initState();
  }

  @override
  dispose(){
    super.dispose();
    isShowWhiteBoard=false;
  }

  _showDetailDialog() async {
    setState(() {
      isShowBottomSheet = true;
    });
    return await showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      // title: 'Cuộc họp của Nguyễn Văn Nam',
      builder: (_) => Container(
        padding: AppDimens.paddingHorizontal16,
        height: 400,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(15),
          ),
          color: AppColors.tundora.withOpacity(0.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Divider(
              thickness: 5,
              color: AppColors.black99,
              indent: _width * 0.4,
              endIndent: _width * 0.4,
            ),
            Padding(
              padding: AppPadding.paddingVertical8,
              child: Text(
                'Cuộc họp của Nguyễn Văn Nam',
                style: context.theme.searchBigTextStyle
                    .copyWith(fontSize: 20, color: AppColors.white),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Text(
                          'ID cuộc họp',
                          style: context.theme.chatConversationDropdownTextStyle
                              .copyWith(color: AppColors.black99),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          '9123 5096 4868',
                          style: context.theme.userListTileTextTheme
                              .copyWith(color: AppColors.white, fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Text(
                          'Người chủ trì',
                          style: context.theme.chatConversationDropdownTextStyle
                              .copyWith(color: AppColors.black99),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          'Nguyễn Văn Nam',
                          style: context.theme.userListTileTextTheme
                              .copyWith(color: AppColors.white, fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Text(
                          'Mật mã',
                          style: context.theme.chatConversationDropdownTextStyle
                              .copyWith(color: AppColors.black99),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          '57c0ZE',
                          style: context.theme.userListTileTextTheme
                              .copyWith(color: AppColors.white, fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Text(
                          'Liên kết mời',
                          style: context.theme.chatConversationDropdownTextStyle
                              .copyWith(color: AppColors.black99),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          'hhtps://6eyrutiyuofdjhgfug5y73894/56/rty8u6/345678909876543',
                          style: context.theme.userListTileTextTheme
                              .copyWith(color: AppColors.white, fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Text(
                          'Mã hóa',
                          style: context.theme.chatConversationDropdownTextStyle
                              .copyWith(color: AppColors.black99),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          'Đã bật',
                          style: context.theme.userListTileTextTheme
                              .copyWith(color: AppColors.white, fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    'Bạn đang kết nối với Mạng lưới Chat365 toàn cầu qua trung tâm dữ liệu tại Việt Nam.',
                    style: context.theme.chatConversationDropdownTextStyle
                        .copyWith(color: AppColors.black99),
                  ),
                  TextButton(
                    onPressed: () => AppRouter.toPage(context,
                        AppPages.MeetingScreen_OverviewSecuritySetting),
                    child: Text('Tổng quan về cài đặt bảo mật'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).whenComplete(() {
      Future.delayed(Duration(milliseconds: 500));
      setState(() => isShowBottomSheet = false);
    });
  }

  _showEmojiDialog() async {
    setState(() {
      isFullScreen = true;
      isShowBottomSheet = true;
    });
    return await showModalBottomSheet(
      isScrollControlled: true,
        isDismissible: false,
        enableDrag: false,
        backgroundColor: Colors.transparent,
        context: context,
        builder: (_) {
          return EmojiBottomSheet();
        }).whenComplete(() {
      Future.delayed(Duration(milliseconds: 500));
      setState(() {
        isFullScreen = false;
        isShowBottomSheet = false;
      });
    });
  }

  _buildAudioNotConnect() {
    return GestureDetector(
      onTap: () => showDialog(
          barrierDismissible: false,
          context: context,
          builder: (_) => CupertinoAlertDialog(
                content: Text(
                  'Để nghe người khác\nvui lòng tham gia âm thanh',
                  style: context.theme.userListTileTextTheme
                      .copyWith(fontSize: 14, color: AppColors.black),
                ),
                actions: [
                  CupertinoButton(
                    onPressed: () {
                      Navigator.pop(context);
                      setState(() {
                        isAudioConnected = true;
                      });
                    },
                    child: Text(
                      'Wifi hoặc Dữ liệu di động',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                  CupertinoButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Không có âm thanh',
                        style: TextStyle(fontSize: 14)),
                  ),
                ],
              )),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SvgPicture.asset(
            Images.ic_headphone,
            color: AppColors.white,
            width: 25,
            height: 25,
          ),
          Text(
            'Kết nối âm thanh',
            style: context.theme.userListTileTextTheme
                .copyWith(color: AppColors.white, fontSize: 10),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  _buildAudioConnected() {
    return GestureDetector(
      onTap: () {
        setState(() {
          isTurnOnMic = !isTurnOnMic;
        });
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SvgPicture.asset(
            isTurnOnMic ? Images.ic_mic : Images.ic_mic_off,
            color: AppColors.white,
            width: 25,
            height: 25,
          ),
          Text(
            isTurnOnMic ? 'Tắt mic' : 'Mở mic',
            style: context.theme.userListTileTextTheme
                .copyWith(color: AppColors.white, fontSize: 10),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  _buildNotSharing() {
    return GestureDetector(
      onTap: _showShareScreenBottomSheet,
      child: Padding(
        padding: AppPadding.paddingAll4,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SvgPicture.asset(
              Images.ic_share_screen,
              color: AppColors.lawnGreen,
              width: 25,
              height: 25,
            ),
            Text(
              'Chia sẻ màn hình',
              style: context.theme.userListTileTextTheme
                  .copyWith(color: AppColors.lawnGreen, fontSize: 10),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  _buildSharing() {
    return GestureDetector(
      onTap: () => setState(() {
        isSharing = false;
        isShowWhiteBoard =false;
      }),
      child: Padding(
        padding: AppPadding.paddingAll4,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SvgPicture.asset(
              Images.ic_stop_share_screen,
              color: AppColors.red,
              width: 25,
              height: 25,
            ),
            Text(
              'Dừng chia sẻ',
              style: context.theme.userListTileTextTheme
                  .copyWith(color: AppColors.red, fontSize: 10),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  _shareScreenBottomSheetItem(String text, {void Function()? onPressed}) {
    return Expanded(
      child: InkWell(
        onTap: onPressed,
        child: Text(
          text,
          style: context.theme.userListTileTextTheme
              .copyWith(color: AppColors.white, fontSize: 14),
        ),
      ),
    );
  }

  _shareDialog() {
    return showDialog(
        context: context,
        builder: (_) => CupertinoAlertDialog(
              title: Text(
                'URL trang web',
                style: context.theme.chatConversationDropdownTextStyle
                    .copyWith(fontSize: 14, color: AppColors.black),
              ),
              content: Container(
                child: Column(
                  children: [
                    Padding(
                      padding: AppPadding.paddingVertical8,
                      child: Text(
                        'Nhập URL và nhấn chia sẻ để mọi người có thể thấy nó',
                        textAlign: TextAlign.center,
                      ),
                    ),
                    CupertinoTextField(
                      // decoration: BoxDecoration(
                      // color: Colors.transparent,
                      // ),
                      placeholder: 'Nhập URL tại đây',
                    ),
                  ],
                ),
              ),
              actions: [
                CupertinoButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Hủy',
                    style: context.theme.chatConversationDropdownTextStyle
                        .copyWith(fontSize: 14, color: AppColors.primary),
                  ),
                ),
                CupertinoButton(
                  onPressed: () {
                    Navigator.pop(context);
                    setState(() {
                      isSharing = true;
                    });
                  },
                  child: Text('Chia sẻ'),
                ),
              ],
            ));
  }

  _showShareScreenBottomSheet() async {
    setState(() {
      isFullScreen = true;
      isShowBottomSheet = true;
    });
    return await showModalBottomSheet(
        isDismissible: true,
        enableDrag: false,
        backgroundColor: Colors.transparent,
        context: context,
        builder: (_) {
          return Container(
            padding: AppPadding.paddingAll16,
            width: MediaQuery.of(context).size.width,
            height: 300,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
              color: AppColors.tundora.withOpacity(0.5),
            ),
            child: Column(
              children: [
                Container(
                  padding: AppPadding.paddingAll16,
                  height: 220,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: AppBorderAndRadius.defaultBorderRadius,
                    color: AppColors.tundora,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _shareScreenBottomSheetItem('Ảnh'),
                      Divider(
                        color: context.theme.dividerDefaultColor,
                        thickness: 1,
                      ),
                      _shareScreenBottomSheetItem('iCloud Drive'),
                      Divider(
                        color: context.theme.dividerDefaultColor,
                        thickness: 1,
                      ),
                      _shareScreenBottomSheetItem('Google Drive'),
                      Divider(
                        color: context.theme.dividerDefaultColor,
                        thickness: 1,
                      ),
                      _shareScreenBottomSheetItem('Microsoft OneDrive'),
                      Divider(
                        color: context.theme.dividerDefaultColor,
                        thickness: 1,
                      ),
                      _shareScreenBottomSheetItem('URL trang web',
                          onPressed: () async {
                        Navigator.pop(context);
                        await _shareDialog();
                      }),
                    ],
                  ),
                ),
                Container(
                  margin: AppPadding.paddingAll16,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Text(
                      'Hủy',
                      style: context.theme.chatConversationDropdownTextStyle
                          .copyWith(color: AppColors.white),
                    ),
                  ),
                ),
              ],
            ),
          );
        }).whenComplete(() {
      Future.delayed(Duration(milliseconds: 500));
      setState(() {
        isFullScreen = false;
        isShowBottomSheet = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: isFullScreen
          ? PreferredSize(
              preferredSize: Size.zero,
              child: Container(),
            )
          : AppBar(
              leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: SvgPicture.asset(
                  Images.ic_arrow_back,
                  color: AppColors.white,
                ),
              ),
              title: GestureDetector(
                onTap: () async => _showDetailDialog(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Phòng họp',
                      style: TextStyle(color: AppColors.white),
                    ),
                    SvgPicture.asset(
                      Images.ic_arrow_down,
                      color: AppColors.white,
                    ),
                  ],
                ),
              ),
              centerTitle: true,
              actions: [
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    width: 80,
                    height: 30,
                    margin: AppPadding.paddingAll10.copyWith(left: 0),
                    decoration: BoxDecoration(
                        borderRadius: AppBorderAndRadius.defaultBorderRadius,
                        color: AppColors.red),
                    child: Center(
                      child: Text(
                        'Kết thúc',
                        style: context.theme.chatConversationDropdownTextStyle
                            .copyWith(color: AppColors.white),
                      ),
                    ),
                  ),
                ),
              ],
              backgroundColor: AppColors.tundora,
            ),
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: isShowWhiteBoard?AppColors.white:Colors.black,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    if(!isSharing){
                      setState(() {
                        isFullScreen = !isFullScreen;
                        isFullScreen
                            ? SystemChrome.setSystemUIOverlayStyle(
                                SystemUiOverlayStyle.dark.copyWith(
                                    statusBarBrightness: Brightness.dark,
                                    statusBarColor: AppColors.black))
                            : SystemChrome.setSystemUIOverlayStyle(
                                SystemUiOverlayStyle.light.copyWith(statusBarColor: context.theme.backgroundColor.withOpacity(0.15)));
                      });
                    }
                  },
                  child: isShowWhiteBoard?WhiteBoard():Container(
                    width: _width,
                    height: _height,
                    // alignment: Alignment.bottomLeft,
                    decoration: BoxDecoration(
                      color: AppColors.black,
                      image: isSharing
                          ? DecorationImage(
                        image: AssetImage(
                            'assets/images/background_meeting.png'),
                        fit: BoxFit.cover,
                      )
                          : null,
                    ),
                    child: isSharing
                        ? ShareScreen()
                        : Center(
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          borderRadius:
                          AppBorderAndRadius.defaultBorderRadius,
                          color: AppColors.orange,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              isShowBottomSheet
                  ? Container(
                      height: AppDimens.space58,
                    )
                  : isFullScreen
                      ? Text(
                          'Nguyễn Văn Nam',
                          style: context.theme.userListTileTextTheme
                              .copyWith(color: AppColors.white),
                        )
                      : AnimatedContainer(
                          height: AppDimens.space58,
                          duration: Duration(milliseconds: 300),
                          color: AppColors.tundora,
                          child: Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: AppPadding.paddingAll4,
                                  child: isAudioConnected
                                      ? _buildAudioConnected()
                                      : _buildAudioNotConnect(),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: AppPadding.paddingAll4,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        isTurnOnCamera = !isTurnOnCamera;
                                      });
                                    },
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        SvgPicture.asset(
                                          isTurnOnCamera
                                              ? Images.ic_video_call_1
                                              : Images.ic_video_off,
                                          color: AppColors.white,
                                          width: 25,
                                          height: 25,
                                        ),
                                        Text(
                                          isTurnOnCamera
                                              ? 'Tắt camera'
                                              : 'Mở camera',
                                          style: context
                                              .theme.userListTileTextTheme
                                              .copyWith(
                                                  color: AppColors.white,
                                                  fontSize: 10),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: (isSharing||isShowWhiteBoard)
                                    ? _buildSharing()
                                    : _buildNotSharing(),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: AppPadding.paddingAll4,
                                  child: GestureDetector(
                                    onTap: () => AppRouter.toPage(context,
                                        AppPages.MeetingParticipant_Screen),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        SvgPicture.asset(
                                          Images.ic_people,
                                          color: AppColors.white,
                                          width: 25,
                                          height: 25,
                                        ),
                                        Text(
                                          'Người tham gia',
                                          style: context
                                              .theme.userListTileTextTheme
                                              .copyWith(
                                                  color: AppColors.white,
                                                  fontSize: 10),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => _showEmojiDialog(),
                                  child: Padding(
                                    padding: AppPadding.paddingAll4,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        SvgPicture.asset(
                                          Images.ic_more_hoz,
                                          color: AppColors.white,
                                          width: 25,
                                          height: 25,
                                        ),
                                        Text(
                                          'Khác',
                                          style: context
                                              .theme.userListTileTextTheme
                                              .copyWith(
                                                  color: AppColors.white,
                                                  fontSize: 10),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
            ],
          ),
        ),
      ),
      // backgroundColor: AppColors.black,
    );
  }
}
