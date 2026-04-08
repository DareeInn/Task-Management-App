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
        subtitle: Text(
          '${task.subtasks.length} subtasks',
          style: const TextStyle(color: Colors.grey),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline),
          onPressed: () async {
            final confirm = await showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Delete Task'),
                content: const Text(
                  'Are you sure you want to delete this task?',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text('Delete'),
                  ),
                ],
              ),
            );
            if (confirm == true) {
              taskService.deleteTask(task.id);
            }
          },
        ),
        children: [SubtaskSection(task: task, taskService: taskService)],
      ),
    );
  }
}
