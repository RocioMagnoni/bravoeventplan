import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import '../services/camera_service.dart';
import '../services/capability_service.dart';

class MirrorViewModel extends ChangeNotifier {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;
  bool _isUnsupported = false;

  CameraController? get controller => _controller;
  Future<void>? get initializeControllerFuture => _initializeControllerFuture;
  bool get isUnsupported => _isUnsupported;

  MirrorViewModel() {
    _initializeCamera();
  }

  void _initializeCamera() {
    if (CapabilityService.isWebApp) {
      _isUnsupported = true;
      notifyListeners();
      return;
    }

    if (CameraService.cameras.length > 1) {
      _controller = CameraController(
        CameraService.cameras[1], // Front camera
        ResolutionPreset.medium,
      );
      _initializeControllerFuture = _controller!.initialize().then((_) {
        notifyListeners();
      });
    } else {
      _isUnsupported = true;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}
