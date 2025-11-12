import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/task.dart';

class ChecklistRepository {
  final CollectionReference _taskCollection = FirebaseFirestore.instance.collection('tasks');

  Stream<List<Task>> getTasks() {
    return _taskCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Task.fromSnapshot(doc)).toList();
    });
  }

  Future<void> addTask(Task task) {
    return _taskCollection.add(task.toJson());
  }

  Future<void> updateTask(Task task) {
    return _taskCollection.doc(task.id).update(task.toJson());
  }

  Future<void> deleteTask(String taskId) {
    return _taskCollection.doc(taskId).delete();
  }
}
