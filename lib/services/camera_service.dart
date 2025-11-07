import 'package:camera/camera.dart';

class CameraService {
  static List<CameraDescription> cameras = [];

  static Future<void> initializeCameras() async {
    if (cameras.isEmpty) {
      try {
        cameras = await availableCameras();
      } on CameraException catch (e) {
        // Log the error or handle it as needed
        print('Error initializing cameras: ${e.code}, ${e.description}');
      }
    }
  }
}
