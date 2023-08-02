import 'dart:async';

import 'package:camera/camera.dart';
import 'package:chat_365/utils/helpers/logger.dart';
import 'package:chat_365/utils/ui/app_dialogs.dart';

class CameraUtils {
  Future<CameraController> getCameraController(
    ResolutionPreset resolutionPreset,
    CameraLensDirection cameraLensDirection,
  ) async {
    final cameras = await availableCameras();
    final camera = cameras
        .firstWhere((camera) => camera.lensDirection == cameraLensDirection);
    try {
      return CameraController(
        camera,
        resolutionPreset,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );
    } catch (e, s) {
      logger.logError(e, s, 'CreateCameraControllerError: ');
      AppDialogs.toast('Không thể khởi tạo camera !');
      rethrow;
    }
  }
}