import 'dart:convert';

import 'package:chat_365/common/images.dart';
import 'package:chat_365/core/constants/local_storage_key.dart';
import 'package:chat_365/core/constants/string_constants.dart';
import 'package:chat_365/core/theme/app_colors.dart';
import 'package:chat_365/core/theme/app_text_style.dart';
import 'package:chat_365/modules/home_qr_code/bloc/home_qr_bloc.dart';
import 'package:chat_365/modules/home_qr_code/bloc/home_qr_state.dart';
import 'package:chat_365/router/app_pages.dart';
import 'package:chat_365/router/app_router.dart';
import 'package:chat_365/utils/data/extensions/context_extension.dart';
import 'package:chat_365/utils/ui/app_dialogs.dart';
import 'package:chat_365/utils/ui/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:sp_util/sp_util.dart';

class AcceptLoginScreen extends StatefulWidget {
  const AcceptLoginScreen({Key? key}) : super(key: key);

  @override
  State<AcceptLoginScreen> createState() => _AcceptLoginScreenState();
}

class _AcceptLoginScreenState extends State<AcceptLoginScreen> {
  String? locationComputer;
  String? nameComputer;
  String? timeComputer;
  String? encodeEmail;
  String? encodePass;
  String? qrCodeID;
  var latitude;
  var longitude;
  String? address;

  @override
  Future didChangeDependencies() async {
    try {
      nameComputer = context.args['nameComputer'];
      latitude = context.args['latitude'];
      longitude = context.args['longitude'];
      timeComputer = context.args['timeComputer'];
      qrCodeID = context.args['qrCodeID'];
      print('Dữ Liệu: $locationComputer - $nameComputer - $latitude - $longitude - $timeComputer - $qrCodeID');
      await getLocationName().then((value) => getUserLocation());
    } catch (e) {
      print('Error: ${e.toString()}');
    }
    super.didChangeDependencies();
  }

  ///Lấy vị trí chấm công
  Future<String> getLocationName() async {
    List<Placemark> placeMark =
        await GeocodingPlatform.instance.placemarkFromCoordinates(latitude, longitude, localeIdentifier: "vi").catchError((e) {
      print("Loi vi tri: $e");
      return List<Placemark>.from([]);
    });
    return '${placeMark[0].subThoroughfare} ${placeMark[0].thoroughfare}, ${placeMark[0].subAdministrativeArea}, ${placeMark[0].administrativeArea}, ${placeMark[0].country}';
  }

  ///Lấy lat long
  Future getUserLocation() async {
    address = await getLocationName();
  }

  final HomeQRCodeBloc _homeQRCodeBloc = HomeQRCodeBloc();

  Future encodeEmailPassword() async {
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    encodeEmail = stringToBase64.encode(context.userInfo().email!);
    encodePass = stringToBase64.encode(context.userInfo().password!);
    print('MaHoa: $encodeEmail - $encodePass');
  }

  String? test;

  @override
  void initState() {
    test = SpUtil.getString(LocalStorageKey.passwordClass);
    // TODO: implement initState
    encodeEmailPassword();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  /// Dung cho chuc nang delay thoi gian scan qr code
  DateTime? lastScan;

  @override
  Widget build(BuildContext context) {
    Widget _CustomRow({
      required String title,
      required String detailTitle,
    }) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: AppTextStyles.regularW400(
                  context,
                  size: 16,
                ),
                textAlign: TextAlign.center),
            SizedBoxExt.w5,
            Expanded(
              child: Text(
                detailTitle,
                style: AppTextStyles.regularW500(
                  context,
                  size: 14,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return BlocProvider.value(
      value: _homeQRCodeBloc,
      child: BlocListener<HomeQRCodeBloc, HomeQRCodeState>(
        listener: (_, state) {
          AppRouter.removeAllDialog(context);
          if (state is HomeQRCodeLoadingState) {
            AppDialogs.showLoadingCircle(context);
          } else if (state is HomeQRCodeLoadedState) {
            AppDialogs.toast("Đăng nhập thành công");
            AppRouter.backToPage(context, AppPages.Navigation);
          }
        },
        listenWhen: (_, __) => mounted,
        child: SafeArea(
          child: Scaffold(
            backgroundColor: context.theme.backgroundFormFieldColor,
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                  Center(
                    child: Image.asset(
                      Images.img_accept_login,
                      height: 220,
                      width: 220,
                    ),
                  ),
                  SizedBoxExt.h20,
                  Text(
                    StringConst.allowLoginChat365,
                    style: AppTextStyles.regularW500(context, size: 16),
                  ),
                  SizedBoxExt.h30,
                  _CustomRow(
                    title: 'Thiết bị:',
                    detailTitle: nameComputer ?? "Không xác định",
                  ),
                  _CustomRow(
                    title: 'Thời gian:',
                    detailTitle: timeComputer ?? "Không xác định",
                  ),
                  _CustomRow(
                    title: 'Địa điểm:',
                    detailTitle: address ?? 'Không xác định',
                  ),
                  SizedBoxExt.h30,
                  RichText(
                    textAlign: TextAlign.center,
                    softWrap: true,
                    strutStyle: StrutStyle(height: 1.5),
                    text: TextSpan(
                      text: 'Lưu ý: ',
                      style: AppTextStyles.regularW600(context, size: 16),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Bạn sẽ được yêu cầu xác thực bằng ',
                          style: AppTextStyles.regularW400(context, size: 16),
                        ),
                        TextSpan(
                          text: 'Sinh trắc học ',
                          style: AppTextStyles.regularW600(context, size: 16),
                        ),
                        TextSpan(
                          text: 'để bảo vệ tài khoản',
                          style: AppTextStyles.regularW400(context, size: 16),
                        ),
                      ],
                    ),
                  ),
                  SizedBoxExt.h96,
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () {
                            _homeQRCodeBloc.allowLoginQR(
                              qrCodeID,
                              '${encodeEmail}++',
                              '${encodePass}++',
                            );
                          },
                          child: Ink(
                            width: context.mediaQuerySize.width * 0.45,
                            height: 40,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Center(
                              child: Text(
                                'Đăng nhập',
                                style: AppTextStyles.regularW500(
                                  context,
                                  size: 16,
                                  color: AppColors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBoxExt.h16,
                        TextButton(
                          onPressed: () => AppRouter.backToPage(context, AppPages.Navigation),
                          child: Text(
                            'Từ chối',
                            style: AppTextStyles.regularW500(
                              context,
                              size: 16,
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
