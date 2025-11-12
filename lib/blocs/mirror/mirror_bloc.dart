import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:camera/camera.dart';
import '../../services/camera_service.dart';
import '../../services/capability_service.dart';
import 'mirror_event.dart';
import 'mirror_state.dart';

class MirrorBloc extends Bloc<MirrorEvent, MirrorState> {
  CameraController? _controller;

  MirrorBloc() : super(MirrorInitial()) {
    on<InitializeCamera>(_onInitializeCamera);
  }

  Future<void> _onInitializeCamera(InitializeCamera event, Emitter<MirrorState> emit) async {
    if (CapabilityService.isWebApp) {
      emit(const MirrorFailure("Cámara no disponible en esta plataforma."));
      return;
    }

    if (CameraService.cameras.length < 2) {
      emit(const MirrorFailure("No se encontró la cámara frontal."));
      return;
    }

    emit(MirrorLoading());

    try {
      _controller = CameraController(
        CameraService.cameras[1], // Front camera
        ResolutionPreset.medium,
        enableAudio: false,
      );

      await _controller!.initialize();
      emit(MirrorReady(_controller!));

    } catch (e) {
      emit(MirrorFailure("Error al inicializar la cámara: ${e.toString()}"));
    }
  }

  @override
  Future<void> close() {
    _controller?.dispose();
    return super.close();
  }
}
