import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/task.dart';

class TaskService {
  final CollectionReference<Map<String, dynamic>> tasksRef = FirebaseFirestore
      .instance
      .collection('tasks');

  Future<void> addTask(String title) async {
    final trimmed = title.trim();
    if (trimmed.isEmpty) return;

    final task = Task(id: '', title: trimmed, createdAt: DateTime.now());

    await tasksRef.add(task.toMap());
  }

  Stream<List<Task>> streamTasks() {
    return tasksRef
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => Task.fromMap(doc.id, doc.data()))
              .toList(),
        );
  }

  Future<void> updateTask(Task task) async {
    await tasksRef.doc(task.id).update(task.toMap());
  }

  Future<void> deleteTask(String taskId) async {
    await tasksRef.doc(taskId).delete();
  }

  Future<void> toggleTask(Task task) async {
    await tasksRef.doc(task.id).update({'isCompleted': !task.isCompleted});
  }

  Future<void> addSubtask(Task task, String subtaskTitle) async {
    final trimmed = subtaskTitle.trim();
    if (trimmed.isEmpty) return;

    final updatedSubtasks = List<Map<String, dynamic>>.from(task.subtasks)
      ..add({'title': trimmed, 'isCompleted': false});

    await tasksRef.doc(task.id).update({'subtasks': updatedSubtasks});
  }

  Future<void> toggleSubtask(Task task, int index) async {
    final updatedSubtasks = List<Map<String, dynamic>>.from(task.subtasks);

    if (index < 0 || index >= updatedSubtasks.length) return;

    final current = Map<String, dynamic>.from(updatedSubtasks[index]);
    current['isCompleted'] = !(current['isCompleted'] ?? false);
    updatedSubtasks[index] = current;

    await tasksRef.doc(task.id).update({'subtasks': updatedSubtasks});
  }

  Future<void> deleteSubtask(Task task, int index) async {
    final updatedSubtasks = List<Map<String, dynamic>>.from(task.subtasks);

    if (index < 0 || index >= updatedSubtasks.length) return;

    updatedSubtasks.removeAt(index);

    await tasksRef.doc(task.id).update({'subtasks': updatedSubtasks});
  }
}
