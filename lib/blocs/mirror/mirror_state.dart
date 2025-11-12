import 'package:camera/camera.dart';
import 'package:equatable/equatable.dart';

abstract class MirrorState extends Equatable {
  const MirrorState();

  @override
  List<Object?> get props => [];
}

class MirrorInitial extends MirrorState {}

class MirrorLoading extends MirrorState {}

class MirrorReady extends MirrorState {
  final CameraController controller;

  const MirrorReady(this.controller);

  @override
  List<Object?> get props => [controller];
}

class MirrorFailure extends MirrorState {
  final String error;

  const MirrorFailure(this.error);

  @override
  List<Object> get props => [error];
}
