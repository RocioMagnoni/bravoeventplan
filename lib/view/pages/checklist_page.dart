import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodel/checklist_viewmodel.dart';

class CheckListPage extends StatelessWidget {
  const CheckListPage({super.key});

  @override
  Widget build(BuildContext context) {
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

  @override
  Widget build(BuildContext context) {
    final azul = const Color(0xFF1E3A5F);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        title: const Text(
          'Checklist',
          style: TextStyle(color: Colors.black),
        ),
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              )
            : null,
      ),
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
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: azul),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: azul, width: 2),
                        ),
                        filled: true,
                        fillColor: azul.withOpacity(0.2),
                      ),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      if (_taskController.text.isNotEmpty) {
                        context.read<ChecklistViewModel>().addTask(_taskController.text);
                        _taskController.clear();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: azul,
                      foregroundColor: Colors.white,
                      padding:
                          const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                    ),
                    child: const Text('Agregar'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Consumer<ChecklistViewModel>(
                  builder: (context, viewModel, child) {
                    return ListView.builder(
                      itemCount: viewModel.tasks.length,
                      itemBuilder: (context, index) {
                        final task = viewModel.tasks[index];
                        return Card(
                          color: task.isDone ? Colors.grey[600] : Colors.yellow,
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
                                  onChanged: (val) =>
                                      context.read<ChecklistViewModel>().toggleTaskStatus(index),
                                  activeColor: azul,
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.black),
                                  onPressed: () =>
                                      context.read<ChecklistViewModel>().removeTask(index),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
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
