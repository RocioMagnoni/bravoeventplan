import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/checklist_repository.dart';
import 'checklist_event.dart';
import 'checklist_state.dart';

class ChecklistBloc extends Bloc<ChecklistEvent, ChecklistState> {
  final ChecklistRepository _repository;
  StreamSubscription? _tasksSubscription;

  ChecklistBloc(this._repository) : super(ChecklistInitial()) {
    on<LoadTasks>(_onLoadTasks);
    on<AddTask>(_onAddTask);
    on<UpdateTask>(_onUpdateTask);
    on<DeleteTask>(_onDeleteTask);
  }

  Future<void> _onLoadTasks(LoadTasks event, Emitter<ChecklistState> emit) async {
    emit(ChecklistLoading());
    await _tasksSubscription?.cancel();
    try {
      await emit.forEach(
        _repository.getTasks(), 
        onData: (tasks) => ChecklistLoaded(tasks),
        onError: (error, _) => ChecklistError(error.toString()),
      );
    } catch (e) {
      emit(ChecklistError(e.toString()));
    }
  }

  Future<void> _onAddTask(AddTask event, Emitter<ChecklistState> emit) async {
    try {
      await _repository.addTask(event.task);
    } catch (e) {
      // The stream will handle emitting error states if something goes wrong 
      // at the repository level, but we can catch specific add errors here.
      print("Error adding task: $e");
    }
  }

  Future<void> _onUpdateTask(UpdateTask event, Emitter<ChecklistState> emit) async {
    try {
      await _repository.updateTask(event.task);
    } catch (e) {
      print("Error updating task: $e");
    }
  }

  Future<void> _onDeleteTask(DeleteTask event, Emitter<ChecklistState> emit) async {
    try {
      await _repository.deleteTask(event.taskId);
    } catch (e) {
      print("Error deleting task: $e");
    }
  }

  @override
  Future<void> close() {
    _tasksSubscription?.cancel();
    return super.close();
  }
}
