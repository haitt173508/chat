import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:chat_365/core/error_handling/exceptions.dart';
import 'package:chat_365/data/services/map_service/map_service.dart';
import 'package:chat_365/modules/get_token/repos/get_token_repo.dart';
import 'package:chat_365/modules/timekeeping/model/result_timekeeping_configuration_model.dart';
import 'package:chat_365/modules/timekeeping/repo/timekeeping_repo.dart';
import 'package:chat_365/utils/data/models/exception_error.dart';
import 'package:chat_365/utils/helpers/logger.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:screenshot/screenshot.dart';
import 'timekeeping_state.dart';

class TimekeepingBloc extends Cubit<TimekeepingState> {
  final TimekeepingRepo timekeepingRepo;
  final GetTokenRepo getTokenRepo;

  ///Vị trí của bạn
  LatLng? currentLocation;
  double? distance;
  String address = 'Khoảng cách không xác định';

  double? totalDistance;

  ///Thông tin wifi
  var nameWifi;
  var wifiID;
  var wifiIp;
  String? companyWay;
  var idDevice;
  var device;
  var deviceqr;
  String? phoneNameQR;
  var brand;
  bool didNavigateToAppSettings = false;
  bool isInit = false;

  // getDistance() => distance = latCom == 0 && longCom == 0
  //     ? 0
  //     : Geolocator.distanceBetween(
  //         currentLocation?.latitude ?? 0.0,
  //         currentLocation?.longitude ?? 0.0,
  //         latCom ?? 0.0,
  //         longCom ?? 0.0,
  //       ).toPrecision(1);

  void getTotalDistance() {
    if (currentLocation == null) return;
    // print('getTotalDistance');
    List<double> listTotalDistance = [];
    // print('allCoordinate : ${configCoordinate!.length}');
    try {
      for (var item in configCoordinate!) {
        totalDistance = (Geolocator.distanceBetween(
          currentLocation?.latitude ?? 0.0,
          currentLocation?.longitude ?? 0.0,
          double.parse(item.corLat),
          double.parse(item.corLong),
        ).toPrecision(1));
        // print('Khoang cach ${totalDistance}');
        listTotalDistance.add(totalDistance!);
        if (listTotalDistance.reduce(min) == totalDistance) {
          coordinate = item;
        }
      }
    } catch (e) {}
    ;
    totalDistance = listTotalDistance.reduce(min);
    // print('totalDistance:${totalDistance}');
  }

  ///Lấy lat long
  Future<bool> getUserLocation() async {
    emit(TimeKeepingLoadingLocationState());
    currentLocation = await MapService().getCurrentLocation();
    if (currentLocation != null) {
      getLocationName(
        currentLocation!.latitude,
        currentLocation!.longitude,
      ).then((value) => address = value);
      // getDistance();
      getTotalDistance();
      return true;
    }
    return false;
  }

  String? checkWifi() {
    // print('checkWifi');
    // print('macwifi:${wifiID}');
    // print('allWifiConfig.map((e) => e.macAddress):${configWifi!.map((e) => e.macAddress)}');
    var listMacWifi = configWifi!.map((e) => e.macAddress);
    if (listMacWifi.map((e) => e).contains(wifiID)) {
      return '1';
    } else {
      return '0';
    }
  }

  ListCoordinate coordinate = ListCoordinate.fromJson({});

  String? checkCoordinate() {
    // print('checkCoordinate');
    // print('totalDistance $totalDistance');
    // print('allCoordinate ${configCoordinate!.length}');
    // print('Bán kính : ${coordinate.corRadius}');
    try {
      for (var item in configCoordinate!) {
        print('item.corRadius: ${item.corRadius}');
        if (totalDistance! <= double.parse(coordinate.corRadius)) {
          return '1';
        } else {
          return '0';
        }
      }
    } catch (e) {}
    return '1';
  }

  ///Lấy vị trí chấm công
  Future<String> getLocationName(double lat, double long) async {
    bool isCanGet = true;
    List<Placemark> placeMark = await GeocodingPlatform.instance
        .placemarkFromCoordinates(
      lat,
      long,
      localeIdentifier: "vi",
    )
        .catchError((e) {
      isCanGet = false;
      print("Loi vi tri: $e");
      return List<Placemark>.from([]);
    });
    return isCanGet
        ? '${placeMark[0].subThoroughfare} ${placeMark[0].thoroughfare}, ${placeMark[0].subAdministrativeArea}, ${placeMark[0].administrativeArea}, ${placeMark[0].country}'
        : "Không xác định";
  }

  Future<void> getInfoWifi() async {
    // await Future.delayed(const Duration(seconds: 1));

    var wifiBSSID = await NetworkInfo().getWifiBSSID();
    var wifiIP = await NetworkInfo().getWifiIP();
    var wifiName = await NetworkInfo().getWifiName();
    nameWifi = wifiName;
    wifiID = wifiBSSID;
    wifiIp = wifiIP;
    print('$wifiIP -> $wifiName -> $wifiBSSID');
    print('$wifiIP -> $nameWifi -> $wifiBSSID');
  }

  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  String? phoneName;

  getDeviceInfo() async {
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      phoneName = androidInfo.model;
      phoneNameQR = "${androidInfo.brand}:${androidInfo.model}";
      idDevice = androidInfo.androidId;
      brand = androidInfo.brand;
      device =
          '{"${androidInfo.androidId}":"${brand}: ${phoneName}-${idDevice}", "from": "chat365"}';
      deviceqr = '{"${idDevice}":"${androidInfo.brand}:${androidInfo.model}"}';
    } else {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      phoneName = iosInfo.utsname.machine;
      brand = iosInfo.model;
      phoneNameQR = "${brand}: ${iosInfo.name}";

      idDevice = iosInfo.identifierForVendor;
      device =
          '{"${iosInfo.identifierForVendor}":"${brand}: ${phoneName}-${idDevice}", "from": "chat365"}';
      deviceqr = '{"${iosInfo.identifierForVendor}":"$phoneNameQR"}';
    }
  }

  TimekeepingBloc(
    TimekeepingState initialState,
    this.timekeepingRepo,
    this.getTokenRepo,
  ) : super(initialState);

  ResultTimekeepingConfigurationModel? model;
  double? latCom;
  double? longCom;
  String? typeTimekeeping;

  getTimekeepingConfiguration() async {
    try {
      emit(TimekeepingLoadingState());
      await getTokenRepo.getToken();
      getConfiguration();
    } on CustomException catch (e, s) {
      logger.logError(e, s);
      emit(TimekeepingErrorState(e.error));
    }
  }

  List<ListWifi>? configWifi;
  List<ListCoordinate>? configCoordinate;

  Future<void> getConfiguration() async {
    await getInfoWifi();
    await getDeviceInfo();
    var res = await timekeepingRepo.getInfoCom();
    try {
      if (res.error == null) {
        emit(TimekeepingLoadingState());
        model = resultTimekeepingConfigurationModelFromJson(res.data);
        final coor = model?.data?.config.listCoordinate.isEmpty == true
            ? [0.0, 0.0]
            : [
                double.parse(
                    model?.data?.config.listCoordinate[0].corLat ?? '0'),
                double.parse(
                    model?.data?.config.listCoordinate[0].corLong ?? '0'),
              ];
        latCom = coor[0];
        longCom = coor[1];
        typeTimekeeping = model?.data?.config.typeTimekeeping;
        configWifi = model?.data?.config.listWifi;
        configCoordinate = model?.data?.config.listCoordinate;
        await getUserLocation();
        print(longCom);
        emit(TimekeepingLoadedState());
      } else {
        throw CustomException(res.error);
      }
    } catch (e, s) {
      emit(TimekeepingErrorState(
          e is CustomException ? e.error : ExceptionError(e.toString())));
    }
  }
}
