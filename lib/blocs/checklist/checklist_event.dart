import 'package:equatable/equatable.dart';
import '../../data/model/task.dart';

abstract class ChecklistEvent extends Equatable {
  const ChecklistEvent();

  @override
  List<Object> get props => [];
}

class LoadTasks extends ChecklistEvent {}

class AddTask extends ChecklistEvent {
  final Task task;

  const AddTask(this.task);

  @override
  List<Object> get props => [task];
}

class UpdateTask extends ChecklistEvent {
  final Task task;

  const UpdateTask(this.task);

  @override
  List<Object> get props => [task];
}

class DeleteTask extends ChecklistEvent {
  final String taskId;

  const DeleteTask(this.taskId);

  @override
  List<Object> get props => [taskId];
}
