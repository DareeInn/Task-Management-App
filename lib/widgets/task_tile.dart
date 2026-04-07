import 'package:flutter/material.dart';

import '../models/task.dart';
import '../services/task_service.dart';
import 'subtask_section.dart';

class TaskTile extends StatelessWidget {
  final Task task;
  final TaskService taskService;

  const TaskTile({super.key, required this.task, required this.taskService});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ExpansionTile(
        leading: Checkbox(
          value: task.isCompleted,
          onChanged: (_) => taskService.toggleTask(task),
        ),
        title: Text(
          task.title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            decoration: task.isCompleted ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Text('${task.subtasks.length} subtasks'),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline),
          onPressed: () => taskService.deleteTask(task.id),
        ),
        children: [SubtaskSection(task: task, taskService: taskService)],
      ),
    );
  }
}
