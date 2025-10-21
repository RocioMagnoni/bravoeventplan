import 'package:flutter/material.dart';

class CheckListPage extends StatefulWidget {
  @override
  _CheckListPageState createState() => _CheckListPageState();
}

class _CheckListPageState extends State<CheckListPage> {
  final TextEditingController _taskController = TextEditingController();
  final List<Map<String, dynamic>> _tasks = [];

  void _addTask() {
    if (_taskController.text.isEmpty) return;
    setState(() {
      _tasks.add({'task': _taskController.text, 'done': false});
      _taskController.clear();
    });
  }

  void _toggleDone(int index, bool value) {
    setState(() => _tasks[index]['done'] = value);
  }

  void _removeTask(int index) {
    setState(() => _tasks.removeAt(index));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        title: Text(
          'Checklist',
          style: TextStyle(color: Colors.black),
        ),
        leading: Navigator.canPop(context)
            ? IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        )
            : null,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _taskController,
                      decoration: InputDecoration(
                        labelText: 'Nueva tarea',
                        labelStyle: TextStyle(color: Colors.yellow),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.yellow),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.yellow, width: 2),
                        ),
                      ),
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: _addTask,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.yellow,
                      foregroundColor: Colors.black,
                    ),
                    child: Text('Agregar'),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: _tasks.length,
                  itemBuilder: (context, index) {
                    final task = _tasks[index];
                    return Card(
                      color: task['done'] ? Colors.grey[600] : Colors.yellow,
                      margin: EdgeInsets.symmetric(vertical: 5),
                      child: ListTile(
                        title: Text(
                          task['task'],
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Switch(
                              value: task['done'],
                              onChanged: (val) => _toggleDone(index, val),
                              activeColor: Color(0xFF1E3A5F),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.black),
                              onPressed: () => _removeTask(index),
                            ),
                          ],
                        ),
                      ),
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
