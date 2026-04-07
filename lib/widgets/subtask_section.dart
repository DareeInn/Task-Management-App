import 'package:flutter/material.dart';

import '../models/task.dart';
import '../services/task_service.dart';

class SubtaskSection extends StatefulWidget {
  final Task task;
  final TaskService taskService;

  const SubtaskSection({
    super.key,
    required this.task,
    required this.taskService,
  });

  @override
  State<SubtaskSection> createState() => _SubtaskSectionState();
}

class _SubtaskSectionState extends State<SubtaskSection> {
  final TextEditingController _subtaskController = TextEditingController();

  @override
  void dispose() {
    _subtaskController.dispose();
    super.dispose();
  }

  Future<void> _addSubtask() async {
    final title = _subtaskController.text.trim();

    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a subtask title.')),
      );
      return;
    }

    await widget.taskService.addSubtask(widget.task, title);
    _subtaskController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final subtasks = widget.task.subtasks;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _subtaskController,
                  decoration: const InputDecoration(
                    hintText: 'Add a subtask...',
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                  onSubmitted: (_) => _addSubtask(),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(onPressed: _addSubtask, child: const Text('Add')),
            ],
          ),
          const SizedBox(height: 8),
          if (subtasks.isEmpty)
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'No subtasks yet.',
                style: TextStyle(color: Colors.grey),
              ),
            )
          else
            Column(
              children: List.generate(subtasks.length, (index) {
                final subtask = subtasks[index];
                final title = subtask['title']?.toString() ?? '';
                final isCompleted = subtask['isCompleted'] ?? false;

                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Checkbox(
                    value: isCompleted,
                    onChanged: (_) =>
                        widget.taskService.toggleSubtask(widget.task, index),
                  ),
                  title: Text(
                    title,
                    style: TextStyle(
                      decoration: isCompleted
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline, size: 20),
                    onPressed: () =>
                        widget.taskService.deleteSubtask(widget.task, index),
                  ),
                );
              }),
            ),
        ],
      ),
    );
  }
}
