import 'package:chat_365/common/widgets/permission/location_permission_page.dart';
import 'package:chat_365/main.dart';
import 'package:chat_365/router/app_pages.dart';
import 'package:chat_365/router/app_route_observer.dart';
import 'package:chat_365/router/app_router.dart';
import 'package:chat_365/utils/helpers/logger.dart';
import 'package:chat_365/utils/ui/app_dialogs.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapService {
  static const key = "AIzaSyCmAUhuDeHY3HjgwKLdvm0rpsoyS6JmF9U";

  // static const apiKey = "AIzaSyCJqpC7oo-YYJJ1pRVZJgf84qExlHZCWSc";
  static const dirApiKey = "AIzaSyA66KwUrjxcFG5u0exynlJ45CrbrNe3hEc";
  static const apiKey = "AIzaSyA66KwUrjxcFG5u0exynlJ45CrbrNe3hEc";

  static MapService? _instance;

  factory MapService() => _instance ??= MapService._();

  MapService._() {}

  Future init() async {
    _position = await getCurrentLocation();
  }

  Future<LatLng?> getCurrentLocation() async {
    // bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    final bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      try {
        return await _toLocationPermissionPage();
      } catch (e) {
        // AppDialogs.toast(
        //     'Location permissions are permanently denied, we cannot request permissions.');
      }
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      // AppDialogs.toast('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      // try {
      //   await _toLocationPermissionPage();
      //   permission = await Geolocator.checkPermission();
      // } catch (e, s) {
      //   logger.logError(e, s);
      permission = await Geolocator.requestPermission();
      // }

      // if (permission == LocationPermission.denied) {
      //   // Permissions are denied, next time you could try
      //   // requesting permissions again (this is also where
      //   // Android's shouldShowRequestPermissionRationale
      //   // returned true. According to Android guidelines
      //   // your App should show an explanatory UI now.
      //   // AppDialogs.toast('Location permissions are denied');
      // }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      try {
        return await _toLocationPermissionPage();
      } catch (e) {
        // AppDialogs.toast(
        //     'Location permissions are permanently denied, we cannot request permissions.');
      }
    }
    try {
      return await _onLocationPermissionGranted();
    } catch (e, s) {
      AppDialogs.toast('Lấy vị trí thất bại');
      logger.logError(e, s, 'MapServiceGetLocationError');
    }
    return null;
  }

  /// Cấp quyền truy cập camera
  // Future<LatLng?> getCurrentCamera() async {
  //   bool serviceEnabled;
  //   LocationPermission permission;

  //   // Test if location services are enabled.
  //   serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (!serviceEnabled) {
  //     // Location services are not enabled don't continue
  //     // accessing the position and request users of the
  //     // App to enable the location services.
  //     // AppDialogs.toast('Location services are disabled.');
  //   }

  //   permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     try {
  //       await _toLocationPermissionPage();
  //       permission = await Geolocator.checkPermission();
  //     } catch (e, s) {
  //       logger.logError(e, s);
  //       permission = await Geolocator.requestPermission();
  //     }

  //     if (permission == LocationPermission.denied) {
  //       // Permissions are denied, next time you could try
  //       // requesting permissions again (this is also where
  //       // Android's shouldShowRequestPermissionRationale
  //       // returned true. According to Android guidelines
  //       // your App should show an explanatory UI now.
  //       // AppDialogs.toast('Location permissions are denied');
  //     }
  //   }

  //   if (permission == LocationPermission.deniedForever) {
  //     // Permissions are denied forever, handle appropriately.
  //     try {
  //       return await _toCameraPermissionPage();
  //     } catch (e) {
  //       // AppDialogs.toast(
  //       //     'Location permissions are permanently denied, we cannot request permissions.');
  //     }
  //   }
  //   try {
  //     return await _toCameraPermissionPage();
  //   } catch (e) {}
  //   return null;
  // }

  Future _toLocationPermissionPage() async {
    var context = navigatorKey.currentContext!;
    bool isRouteContainNavigation =
        routeObserver.isContainPageName(AppPages.Navigation.name);
    bool isDuplicates =
        routeObserver.isContainPageName(AppPages.Location_Permission.name);
    if (isRouteContainNavigation && !isDuplicates)
      return AppRouter.toPage(
        context,
        AppPages.Location_Permission,
        arguments: {
          LocationPermissionPage.callBackArg: _onLocationPermissionGranted,
        },
        duration: Duration.zero,
      );
  }

  /// check cấp quyền camera
  // Future _toCameraPermissionPage() async {
  //   return await Navigator.of(navigatorKey.currentContext!).push(
  //     MaterialPageRoute(
  //       builder: (_) => CameraPermissionPage(
  //         callBack: _onCameraPermissionGranted,
  //       ),
  //     ),
  //   );
  // }

  Future<LatLng> _onLocationPermissionGranted() async {
    var p = await GeolocatorPlatform.instance.getCurrentPosition(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: 5,
        timeLimit: Duration(seconds: 15),
      ),
    );
    logger.log(p, name: 'CurrentLocation');
    return LatLng(
      p.latitude,
      p.longitude,
    );
  }

  ///Cấp quyền truy cập camera
  // Future<LatLng> _onCameraPermissionGranted() async {
  //   var p = await GeolocatorPlatform.instance.getCurrentPosition(
  //     locationSettings: LocationSettings(
  //       accuracy: LocationAccuracy.best,
  //       distanceFilter: 5,
  //       timeLimit: Duration(seconds: 2),
  //     ),
  //   );
  //   logger.log(p, name: 'CurrentLocation');
  //   return LatLng(
  //     p.latitude,
  //     p.longitude,
  //   );
  // }

  LatLng? _position;

  LatLng get position {
    var _defaultLatLng = LatLng(
      14.0583,
      108.2772,
    );
    return _position ?? _defaultLatLng;
  }
}
