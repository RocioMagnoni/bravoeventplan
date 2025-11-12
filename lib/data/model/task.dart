import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Task extends Equatable {
  final String? id;
  final String title;
  final bool isDone;

  const Task({this.id, required this.title, this.isDone = false});

  // Factory to create a Task from a Firestore snapshot
  factory Task.fromSnapshot(DocumentSnapshot snap) {
    final data = snap.data() as Map<String, dynamic>;
    return Task(
      id: snap.id,
      title: data['title'] ?? '',
      isDone: data['isDone'] ?? false,
    );
  }

  // Method to convert a Task object to a map for Firestore
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'isDone': isDone,
    };
  }

  // copyWith method to create a new instance with updated fields
  Task copyWith({
    String? id,
    String? title,
    bool? isDone,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      isDone: isDone ?? this.isDone,
    );
  }

  @override
  List<Object?> get props => [id, title, isDone];
}
