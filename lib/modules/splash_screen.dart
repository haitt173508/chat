import 'package:chat_365/common/images.dart';
import 'package:chat_365/service/firebase_service.dart';
import 'package:chat_365/service/injection.dart';
import 'package:chat_365/utils/ui/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    try {
      FlutterNativeSplash.remove();
    } catch (e) {}
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      getIt.get<FirebaseService>().initMessage();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              Images.img_logo_have_text,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 30),
            WidgetUtils.loadingCircle(context),
          ],
        ),
      ),
    );
  }
}
