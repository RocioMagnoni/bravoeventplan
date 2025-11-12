import 'package:equatable/equatable.dart';
import '../../data/model/task.dart';

abstract class ChecklistState extends Equatable {
  const ChecklistState();

  @override
  List<Object> get props => [];
}

class ChecklistInitial extends ChecklistState {}

class ChecklistLoading extends ChecklistState {}

class ChecklistLoaded extends ChecklistState {
  final List<Task> tasks;

  const ChecklistLoaded([this.tasks = const []]);

  @override
  List<Object> get props => [tasks];
}

class ChecklistError extends ChecklistState {
  final String message;

  const ChecklistError(this.message);

  @override
  List<Object> get props => [message];
}
