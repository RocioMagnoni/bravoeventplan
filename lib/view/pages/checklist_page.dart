import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/checklist/checklist_bloc.dart';
import '../../blocs/checklist/checklist_event.dart';
import '../../blocs/checklist/checklist_state.dart';
import '../../data/model/task.dart';
import '../widgets/main_drawer.dart';

class CheckListPage extends StatelessWidget {
  const CheckListPage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<ChecklistBloc>().add(LoadTasks());
    return const _CheckListPageView();
  }
}

class _CheckListPageView extends StatefulWidget {
  const _CheckListPageView();

  @override
  State<_CheckListPageView> createState() => _CheckListPageViewState();
}

class _CheckListPageViewState extends State<_CheckListPageView> {
  final _taskController = TextEditingController();

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }

  void _addTask() {
    if (_taskController.text.isNotEmpty) {
      final newTask = Task(title: _taskController.text);
      context.read<ChecklistBloc>().add(AddTask(newTask));
      _taskController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final azul = const Color(0xFF1E3A5F);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        centerTitle: true,
        title: const Text('Checklist', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      drawer: const MainDrawer(currentPage: AppPage.checklist), // ⬅️ CORRECTED THIS
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _taskController,
                      decoration: InputDecoration(
                        labelText: 'Nueva tarea',
                        labelStyle: TextStyle(color: azul),
                        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: azul)),
                        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: azul, width: 2)),
                        filled: true,
                        fillColor: azul.withOpacity(0.2),
                      ),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: _addTask,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: azul,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                    ),
                    child: const Text('Agregar'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: BlocBuilder<ChecklistBloc, ChecklistState>(
                  builder: (context, state) {
                    if (state is ChecklistLoading || state is ChecklistInitial) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is ChecklistLoaded) {
                      if (state.tasks.isEmpty) {
                        return const Center(child: Text('No hay tareas, ¡añade una!', style: TextStyle(color: Colors.yellow)));
                      }
                      return ListView.builder(
                        itemCount: state.tasks.length,
                        itemBuilder: (context, index) {
                          final task = state.tasks[index];
                          return Card(
                            color: task.isDone ? Colors.grey[700] : Colors.yellow,
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            child: ListTile(
                              title: Text(
                                task.title,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Switch(
                                    value: task.isDone,
                                    onChanged: (val) {
                                      final updatedTask = task.copyWith(isDone: val);
                                      context.read<ChecklistBloc>().add(UpdateTask(updatedTask));
                                    },
                                    activeColor: azul,
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.black),
                                    onPressed: () => context.read<ChecklistBloc>().add(DeleteTask(task.id!)),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    } else if (state is ChecklistError) {
                      return Center(child: Text(state.message, style: const TextStyle(color: Colors.red)));
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
