import 'package:app_settings/app_settings.dart';
import 'package:chat_365/common/images.dart';
import 'package:chat_365/core/constants/string_constants.dart';
import 'package:chat_365/core/theme/app_colors.dart';
import 'package:chat_365/core/theme/app_text_style.dart';
import 'package:chat_365/modules/auth/bloc/auth_bloc.dart';
import 'package:chat_365/modules/chat/repo/chat_repo.dart';
import 'package:chat_365/modules/chat_conversations/bloc/chat_conversation_bloc.dart';
import 'package:chat_365/modules/timekeeping/bloc/timekeeping_bloc.dart';
import 'package:chat_365/modules/timekeeping/bloc/timekeeping_state.dart';
import 'package:chat_365/modules/timekeeping/widgets/icon_text.dart';
import 'package:chat_365/router/app_pages.dart';
import 'package:chat_365/router/app_router.dart';
import 'package:chat_365/utils/data/extensions/context_extension.dart';
import 'package:chat_365/utils/ui/app_dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

class ChooseATimekeepingScreen extends StatefulWidget {
  ChooseATimekeepingScreen({Key? key}) : super(key: key);

  @override
  State<ChooseATimekeepingScreen> createState() =>
      _ChooseATimekeepingScreenState();
}

class _ChooseATimekeepingScreenState extends State<ChooseATimekeepingScreen>
    with WidgetsBindingObserver, AutomaticKeepAliveClientMixin {
  bool didNavigateToAppSettings = false;

  void initState() {
    _timekeepingBloc = context.read<TimekeepingBloc>();
    _timekeepingBloc.emit(TimekeepingLoadingState());
    // _timekeepingBloc.getInfoWifi();
    // _timekeepingBloc.getDeviceInfo();
    _timekeepingBloc.getConfiguration();
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
  }

  late final TimekeepingBloc _timekeepingBloc;

  ///Set lại wifi trước khi chấm công
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed && didNavigateToAppSettings) {
      didNavigateToAppSettings = false;
      await _timekeepingBloc.getInfoWifi();
      await _timekeepingBloc.getUserLocation();
      _timekeepingBloc.emit(TimekeepingLoadedState());
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocProvider.value(
      value: _timekeepingBloc,
      child: Scaffold(
        backgroundColor: context.theme.messageBoxColor,
        appBar: AppBar(
          title: Text(
            StringConst.timekeeping,
          ),
          elevation: 1,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            InkWell(
              onTap: () {
                _timekeepingBloc.typeTimekeeping?.contains('8') == true ||
                        [1408, 1279, 1207, 5528, 174, 38676]
                            .contains(context.userInfo().id)
                    ? {
                        AppRouter.toPage(
                          context,
                          AppPages.Face_Timekeeping,
                          blocValue: _timekeepingBloc,
                        ),
                      }
                    : AppDialogs.showFunctionLockDialog(context,
                        title: StringConst.function_lock);
              },
              child: Ink(
                height: 82,
                width: MediaQuery.of(context).size.width,
                color: context.theme.backgroundFormFieldColor,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(Images.ic_user_face),
                    const SizedBox(height: 8),
                    Text(
                      "Nhận diện khuôn mặt",
                      style: AppTextStyles.regularW400(context, size: 16),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 5),
            InkWell(
              onTap: () {
                _timekeepingBloc.typeTimekeeping?.contains('2') == true
                    ? {
                        AppRouter.toPage(
                          context,
                          AppPages.QR_Timekeeping,
                          blocValue: _timekeepingBloc,
                        ),
                        AppDialogs.toast('Quét mã QR')
                      }
                    : AppDialogs.showFunctionLockDialog(context,
                        title: StringConst.function_lock);
              },
              child: Ink(
                height: 82,
                width: MediaQuery.of(context).size.width,
                color: context.theme.backgroundFormFieldColor,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(Images.ic_qr_timekeeping),
                    const SizedBox(height: 8),
                    Text(
                      "Mã QR",
                      style: AppTextStyles.regularW400(context, size: 16),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            BlocBuilder(
                bloc: _timekeepingBloc,
                builder: (context, state) {
                  if (state is TimekeepingLoadingState) {
                    _timekeepingBloc.companyWay = 'Đang lấy vị trí ...';
                  } else if (state is TimekeepingLoadedState) {
                    // if (_timekeepingBloc.currentLocation == null && _timekeepingBloc.isInit)
                    //   _timekeepingBloc.getUserLocation().then((value) {
                    //     _timekeepingBloc.isInit = true;
                    //     if (value) setState(() {});
                    //   });
                    // else
                    //   _timekeepingBloc.getDistance();
                    if (_timekeepingBloc.configCoordinate!.isEmpty ||
                        _timekeepingBloc.totalDistance == null) {
                      _timekeepingBloc.companyWay =
                          'Khoảng cách không xác định';
                    } else {
                      _timekeepingBloc.companyWay =
                          'Cách công ty ${_timekeepingBloc.totalDistance} m';
                    }
                  } else if (state is TimekeepingError401) {
                    var id = context.userInfo().id;
                    context.read<ChatRepo>().logout(id);
                    context.read<ChatConversationBloc>().clear();
                    context.read<AuthBloc>().add(AuthLogoutRequest());
                  }
                  return Column(
                    children: [
                      IconText(
                        icon: Images.ic_choose_location,
                        title: 'Thông tin vị trí',
                        detail: _timekeepingBloc.companyWay ??
                            'Khoảng cách không xác định',
                        onTap: () async {
                          didNavigateToAppSettings = true;
                          AppSettings.openLocationSettings();
                        },
                        onRefresh: () async {
                          await _timekeepingBloc.getUserLocation();
                          _timekeepingBloc.emit(TimekeepingLoadedState());
                        },
                      ),
                      IconText(
                        icon: Images.ic_choose_wifi,
                        title: 'Thông tin Wifi',
                        detail:
                            _timekeepingBloc.nameWifi?.replaceAll('"', '') ??
                                'Chưa xác định',
                        onTap: () {
                          didNavigateToAppSettings = true;
                          AppSettings.openWIFISettings();
                        },
                        onRefresh: () async {
                          await _timekeepingBloc.getInfoWifi();
                          setState(() {});
                        },
                      ),
                    ],
                  );
                }),
            Spacer(),
            TextButton(
                onPressed: () {
                  _launchURL(StringConst.tutorialLink);
                },
                child: Text(
                  'Hướng dẫn chấm công',
                  style: TextStyle(
                    fontSize: 16,
                    decoration: TextDecoration.underline,
                    color: AppColors.primary,
                  ),
                ))
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

_launchURL(url) async {
  await launch(url);
}
