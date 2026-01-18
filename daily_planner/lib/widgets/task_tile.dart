import 'package:flutter/material.dart';
import '../models/Task.dart';

class TaskTile extends StatelessWidget {
  const TaskTile({
    super.key,
    required this.index,
    required this.task,
    required this.onChanged,
    required this.onDelete,
  });

  final int index;
  final Task task;
  final ValueChanged<bool?> onChanged;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final isEven = index % 2 == 0;
    final bgColor = isEven
        ? const Color.fromARGB(255, 176, 224, 246)
        : const Color.fromARGB(255, 125, 207, 244);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Dismissible(
        key: ValueKey(task.title + index.toString()),
        direction: DismissDirection.endToStart,
        background: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            color: Colors.redAccent,
            child: const Icon(Icons.delete, color: Colors.white),
          ),
        ),
        onDismissed: (_) => onDelete(),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Container(
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // Circle with incrementing numbers
                Container(
                  width: 36,
                  height: 36,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blueAccent,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Task title + subtitle
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          decoration: task.isDone
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        task.isDone ? 'Completed' : 'Not Done Yet',
                        style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                      ),
                    ],
                  ),
                ),
                // Checkbox
                Checkbox(value: task.isDone, onChanged: onChanged),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
