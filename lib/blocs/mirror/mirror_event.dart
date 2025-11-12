import 'package:equatable/equatable.dart';

abstract class MirrorEvent extends Equatable {
  const MirrorEvent();

  @override
  List<Object> get props => [];
}

class InitializeCamera extends MirrorEvent {}
