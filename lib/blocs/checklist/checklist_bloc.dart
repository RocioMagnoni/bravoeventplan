import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/model/task.dart';
import '../../data/repositories/checklist_repository.dart';
import 'checklist_event.dart';
import 'checklist_state.dart';

class ChecklistBloc extends Bloc<ChecklistEvent, ChecklistState> {
  final ChecklistRepository _repository;

  ChecklistBloc(this._repository) : super(ChecklistInitial()) {
    on<LoadTasks>(_onLoadTasks);
    on<AddTask>(_onAddTask);
    on<UpdateTask>(_onUpdateTask);
    on<DeleteTask>(_onDeleteTask);
  }

  void _onLoadTasks(LoadTasks event, Emitter<ChecklistState> emit) async {
    emit(ChecklistLoading());
    try {
      await emit.forEach(
        _repository.getTasks(),
        onData: (tasks) => ChecklistLoaded(tasks),
        onError: (error, stackTrace) => ChecklistError(error.toString()),
      );
    } catch (e) {
      emit(ChecklistError(e.toString()));
    }
  }

  void _onAddTask(AddTask event, Emitter<ChecklistState> emit) async {
    try {
      await _repository.addTask(event.task);
      // The stream in _onLoadTasks will handle emitting the new state
    } catch (e) {
      emit(ChecklistError(e.toString()));
    }
  }

  void _onUpdateTask(UpdateTask event, Emitter<ChecklistState> emit) async {
    try {
      await _repository.updateTask(event.task);
    } catch (e) {
      emit(ChecklistError(e.toString()));
    }
  }

  void _onDeleteTask(DeleteTask event, Emitter<ChecklistState> emit) async {
    try {
      await _repository.deleteTask(event.taskId);
    } catch (e) {
      emit(ChecklistError(e.toString()));
    }
  }
}
